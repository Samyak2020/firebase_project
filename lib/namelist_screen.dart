import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_proj1/add_amt_screen.dart';
import 'package:flutter_proj1/colors.dart';
import 'package:flutter_proj1/login.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _firestore = Firestore.instance;


class NameListScreen extends StatefulWidget {

  String loggedInUserEmail;
  String loggedInUserId;

  NameListScreen({@required this.loggedInUserEmail,@required this.loggedInUserId});

  @override
  _NameListScreenState createState() => _NameListScreenState();
}

class _NameListScreenState extends State<NameListScreen> {
  final _auth = FirebaseAuth.instance;
  String demoName = "Something";


  void namesStream() async{
    await for(var snapshot in _firestore.collection('names').snapshots()){
      for(var name in snapshot.documents){
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.deepYellow,
      appBar: AppBar(
        backgroundColor: AppColors.deepYellow,
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Write some code to control things, when user press back button in AppBar
              Navigator.pop(context);
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
            _auth.signOut();
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.remove('userID');
            prefs.remove('email');
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (c) => LoginScreen()),
                    (route) => false);
        },
        tooltip: 'Logout',
        backgroundColor: AppColors.red,
        child: Text("Logout",
          style: theme.textTheme.bodyText1.copyWith(color: AppColors.white),
        ),
      ),
      body:  StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('names').snapshots(),
          builder: (context, snapshot){
            if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.amber,
                ),
              );
            }
            final names = snapshot.data.documents;
            final currentUser = widget.loggedInUserId;
              return ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(10.0),
                itemCount: names.length ,
                itemBuilder: (BuildContext context, int index) {

                  var name = snapshot.data.documents[index];
                  var docId = snapshot.data.documents[index].documentID;
                  var userId = name.data['userId'];
                  var nameTxt =  name.data['name'];
                  DateTime myDateTime = (snapshot.data.documents[index].data['timestamp']).toDate();
                  var time = DateFormat.yMMMd().add_jm().format(myDateTime);
                  if(userId == currentUser){
                    return Card(
                      color: Colors.white,
                      elevation: 2.0,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.blue,
                          child: Icon(Icons.person),
                        ),
                        title: Text(
                            nameTxt,
                          style: theme.textTheme.headline6.copyWith(color: AppColors.blue),
                        ),
                        subtitle:  Text(
                         // dateString,
                          time,
                          style: theme.textTheme.bodyText2.copyWith(color: AppColors.blue),
                        ),
                        trailing: GestureDetector(
                          child: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onTap: () async{
                            _firestore.collection("names").document(docId).delete().then((value){
                              showSnackBarDialog(context, errorMsg: "Name deleted",backgroundColor: Colors.red);
                            });
                          },
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> AddAmtScreen(name: nameTxt,
                          loggedInUserId: currentUser,

                          )));
                        },
                      ),
                    );
                  }else{
                    return SizedBox();
                  }

                },
              );
            // }else{
            //   return SizedBox();
            // }

          }),
    );
  }
}

// To:DO : get Timestamp from firebase
//


