import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../functions/parse_anime.dart';
import '../models/anime_model.dart';

class GetPage extends StatefulWidget {
  const GetPage({super.key});

  @override
  State<GetPage> createState() => _GetPageState();
}

class _GetPageState extends State<GetPage> {
  late Future<List<Anime>> _animeFuture;
  List<Anime> _fullList = [];
  List<Anime> _filteredList = [];
  final TextEditingController _searchController = TextEditingController();

  Future<List<Anime>> fetchAnimeJson() async {
    final response = await http.get(Uri.parse('http://192.168.1.34:8000/static/anime_data.json'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final parsedList = parse_anime(data);
      _fullList = parsedList;
      _filteredList = parsedList;
      return parsedList;
    } else {
      throw Exception("Failed to load anime data");
    }
  }

  @override
  void initState() {
    super.initState();
    _animeFuture = fetchAnimeJson();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredList = _fullList.where((anime) => anime.name.toLowerCase().contains(query)).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Otaku Rec')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Anime',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Anime>>(
              future: _animeFuture,
              builder: (BuildContext context, AsyncSnapshot<List<Anime>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (_filteredList.isEmpty) {
                  return const Center(child: Text('No matching anime found.'));
                } else {
                  return ListView.builder(
                    itemCount: _filteredList.length,
                    itemBuilder: (context, index) {
                      Anime anime = _filteredList[index];
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Text(anime.id),
                          title: Text(
                            anime.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(anime.type),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
