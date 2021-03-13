import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:intl/intl.dart';
// import 'package:tutorial_coach_mark/content_target.dart';

class Constant {

  //Tutorial Pages
  String title1 = "Welcome to Optio! To get started, we’ll explain the basics.";
  String title2 = "Life Aspects are simply areas of your life like school, work, social, etc. that tasks and goals can fall into.";
  String title3 = "Your goals can be both long and short-term.";
  String detail1 = "You’ll have Life Aspects, Long and Short-term Goals with steps to achieve them, & Daily Tasks, with a handy Matrix that prioritizes everything based on your preferences!";
  String detail2 = "You can make as many of these as your heart desires! & you’re able to choose fun logos for these aspects from your camera roll or emoji keyboard.";
  String detail3 = "The steps to reach these goals will be labeled as tasks, with the differentiation between daily responsibilities and steps to reach goals up to you to define.";

  Future<bool> isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  

  simpleTExtViewWithGivenFontSize(String str, double size, Color colors) {
    return Text(
      str,
      style: TextStyle(
          fontSize: UIUtills().getProportionalHeight(size),
          color: colors == null ? Colors.white : colors),
    );
  }

  backbutton(BuildContext context) {
    return IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
          size: UIUtills().getProportionalHeight(40.0),
        ),
        onPressed: () {
          Navigator.pop(context);
        });
  }

  blackbackbutton(BuildContext context) {
    return IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: UIUtills().getProportionalHeight(40.0),
        ),
        onPressed: () {
          Navigator.pop(context);
        });
  }

  flushbar(
      BuildContext context, String title, String subtitle, IconData showicon) {
    return Flushbar(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.all(15),
      title: title,
      message: subtitle == null || subtitle.length == 0 ? "Something went wrong" : subtitle,
      shouldIconPulse: false,
      borderRadius: 8,
      duration: Duration(seconds: 3),
      backgroundGradient:
          LinearGradient(colors: [Colors.grey[900], Colors.grey[900]]),
      icon: Icon(
        showicon,
        color: Colors.white,
      ),
      // backgroundColor: Colors.grey,
    ).show(context);
  }

  bool isEmailValidate(String email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    return RegExp(pattern).hasMatch(email);
  }

  String validateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  makeflushbarForConnectivity(BuildContext context) {
    return Flushbar(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.all(15),
      title: null,
      message: "Network not available.Please try later!",
      shouldIconPulse: false,
      borderRadius: 8,
      duration: Duration(seconds: 4),
      backgroundGradient:
          LinearGradient(colors: [Colors.grey[900], Colors.grey[900]]),
      icon: Icon(
        Icons.network_wifi,
        color: Colors.white,
      ),
      // backgroundColor: Colors.grey,
    ).show(context);
  }

  showProgress(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.black12,
            body: Center(
              child: Container(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          );
        });
  }

  hideProgress(BuildContext context) {
    Navigator.pop(context);
  }
}

class UIUtills {
  factory UIUtills() {
    return _singleton;
  }
  static final UIUtills _singleton = UIUtills._internal();
  UIUtills._internal() {
    print("Instance created UIUtills");
  }
//region Screen Size and Proportional according to device
  double _screenHeight;
  double _screenWidth;
  double get screenHeight => _screenHeight;
  double get screenWidth => _screenWidth;
  final double _refrenceScreenHeight = 640;
  final double _refrenceScreenWidth = 360;
  void updateScreenDimesion({double width, double height}) {
    _screenWidth = (width != null) ? width : _screenWidth;
    _screenHeight = (height != null) ? height : _screenHeight;
  }

  double getProportionalHeight(double d, {double height}) {
    if (_screenHeight == null) return height;
    return _screenHeight * height / _refrenceScreenHeight;
  }

  double getProportionalWidth(double d, {double width}) {
    print(d);
    print(_screenWidth);
    if (_screenWidth == null) return width;
    var w = (_screenWidth * width) / (_refrenceScreenWidth);
    // var ceilToDouble = w.ceilToDouble();
    print(w);
    return w.ceilToDouble();
  }

//endregion
//region TextStyle
  TextStyle getTextStyleRegular(
      {String fontName = 'Roboto-Regular',
      double fontsize = 12,
      Color color,
      bool isChangeAccordingToDeviceSize = true,
      double characterSpacing,
      double lineSpacing}) {
    double finalFontsize = fontsize;
    if (isChangeAccordingToDeviceSize && this._screenWidth != null) {
      finalFontsize = (finalFontsize * _screenWidth) / _refrenceScreenWidth;
    }
    if (characterSpacing != null) {
      return TextStyle(
          fontSize: finalFontsize,
          fontFamily: fontName,
          color: color,
          letterSpacing: characterSpacing);
    } else if (lineSpacing != null) {
      return TextStyle(
          fontSize: finalFontsize,
          fontFamily: fontName,
          color: color,
          height: lineSpacing);
    }
    return TextStyle(
        fontSize: finalFontsize, fontFamily: fontName, color: color);
  }
}
