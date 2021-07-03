import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_proj1/colors.dart';
import 'package:flutter_proj1/login.dart';
import 'package:flutter_proj1/match_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


final _firestore = Firestore.instance;

class NamePage extends StatefulWidget {
  @override
  _NamePageState createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  String loggedInUserEmail;
  String loggedInUserId;
  TextEditingController nameController = TextEditingController();
  String hintName = "Enter Name";
  String name;
  bool showSpinner = false;
  var userEmail;
  String userid;



  Future getCurrentUser() async{
    try{
      final user = await _auth.currentUser();
      if(user!=null) {
        loggedInUser = user;
        loggedInUserEmail =  loggedInUser.email ?? "" ;
        loggedInUserId =  loggedInUser.uid ?? "" ;
      }
    }catch (e){
    }
  }

  getUserFromSharedPref()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('email');
      userid = prefs.getString('userID');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    getUserFromSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    var theme = Theme.of(context);

    var userID = userid;
    var eMAIL = userEmail;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.deepYellow,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  child: Text( "$eMAIL" ?? "User Email"
                    // "${loggedInUserEmail.email}"
                    ,
                    textAlign: TextAlign.start,
                    style: theme.textTheme.subtitle1.copyWith(color: AppColors.blue),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: screenSize.width * 0.12,right: screenSize.width * 0.1),
                    child: Text("Please Insert A Name",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headline5.copyWith(color: AppColors.blue),
                    ),
                  ),
                ),
              ],
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                Padding(
                  padding: EdgeInsets.only(left: screenSize.width * 0.1, right: screenSize.width * 0.1,bottom: screenSize.height * 0.03),
                  child: TextFormField(
                    style: TextStyle(
                        color: AppColors.black,
                        fontSize: 14.0,
                        decoration: TextDecoration.none),
                    decoration:InputDecoration(
                      prefixIcon: Icon(
                        Icons.person_add_alt, color: Colors.black54,
                        size: 22,),
                      hintText: hintName,
                      hintStyle: theme.textTheme.subtitle2.copyWith(color: Colors.black54),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black54),
                      ),
                    ),
                    textAlign: TextAlign.start,
                    controller: nameController,
                    onChanged: (value) {
                      name = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        setState(() {
                          return hintName = "Please enter your Email";
                        });
                      }
                      return null;
                    },
                  ),
                  ),
                RawMaterialButton(
                  onPressed: () async{
                    setState(() {
                      showSpinner = true;
                    });
                    await _firestore.collection("names").add(
                        {
                          'name' : name,
                          'timestamp': FieldValue.serverTimestamp(),
                          'userId' : loggedInUserId,
                        }
                    );
                    setState(() {
                      showSpinner = false;
                    });
                    name = '';
                    nameController.text = '';
                    showSnackBarDialog(context, errorMsg: "Saved to list",backgroundColor: Colors.green);
                  },
                  elevation: 8.0,
                  fillColor: AppColors.blue,
                  child: Text("Save",
                    style: theme.textTheme.subtitle1.copyWith(color: AppColors.white),
                  ),
                  padding: EdgeInsets.all(12.0),
                ),
              ],
            ),
            RawMaterialButton(
              onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> MatchScreen(
                loggedInUserEmail: loggedInUserEmail,
                loggedInUserId: loggedInUserId,
              ))),
              elevation: 8.0,
              fillColor: AppColors.blue,

              child: Text("Go \n To \n Match",
                textAlign: TextAlign.center,
                style: theme.textTheme.subtitle1.copyWith(color: AppColors.white),
              ),
              padding: EdgeInsets.all(20.0),
              shape: CircleBorder(),
            ),
          ],
        ),
      ),
    );
  }
}

class TextfieldThemeStyle extends StatelessWidget {
  const TextfieldThemeStyle({this.child});

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Theme(
        data: new ThemeData(
          primaryColor: AppColors.red,
        ),
        child: child);
  }
}


