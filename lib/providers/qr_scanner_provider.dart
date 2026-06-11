import 'package:flutter_riverpod/flutter_riverpod.dart';

final scannedResultProvider = StateProvider<String?>((ref) => null);

// a state provider is designed to expose and easily modify simple variables (like enums, booleans, or strings) directly from the user interface
// perfect for basic form fields , checkboxes or counters
// ref.watch(scannedResultProvider)     read teh state
//ref.read(scannedResultProvider.notifier).(value)  write to the state