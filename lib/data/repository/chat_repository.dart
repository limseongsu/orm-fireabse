import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/data/model/chat_model.dart';
import 'package:logger/logger.dart';

class ChatRepository {
  final CollectionReference<Map<String, dynamic>> messageDB =
      FirebaseFirestore.instance.collection('Messages');

  Future<List<Chat>> getAllMessages() async {
    List<Chat> chatList = [];
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await messageDB.get();
      if (snapshot.docs.isNotEmpty) {
        chatList = snapshot.docs.map((e) => Chat.fromJson(e.data())).toList();
        chatList.sort((a, b) => b.timeStamp.compareTo(a.timeStamp));
      }
    } catch (e) {
      Logger().d(e);
    }

    return chatList;
  }

  Future<void> updateMessage({required Chat chat}) async {
    try {
      await messageDB.doc().set(chat.toJson());
    } catch (e) {
      Logger().d(e);
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> messageStream() {
    return messageDB.snapshots();
  }
}
