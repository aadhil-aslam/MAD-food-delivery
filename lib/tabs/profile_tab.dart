import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/screens/orders/orders_list.dart';
import '../constants.dart';
import '../screens/admin/admin.dart';
import '../services/firebase_services.dart';
import '../widgets/home_action_bar.dart';

class ProfileTab extends StatefulWidget {
  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final FirebaseServices _firebaseServices = FirebaseServices();

  Future _alertDialogBuilder() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text("Logout"),
            content: Container(child: Text("Logout your account?")),
            actions: [
              TextButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pop(context);
                  },
                  child: const Text("Logout")),
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"))
            ],
          );
        });
  }

  authorizeAccess(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((docs) {
        if (docs.docs[0].exists) {
          if (docs.docs[0]['role'] == 'admin') {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => const AdminPage()));
            print("Authorized");
          } else {
            _noAuthAlert();
            print("Not Authorized");
          }
        } else {
          _noAuthAlert();
          print("Not Authorized");
        }
      });
    } catch (e) {
      _noAuthAlert();
    }
  }

  Future _noAuthAlert() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Container(child: Text("User not authorized")),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context), child: Text("Ok"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HomeAppBar(),
          // CustomActionBar(
          //   title: "Profile",
          // ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => OrdersList()));
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: Row(
                children: const [
                  Icon(Icons.shopping_bag),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text("Orders", style: Constants.regularDarkText),
                  ),
                ],
              ),
            ),
          ),
          // const Padding(
          //   padding: EdgeInsets.symmetric(
          //       horizontal: 24.0),
          //   child: Divider(
          //     color: Colors.black38, thickness: 0.5,
          //   ),
          // ),
          GestureDetector(
            onTap: () {
              authorizeAccess(context);
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
              child: Row(
                children: const [
                  Icon(Icons.admin_panel_settings),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text("Admin", style: Constants.regularDarkText),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _alertDialogBuilder();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: const [
                  Icon(Icons.logout),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text("Logout", style: Constants.regularDarkText),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
