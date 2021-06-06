import 'dart:convert';

import 'package:http/http.dart' as http;
import '../Model/newsInfo.dart';

class Strings {
  static String news_url =
      'http://newsapi.org/v2/everything?domains=wsj.com&apiKey=62dc27de23bf4aee8166440278122f69&language=en';
}

class API_Manager {
  Future<NewsModel> getNews() async {
    var client = http.Client();
    var newsModel;
    // Uri url = Uri.http("https://newsapi.org", "/v2/everything?domains=wsj.com",
    //     {"apiKey": "62dc27de23bf4aee8166440278122f69", "language": "en"});
    Uri url = Uri.parse("http://newsapi.org/v2/everything?domains=wsj.com&apiKey=62dc27de23bf4aee8166440278122f69&language=en");
    try {
      var response = await client.get(url);
      print("response.statusCode => ${response.statusCode}");
      if (response.statusCode == 200) {
        // print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ ${newsModel}");
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);
        // print("yyyyyyyyyyyyyy   ${jsonMap.runtimeType}");
        newsModel = NewsModel.fromJson(jsonMap);
        // print("Now +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ ${newsModel}");

      }
    } catch (Exception) {
      print("yaha hun me :(");
      return newsModel;
    }

    return newsModel;
  }
}
