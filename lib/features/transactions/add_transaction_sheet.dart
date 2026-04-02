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
    final title = titleController.text.trim();
    final amountText = amountController.text.trim();

    if (title.isEmpty || amountText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }
    final amount = double.tryParse(amountText);

    if(amount == null){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid amount")),
      );
      return;
    }
    await repo.addTransaction({
      "title" : titleController.text,
      "amount" : double.parse(amountController.text),
      "type": type,
      "date": DateTime.now().millisecondsSinceEpoch,
    });
    Navigator.pop(context,true);
  }
  @override
  void dispose(){
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Add Transaction", style: TextStyle(fontSize:18, fontWeight: FontWeight.bold)),

          const SizedBox(height: 16),

          TextField(controller: titleController,decoration: const InputDecoration(labelText:"Title",border:OutlineInputBorder())),

          const SizedBox(height: 16),

          TextField(controller: amountController,decoration: const InputDecoration(labelText:"Amount",border:OutlineInputBorder())),

          const SizedBox(height: 12),

          DropdownButtonFormField<String>(
            initialValue: type,
            decoration: const InputDecoration(border:OutlineInputBorder()),
            items: const[
              DropdownMenuItem(value: "income", child:Text("Income")),
              DropdownMenuItem(value: "expense", child:Text("Expense")),
            ],
            onChanged: (val) => setState(() => type = val!),
          ),

          const SizedBox(height:16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: saveTransaction,
              child: const Text("Save Transaction"),
            ),
          ),

        ],
      ),
    );
  }
}