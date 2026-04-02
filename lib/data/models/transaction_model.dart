class TransactionModel {
  final String id;
  final String title;
  final double amount;
  final String type;
  final String category ;
  final DateTime date;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
});
}