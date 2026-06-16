import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:spendbuddy/providers/qr_scanner_provider.dart';
import 'package:flutter/services.dart';

import '../providers/history_provider.dart';

class ScannerScreen extends ConsumerStatefulWidget{
  const ScannerScreen({super.key});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen>{

  final MobileScannerController controller = MobileScannerController();
  bool isScanned = false;


  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    final scannedResult = ref.watch(scannedResultProvider);

    return Scaffold(
      appBar : AppBar(title: const Text('QR Scanner')),
      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            Container(
              height:300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),

              clipBehavior: Clip.antiAlias,

              child: MobileScanner(
                controller: controller,

                onDetect: (capture){
                  if(isScanned) return;

                  final code = capture.barcodes.first.rawValue;

                  if(code== null) return;

                  setState(() {
                    isScanned = true;
                  });

                  ref.read(scanHistoryProvider.notifier).addScan(code,code);
                  ref.read(scannedResultProvider.notifier).state = code;
                }
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Text(scannedResult ?? 'No QR detected'),
              )
            ),

            ElevatedButton(
              onPressed: scannedResult == null ? null : ()async {
                await Clipboard.setData(ClipboardData(text: scannedResult,));
                if(context.mounted){
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(
                    'Copied to Clipboard'
                  )));
                }
              },
              child: const Text('Copy')
            )

          ],
        ),
      )
    );
  }

}