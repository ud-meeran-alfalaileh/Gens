// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:lottie/lottie.dart';
// import 'package:sofiaShopApplication/src/feature/history/view/main_page/history_page.dart';
 
// class ConfirmPage extends StatefulWidget {
//   const ConfirmPage({super.key,required this.token});
// final String token;
//   @override
//   State<ConfirmPage> createState() => _ConfirmPageState();
// }

// class _ConfirmPageState extends State<ConfirmPage> {

//   @override
//   void initState() {
//     super.initState();
// navigateToOtherPage();    
//   }
//  Future<void> navigateToOtherPage()async{
//     Timer(const Duration(seconds: 2), () {
//        Get.off( HistoryPage(token: widget.token,),
//           transition: Transition.fade,
//           duration: const Duration(milliseconds: 900));
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Center(
//           child: Lottie.asset('assets/animation/Animation - 1718193787753.json'),
//         ),
      
//     );
//   }
// }
