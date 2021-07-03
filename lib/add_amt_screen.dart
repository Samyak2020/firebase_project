import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_proj1/colors.dart';
import 'custom_textfield.dart';
import 'login.dart';


final _firestore = Firestore.instance;

class AddAmtScreen extends StatefulWidget {

  final String name;
  var timeStamp;
  String loggedInUserId;


  AddAmtScreen({@required this.name,this.timeStamp,this.loggedInUserId});

  @override
  _AddAmtScreenState createState() => _AddAmtScreenState();
}

class _AddAmtScreenState extends State<AddAmtScreen> {
  bool showSpinner = false;
  String amount;
  String macNumber;

  String hintMac = 'Enter your Number';
  String hintTextAmt= 'Enter Amount';


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
              Navigator.pop(context);
            }),
      ),
      body:  Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(left: screenSize.width * 0.12,right: screenSize.width * 0.1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            child: Text(widget.name,
                              style: theme.textTheme.headline5.copyWith(color: AppColors.blue),
                            ),
                            onTap: (){},
                          ),SizedBox(height: screenSize.height * 0.005),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.height * 0.02),
                            height: screenSize.height * 0.004,
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
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenSize.height * 0.045),
              Padding(
                padding: EdgeInsets.only(left: screenSize.width * 0.1, right: screenSize.width * 0.1,bottom: screenSize.height * 0.04),
                child: TextFormField(
                  style: TextStyle(
                      color: AppColors.black,
                      fontSize: 14.0,
                      decoration: TextDecoration.none),
                  decoration:InputDecoration(
                    prefixIcon: Icon(
                      Icons.confirmation_number_outlined, color: Colors.black54,
                      size: 22,),
                    hintText: hintMac,
                    hintStyle: theme.textTheme.subtitle2.copyWith(color: Colors.black54),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black54),
                    ),
                  ),
                  textAlign: TextAlign.start,
                  onChanged: (value) {
                    macNumber = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      setState(() {
                        return hintMac = "Please enter a Mac Number";
                      });
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: screenSize.width * 0.1, right: screenSize.width * 0.1,bottom: screenSize.height * 0.04),
                child: TextFormField(
                  style: TextStyle(
                      color: AppColors.black,
                      fontSize: 14.0,
                      decoration: TextDecoration.none),
                  decoration:InputDecoration(
                    prefixIcon: Icon(
                      Icons.attach_money_outlined, color: Colors.black54,
                      size: 22,),
                    hintText: hintTextAmt,
                    hintStyle: theme.textTheme.subtitle2.copyWith(color: Colors.black54),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black54),
                    ),
                  ),
                  textAlign: TextAlign.start,
                  onChanged: (value) {
                    amount = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      setState(() {
                        return hintTextAmt = "Please enter an Amount";
                      });
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: screenSize.height * 0.075),
              RawMaterialButton(
                //onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> NameListScreen())),
                onPressed: () async{
                  setState(() {
                    showSpinner = true;
                  });
                  await _firestore.collection("nameWithAmt").add(
                      {
                        'name' : widget.name,
                        'timestamp': FieldValue.serverTimestamp(),
                        'userId' : widget.loggedInUserId,
                        'amount' : amount
                      },
                  );
                  setState(() {
                    showSpinner = false;
                  });
                  macNumber = '';
                  amount = '';
                  showSnackBarDialog(context, errorMsg: "Saved to list",backgroundColor: Colors.green);
                },
                elevation: 8.0,
                fillColor: AppColors.blue,
                child: Text("Save",
                  style: theme.textTheme.headline6.copyWith(color: AppColors.white),
                ),
                padding: EdgeInsets.all(24.0),
                shape: CircleBorder(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
