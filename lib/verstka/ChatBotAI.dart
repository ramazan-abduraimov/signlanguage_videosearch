
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sign_language/verstka/Sign_Language_Type.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:record_mp3/record_mp3.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatBote extends StatefulWidget {
  const ChatBote({Key? key}) : super(key: key);

  @override
  State<ChatBote> createState() => _ChatBoteState();
}

class _ChatBoteState extends State<ChatBote> {


  TextEditingController _textEditingController = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool isEmpty = false;
  String statusText = '';
  String? recordFilePath;
  Color buttonColor = Colors.red;
  bool isRecording = false;
  String _responseText = '';

  String kyrgyzText = 'Сураныз';


  Future<void> _speakText(String text) async {
    String apiUrl = 'http://tts.ulut.kg/api/tts';
    String token =
        '9833a3e6dc863668f4203a922936fe860c565ba36400b95a0aa72e9b7e7f8ee2d9503325c5b05fa5e81b46b5613025167acb521f454fc9012352935c7d7403d7';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },

        body: json.encode({'speaker_id': 2, 'text': text}),

      );
      print(json.encode({'speaker_id': 2, 'text': text}),);

      if (response.statusCode == 200) {
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        File audioFile = File('$tempPath/tempAudio.mp3');

        await audioFile.writeAsBytes(response.bodyBytes);

        await _audioPlayer.setFilePath(audioFile.path);
        await _audioPlayer.play();
      } else {
        throw Exception(
            'Failed to load audio. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<String> _translateToEnglish(String text) async {
    String apiKey = 'AIzaSyAPXbaIlXvuDRCDtnPdh0lh83bo0zW0fps';
    String apiUrl =
        'https://translation.googleapis.com/language/translate/v2?key=$apiKey';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'q': text,
          'source': 'ky',
          'target': 'en',
          'format': 'text'
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['data']['translations'][0]['translatedText'];
      } else {
        print('Failed to translate text to English: ${response.statusCode}');
        return '';
      }
    } catch (e) {
      print('Error translating text to English: $e');
      return '';
    }
  }

  Future<String> _translateToKyrgyz(String text) async {
    String apiKey = 'AIzaSyAPXbaIlXvuDRCDtnPdh0lh83bo0zW0fps';
    String apiUrl =
        'https://translation.googleapis.com/language/translate/v2?key=$apiKey';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'q': text,
          'source': 'en',
          'target': 'ky',
          'format': 'text'
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['data']['translations'][0]['translatedText'];
      } else {
        print('Failed to translate text to Kyrgyz: ${response.statusCode}');
        return '';
      }
    } catch (e) {
      print('Error translating text to Kyrgyz: $e');
      return '';
    }
  }

  Future<void> _speakGeneratedText(String originalText) async {
    try {
      // Translate text to English
      String englishText = await _translateToEnglish(originalText);

      // Make request to Gemini API with translated English text
      String apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyBo2ZyghDOaPHZSQRerfWBG9p_fv07uWtU';


      final geminiResponse = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'contents': [{'parts': [{'text': englishText}]}]}),
      );

      if (geminiResponse.statusCode == 200) {
        final jsonResponse = json.decode(geminiResponse.body);
        final generatedText =
        jsonResponse['candidates'][0]['content']['parts'][0]['text'];

        // Split the generated text into words
        List<String> words = generatedText.split(' ');

        // Take only the first 10 words
        String limitedText = words.take(100).join(' ');

        // Translate the limited text to Kyrgyz
        String z = await _translateToKyrgyz(limitedText);
        setState(() {
          kyrgyzText= z;
        });
        // Speak the translated Kyrgyz text
        await _speakText(kyrgyzText);
      } else {
        throw Exception(
            'Error generating text from Gemini: ${geminiResponse.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {},
        child: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Image.asset("assets/images/Sign Language.png"),
                    Container(child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 18, 40, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.menu),
                              color: Colors.white,
                            ),
                            Row(children: [Text("Үн жардамчысы ",style: TextStyle(color: Colors.white,fontSize: 17),),
                              SizedBox(width: 18,),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) => SignLanguageType(),
                                    ));
                                  },
                                  child: Image.asset("assets/images/TextToSpeach.png",width: 42,height: 42,)),
                            ],)

                          ],
                        ),
                      ),
                      SizedBox(height: 120,),
                      Container(
                        width: 350,
                        height: 500,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Colors.lightBlueAccent),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(kyrgyzText,style: TextStyle(fontSize: 20),),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 30, 20, 0),
                        child: Container(
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _textEditingController,
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black),
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        width: 2,
                                        color:
                                        Color.fromRGBO(42, 70, 255, 1),
                                      ),
                                      borderRadius:
                                      BorderRadius.circular(20),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        width: 2,
                                        color:
                                        Color.fromRGBO(42, 70, 255, 1),
                                      ),
                                      borderRadius:
                                      BorderRadius.circular(20),
                                    ),
                                    labelText: _responseText,
                                    labelStyle: TextStyle(
                                        color:
                                        Color.fromRGBO(51, 57, 132, 1)),
                                  ),
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      setState(() {
                                        isEmpty = true;
                                      });
                                    } else {
                                      setState(() {
                                        isEmpty = false;
                                      });
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (isEmpty) {
                                    _speakGeneratedText(_textEditingController.text.trim());

                                  }
                                },
                                onLongPressStart: (_) =>
                                    _handleRecordingStart(),
                                onLongPressEnd: (_) {
                                  setState(() {
                                  _handleRecordingStop();

                                  });
                                },
                                child: CircleAvatar(
                                  radius: 28,
                                  backgroundColor: buttonColor,
                                  child: Icon(
                                    isEmpty
                                        ? Icons.send
                                        : isRecording
                                        ? Icons.mic
                                        : Icons.mic_sharp,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),


                    ],),),


                  ],
                )
              ],
            ),
          ),),
      ),
    );

  }


  Future<void> _handleRecordingStart() async {
    if (!await _checkPermission()) {
      statusText = 'No microphone permission';
      return;
    }
    setState(() {
      statusText = 'Recording...';
      isRecording = true;
      buttonColor = Colors.blue;
    });

    recordFilePath = await _getFilePath();
    RecordMp3.instance.start(recordFilePath!, (type) {
      setState(() {
        statusText = 'Record error--->$type';
      });
    });
  }

  Future<void> _handleRecordingStop() async {
    bool stopped = RecordMp3.instance.stop();
    if (!stopped) {
      return;
    }

    setState(() {
      statusText = 'Record complete';
      isRecording = false;
      buttonColor = Colors.red;
    });

    // Send recorded audio to API and get response text
    String responseText = await _sendToAPI();

    // Speak the generated text
    await _speakGeneratedText(responseText);
  }

  Future<bool> _checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      return status == PermissionStatus.granted;
    }
    return true;
  }

  Future<String> _sendToAPI() async {
    if (recordFilePath == null) {
      print('Recorded file path is null');
      return '';
    }

    File file = File(recordFilePath!);
    if (!file.existsSync()) {
      print('Recorded file does not exist');
      return '';
    }

    String apiUrl = 'https://asr.ulut.kg/api/receive_data';
    var headers = {
      'Authorization':
      'Bearer 9833a3e6dc863668f4203a922936fe860c565ba36400b95a0aa72e9b7e7f8ee2d9503325c5b05fa5e81b46b5613025167acb521f454fc9012352935c7d7403d7'
    };

    List<int> bytes = await file.readAsBytes();

    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.headers.addAll(headers);
    request.files.add(
        http.MultipartFile.fromBytes('audio', bytes, filename: 'test.mp3'));

    try {
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        print('API Response: $responseBody');

        try {
          Map<String, dynamic> jsonResponse = json.decode(responseBody);
          String textFromAPI = jsonResponse['text'] ?? '';
          setState(() {
            _responseText = textFromAPI;
          });
          return textFromAPI;
        } catch (e) {
          print('Error decoding response: $e');
          setState(() {
            _responseText = 'Error decoding response';
          });
          return '';
        }
      } else {
        print('API Request failed with status code: ${response.statusCode}');
        return '';
      }
    } catch (e) {
      print('Error sending request to API: $e');
      return '';
    }
  }

  Future<String> _getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + '/record';
    Directory d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return sdPath + '/test.mp3';
  }
}
