import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_shop_app/pages/add_item_page.dart';
import 'package:my_shop_app/pages/edit_item_page.dart';
import 'package:my_shop_app/pages/login_page.dart';
import 'package:my_shop_app/pages/screens/all_screen.dart';
import 'package:my_shop_app/pages/screens/drinks_screen.dart';
import 'package:my_shop_app/pages/screens/vegetables_screen.dart';

import 'screens/packets_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final categoryList = [
    ['All', 'assets/icons/all.png'],
    ['Vegetables', 'assets/icons/vegetable.png'],
    ['Drinks', 'assets/icons/soda.png'],
    ['Packets', 'assets/icons/food.png']
  ];

  late String selectedCategory;

  @override
  void initState() {
    selectedCategory = categoryList[0][0];
    super.initState();
  }

  //signout function
  signout() {
    FirebaseAuth.instance.signOut().then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Home Page',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () {
              signout();
            },
            icon: const Icon(
              Icons.logout,
            ),
            color: Colors.white,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            width: width,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categoryList.map(
                  (category) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedCategory = category[0];
                          });
                        },
                        child: Chip(
                          backgroundColor: selectedCategory == category[0]
                              ? Colors.green
                              : Colors.white,
                          label: Text(category[0]),
                          avatar: CircleAvatar(
                            backgroundImage: AssetImage(
                              category[1],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          ),
          Expanded(
            child: selectedCategory == categoryList[0][0]
                ? const AllScreen()
                : selectedCategory == categoryList[1][0]
                    ? const VegetablesScreen()
                    : selectedCategory == categoryList[2][0]
                        ? const DrinksScreen()
                        : const PacketsScreen(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddItemPage(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
