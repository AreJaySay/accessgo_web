import 'package:flutter/material.dart';
import 'package:pass_slip_management_web/utils/palettes.dart';
import 'package:shimmer/shimmer.dart';

class ShimmeringLoader{
  Widget pageLoader({required double radius, required double width, required double height, bool isPreparing = false}){
    return Shimmer.fromColors(
        baseColor: isPreparing ? Colors.white : Colors.grey.shade200,
        highlightColor: isPreparing ? palettes.blue : Colors.white,
        child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: isPreparing ?
              BorderRadius.only(
                topRight: Radius.circular(5),
                topLeft: Radius.circular(5)
              ) :
              BorderRadius.circular(radius),
            )
        )
    );
  }
}