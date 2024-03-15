import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_shop_app/pages/home_page.dart';
import 'package:my_shop_app/pages/signup_page.dart';
import 'package:my_shop_app/widgets/custom_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //login Function
  login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return CustomWidgets.CustomAlertDialog(
          'Please fill the required fields.', context);
    } else {
      UserCredential? userCredential;
      try {
        userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const HomePage(),
            ),
          );
        });
      } on FirebaseAuthException catch (ex) {
        return CustomWidgets.CustomAlertDialog(ex.code.toString(), context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Login Page',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomWidgets.CustomTextField(
              'Email',
              emailController,
              null,
              Icons.mail,
              false,
              width,
            ),
            const SizedBox(height: 20),
            CustomWidgets.CustomTextField(
              'Password',
              passwordController,
              null,
              Icons.lock,
              true,
              width,
            ),
            const SizedBox(height: 30),
            CustomWidgets.CustomButton(
              'Login',
              () {
                login(
                  emailController.text.toString(),
                  passwordController.text.toString(),
                );
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Don\'t have an account?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SignupPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Signup',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
