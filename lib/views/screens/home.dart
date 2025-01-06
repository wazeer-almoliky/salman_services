import 'package:flutter/material.dart';
import 'package:salman_services/utilities/constants/app_color.dart';
import 'package:salman_services/utilities/customs/app_bar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'سلمــان للخدمات العامة', backgroundColor: AppColor.primary, actions: []),
      body: Center(
        child: Text('سلمــان للخدمات العامة',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,color: AppColor.secondary,),
            label: 'الرئيسة'),
          BottomNavigationBarItem(
            icon: Icon(Icons.work,color: AppColor.secondary,),
            label: 'العملاء'),
          BottomNavigationBarItem(
            icon: Icon(Icons.home,color: AppColor.secondary,),
            label: 'التأشيرات'),
          BottomNavigationBarItem(
            icon: Icon(Icons.home,color: AppColor.secondary,),
            label: 'الفيز'),

        ],
        backgroundColor: AppColor.primary,
        ),
    );
  }
}