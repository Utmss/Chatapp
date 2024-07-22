import 'package:baatein/forgot_pass.dart';
import 'package:baatein/home.dart';
import 'package:baatein/services/database.dart';
import 'package:baatein/services/shared_pref.dart';
import 'package:baatein/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
class signin extends StatefulWidget {
  const signin({super.key});

  @override
  State<signin> createState() => _signinState();
}

class _signinState extends State<signin> {
  String email  = "",password = "",name = "",username = "",pic ="",id = "";
  TextEditingController usermailcontroller = new TextEditingController();
  TextEditingController userpasswordcontroller  = new TextEditingController();
final _formkey = GlobalKey<FormState>();
usersignin()async{
  try{
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
QuerySnapshot querySnapshot = await DataBaseMethods().getuserbyemail(email);
name = "${querySnapshot.docs[0]["Name"]}";
username = "${querySnapshot.docs[0]["username"]}";
pic = "${querySnapshot.docs[0]["photo"]}";
id = querySnapshot.docs[0].id;
await sharedpreferencehelper().saveuserdisplayname(name);
await sharedpreferencehelper().saveusername(username);
await sharedpreferencehelper().saveuserid(id);
await sharedpreferencehelper().saveuserpic(pic);

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
  }
  on FirebaseException catch(e){
    if(e.code == 'user-not-found'){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("No User found",style: TextStyle(color: Color(0xFf7f30fe),fontSize: 18,fontWeight: FontWeight.w500),)));
    }
    else if(e.code ==  'wrong-password'){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("NPlease Enter Correct password",style: TextStyle(color: Color(0xFf7f30fe),fontSize: 18,fontWeight: FontWeight.w500),)));
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Stack(
            children: [
        Container(
          height: MediaQuery.of(context).size.height/4.0,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFf7f30fe), Color(0xFF6380fb),],begin: Alignment.topLeft,end: Alignment.bottomRight),
            borderRadius: BorderRadius.vertical(bottom: Radius.elliptical(MediaQuery.of(context).size.width,105.0))
          ),
        ),
        
        Padding(
          padding: const EdgeInsets.only(top: 70),
          child: Column(children: [
            Center(
        child: Text("SignIn",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
            ),
             Center(
        child: Text("Login to your Account",style: TextStyle(color: Color(0xFFbbb0ff),fontSize: 18,fontWeight: FontWeight.w400),),
            ),
            SizedBox(height: 20,),
            Container(
         margin: EdgeInsets.symmetric(vertical: 20,horizontal: 20.0),
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 30,horizontal: 20.0),
            padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
            height: MediaQuery.of(context).size.height/2.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,borderRadius: BorderRadius.circular(10)
            ),
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Email",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.0,color: Colors.black38)
                    ),
                    child: TextFormField(
                      controller: usermailcontroller,
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "Please Enter Your Email";
                        }
                        return null;
                      },
                      decoration: InputDecoration(border: InputBorder.none,prefixIcon: Icon(Icons.email_outlined,color: Color(0xFf7f30fe),)),
                    ),
                  ),
                  SizedBox(height: 10,),
                   Text("Password",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.0,color: Colors.black38)
                    ),
                    child: TextFormField(
                      controller: userpasswordcontroller,
                       validator: (value){
                        if(value == null || value.isEmpty){
                          return "Please Enter Your Password";
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        
                        border: InputBorder.none,prefixIcon: Icon(Icons.password,color: Color(0xFf7f30fe),)),
                    ),
                  ),
                  SizedBox(height: 10,),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>forgot()));
                    },
                    child: Container(
                      alignment: Alignment.bottomRight,
                      child: Text("Forget Password?",style: TextStyle(color:Colors.black,fontSize: 16,fontWeight: FontWeight.bold ),),
                    ),
                  ),
                  SizedBox(height: 40,),
                  GestureDetector(
                    onTap: (){
                      if(_formkey.currentState!.validate()){
                        setState(() {
                          email = usermailcontroller.text;
                          password = userpasswordcontroller.text;
                        });
                      }
                      usersignin();
                    },
                    child: Material(
                      elevation: 5,
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Color(0xFf7f30fe),borderRadius: BorderRadius.circular(10)),
                        child: Text("SIGN IN",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
            ),
            SizedBox(height: 40,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account ?",style: TextStyle(fontSize: 18,),),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>signup()));
                  },
                  child: Text("Sign Up",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color:Color(0xFf7f30fe) ),)),
              ],
            )
          ],),
        )
            ],
          ),
        ),
      ),
    );
  }
}