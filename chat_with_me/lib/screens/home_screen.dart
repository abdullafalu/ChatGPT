import 'dart:developer';

import 'package:chat_with_me/core/constant.dart';
import 'package:chat_with_me/providers/chat_provider.dart';
import 'package:chat_with_me/providers/models_provider.dart';
import 'package:chat_with_me/services/asset_manager.dart';
import 'package:chat_with_me/widgets/chat_widget.dart';
import 'package:chat_with_me/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../services/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isTyping = false;
  late TextEditingController textEditingController;
  late FocusNode focusNode;
  late ScrollController _listScrollController;

  @override
  void initState() {
    _listScrollController = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  // List<ChatModels> chatList=[];

  @override
  Widget build(BuildContext context) {
    final modelProvider = Provider.of<ModelsProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlackColor,
        title: Row(
          children: [
            Image.asset(
              AssetManager.botLogo,
              width: 40,
            ),
            const Text("   ChatGPT")
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () async {
              await Services.showModalSheet(context);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                  controller: _listScrollController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: chatProvider.getChatList.length, //chatList.length,
                  itemBuilder: (context, index) {
                    return ChatWidget(
                      chatIndex: chatProvider.getChatList[index]
                          .chatIndex, //chatList[index].chatIndex,
                      msg: chatProvider
                          .getChatList[index].msg, //chatList[index].msg,
                    );
                  }),
            ),
            if (_isTyping) ...[
              const SpinKitThreeBounce(
                color: kWhiteColor,
                size: 18,
              ),
            ],
            kHeight10,
            Material(
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          focusNode: focusNode,
                          onSubmitted: (value) {
                            sendMessageFCT(
                                modelProvider: modelProvider,
                                chatProvider: chatProvider);
                          },
                          controller: textEditingController,
                          style: const TextStyle(
                            color: kWhiteColor,
                          ),
                          decoration: const InputDecoration.collapsed(
                            hintText: "How can i help you?",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: kWhiteColor,
                      ),
                      onPressed: () async {
                        await sendMessageFCT(
                            modelProvider: modelProvider,
                            chatProvider: chatProvider);
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void scrollListToEnd() {
    _listScrollController.animateTo(
      _listScrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.easeOut,
    );
  }

  Future<void> sendMessageFCT(
      {required ModelsProvider modelProvider,
      required ChatProvider chatProvider}) async {
    try {
      String msg = textEditingController.text;
      if (_isTyping) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                TextWidget(title: "You cant send multiple masseges at a time"),
            backgroundColor: kRedColor,
          ),
        );
      }
      if (textEditingController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Text field cannot be empty"),
            backgroundColor: kRedColor,
          ),
        );
      }
      setState(() {
        _isTyping = true;
        // chatList.add(ChatModels(msg: textEditingController.text, chatIndex: 0));
        chatProvider.addUserMassage(msg: msg);
        textEditingController.clear();
        focusNode.unfocus();
      });
      await chatProvider.sendMessageAndGetAnswers(
        msg: msg,
        choosenModelId: modelProvider.getCurrentModel,
      );
      // chatList.addAll(await ApiService.sendMessage(
      //   message: textEditingController.text,
      //   modelId: modelProvider.getCurrentModel,
      // ));
      setState(() {});
    } catch (e) {
      log('error $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: TextWidget(
            title: e.toString(),
          ),
          backgroundColor: kRedColor,
        ),
      );
    } finally {
      setState(() {
        scrollListToEnd();
        _isTyping = false;
      });
    }
  }
}
