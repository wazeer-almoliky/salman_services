import 'package:arabic_font/arabic_font.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final List<Widget> actions;
  const CustomAppBar({super.key, required this.title, required this.backgroundColor, required this.actions});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title,style: ArabicTextStyle(arabicFont: ArabicFont.arefRuqaa,color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
      backgroundColor: backgroundColor,
      actions: actions,
      toolbarHeight: 150,
      centerTitle: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(33),
        bottomRight: Radius.circular(33)
        )),
    );
  }
  @override
  Size get preferredSize => Size.fromHeight(95);
}