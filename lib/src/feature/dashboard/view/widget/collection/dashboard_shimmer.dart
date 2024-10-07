import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:shimmer/shimmer.dart';

Shimmer dashboardShimmer() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 90),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Container(
          height: 150,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.only(bottom: 10),
        );
      },
      separatorBuilder: (context, index) {
        return 20.0.kH;
      },
      itemCount: 6, // Show 6 shimmer placeholders
    ),
  );
}
