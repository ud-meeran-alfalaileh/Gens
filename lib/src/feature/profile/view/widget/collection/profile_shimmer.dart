import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:shimmer/shimmer.dart';

Shimmer profileImageShimmer() {
  return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        padding: const EdgeInsets.all(10),
        width: 150,
        height: 150,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: AppTheme.lightAppColors.background),
      ));
}

Shimmer profileHeaderShimmer() {
  return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            width: 150,
            height: 30,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppTheme.lightAppColors.background),
          ),
          10.0.kH,
          Container(
            padding: const EdgeInsets.all(10),
            width: 150,
            height: 30,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppTheme.lightAppColors.background),
          ),
          10.0.kH,
          Container(
            padding: const EdgeInsets.all(10),
            width: 150,
            height: 30,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppTheme.lightAppColors.background),
          ),
        ],
      ));
}
