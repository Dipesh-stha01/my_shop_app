import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/custom_widgets.dart';

class UpdateItemPage extends StatefulWidget {
  final String image, name, category, price, quantity;
  const UpdateItemPage(
      {super.key,
      required this.image,
      required this.name,
      required this.category,
      required this.price,
      required this.quantity});

  @override
  State<UpdateItemPage> createState() => _UpdateItemPageState();
}

class _UpdateItemPageState extends State<UpdateItemPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  File? productImage;
  final gramList = ['250G', '500G', '1KG', '1Piece'];
  final litreList = ['250ML', '500ML', '1L', '1.5L', '2L', '1Bottle'];
  final pieceList = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '1Packet',
    '125G',
    '250G',
    '500G',
    '1KG'
  ];
  final categoryList = [
    ['Vegetables', 'assets/icons/vegetable.png'],
    ['Drinks', 'assets/icons/soda.png'],
    ['Packets', 'assets/icons/food.png']
  ];
  late String selectedCategory;
  late String quantity;
  late String gram;
  late String litre;
  late String piece;

  @override
  void initState() {
    selectedCategory = widget.category;
    print('category: $selectedCategory');
    nameController.text = widget.name.toString();
    priceController.text = widget.price.toString();

    gram = '';
    litre = '';
    piece = '';
    setState(() {
      if (selectedCategory == "Vegetables") {
        gram = widget.quantity;
        litre = litreList.first;
        piece = pieceList.first;
      } else if (selectedCategory == "Drinks") {
        gram = gramList.first;
        litre = widget.quantity;
        piece = pieceList.first;
      } else {
        gram = gramList.first;
        litre = litreList.first;
        piece = widget.quantity;
      }
    });
    super.initState();
  }

  //select image
  selectImage(ImageSource imageSource) async {
    final photo = await ImagePicker().pickImage(source: imageSource);
    if (photo == null) return;
    final tempPic = File(photo.path);
    setState(() {
      productImage = tempPic;
    });
  }

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
                  selectImage(ImageSource.camera);
                  Navigator.pop(context);
                },
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
              ),
              ListTile(
                onTap: () {
                  selectImage(ImageSource.gallery);
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

  //Add Item function
  addItem(String name, String price) async {
    if (name == '' || price == '') {
      return CustomWidgets.CustomAlertDialog(
        'Please fill the required fields.',
        context,
      );
    } else {
      try {
        uploadData();
      } on FirebaseAuthException catch (ex) {
        return CustomWidgets.CustomAlertDialog(
          ex.code.toString(),
          context,
        );
      }
    }
  }

  uploadData() async {
    try {
      if (productImage != null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );
        UploadTask uploadTask = FirebaseStorage.instance
            .ref('Product Images')
            .child(nameController.text.toString())
            .putFile(productImage!);
        TaskSnapshot taskSnapshot = await uploadTask;
        String url = await taskSnapshot.ref.getDownloadURL();
        FirebaseFirestore.instance
            .collection('Products')
            .doc(nameController.text.toString())
            .update(
          {
            'Name': nameController.text.toString(),
            'Price': priceController.text.toString(),
            'Image': url,
            'Category': selectedCategory,
            'Quantity': selectedCategory == "Vegetables"
                ? gram
                : selectedCategory == "Drinks"
                    ? litre
                    : piece,
          },
        ).then((value) {
          // close the loading indicator
          Navigator.of(context).pop();
        });
        // close the current page
        Navigator.of(context).pop();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Data updated successfully!"),
          ),
        );
      } else {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );
        FirebaseFirestore.instance
            .collection('Products')
            .doc(nameController.text.toString())
            .update(
          {
            'Name': nameController.text.toString(),
            'Price': priceController.text.toString(),
            'Category': selectedCategory,
            'Quantity': selectedCategory == "Vegetables"
                ? gram
                : selectedCategory == "Drinks"
                    ? litre
                    : piece,
          },
        ).then((value) {
          // close the loading indicator
          Navigator.of(context).pop();
        });
        // close the current page
        Navigator.of(context).pop();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Data updated successfully!"),
          ),
        );
      }
    } catch (ex) {
      return CustomWidgets.CustomAlertDialog(
        ex.toString(),
        context,
      );
    }
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
          'Update Item Page',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  showAlertBox();
                },
                child: productImage == null
                    ? Container(
                        width: width,
                        height: height / 2.3,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(widget.image),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )
                    : Container(
                        width: width,
                        height: height / 2.3,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(productImage!),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Category: ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    height: 60,
                    width: width / 1.6,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: DropdownButton(
                        value: selectedCategory,
                        underline: Container(),
                        items: categoryList.map<DropdownMenuItem<String>>(
                            (List<String> category) {
                          return DropdownMenuItem<String>(
                            value: category[0],
                            child: Row(
                              children: <Widget>[
                                Image.asset(
                                  category[1],
                                  width: 24,
                                  height: 24,
                                ),
                                const SizedBox(width: 10),
                                Text(category[0]),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value.toString();
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomWidgets.CustomTextField(
                'Name',
                nameController,
                null,
                Icons.text_fields_outlined,
                false,
                width,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomWidgets.CustomTextField(
                    'Price',
                    priceController,
                    TextInputType.number,
                    Icons.monetization_on_outlined,
                    false,
                    width / 1.8,
                  ),
                  Container(
                    height: 60,
                    width: width / 3.5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: DropdownButton(
                        value: selectedCategory == 'Vegetables'
                            ? gram
                            : selectedCategory == 'Drinks'
                                ? litre
                                : piece,
                        items: selectedCategory == "Vegetables"
                            ? gramList.map((String value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList()
                            : selectedCategory == "Drinks"
                                ? litreList.map((String value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList()
                                : pieceList
                                    .map<DropdownMenuItem<String>>((value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                        onChanged: (value) {
                          setState(() {
                            quantity = value.toString();
                            if (selectedCategory == "Vegetables") {
                              gram = value.toString();
                            } else if (selectedCategory == "Drinks") {
                              litre = value.toString();
                            } else {
                              piece = value.toString();
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              CustomWidgets.CustomButton(
                'Update Item',
                () {
                  addItem(
                    nameController.text.toString(),
                    priceController.text.toString(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
