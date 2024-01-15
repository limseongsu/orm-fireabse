import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/data/repository/chat_repository.dart';
import 'package:flutter/material.dart';
import '../../data/model/chat_model.dart';
import '../../data/model/user_model.dart';
import 'package:intl/intl.dart';

class ChatViewModel extends ChangeNotifier {
  final ChatRepository _chatRepository = ChatRepository();

  List<Chat> chatList = [];
  bool isLoading = false;
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  String receiverName = 'second';

  Future<void> initChatRoom({required User currentUser}) async {
    isLoading = true;
    // fakeData 여서 간단하게 구현 -> 실제 login 을 사용하면 해당 sender, receiver 정보를 다 만들어야함.
    if (currentUser.userId != 'first') {
      receiverName = 'first';
    }
    // 화면 진입 시 데이터 로드
    await initMessages();

    isLoading = false;
    notifyListeners();
  }

  ///  채팅방이 만들어 질  떄
  Future<void> initMessages() async {
    chatList = await _chatRepository.getAllMessages();
    chatList.reversed;
  }

  /// 새로운 채팅이 입력 됐을 때
  Future<void> sendMessage({required User currentUser}) async {
    final message = messageController.text;
    //좌우 공백 없에기
    if (message.trimLeft().trimRight().isNotEmpty) {
      DateTime dateTime = DateTime.now();
      int timestamp = dateTime.millisecondsSinceEpoch;
      Chat newChat = Chat(true, sender: currentUser.userId, message: message, timeStamp: timestamp);
      await _chatRepository.updateMessage(chat: newChat);
      messageController.clear();
      notifyListeners();
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessageEvent() {
    //streamBuilder 에 Event 전달
    return _chatRepository.messageStream();
  }

  void updateLastMessage({required QuerySnapshot<Map<String, dynamic>> snapshot}) {
    if (snapshot.docChanges.last.doc.exists) {
      Map<String, dynamic> mapData = Map.from(snapshot.docChanges.last.doc.data()!);
      Chat newChat = Chat.fromJson(mapData);
      chatList.insert(0, newChat);
      notifyListeners();
    }
  }

  String convertTimestamp(int timestamp) {
    DateTime convertDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateFormat format = DateFormat('HH:mm');
    String nowTime = format.format(convertDate);
    return nowTime;
  }

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    ;
    super.dispose();
  }
}
