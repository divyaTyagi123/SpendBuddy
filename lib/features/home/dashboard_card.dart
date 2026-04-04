import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class DashboardCard extends StatelessWidget {
  final double balance;
  final double income;
  final double expense;

  const DashboardCard({
    super.key,
    required this.balance,
    required this.income,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF00509E), Color(0xFF007ACC)],
        ),
        boxShadow:[
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset:const Offset(0,5)
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Total Balance",
            style: TextStyle(color: Colors.white70),
          ),

          const SizedBox(height: 8),

          // 💰 TOTAL BALANCE
          Text(
            "₹${balance.toStringAsFixed(0)}",
            style: TextStyle(
              color: balance < 0 ? Colors.red : Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildItem("Income", income, AppColors.income),
              _buildItem("Expense", expense, AppColors.expense),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItem(String title, double amount, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white70),
        ),

        const SizedBox(height: 4),

        Text(
          "₹${amount.toStringAsFixed(2)}",
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}