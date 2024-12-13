import 'package:flutter/material.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/login/model/login_form_model.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class AuthForm extends StatefulWidget {
  AuthForm({
    required this.formModel,
    this.maxLine,
    this.ontap,
    super.key,
  });
  FormModel formModel;
  VoidCallback? ontap;
  int? maxLine;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        onTap: widget.ontap,
        onChanged: widget.formModel.onChange,
        maxLines: widget.maxLine ?? 1,
        minLines: widget.maxLine ?? 1,
        // autofocus: true,
        cursorHeight: 15,
        textInputAction: TextInputAction.done,
        cursorColor: AppTheme.lightAppColors.black,
        style: TextStyle(
            color: AppTheme.lightAppColors.black,
            fontSize: 20,
            letterSpacing: 1),
        readOnly: widget.formModel.enableText,
        inputFormatters: widget.formModel.inputFormat,
        keyboardType: widget.formModel.type,
        validator: widget.formModel.validator,
        obscureText: widget.formModel.invisible,
        controller: widget.formModel.controller,
        decoration: widget.formModel.icon != null
            ? InputDecoration(
                prefixIcon: Icon(
                  widget.formModel.icon,
                  color: AppTheme.lightAppColors.secondaryColor,
                ),
                filled: true,
                fillColor: AppTheme.lightAppColors.maincolor,
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                border: const OutlineInputBorder(),
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                hintText: widget.formModel.hintText.tr,
                hintStyle: TextStyle(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w400,
                    letterSpacing: .5,
                    color: AppTheme.lightAppColors.black.withOpacity(.5),
                    fontSize: 14))
            : InputDecoration(
                filled: true,
                fillColor: AppTheme.lightAppColors.maincolor,
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                border: const OutlineInputBorder(),
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                hintText: widget.formModel.hintText.tr,
                hintStyle: TextStyle(
                  // fontFamily: "Inter",
                  fontWeight: FontWeight.w400,
                  letterSpacing:
                      0.5, // Try a negative value to force smaller spacing
                  color: AppTheme.lightAppColors.black.withOpacity(.5),
                  fontSize: 14,
                )));
  }
}
