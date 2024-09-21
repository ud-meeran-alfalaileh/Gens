// import 'package:flutter/material.dart';
// import 'package:gens/src/config/sizes/size_box_extension.dart';
// import 'package:gens/src/config/sizes/sizes.dart';
// import 'package:gens/src/config/theme/theme.dart';
// import 'package:gens/src/core/utils/app_button.dart';
// import 'package:gens/src/feature/login/model/login_form_model.dart';
// import 'package:gens/src/feature/login/view/widgte/collection/auth_form_widget.dart';
// import 'package:gens/src/feature/profile/controller/profile_controller.dart';
// import 'package:gens/src/feature/profile/view/widget/main_widget/update_password.dart';
// import 'package:gens/src/feature/profile/view/widget/text/profile_text.dart';
// import 'package:get/get.dart';

// class UpdateProfileWidget extends StatelessWidget {
//   const UpdateProfileWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(ProfileController());
//     return SafeArea(
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 IconButton(
//                     onPressed: () {
//                       Get.back();
//                     },
//                     icon: Icon(
//                       Icons.arrow_back_ios_new_outlined,
//                       color: AppTheme.lightAppColors.primary,
//                     )),
//                 SizedBox(
//                   width: context.screenWidth * .67,
//                   child: Center(
//                     child: ProfileText.mainText("Update your details"),
//                   ),
//                 ),
//               ],
//             ),
//             30.0.kH,
//             ProfileText.thirdText("Email"),
//             AuthForm(
//                 formModel: FormModel(
//                     controller: controller.email,
//                     enableText: false,
//                     hintText: "Email",
//                     icon: Icons.email_outlined,
//                     invisible: false,
//                     validator: null,
//                     type: TextInputType.emailAddress,
//                     inputFormat: [],
//                     onTap: null)),
//             (15.0.kH),
//             ProfileText.thirdText("First Name"),
//             AuthForm(
//                 formModel: FormModel(
//                     controller: controller.name,
//                     enableText: false,
//                     hintText: "Firs Name",
//                     invisible: false,
//                     icon: Icons.person_2_outlined,
//                     validator: null,
//                     type: TextInputType.text,
//                     inputFormat: [],
//                     onTap: null)),
//             (15.0.kH),
//             ProfileText.thirdText("Second Name"),
//             AuthForm(
//                 formModel: FormModel(
//                     controller: controller.secName,
//                     enableText: false,
//                     hintText: "Second Name",
//                     invisible: false,
//                     icon: Icons.person_2_outlined,
//                     validator: null,
//                     type: TextInputType.text,
//                     inputFormat: [],
//                     onTap: null)),
//             (15.0.kH),
//             ProfileText.thirdText("Phone"),
//             AuthForm(
//                 formModel: FormModel(
//                     controller: controller.phoneNumber,
//                     enableText: false,
//                     hintText: "Phone",
//                     icon: Icons.phone,
//                     invisible: false,
//                     validator: null,
//                     type: TextInputType.phone,
//                     inputFormat: [],
//                     onTap: null)),
//             (15.0.kH),
//             ProfileText.thirdText("Gender"),
//             Center(
//               child: DropdownButtonFormField<String>(
//                 value: controller.selectedGender.value,
//                 hint: ProfileText.thirdText('Select a Gender'.tr),
//                 items: controller.genderOptions.map((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(
//                       value,
//                       style: const TextStyle(
//                         fontFamily: "Inter",
//                         fontWeight: FontWeight.w400,
//                         color: Colors.black,
//                         fontSize: 14,
//                       ),
//                     ),
//                   );
//                 }).toList(),
//                 onChanged: (newValue) {
//                   controller.selectedGender.value = newValue!;
//                 },
//                 iconEnabledColor: AppTheme.lightAppColors.primary,
//                 icon: const Icon(
//                   Icons.arrow_drop_down,
//                 ),
//                 focusColor: Colors.black,
//                 decoration: InputDecoration(
//                   prefixIcon: Icon(Icons.person_2_outlined,
//                       color: AppTheme.lightAppColors.primary),
//                   border: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: AppTheme.lightAppColors.primary,
//                     ),
//                     borderRadius: BorderRadius.circular(5.0),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: AppTheme.lightAppColors.primary,
//                       width: 1.0,
//                     ),
//                     borderRadius: BorderRadius.circular(5.0),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: AppTheme.lightAppColors.primary,
//                     ),
//                     borderRadius: BorderRadius.circular(5.0),
//                   ),
//                 ),
//                 style: const TextStyle(
//                   fontSize: 16.0,
//                   color: Colors.black,
//                 ),
//                 dropdownColor: Colors.white,
//               ),
//             ),
//             20.0.kH,
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Center(
//                   child: SizedBox(
//                     width: context.screenWidth * .4,
//                     // height: context.screenHeight * .1,
//                     child: AppButton(
//                         onTap: () {
//                           controller.updateUser(context);
//                         },
//                         title: "Update"),
//                   ),
//                 ),
//                 Center(
//                     child: GestureDetector(
//                         onTap: () {
//                           Get.to(() => const UpdatePassword(),
//                               transition: Transition.downToUp);
//                         },
//                         child: Container(
//                           width: context.screenWidth * .4,
//                           height: context.screenHeight * .05,
//                           decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: AppTheme.lightAppColors.primary,
//                               ),
//                               color: AppTheme.lightAppColors.background,
//                               borderRadius: BorderRadius.circular(20)),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               Text(
//                                 "Change password",
//                                 style: TextStyle(
//                                   fontFamily: 'Inter',
//                                   fontSize: 15,
//                                   color: AppTheme.lightAppColors.primary,
//                                   fontWeight: FontWeight
//                                       .w500, // Use FontWeight.bold for the bold variant
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ))),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
