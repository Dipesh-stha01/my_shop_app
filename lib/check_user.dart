import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_shop_app/pages/home_page.dart';
import 'package:my_shop_app/pages/login_page.dart';

class CheckUser extends StatefulWidget {
  const CheckUser({super.key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  @override
  Widget build(BuildContext context) {
    return checkUser();
  }

  checkUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const LoginPage();
    } else {
      return const HomePage();
    }
  }
}
