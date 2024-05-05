import 'package:flutter/cupertino.dart';

extension PaddingExtension on int {
  Widget get h => SizedBox(
        width: toDouble(),
      );

  Widget get v => SizedBox(
        height: toDouble(),
      );
}
