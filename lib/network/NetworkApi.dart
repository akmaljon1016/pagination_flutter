import '../model/News.dart';
import 'package:dio/dio.dart';

class NetworkApi {
  Dio dio = Dio();

  Future<List<Articles>?> getNews(int pageKey) async {
    var response = await dio.get(
        "https://newsapi.org/v2/everything?q=apple&apiKey=7eecb185f40340cd9e7bac121ca19380&page=${pageKey}&pageSize=10");
    if (response.statusCode == 200) {
      return News.fromJson(response.data).articles;
    }
  }
}
