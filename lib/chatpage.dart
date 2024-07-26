import 'package:baatein/home.dart';
import 'package:baatein/services/database.dart';
import 'package:baatein/services/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

class chats extends StatefulWidget {
  String name,profileUrl,username;
chats({required this.name,required this.profileUrl,required this.username});
  @override
  State<chats> createState() => _chatsState();
}

class _chatsState extends State<chats> {
  TextEditingController messagecontroller = new TextEditingController();
  String? myUserName,myProfilepic,myName,myemail,messageId,chatRoomId;
  Stream? messageStream;
  getthesharedpref()async{
myUserName = await sharedpreferencehelper().getusername();
myProfilepic = await sharedpreferencehelper().getuserpic();
myName = await sharedpreferencehelper().getdisplaynamekey();
myemail = await sharedpreferencehelper().getuseremail();
chatRoomId = getchatRoomIdbyUsername(widget.username, myUserName!);
setState(() {
  
});
  }
ontheload()async{
await getthesharedpref();
await getandsendmessage();
setState(() {
  
});
}
@override
void initState(){
  super.initState();
  ontheload();
}
getchatRoomIdbyUsername(String a,String b){
if(a.substring(0,1).codeUnitAt(0)>b.substring(0,1).codeUnitAt(0)){
  return "$b\_$a";
}else{
  return "$a\_$b";
}
  }

Widget chatmessagetile(String message,bool sendbyme){
return Row(
  mainAxisAlignment: sendbyme?MainAxisAlignment.end:MainAxisAlignment.start,
  children: [
Flexible(child: Container(
  padding: EdgeInsets.all(16),
  margin: EdgeInsets.symmetric(horizontal: 16,vertical: 4),
  decoration: BoxDecoration(

    borderRadius: BorderRadius.only(topLeft: Radius.circular(24),bottomRight: sendbyme? Radius.circular(0):Radius.circular(24),topRight: Radius.circular(24),bottomLeft: sendbyme?Radius.circular(24):Radius.circular(0)),
    color: sendbyme?Color.fromARGB(255, 210, 213,219):Color.fromARGB(255, 211, 228,243)
  ),
  child: Text(message,style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
))
  ],
);
}

  Widget chatmessage(){
    return StreamBuilder(stream: messageStream, builder: (context,AsyncSnapshot snapshot){
      return snapshot.hasData? ListView.builder(
        padding: EdgeInsets.only(bottom: 90,top: 130),
        itemCount: snapshot.data.docs.length,
        reverse: true,
        itemBuilder: (context,index){
          DocumentSnapshot ds = snapshot.data.docs[index];
          return chatmessagetile(ds["message"], myUserName == ds["sendBy"]);
        }): Center(
          child: CircularProgressIndicator(),
        );
    });
  }
  sendmessage(bool sendclicked){
    if(messagecontroller.text != ""){
      String message = messagecontroller.text;
      messagecontroller.text = "";
      DateTime now = DateTime.now();
      String formatteddate = DateFormat('h:mma').format(now);
      Map<String,dynamic>messageInfoMap = {
        "message":message,
        "sendBy":myUserName,
        "timestamp":formatteddate,
        "time":FieldValue.serverTimestamp(),
        "imgUrl": myProfilepic,
      };
      messageId ??= randomAlphaNumeric(10);
      DataBaseMethods().addmessage(chatRoomId!, messageId!, messageInfoMap).then((value) {
        Map<String,dynamic>lastMessageInfoMap={
          "lastmessage":message,
          "lastmessagesendtimestamp":formatteddate,
          "time":FieldValue.serverTimestamp(),
          "lastmessagesendbBy":myUserName,
        };
        DataBaseMethods().updatelastmessagesend(chatRoomId!, lastMessageInfoMap);
        if(sendclicked){
          messageId = null;
        }
      });
    }
  }
getandsendmessage()async{
messageStream = await DataBaseMethods().getchatroommessages(chatRoomId);
setState(() {
  
});
}
  @override
  Widget build(BuildContext context) {
    return 
     Scaffold(
       backgroundColor: Color(0xFF553370),
      body: Container(
          padding: EdgeInsets.only(top: 60),
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 50),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/1.12,
              decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))),
              child: chatmessage()),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
                    },
                    child: Icon(Icons.arrow_back_ios_new_outlined,color:Colors.white70 ,)),
                  SizedBox(width: 90,),
                   Text(widget.name,style: TextStyle(color: Colors.white70,fontSize: 20,fontWeight: FontWeight.w500),),
                ],
              ),
            ),
                  Container(
                    margin: EdgeInsets.only(left: 20,right: 20,bottom: 10,),
                    alignment: Alignment.bottomCenter,
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)
                        ),
                        child: 
                            TextField(
                              controller: messagecontroller,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "type a  message",
                                hintStyle: TextStyle(color: Colors.black45),
                                suffixIcon: GestureDetector(
                                  onTap: (){
                                    sendmessage(true);
                                  },
                                  child: Icon(Icons.send_rounded,color: Color(0xFF553370),))
                              ),
                            ),
                        ),
                      ),
                    ),
                    ]
           )),
                    );
  }
}
