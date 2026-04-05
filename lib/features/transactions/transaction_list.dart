import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spendbuddy/data/repositories/transaction_repository.dart';
import '../transactions/add_transaction_sheet.dart';

class TransactionList extends StatelessWidget {
  final List transactions;
  final VoidCallback onDelete;

  const TransactionList({
    super.key,
    required this.transactions,
    required this.onDelete,
  });

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

        return Dismissible(
          key: Key(item['date'].toString()),
          direction: DismissDirection.endToStart,

          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: Colors.red,
            child: const Icon(Icons.delete, color: Colors.white),
          ),

          onDismissed: (direction) async {
            final repo = TransactionRepository();

            await repo.deleteTransaction(index);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Transaction deleted")),
            );

            onDelete();
          },

          child: GestureDetector(
            onTap: () async {
              final result = await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => AddTransactionSheet(
                  existingData: Map<String, dynamic>.from(item),
                  index: index,
                ),
              );

              if (result == true) {
                onDelete(); // refresh
              }
            },

            child: Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 6),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor:
                    isIncome ? Colors.green : Colors.red,
                    child: const Icon(Icons.currency_rupee,
                        color: Colors.white),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(item['title'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold)),

                        Text(
                          "$category • ${DateFormat.jm().format(dateTime)}",
                        ),
                      ],
                    ),
                  ),

                  Text(
                    "₹${(item['amount'] as num).toDouble().toStringAsFixed(0)}",
                    style: TextStyle(
                      color: isIncome
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}