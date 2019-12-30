import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatLine extends StatelessWidget {
  final dynamic messages;
  final dynamic user;
  ChatLine({Key key, this.messages, this.user}) : super(key: key);
  final formatter = new DateFormat('MMM d, h:mm a');

  _buildMessage(dynamic message, bool isMe, BuildContext context) {
    return Container(
      margin: isMe ? EdgeInsets.only(
        top: 8.0,
        bottom: 8.0,
        left: 40.0,
      ) : EdgeInsets.only(
        top: 8.0,
        bottom: 8.0,
        right: 40.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(formatter.format(DateTime.fromMillisecondsSinceEpoch(message['time'].millisecondsSinceEpoch)),
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 11.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          message['text']!= "" ? Linkify(
            onOpen: (link) async {
              if(await canLaunch(link.url)) {
                await launch(link.url);
              } else {
                Flushbar(
                  title: "Whoops",
                  message: "Couldn't load that link",
                  duration: Duration(seconds: 2),
                  icon: Icon(Icons.sentiment_dissatisfied),
                ).show(context);
              }
            },
            text: message['text'],
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
            linkStyle: TextStyle(
              color: Colors.red,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ) : Image.network(message['imageURL']),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 25.0,
        vertical: 15.0,
      ),
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        color: isMe ? Colors.pink[50] : Theme.of(context).accentColor,
        borderRadius: isMe ? BorderRadius.only(
          topLeft: Radius.circular(15.0),
          bottomLeft: Radius.circular(15.0),
        ): BorderRadius.only(
          topRight: Radius.circular(15.0),
          bottomRight: Radius.circular(15.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: ListView.builder(
          reverse: true,
          padding: EdgeInsets.only(
            top: 15.0,
          ),
          itemCount: messages.length,
          itemBuilder: (BuildContext context, int index) {
            final message = messages[index];
            final bool isMe = message['sender'] == user['uid'];
            return _buildMessage(message, isMe, context);
          },
        ),
      ),
    );
  }
}