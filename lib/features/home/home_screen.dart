import 'package:flutter/material.dart';

import '../transactions/add_transaction_sheet.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});

  void _openAddSheet(BuildContext context){
    showModalBottomSheet(
        context: context,
        builder: (_) => const AddTransactionSheet(),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text("Spend Buddy")),
      body: const Center(child: Text("No Transactions yet")),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _openAddSheet(context),
          child: const Icon(Icons.add),
      ),
    );
  }
}