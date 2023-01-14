import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/screens/auth/register_page.dart';
import 'package:food_delivery/widgets/custom_btn.dart';

import '../../constants.dart';
import '../../widgets/custom_input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
  Future<String?> _loginAccount() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _loginEmail.trim(), password: _loginPassword.trim());
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
      _loginFormLoading = true;
    });

    // Run the create account method
    String? _loginFeedback = await _loginAccount();

    // If the string is not null, we got error while create account.
    if (_loginFeedback != null) {
      _alertDialogBuilder(_loginFeedback);

      // Set the form to regular state (not loading).
      setState(() {
        _loginFormLoading = false;
      });
    }
  }

  // Default form loading state
  bool _loginFormLoading = false;

  // Form input field values
  String _loginEmail = "";
  String _loginPassword = "";

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
              child: Stack(
                children: [
                  // Container(
                  //     width: 250,
                  //     height: 25,
                  //     color: Theme.of(context).colorScheme.secondary),
                  Text(
                    "Welcome User, \nLogin to your account",
                    textAlign: TextAlign.center,
                    style: Constants.LoginHeading,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                CustomInput(
                  hintText: 'Email',
                  onChanged: (value) {
                    _loginEmail = value;
                  },
                  onSubmitted: (value) {
                    _passwordFocusNode.requestFocus();
                  },
                  textInputAction: TextInputAction.next,
                ),
                CustomInput(
                  hintText: 'Password',
                  onChanged: (value) {
                    _loginPassword = value;
                  },
                  onSubmitted: (value) {
                    _submitForm();
                  },
                  focusNode: _passwordFocusNode,
                  isPasswordField: true,
                ),
                CustomBtn(
                  text: 'Login',
                  onPressed: () {
                    _submitForm();
                  },
                  isLoading: _loginFormLoading,
                )
              ],
            ),
            // Padding(
            //     padding: const EdgeInsets.only(bottom: 16.0),
            //     child: Text(
            //       '"Eat good, feel good.."',
            //       style: TextStyle(color: Colors.white, fontSize: 18),
            //     )),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: CustomBtn(
                text: 'Create New Account',
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RegisterPage()));
                },
                outlineBtn: true,
              ),
            )
          ],
        ),
      )),
    );
  }
}
