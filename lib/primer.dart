import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class SignLanguage extends StatefulWidget {
  const SignLanguage({Key? key}) : super(key: key);

  @override
  State<SignLanguage> createState() => _SignLanguageState();
}

class _SignLanguageState extends State<SignLanguage> {
  String statusText = '';
  String? recordFilePath;
  Color buttonColor = Colors.lightBlueAccent;
  bool isRecording = false;
  String _responseText = '';
  bool isEmpty = false;

  TextEditingController _searchController = TextEditingController();
  List<dynamic> _contentList = [];
  bool _notFound = false;

  Future<void> _searchVideos(String searchText) async {
    setState(() {
      _contentList = [];
      _notFound = false;
    });
    if (searchText.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Please enter a search term."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.67.243:3000/api/videos/${searchText.toLowerCase()}'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _contentList = data;
        });
        if (_contentList.isEmpty) {
          setState(() {
            _notFound = true;
          });
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        _notFound = true;
      });
    }
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
                    Column(
                      children: [
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
                              Row(
                                children: [
                                  Text(
                                    "Sign Language",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 17),
                                  ),
                                  SizedBox(
                                    width: 18,
                                  ),
                                  // GestureDetector(
                                  //     onTap: () {
                                  //       Navigator.of(context)
                                  //           .push(MaterialPageRoute(
                                  //         builder: (BuildContext context) =>
                                  //             SignLanguageType(),
                                  //       ));
                                  //     },
                                  //     child: Image.asset(
                                  //       "assets/images/image 2 (1).png",
                                  //       width: 42,
                                  //       height: 42,
                                  //     )),
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 150,
                        ),
                        Container(
                          width: 350,
                          height: 400,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: Colors.lightBlueAccent),
                            color: Colors.white,
                          ),

                          child: _contentList.isEmpty
                              ? _notFound
                              ? Center(child: Text('No content found matching your query.'))
                              : Center(child: Text('No video selected yet.'))
                              : _contentList[0]['type'] == 'video'
                              ? VideoSequencePlayer(videoUrls: _contentList.map((item) => item['url'] as String).toList())
                              : PNGsWidget(pngs: _contentList[0]['pngs']),

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
                                    controller: _searchController,
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
                                      labelText: "Text",
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
                                      _searchVideos(
                                          _searchController.text.trim());
                                    }
                                  },
                                  onLongPressStart: (_) =>
                                      _handleRecordingStart(),
                                  onLongPressEnd: (_) =>
                                      _handleRecordingStop(),
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
                        SizedBox(
                          height: 61,
                        ),
                      ],
                    ),

                    Positioned(
                        bottom: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 175,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                ),
                                border: Border.all(color: Colors.white),
                                color: Color.fromRGBO(244, 246, 255, 1),
                              ),
                              child: Center(
                                child: Text("Kyrgyz"),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Navigator.of(context).push(MaterialPageRoute(
                                //   builder: (BuildContext context) =>
                                //       SignLanguageToText(),
                                // ));
                              },
                              child: const CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage(
                                    "assets/images/exchange (1) 1.png"),
                              ),
                            ),
                            Container(
                              width: 175,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(50),
                                ),
                                border: Border.all(color: Colors.white),
                                color: Color.fromRGBO(42, 70, 255, 0.95),
                              ),
                              child: Center(
                                child: Text(
                                  "Sign Language",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
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

    File file = File(recordFilePath!);
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
    request.files.add(
        http.MultipartFile.fromBytes('audio', bytes, filename: 'test.mp3'));

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
            _searchController = TextEditingController(text: _responseText);
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


class VideoSequencePlayer extends StatefulWidget {
  final List<String> videoUrls;
  const VideoSequencePlayer({required this.videoUrls});

  @override
  _VideoSequencePlayerState createState() => _VideoSequencePlayerState();
}

class _VideoSequencePlayerState extends State<VideoSequencePlayer> {
  late VideoPlayerController _controller;
  int _currentVideoIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    if (widget.videoUrls.isNotEmpty && widget.videoUrls[_currentVideoIndex] != null) {
      _controller = VideoPlayerController.network(widget.videoUrls[_currentVideoIndex])
        ..initialize().then((_) {
          setState(() {});
          _controller.play();
          _controller.addListener(_videoListener);
        });
    }
  }

  void _videoListener() {
    if (_controller.value.position == _controller.value.duration) {
      _playNextVideo();
    }
  }

  void _playNextVideo() {
    if (_currentVideoIndex < widget.videoUrls.length - 1) {
      _currentVideoIndex++;
      _controller.pause();
      _controller.dispose();
      _initializeVideoPlayer();
    } else {
      // All videos have been played, reset index for next search
      setState(() {
        _currentVideoIndex = 0;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: _controller.value.isInitialized
          ? VideoPlayer(_controller)
          : Center(child: CircularProgressIndicator()),
    );
  }
}


class PNGsWidget extends StatelessWidget {
  final List<dynamic> pngs;
  const PNGsWidget({required this.pngs});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: pngs.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.all(20),
              child: Image.network(
                pngs[index] as String, // Cast each element to a String
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      ),
    );
  }
}
