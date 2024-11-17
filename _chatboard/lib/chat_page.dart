import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatefulWidget {
  final String boardName;

  ChatPage({required this.boardName});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final User? _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.boardName),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messageBoards')
                  .doc(widget.boardName)
                  .collection('messages')
                  .orderBy('datetime', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                var messages = snapshot.data!.docs;
                print('Messages fetched: ${messages.length}');
                for (var message in messages) {
                  print('Message: ${message['message']}');
                }
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    return ListTile(
                      title: Text(message['message']),
                      subtitle: Text('${message['username']} - ${message['datetime'].toDate()}'),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter a message',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      print('Sending message: ${_messageController.text}');
      await FirebaseFirestore.instance
          .collection('messageBoards')
          .doc(widget.boardName)
          .collection('messages')
          .add({
        'message': _messageController.text,
        'datetime': Timestamp.now(),
        'username': _user?.displayName ?? 'Anonymous',
      });
      _messageController.clear();
    }
  }
}