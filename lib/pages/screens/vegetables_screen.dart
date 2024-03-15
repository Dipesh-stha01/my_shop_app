import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../edit_item_page.dart';

class VegetablesScreen extends StatefulWidget {
  const VegetablesScreen({super.key});

  @override
  State<VegetablesScreen> createState() => _VegetablesScreenState();
}

class _VegetablesScreenState extends State<VegetablesScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Products')
            .where('Category', isEqualTo: 'Vegetables')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return GridView.builder(
                padding: const EdgeInsets.all(15.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.60,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                ),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => UpdateItemPage(
                            name: snapshot.data!.docs[index]['Name'].toString(),
                            image:
                                snapshot.data!.docs[index]['Image'].toString(),
                            category: snapshot.data!.docs[index]['Category']
                                .toString(),
                            price:
                                snapshot.data!.docs[index]['Price'].toString(),
                            quantity: snapshot.data!.docs[index]['Quantity']
                                .toString(),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 2),
                            color: Colors.grey.withOpacity(0.4),
                            spreadRadius: 4,
                            blurRadius: 5,
                          )
                        ],
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: width,
                              height: height / 5,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    snapshot.data!.docs[index]['Image']
                                        .toString(),
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Name: ${snapshot.data!.docs[index]['Name']}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Price: Rs.${snapshot.data!.docs[index]['Price']}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Category: ${snapshot.data!.docs[index]['Category']}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Measurement: ${snapshot.data!.docs[index]['Quantity']}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.hasError.toString(),
                ),
              );
            } else {
              return const Center(
                child: Text('No Data Found.'),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
