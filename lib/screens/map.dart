import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../services/firebase_services.dart';

class CurrentLocationScreen extends StatefulWidget {
  final bool? floatingActionButton;
  final bool? label;
  final bool? hasBackArrow;
  final Function(String)? onSelected;
  CurrentLocationScreen(
      {this.floatingActionButton,
      this.label,
      this.hasBackArrow,
      this.onSelected});

  @override
  _CurrentLocationScreenState createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<CurrentLocationScreen> {
  FirebaseServices _firebaseServices = FirebaseServices();

  String Address = "Address";
  double lat = 6.939052;
  double long = 79.893018;

  bool _loading = false;

  void getCurrentLocation() async {
    _loading = true;
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      point.latitude = position.latitude;
      point.longitude = position.longitude;
      getUserLocation(position.latitude, position.longitude);
      _loading = false;
    });
    print(position);
  }

  _fetchAddress() async {
    final firebaseUser = await FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(_firebaseServices.getUserId())
          .get()
          .then((ds) {
        Address = ds.data()!['Address'];
        lat = ds.data()!['latitude'];
        long = ds.data()!['longitude'];
        getRegLocation(lat, long);
        widget.onSelected!(Address);
        //getUserCoordinates(Address);
        setState(() {});
      }).catchError((e) {});
    } else {
      Address = 'Address';
      lat = 6.939052;
      long = 79.893018;
      getRegLocation(lat, long);
    }
  }

  CustomPoint _textPos = const CustomPoint(10.0, 10.0);

  late MapController _mapController;

  @override
  void initState() {
    super.initState();
    _fetchAddress();
    _mapController = MapController();
  }

  LatLng point = LatLng(6.939052, 79.893018);
  Placemark place = Placemark();

  getRegLocation(latitude, longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    place = placemarks[0];
    print(place);
    setState(() {
      Address =
          "${place.street}, ${place.locality}, ${place.subAdministrativeArea}";
      place = place;
      point.latitude = latitude;
      point.longitude = longitude;
      print(point.latitude);
      print(point.longitude);
    });
  }

  getUserLocation(latitude, longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    place = placemarks[0];
    print(place);
    setState(() {
      Address =
          "${place.street}, ${place.locality}, ${place.subAdministrativeArea}";
      place = place;
      point.latitude = latitude;
      point.longitude = longitude;
      print(point.latitude);
      print(point.longitude);
    });
  }

  Location loc =
      Location(latitude: 60.0, longitude: 12.0, timestamp: DateTime.now());

  Future<void> _alertDialogBuilder(String error) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Set address?"),
            content: Container(child: Text(error)),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel")),
              TextButton(
                  onPressed: () {
                    _firebaseServices.usersRef
                        .doc(_firebaseServices.getUserId())
                        .set({
                      "Address":
                          "${place.street}, ${place.locality}, ${place.subAdministrativeArea}",
                      "latitude": point.latitude,
                      "longitude": point.longitude
                    }, SetOptions(merge: true));
                    _fetchAddress();
                    Navigator.pop(context);
                  },
                  child: Text("Set"))
            ],
          );
        });
  }

  bool hasSubmitButton = false;

  @override
  Widget build(BuildContext context) {
    bool _label = widget.label ?? true;
    bool _hasBackArrow = widget.hasBackArrow ?? false;

    return Scaffold(
      body: SafeArea(
        child: _loading == true
            ? Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
                Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: Text("Fetching current location. Please wait"),
                )
              ],
            ))
            : Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                        onTap: (tapPosition, point) {
                          //getUserCoordinates(Address);
                          setState(() {
                            hasSubmitButton = true;
                            point = point;
                          });
                          getUserLocation(point.latitude, point.longitude);
                          final pt1 = _mapController.latLngToScreenPoint(point);
                          _textPos = CustomPoint(pt1!.x, pt1.y);
                        },
                        center: point,
                        zoom: 17.0),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: const ['a', 'b', 'c'],
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: point,
                            builder: (context) => const Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 60,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (_label)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              if (_hasBackArrow)
                                Padding(
                                    padding: EdgeInsets.only(right: 16.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                          width: 42.0,
                                          height: 42.0,
                                          decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(8.0)),
                                          child: const Icon(
                                            Icons.arrow_back_ios_new,
                                            color: Colors.white,
                                            size: 18,
                                          )),
                                    )),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(Address ?? "Address"),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              if (hasSubmitButton)
                                Padding(
                                    padding: EdgeInsets.only(left: 16.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        _alertDialogBuilder(
                                            "${place.street}, ${place.locality}, ${place.subAdministrativeArea}");
                                      },
                                      child: Container(
                                          width: 42.0,
                                          height: 42.0,
                                          decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(8.0)),
                                          child: const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 20,
                                          )),
                                    )),
                            ],
                          ),
                        ],
                      ),
                    ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getCurrentLocation();
          setState(() {
            hasSubmitButton = true;
            point = point;
          });
        },
        child: Icon(Icons.my_location),
      ),
    );
  }
}
