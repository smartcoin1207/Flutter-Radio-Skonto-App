import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ErrorImageWidget extends StatelessWidget {
  const ErrorImageWidget({
    this.height,
    this.width,
    super.key,
  });

  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(padding: EdgeInsets.all(10),
        child: SvgPicture.asset(
          height: height,
          width: width,
          'assets/image/skonto_logo_svg.svg',
        ),
      ),
    );
  }
}
