
import 'package:baatein/chatpage.dart';
import 'package:baatein/services/database.dart';
import 'package:baatein/services/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool search = false;
  String? myName, myProfilepic, myUserName, myemail;
  Stream<QuerySnapshot>? chatroomstream;

  @override
  void initState() {
    super.initState();
    ontheload();
  }

  Future<void> getthesharedpref() async {
    myName = await sharedpreferencehelper().getdisplaynamekey();
    myProfilepic = await sharedpreferencehelper().getuserpic();
    myUserName = await sharedpreferencehelper().getusername();
    myemail = await sharedpreferencehelper().getuseremail();
    setState(() {});
  }

  Future<void> ontheload() async {
    await getthesharedpref();
    chatroomstream = await  DataBaseMethods().getchatrooms();
    setState(() {});
  }

  Widget chatroomlist() {
    return StreamBuilder(
      stream: chatroomstream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data!.docs[index];
                  return chatroomlistTile(
                    lastmessage: ds["lastmessage"],
                    chatRoomId: ds.id,
                    myUsername: myUserName!,
                    time: ds["lastmessagesendtimestamp"],
                  );
                },
              )
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  String getchatRoomIdbyUsername(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  var queryResultSet = [];
  var tempSearchStore = [];

  initialSearch(value) async {
    if (value.isEmpty) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
      return;
    }

    setState(() {
      search = true;
    });

    var lowerCaseValue = value.toLowerCase();

    if (queryResultSet.isEmpty && value.length == 1) {
      var docs = await DataBaseMethods().Search(value);
      setState(() {
        for (var doc in docs.docs) {
          queryResultSet.add(doc.data());
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['username'].toLowerCase().startsWith(lowerCaseValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF553370),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    search
                        ? Expanded(
                            child: TextField(
                              onChanged: (value) {
                                initialSearch(value);
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search ',
                                hintStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                              style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                          )
                        : Text(
                            "Baatein",
                            style: TextStyle(color: Colors.white70, fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          search = !search;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color(0xFF3a2144),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          search ? Icons.close : Icons.search,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                width: MediaQuery.of(context).size.width,
                height: search
                    ? MediaQuery.of(context).size.height / 1.19
                    : MediaQuery.of(context).size.height / 1.15,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    search
                        ? ListView(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            primary: false,
                            shrinkWrap: true,
                            children: tempSearchStore.map((element) {
                              return buildResultCard(element);
                            }).toList(),
                          )
                        : chatroomlist(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildResultCard(data) {
    return GestureDetector(
      onTap: () async {
        search = false;
        setState(() {});

        var chatRoomId = getchatRoomIdbyUsername(myUserName!, data["username"]);
        Map<String, dynamic> chatRoomInfoMap = {
          "users": [myUserName, data["username"]],
        };

        await DataBaseMethods().createchatRoom(chatRoomId, chatRoomInfoMap);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => chats(
              name: data["Name"],
              profileUrl: data["photo"],
              username: data["username"],
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.network(data["photo"], height: 70, width: 70, fit: BoxFit.cover),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data["Name"],
                      style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      data["username"],
                      style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class chatroomlistTile extends StatefulWidget {
  final String lastmessage, chatRoomId, myUsername, time;
  chatroomlistTile({
    required this.lastmessage,
    required this.chatRoomId,
    required this.myUsername,
    required this.time,
  });

  @override
  State<chatroomlistTile> createState() => _chatroomlistTileState();
}

class _chatroomlistTileState extends State<chatroomlistTile> {
  String Profileurl = "", name = "", username = "", id = "";

 

  // getthisuserinfo() async {
  //   username = widget.chatRoomId.replaceAll("_", "").replaceAll(widget.myUsername, "");
  //   QuerySnapshot querySnapshot = await DataBaseMethods().getUserinfo(username.toUpperCase());
  //   if (querySnapshot.docs.isNotEmpty) {
  //     name = "${querySnapshot.docs[0]["Name"]}";
  //     Profileurl = "${querySnapshot.docs[0]["photo"]}";
  //     id = "${querySnapshot.docs[0]["Id"]}";
  //     setState(() {
        
  //     });
  //   }
  // }
  // Future<void> getthisuserinfo() async {
    
  //   username = widget.chatRoomId.replaceAll(widget.myUsername, "").replaceAll("_", "");
  //   username = username.trim(); 

  //   // Query the database for user info
  //   QuerySnapshot querySnapshot = await DataBaseMethods().getUserinfo(username);
  //   if (querySnapshot.docs.isNotEmpty) {
  //     name = querySnapshot.docs[0]["Name"];
  //     Profileurl = querySnapshot.docs[0]["photo"];
  //     setState(() {});
  //   }
  // }
Future<void> getthisuserinfo() async {
  username = widget.chatRoomId.replaceAll(widget.myUsername, "").replaceAll("_", "").trim();

  print('Looking up user: $username'); // Debugging line

  QuerySnapshot querySnapshot = await DataBaseMethods().getUserinfo(username);
  if (querySnapshot.docs.isNotEmpty) {
    name = querySnapshot.docs[0]["Name"];
    Profileurl = querySnapshot.docs[0]["photo"];
    print('User found: Name = $name, Profile URL = $Profileurl'); // Debugging line
    setState(() {});
  } else {
    print('User not found'); // Debugging line
  }
}
 @override
  void initState() {
    getthisuserinfo();
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Profileurl == ""
              ? CircularProgressIndicator()
              : ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(Profileurl, height: 70, width: 70, fit: BoxFit.cover),
                ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    username,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width/3,
                child: Text(
                 
                  widget.lastmessage,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black45, fontWeight: FontWeight.w500, fontSize: 15),
                ),
              ),
            ],
          ),
          Spacer(),
          Text(
            widget.time,
            style: TextStyle(color: Colors.black45, fontWeight: FontWeight.w500, fontSize: 15),
          )
        ],
      ),
    );
  }
}
