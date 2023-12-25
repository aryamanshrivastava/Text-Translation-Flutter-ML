// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
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
  @override
  void initState() {
    //implement initState
    super.initState();
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
  translateText(String text) async {}

  //identify text
  identifyLanguages(String text) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Container(
          color: Colors.black12,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
                height: 50,
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
                        height: 48,
                        width: 1,
                        color: Colors.white,
                      ),
                      const Text(
                        'Urdu',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20, left: 2, right: 2),
                width: double.infinity,
                height: 250,
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: textEditingController,
                      decoration: const InputDecoration(
                          fillColor: Colors.white,
                          hintText: 'Type text here...',
                          filled: true,
                          border: InputBorder.none),
                      style: const TextStyle(color: Colors.black),
                      maxLines: 100,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15, left: 13, right: 13),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(color: Colors.white),
                      backgroundColor: Colors.green),
                  child: const Text('Translate'),
                  onPressed: () {
                    translateText(textEditingController.text);
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15, left: 10, right: 10),
                width: double.infinity,
                height: 250,
                child: Card(
                  color: Colors.white,
                  child: Container(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        result,
                        style: const TextStyle(fontSize: 18),
                      )),
                ),
              ),
            ],
          ),
        )));
  }
}
