import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:record_mp3/record_mp3.dart';
import 'package:permission_handler/permission_handler.dart';

class TextToSpeechApp extends StatefulWidget {
  @override
  _TextToSpeechAppState createState() => _TextToSpeechAppState();
}

class _TextToSpeechAppState extends State<TextToSpeechApp> {
  String statusText = '';
  String? recordFilePath;
  Color buttonColor = Colors.red;
  bool isRecording = false;
  String _responseText = '';

  final AudioPlayer _audioPlayer = AudioPlayer();
  TextEditingController _textEditingController = TextEditingController();

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
        String kyrgyzText = await _translateToKyrgyz(limitedText);

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
      appBar: AppBar(
        title: Text('Text-to-Speech Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Enter text here',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                Center(
                  child: GestureDetector(
                    onLongPressStart: (_) => _handleRecordingStart(),
                    onLongPressEnd: (_) => _handleRecordingStop(),
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: buttonColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Text(
                          isRecording ? 'Recording...' : 'Hold to Record',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {},
              child: Text('Generate and Speak'),
            ),
          ],
        ),
      ),
      bottomSheet: _responseText.isNotEmpty
          ? Container(
        color: Colors.grey[200],
        padding: EdgeInsets.all(16),
        child: Text(
          _responseText,
          style: TextStyle(fontSize: 16),
        ),
      )
          : null,
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