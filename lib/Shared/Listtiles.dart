import 'package:ding_web/models/Menuitem.dart';
import 'package:ding_web/models/Orders/Order.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class Tile extends StatelessWidget {
  Future<void>? action;
  Order? list;
  Widget? title_widget;
  Widget? trailing_widget;
  Widget? subtitle_widget;
  Widget? leading_widget;
  Tile({super.key,this.title_widget,this.trailing_widget,this.subtitle_widget,this.leading_widget,this.list,this.action});

  @override
  Widget build(BuildContext context) {
    return Column(children: list!.items!.map((e) => ListTile(title: Text(e.name!),trailing: Text(e.price!),onTap: () => action,)).toList(),);
  }
}