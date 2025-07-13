import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController genreController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController emotionController = TextEditingController();

  bool isSubmitting = false;
  String message = '';

  Future<void> submitAnime() async {
    setState(() {
      isSubmitting = true;
      message = '';
    });

    final url = Uri.parse('http://192.168.1.34:8000/api/add_anime/'); // Django endpoint

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
        body: json.encode({
        'anime': nameController.text.trim(),          // ✅ not 'name', should be 'anime'
        'genere': genreController.text.trim(),
        'rate': int.tryParse(rateController.text.trim()) ?? 0,
        'emotion_tag': emotionController.text.trim(),
        }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      setState(() {
        message = 'Anime added successfully!';
        isSubmitting = false;
      });
      nameController.clear();
      genreController.clear();
      rateController.clear();
      emotionController.clear();
    } else {
      setState(() {
        message = 'Failed to add anime. Error: ${response.body}';
        isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Anime')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Anime Name'),
                validator: (value) => value!.isEmpty ? 'Enter a name' : null,
              ),
              TextFormField(
                controller: genreController,
                decoration: const InputDecoration(labelText: 'Genre (2 letters)'),
                maxLength: 2,
                validator: (value) => value!.length != 2 ? 'Must be 2 characters' : null,
              ),
              TextFormField(
                controller: rateController,
                decoration: const InputDecoration(labelText: 'Rating (0-10)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final val = int.tryParse(value ?? '');
                  if (val == null || val < 0 || val > 10) return 'Enter a valid rating';
                  return null;
                },
              ),
              TextFormField(
                controller: emotionController,
                decoration: const InputDecoration(labelText: 'Emotion Tag'),
                validator: (value) => value!.isEmpty ? 'Enter emotion' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isSubmitting
                    ? null
                    : () {
                  if (_formKey.currentState!.validate()) {
                    submitAnime();
                  }
                },
                child: const Text('Submit'),
              ),
              const SizedBox(height: 10),
              if (message.isNotEmpty)
                Text(
                  message,
                  style: TextStyle(
                      color: message.contains('successfully') ? Colors.green : Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
