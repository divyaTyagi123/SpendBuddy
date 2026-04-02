import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spendbuddy/data/repositories/transaction_repository.dart';

import '../../core/theme/app_colors.dart';
class TransactionList extends StatelessWidget {
  final List transactions;

  const TransactionList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const Center(child: Text("No transactions yet"));
    }

    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final item = transactions[index];

        final isIncome = item['type'] == 'income';

        final dateTime =
        DateTime.fromMillisecondsSinceEpoch(item['date']);

        return ListTile(
          leading: CircleAvatar(
            backgroundColor:
            isIncome ? AppColors.income : AppColors.expense,
            child: Icon(
              isIncome
                  ? Icons.arrow_downward
                  : Icons.arrow_upward,
              color: Colors.white,
            ),
          ),
          title: Text(item['title']),
          subtitle: Text(
            DateFormat.jm().format(dateTime),
          ),
          trailing: Text(
            "₹${(item['amount'] as num).toDouble().toStringAsFixed(2)}",
            style: TextStyle(
              color: isIncome
                  ? AppColors.income
                  : AppColors.expense,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}