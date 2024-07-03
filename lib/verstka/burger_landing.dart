

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BurgerLanding extends StatelessWidget {
  const BurgerLanding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Drawer(
        child: SingleChildScrollView(child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            buildHeader(context),
            BuildMenuItens(context),
          ],
        ),),
      );
  Widget buildHeader(BuildContext context) => Material(
    color: Colors.blue.shade700 ,
        child: InkWell(
          onTap: (){},
            child: Container(

        padding:  EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            CircleAvatar(radius: 52,
            backgroundImage: AssetImage("assets/images/avatarka.png"),
            ),
            SizedBox(height: 15 ,),
            Text("Ramazan Abduraimov"),
            //   SizedBox(height: 5,),
            // Text("AbduraimovRamazan@gmail.com"),
              SizedBox(height: 25 ,),
              GestureDetector(
                onTap: (){},
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.white),
                    color: Colors.blue.shade700 ,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.edit,color: Colors.white,),
                      Center(child: Text(" Edit Profile",style: TextStyle(color: Colors.white),)),
                    ],
                  ),
                  width: 110,
                height: 35,
                ),
              ),
          ],),
        ),
            ),
          ),
      );
  Widget BuildMenuItens (BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    child: Wrap(
      children: [
        ListTile(
          leading: const Icon(Icons.menu),
          title: const Text("Билдирүүлөр"),
          onTap: (){},
        ),
        ListTile(
          leading: const Icon(Icons.help),
          title: const Text("Жардам"),
          onTap: (){},
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text("Жөндөөлөр"),
          onTap: (){},
        ),
        ListTile(
          leading: const Icon(Icons.logout_outlined),
          title: const Text("Чыгуу"),
          onTap: (){},
        ),

      ],
    ),
  );
}