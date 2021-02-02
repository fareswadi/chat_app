import 'package:chat_app/firebasepage.dart';
import 'package:chat_app/helperfunction.dart';
import 'package:chat_app/searchPage.dart';
import 'package:chat_app/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _email=TextEditingController();
  TextEditingController _password=TextEditingController();
  var _key=GlobalKey<FormState>();
  QuerySnapshot snapshot;
   FirePage firePage=FirePage();

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
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: Center(child: Text('My CHAT APP',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Form(
                      key: _key,
                        child: Column(
                          children: [
                         TextFormField(
                           controller: _email,
                        validator: (val){
                          if(val.isEmpty){
                            return 'please enter the email';
                          }
                          return null ;
                        },
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)
                          ),

                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.white,fontSize: 20),
                          hintText: 'please enter the correct email',
                          prefixIcon: Icon(Icons.email,color: Colors.white,),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.white,
                                  width: 5)
                          ),

                        ),
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        controller: _password,
                        validator: (val){
                          if(val.isEmpty){
                            return 'please enter the password';
                          }
                          return null ;
                        },

                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.white),

                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)
                          ),
                          labelStyle: TextStyle(color: Colors.white,fontSize: 20),

                          labelText: 'Password',
                          hintText: 'please enter the correct password',
                          prefixIcon: Icon(Icons.vpn_key,color: Colors.white,),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.white,
                                  width: 5)
                          ),

                        ),
                      ),
                    ],)),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: InkWell(onTap: (){},child: Text('Forget the password!!')),
              ),
              SizedBox(height: 20,),

              Center(
                child: FlatButton(onPressed: (){
                  if(_key.currentState.validate()){
                    firePage.logo(_email.text, _password.text);
                    if(FirebaseAuth.instance.currentUser!=null){
                      firePage.getemailuser(_email.text).then((value){
                        snapshot= value ;
                        Helper.setmyname(snapshot.docs[0].data()['name']);
                        print('soosoydd${snapshot.docs[0].data()['name']}');
                          }


                      );
                      Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context){
                        return SearchPage();
                      }));
                    }

                  }
                }, child: Text('LOGIN'),color: Colors.red,padding: EdgeInsets.symmetric(horizontal: 12,vertical: 7),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),),
              ),
              SizedBox(height: 20,),

              Center(
                child: FlatButton(onPressed: (){}, child: Text('LOGIN WITH Google'),color: Colors.white,padding: EdgeInsets.symmetric(horizontal: 12,vertical: 7),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text('if you Dont have the count?? '),
                    InkWell(onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder:(context){
                        return SignUp();
                      } ));
                     },child: Text('sign up',
                      style: TextStyle(fontWeight: FontWeight.w800,color: Colors.white,wordSpacing: 5,backgroundColor: Colors.amber,fontSize: 18,decoration: TextDecoration.underline),),)
                  ],
                ),
              ),
              SizedBox(height: 50,),


            ],
          ),
        ),
      ),
    ],
    );
  }
}
