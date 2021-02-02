import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirePage{
 var user = FirebaseAuth.instance.currentUser;
 Future logo(String email , String password)async {
   await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
 }
 Future signup(String email , String password)async{
  await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
 }
 search(String searchName)async{
  return await FirebaseFirestore.instance.collection("user").where("name",isEqualTo: searchName).get();
 }
 getimage(String currentuser)async{
  return await FirebaseFirestore.instance.collection("user").where("uid",isEqualTo: currentuser).get();
 }
 getemailuser(String email)async{
  return await FirebaseFirestore.instance.collection("user").where("email",isEqualTo: email).get();
 }
 infoPersonal(data)async{
  return await FirebaseFirestore.instance.collection("user").doc().set(data);
 }
 createroom(String chatRoomId , data){
    FirebaseFirestore.instance.collection('chatRoom').doc(chatRoomId).set(data).catchError((e){
   print("sosoos${e.toString()}");
  });
 }
 sendConversation(String chatRoomId,messageMap){
  FirebaseFirestore.instance.collection('chatRoom')
      .doc(chatRoomId).
  collection('conversation').
  add(messageMap).catchError((e){
   print(e.toString());
  });
 }
 getConversation(String chatRoomId)async{
  return await FirebaseFirestore.instance.collection('chatRoom')
      .doc(chatRoomId).
  collection('conversation').orderBy("time",descending: false).
  snapshots();
 }
}