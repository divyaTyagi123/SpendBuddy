import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:spendbuddy/providers/qr_generated_provider.dart';
import 'package:share_plus/share_plus.dart';

// consumer widget is a special UI component that
// listens to app state providers
// replaces standard StatelessWidget and automatically triggers
// a UI rebuild whenever the specific state (it relies on) updates,

class GeneratorScreen extends ConsumerWidget{
  const GeneratorScreen({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref){
    final qrText = ref.watch(qrTextProvider);
    final generatedText = ref.watch(generatedQrProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Generator'),
      ),
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
                onChanged: (value){
                  ref.read(qrTextProvider.notifier).state = value;
                },
              ),
        
              const SizedBox(height: 24),
        
              ElevatedButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();

                  if(qrText.trim().isEmpty) return;
        
                  ref.read(generatedQrProvider.notifier).state = qrText;
                },
                child: const Text('Generate QR'),
              ),
        
              const SizedBox(height:40),
        
              generatedText.isNotEmpty
                ? Card(
                  elevation:4,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: QrImageView(
                      data: generatedText,
                      size:220,
                    ),
                  ),
                )
              :Card(
                  elevation:4,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: QrImageView(data: '',size: 220)
                  )
                ),
        
              const SizedBox(height: 16,),
        
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: generatedText.isEmpty
                      ? null
                          : () async{
                        await Clipboard.setData(
                          ClipboardData(text: generatedText),
                        );
                        if(context.mounted){
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Copied to clipboard")
                            )
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
                          : (){
                            SharePlus.instance.share(
                              ShareParams(
                                text: generatedText,
                              )
                            );
                        },
                        child: const Text("Share")
                    ),
                  ),

                  const SizedBox(width:12),

                  Expanded(
                    child: ElevatedButton(
                        onPressed: generatedText.isEmpty
                            ? null
                            : (){
                          // share code here
                        },
                        child: const Text("Save")
                    ),
                  ),
                ],
              ),
            ]
          )
        ),
      )
    );
  }
}