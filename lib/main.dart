import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
      home: const HomeScreen(),
    );
  }

}