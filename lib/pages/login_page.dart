import 'package:flutter/material.dart';
import 'package:llt/pages/admin_login.dart';
import 'package:llt/pages/user_login.dart';
import 'package:llt/pages/user_pg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Live Location Tracker"),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AdminLogin()));
                    },
                    child: Text("Admin login")),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => UserLogin()));
                  },
                  child: Text("User login"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
