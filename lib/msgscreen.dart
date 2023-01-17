import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List lst = [];
  String? a;
  String? img;
  TextEditingController txtcontroller = TextEditingController();

  @override
  void initState() {
    uid();
    super.initState();
  }

  uid() async {
    final pref = await SharedPreferences.getInstance();
    a = pref.getString('uid');
    img = pref.getString('img');
    print('?????????????????????????????????${a}${img}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Container(
            height: 70,
            width: 400,
            color: Colors.teal,
            child: ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  GoogleSignIn().signOut();
                },
                child: const Text('logout')),
          ),
          Expanded(
              // flex: 12,
              child: Container(
            child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('chats').snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  print(
                      '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${snapshot.data}');
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data == null) {
                    return Center(
                      child: Text('No data'),
                    );
                  } else {
                    return ListView.builder(
                      reverse: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        List<QueryDocumentSnapshot<Map<String, dynamic>>> lst =
                            snapshot.data!.docs;
                        lst.sort((a, b) {
                          print(a.data()['time']);
                          print(b.data()['time']);

                          return b.data()['time'].compareTo(a.data()['time']);
                        });
                        return Align(
                          alignment: a == lst[index]['uid']
                              ? Alignment.bottomRight
                              : Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                            child: Chip(
                              avatar: CircleAvatar(
                                  backgroundImage: NetworkImage(lst[index]
                                          ['image'] ??
                                      'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.pngitem.com%2Fso%2Fprofile-icon%2F&psig=AOvVaw0IX78pDv6x92qMnnSokWHb&ust=1667025664776000&source=images&cd=vfe&ved=0CA0QjRxqFwoTCNjbxdiogvsCFQAAAAAdAAAAABAE')),
                              label: Text(lst[index]['message'],
                                  style: const TextStyle(fontSize: 19)),
                              padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
                            ),
                          ),
                        );
                      },
                    );
                  }
                }),
          )),
          SizedBox(
              height: 70,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: SizedBox(
                      height: 60,
                      width: 340,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                        child: TextField(
                            controller: txtcontroller,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                                suffixIcon: Icon(
                                  Icons.face,
                                ))),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 70,
                    width: 50,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                      child: IconButton(
                          onPressed: () {
                            if (txtcontroller.text.isEmpty) {
                            } else {
                              FirebaseFirestore.instance
                                  .collection('chats')
                                  .add({
                                'message': txtcontroller.text,
                                'time': DateTime.now().toString(),
                                'uid': a,
                                'image': img
                              });
                              txtcontroller.clear();
                            }
                          },
                          icon: const Icon(
                            Icons.send_rounded,
                            size: 45,
                          )),
                    ),
                  )
                ],
              ))
        ],
      )),
    );
  }
}
