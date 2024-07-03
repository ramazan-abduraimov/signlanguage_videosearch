
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sign_language/verstka/Sign_Language_Type.dart';

class SignLanguageToText extends StatelessWidget {
  const SignLanguageToText({Key? key}) : super(key: key);

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
                            Row(children: [Text("Жаңдоо тили",style: TextStyle(color: Colors.white,fontSize: 17),),
                              SizedBox(width: 18,),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) => SignLanguageType(),
                                    ));
                                  },
                                  child: Image.asset("assets/images/image 2 (1).png",width: 42,height: 42,)),
                            ],)

                          ],
                        ),
                      ),
                      SizedBox(height: 150,),
                      Container(
                        width: 350,
                        height: 400,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Colors.lightBlueAccent),
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 30, 15, 0),
                        child: Container(

                          child:
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: TextField(
                                  maxLines: 3,
                                  style: const TextStyle(fontSize: 13, color: Colors.black),
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
                              SizedBox(width: 5,),
                              GestureDetector(

                                child: const CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Color.fromRGBO(42, 70, 255, 1),
                                  child: Icon(Icons.volume_up_sharp,color: Colors.white,size: 30,),
                                ),
                              ),

                            ],
                          ),

                        ),
                      ),
                      SizedBox(height: 26,),
                      Stack(
                        children: [
                          Positioned(


                              child:Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  Expanded(
                                    child: Container(
                                      width: 175,
                                      height: 55,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(50),),
                                        border: Border.all(color: Colors.white),
                                        color: Color.fromRGBO(244, 246, 255, 1),
                                      ),
                                      child: Center(child: Text("Жаңдоо тили"),),
                                    ),
                                  ),

                                  Expanded(
                                    child: Container(
                                      width: 175,
                                      height: 55,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(topRight: Radius.circular(50),),
                                        border: Border.all(color: Colors.white),
                                        color: Color.fromRGBO(42, 70, 255, 0.95),
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
                      bottom: 0,
                      left: 175,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),

                        child: const CircleAvatar(

                          radius: 30,
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage("assets/images/Group 11412.png"),
                        ),
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
