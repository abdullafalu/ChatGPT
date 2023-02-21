import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_with_me/services/asset_manager.dart';
import 'package:chat_with_me/widgets/text_widget.dart';
import 'package:flutter/material.dart';

import '../core/constant.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({super.key, required this.msg, required this.chatIndex});
  final String msg;
  final int chatIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: chatIndex == 0 ? backgroundColor : cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  chatIndex == 0 ? AssetManager.person : AssetManager.chatLogo,
                  width: 30,
                  height: 30,
                ),
                kWidth10,
                 Expanded(
                        child:chatIndex == 0? TextWidget(
                        title: msg,
                      ): DefaultTextStyle(
                        style:const TextStyle(
                          color: kWhiteColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                        child: AnimatedTextKit(
                          isRepeatingAnimation : false,
                          repeatForever: false,
                          displayFullTextOnTap: true,
                          totalRepeatCount: 1,
                          animatedTexts: [
                          TyperAnimatedText(msg.trim()),
                        ]),
                      )),
                chatIndex == 0
                    ? const SizedBox.shrink()
                    : Row(
                        children: const [
                          Icon(
                            Icons.thumb_up_alt_outlined,
                            color: kWhiteColor,
                          ),
                          kWidth5,
                          Icon(
                            Icons.thumb_down_alt_outlined,
                            color: kWhiteColor,
                          )
                        ],
                      )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
