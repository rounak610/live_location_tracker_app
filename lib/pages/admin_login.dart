import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:llt/pages/admin_page.dart';
import 'package:pinput/pinput.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({Key? key}) : super(key: key);

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  late int password = 787862;
  late int input;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Live Location Tracker"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Enter password",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Pinput(
                controller: pinController,
                focusNode: focusNode,
                length: 6,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                pinAnimationType: PinAnimationType.fade,
                onChanged: (value) {
                  setState(() {
                    input = int.parse(
                        value); // this is the right way to convert string to int
                  });
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  if (input == password) {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AdminPage()));
                  } else if (input != password) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Wrong password"),
                      duration: Duration(seconds: 1),
                    ));
                  }
                } catch (e) {
                  print(e);
                }
              },
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
