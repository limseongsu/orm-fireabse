import 'package:firebase_example/data/repository/login_repository.dart';
import 'package:firebase_example/ui/screen/chat/chat_screen.dart';
import 'package:firebase_example/ui/view_model/chat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/model/user_model.dart';

enum LogInResult { success, fail }

class LoginViewModel extends ChangeNotifier {
  final LoginRepository _loginRepository = LoginRepository();
  final String titleText = "로그인 화면";
  final String idText = "아이디";
  final String passwordText = "비밀번호";
  final String loginButtonName = "로그인";

  TextEditingController idController = TextEditingController();
  TextEditingController pwController = TextEditingController();

  bool isLoading = false;

  Future loginCheck(BuildContext context) async {
    // debounce 같이 사용
    if (isLoading == false) {
      isLoading = true;

      if (idController.text.trim().isNotEmpty && pwController.text.trim().isNotEmpty) {
        User? verify =
            await _loginRepository.login(userId: idController.text, password: pwController.text);
        // mounted 옵션을 안 썼을 경우 Navigator.of(context) 부분에 yellow underline lint 가 표시됨.
        // 이유는 비동기 코드 블럭에서 BuildContext 를 바로 쓰지 말라는 의미이다.  BuildContext 를 안전하게 참조할 수 있게 작성하라는 컴파일러의 경고 가 있음.
        if (verify is User && context.mounted) {
          return Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
            builder: (context) {
              return ChangeNotifierProvider(
                create: (_) => ChatViewModel(),
                child: ChatRoomScreen(currentUser: verify),
              );
            },
          ), (route) => false);
        }

        isLoading = false;
      }
    }
    notifyListeners();
  }

  @override
  void dispose() {
    idController.dispose();
    pwController.dispose();
    super.dispose();
  }
}
