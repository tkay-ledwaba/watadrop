import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../common/style.dart';

showProgressWidget(context){
  return Container(
    color: colorPrimary,
    child: Center(
      child: CircularProgressIndicator(
        color: colorAccent,
      ),
    ),
  );
}