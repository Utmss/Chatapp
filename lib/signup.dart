import 'package:baatein/home.dart';
import 'package:baatein/services/database.dart';
import 'package:baatein/services/shared_pref.dart';
import 'package:baatein/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:random_string/random_string.dart';
class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  String email = "",password = "",confirmpassword = "",name = "";
  TextEditingController mailcontoller = new TextEditingController();
  TextEditingController passwordcontoller = new TextEditingController();
  TextEditingController confirmpasswordcontoller = new TextEditingController();
  TextEditingController namecontoller = new TextEditingController();
  final _formkey = GlobalKey<FormState>();
  Registration()async{
if(password != null && password == confirmpassword){
  try{
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    String Id = randomAlphaNumeric(10);
    String user = mailcontoller.text.replaceAll("@gmail.com", "");
    String updateusername = user.replaceFirst(user[0], user[0].toUpperCase());
    String firstletter  = user.substring(0,1).toUpperCase();


    Map<String,dynamic>userInfoMap = {
"Name":namecontoller.text,
"Email" : mailcontoller.text,
"username":updateusername.toUpperCase(),
"searchkey":firstletter,
"photo":"https://firebasestorage.googleapis.com/v0/b/foodie-5dfeb.appspot.com/o/blogimages%2Fr61012a850?alt=media&token=3e361ca8-4aab-485e-905c-9b6465ea0c51",
"Id": Id,
    };
    await DataBaseMethods().adduserdetails(userInfoMap, Id);
    await sharedpreferencehelper().saveuserid(Id);
     await sharedpreferencehelper().saveuserdisplayname(namecontoller.text);
     await sharedpreferencehelper().saveuseremail(mailcontoller.text);
     await sharedpreferencehelper().saveuserpic("https://firebasestorage.googleapis.com/v0/b/foodie-5dfeb.appspot.com/o/blogimages%2Fr61012a850?alt=media&token=3e361ca8-4aab-485e-905c-9b6465ea0c51");
     await sharedpreferencehelper().saveusername(mailcontoller.text.replaceAll("@gmail.com", "").toLowerCase(),);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Registered Succesfully",style: TextStyle(color: Color(0xFf7f30fe),fontSize: 20,fontWeight: FontWeight.bold),)));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
  }on FirebaseAuthException catch(e){
    if(e.code == 'weak-password'){
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password is Week",style: TextStyle(color: Color(0xFf7f30fe),fontSize: 18,fontWeight: FontWeight.w500),)));
    }else if(e.code == 'email-already-in-use'){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text("Email already exists",style: TextStyle(color: Color(0xFf7f30fe),fontSize: 18,fontWeight: FontWeight.w500),)));
    }
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
        child: Text("SignUp",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
            ),
             Center(
        child: Text("Create your Account",style: TextStyle(color: Color(0xFFbbb0ff),fontSize: 18,fontWeight: FontWeight.w400),),
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
            height: MediaQuery.of(context).size.height/1.7,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,borderRadius: BorderRadius.circular(10)
            ),
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text("Name",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.0,color: Colors.black38)
                    ),
                    child: TextFormField(
                      controller: namecontoller,
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "Please Enter Your Name";
                        }
                        return null;
                      },
                      decoration: InputDecoration(border: InputBorder.none,prefixIcon: Icon(Icons.person_2_outlined,color: Color(0xFf7f30fe),)),
                    ),
                  ),
                   SizedBox(height: 10,),
                  Text("Email",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.0,color: Colors.black38)
                    ),
                    child: TextFormField(
                      controller: mailcontoller,
                     validator: (value){
                      if(value == null || value.isEmpty){
                        return "Plaese Enter Your email";
                      }return null;
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
                      controller: passwordcontoller,
                      validator: (value){
                        if(value == null || value.isEmpty ){
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
                   Text("Confirm Password",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.0,color: Colors.black38)
                    ),
                    child: TextFormField(
                      controller: confirmpasswordcontoller,
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "Password not match";
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        
                        border: InputBorder.none,prefixIcon: Icon(Icons.password,color: Color(0xFf7f30fe),)),
                    ),
                  ),
                  SizedBox(height: 40,),
                  GestureDetector(
                    onTap: (){
                      if(_formkey.currentState!.validate()){
                        setState(() {
                          email = mailcontoller.text;
                          name = namecontoller.text;
                          password = passwordcontoller.text;
                          confirmpassword = confirmpasswordcontoller.text;
                        });
                      }
                      Registration();
                    },
                    child: Material(
                      elevation: 5,
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Color(0xFf7f30fe),borderRadius: BorderRadius.circular(10)),
                        child: Text("SIGN UP",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
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
                Text("Already have an account ?",style: TextStyle(fontSize: 18,),),
                GestureDetector(
                  onTap: (){
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>signin()));
                  },
                  child: Text("Sign In",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color:Color(0xFf7f30fe) ),)),
              ],
            )
          ],),
        )
            ],
          ),
        ),
      ),
    );;
  }
}