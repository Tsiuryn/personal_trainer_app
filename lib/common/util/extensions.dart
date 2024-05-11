import 'package:flutter/cupertino.dart';

extension PaddingExtension on int {
  Widget get w => SizedBox(
        width: toDouble(),
      );

  Widget get h => SizedBox(
        height: toDouble(),
      );
}
