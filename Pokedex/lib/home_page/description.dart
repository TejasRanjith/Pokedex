import 'package:flutter/material.dart';

class Description extends StatelessWidget {
  const Description({super.key});

  @override
  Widget build(BuildContext context) {
    Widget mytext() {
      String text =
          "Press the fire animation present at the bottom of the home screen.";
      String text1 = "After that, you will be roasted by a pokemon";
      String text2 =
          "Accept the burn of the pokemon accordingly and analyze it.";
      String text3 =
          "You can find many other pokemon in the catalog, with all details being unlocked.";
      String text4 =
          "You chat with an AI to understand more about pokemon using the chat here option";

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            "1.$text\n\n2.$text1\n\n3.$text2\n\n4.$text3\n\n$text4",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Image.asset(
              "assets/poke_title.png",
              width: 180,
              height: 100,
            ),
          ),
          Center(
              child: Image.asset(
            color: const Color.fromARGB(198, 157, 157, 157),
            "assets/pokeball_background.png",
            width: 800,
            height: 800,
          )),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: mytext(),
          )
        ],
      ),
    );
  }
}
