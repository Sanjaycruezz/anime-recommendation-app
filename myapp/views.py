import os
import json
import google.generativeai as genai
from django.conf import settings
from django.views.decorators.csrf import csrf_exempt

from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response

from .models import Anime
from .serializers import AnimeSerializer

# ✅ Setup Gemini API Key
GOOGLE_API_KEY = "GOOGLE_API_KEY"  # Replace with your actual key
genai.configure(api_key=GOOGLE_API_KEY)

# ✅ Select the first available model that supports generateContent
model = None
for m in genai.list_models():
    if 'generateContent' in m.supported_generation_methods:
        print(f"Using model: {m.name}")
        model = genai.GenerativeModel('gemini-1.5-flash')
        break

# ✅ Return anime data from JSON
@api_view(['GET'])
def view_anime(request):
    json_path = os.path.join(settings.BASE_DIR, 'static', 'anime_data.json')
    try:
        with open(json_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
        return Response({'anime': data})
    except Exception as e:
        return Response({'error': str(e)})

# ✅ Greet test endpoint
@csrf_exempt
def greet(request):
    return Response({'message': 'Hello from Django!'})

# ✅ Add anime entry and update JSON
@api_view(['POST'])
def add_anime(request):
    serializer = AnimeSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        try:
            all_anime = Anime.objects.all()
            all_data = AnimeSerializer(all_anime, many=True).data
            json_path = os.path.join(settings.BASE_DIR, 'myapp', 'static', 'anime_data.json')
            with open(json_path, 'w', encoding='utf-8') as f:
                json.dump(all_data, f, indent=2)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        except Exception as e:
            return Response({'error': f'DB saved, but failed to update JSON: {str(e)}'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

# ✅ Recommend new anime based on mood using Gemini
@api_view(['GET'])
def recommend_anime(request):
    mood = request.GET.get('mood', '')
    if not mood:
        return Response({"error": "Mood not provided"}, status=400)

    matching_anime = Anime.objects.filter(emotion_tag__iexact=mood)
    titles = [anime.anime for anime in matching_anime]

    if not titles:
        return Response({"recommendations": [], "message": "No anime found for this mood."}, status=200)

    prompt = (
        "Recommend anime similar to the below based on mood, in list form, marking the recommended titles with **:\n"
        + "\n".join(titles)
    )

    try:
        response = model.generate_content(prompt)
        # Updated Extraction: Detect Gemini titles marked with **
        lines = response.text.strip().split('\n')
        recommended = []
        for line in lines:
            if '**' in line:
                # Extract bolded anime name
                clean = line.replace('*', '').strip(' -')
                recommended.append(clean)

        # Remove duplicates & already present anime
        existing_titles = set(Anime.objects.values_list('anime', flat=True))
        new_anime = [title for title in recommended if title not in existing_titles]

        # Format as pointwise list
        formatted = [f"{idx + 1}. {title}" for idx, title in enumerate(new_anime)]
        return Response({'recommendations': formatted}, status=200)

    except Exception as e:
        return Response({'error': f"Gemini API failed: {str(e)}"}, status=500)
