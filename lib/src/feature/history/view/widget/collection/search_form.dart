// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:get/get.dart';

import '../../../../../config/theme/theme.dart';

class SearchForm extends StatefulWidget {
  const SearchForm({required this.search, super.key});
  final SearchFormEntitiy search;

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    // Request focus when the page is initialized
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    // Dispose the focus node when the widget is disposed
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppTheme.lightAppColors.maincolor.withOpacity(.5),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: AppTheme.lightAppColors.containercolor.withOpacity(.2)),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: AppTheme.lightAppColors.primary.withOpacity(.1)),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          hintStyle: TextStyle(
            color: AppTheme.lightAppColors.primary.withOpacity(0.5),
          ),
        ),
      ),
      child: SizedBox(
        width: context.screenWidth,
        // height: context.screenHeight * 0.08,
        child: Stack(
          children: [
            TextFormField(
              // focusNode: _focusNode,
              style: TextStyle(
                fontFamily: 'Inter',
                color: AppTheme.lightAppColors.primary,
              ),
              cursorColor: AppTheme.lightAppColors.primary,
              readOnly: widget.search.enableText,
              keyboardType: widget.search.type,
              onTap: widget.search.ontap,
              onChanged: widget.search.onChange,
              controller: widget.search.searchController,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                floatingLabelStyle: TextStyle(
                  color: AppTheme.lightAppColors.mainTextcolor,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: AppTheme.lightAppColors.primary,
                ),
                hintText: "Search for Doctor".tr,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchFormEntitiy {
  TextEditingController searchController = TextEditingController();
  String hintText;
  bool enableText;
  VoidCallback ontap;
  TextInputType type;
  void Function(String?)? onChange;

  SearchFormEntitiy({
    required this.searchController,
    required this.hintText,
    required this.type,
    required this.ontap,
    required this.enableText,
    required this.onChange,
  });
}
