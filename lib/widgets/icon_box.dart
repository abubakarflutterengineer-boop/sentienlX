import 'package:flutter/material.dart';
class IconBox extends StatelessWidget { final IconData icon; final Color color; const IconBox({super.key,required this.icon,required this.color}); @override Widget build(BuildContext c)=>Container(width:46,height:46,decoration:BoxDecoration(color:color.withOpacity(.1),borderRadius:BorderRadius.circular(13)),child:Icon(icon,color:color)); }
