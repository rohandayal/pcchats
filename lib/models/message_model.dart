import 'package:flutter/material.dart';

class Messages with ChangeNotifier {
  // _messages is an internal array of messages

  dynamic _messages;
  Messages(this._messages);

  Messages getMessages() {
    // TODO: Fetch messages if we don't have them
    // if(_messages.length == 0) {
    //   fetchMessages();
    // }
    return _messages;
  }

  void addMessage(dynamic message) {
    _messages.add(message);
    notifyListeners();
  }
}