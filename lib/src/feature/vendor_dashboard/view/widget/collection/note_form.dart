import 'package:flutter/material.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/login/model/login_form_model.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class NoteForm extends StatefulWidget {
  NoteForm({
    required this.formModel,
    this.ontap,
    super.key,
  });
  FormModel formModel;
  VoidCallback? ontap;

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
          child: TextFormField(
              onTap: widget.ontap,
              onChanged: widget.formModel.onChange,
              maxLines: 3,
              minLines: 2,
              // autofocus: true,
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
              decoration: widget.formModel.icon != null
                  ? InputDecoration(
                      prefixIcon: Icon(
                        widget.formModel.icon,
                        color: AppTheme.lightAppColors.primary,
                      ),
                      filled: true,
                      fillColor: AppTheme.lightAppColors.background,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppTheme.lightAppColors.black,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppTheme.lightAppColors.primary,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                      hintText: widget.formModel.hintText.tr,
                      hintStyle: TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1.5,
                          color: AppTheme.lightAppColors.black.withOpacity(.5),
                          fontSize: 14))
                  : InputDecoration(
                      filled: true,
                      fillColor: AppTheme.lightAppColors.background,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppTheme.lightAppColors.black,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppTheme.lightAppColors.primary,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                      hintText: widget.formModel.hintText.tr,
                      hintStyle: TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1.5,
                          color: AppTheme.lightAppColors.black.withOpacity(.5),
                          fontSize: 14)))),
    );
  }
}