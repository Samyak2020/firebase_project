import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_proj1/colors.dart';
import 'package:flutter_proj1/login.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'name_page.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email;
  String password;
  TextEditingController emailController = TextEditingController();
  TextEditingController pwController = TextEditingController();


  String hintTextEmail = 'Enter your email';
  String hintTextPw = 'Enter your password';

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.deepYellow,
      body:  ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      child: Text("Sign In",
                        style: theme.textTheme.headline4.copyWith(color: AppColors.black),
                      ),
                      onTap: ()=>Navigator.of(context).pop(LoginScreen()),
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          child: Text("Sign Up",
                            style: theme.textTheme.headline4.copyWith(color: AppColors.blue),
                          ),
                          onTap: (){},
                        ),
                        SizedBox(height: screenSize.height * 0.005),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.height * 0.02),
                          height: screenSize.height * 0.006,
                          decoration: BoxDecoration(
                            color: AppColors.blue,
                            borderRadius: BorderRadius.all(
                                Radius.circular(40)
                            ),
                            border: Border.all(
                              width: 3,
                              color: AppColors.blue,
                              style: BorderStyle.solid,
                            ),),
                        ),
                      ],
                    ),

                  ],
                ),
                SizedBox(height: screenSize.height * 0.075),
                Padding(
                  padding: EdgeInsets.only(left: screenSize.width * 0.1, right: screenSize.width * 0.1,bottom: screenSize.height * 0.03),
                  child: TextFormField(
                    style: TextStyle(
                        color: AppColors.black,
                        fontSize: 14.0,
                        decoration: TextDecoration.none),
                    keyboardType: TextInputType.emailAddress,
                    decoration:InputDecoration(
                      prefixIcon: Icon(
                        Icons.email_outlined, color: Colors.black54,
                        size: 22,),
                      hintText: hintTextEmail,
                      hintStyle: theme.textTheme.subtitle2.copyWith(color: Colors.black54),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black54),
                      ),
                    ),
                    controller: emailController,
                    textAlign: TextAlign.start,
                    onChanged: (value) {
                      email = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        setState(() {
                          return hintTextEmail = "Please enter your Email";
                        });
                      }
                      return null;
                    },
                  ),),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
                  child: TextFormField(
                    style: TextStyle(
                        color: AppColors.black,
                        fontSize: 14.0,
                        decoration: TextDecoration.none),
                    obscureText: true,
                    decoration:InputDecoration(
                      prefixIcon: Icon(
                        Icons.vpn_key_outlined, color: Colors.black54,
                        size: 22,),
                      hintText: hintTextPw,
                      hintStyle: theme.textTheme.subtitle2.copyWith(color: Colors.black54),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black54),
                      ),
                    ),
                    controller: pwController,
                    textAlign: TextAlign.start,
                    onChanged: (value) {
                      password = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        setState(() {
                          return hintTextPw = "Please enter your Password";
                        });
                      }else if (value.length < 6){
                        return hintTextPw = "Password must be above 6 characters";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: screenSize.height * 0.075),
                RawMaterialButton(
                  onPressed: () async{
                    setState(() {
                      showSpinner = true;
                    });
                    if(email != null && password != null && password.length >= 6){
                      try{
                        final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                        if(newUser != null ){

                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.setString('userID', newUser.uid);
                          prefs.setString('email', newUser.email);

                          Navigator.push(context, MaterialPageRoute(builder: (context)=> NamePage()));
                        }
                        setState(() {
                          showSpinner = false;
                        });
                      }catch(e){
                      }
                    }else if(emailController.text != null && pwController.text != null && pwController.text.length < 6){
                      showSnackBarDialog(context, errorMsg: "Password should be above 6 characters",backgroundColor: AppColors.red);
                    }else{
                      showSnackBarDialog(context, errorMsg: "Check your Credentials",backgroundColor: AppColors.red);
                    }

                  },
                  elevation: 2.0,
                  fillColor: AppColors.blue,
                  child: Icon(
                    Icons.arrow_forward,
                    color: AppColors.white,
                    size: 35.0,
                  ),
                  padding: EdgeInsets.all(15.0),
                  shape: CircleBorder(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
