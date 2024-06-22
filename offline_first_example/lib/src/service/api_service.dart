import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;

  ApiService()
      : _dio =
            Dio(BaseOptions(baseUrl: 'https://jsonplaceholder.typicode.com')) {
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  Future<Map<String, dynamic>> getPost(int id) async {
    final response = await _dio.get('/posts/$id');
    return response.data;
  }

  Future<Map<String, dynamic>> createPost(Map<String, dynamic> data) async {
    final response = await _dio.post('/posts', data: data);
    return response.data;
  }
}
