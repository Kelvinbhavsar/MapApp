import 'dart:convert';

import 'package:MapApp/NetworkCall/apiManager.dart';
import 'package:MapApp/NetworkCall/url.dart';
import 'package:MapApp/Utils/constant.dart';
import 'package:MapApp/signIn.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:Optio/Utils/colors.dart';
// import 'package:Optio/main.dart';

class CustomDialogBox extends StatefulWidget {
  CustomDialogBox({Key key, this.title, this.message, this.type, this.onOff,this.onNegative,this.onPositive, this.isUpdate}) : super(key: key);

  final String title;
  final String message;
  final int type;   //0-> Logout,1-> Notification
  final bool onOff;
  final bool isUpdate;
  Function onNegative;
  Function onPositive;

  @override
  State<StatefulWidget> createState() => CustomDialogBoxState();
}

class CustomDialogBoxState extends State<CustomDialogBox>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeInOutBack);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: IntrinsicHeight(
            child: Container(
                margin: EdgeInsets.all(20.0),
                padding: EdgeInsets.all(8.0),
                // height: MediaQuery.of(context).size.height * 0.24,

                decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0))),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, left: 20.0, right: 20.0),
                            child: Text(
                              widget.title,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, left: 20.0, right: 20.0),
                            child: Text(
                              widget.message,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16.0,),
                                  textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Visibility(
                          visible: !widget.isUpdate,
                          child: Flexible(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ButtonTheme(
                                  height: 36.0,
                                  // minWidth: 110.0,
                                  child: RaisedButton(
                                    color: Colors.black,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0)),
                                    splashColor: Colors.white.withAlpha(40),
                                    child: Text(
                                      'No',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0),
                                    ),
                                    onPressed: (){
                                      setState(() {
                                        widget.onNegative();
                                      });
                                    }
                                  )),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0,
                                  right: 10.0,
                                  top: 10.0,
                                  bottom: 10.0),
                              child: ButtonTheme(
                                  height: 36.0,
                                  // minWidth: 110.0,
                                  child: RaisedButton(
                                    color: Colors.black,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                    splashColor: Colors.white.withAlpha(40),
                                    child: Text(
                                      widget.isUpdate ? 'Update' : 'Yes',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0),
                                    ),
                                    onPressed: (){
                                      setState(() {
                                        widget.onPositive();
                                      });
                                    }
                                  ))),
                        ),
                      ],
                    ))
                  ],
                )),
          ),
        ),
      ),
    );
  }

  void callLogoutAPI() async{
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => Login()),(Route<dynamic> route )=> false);

  }

  void setNotification() async {
    setState(() {
      SharedPreferences.getInstance().then((value){
        if(widget.onOff){
          value.setBool('notification', false);
        }else{
          value.setBool('notification', true);
        }
      });
      Navigator.pop(context);
    });
  }
}