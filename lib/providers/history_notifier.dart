import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/history_model.dart';

class ScanHistoryNotifier extends StateNotifier<List<ScanItem>> {
  ScanHistoryNotifier() : super([]);
  
  void addScan(String id,String value){
    state = [
      ScanItem(
        id: id,
        value: value,
        scannedAt: DateTime.now() // DateTime.timestamp()
      ),
      ...state,
    ];
  }

  void deleteScan(String id){
    state = state.where((scan) => scan.id != id).toList();
  }

  void clearHistory(){
    state = [];
  }
}