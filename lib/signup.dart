import 'dart:io';
import 'dart:math';

import 'package:chat_app/chatroom.dart';
import 'package:chat_app/firebasepage.dart';
import 'package:chat_app/helperfunction.dart';
import 'package:chat_app/loginpage.dart';
import 'package:chat_app/namepage.dart';
import 'package:chat_app/searchPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var _keyform=GlobalKey<FormState>();
  TextEditingController _namecontroller=TextEditingController();
  TextEditingController _emailcontroller= TextEditingController();
  TextEditingController _passwordcontroller= TextEditingController();
  FirePage firePage=new FirePage();
  Helper helper=new Helper();
  QuerySnapshot querySnapshot;
  File _image;
  String urlimage;
 bool  isloading=false;

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
                  child: Center(child: Text('Sign up',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Column(
                      children: [
                        Form(
                          key: _keyform,
                            child: Column(
                              children: [
                             TextFormField(
                               controller: _namecontroller,
                            validator: (val){
                              if(val.isEmpty){
                                return 'please enter the Name';
                              }
                              return null ;
                            },

                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: Colors.white),

                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              labelStyle: TextStyle(color: Colors.white,fontSize: 20),

                              labelText: 'Name',
                              hintText: 'please enter the correct name',
                              prefixIcon: Icon(Icons.vpn_key,color: Colors.white,),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Colors.white,
                                      width: 5)
                              ),

                            ),
                          ),
                          SizedBox(height: 20,),
                          TextFormField(
                            controller: _emailcontroller,
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
                            controller: _passwordcontroller,
                            obscureText: true,
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
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: InkWell(onTap: (){},child: Text('Forget the password!!')),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Text("choose your picture for your profile"),
                    InkWell(
                          child: Container(width: 60,height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      image: DecorationImage(

                          image:urlimage!=null? NetworkImage(urlimage.toString()):
                              ExactAssetImage('images/person-icon.png'),

                      fit: BoxFit.cover,

                      )
                    )),
                      onTap: ()async{
                           await getimage();
                      },
                    ),


                  ],),
                ),

                Center(
                  child: FlatButton(
                    onPressed: (){

                      signup();
                  }


                           ,child: Text('SIGN UP'),color: Colors.red,padding: EdgeInsets.symmetric(horizontal: 12,vertical: 7),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text('if you have the count?? '),
                      InkWell(onTap:(){
                        Navigator.pushReplacement(context,MaterialPageRoute(builder:(context){
                          return Login();
                        } ));
                      }
                       ,child: Text('login',
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
  doloading(BuildContext context){
    return Center(child: CircularProgressIndicator());
  }
   signup() async{
     final User user = await FirebaseAuth.instance.currentUser;
    try{
      if(_keyform.currentState.validate()){
        UserCredential user=await FirebaseAuth.instance.
        createUserWithEmailAndPassword(
            email: _emailcontroller.text,
            password: _passwordcontroller.text);
        if(user.user==null){
          print("no user");
        }else{
          print('yes user');
          Helper.setmyname(_namecontroller.text);

          setState(() {
            isloading=true;
          });
          print('object2132');
          Map<String , String>data={
            'email':_emailcontroller.text,
            'name':_namecontroller.text,
            'image':urlimage.toString(),
            'uid' :user.user.uid.toString(),
          };
            print('fsdfd22');
          firePage.infoPersonal(data);
          print('goooooo');
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder:(context){
                return SearchPage();
              }
          ), (route) => false);
        }
      }
    }catch(e){
      print("ddf"+e.toString());
    }

  }
  Future getimage()async{
    final _picker=ImagePicker();
   PickedFile image;
   image = await _picker.getImage(source: ImageSource.gallery);
   var file = File(image.path);

    String name =Random().nextInt(1000).toString()+ '_product';
    var snapshot = await FirebaseStorage.instance.ref()
        .child(name).putFile(file).onComplete;
   // final StorageUploadTask uploadTask =  storageReference.putFile(image);
 //   StorageTaskSnapshot response=await uploadTask.onComplete;
    var dowoloadUrl = await snapshot.ref.getDownloadURL();
    setState(() {
      urlimage=dowoloadUrl;
      Helper.setimage(urlimage.toString());
    });
  }

}
