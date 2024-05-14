import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:masari_salik_app/style/fonts.dart';

import '../../style/app_color.dart';

class HospitalChatScreen extends StatefulWidget {
  final String recipientEmail;
  final String recipientUserId;
  final String recipientToken;
  HospitalChatScreen(
      {required this.recipientEmail,
      required this.recipientUserId,
      required this.recipientToken});

  @override
  _HospitalChatScreenState createState() => _HospitalChatScreenState();
}

class _HospitalChatScreenState extends State<HospitalChatScreen> {
  final TextEditingController messageController = TextEditingController();
  final userId = FirebaseAuth.instance.currentUser!.uid;
  File? _imageFile;
  late final String receiverToken;
  @override
  void initState() {
    super.initState();
    requestPermission();
    receiverToken = widget.recipientToken;
  }

  void sendMessage({required String text, String? imageUrl}) async {
    final user = FirebaseAuth.instance.currentUser;

    if (text.isEmpty && _imageFile == null) {
      return;
    }
    List<String> ids = [userId, widget.recipientUserId];
    ids.sort();
    String chatRoom = ids.join("_");
    if (text.isEmpty && _imageFile == null) {
      return;
    }

    if (_imageFile != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('chat_images')
          .child('${DateTime.now()}.jpg');
      await ref.putFile(_imageFile!);
      imageUrl = await ref.getDownloadURL();
      await sendPushMessage(
          '${messageController.text.trim()}', 'New Message', 'user');
    }

    FirebaseFirestore.instance
        .collection('chats')
        .doc(chatRoom)
        .collection("messages")
        .add({
      'message': messageController.text.trim(),
      'imageUrl': imageUrl,
      'userId': userId,
      'timestamp': DateFormat.jm().format(DateTime.now()), // Format the time
    });
    await sendPushMessage(
        'New Message', '${messageController.text.trim()}', 'user');
    messageController.clear();
    setState(() {
      _imageFile = null;
    });
  }

  Future sendPushMessage(String body, String title, receiver) async {
    final String serverToken =
        "AAAAPQ5D324:APA91bE1ADCNQD9uRyLZl5G7qLWPXo8NhUeOSL279wXCv-o616wZE7KPFifoRDIOLh3FidgNlJEdq0Z8hWGHN9j0y5-zQ8BJVwsaUPTJPkX96xWIs_pQ2tBqjkLfVmqkKancb3bzY9ez";

    try {
      print('reciever token is : $receiverToken');
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverToken',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body.toString(),
              'title': title.toString()
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': title,
              'receiver': receiver
            },
            "to": receiverToken,
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor.primary),
        centerTitle: true,
        title: Column(
          children: [
            Icon(
              Icons.account_circle,
              color: AppColor.primary,
            ),
            Text(
              widget.recipientEmail,
              style: robotoMediumBold,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              key: ValueKey(widget.recipientUserId),
              stream: getMessages(userId, widget.recipientUserId),
              builder: (ctx, chatSnapshot) {
                if (chatSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                final chatDocs = chatSnapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: chatDocs.length,
                  itemBuilder: (ctx, index) => _buildMessage(chatDocs[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                _buildImagePickerButton(),
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(labelText: 'Message'),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: AppColor.primary,
                  ),
                  onPressed: () => sendMessage(text: messageController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(DocumentSnapshot messageSnapshot) {
    final messageData = messageSnapshot.data() as Map<String, dynamic>;
    //final currentUser = FirebaseAuth.instance.currentUser;
    final currentUser = userId;
    // final isCurrentUser = messageData['userId'] == currentUser?.uid;
    final isCurrentUser = messageData['userId'] == currentUser;
    if (messageData['imageUrl'] != null) {
      // Display image message
      return Row(
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            alignment:
                isCurrentUser ? Alignment.centerLeft : Alignment.centerLeft,
            decoration: BoxDecoration(
              color: isCurrentUser ? AppColor.primary : AppColor.primarySoft,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Image.network(
                    messageData['imageUrl'],
                    width: 200,
                    height: 200,
                  ),
                  Text(
                    messageData['message'],
                    style: TextStyle(
                      color: isCurrentUser ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    messageData['timestamp'].toString(),
                    style: TextStyle(
                      color: isCurrentUser ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    // Display text message
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: isCurrentUser ? AppColor.primary : AppColor.primarySoft,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          children: [
            Text(
              messageData['message'],
              style: TextStyle(
                color: isCurrentUser ? Colors.white : Colors.black,
              ),
            ),
            Text(
              messageData['timestamp'].toString(),
              style: TextStyle(
                color: isCurrentUser ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePickerButton() {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.photo,
            color: AppColor.primary,
          ),
          onPressed: _pickImage,
        ),
      ],
    );
  }

  void _pickImage() async {
    final pickedImageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImageFile != null) {
      setState(() {
        _imageFile = File(pickedImageFile.path);
      });
    }
  }

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    final _fireStore = FirebaseFirestore.instance;
    return _fireStore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

requestPermission() async {
  NotificationSettings settings = await _firebaseMessaging.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: false,
    criticalAlert: true,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
}
