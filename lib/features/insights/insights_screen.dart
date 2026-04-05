import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../data/repositories/transaction_repository.dart';
import '../../core/theme/app_colors.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  final TransactionRepository repo = TransactionRepository();

  Map<String, double> categoryData = {};

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final data = await repo.getTransactions();

    Map<String, double> tempData = {};

    for (var item in data) {
      final category = item['category'] ?? "Other";
      final amount = (item['amount'] as num).toDouble();

      // Only expenses
      if (item['type'] == 'expense') {
        tempData[category] = (tempData[category] ?? 0) + amount;
      }
    }

    setState(() {
      categoryData = tempData;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (categoryData.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("No data for insights")),
      );
    }

    final total = categoryData.values.reduce((a, b) => a + b);

    return Scaffold(
      appBar: AppBar(title: const Text("Insights")),
      body: Column(
        children: [
          const SizedBox(height: 20),

          //  PREMIUM CARD
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  "Spending Breakdown",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                // DONUT CHART
                SizedBox(
                  height: 250,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          centerSpaceRadius: 60,
                          sectionsSpace: 2,
                          sections: categoryData.entries.map((entry) {
                            final percent =
                                (entry.value / total) * 100;

                            return PieChartSectionData(
                              value: entry.value,
                              color: _getColor(entry.key),
                              title:
                              "${percent.toStringAsFixed(0)}%",
                              radius: 70,
                              titleStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      //  CENTER TOTAL
                      Text(
                        "₹${total.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // LEGEND
          Expanded(
            child: ListView(
              children: categoryData.entries.map((entry) {
                return _buildLegend(
                  entry.key,
                  entry.value,
                  _getColor(entry.key),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(String title, double amount, Color color) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 6, backgroundColor: color),
              const SizedBox(width: 8),
              Text(title),
            ],
          ),
          Text("₹${amount.toStringAsFixed(2)}"),
        ],
      ),
    );
  }

  // CATEGORY COLORS
  Color _getColor(String category) {
    switch (category) {
      case "Food":
        return Colors.orange;
      case "Travel":
        return Colors.blue;
      case "Shopping":
        return Colors.purple;
      case "Bills":
        return Colors.red;
      case "Health":
        return Colors.green;
      case "Entertainment":
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }
}