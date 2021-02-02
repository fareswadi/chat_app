import 'package:chat_app/chatroom.dart';
import 'package:chat_app/firebasepage.dart';
import 'package:chat_app/helperfunction.dart';
import 'package:chat_app/namepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  FirePage firePage = FirePage();
  TextEditingController searchName = TextEditingController();
  QuerySnapshot querySnapshot;
  QuerySnapshot querySnapshot2;

  NamePage namePage = new NamePage();

  namestorage() async {
    NamePage.myname = await Helper.getmyname();
  }

  createconversation(BuildContext context, String username) {
    print('yesssssssss2');

    namestorage();

    print('yesssssssss3');

    String chatRoomId = getchatRoomId(username, NamePage.myname);
    print("object${NamePage.myname}");
    List<String> users = [username, NamePage.myname];
    Map<String, dynamic> chatRoommap = {
      'user': users,
      'chatRoomId': chatRoomId
    };
    print('yesssssssss');
    firePage.createroom(chatRoomId, chatRoommap);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ChatRoom(chatRoomId);
    }));
  }

  searchuid() async {
    final User user = await FirebaseAuth.instance.currentUser;
    firePage.getimage(user.uid.toString()).then((val) {
      print('sdwwwwww');
      setState(() {
        querySnapshot2 = val;
      });
    });
  }

  searchmethods() {
    firePage.search(searchName.text).then((val) {
      print('sccdddcccc');
      setState(() {
        print(val + "sosososo");
        querySnapshot = val;
      });
    });
  }

  Widget searchList() {
    return querySnapshot != null
        ? ListView.builder(
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(
                      querySnapshot.docs[index].data()['name'],
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    subtitle: Text(
                      querySnapshot.docs[index].data()['email'],
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.grey,
                          fontWeight: FontWeight.w800),
                    ),
                    onTap: () {
                      createconversation(context, searchName.text);
                    },
                  )
                ],
              );
            },
            itemCount: querySnapshot.docs.length,
            shrinkWrap: true,
          )
        : Center(child: Text('no data'));
  }

  String uid;
  String name;
  String email;
  String urlimage;

  void initState() {
    super.initState();
    namestorage();
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('user')
          .where('uid', isEqualTo: user.uid)
          .get()
          .then((snapshot) => setState(() {
                uid = user.uid;
                name = snapshot.docs[0].data()['name'];
                email = snapshot.docs[0].data()['email'];
                urlimage = snapshot.docs[0].data()['image'];
              }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                Color(0xFF0F52BA),
                Color(0xFF6593F5),
                Color(0xFF4682B4),
              ],
                  stops: [
                0.33,
                0.66,
                0.99
              ])),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              searchmethods();
            },
            child: Icon(Icons.search),
          ),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            title: Text('CHAT APP'),
            centerTitle: true,
          ),
          drawer: Drawer(
              child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: name != null ? Text(name) : Text('username'),
                accountEmail:
                    email != null ? Text(email) : Text('email address'),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: urlimage != null
                      ? NetworkImage(urlimage)
                      : ExactAssetImage('images/person-icon.png'),
                ),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                      Color(0xFF0F52BA),
                      Color(0xFF6593F5),
                      Color(0xFF4682B4),
                    ],
                        stops: [
                      0.33,
                      0.66,
                      0.99
                    ])),
              ),
            ],
          )),
          body: Padding(
            padding: const EdgeInsets.only(top: 22, left: 12, right: 12),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: searchName,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                      labelText: 'search',
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              BorderSide(color: Colors.white, width: 5)),
                    ),
                  ),
                  searchList(),
                  //_drawProducts()
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  getchatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > a.substring(0, 1).codeUnitAt(0)) {
      return '$b\_$a';
    } else {
      return '$a\_$b';
    }
  }

  Widget _drawProducts() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('user').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return ListView(
              shrinkWrap: true,
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                return ListTile(
                  title: Text(document['name']),
                  subtitle: Text(document['email']),
                  trailing: (document['image'] != null)
                      ? SizedBox(
                          width: 150,
                          height: 150,
                          child: Image(
                            image: NetworkImage(document['image'][0]),
                            fit: BoxFit.cover,
                          ),
                        )
                      : SizedBox(
                          height: 0,
                          width: 0,
                        ),
                );
              }).toList(),
            );
        }
      },
    );
  }
}
