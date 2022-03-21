import 'package:dio/dio.dart';

class HttpService {
  late Dio _dio;

  HttpService() {
    _dio = Dio(BaseOptions(
      baseUrl: "https://reqres.in/"
    ));
  }


  Future<Response> getRequest(String endPoint) async {
    Response response;
    try {
      response = await _dio.get(endPoint);
    } on DioError catch (e) {
      print("Caught Error: ${e.message}");
      throw Exception(e.message);
    }

    return response;
  }

  initializeInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (error, _) {
        print("DIO ERROR: ${error.message}");
      },
      onRequest: (request, _) {
        print("DIO REQUEST- method: ${request.method}, PATH: ${request.path}");
    },
      onResponse: (response, _) {
        print("DIO RESPONSE: ${response.data}");
      }
    ));
  }

}