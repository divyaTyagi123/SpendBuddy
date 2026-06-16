import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/history_model.dart';
import 'history_notifier.dart';

final scanHistoryProvider = StateNotifierProvider<
    ScanHistoryNotifier, List<ScanItem>>(
    (ref) => ScanHistoryNotifier(),
);