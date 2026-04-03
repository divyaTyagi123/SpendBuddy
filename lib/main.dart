import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spendbuddy/features/insights/insights_screen.dart';
import 'core/theme/app_theme.dart';
import 'features/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const SpendBuddyApp());
}

class SpendBuddyApp extends StatelessWidget{
  const SpendBuddyApp ({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Spend Buddy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainScreen(),
    );
  }
}
class MainScreen extends StatefulWidget{
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>{
  int index = 0;
  final screens=[
    const HomeScreen(),
    const InsightsScreen(),
  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (value){
          setState((){
            index = value;
          });
        },
        items: const[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label:"Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label:"Insights"
          )
        ]
      ),
    );
  }
}