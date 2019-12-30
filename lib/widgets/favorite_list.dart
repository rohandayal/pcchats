import 'package:flutter/material.dart';
import 'package:pcchatz/models/user_model.dart';
import 'package:pcchatz/screens/chat_screen.dart';
import 'package:theme_provider/theme_provider.dart';


class FavouriteList extends StatelessWidget {
  final List<User> users;
  FavouriteList({Key key, this.users}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.only(
          left: 10.0,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: users.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () => Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (_) => ThemeConsumer(child: ChatScreen(
                    user: users[index],
                  ))
                )
              ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 7.0,
                horizontal: 10.0,
              ),
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 35.0,
                    backgroundImage: NetworkImage(users[index].imageUrl),
                  ),
                  SizedBox(
                    height: 6.0,
                  ),
                  Text(
                    users[index].name,
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}