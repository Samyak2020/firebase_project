import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_proj1/colors.dart';
import 'package:flutter_proj1/login.dart';
import 'package:flutter_proj1/name_page.dart';
import 'package:flutter_proj1/namelist_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';



class MatchScreen extends StatefulWidget {

  String loggedInUserEmail;
  String loggedInUserId;

  MatchScreen({@required this.loggedInUserEmail,@required this.loggedInUserId});
  @override
  _MatchScreenState createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {

  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    var theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.deepYellow,
     appBar: AppBar(
       elevation: 0,
       backgroundColor: AppColors.deepYellow,
       leading: IconButton(
           icon: Icon(Icons.arrow_back),
           onPressed: () {
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
      body:  Center(
        child: Padding(
          padding: EdgeInsets.only(bottom: screenSize.height * 0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: screenSize.width * 0.1,right: screenSize.width * 0.1),
                    child: Text("Logged in as "
                      // "${loggedInUserEmail.email}"
                      ,
                      textAlign: TextAlign.start,
                      style: theme.textTheme.bodyText1.copyWith(color: AppColors.white),
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.01),
                  Padding(
                    padding: EdgeInsets.only(left: screenSize.width * 0.1,right: screenSize.width * 0.1),
                    child: Text( "${widget.loggedInUserEmail}" ?? "User Email"
                      // "${loggedInUserEmail.email}"
                      ,
                      textAlign: TextAlign.start,
                      style: theme.textTheme.subtitle1.copyWith(color: AppColors.blue),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenSize.height * 0.05),
              RawMaterialButton(
                onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> NameListScreen(
                  loggedInUserId: widget.loggedInUserId,
                  loggedInUserEmail: widget.loggedInUserEmail,
                ))),
                elevation: 8.0,
                fillColor: AppColors.blue,
                child: Text("MATCH",
                  style: theme.textTheme.subtitle1.copyWith(color: AppColors.white),
                ),
                padding: EdgeInsets.all(35.0),
                shape: CircleBorder(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

