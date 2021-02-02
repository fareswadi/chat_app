import 'package:chat_app/firebasepage.dart';
import 'package:chat_app/namepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class ChatRoom extends StatefulWidget {
  final String chatRoomId;

  ChatRoom(this.chatRoomId);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
 TextEditingController _message=TextEditingController();
 FirePage firePage=new FirePage();
 QuerySnapshot snapshot;
 Stream chatMessageStream;
 Widget ChatMessageList() {
   return
      StreamBuilder(
       stream: chatMessageStream,
       builder: (context, snapshot){
        return snapshot.data!=null?
          ListView.builder(
           itemCount: snapshot.data.documents.length,
           itemBuilder: (context, index) {
             return MessageTile(snapshot.data.documents[index].data()["message"],
                 snapshot.data.documents[index].data()["sendby"]==NamePage.myname);
           },
         ):Container();
       },
     );

 }

/* Widget getmessage(){


   return StreamBuilder(
       stream: streamchange ,
       builder:(context ,  snapshot){


           return ListView.builder(
               itemCount: snapshot.data.documents.length,
               itemBuilder: (context , index){
                 //querySnapshot.docs[index].data()['name']
                 return MessageTile(snapshot.data.documents[index].data()['message'],
                     snapshot.data.snapshot.data.documents[index].data()['sendby']==NamePage.myname);

               });


   });
 }*/
 sendmessage(){

   if(_message.text.isNotEmpty){
     Map<String , String> messageMap={
       "message":_message.text,
       "sendby":NamePage.myname,
       "time": DateTime.now().microsecondsSinceEpoch.toString()
     };
     firePage.sendConversation(widget.chatRoomId, messageMap);
     _message.text="";
   }
 }

 @override
  void initState() {
      if(firePage.getConversation(widget.chatRoomId)!=null){
        firePage.getConversation(widget.chatRoomId).then((value){
          setState(() {
            chatMessageStream=value;
          });
        });
      }else{
         Container();
      }



    super.initState();
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
          body : Stack(
            children: [
              ChatMessageList(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextFormField(
                      controller: _message,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.white),

                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)
                        ),
                        labelStyle: TextStyle(color: Colors.white,fontSize: 20),
                        hintText: 'message...',

                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.white,
                                width: 5)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white,
                                width: 2)
                        )

                      ),
                    ),
                  ],
                ),
              ),
              Positioned(left: MediaQuery.of(context).size.width*0.88,
                top: MediaQuery.of(context).size.height*0.91
                 , child: IconButton(icon: Icon(Icons.send), onPressed: (){
                   sendmessage();
                  },
                    color: Colors.white,))

            ],
          ),
        ),

      ],
    );
  }
}
class MessageTile extends StatelessWidget {
  @override
  final String message;
  final bool issendby;

  MessageTile(this.message,this.issendby);

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12),
      alignment: issendby ? Alignment.centerLeft : Alignment.centerRight,
      width: MediaQuery.of(context).size.width,

      child: Container(
        decoration: BoxDecoration(
            color: issendby ? Colors.red :Colors.green,
          borderRadius: issendby ?
              BorderRadius.only(
                topRight: Radius.circular(25),
                bottomRight: Radius.circular(25),
                topLeft: Radius.circular(25)
              ):
          BorderRadius.only(
              topRight: Radius.circular(25),
              bottomLeft: Radius.circular(25),
              topLeft: Radius.circular(25)
          )

        ),
        padding: EdgeInsets.symmetric(horizontal: 14,vertical: 8),
        child: Text(message , style:  TextStyle(fontSize: 17,fontWeight: FontWeight.w600),),

      ),
    );
  }
}
