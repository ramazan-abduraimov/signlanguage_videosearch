
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sign_language/verstka/Sign_Language_Type.dart';

class TextToSpeechPoluchi extends StatefulWidget {

  final String text;
  TextToSpeechPoluchi({required this.text});



  @override
  State<TextToSpeechPoluchi> createState() => _TextToSpeechPoluchiState();
}

class _TextToSpeechPoluchiState extends State<TextToSpeechPoluchi> {







  @override
  Widget build(BuildContext context) {
    TextEditingController _textController = TextEditingController(text: widget.text);
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

                            labelText: "Text",
                            labelStyle: TextStyle(color: Color.fromRGBO(51, 57, 132, 1)),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 30,right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              child: Center(child: CircleAvatar(
                                radius: 40,
                                child: Icon(Icons.pause,size: 45,),
                              ),),
                            ),
                            GestureDetector(
                              child: Center(child: CircleAvatar(
                                radius: 40,
                                child: Icon(Icons.send,size: 45,),
                              ),),
                            ),
                            GestureDetector(
                              child: Center(child: CircleAvatar(
                                radius: 40,
                                child: Icon(Icons.play_arrow,size: 45,),
                              ),),
                            ),
                          ],
                        ),
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
