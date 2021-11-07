// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:text_to_speech/text_to_speech.dart';

class HomePageModule extends StatefulWidget {
  const HomePageModule({Key? key}) : super(key: key);

  @override
  _HomePageModuleState createState() => _HomePageModuleState();
}

class _HomePageModuleState extends State<HomePageModule> {
  final String defaultLanguage = 'en-US';

  TextToSpeech tts = TextToSpeech();

  String text = '';
  double volume = 1; // Range: 0-1
  double rate = 1.0; // Range: 0-2
  double pitch = 1.0; // Range: 0-2

  String? language;
  String? languageCode;
  List<String> languages = <String>[];
  List<String> languageCodes = <String>[];
  String? voice;

  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textEditingController.text = text;
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      initLanguages();
    });
  }

  Future<void> initLanguages() async {
    /// populate lang code (i.e. en-US)
    languageCodes = await tts.getLanguages();

    /// populate displayed language (i.e. English)
    final List<String>? displayLanguages = await tts.getDisplayLanguages();
    if (displayLanguages == null) {
      return;
    }

    languages.clear();
    for (final dynamic lang in displayLanguages) {
      languages.add(lang as String);
    }

    final String? defaultLangCode = await tts.getDefaultLanguage();
    if (defaultLangCode != null && languageCodes.contains(defaultLangCode)) {
      languageCode = defaultLangCode;
    } else {
      languageCode = defaultLanguage;
    }
    language = await tts.getDisplayLanguageByCode(languageCode!);

    /// get voice
    voice = await getVoiceByLang(languageCode!);

    if (mounted) {
      setState(() {});
    }
  }

  Future<String?> getVoiceByLang(String lang) async {
    final List<String>? voices = await tts.getVoiceByLang(languageCode!);
    if (voices != null && voices.isNotEmpty) {
      return voices.first;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.blue[900]),
      color: Colors.blue[900],
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: const Text('Text-to-Speech SMHOS'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: textEditingController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter some text here...'),
                    onChanged: (String newText) {
                      setState(() {
                        text = newText;
                      });
                    },
                  ),
                  Row(
                    children: <Widget>[
                      const Text('Volume'),
                      Expanded(
                        child: Slider(
                          activeColor: Colors.blue[900],
                          value: volume,
                          min: 0,
                          max: 1,
                          label: volume.round().toString(),
                          onChanged: (double value) {
                            initLanguages();
                            setState(() {
                              volume = value;
                            });
                          },
                        ),
                      ),
                      Text('(${volume.toStringAsFixed(2)})'),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      const Text('Rate'),
                      Expanded(
                        child: Slider(
                          activeColor: Colors.blue[900],
                          value: rate,
                          min: 0,
                          max: 2,
                          label: rate.round().toString(),
                          onChanged: (double value) {
                            setState(() {
                              rate = value;
                            });
                          },
                        ),
                      ),
                      Text('(${rate.toStringAsFixed(2)})'),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      const Text('Pitch'),
                      Expanded(
                        child: Slider(
                          activeColor: Colors.blue[900],
                          value: pitch,
                          min: 0,
                          max: 2,
                          label: pitch.round().toString(),
                          onChanged: (double value) {
                            setState(() {
                              pitch = value;
                            });
                          },
                        ),
                      ),
                      Text('(${pitch.toStringAsFixed(2)})'),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      const Text('Language'),
                      const SizedBox(
                        width: 20,
                      ),
                      DropdownButton<String>(
                        value: language,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String? newValue) async {
                          languageCode =
                              await tts.getLanguageCodeByName(newValue!);
                          voice = await getVoiceByLang(languageCode!);
                          setState(() {
                            language = newValue;
                          });
                        },
                        items: languages
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: <Widget>[
                      const Text('Voice'),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(voice ?? '-'),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(right: 10),
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.blue[900])),
                            child: const Text('Stop'),
                            onPressed: () {
                              tts.stop();
                            },
                          ),
                        ),
                      ),
                      if (supportPause)
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(right: 10),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.blue[900])),
                              child: const Text('Pause'),
                              onPressed: () {
                                tts.pause();
                              },
                            ),
                          ),
                        ),
                      if (supportResume)
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(right: 10),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.blue[900])),
                              child: const Text('Resume'),
                              onPressed: () {
                                tts.resume();
                              },
                            ),
                          ),
                        ),
                      Expanded(
                          child: Container(
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.blue[900])),
                          child: const Text('Speak'),
                          onPressed: () {
                            speak();
                          },
                        ),
                      ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool get supportPause => defaultTargetPlatform != TargetPlatform.android;

  bool get supportResume => defaultTargetPlatform != TargetPlatform.android;

  void speak() {
    tts.setVolume(volume);
    tts.setRate(rate);
    if (languageCode != null) {
      tts.setLanguage(languageCode!);
    }
    tts.setPitch(pitch);
    tts.speak(text);
  }
}



//  Padding(
//             padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
//             child: Container(
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(color: Colors.blue.shade900)),
//                 child: const TextField(
//                   maxLines: 20,
//                   decoration: InputDecoration(
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 20)),
//                 )),
//           ),
