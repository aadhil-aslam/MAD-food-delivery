import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants.dart';
import '../../widgets/custom_btn.dart';
import '../../widgets/custom_input.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  // Default form loading state
  bool _registerFormLoading = false;

  // Form input field values
  String _type = "Pizza";
  int _price = 0;
  String _name = "";
  String _desc = "";

  //Build an alert to dialog to display some error
  Future<void> _alertDialogBuilder(String error) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Container(child: Text(error)),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Close Dialog"))
            ],
          );
        });
  }

  String docId = "docId";

  List<String> pizzaPrices = [
    "0",
    "499",
    "1000",
  ];

  List<Types> types = <Types>[
    const Types(["0", "499", "1000"], 'Pizzas'),
    const Types(["0", "299", "600"], 'Pastas'),
    const Types(["0", "199", "500"], 'Appetizers'),
    const Types(["0", "399", "800"], 'Rice'),
    const Types(["0", "199", "300"], 'Desserts'),
    const Types(["0", "99", "200"], 'Beverages')
  ];

  late Types selectedType;
  List<String> selectedPrices = ["0", "499", "1000"];

  String quotaLimit = '5';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedType = types[0];
  }

  String imageUrl = "imageUrl";

  // Create a new user product
  Future<String?> _createProduct() async {
    bool haveImage = file != null;
    bool haveName = _name != "";
    bool haveDesc = _desc != "";
    bool havePrice = _price != 0;
    bool haveType = _type != "";
    if (haveImage & haveName & haveName & haveDesc & havePrice & haveType) {
      try {
        DocumentReference docRef =
        await FirebaseFirestore.instance
            .collection("Products")
            .add({
          "name": _name,
          "search string": _name.toLowerCase(),
          "desc": _desc,
          "type": _type,
          "price": _price,
          "images": "imageUrl",
          "size": ["S","M","L"],
          "prices": selectedPrices
        });

        docId = docRef.id;

        final imageName = '${DateTime
            .now()
            .millisecondsSinceEpoch}.png';

        final storageReference =
        FirebaseStorage.instance.ref().child("images/$imageName");

        await storageReference.putFile(file!);
        imageUrl = await storageReference.getDownloadURL();

        await FirebaseFirestore.instance
            .collection("Products")
            .doc(docId)
            .update({
          "images": [imageUrl, imageUrl, imageUrl]
        });
        return null;
      } catch (e) {
        return e.toString();
      }
    } else {
      return "All fields required";
    }
  }

  void _submitForm() async {
    // Set the form to loading state
    setState(() {
      _registerFormLoading = true;
    });

    // Run the create account method
    String? _createProductFeedback = await _createProduct();

    // If the string is not null, we got error while create account.
    if (_createProductFeedback != null) {
      _alertDialogBuilder(_createProductFeedback);

      // Set the form to regular state (not loading).
      setState(() {
        _registerFormLoading = false;
      });
    } else {
      // The String value was null, user is logged in.
      Navigator.pop(context);
    }
  }

  File? file;

  _ChoosePhoto() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      file = File(image!.path);
    });
  }

  String? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 24.0),
              child: const Text(
                "Add New Product",
                textAlign: TextAlign.center,
                style: Constants.boldHeading,
              ),
            ),
            Stack(
              children: [
                Center(
                  child: Container(
                    height: 160,
                    width: 160,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: file != null
                          ? Image.file(
                              file!,
                              fit: BoxFit.cover,
                            )
                          : Center(
                              child: CircleAvatar(
                                backgroundColor: const Color(0xFFF2F2F2),
                                radius: 80,
                                child: Icon(
                                  Icons.add_a_photo,
                                  size: 30,
                                  color: file == null
                                      ? Colors.black
                                      : Colors.transparent,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
                Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.black12,
                    radius: 80,
                    child: IconButton(
                        icon: const Icon(
                          Icons.add_a_photo,
                          size: 30,
                        ),
                        color: file == null ? Colors.black : Colors.transparent,
                        onPressed: () {
                          //Navigator.pop(context);
                          _ChoosePhoto();
                        }),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                CustomInput(
                  hintText: 'Name',
                  onChanged: (value) {
                    _name = value;
                  },
                  onSubmitted: (value) {
                    // _passwordFocusNode.requestFocus();
                  },
                  textInputAction: TextInputAction.next,
                ),
                CustomInput(
                  hintText: 'Description',
                  onChanged: (value) {
                    _desc = value;
                  },
                  onSubmitted: (value) {
                    // _passwordFocusNode.requestFocus();
                  },
                  textInputAction: TextInputAction.next,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 24.0),
                  decoration: BoxDecoration(
                      color: const Color(0xFFF2F2F2).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8),
                      child: DropdownButton<Types>(
                    hint: const Text("Select type"),
                    value: selectedType,
                    onChanged: (Types? newValue) {
                      setState(() {
                        selectedType = newValue!;
                        selectedPrices = selectedType.prices;
                        _type = selectedType.name;
                      });
                    },
                    items: types.map((Types vehicles) {
                      return DropdownMenuItem<Types>(
                        value: vehicles,
                        child: Text(
                          vehicles.name,
                          style: const TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                    //borderRadius: BorderRadius.circular(10),
                    underline: const SizedBox(),
                    isExpanded: true,
                  ))
                ),
                // CustomInput(
                //   hintText: 'Type',
                //   onChanged: (value) {
                //     _type = value;
                //   },
                //   onSubmitted: (value) {
                //     // _passwordFocusNode.requestFocus();
                //   },
                //   textInputAction: TextInputAction.next,
                // ),
                CustomInput(
                  hintText: 'Price',
                  onChanged: (value) {
                    _price = int.parse(value);
                  },
                  onSubmitted: (value) {
                    _submitForm();
                  },
                  isNumField: TextInputType.number,
                  // focusNode: _passwordFocusNode,
                ),
                CustomBtn(
                  text: 'Add Product',
                  onPressed: () {
                    _submitForm();
                  },
                  isLoading: _registerFormLoading,
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 14.0),
              child: CustomBtn(
                  text: 'Back To Dashboard',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  outlineBtn: true),
            )
          ],
        ),
      )),
    );
  }
}

class Types {
  const Types(this.prices, this.name);

  final String name;
  final List<String> prices;
}

List<String> pizzaPrices = [
  "0",
  "499",
  "1000",
];
