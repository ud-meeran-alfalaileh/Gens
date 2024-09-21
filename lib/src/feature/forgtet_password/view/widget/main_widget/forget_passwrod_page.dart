// import 'package:flutter/material.dart';
// import 'package:gens/src/config/sizes/size_box_extension.dart';
// import 'package:gens/src/core/utils/app_button.dart';
// import 'package:gens/src/feature/forgtet_password/controller/forget_password_controller.dart';
// import 'package:gens/src/feature/forgtet_password/view/widget/text/forget_password_text.dart';
// import 'package:gens/src/feature/login/model/login_form_model.dart';
// import 'package:gens/src/feature/login/view/widgte/collection/auth_form_widget.dart';
// import 'package:get/get.dart';

// class ForgetPasswrodPage extends StatelessWidget {
//   const ForgetPasswrodPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // final controller = Get.put(ForgetPasswordController());
//     return Column(

//       children: [
//         ForgetPasswordText.secText("Enter New password".tr),
//         AuthForm(
//           formModel: FormModel(
//               icon: Icons.lock_outline,
//               controller: controller.password,
//               enableText: false,
//               hintText: "loginPassword".tr,
//               invisible: true,
//               validator: null,
//               type: TextInputType.text,
//               inputFormat: [],
//               onTap: () {}),
//         ),
//         30.0.kH,
//         AppButton(
//             onTap: () {
//               controller.email;
//             },
//             title: "Continue")
//       ],
//     );
//   }
// }
