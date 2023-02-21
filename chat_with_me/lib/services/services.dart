import 'package:flutter/material.dart';

import '../core/constant.dart';
import '../widgets/model_drop_down_widget.dart';

class Services {
  ///SHOW MODEL BOTTOM SHEET
  static Future<void> showModalSheet(BuildContext context) async {
    return await showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        backgroundColor: cardColor,
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Flexible(
                  child: Text(
                    "Choosen model :",
                    style: TextStyle(fontSize: 16, color: kWhiteColor),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: ModelDropDownWidget(),
                ),
              ],
            ),
          );
        });
  }
}
