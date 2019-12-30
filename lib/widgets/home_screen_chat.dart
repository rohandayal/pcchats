import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pcchatz/screens/chat_screen.dart';
import 'package:theme_provider/theme_provider.dart';


class HomeScreenChat extends StatefulWidget {
  final dynamic messages;
  final dynamic user;
  HomeScreenChat({Key key, this.messages, this.user}) : super(key: key);

  @override
  _HomeScreenChatState createState() => _HomeScreenChatState();
}

class _HomeScreenChatState extends State<HomeScreenChat> {
  dynamic contacts; 
  var _chats = new Map();
  var tempchats = new List<dynamic>();
  var chats = new List<dynamic>();
  dynamic fetchContacts;
  final formatter = new DateFormat('MMM d, h:mm a');

  void setupPage(dynamic result) {
    setState(() {
      contacts = result.documents;
      chats = tempchats;
    });
  }

  @override
  void initState() { 
    Set<String> userset = {};
    for(var i=0; i<widget.messages.length; i++) {
      var thismessage = widget.messages[i]; 
      userset.add(thismessage['sender']);
      if(_chats.containsKey(thismessage['sender'])) {
        if(_chats[thismessage['sender']]["time"].millisecondsSinceEpoch < thismessage["time"].millisecondsSinceEpoch) {
          _chats[thismessage['sender']]["text"] = thismessage["text"];
          _chats[thismessage['sender']]["time"] = thismessage["time"];
        }
        if(widget.messages[i]["unread"]) {
          _chats[thismessage['sender']]["unreadcount"] += 1;
        }
      } else {
        _chats[thismessage['sender']] = {
          "text": thismessage["text"],
          "time": thismessage["time"],
          "unreadcount": thismessage["unread"] ? 1 : 0,
          "sender": thismessage["sender"],
        };
      }
    }
    if(userset.length > 0) {
      fetchContacts = Firestore.instance.collection('users').where(
        'uid',
        whereIn: userset.toList()
      ).snapshots().listen((result) => {
        setupPage(result)
      });
    }
    _chats.forEach((k,v) => tempchats.add(v));
    super.initState();
  }

  dynamic getContact(String uid) {
    for(var i=0; i<contacts.length; i++) {
      if(contacts[i]['uid'] == uid) {
        return contacts[i];
      }
    }
    return null;
  }

  // dynamic goToChatScreen(context, thiscontact,sender) {
  //   for(var i=0; i<chats.length; i++) {
  //     if(chats[i]["sender"] == sender) {
  //       chats[i]["unreadcount"] = 0;
  //     }
  //   }
  //   Navigator.push(
  //     context, 
  //     MaterialPageRoute(
  //       builder: (_) => ChatScreen(
  //         contact: thiscontact,
  //         user: widget.user,
  //       )
  //     )
  //   );    
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: ListView.builder(
          itemCount: chats.length,
          itemBuilder: (BuildContext context, int index) {
            var chat = chats[index];
            var thiscontact = getContact(chat['sender']);
            if(chat == null || thiscontact == null) {
              return CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
              );
            }
            return GestureDetector(
              // onTap: goToChatScreen(context, thiscontact, chat['sender']),
              onTap: () => Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (_) => ThemeConsumer(child: ChatScreen(
                    contact: thiscontact,
                    user: widget.user,
                  ))
                )
              ),
              child: Container(
                margin: EdgeInsets.only(
                  top: 5.0,
                  bottom: 5.0,
                  right: 20.0,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                decoration: BoxDecoration(
                  color: chat["unreadcount"] > 0 ? Colors.red[50] : Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          thiscontact["imageURL"] == "" ? 
                          CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Text(
                              thiscontact['fname'].substring(0,2),
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 20.0,
                              ),
                            ),
                          )
                          : CircleAvatar(
                            radius: 35.0,
                            backgroundImage: NetworkImage(thiscontact["imageURL"]),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  thiscontact['fname'],
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.0, 
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.45,
                                  child: Text(
                                    chat["text"],
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          formatter.format(DateTime.fromMillisecondsSinceEpoch(chat['time'].millisecondsSinceEpoch)),
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        chat["unreadcount"] > 0 ? Container(
                          width: 40.0,
                          height: 20.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: Theme.of(context).primaryColor,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            chat["unreadcount"].toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11.0,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ) : Text(' '),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}