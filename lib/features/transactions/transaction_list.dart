import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spendbuddy/data/repositories/transaction_repository.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/category_icon.dart';
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
        final category = item['category'] ?? "Other";

        final dateTime =
        DateTime.fromMillisecondsSinceEpoch(item['date']);

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme
                .of(context)
                .cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
              )
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor:
                isIncome ? AppColors.income : AppColors.expense,
                child: Icon(getCategoryIcon(category), color: Colors.white),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['title'],
                        style: const TextStyle(fontWeight: FontWeight.bold)),

                    Text(
                      "$category • ${DateFormat.jm().format(dateTime)}",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),

              Text(
                "₹${(item['amount'] as num).toDouble().toStringAsFixed(0)}",
                style: TextStyle(
                  color: isIncome
                      ? AppColors.income
                      : AppColors.expense,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}