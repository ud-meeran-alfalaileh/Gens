import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/login/model/login_form_model.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class AuthForm extends StatefulWidget {
  AuthForm({
    required this.formModel,
    this.ontap,
    super.key,
  });
  FormModel formModel;
  VoidCallback? ontap;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
          height: context.screenHeight * .08,
          width: context.screenWidth,
          child: TextFormField(
              cursorHeight: 15,
              textInputAction: TextInputAction.done,
              cursorColor: AppTheme.lightAppColors.black,
              // style: TextStyle(color: AppTheme.lightAppColors.black,fontSize: 20),
              readOnly: widget.formModel.enableText,
              inputFormatters: widget.formModel.inputFormat,
              keyboardType: widget.formModel.type,
              validator: widget.formModel.validator,
              obscureText: widget.formModel.invisible,
              controller: widget.formModel.controller,
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    widget.formModel.icon,
                    color: AppTheme.lightAppColors.primary.withOpacity(.6),
                  ),
                  filled: true,
                  fillColor: AppTheme.lightAppColors.background,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppTheme.lightAppColors.black,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppTheme.lightAppColors.primary,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  hintText: widget.formModel.hintText.tr,
                  hintStyle: TextStyle(
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                      color: AppTheme.lightAppColors.black.withOpacity(.5),
                      fontSize: 14)))),
    );
  }
}