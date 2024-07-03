import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sign_language/verstka/Text%20_to_speech.dart';
import 'package:sign_language/verstka/Voice_to_text.dart';
import 'package:sign_language/verstka/text_to_Sign_Language.dart';

class SignLanguageType extends StatelessWidget {
  const SignLanguageType({Key? key}) : super(key: key);

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
                    Image.asset("assets/images/Sign Language (3).png"),
                    Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 18, 40, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // IconButton(
                                //   onPressed: () {},
                                //   icon: const Icon(Icons.menu),
                                //   color: Colors.white,
                                // ),
                                SizedBox(),
                                GestureDetector(
                                  onTap: () => Navigator.of(context).pop(),
                                  child: Image.asset("assets/images/Group 2.png",width: 42,height: 42,)),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(40, 170, 40, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) => SignLanguage(),
                                    ));
                                  },
                                  child: Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(color: Colors.lightBlueAccent),
                                      color: Colors.white,
                                    ),
                                    child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset("assets/images/sign-language-type.png",width: 70,height: 70,),
                                        SizedBox(height: 10,),
                                        Text("Sign Language",style: TextStyle(color: Colors.lightBlueAccent),)
                                      ],),

                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) => VoiceToText(),
                                    ));
                                  },
                                  child: Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(color: Colors.lightBlueAccent),
                                      color: Colors.white,
                                    ),
                                    child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset("assets/images/Voice_to_text.png",width: 70,height: 70,),
                                        SizedBox(height: 10,),
                                        Text("Voice to text",style: TextStyle(color: Colors.lightBlueAccent),)
                                      ],),

                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(40, 20, 40, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(color: Colors.lightBlueAccent),
                                      color: Colors.white,
                                    ),
                                    child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset("assets/images/Picture_to_voice.png",width: 70,height: 70,),
                                        SizedBox(height: 10,),
                                        Text("Picture to voice",style: TextStyle(color: Colors.lightBlueAccent),)
                                      ],),

                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) => TextToSpeech(),
                                    ));
                                  },
                                  child: Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(color: Colors.lightBlueAccent),
                                      color: Colors.white,
                                    ),
                                    child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset("assets/images/Text_to_voice.png",width: 70,height: 70,),
                                        SizedBox(height: 10,),
                                        Text("Text to speach",style: TextStyle(color: Colors.lightBlueAccent),)
                                      ],),

                                  ),
                                ),
                              ],
                            ),
                          ),],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),),
      ),
    );
  }
}
