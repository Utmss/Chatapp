import 'package:baatein/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
class forgot extends StatefulWidget {
  const forgot({super.key});

  @override
  State<forgot> createState() => _forgotState();
}

class _forgotState extends State<forgot> {
  String email = "";
  final _formkey = GlobalKey<FormState>();
  TextEditingController usermailcontroller = new TextEditingController();
  resetpassword()async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password Reset Email has been sent",style: TextStyle(color: Color(0xFf7f30fe),fontSize: 18,fontWeight: FontWeight.w500),)));
    }
    on FirebaseException catch(e){
    if(e.code == 'user-not-found'){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("No User found for this mail",style: TextStyle(color: Color(0xFf7f30fe),fontSize: 18,fontWeight: FontWeight.w500),)));
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
        child: Text("Password Recovery",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
            ),
             Center(
        child: Text("Change Your Password",style: TextStyle(color: Color(0xFFbbb0ff),fontSize: 18,fontWeight: FontWeight.w400),),
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
            height: MediaQuery.of(context).size.height/3.5,
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
                
                  SizedBox(height: 40,),
                  GestureDetector(
                    onTap: (){
                     if(_formkey.currentState!.validate()){
                      setState(() {
                        email = usermailcontroller.text;
                      });
                      resetpassword();
                     }
                    },
                    child: Material(
                      elevation: 5,
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Color(0xFf7f30fe),borderRadius: BorderRadius.circular(10)),
                        child: Text("SEND EMAIL",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
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