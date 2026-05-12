import 'package:flutter/material.dart';

class GridstyleLogic extends ChangeNotifier{
  bool _gridStyle = false;
  bool get gridStyle => _gridStyle;

  void toggleStyle(){
    _gridStyle = !_gridStyle;
    notifyListeners();
  }
}