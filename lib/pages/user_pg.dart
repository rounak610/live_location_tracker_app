import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'login_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key, required this.data}) : super(key: key);
  final String data;

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;
  late String id = widget.data;
  @override
  void initState() {
    super.initState();
    _requestPermission();
    location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
    location.enableBackgroundMode(enable: true);
  }

  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Live Location Tracker"),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => LoginPage()));
            },
            icon: Icon(Icons.arrow_back_outlined)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: Text("User Id : ${id}",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold))),
          Center(
            child: FutureBuilder<bool>(
              builder: (context, snapshot) {
                // print("rerun");
                if (snapshot.hasData) {
                  if (snapshot.data!) {
                    return Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Status : ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.bold)),
                        Text("Data exist",
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 25,
                                fontWeight: FontWeight.bold)),
                      ],
                    ));
                  }
                  return Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Status : ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold)),
                      Text("Data doesn't exist",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 25,
                              fontWeight: FontWeight.bold)),
                    ],
                  ));
                }
                return const Center(child: CircularProgressIndicator());
              },
              future: isDocumentExist(id),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Center(
            child: ElevatedButton(
                onPressed: () async {
                  await _getLocation();
                  setState(() {});
                },
                child: Text("Add my location")),
          ),
          SizedBox(height: 10),
          Center(
            child: ElevatedButton(
                onPressed: () {
                  _listenLocation();
                },
                child: Text("Enable live location")),
          ),
          SizedBox(height: 10),
          Center(
            child: ElevatedButton(
                onPressed: () {
                  _stopListening();
                },
                child: Text("End live location")),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: ElevatedButton(
                onPressed: () async {
                  await _delete_data();
                  setState(() {});
                },
                child: Text("Remove location")),
          ),
        ],
      ),
    ));
  }

  Future<bool> isDocumentExist(String doc) async {
    DocumentSnapshot<Map<String, dynamic>> document =
        await FirebaseFirestore.instance.collection("location").doc(doc).get();
    if (document.exists) {
      return true;
    } else {
      return false;
    }
  }

  _getLocation() async {
    try {
      final loc.LocationData _locationResult = await location.getLocation();
      await FirebaseFirestore.instance.collection('location').doc(id).set({
        'latitude': _locationResult.latitude,
        'longitude': _locationResult.longitude,
        'ID': id
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
    Fluttertoast.showToast(msg: "Location data for ${id} added");
  }

  Future<void> _listenLocation() async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentlocation) async {
      await FirebaseFirestore.instance.collection('location').doc(id).set({
        'latitude': currentlocation.latitude,
        'longitude': currentlocation.longitude,
        'ID': id
      }, SetOptions(merge: true));
    });
  }

  _stopListening() {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
  }

  _requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print('done');
    } else if (status.isDenied) {
      _requestPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  _delete_data() async {
    await FirebaseFirestore.instance.collection('location').doc(id).delete();
    Fluttertoast.showToast(msg: "Location data for ${id} deleted");
  }
}
