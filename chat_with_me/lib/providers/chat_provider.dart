import 'package:chat_with_me/models/chat_models.dart';
import 'package:chat_with_me/services/api_service.dart';
import 'package:flutter/cupertino.dart';

class ChatProvider with ChangeNotifier {
  List<ChatModels> chatList = [];
  List<ChatModels> get getChatList {
    return chatList;
  }

  void addUserMassage({required String msg}) {
    chatList.add(ChatModels(msg: msg, chatIndex: 0));
    notifyListeners();
  }

  Future<void> sendMessageAndGetAnswers({
    required String msg,
    required String choosenModelId,
  }) async {
    chatList.addAll(await ApiService.sendMessage(
      message: msg,
      modelId: choosenModelId,
    ));
    notifyListeners();
  }
}
