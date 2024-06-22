import 'package:flutter/material.dart';
import 'package:offline_first_example/src/service/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  String _getResponse = '';
  String _postResponse = '';

  Future<void> _performGetRequest() async {
    try {
      final response = await _apiService.getPost(2);
      setState(() {
        _getResponse = response.toString();
      });
    } catch (e) {
      setState(() {
        _getResponse = 'Error: $e';
      });
    }
  }

  Future<void> _performPostRequest() async {
    try {
      final response = await _apiService.createPost({
        'title': 'foo',
        'body': 'bar',
        'userId': 1,
      });
      setState(() {
        _postResponse = response.toString();
      });
    } catch (e) {
      setState(() {
        _postResponse = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exemplo Offline First'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _getResponse = '';
                _postResponse = '';
              });
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: _performGetRequest,
              child: const Text('Fazer o GET'),
            ),
            const SizedBox(height: 8),
            Text('GET Response: $_getResponse'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _performPostRequest,
              child: const Text('Fazer o POST'),
            ),
            const SizedBox(height: 8),
            Text('POST Response: $_postResponse'),
          ],
        ),
      ),
    );
  }
}
