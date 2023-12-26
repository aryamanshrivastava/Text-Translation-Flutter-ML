// ignore_for_file: avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController textEditingController = TextEditingController();
  String result = 'Translated text...';
  dynamic modelManager;
  dynamic languageIdentifier;

  @override
  void initState() {
    //implement initState
    super.initState();
    languageIdentifier = LanguageIdentifier(confidenceThreshold: 0.5);
    modelManager = OnDeviceTranslatorModelManager();

    checkAndDownloadModel();
  }

  bool isEnglish = false;
  bool isHindi = false;
  dynamic onDeviceTranslator;
  checkAndDownloadModel() async {
    print("check model start");

    //if models are loaded then create translator
    isEnglish =
        await modelManager.isModelDownloaded(TranslateLanguage.english.bcpCode);
    isHindi =
        await modelManager.isModelDownloaded(TranslateLanguage.hindi.bcpCode);
    //download models if not downloaded
    if (!isEnglish) {
      isEnglish =
          await modelManager.downloadModel(TranslateLanguage.english.bcpCode);
    }
    if (!isHindi) {
      isHindi =
          await modelManager.downloadModel(TranslateLanguage.hindi.bcpCode);
    }
    //if models are loaded then create translator
    if (isEnglish && isHindi) {
      onDeviceTranslator = OnDeviceTranslator(
          sourceLanguage: TranslateLanguage.english,
          targetLanguage: TranslateLanguage.hindi);
    }

    print("check model end");
  }

  //translate text
  translateText(String text) async {
    if (isEnglish && isHindi) {
      final String response = await onDeviceTranslator.translateText(text);
      setState(() {
        result = response;
      });
    }
    identifyLanguages(text);
  }

  //identify text
  identifyLanguages(String text) async {
    final String response = await languageIdentifier.identifyLanguage(text);
    textEditingController.text += "($response)";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: Colors.black12,
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Container(
                margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
                height: 80,
                child: Card(
                  color: Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        'English',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        height: 78,
                        width: 1,
                        color: Colors.white,
                      ),
                      const Text(
                        'Hindi',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    controller: textEditingController,
                    decoration: const InputDecoration(
                        fillColor: Colors.white,
                        hintText: 'Type text here...',
                        filled: true,
                        border: InputBorder.none),
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                    maxLines: 100,
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      textStyle: const TextStyle(color: Colors.white),
                      backgroundColor: Colors.green),
                  child: const Text('Translate',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  onPressed: () {
                    translateText(textEditingController.text);
                  },
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      result,
                      style: const TextStyle(fontSize: 20),
                    )),
              ),
            ],
          ),
        ));
  }
}
