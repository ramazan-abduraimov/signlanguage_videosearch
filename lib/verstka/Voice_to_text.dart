
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:sign_language/verstka/Sign_Language_Type.dart';

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class VoiceToText extends StatefulWidget {
  const VoiceToText({Key? key}) : super(key: key);

  @override
  State<VoiceToText> createState() => _VoiceToTextState();
}

class _VoiceToTextState extends State<VoiceToText> {

  String statusText = '';
  String? recordFilePath;
  Color buttonColor = Color.fromRGBO(42, 70, 255, 1.0);
  bool isRecording = false;
  String _responseText = '';
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
                            Row(children: [Text("Үндү текстке айландыруу",style: TextStyle(color: Colors.white,fontSize: 17),),
                              SizedBox(width: 18,),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) => SignLanguageType(),
                                    ));
                                  },
                                  child: Image.asset("assets/images/Voice_to_text_small.png",width: 42,height: 42,)),
                            ],)

                          ],
                        ),
                      ),
                      SizedBox(height: 120,),

                      Container(
                        width: 350,
                        height: 450,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Colors.lightBlueAccent),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 20, 10, 10),
                          child: SingleChildScrollView(
                            child: Text(
                              _responseText,
                              style: TextStyle(color: Color.fromRGBO(51, 57, 132, 1), fontSize: 35),
                            ),
                          ),
                        ),
                      ),


                      SizedBox(height: 131,),
                      Stack(children: [  Positioned(


                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Expanded(
                              child: Container(
                                width: 200,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(50),),
                                  border: Border.all(color: Colors.white),
                                  color: Color.fromRGBO(244, 246, 255, 2),
                                ),
                                child: Center(child: Text("Үн"),),
                              ),
                            ),

                            Expanded(
                              child: Container(
                                width: 200,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(50),),
                                  border: Border.all(color: Colors.white),
                                  color: Color.fromRGBO(42, 70, 255, 0.70),
                                ),
                                child: Center(child: Text("Кыргыз",style: TextStyle(color: Colors.white),),),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ],
                      ),


                    ],
                    ),
                    ),

                    Positioned(
                      left: 150,
                      bottom: 0,
                      child: GestureDetector(
                        onLongPressStart: (_) => _handleRecordingStart(),
                        onLongPressEnd: (_) => _handleRecordingStop(),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: buttonColor,
                          child: Icon(isRecording ? Icons.mic : Icons.mic_sharp,
                          size: 50,
                            color: Colors.white,
                          ),

                        ),
                      ),
                    ),
                  ],
                ),
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
      buttonColor = Color.fromRGBO(42, 70, 255, 0.70);
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
      buttonColor = Colors.blueAccent;
    });

    await _sendToAPI();
  }

  Future<bool> _checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      return status == PermissionStatus.granted;
    }
    return true;
  }

  Future<void> _sendToAPI() async {
    if (recordFilePath == null) {
      print('Recorded file path is null');
      return;
    }

    File file =File(recordFilePath!);
    if (!file.existsSync()) {
      print('Recorded file does not exist');
      return;
    }

    String apiUrl = 'https://asr.ulut.kg/api/receive_data';
    var headers = {
      'Authorization':
      'Bearer 9833a3e6dc863668f4203a922936fe860c565ba36400b95a0aa72e9b7e7f8ee2d9503325c5b05fa5e81b46b5613025167acb521f454fc9012352935c7d7403d7'
    };

    // Read file as bytes
    List<int> bytes = await file.readAsBytes();

    // Construct multipart request manually
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.headers.addAll(headers);
    request.files.add(http.MultipartFile.fromBytes('audio', bytes, filename: 'test.mp3'));

    try {
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        print('API Response: $responseBody'); // For debugging

        try {
          Map<String, dynamic> jsonResponse = json.decode(responseBody);
          String textFromAPI = jsonResponse['text'] ?? '';
          setState(() {
            _responseText = textFromAPI;
          });
        } catch (e) {
          print('Error decoding response: $e');
          setState(() {
            _responseText = 'Error decoding response';
          });
        }
      } else {
        print('API Request failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending request to API: $e');
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
