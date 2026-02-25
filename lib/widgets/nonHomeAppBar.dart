import 'package:flutter/material.dart';
import '../style.dart';

AppBar NonHomeAppBar(BuildContext context, String text) {
  styles color = styles(context: context);
  return AppBar(
    iconTheme: IconThemeData(color: Colors.white),
    centerTitle: true,
    title: Text(text, style: TextStyle(color: color.onPrimaryC)),
    backgroundColor: color.primaryC,
  );
}
