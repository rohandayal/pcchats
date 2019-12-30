// import 'package:flutter/material.dart';
// import 'package:pcchatz/models/message_model.dart';

// class LikeButton extends StatefulWidget {
//   final Message message;
//   LikeButton({Key key, this.message}) : super(key: key);

//   @override
//   _LikeButtonState createState() => _LikeButtonState();
// }

// class _LikeButtonState extends State<LikeButton> {
//   void _toggleFavorite() {
//     setState(() {
//       if(widget.message.favorite) {
//         widget.message.favorite = false;
//       } else {
//         widget.message.favorite = true;
//       }
//     });
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//        child: IconButton(
//           icon: widget.message.favorite ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
//           iconSize: 30.0,
//           color: widget.message.favorite ? Theme.of(context).primaryColor : Colors.blueGrey,
//           onPressed: _toggleFavorite,
//         ),
//     );
//   }
// }