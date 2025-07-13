from django.urls import path
from .views import add_anime
from . import views

urlpatterns = [
    path('api/greet/', views.greet),
    path('api/anime/', views.view_anime),
    path('api/add_anime/', views.add_anime),
    path('api/recommend_anime/', views.recommend_anime),
]




