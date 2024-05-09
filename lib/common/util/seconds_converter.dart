String parseSeconds(int seconds) {
  String getNumber(int numb) => numb < 10 ? '0$numb' : '$numb';

  return '${getNumber(seconds ~/ 60)}:${getNumber(seconds % 60)}';
}
