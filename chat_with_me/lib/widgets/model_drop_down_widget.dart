import 'package:chat_with_me/core/constant.dart';
import 'package:chat_with_me/models/model_models.dart';
import 'package:chat_with_me/providers/models_provider.dart';
import 'package:chat_with_me/services/api_service.dart';
import 'package:chat_with_me/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModelDropDownWidget extends StatefulWidget {
  const ModelDropDownWidget({super.key});

  @override
  State<ModelDropDownWidget> createState() => _ModelDropDownWidgetState();
}

class _ModelDropDownWidgetState extends State<ModelDropDownWidget> {
  String? currentModel ;
  @override
  Widget build(BuildContext context) {
    final modelProvider=Provider.of<ModelsProvider>(context,listen: false);
    currentModel=modelProvider.getCurrentModel;  
    return FutureBuilder<List<ModelModels>>(
        future: modelProvider.getAllModel(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: TextWidget(title: snapshot.error.toString()),
            );
          }
          return snapshot.data == null || snapshot.data!.isEmpty
              ? const SizedBox.shrink()
              : FittedBox(
                child: DropdownButton(
                    dropdownColor: backgroundColor,
                    iconEnabledColor: kWhiteColor,
                    items: List<DropdownMenuItem<String>>.generate(
                      snapshot.data!.length,
                      (index) => DropdownMenuItem(
                        value: snapshot.data![index].id,
                        child: Text(
                          snapshot.data![index].id,
                          style:
                              const TextStyle(fontSize: 16, color: kWhiteColor),
                        ),
                      ),
                    ),
                    value: currentModel,
                    onChanged: (value) {
                      setState(() {
                        currentModel = value.toString();
                      });
                      modelProvider.setCurrentModel(value.toString());
                    },
                  ),
              );
        });
  }
}
