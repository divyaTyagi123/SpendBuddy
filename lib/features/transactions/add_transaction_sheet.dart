import 'package:flutter/material.dart';
import 'package:spendbuddy/data/repositories/transaction_repository.dart';

class AddTransactionSheet extends StatefulWidget{
  const AddTransactionSheet({super.key});

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();

}

class _AddTransactionSheetState extends State<AddTransactionSheet>{
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  final TransactionRepository repo = TransactionRepository();

  String type = "expense";

  void saveTransaction() async{
    await repo.addTransaction({
      "title" : titleController.text,
      "amount" : double.parse(amountController.text),
      "type": type,
      "date": DateTime.now.toString()
    });

    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Add Transaction", style: TextStyle(fontSize:18)),

          TextField(controller: titleController,decoration: const InputDecoration(labelText:"Title")),
          TextField(controller: amountController,decoration: const InputDecoration(labelText:"Amount")),

          DropdownButton<String>(
            value: type,
            items: const[
              DropdownMenuItem(value: "income", child:Text("Income")),
              DropdownMenuItem(value: "expense", child:Text("Expense")),
            ],
            onChanged: (val) => setState(() => type = val!),
          ),
          ElevatedButton(onPressed: saveTransaction, child: const Text("Save"))
        ],
      ),
    );
  }
}