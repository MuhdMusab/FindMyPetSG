import 'package:flutter/material.dart';

PreferredSizeWidget appBarMain(BuildContext context) {
  return AppBar(
      //title: Image.asset("assets/images/logo.png", height: 50)
   title: Text(
     "FindMyPetSG",
     style: TextStyle(
       fontSize: 17,
       color: Colors.white,

     ),
   ),
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.white54,
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      )
  );
}

InputDecoration circularFieldInputDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      color: Colors.black87,
    ),
    //border: InputBorder.none,
  );
}

TextStyle simpleWhiteTextStyle() {
  return TextStyle(
      color: Colors.white,
      fontSize: 16
  );
}

TextStyle simpleBlackTextStyle() {
  return TextStyle(
      color: Colors.black,
      fontSize: 16
  );
}

TextStyle simpleGreyTextStyle() {
  return TextStyle(
      color: Colors.black,
      fontSize: 16
  );
}

TextStyle mediumTextStyle() {
  return TextStyle(
      color: Colors.black,
      fontSize: 17
  );
}

typedef F<String> = List<String> Function<String>(String);

Container inputTextField(String str, TextEditingController ctrl, BuildContext context, String ? Function(String ?) validator) {
  //String ? Function(String ?) ? func
  return Container(
    width: MediaQuery.of(context).size.width,
    padding: EdgeInsets.symmetric(
        vertical: 2,
        horizontal: 15
    ),
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [
        Colors.white,
        Colors.white,
      ]),
      borderRadius: BorderRadius.circular(30),
       border: Border.all(color: Colors.black26,
         width: 2,
       ),
    ),
    child: TextFormField(
      validator: validator,
      controller: ctrl,
      style: simpleBlackTextStyle(),
      decoration: circularFieldInputDecoration(str),
    ),
  );
}