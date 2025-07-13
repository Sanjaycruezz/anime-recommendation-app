import 'package:flutter/material.dart';
import 'recommendation_page.dart';

class MoodInputPage extends StatefulWidget {
  const MoodInputPage({super.key});

  @override
  State<MoodInputPage> createState() => _MoodInputPageState();
}

class _MoodInputPageState extends State<MoodInputPage> {
  final TextEditingController _moodController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Your Mood')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _moodController,
              decoration: const InputDecoration(labelText: 'Mood (e.g., sad, excited, lonely)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final mood = _moodController.text.trim();
                if (mood.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecommendationPage(mood: mood),
                    ),
                  );
                }
              },
              child: const Text('Get Recommendations'),
            ),
          ],
        ),
      ),
    );
  }
}
