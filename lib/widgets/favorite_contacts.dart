import 'package:flutter/material.dart';
import 'package:pcchatz/models/user_model.dart';
import 'package:pcchatz/widgets/favorite_list.dart';

class FavoriteContacts extends StatelessWidget {
  const FavoriteContacts({Key key}) : super(key: key);

  // Future<List<User>> _calculation = getUsers();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0,),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Favourite Contacts",
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.more_horiz,
                  ),
                  iconSize: 30.0,
                  color: Colors.blueGrey,
                  onPressed: () {},
                )
              ],
            ),
          ),
          Container(
            height: 120.0,
            child: FutureBuilder<List<User>>(
              future: getUsers(),
              builder: (BuildContext context, AsyncSnapshot<List<User>> users) {
                if(users.hasError) {
                  print(users.error);
                }
                return users.hasData ? FavouriteList(users: users.data) : Center(child: CircularProgressIndicator(),);
              }
            ),
          ),
        ],
      ),
    );
  }
}