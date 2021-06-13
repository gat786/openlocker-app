import 'package:flutter/material.dart';

class MediaType{
  String title;
  Icon icon;
  bool isSelected;

  MediaType({required this.title,required this.icon, this.isSelected = false});
}