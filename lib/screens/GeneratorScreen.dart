import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:spendbuddy/providers/qr_generated_provider.dart';
import 'package:share_plus/share_plus.dart';

// consumer widget is a special UI component that
// listens to app state providers
// replaces standard StatelessWidget and automatically triggers
// a UI rebuild whenever the specific state (it relies on) updates,

class GeneratorScreen extends ConsumerStatefulWidget {
  const GeneratorScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _GeneratorScreenState();
  }
}

class _GeneratorScreenState extends ConsumerState<GeneratorScreen> {
  @override
  Widget build(BuildContext context) {
    final qrText = ref.watch(qrTextProvider);
    final generatedText = ref.watch(generatedQrProvider);

    final ScreenshotController screenshotController = ScreenshotController();


    Future<File?> saveQrImage() async {
      try {
        final Uint8List? image = await screenshotController.capture();

        if (image == null) return null;

        final directory = await getApplicationDocumentsDirectory();

        final timestamp = DateTime.now().millisecondsSinceEpoch;

        final file = File('${directory.path}/qr_$timestamp.png');

        await file.writeAsBytes(image);

        return file;
      }catch(e){
        debugPrint(e.toString());
        return null;
      }
    }

    Future<void> shareQrImage() async{
      final Uint8List? image = await screenshotController.capture();
      if(image == null) return;
      final directory = await getTemporaryDirectory();

      final file = File('${directory.path}/shared_qr.png');
      await file.writeAsBytes(image);

      await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('QR Generator')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Enter Text or URL',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  ref
                      .read(qrTextProvider.notifier)
                      .state = value;
                },
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();

                  if (qrText
                      .trim()
                      .isEmpty) return;

                  ref
                      .read(generatedQrProvider.notifier)
                      .state = qrText;
                },
                child: const Text('Generate QR'),
              ),

              const SizedBox(height: 40),

              generatedText.isNotEmpty
                  ? Screenshot(
                controller: screenshotController,
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      QrImageView(
                        data: generatedText,
                        size: 220,
                      ),
                      const SizedBox(height: 12),
                      Text(generatedText, textAlign : TextAlign.center)
                    ],
                  )
                ),
              )
                  : Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: QrImageView(data: '', size: 220),
                ),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: generatedText.isEmpty
                          ? null
                          : () async {
                        await Clipboard.setData(
                          ClipboardData(text: generatedText),
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Copied to clipboard"),
                            ),
                          );
                        }
                      },
                      child: const Text('Copy'),
                    ),
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: generatedText.isEmpty
                          ? null
                          : () async{
                        await shareQrImage();
                      },
                      child: const Text("Share"),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: generatedText.isEmpty
                          ? null
                          : () async{
                            final file = await saveQrImage();
                            if(file != null && context.mounted){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('QR saved successfully')
                                )
                              );
                            }
                      },
                      child: const Text("Save"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

  }
}