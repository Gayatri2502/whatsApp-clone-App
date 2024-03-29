import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prac_chat/Models/user_model.dart';

import '../../Screens/chat_screen.dart';

class UserChatCards extends StatefulWidget {
  const UserChatCards({
    Key? key,
    required this.user,
  }) : super(key: key);

  final UserModel user;
  @override
  State<UserChatCards> createState() => _UserChatCardsState();
}

class _UserChatCardsState extends State<UserChatCards> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.01, vertical: 5),
      elevation: 0.15,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
          child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            width: MediaQuery.of(context).size.width * 0.125,
            height: MediaQuery.of(context).size.height * 0.15,
            fit: BoxFit.fill,
            imageUrl: widget.user.photo,
            // placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(
              CupertinoIcons.person_crop_circle_fill,
              size: 50,
              color: Colors.black12,
            ),
          ),
        ),
        title: Text(
          widget.user.name,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
        ),
        subtitle: Text(
          widget.user.bio,
          maxLines: 1,
        ),
        trailing: const Text(
          '12.00 PM',
          style: TextStyle(color: Colors.black54),
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return ChatScreen(
              user: widget.user,
            );
          }));
        },
      )),
    );
  }
}
