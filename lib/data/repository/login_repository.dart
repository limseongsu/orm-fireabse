import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/data/model/user_model.dart';

class LoginRepository {
  Future<User?> login({required String userId, required String password}) async {
    final QuerySnapshot userDatabase = await FirebaseFirestore.instance.collection('Users').get();
    final List<User> userList = userDatabase.docs
        .map((DocumentSnapshot e) => User.fromJson(e.data() as Map<String, dynamic>))
        .toList();
    if (userList
        .where((element) => (element.userId == userId) && (element.password == password))
        .isNotEmpty) {
      return userList
          .where((element) => (element.userId == userId) && (element.password == password))
          .first;
    } else {
      return null;
    }
  }
}
