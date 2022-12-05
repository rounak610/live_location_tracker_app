import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:llt/pages/login_page.dart';
import 'package:llt/pages/my_map.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
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
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('location').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(snapshot.data!.docs[index]['ID'].toString()),
                    subtitle: Row(
                      children: [
                        Text(snapshot.data!.docs[index]['latitude'].toString(),),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                            snapshot.data!.docs[index]['longitude'].toString()),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.directions),
                      color: Colors.red,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                MyMap(snapshot.data!.docs[index].id)));
                      },
                    ),
                  );
                });
          }),
    ));
  }
}
