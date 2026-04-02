import 'package:hive/hive.dart';

class HiveService{
  static const String boxName = 'transactions';

  Future<Box> openBox() async{
    return await Hive.openBox(boxName);
  }

  Future<void> addTransaction(Map<String,dynamic> data) async {
    final box = await openBox();
    await box.add(data);
  }

  List getTransactions(Box box){
    return box.values.toList();
  }
}