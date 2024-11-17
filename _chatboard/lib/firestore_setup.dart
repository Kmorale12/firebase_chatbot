import 'package:cloud_firestore/cloud_firestore.dart';

void addMessageBoards() async {
  CollectionReference messageBoards = FirebaseFirestore.instance.collection('messageBoards'); //used to add the message boards to the database

  await messageBoards.doc('general_discussion').set({ //used to set the message boards
    'name': 'General Discussion',
    'image': 'assets/general.png',
  });

  await messageBoards.doc('tech_talk').set({
    'name': 'Tech Talk',
    'image': 'assets/tech.png',
  });

  await messageBoards.doc('cars').set({
    'name': 'Cars',
    'image': 'assets/random.png',
  });
}