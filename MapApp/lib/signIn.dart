/*import 'package:flutter/material.dart';
class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}*/

import 'dart:convert';

import 'package:MapApp/NetworkCall/apiManager.dart';
import 'package:MapApp/NetworkCall/url.dart';
import 'package:MapApp/Utils/constant.dart';
import 'package:MapApp/verify.dart';
import 'package:MapApp/Utils/sizeconfig.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:MapApp/Utils/colors.dart';
import 'package:flutter/services.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController phonenumber = TextEditingController();
  CountryCode countryCode = CountryCode.fromCode('US');

  bool otpSentSuccessfully = false;


  @override
  Widget build(BuildContext context) {
    
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: Colors.orangeAccent,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Container(
            height: deviceHeight,
            child: ListView(
              padding: EdgeInsets.all(0),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(deviceHeight * 0.055),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: deviceHeight * 0.18,
                        child: Image(
                          image: AssetImage("Assets/images/AppIcon.jpeg"),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      Text(
                        "Your Weather Buddy",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: getProportionalScreenWidth(20),
                            color: bg_white),
                      ),
                    ],
                  ),
                ),
                Container(
                  height:deviceHeight * (1 - 0.18),
                  width: deviceWidth,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24)),
                      color: bg_white),
                  child: Padding(
                    padding: EdgeInsets.all(deviceWidth * 0.14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Mobile Number",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: getProportionalScreenWidth(17),
                              color: Colors.black),
                        ),
                        Container(
                          height: 50,
                          width: deviceWidth,
                          child: Row(
                            children: <Widget>[
                              CountryCodePicker(
                                onChanged: (value) {
                                  countryCode = value;
                                },
                                showFlag: true,
                                initialSelection: 'US',
                                showCountryOnly: false,
                                showOnlyCountryWhenClosed: false,
                                alignLeft: true,
                                showFlagDialog: true,
                                builder: (countryCode) {
                                  return Container(
                                    child: Row(
                                      children: <Widget>[
                                        Text('  ${countryCode.dialCode}'),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5.0, right: 5.0),
                                          child: Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.grey,
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                              Container(
                                height: 30,
                                width: 1,
                                color: Colors.grey,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 8.0, left: 8.0),
                                  child: TextField(
                                    controller: phonenumber,
                                    keyboardType: TextInputType.phone,
                                    decoration: new InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        hintText: "e.g. 91488 23564"),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: deviceWidth,
                          color: Colors.grey,
                          height: 1,
                        ),
                        SizedBox(
                          height: deviceHeight * 0.03,
                        ),
                        Container(
                          height: deviceHeight * 0.06,
                          width: deviceWidth * 0.8,
                          child: RaisedButton(
                              onPressed: () async {
                                if (phonenumber.text.trim().toString().length >
                                    8) {
                                  FocusScope.of(context).unfocus();
                                  // Constant().showProgress(context);
                                    verifyNumber();
                                } else {
                                  Constant().flushbar(
                                      context,
                                      null,
                                      "Please enter valid number",
                                      Icons.warning);
                                }
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(
                                    deviceHeight * 0.03),
                              ),
                              color: Colors.orangeAccent,
                              child: Text(
                                "Verify",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: getProportionalScreenWidth(17),
                                    fontStyle: FontStyle.normal),
                              )),
                        ),
                        SizedBox(
                          height: deviceHeight * 0.03,
                        ),
                        SizedBox(
                          height: deviceHeight * 0.35,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }


  _verifyPhoneNumber(BuildContext context) async {
    print(phonenumber.text.toString());
    String phoneNumber = countryCode.toString() + phonenumber.text.toString();

    final FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: Duration(seconds: 0),
      verificationFailed: (authException) =>
          _verificationFailed(authException, context),
      codeAutoRetrievalTimeout: (verificationId) =>
          _codeAutoRetrievalTimeout(verificationId),
      codeSent: (verificationId, [int code]){
                                          // Constant().hideProgress(context);

        _smsCodeSent(verificationId, code);
      }
          ,
      verificationCompleted: (AuthCredential phoneAuthCredential) {
        print("object");
      },
    );
  }

  _verificationFailed(authException, context) {
    otpSentSuccessfully = false;
    print("Verification Failed : ${authException.message}");
    if("${authException.code}" == "invalidCredential"){
      Constant().flushbar(context, null, "Please enter valid mobile number", Icons.warning);
    }else{
      Constant().flushbar(context, null, "${authException.message}", Icons.warning);
    }
  }

  _codeAutoRetrievalTimeout(verificationId) async {
    print("Login TimeOut");
    SharedPreferences users = await SharedPreferences.getInstance();
    users.setString('verId', verificationId);
    // Navigator.of(context).pop();
    // Constant().flushbar(context, null, "Timeout", Icons.warning);
    // AlertDialog(
    //   content: Text("TimeOut"),
    // );
  }

  _smsCodeSent(verificationId, [int code]) async {
 
    // Constant().hideProgress(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Verify(
                  phone: phonenumber.text.trim().toString(),
                  countryCode: countryCode.toString(),
                )));
                
    
  }

  verifyNumber() async {
    _verifyPhoneNumber(context);
  }
}
