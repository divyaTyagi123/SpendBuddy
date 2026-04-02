import 'package:spendbuddy/data/services/hive_service.dart';

class TransactionRepository {
  final HiveService _hiveService = HiveService();

Future<void> addTransaction(Map<String,dynamic> data) async {
  await _hiveService.addTransaction(data);
}
Future<List> getTransactions() async {
  final box = await _hiveService.openBox();
  return _hiveService.getTransactions(box);
}
}