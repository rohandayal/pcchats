import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pcchatz/screens/chat_screen.dart';
import 'package:theme_provider/theme_provider.dart';

class UsersScreen extends StatefulWidget {
  final dynamic user;
  UsersScreen({Key key, this.user}) : super(key: key);

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<Widget> getDisplay(dynamic user) {
    List<Widget> displayList = new List<Widget>();
    if(user.data.containsKey('imageURL') && user["imageURL"] != "") {
      displayList.add(
        CircleAvatar(
          backgroundImage: NetworkImage(user["imageURL"]),
        )
      );
    } else {
      displayList.add(
        CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(
            user['fname'].substring(0,2),
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 20.0,
            ),
          ),
        )
      );
    }
    displayList.add(
      SizedBox(
        height: 10.0,
      )
    );
    displayList.add(
      Text(
        user['fname'],
        style: TextStyle(
          color: Colors.blueGrey,
          fontSize: 22.0,
        ),
      )
    );
    return displayList;
  }
  
  List<Widget> getTiles(dynamic users) {
    List<Widget> returnList = new List<Widget>();
    for(var i=0; i<users.length; i++) {
      // if(users[i]['uid'] == widget.uid) {
      //   continue;
      // }
      returnList.add(
        new GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => ThemeConsumer(child: ChatScreen(contact: users[i], user: widget.user)),
              ));
            },
            child: Card(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: getDisplay(users[i])
                ),
              ),
            ),
          ),
        )
      );
    }
    return returnList;
  }
  
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ClipRRect(
          borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          child: StreamBuilder(
            stream: Firestore.instance.collection('users').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(),);
              }
              if(!snapshot.hasData) {
                return Center(
                  child: Text(
                    'No users :(',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24.0,
                    ),
                  ),
                );
              }
              var users = snapshot.data.documents;
              return GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                children: getTiles(users),
              );
            },
          )
        ),
      )
    );
  }
}