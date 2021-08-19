import 'package:flutter/services.dart';

class Utils {

  /*
  * Method static hide keyboard
  * */
  static void hideKeyBoard()
  {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }
}
