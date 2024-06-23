import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:offline_first_example/src/db/database_helper.dart';

bool isSyncing = false;

class CacheInterceptor extends Interceptor {
  final Dio dio;

  CacheInterceptor({required this.dio});

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      await syncFailedRequests();
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.type == DioExceptionType.connectionError) {
      await handleFailedPostRequest(err.requestOptions);
    }
    return handler.next(err);
  }

  Future<void> syncFailedRequests() async {
    if (isSyncing) return;
    isSyncing = true;
    final failedRequests = await DatabaseHelper.instance.getAllCachedData();

    for (var request in failedRequests) {
      try {
        await dio.request(
          request['url'],
          data: jsonDecode(request['data']),
          options: Options(
            method: request['method'],
          ),
        );
        await DatabaseHelper.instance.deleteCachedData(request['id']);
      } catch (e) {
        log('Erro ao sincronizar dados do cache: $e');
      }
    }

    isSyncing = false;
  }

  Future<void> handleFailedPostRequest(RequestOptions requestOptions) async {
    if (requestOptions.method == 'POST') {
      final cache = {
        'url': requestOptions.path,
        'method': requestOptions.method,
        'data': jsonEncode(requestOptions.data),
      };
      await DatabaseHelper.instance.insert(cache);
    }
  }
}
