import 'package:shared_preferences/shared_preferences.dart';

class sharedpreferencehelper{
  static String UserIdkey = "USERKEY";
  static String UserNamekey = "USERNAMEKEY";
  static String UserEmailkey = "USEREMAILKEY";
  static String UserPickey = "USERPICKEY";
  static String displaynamekey = "USERDISPLAYNAME";
  
  Future<bool> saveuserid(String getuserid)async{
SharedPreferences prefs = await SharedPreferences.getInstance();
return prefs.setString(UserIdkey, getuserid);
  }
  Future<bool> saveuseremail(String getuseremail)async{
SharedPreferences prefs = await SharedPreferences.getInstance();
return prefs.setString(UserEmailkey, getuseremail);
  }
   Future<bool> saveusername(String getusername)async{
SharedPreferences prefs = await SharedPreferences.getInstance();
return prefs.setString(UserNamekey, getusername);
  }
   Future<bool> saveuserpic(String getuserpic)async{
SharedPreferences prefs = await SharedPreferences.getInstance();
return prefs.setString(UserPickey, getuserpic);
  }
Future<bool> saveuserdisplayname(String getuserdislayname)async{
SharedPreferences prefs = await SharedPreferences.getInstance();
return prefs.setString(displaynamekey, getuserdislayname);
  }
  Future<String?> getuserid()async{
SharedPreferences prefs = await SharedPreferences.getInstance();
return prefs.getString(UserIdkey);
  }
  Future<String?> getusername()async{
SharedPreferences prefs = await SharedPreferences.getInstance();
return prefs.getString(UserNamekey);
  }
  Future<String?> getuseremail()async{
SharedPreferences prefs = await SharedPreferences.getInstance();
return prefs.getString(UserEmailkey);
  }
  Future<String?> getuserpic()async{
SharedPreferences prefs = await SharedPreferences.getInstance();
return prefs.getString(UserPickey);
  }
  Future<String?> getdisplaynamekey()async{
SharedPreferences prefs = await SharedPreferences.getInstance();
return prefs.getString(displaynamekey);
  }
}