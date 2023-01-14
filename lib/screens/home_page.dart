import 'package:flutter/material.dart';
import 'package:food_delivery/services/firebase_services.dart';
import 'package:food_delivery/tabs/profile_tab.dart';
import 'package:ionicons/ionicons.dart';
import '../tabs/menu_tab.dart';
import '../tabs/saved_tab.dart';
import '../tabs/search_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _tabsPageController;
  int _selectedTab = 0;

  FirebaseServices _firebaseServices = FirebaseServices();

  @override
  void initState() {
    print("UserID: ${_firebaseServices.getUserId()}");
    _tabsPageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _tabsPageController.dispose();
    super.dispose();
  }

  int pageIndex = 0;

  final pages = [
    MenuTab(),
    SearchTab(),
    SavedTab(),
    ProfileTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[pageIndex],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Ionicons.home_outline,
                  size: 28,
                ),
                //activeIcon: Icon(Ionicons.home, size: 28),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search_outlined, size: 28),
                //activeIcon: Icon(Ionicons.search, size: 28),
                label: 'Sources',
              ),
              BottomNavigationBarItem(
                icon: Icon(Ionicons.heart_outline, size: 28),
                //activeIcon: Icon(Ionicons.heart, size: 28),
                label: 'Countries',
              ),
              BottomNavigationBarItem(
                icon: Icon(Ionicons.person_circle_outline, size: 28),
                //activeIcon: Icon(Ionicons.log_out, size: 28),
                label: 'Profile',
              ),
            ],
            currentIndex: pageIndex,
            selectedItemColor: Theme.of(context).colorScheme.secondary,
            onTap: _onItemTapped,
            unselectedItemColor: Colors.black54,
            showSelectedLabels: false,
            showUnselectedLabels: false,
          ),
    );
  }
}
