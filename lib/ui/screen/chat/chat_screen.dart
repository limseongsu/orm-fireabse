import 'package:firebase_example/data/model/user_model.dart';
import 'package:firebase_example/ui/view_model/chat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/model/chat_model.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key, required this.currentUser});

  final User currentUser;

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  ChatViewModel viewModel = ChatViewModel();

  @override
  void initState() {
    //
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      viewModel = Provider.of<ChatViewModel>(context, listen: false);
      viewModel.getLastMessageEvent().listen((event) {
        viewModel.updateLastMessage(snapshot: event);
      });
      await viewModel.initChatRoom(currentUser: widget.currentUser);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<ChatViewModel>();
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.2),
      appBar: AppBar(
        backgroundColor: Colors.grey,
        centerTitle: true,
        shadowColor: Colors.white70,
        elevation: 3.0,
        title: Text(widget.currentUser.userId),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: viewModel.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Expanded(child: Consumer<ChatViewModel>(
                    builder: (BuildContext context, ChatViewModel value, Widget? child) {
                      return ListView.builder(
                          reverse: true,
                          controller: value.scrollController,
                          itemCount: value.chatList.length,
                          itemBuilder: (context, index) {
                            if (value.chatList.isNotEmpty) {
                              return _chatWidget(
                                isMyChat:
                                    (value.chatList[index].sender == widget.currentUser.userId)
                                        ? true
                                        : false,
                                receiverName: value.receiverName,
                                chat: value.chatList[index],
                                date: value.convertTimestamp(value.chatList[index].timeStamp),
                              );
                            } else {
                              return Container();
                            }
                          });
                    },
                  )),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(left: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                            ),
                            child: TextField(
                              controller: viewModel.messageController,
                              style: const TextStyle(color: Colors.white, fontSize: 20),
                              cursorColor: Colors.white,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        InkWell(
                          onTap: () async =>
                              await viewModel.sendMessage(currentUser: widget.currentUser),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(8)),
                            width: 60,
                            child: const Center(
                              child: Text(
                                "보내기",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Column _chatWidget({
    required bool isMyChat,
    required String receiverName,
    required Chat chat,
    required String date,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isMyChat)
          Column(
            children: [
              Text(receiverName,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
            ],
          ),
        Row(
          children: [
            if (isMyChat) const Expanded(child: SizedBox()),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: const TextStyle(color: Colors.red, fontSize: 10),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 200),
                    child: Text(chat.message,
                        style: const TextStyle(color: Colors.white, fontSize: 14)),
                  )
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
