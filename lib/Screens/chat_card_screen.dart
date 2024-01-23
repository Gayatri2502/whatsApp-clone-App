import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:widget_loading/widget_loading.dart';

import '../Models/user_model.dart';
import '../Widgets/Chat Cards/chat_cards.dart';

class ChatCardScreen extends StatefulWidget {
  const ChatCardScreen({Key? key}) : super(key: key);

  @override
  State<ChatCardScreen> createState() => _ChatCardScreenState();
}

class _ChatCardScreenState extends State<ChatCardScreen> {
  List<UserModel> contactList = [];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    isLoading = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('Users').snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return CircularWidgetLoading(
                  sizeDuration: Duration(milliseconds: 5),
                  dotRadius: 5,
                  dotColor: Colors.teal.shade200,
                  child: Container());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              contactList = data
                      ?.map((e) =>
                          UserModel.fromJson(e.data() as Map<String, dynamic>))
                      .toList() ??
                  [];

              // Remove the current user from the contactList
              contactList.removeWhere((user) =>
                  user.userID == FirebaseAuth.instance.currentUser!.uid);
          }
          return ListView.builder(
              itemCount: contactList.length,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.02,
              ),
              // physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(1),
                  child: UserChatCards(
                    user: contactList[index],
                  ),
                );
                // return Text('$listOfUsers[index]');
              });
        });
  }
}
