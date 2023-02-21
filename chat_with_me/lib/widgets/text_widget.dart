import 'package:chat_with_me/core/constant.dart';
import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  const TextWidget({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        color: kWhiteColor,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
