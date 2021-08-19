import 'package:flutter/material.dart';

class BottomSheets
{

  /*
  * No Internet BottomSheet
  * */
  void noInternetBottomSheet(context,Function() param1) {
    showModalBottomSheet(
        enableDrag: false,
        isDismissible: false,
        context: context,
        builder: (BuildContext buildContext) {
          return Container(
            margin: EdgeInsets.only(top: 30.0),
            child: Container(
              height: MediaQuery.of(context).size.height / 3.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/no_internet.png',
                    height: 100.0,
                    width: 100.0,
                  ),
                  Text(
                    'No Internet Connection',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 24.0,
                        fontFamily: 'ProductSans',
                        color: Colors.black),
                  ),
                  Text(
                    'Please turn on your device internet.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'ProductSans',
                        color: Colors.black),
                  ),
                  SizedBox(height: 8.0,),
                  InkWell(
                    splashColor: Colors.red,
                      onTap:param1,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red, width: 1.5),
                          borderRadius: BorderRadius.circular(20.0)
                        ),
                        child: Text(
                          "Retry",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 20.0
                          ),),
                      )),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Image.asset('assets/images/logo.png', width: 70.0)
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  )
                ],
              ),
            ),
          );
        });
  }
}