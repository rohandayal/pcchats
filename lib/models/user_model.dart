import 'dart:convert';
import 'dart:io';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String name;
  final String imageUrl;

  User({
    this.id,
    this.name,
    this.imageUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

List<User> users = [];
User currentUser = new User(id: '0', name: 'Me', imageUrl: null);

User findUserById(String userId) {
  if(userId == '0') return currentUser;
  for(var i=0; i<users.length; i++) {
    if(users[i].id==userId) {
      return users[i];
    }
  }
  return null;
}

Future<List<User>> getUsers() async {
  HttpClient http = HttpClient();
  if(users.length > 0) {
    return users;
  }
  try {
    var queryArguments = new Map<String, String>();
    queryArguments.putIfAbsent('results', () => '10');
    var uri = Uri.https('randomuser.me','/api/', queryArguments);
    var request = await http.getUrl(uri);
    var response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();
    var usermap = jsonDecode(responseBody);
    for(var i=0; i<usermap["results"].length; i++) {
      var thisuserjson = usermap["results"][i];
      users.add(User.fromJson(thisuserjson));
    }

  } catch (exception) {
    print(exception);
  }
  return users;
}