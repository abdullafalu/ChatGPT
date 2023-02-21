import 'package:chat_with_me/models/model_models.dart';
import 'package:chat_with_me/services/api_service.dart';
import 'package:flutter/cupertino.dart';

class ModelsProvider with ChangeNotifier{
  String currentModel="text-davinci-003";
  String get getCurrentModel{
    return currentModel;
  }
  void setCurrentModel(String newModel){
    currentModel=newModel;
    notifyListeners();
  }
  List<ModelModels> modelList=[];
  List<ModelModels>get getModelList{
    return modelList;
  }

Future<List<ModelModels>> getAllModel()async{
  modelList=await ApiService.getModels();
  return modelList;
}
}