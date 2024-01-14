import 'package:firebase_example/ui/view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();
    return Scaffold(
      resizeToAvoidBottomInset: false, // key board input 이 올라올 때 생기는 overflow error 막는 기능
      backgroundColor: Colors.grey.withOpacity(0.2),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 100, bottom: 100),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _screenTitleWidget(viewModel.titleText),
            const SizedBox(height: 100),
            _makeTextFieldWidget(viewModel.idText, viewModel.idController),
            const SizedBox(height: 50),
            _makeTextFieldWidget(viewModel.passwordText, viewModel.pwController, isPw: true),
            const Spacer(),
            _loginButtonWidget(viewModel, context),
          ],
        ),
      ),
    );
  }

  Text _screenTitleWidget(String title) {
    return Text(title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 36,
          fontWeight: FontWeight.w400,
        ));
  }

  Column _makeTextFieldWidget(String title, TextEditingController controller, {bool? isPw}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
            )),
        const SizedBox(height: 8),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white), borderRadius: BorderRadius.circular(8)),
            height: 50,
            child: TextField(
              // hide input text option
              obscureText: isPw == true ? true : false,
              controller: controller,
              style: const TextStyle(color: Colors.white, fontSize: 20),
              cursorColor: Colors.white,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            )),
      ],
    );
  }

  InkWell _loginButtonWidget(LoginViewModel viewModel, BuildContext context) {
    return InkWell(
      onTap: () => viewModel.loginCheck(context),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black),
        ),
        child: Center(
          child: Text(
            viewModel.loginButtonName,
            style: const TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
