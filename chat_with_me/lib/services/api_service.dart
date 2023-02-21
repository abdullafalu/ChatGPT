import 'dart:convert';
import 'dart:io';
import 'dart:developer';

import 'package:chat_with_me/core/api_const.dart';
import 'package:chat_with_me/models/chat_models.dart';
import 'package:chat_with_me/models/model_models.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<ModelModels>> getModels() async {
    try {
      var response = await http.get(Uri.parse("$baseUrl/models"),
          headers: {'Authorization': 'Bearer $apiKey'});
      Map jsonResponse = jsonDecode(response.body);
      //print("jsonresponse $jsonResponse");

      if (jsonResponse['error'] != null) {
        print('jsonresponse["error"] ${jsonResponse["error"]["message"]}');
        throw HttpException(jsonResponse['error']['message']);
      }
      List temp = [];
      for (var value in jsonResponse['data']) {
        temp.add(value);
        // log("temp $value");
      }
      return ModelModels.modelsFromSnapshot(temp);
    } catch (e) {
      print("error$e");
      rethrow;
    }
  }

  //SEND MASSEGE
  static Future<List<ChatModels>> sendMessage({
    required String message,
    required String modelId,
  }) async {
    try {
      var response = await http.post(
        Uri.parse("$baseUrl/completions"),
        headers: {
          'Authorization': 'Bearer $apiKey',
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "model": modelId,
          "prompt": message,
          "max_tokens": 100,
        }),
      );
      Map jsonResponse = jsonDecode(response.body);
      //print("jsonresponse $jsonResponse");

      if (jsonResponse['error'] != null) {
        print('jsonresponse["error"] ${jsonResponse["error"]["message"]}');
        throw HttpException(jsonResponse['error']['message']);
      }
      List<ChatModels> chatList = [];
      if (jsonResponse["choices"].length > 0) {
        // print("jsonresponse[choice] ${jsonResponse['choices'][0]['text']}");
        chatList = List.generate(
          jsonResponse['choices'].length,
          (index) => ChatModels(
            msg: jsonResponse["choices"][index]['text'],
            chatIndex: 1,
          ),
        );
      }
      return chatList;
    } catch (e) {
      print("error$e");
      rethrow;
    }
  }
}
