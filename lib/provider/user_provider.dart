import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_user/model/user.dart';
import 'package:github_user/service/user_service.dart';

import '../database/sql_helper.dart'; // assuming SQLHelper class is in this file

class UserProvider extends ChangeNotifier{
  final _service = UserApi();
  bool isLoading = false;

  List<ItemsItem> _user = [];
  List<ItemsItem> get user => _user;

  Future<void> getUser(String username) async{
    isLoading = true;
    notifyListeners();

    final response = await _service.getUserByUsername(username);
    _user = response;

    isLoading = false;
    notifyListeners();
  }

  Future<int> createItem(int iduser, String username, String avatarurl) async {
    final db = await SQLHelper.db();
    final itemId = await SQLHelper.createItem(iduser, username, avatarurl);
    notifyListeners();
    return itemId;
  }

  Future<List<Map<String, dynamic>>> getItem() async {
    final db = await SQLHelper.db();
    return SQLHelper.getItem();
  }


  Future<bool> getItemById(int id) async {
    final db = await SQLHelper.db();
    final item = await SQLHelper.getItemById(id);
    return item != null;
  }

  Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    await SQLHelper.deleteItem(id);
    notifyListeners();
  }

}