import 'package:dio/dio.dart';

Dio dio = new Dio();
const baseUrl = 'https://m.dmzj.com/';

Future<Response> baseApi (url) async{
  Response response = await dio.get(baseUrl+url,options: Options(
    headers:{
      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.129 Safari/537.36'
    }
  ));
  return response;
}