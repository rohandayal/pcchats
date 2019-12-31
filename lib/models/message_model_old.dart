// import 'dart:math';

// import 'package:pcchatz/models/user_model.dart';
// import 'package:random_string/random_string.dart';
// import 'package:lipsum/lipsum.dart' as lipsum;

// Message _$MessageFromJson(Map<String, dynamic> json) {
//   return Message(
//       id: json["id"] as String,
//       sender: User.fromJson(json['sender']),
//       time: json['datetime'] as DateTime,
//       messagetext: json["messagetext"] as String,
//       unread: json['unread'] as bool,
//       imageUrl: json['imageUrl'] as String,
//       favorite: json['favorite'] as bool
//       );
// }

// Map<String, dynamic> _$MessageToJson(Message message) => <String, dynamic>{
//       'id': message.id,
//       'sender': message.sender,
//       'time': message.time,
//       'messagetext': message.messagetext,
//       'unread': message.unread,
//       'imageUrl': message.imageUrl,
//       'favorite': message.favorite
//     };

// class Message {
//   final String id;
//   final User sender;
//   final DateTime time;
//   final String messagetext;
//   final bool unread;
//   final String imageUrl;
//   bool favorite;

//   Message({
//     this.id,
//     this.sender,
//     this.time,
//     this.messagetext,
//     this.unread,
//     this.imageUrl,
//     this.favorite
//   });

//   factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);
  
//   Map<String, dynamic> toJson() => _$MessageToJson(this);
// }

// Message generateIncomingMessage(String userId) {
//   var randGen = Random.secure();
//   User fromUser = findUserById(userId);
//   String messagetext = lipsum.createSentence();
//   String id = randomString(35);
//   bool unread = randGen.nextInt(10) > 5 ? true : false;
//   bool favorite = randGen.nextInt(10) > 5 ? true : false;
//   DateTime time = new DateTime.utc(2019, 12, randGen.nextInt(30) + 1, randGen.nextInt(23), randGen.nextInt(60));
//   return new Message(id: id, sender: fromUser, time: time, messagetext: messagetext, unread: unread, imageUrl: null, favorite: favorite);
// }

// Future<List<Message>> genHomeMessages() async {
//   List<Message> messages = new List<Message>();
//   for(var i=0; i<users.length; i++) {
//     Message thismessage = generateIncomingMessage(users[i].id);
//     messages.add(thismessage);
//   }
//   messages.sort((b, a) => a.time.compareTo(b.time));
//   return messages;
// }

// Future<List<Message>> getHomeMessages = Future<List<Message>>.delayed(
//   Duration(seconds: 2),
//   genHomeMessages
// );

// Future<List<Message>> genChatMessages(User user) async {
//   var randGen = Random.secure();
//   List<Message> messages = new List<Message>();
//   int whosent = 0;
//   for(var i=0; i<randGen.nextInt(20); i++) {
//     whosent = randGen.nextInt(10);
//     Message thismessage = generateIncomingMessage(whosent > 5 ? user.id : currentUser.id);
//     messages.add(thismessage);
//   }
//   messages.sort((b, a) => a.time.compareTo(b.time));
//   return messages;
// }