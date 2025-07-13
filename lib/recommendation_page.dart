import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecommendationPage extends StatefulWidget {
  final String mood;

  const RecommendationPage({super.key, required this.mood});

  @override
  State<RecommendationPage> createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
  List<String> recommendedAnime = [];
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    fetchRecommendations();
  }

  Future<void> fetchRecommendations() async {
    final url = Uri.parse('http://192.168.1.34:8000/api/recommend_anime/?mood=${widget.mood}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          recommendedAnime = List<String>.from(data['recommendations']);
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Error: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Failed: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recommended Anime')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
          ? Center(child: Text(error))
          : ListView.builder(
        itemCount: recommendedAnime.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(recommendedAnime[index]),
            leading: const Icon(Icons.star),
          );
        },
      ),
    );
  }
}
