import 'package:flutter/material.dart';

class chats extends StatefulWidget {
  const chats({super.key});

  @override
  State<chats> createState() => _chatsState();
}

class _chatsState extends State<chats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Color(0xFF553370),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.only(top: 60),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                  children: [
                    Icon(Icons.arrow_back_ios_new_outlined,color:Colors.white70 ,),
                    SizedBox(width: 90,),
                     Text("Utkarsh Mishra",style: TextStyle(color: Colors.white70,fontSize: 20,fontWeight: FontWeight.w500),),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Container(
                padding: EdgeInsets.only(left: 20,right: 20,top: 50,bottom: 40),
                width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height/1.15,
                      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.only(topLeft:Radius.circular(30),topRight: Radius.circular(30))),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      margin:EdgeInsets.only(left:MediaQuery.of(context).size.width/2),
                      alignment: Alignment.bottomRight,
                      decoration: BoxDecoration(color: Color.fromARGB(255, 210, 213,219),borderRadius: BorderRadius.only(topLeft:Radius.circular(10),topRight: Radius.circular(10),bottomLeft: Radius.circular(10))),
                      child: Text("Hello, How was the day?",style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      padding: EdgeInsets.all(10),
                      margin:EdgeInsets.only(right:MediaQuery.of(context).size.width/3),
                      alignment: Alignment.topLeft,
                      decoration: BoxDecoration(color: Color.fromARGB(255, 211, 228,243),borderRadius: BorderRadius.only(bottomRight:Radius.circular(10),topRight: Radius.circular(10),topLeft: Radius.circular(10))),
                      child: Text("Heyy, the day was really fine. & yours?",style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                    ),
                    Spacer(),
                    Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,borderRadius: BorderRadius.circular(30)
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(border: InputBorder.none,hintText: "Type a message",hintStyle: TextStyle(color: Colors.black45)),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(color: Color(0xFFf3f3f3),borderRadius: BorderRadius.circular(60)),
                              child: Center(child: Icon(Icons.send,color: Color.fromARGB(255, 192, 214, 233),)))
                          ],
                        ),
                      ),
                    )
                    
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}