
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sign_language/server/Speach_to_server.dart';
import 'package:sign_language/verstka/ChatBotAI.dart';
import 'package:sign_language/verstka/Text%20_to_speech.dart';
import 'package:sign_language/verstka/Voice_to_text.dart';
import 'package:sign_language/verstka/burger_landing.dart';
import 'package:sign_language/verstka/text_to_Sign_Language.dart';

class MainPage_landing extends StatefulWidget {
  const MainPage_landing({Key? key}) : super(key: key);

  @override
  State<MainPage_landing> createState() => _MainPage_landingState();
}

class _MainPage_landingState extends State<MainPage_landing> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      drawer: Container(
        width: 350,
        child: BurgerLanding(

        ),
      ),
        drawerDragStartBehavior: DragStartBehavior.start,
        body: RefreshIndicator(
        onRefresh: () async {},
    child:SingleChildScrollView(
      child: SafeArea(
           top: true,
           // child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Image.asset("assets/images/Landing.png",
                    ),
                    Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 18, 40, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                IconButton(

                                  onPressed: ()  {
                                    _globalKey.currentState?.openDrawer();
                                  },
                                  icon: const Icon(Icons.menu),
                                  color: Colors.white,
                                ),
                                GestureDetector(
                                  child: const CircleAvatar(
                                    radius: 25,
                                    backgroundImage: AssetImage('assets/images/avatarka.png'),
                                  ),
                                ),

                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(35.0),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Салам, Самад!",style: TextStyle(color: Colors.white,fontSize: 20 ) ,),
                                      SizedBox(height: 10,),
                                      Text("Бугун Сизге ",style: TextStyle(color: Colors.white,fontSize: 35 ) ,),
                                      Text("кандай жардам",style: TextStyle(color: Colors.white,fontSize: 35 ) ,),
                                      Text("бере алам?",style: TextStyle(color: Colors.white,fontSize: 35 ) ,),
                                    ],
                                  ),
                              ),

                            ],
                          ),
                         Padding(
                           padding: const EdgeInsets.fromLTRB(40, 70, 40, 0),
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
                                       Text(" Жаңдоо тили",style: TextStyle(color: Colors.lightBlueAccent),)
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
                                       Text("Үндү текстке",style: TextStyle(color: Colors.lightBlueAccent),),
                                       Text("айландыруу",style: TextStyle(color: Colors.lightBlueAccent),)

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
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) => ChatBote(),
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
                                        Image.asset("assets/images/voice-command 1.png",width: 70,height: 70,),
                                        SizedBox(height: 10,),
                                        Text("Үн жардамчысы",style: TextStyle(color: Colors.lightBlueAccent),)
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
                                        Text("Текстке үн берүү",style: TextStyle(color: Colors.lightBlueAccent),)
                                      ],),

                                  ),
                                ),
                              ],
                            ),
                          ),




                        ],
                      ),
                    ),
                    Positioned(
                      left: 110,
                      top: 760,
                      child: Stack(children: [
                      Image.asset("assets/images/Rectangle 1.png",width: 300,height: 75,),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(210, 33, 0, 0),
                        child: Center(child: Text("SignXR",style: TextStyle(color: Color.fromRGBO(51, 57, 132, 1),fontSize: 17),)),
                      ),
                    ],
                      ),
                    ),

                  ],
                ),
              ],
            )
            //)
       ),
    )
        )
    );
  }
}