import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/repositories/transaction_repository.dart';

class InsightsScreen extends StatefulWidget{
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();

}
class _InsightsScreenState extends State<InsightsScreen>{
  final TransactionRepository repo = TransactionRepository();

  double income = 0;
  double expense = 0;

  @override
  void initState(){
    super.initState();
    loadData();
  }

  Future<void> loadData() async{
    final data = await repo.getTransactions();
    double inc = 0;
    double exp = 0;

    for(var item in data){
      if(item['type'] == 'income'){
        inc += item['amount'];
      }else{
        exp += item['amount'];
      }
    }

    setState(() {
      income = inc;
      expense = exp;
    });
  }

  @override
  Widget build(BuildContext context){
    final total = income + expense;
    if(total == 0){
      return const Center(child: Text("No data for insights"));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Insights")),
      body: Column(
        children:[
          const SizedBox(height:20),
          // pie chart
          SizedBox(
            height:250,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    centerSpaceRadius: 50,
                    sectionsSpace: 2,
                    sections: [
                      PieChartSectionData(
                        value: income,
                        color: AppColors.income,
                        title: "${((income/(income+expense)) *100).toStringAsFixed(0)}%",
                        radius: 60,
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                      PieChartSectionData(
                        value: expense,
                        color:AppColors.expense,
                        title: "${((expense/(income+expense))* 100).toStringAsFixed(0)}%",
                        radius: 60,
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight:FontWeight.bold
                        )
                      )
                    ]
                  ),
                ),
                Text(
                    "${(income - expense).toStringAsFixed(0)}",
                    style: const TextStyle(fontWeight:FontWeight.bold)
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Legend
          _buildLegend("Income",income, AppColors.income),
          _buildLegend("Expense", expense,AppColors.expense),
        ]
      ),
    );
  }

  Widget _buildLegend(String title,double amount, Color color){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:[
          Row(
            children:[
              CircleAvatar(radius: 6, backgroundColor: color,),
              const SizedBox(width:8),
              Text(title),
            ],
          ),
          Text("₹${amount.toStringAsFixed(2)}")
        ],
      ),
    );
  }
}