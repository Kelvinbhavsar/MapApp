// import 'package:Optio/home.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:MapApp/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'NetworkCall/apiManager.dart';
import 'NetworkCall/url.dart';
import 'Utils/constant.dart';
// import 'Utils/colors.dart';

class Verify extends StatefulWidget {
  
  final String countryCode;
  final String phone;
  

  Verify(
      {this.phone,
      this.countryCode,
      });

  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  TextEditingController verificationCode = TextEditingController();


  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String phone = widget.phone;
    String countryCode = widget.countryCode;

    // String phone = widget.phone;
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    // TextEditingController otp = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        leading: Constant().backbutton(context),
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orangeAccent,
        brightness: Brightness.dark,
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Container(
              color: Colors.orangeAccent,
              height: deviceHeight,
              child: ListView(padding: EdgeInsets.all(0), children: <Widget>[
                Container(
                  child: Container(
                    height: deviceHeight * 0.23,
                    child: Container(
                      child: Image(
                        image: AssetImage("Assets/images/auth.png"),
                        fit: BoxFit.fitHeight,
                      ),
                      height: deviceHeight * 0.23,
                    ),
                    alignment: Alignment.bottomCenter,
                  ),
                ),
                Container(
                    width: deviceWidth,
                    height: deviceHeight * 0.75,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24)),
                        color: Colors.white),
                    child: Padding(
                        padding: EdgeInsets.all(deviceWidth * 0.14),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "OTP Verification",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Enter the OTP you received to",
                                style: TextStyle(
                                    fontWeight: FontWeight.w300, fontSize: 15),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "$countryCode " +
                                    phone.substring(0, 6) +
                                    "XXXX",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 13),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              PinCodeTextField(
                                length: 6,
                                obsecureText: false,
                                controller: verificationCode,
                                animationType: AnimationType.fade,
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.underline,
                                  borderRadius: BorderRadius.circular(2),
                                  borderWidth: 1,
                                  fieldHeight: 50,
                                  fieldWidth: deviceWidth * 0.08,
                                  selectedColor: Colors.grey,
                                  activeFillColor: Colors.grey,
                                  activeColor: Colors.grey,
                                  disabledColor: Colors.grey,
                                  inactiveColor: Colors.grey,
                                ),
                                animationDuration: Duration(milliseconds: 300),
                                backgroundColor: Colors.transparent,
                                enableActiveFill: false,
                                textInputType: TextInputType.number,
                                // errorAnimationController: errorController,
                                // controller: textEditingController,
                                onCompleted: (v) {
                                  print("Completed");
                                },
                                onChanged: (value) {
                                  print(value);
                                  setState(() {
                                    // currentText = value;
                                  });
                                },
                                beforeTextPaste: (text) {
                                  print("Allowing to paste $text");
                                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                  //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                  return true;
                                },
                              ),
                              SizedBox(
                                height: deviceHeight * 0.05,
                              ),
                              Container(
                                  height: deviceHeight * 0.06,
                                  width: deviceWidth * 0.8,
                                  child: RaisedButton(
                                    onPressed: () {
                                      FocusScope.of(context).unfocus();
                                      Constant().showProgress(context);
                                      // verifyOTP();
                                      verifycode(context);
                                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>Subscription()));
                                    },
                                    child: Text(
                                      "Submit",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontStyle: FontStyle.normal),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(
                                          deviceHeight * 0.03),
                                    ),
                                    color: Colors.orangeAccent,
                                  )),
                              SizedBox(
                                height: 15,
                              ),
                              GestureDetector(
                                child: Center(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Resend Code?",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        _start == 0 ? "" : "($_start)",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  if(isClickable) {
                                    setState(() {
                                      isClickable = false;
                                    });
                                    _verifyPhoneNumber(context);
                                    // startTimer();
                                  }
                                },
                              )
                            ])))
              ]))),
    );
  }

  verifycode(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AuthCredential authCred = PhoneAuthProvider.getCredential(
        verificationId: prefs.getString('verId'),
        smsCode: verificationCode.text.toString());

    FirebaseAuth.instance.signInWithCredential(authCred).then((authResult)async {
      Constant().hideProgress(context);
      await SharedPreferences.getInstance().then((value){
          value.setInt('userLogged', 1);
          value.setString('userNumber', widget.countryCode.toString() + " " + widget.phone.toString());
        });
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Home()),
            (Route<dynamic> route) => false);
    }).catchError((error) {
      print(error.toString());
      Constant().hideProgress(context);
      Constant()
          .flushbar(context, null, "Please enter valid code.", Icons.info);
    });
    print("Complete");
    
  }


  _verifyPhoneNumber(BuildContext context) async {
    startTimer();
    print(widget.phone.toString());
    String phoneNumber =
        widget.countryCode.toString() + widget.phone.toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("ResendCodeToken : ${prefs.getInt('resendCodeToken')}");
    final FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      forceResendingToken: prefs.getInt('resendCodeToken'),
      timeout: Duration(seconds: 0),
      verificationFailed: (authException) =>
          _verificationFailed(authException, context),
      codeAutoRetrievalTimeout: (verificationId) =>
          _codeAutoRetrievalTimeout(verificationId),

      // called when the SMS code is sent
      codeSent: (verificationId, [int code]) =>
          _smsCodeSent(verificationId, code),
      verificationCompleted: (AuthCredential phoneAuthCredential) async {
        print("Verification Completed");
        
      },
    );
  }

  _verificationFailed(authException, context) {
    print("Verification Failed : ${authException.message}");
    if("${authException.code}" == "invalidCredential"){
      Constant().flushbar(context, null, "Please enter valid mobile number", Icons.warning);
    }else{
      Constant().flushbar(context, null, "${authException.message}", Icons.warning);
    }
  }

  _codeAutoRetrievalTimeout(verificationId) async {
    SharedPreferences users = await SharedPreferences.getInstance();
    users.setString('verId', verificationId);
    print("TimeOut");
    // Navigator.of(context).pop();
    // Constant().flushbar(context, null, "Timeout", Icons.warning);
  }

  _smsCodeSent(verificationId, [int code]) async {
    print(verificationId);
    SharedPreferences users = await SharedPreferences.getInstance();
    users.setString('verId', verificationId);
    users.setInt('resendCodeToken', code);
    Constant()
        .flushbar(context, null, "Verification code sent successfully.", Icons.thumb_up);
  }


  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Timer _timer;
  int _start;
  bool isClickable = false;

  void startTimer() {
    _start = 120;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            isClickable = true;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }
}
