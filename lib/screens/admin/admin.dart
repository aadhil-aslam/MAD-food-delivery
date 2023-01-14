import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/screens/admin/add%20product.dart';
import 'package:food_delivery/screens/admin/orders.dart';
import '../../constants.dart';
import '../../services/firebase_services.dart';
import '../../widgets/custom_btn.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final FirebaseServices _firebaseServices = FirebaseServices();

  int users = 0;
  int orders = 0;
  int products = 0;
  double accepted = 0;
  double pending = 0;
  double cancelled = 0;
  double completed = 0;

  _fetchAccepted() async {
    await _firebaseServices.orderRef
        .where('status', isEqualTo: "Accepted")
        .get()
        .then((ds) {
      setState(() {
        accepted = ds.docs.length.toDouble();
        print(accepted);
      });
    }).catchError((e) {
    });
  }

  _fetchUsers() async {
    await _firebaseServices.usersRef.get().then((ds) {
      setState(() {
        users = ds.docs.length;
        print(users);
      });
    }).catchError((e) {
    });
  }

  _fetchAllOrders() async {
    await _firebaseServices.orderRef.get().then((ds) {
      setState(() {
        orders = ds.docs.length;
        print(orders);
      });
    }).catchError((e) {
    });
  }

  _fetchAllProducts() async {
    await _firebaseServices.productRef.get().then((ds) {
      setState(() {
        products = ds.docs.length;
        print(products);
      });
    }).catchError((e) {
    });
  }

  _fetchCancelled() async {
    await _firebaseServices.orderRef
        .where('status', isEqualTo: "Cancelled")
        .get()
        .then((ds) {
      setState(() {
        cancelled = ds.docs.length.toDouble();
        print(cancelled);
      });
    }).catchError((e) {});
  }

  _fetchPending() async {
    await _firebaseServices.orderRef
        .where('status', isEqualTo: "Order Placed")
        .get()
        .then((ds) {
      setState(() {
        pending = ds.docs.length.toDouble();
        print(pending);
      });
    }).catchError((e) {});
  }

  _fetchDelivered() async {
    await _firebaseServices.orderRef
        .where('status', isEqualTo: "Delivered")
        .get()
        .then((ds) {
      setState(() {
        completed = ds.docs.length.toDouble();
        print(completed);
      });
    }).catchError((e) {});
  }

  @override
  void initState() {
    _fetchAccepted();
    _fetchPending();
    _fetchCancelled();
    _fetchDelivered();
    _fetchUsers();
    _fetchAllOrders();
    _fetchAllProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 30.0, 24.0, 24.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                        width: 42.0,
                        height: 42.0,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8.0)),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 18,
                        )),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text("Admin", style: Constants.boldHeading),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 24.0, right: 10),
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: const Color(0xFFF2F2F2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: const [
                                      Icon(
                                        Icons.article,
                                        size: 26.0,
                                      ),
                                      SizedBox(
                                        width: 15.0,
                                      ),
                                      Text(
                                        "Total Orders",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    "$orders Orders",
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 24.0, left: 10),
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: const Color(0xFFF2F2F2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: const [
                                      Icon(
                                        Icons.person,
                                        size: 26.0,
                                      ),
                                      SizedBox(
                                        width: 15.0,
                                      ),
                                      Text(
                                        "Total Users",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    "$users Users",
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 20),
                    child: Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: const Color(0xFFF2F2F2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.fastfood,
                                  size: 26.0,
                                ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                Text(
                                  "Total Products",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              "$products Products",
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: const Color(0xFFF2F2F2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Center(
                          child: Column(
                            children: [
                              const Padding(
                                padding:
                                    EdgeInsets.only(bottom: 5.0, top: 5),
                                child: Text("Orders",
                                    style: Constants.boldHeading),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 34.0),
                                      child: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              4,
                                          child: PieChart(
                                            PieChartData(
                                              borderData: FlBorderData(
                                                show: false,
                                              ),
                                              sectionsSpace: 0,
                                              centerSpaceRadius: 0,
                                              sections: showingSections(
                                                  accepted,
                                                  pending,
                                                  cancelled,
                                                  completed),
                                            ),
                                          )),
                                    ),
                                  ),
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.only(left: 50.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                                color: const Color(0xff13d38e),
                                              ),
                                              height: 10,
                                              width: 10,
                                            ),
                                            const Expanded(
                                                child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 15.0),
                                              child: Text("Accepted"),
                                            ))
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15.0),
                                          child: Row(
                                            children: [
                                              Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2),
                                                    color: const Color(0xfff8b250),
                                                  ),
                                                  height: 10,
                                                  width: 10),
                                              const Expanded(
                                                  child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 15.0),
                                                child: Text("Pending"),
                                              ))
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15.0),
                                          child: Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                  color: Colors.red.shade400,
                                                ),
                                                height: 10,
                                                width: 10,
                                              ),
                                              const Expanded(
                                                  child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 15.0),
                                                child: Text("Cancelled"),
                                              ))
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15.0),
                                          child: Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                  color: const Color(0xff0293ee),
                                                ),
                                                height: 10,
                                                width: 10,
                                              ),
                                              const Expanded(
                                                  child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 15.0),
                                                child: Text("Completed"),
                                              ))
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                CustomBtn(
                  text: 'Manage Orders',
                  onPressed: () {
                    Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const AdminOrders()))
                        .then((value) {
                      setState(() {});
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 14.0),
                  child: CustomBtn(
                    text: 'Add products',
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddProduct()));
                    },
                    //isLoading: _registerFormLoading,
                  ),
                )
              ],
            ),
          ],
        ),
      )),
    );
  }

  List<PieChartSectionData> showingSections(
      double accepted, double pending, double cancelled, double completed) {
    return List.generate(4, (i) {
      final fontSize = 10.0;
      final radius = 90.0;

      String acceptedP = (accepted / orders * 100).toStringAsFixed(1);
      String completedP = (completed / orders * 100).toStringAsFixed(1);
      String cancelledP = (cancelled / orders * 100).toStringAsFixed(1);
      String pendingP = (pending / orders * 100).toStringAsFixed(1);

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff13d38e),
            value: accepted,
            title: "$acceptedP%",
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
            badgePositionPercentageOffset: .98,
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: pending,
            title: "$pendingP%",
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
            badgePositionPercentageOffset: .98,
          );
        case 2:
          return PieChartSectionData(
            color: Colors.red.shade400,
            value: cancelled,
            title: "$cancelledP%",
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
            badgePositionPercentageOffset: .98,
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: completed,
            title: "$completedP%",
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
            badgePositionPercentageOffset: .98,
          );
        default:
          throw Exception('Oh no');
      }
    });
  }
}
