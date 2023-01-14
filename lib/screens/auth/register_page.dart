import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../services/firebase_services.dart';
import '../../widgets/custom_btn.dart';
import '../../widgets/custom_input.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //final FirebaseServices _firebaseServices = FirebaseServices();

  Future _createUser() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      "cartTotal": 0,
      "name": _name,
      "Address": "Address",
      "Number": _number,
      "email": _registerEmail,
      "uid": FirebaseAuth.instance.currentUser!.uid,
    });
  }

  //Build an alert to dialog to display some error
  Future<void> _alertDialogBuilder(String error) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Container(child: Text(error)),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Close Dialog"))
            ],
          );
        });
  }

  // Create a new user account
  Future<String?> _createAccount() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _registerEmail.trim(), password: _registerPassword.trim());
      _createUser();
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  void _submitForm() async {
    // Set the form to loading state
    setState(() {
      _registerFormLoading = true;
    });

    // Run the create account method
    String? _createAccountFeedback = await _createAccount();

    // If the string is not null, we got error while create account.
    if (_createAccountFeedback != null) {
      _alertDialogBuilder(_createAccountFeedback);

      // Set the form to regular state (not loading).
      setState(() {
        _registerFormLoading = false;
      });
    } else {
      // The String value was null, user is logged in.
      Navigator.pop(context);
    }
  }

  // Default form loading state
  bool _registerFormLoading = false;

  // Form input field values
  String _registerEmail = "";
  String _registerPassword = "";
  String _name = "";
  String _number = "";
  String _address = "";

  // Focus Node for input fields
  late FocusNode _passwordFocusNode;

  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/pizzalogin.jpg"),
                fit: BoxFit.cover,
              ),
            ),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 24.0),
              child: Text(
                "Create A New Account",
                textAlign: TextAlign.center,
                style: Constants.LoginHeading,
              ),
            ),
            Column(
              children: [
                CustomInput(
                  hintText: 'Full name',
                  onChanged: (value) {
                    _name = value;
                  },
                  onSubmitted: (value) {
                    _passwordFocusNode.requestFocus();
                  },
                  textInputAction: TextInputAction.next,
                ),
                CustomInput(
                  isNumField: TextInputType.phone,
                  hintText: 'Phone number',
                  onChanged: (value) {
                    _number = value;
                  },
                  onSubmitted: (value) {
                    _passwordFocusNode.requestFocus();
                  },
                  textInputAction: TextInputAction.next,
                ),
                CustomInput(
                  hintText: 'Email',
                  onChanged: (value) {
                    _registerEmail = value;
                  },
                  onSubmitted: (value) {
                    _passwordFocusNode.requestFocus();
                  },
                  textInputAction: TextInputAction.next,
                ),
                CustomInput(
                  hintText: 'Password',
                  onChanged: (value) {
                    _registerPassword = value;
                  },
                  onSubmitted: (value) {
                    _submitForm();
                  },
                  focusNode: _passwordFocusNode,
                  isPasswordField: true,
                ),
                CustomBtn(
                  text: 'Create New Account',
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
                  text: 'Back To Login',
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
