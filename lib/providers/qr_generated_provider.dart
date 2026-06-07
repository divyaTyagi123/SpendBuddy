import 'package:flutter_riverpod/flutter_riverpod.dart';

final qrTextProvider = StateProvider<String>((ref){
  return '';
});

final generatedQrProvider = StateProvider<String> ((ref) => '');