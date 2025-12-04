import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pokedex/data_location/gif_location.dart';
import 'package:pokedex/custom/custom_ui_container.dart';
import 'package:pokedex/home_page/camera.dart';
import 'package:pokedex/home_page/catalog.dart';
import 'package:pokedex/home_page/splash_screen.dart';
import 'package:pokedex/llm_api/chat_bot.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'description.dart';
import 'dart:math';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int count = 1;
  List<String> notcapturedpokemon = [];
  @override
  void initState() {
    GifLocation.gif_location.shuffle(Random());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Image.asset(
                  "assets/poke_title.png",
                  width: 180,
                  height: 100,
                ),
              ),
              const Spacer(),
              // Padding(
              //   padding: const EdgeInsets.all(20.0),
              //   child: Text(
              //     count.toString(),
              //     style: const TextStyle(
              //         fontSize: 30, fontWeight: FontWeight.bold),
              //   ),
              // ),
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Stack(
              children: [
                Image.asset(
                  color: const Color.fromARGB(199, 113, 113, 113),
                  "assets/pokeball_background.png",
                  width: MediaQuery.of(context).size.width * 1.2,
                  height: MediaQuery.of(context).size.height * 0.5,
                  scale: 1.5,
                ),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 300.0,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 6),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    enlargeFactor: 1,
                  ),
                  items: GifLocation.gif_location.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Image.asset(
                          i,
                          fit: BoxFit.contain,
                          // width: MediaQuery.of(context).size.width * 1.6,
                          // height: MediaQuery.of(context).size.height * 0.5,
                        );
                      },
                    );
                  }).toList(),
                )
              ],
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Catalog()));
                    },
                    child: CustomUiContainer(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: 150,
                        child: const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            "Catalog",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ))),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Description()));
                    },
                    child: CustomUiContainer(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: 150,
                        child: const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text("Get Help",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold)),
                        ))),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ChatBot()));
            },
            child: CustomUiContainer(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 0.95,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Chat here...",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
              ),
            ),
          ),
          // const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Camera()));
                    },
                    child: const Icon(
                      Icons.camera,
                      size: 80,
                    )),
              ),
              Center(
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SplashScreen()));
                    },
                    child: Lottie.asset('assets/fire_animation.json',
                        width: 180, height: 180, fit: BoxFit.fill)),
              )
            ],
          ),
        ],
      ),
    );
  }
}
