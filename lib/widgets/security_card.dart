import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
class SecurityCard extends StatelessWidget { final Widget child; const SecurityCard({super.key,required this.child}); @override Widget build(BuildContext c)=>Container(width:double.infinity,padding:const EdgeInsets.all(18),decoration:BoxDecoration(color:AppColors.card,borderRadius:BorderRadius.circular(20),border:Border.all(color:AppColors.border),boxShadow:[BoxShadow(color:Colors.black.withOpacity(.04),blurRadius:16,offset:const Offset(0,6))]),child:child); }
