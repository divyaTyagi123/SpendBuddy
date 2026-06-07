import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text("QR Toolkit"), centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            const Icon(Icons.qr_code_2, size:120),

            const SizedBox(height: 40),

            const Text(
              "Scan and Generate QR codes easily with QR Toolkit",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: (){
                  context.push('/scanner');
                },
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text("Scan QR"),
              )
            ),

            SizedBox(height:16),

            SizedBox(
              width: double.infinity,
              height: 55,
              child:ElevatedButton.icon(
                  onPressed: (){
                    context.push('/generator');
                  },
                  icon: const Icon(Icons.qr_code),
                  label: const Text("Generate QR")
              ),

            ),
          ]
        )
      )
    );
  }
}