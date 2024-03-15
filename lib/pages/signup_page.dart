import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_shop_app/pages/home_page.dart';
import 'package:my_shop_app/pages/login_page.dart';

import '../widgets/custom_widgets.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  File? pickedImage;

  //sign up functions
  signup(String email, String password) async {
    if (email.isEmpty || password.isEmpty || pickedImage == null) {
      return CustomWidgets.CustomAlertDialog(
          'Please fill the required fields.', context);
    } else {
      UserCredential? userCredential;
      try {
        userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) {
          uploadData();
        });
      } on FirebaseAuthException catch (ex) {
        return CustomWidgets.CustomAlertDialog(ex.code.toString(), context);
      }
    }
  }

  uploadData() async {
    try {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref('Profile Pics')
          .child(emailController.text.toString())
          .putFile(pickedImage!);
      TaskSnapshot taskSnapshot = await uploadTask;
      String url = await taskSnapshot.ref.getDownloadURL();

      FirebaseFirestore.instance
          .collection('Users')
          .doc(emailController.text.toString())
          .set(
        {
          'Email': emailController.text.toString(),
          'Image': url,
        },
      ).then((value) {
        log("user created");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const HomePage(),
          ),
        );
      });
    } catch (ex) {
      return CustomWidgets.CustomAlertDialog(ex.toString(), context);
    }
  }

  //image picked function
  pickImage(ImageSource imageSource) async {
    final picture = await ImagePicker().pickImage(source: imageSource);
    if (picture == null) return;
    final tempPic = File(picture.path);
    setState(() {
      pickedImage = tempPic;
    });
  }

  //alert box
  showAlertBox() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick Image From:'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
              ),
              ListTile(
                onTap: () {
                  pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
                leading: const Icon(Icons.photo),
                title: const Text('Gallery'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Signup Page',
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
            InkWell(
              onTap: () {
                showAlertBox();
              },
              child: pickedImage == null
                  ? const CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 80,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 80,
                      ),
                    )
                  : CircleAvatar(
                      radius: 80,
                      backgroundImage: FileImage(pickedImage!),
                    ),
            ),
            const SizedBox(height: 20),
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
              'Signup',
              () {
                signup(
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
                  'Already have an account?',
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
                        builder: (_) => const LoginPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Login',
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
