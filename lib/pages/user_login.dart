import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:llt/pages/user_pg.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({Key? key}) : super(key: key);

  @override
  State<UserLogin> createState() => _UserLoginState();
}
//GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _UserLoginState extends State<UserLogin> {
  TextEditingController _controller = TextEditingController();
  late String id;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Live Location Tracker"),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    hintText: 'Enter your BITS ID',
                    hintStyle: TextStyle(color: Colors.grey),
                    labelText: 'BITS-ID',
                    labelStyle: TextStyle(color: Colors.black)),
                inputFormatters: [
                  new LengthLimitingTextInputFormatter(13),
                ],
                onChanged: (value) {
                  setState(() {
                    id = value;
                  });
                },
                // validator: (value) {
                // //   if(value!.isEmpty)
                // //     {
                // //       return "Please enter your BITS-ID";
                // //     }
                // //   else
                // //     {
                // //       return null;
                // //     }
                // },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () async {
                  if (id.isNotEmpty || id != null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserPage(data: id)));
                  } else {
                    print("error");
                  }
                },
                child: Text("Login")),
          ],
        ),
      ),
    );
  }
}
