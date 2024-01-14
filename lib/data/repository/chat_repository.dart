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

  Future updateMessage({required Chat chat}) async {
    try {
      await messageDB.doc().set(chat.toJson());
    } catch (e) {
      Logger().d(e);
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessageStream() {
    return messageDB.snapshots();
  }
}

// import 'package:firebase_database/firebase_database.dart';
// import 'package:logger/logger.dart';
//
// import '../model/chat_model.dart';
//
// class ChatRepository {
//   final DatabaseReference _messagesRef = FirebaseDatabase.instance.ref().child("Messages");
//
//   ///  채팅방이 만들어 질  떄
//   Future<List<Chat>> getAllMessages() async {
//     List<Chat> chatList = [];
//     // await _messagesRef.remove();
//     DataSnapshot snapshot = await _messagesRef.get();
//     if (snapshot.exists) {
//       var mapData = Map.from(snapshot.value as Map<String, String>);
//       Logger().d(mapData.runtimeType);
//
//       // chatList = mapData.values.map((e) => Chat.fromJson(e as Map<String, dynamic>)).toList();
//     }
//     return chatList;
//   }
//
//   /// 새로운 채팅이 입력 됐을 때
//   Future updateMessage({required Chat chat}) async {
//     try {
//       await _messagesRef.set({"Message": chat.toJson()});
//     } catch (e) {
//       Logger().d(e);
//     }
//   }
//
//   Future<DatabaseEvent> databaseEvent() {
//     return _messagesRef.onValue.last;
//   }
// }
