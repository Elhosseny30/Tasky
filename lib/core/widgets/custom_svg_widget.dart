import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomSvgWidget extends StatelessWidget {
  CustomSvgWidget({super.key, required this.path, this.withColorFilter = true,this.height,this.width});
  final String path;
  bool withColorFilter;
  final double? height;
  final double? width;
  CustomSvgWidget.withoutColor({super.key, required this.path,this.height,this.width})
    : withColorFilter = false;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      colorFilter: withColorFilter
          ? ColorFilter.mode(
              Theme.of(context).colorScheme.secondary,
              BlendMode.srcIn,
            )
          : null,
    );
  }
}
