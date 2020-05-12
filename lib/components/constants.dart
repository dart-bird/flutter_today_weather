import 'package:flutter/material.dart';

const kTextFieldInputDecoration = InputDecoration(
  icon: Icon(
    Icons.search,
    color: Colors.black54,
  ),
  hintText: '도시명을 입력하세요',
  hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10.0),
    ),
    borderSide: BorderSide.none,
  ),
);

const kTextTempStyle = TextStyle(
  color: Colors.white,
  fontSize: 25,
);
