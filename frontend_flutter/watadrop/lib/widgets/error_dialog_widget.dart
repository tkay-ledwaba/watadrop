import 'package:flutter/cupertino.dart';
import 'package:watadrop/common/style.dart';

showErrorDialog(context, message){
  return Container(
    color: colorPrimary,
    child: Center(
      child: Text(message),
    ),
  );
}