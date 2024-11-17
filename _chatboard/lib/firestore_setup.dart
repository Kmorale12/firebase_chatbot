import 'package:cloud_firestore/cloud_firestore.dart';

void addMessageBoards() async {
  CollectionReference messageBoards = FirebaseFirestore.instance.collection('messageBoards');

  await messageBoards.doc('general_discussion').set({
    'name': 'General Discussion',
    'image': 'assets/general.png',
  });

  await messageBoards.doc('tech_talk').set({
    'name': 'Tech Talk',
    'image': 'assets/tech.png',
  });

  await messageBoards.doc('random').set({
    'name': 'Random',
    'image': 'assets/random.png',
  });
}

void addInitialMessages() async {
  await _addMessagesToBoard('general_discussion');
  await _addMessagesToBoard('tech_talk');
  await _addMessagesToBoard('random');
}

Future<void> _addMessagesToBoard(String boardId) async {
  CollectionReference messages = FirebaseFirestore.instance
      .collection('messageBoards')
      .doc(boardId)
      .collection('messages');

  await messages.add({
    'datetime': Timestamp.now(),
    'message': 'Welcome to $boardId!',
    'username': 'Admin',
  });

  await messages.add({
    'datetime': Timestamp.now(),
    'message': 'Feel free to start the conversation.',
    'username': 'Admin',
  });
}