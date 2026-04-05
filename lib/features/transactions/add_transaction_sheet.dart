import 'package:flutter/material.dart';
import 'package:spendbuddy/data/repositories/transaction_repository.dart';
import '../../core/constants/app_categories.dart';

class AddTransactionSheet extends StatefulWidget {
  final Map<String, dynamic>? existingData;
  final int? index;

  const AddTransactionSheet({
    super.key,
    this.existingData,
    this.index,
  });

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  final TransactionRepository repo = TransactionRepository();

  String type = "expense";
  String category = "Food";

  @override
  void initState() {
    super.initState();

    // PREFILL FOR EDIT
    if (widget.existingData != null) {
      titleController.text = widget.existingData!['title'];
      amountController.text =
          widget.existingData!['amount'].toString();
      type = widget.existingData!['type'];
      category = widget.existingData!['category'] ?? "Food";
    }
  }

  void saveTransaction() async {
    final title = titleController.text.trim();
    final amountText = amountController.text.trim();

    if (title.isEmpty || amountText.isEmpty) return;

    final amount = double.tryParse(amountText);

    if (amount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid amount")),
      );
      return;
    }

    final data = {
      "title": title,
      "amount": amount,
      "type": type,
      "category": category,
      "date": DateTime.now().millisecondsSinceEpoch,
    };

    if (widget.index != null) {
      //  EDIT
      await repo.updateTransaction(widget.index!, data);
    } else {
      // ADD
      await repo.addTransaction(data);
    }

    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.index != null
                ? "Edit Transaction"
                : "Add Transaction",
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: titleController,
            decoration: const InputDecoration(
                labelText: "Title", border: OutlineInputBorder()),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                labelText: "Amount", border: OutlineInputBorder()),
          ),

          const SizedBox(height: 12),

          DropdownButtonFormField<String>(
            value: type,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: "income", child: Text("Income")),
              DropdownMenuItem(value: "expense", child: Text("Expense")),
            ],
            onChanged: (val) => setState(() => type = val!),
          ),

          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            value: category,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Category",
            ),
            items: AppCategories.categories.map((cat) {
              return DropdownMenuItem(
                value: cat,
                child: Text(cat),
              );
            }).toList(),
            onChanged: (val) => setState(() => category = val!),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: saveTransaction,
              child: Text(widget.index != null
                  ? "Update Transaction"
                  : "Save Transaction"),
            ),
          ),
        ],
      ),
    );
  }
}