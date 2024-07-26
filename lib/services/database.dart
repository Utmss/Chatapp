import 'package:baatein/services/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseMethods{
Future adduserdetails(Map<String,dynamic> userInfoMap,String id)async{
  return await FirebaseFirestore.instance.collection("users").doc(id).set(userInfoMap);
}
Future<QuerySnapshot>getuserbyemail(String email)async{
return await FirebaseFirestore.instance.collection("users").where("Email",isEqualTo:email).get();
}
Future<QuerySnapshot>Search(String username)async{
  return await FirebaseFirestore.instance.collection("users").where("searchkey",isEqualTo: username.substring(0,1).toUpperCase()).get();
}
createchatRoom(String chatRoomId,Map<String,dynamic>chatRoomInfoMap)async{
  final snapshot = await FirebaseFirestore.instance.collection("chatrooms").doc(chatRoomId).get();
  if(snapshot.exists){
    return true;
  }else{
    return FirebaseFirestore.instance.collection("chatrooms").doc(chatRoomId).set(chatRoomInfoMap);
  }
}
Future addmessage(String chatRoomId,String messageId,Map<String,dynamic>messageInfoMap)async{
return  FirebaseFirestore.instance.collection("chatrooms").doc(chatRoomId).collection("chats").doc(messageId).set(messageInfoMap);
}
updatelastmessagesend(String chatRoomId,Map<String,dynamic>lastMessageInfoMap){
  return FirebaseFirestore.instance.collection("chatrooms").doc(chatRoomId).update(lastMessageInfoMap);
}
Future<Stream<QuerySnapshot>>getchatroommessages(chatRoomId)async{
return FirebaseFirestore.instance.collection("chatrooms").doc(chatRoomId).collection("chats").orderBy("time",descending: true).snapshots();
}
Future<QuerySnapshot>getUserinfo(String username)async{
return await FirebaseFirestore.instance.collection("users").where("username",isEqualTo: username).get();
}
Future<Stream<QuerySnapshot>>getchatrooms()async{
String? myUserName = await sharedpreferencehelper().getusername();
return FirebaseFirestore.instance.collection("chatrooms").orderBy("time",descending: true).where("users",arrayContains: myUserName!).snapshots();
}
}