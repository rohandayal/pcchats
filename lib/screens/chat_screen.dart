import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pcchatz/widgets/chat_line.dart';
import 'package:path/path.dart' as PPath;


class ChatScreen extends StatefulWidget {
  final dynamic contact;
  final dynamic user;
  
  ChatScreen({Key key, this.contact, this.user}) : super(key: key);
  
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  dynamic messages;
  Future<dynamic> messageFuture;
  var refresh = 0;
  bool _isMessageSending = false;
  bool _isPicUploading = false;

  String getLookup() {
    var returnlist = [widget.user['uid'], widget.contact['uid']];
    returnlist.sort();
    return returnlist.join('||');
  }

  // String getOnewayLookup() {
  //   return widget.contact['uid'] + "||" + widget.user['uid'];
  // }

  Future chooseFile() async {
    await ImagePicker.pickImage(
      source: ImageSource.gallery
    ).then((image) async {
      setState(() {
        _isPicUploading = true;
      });
      StorageReference storageReference = FirebaseStorage.instance.ref().child('chats/${PPath.basename(image.path)}');
      StorageUploadTask storageUploadTask = storageReference.putFile(image);
      await storageUploadTask.onComplete;
      storageReference.getDownloadURL().then((dlurl) {
        Firestore.instance.collection('messages').add({
          "sender": widget.user['uid'],
          "senderName": widget.user['fname'],
          "receiver": widget.contact['uid'],
          "receiverToken": widget.contact.data.containsKey('tokenID') ?  widget.contact['tokenID'] : '',
          "text": "",
          "time": FieldValue.serverTimestamp(),
          "unread": true,
          "imageURL": dlurl,
          "lookup": getLookup(),
          "type": 0
        });
        setState(() {
          _isPicUploading = false;
        });
      });
    });
  }

  _buildMessageComposer(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          _isPicUploading ? CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          ) : IconButton(
            icon: Icon(Icons.photo),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: chooseFile,
          ),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Send a message... ',
              ),
              controller: msgInputController,
              onChanged: (value) {},
            ),
          ),
          _isMessageSending ? CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          ) : IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: sendMessage,
          ),
        ],
      )
    );
  }

  void cleanUp() {
    msgInputController.clear();
    setState(() {
      _isMessageSending = false;
    });
  }

  void sendMessage() {
    if(msgInputController.text == '') {
      return;
    }
    setState(() {
      _isMessageSending = true;
    });
    Firestore.instance.collection('messages').add({
      "sender": widget.user['uid'],
      "senderName": widget.user['fname'],
      "receiver": widget.contact['uid'],
      "receiverToken": widget.contact.data.containsKey('tokenID') ?  widget.contact['tokenID'] : '',
      "text": msgInputController.text,
      "time": FieldValue.serverTimestamp(),
      "unread": true,
      "imageURL": "",
      "lookup": getLookup(),
      "type": 0
    }).then((response) =>
      cleanUp()
    );
  }

  TextEditingController msgInputController;
  
  @override
  void initState() { 
    msgInputController = new TextEditingController();
    messageFuture = Firestore.instance.collection('messages')
                    .where(
                      'lookup', isEqualTo: getLookup()
                    ).where(
                      'type', isEqualTo: 0
                    ).orderBy('time', descending: true)
                    .getDocuments();
    super.initState();
    // Firestore.instance.collection('messages')
    //   .where('lookup', isEqualTo: getLookup())
    //   .where('type', isEqualTo: 0)
    //   .where('receiver', isEqualTo: widget.user['uid'])
    //   .
  }

  void markMessagesRead(dynamic messages) {
    var batch = Firestore.instance.batch();
    for(var i=0; i<messages.length; i++) {
      if(messages[i]['receiver'] == widget.user['uid'] && messages[i]['unread']) {
        batch.updateData(Firestore.instance.collection('messages').document(messages[i].documentID), {"unread": false});
      }
    }
    batch.commit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(widget.contact['fname'],
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),  
        ),
        elevation: 0.0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: FutureBuilder(
                  future: messageFuture,
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                        ),
                      );
                    }
                    if(!snapshot.hasData) {
                      return Center(
                        child: Text(
                          'No messages :(',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24.0,
                          ),
                        ),
                      );
                    }
                    messages = snapshot.data.documents;
                    markMessagesRead(messages);
                    return ChatLine(messages: messages, user: widget.user,);
                  }
                ),
              ),
            ),
            _buildMessageComposer(context),
          ],
        ),
      ),
    );
  }
}