import 'dart:convert';
import 'package:github_user/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:github_user/api_key.dart';

class UserApi{
  Future<List<ItemsItem>> getUserByUsername(String username) async{
    var uri = Uri.https('api.github.com', '/search/users',{
      "q" : username
    });

    final response = await http.get(uri, headers: {
      "Authorization" : "token $tmdbApiKey"
    });

    try{
      if(response.statusCode == 200){
        final json = jsonDecode(response.body);
        final userResponse = UserResponse.fromJson(json);
        return userResponse.items;
      }
    }catch(e){
      print(e);
    }
    return [];
  }
}