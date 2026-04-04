import 'package:flutter/material.dart';
import '../../data/repositories/transaction_repository.dart';
import '../transactions/add_transaction_sheet.dart';
import '../transactions/transaction_list.dart';
import 'dashboard_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TransactionRepository repo = TransactionRepository();

  List transactions = [];

  double totalBalance = 0;
  double totalIncome = 0;
  double totalExpense = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final data = await repo.getTransactions();

    double income = 0;
    double expense = 0;

    for (final item in data) {
      final amount = (item['amount'] as num).toDouble();

      if (item['type'] == 'income') {
        income += item['amount'];
      } else {
        expense += item['amount'];
      }
    }

    setState(() {
      transactions = data;
      totalIncome = income;
      totalExpense = expense;
      totalBalance = income - expense;
    });

  }

  Future<void> _openAddSheet() async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const AddTransactionSheet(),
    );

    if (result == true) {
      await loadData(); // refresh EVERYTHING
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SpendBuddy"),
      ),
      body: Column(
        children: [
          DashboardCard(
            balance: totalBalance,
            income: totalIncome,
            expense: totalExpense,
          ),
          Expanded(
            child: TransactionList(
              transactions: transactions, // pass data
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddSheet,
        child: const Icon(Icons.add),
      ),
    );
  }
}