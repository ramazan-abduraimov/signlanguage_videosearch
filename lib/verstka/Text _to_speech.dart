
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sign_language/verstka/Sign_Language_Type.dart';
import 'package:sign_language/verstka/TextToSpeech_poluchi.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class TextToSpeech extends StatefulWidget {
  const TextToSpeech({Key? key}) : super(key: key);

  @override
  State<TextToSpeech> createState() => _TextToSpeechState();
}

class _TextToSpeechState extends State<TextToSpeech> {


  final TextEditingController _textController = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> _speakText(String text) async {
    String apiUrl = 'http://tts.ulut.kg/api/tts';
    String token = '9833a3e6dc863668f4203a922936fe860c565ba36400b95a0aa72e9b7e7f8ee2d9503325c5b05fa5e81b46b5613025167acb521f454fc9012352935c7d7403d7';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        body: json.encode({'speaker_id': 2, 'text': text}),

      );

      print('Request URL: ${Uri.parse(apiUrl)}');
      print('Request headers: ${json.encode({'Authorization': 'Bearer $token'})}');
      print('Request body: ${json.encode({'text': text, 'speaker_id': '1'})}');
      print('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Get temporary file path
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        File audioFile = File('$tempPath/tempAudio.mp3');

        // Write audio data to file
        await audioFile.writeAsBytes(response.bodyBytes);

        // Play audio from file
        await _audioPlayer.setFilePath(audioFile.path);
        await _audioPlayer.play();
      } else {
        throw Exception('Failed to load audio. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void dispose() {
    _textController.dispose();
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
                            Row(children: [Text("Текстке үн берүү ",style: TextStyle(color: Colors.white,fontSize: 17),),
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
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextField(
                          controller: _textController,

                          maxLines: 10,
                          style: const TextStyle(fontSize: 30, color: Colors.black),
                          decoration: InputDecoration(

                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 2,
                                color: Color.fromRGBO(42, 70, 255, 1),
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 2,
                                color: Color.fromRGBO(42, 70, 255, 1),
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),

                            labelText: 'Текст',
                            labelStyle: TextStyle(color: Color.fromRGBO(51, 57, 132, 1)),
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () {

                          String text = _textController.text.trim();
                        if (text.isNotEmpty) {
                          _speakText(text);
                        } else {
                          // Handle empty text input
                          print('Text field is empty');
                        }

                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => TextToSpeechPoluchi(text: _textController.text),
                          //   ),
                          // );
                        },
                        child: Center(child: CircleAvatar(
                          radius: 40,
                          child: Icon(Icons.send,size: 45,),
                        ),),
                      )



                    ],),),


                  ],
                )
              ],
            ),
          ),),
      ),
    );

  }
}
