import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image/image.dart' as img;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import '../custom/custom_button.dart';
import '../custom/custom_detailpage.dart';

class Myresult extends StatefulWidget {
  final String path;
  const Myresult({super.key, required this.path});

  @override
  State<Myresult> createState() => _MyresultState();
}

class _MyresultState extends State<Myresult> {
  Interpreter? _interpreter;
  IsolateInterpreter? isolateInterpreter;
  File? _imageFile;
  List<dynamic>? _output;
  bool toshow = false;
  String? pokemon;
  bool isLoading = false;
  double confidence = 0.0;

  final List<String> classNames = [
    'Abra',
    'Aerodactyl',
    'Alakazam',
    'Arbok',
    'Arcanine',
    'Articuno',
    'Beedrill',
    'Bellsprout',
    'Blastoise',
    'Bulbasaur',
    'Butterfree',
    'Caterpie',
    'Chansey',
    'Charizard',
    'Charmander',
    'Charmeleon',
    'Clefable',
    'Clefairy',
    'Cloyster',
    'Cubone',
    'Dewgong',
    'Diglett',
    'Ditto',
    'Dodrio',
    'Doduo',
    'Dragonair',
    'Dragonite',
    'Dratini',
    'Drowzee',
    'Dugtrio',
    'Eevee',
    'Ekans',
    'Electabuzz',
    'Electrode',
    'Exeggcute',
    'Exeggutor',
    'Farfetchd',
    'Fearow',
    'Flareon',
    'Gastly',
    'Gengar',
    'Geodude',
    'Gloom',
    'Golbat',
    'Goldeen',
    'Golduck',
    'Graveler',
    'Grimer',
    'Growlithe',
    'Gyarados',
    'Haunter',
    'Hitmonchan',
    'Hitmonlee',
    'Horsea',
    'Hypno',
    'Ivysaur',
    'Jigglypuff',
    'Jolteon',
    'Jynx',
    'Kabutops',
    'Kadabra',
    'Kakuna',
    'Kangaskhan',
    'Kingler',
    'Koffing',
    'Lapras',
    'Lickitung',
    'Machamp',
    'Machoke',
    'Machop',
    'Magikarp',
    'Magmar',
    'Magnemite',
    'Magneton',
    'Mankey',
    'Marowak',
    'Meowth',
    'Metapod',
    'Mew',
    'Mewtwo',
    'Moltres',
    'MrMime',
    'Nidoking',
    'Nidoqueen',
    'Nidorina',
    'Nidorino',
    'Ninetales',
    'Oddish',
    'Omanyte',
    'Omastar',
    'Parasect',
    'Pidgeot',
    'Pidgeotto',
    'Pidgey',
    'Pikachu',
    'Pinsir',
    'Poliwag',
    'Poliwhirl',
    'Poliwrath',
    'Ponyta',
    'Porygon',
    'Primeape',
    'Psyduck',
    'Raichu',
    'Rapidash',
    'Raticate',
    'Rattata',
    'Rhydon',
    'Rhyhorn',
    'Sandshrew',
    'Sandslash',
    'Scyther',
    'Seadra',
    'Seaking',
    'Seel',
    'Shellder',
    'Slowbro',
    'Slowpoke',
    'Snorlax',
    'Spearow',
    'Squirtle',
    'Starmie',
    'Staryu',
    'Tangela',
    'Tauros',
    'Tentacool',
    'Tentacruel',
    'Vaporeon',
    'Venomoth',
    'Venonat',
    'Venusaur',
    'Victreebel',
    'Vileplume',
    'Voltorb',
    'Vulpix',
    'Wartortle',
    'Weedle',
    'Weepinbell',
    'Weezing',
    'Wigglytuff',
    'Zapdos',
    'Zubat'
  ];

  @override
  void initState() {
    super.initState();
    _loadModel().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    isolateInterpreter?.close();
    super.dispose();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter =
          await Interpreter.fromAsset('lib/data_location/model2.tflite');
      isolateInterpreter =
          await IsolateInterpreter.create(address: _interpreter!.address);
    } catch (e) {
      print('Error loading model: $e');
    }
  }

  Future<void> runInference() async {
    _imageFile = File(widget.path);
    if (_imageFile == null) return;

    img.Image? imageInput = img.decodeImage(_imageFile!.readAsBytesSync());
    if (imageInput == null) return;

    imageInput = img.copyResize(imageInput, width: 224, height: 224);
    List<List<List<List<double>>>> input = imageToFloat32List(imageInput);
    List<dynamic> output = List.filled(142, 0).reshape([1, 142]);

    try {
      if (isolateInterpreter == null) {
        throw ArgumentError("Interpreter is not initialized");
      }

      await isolateInterpreter!.run(input, output);
      setState(() {
        _output =
            output[0].map((e) => e as double).toList(); // Convert to double
        int maxIndex = findLargestIndex(_output!);
        confidence = _output![maxIndex]; // Get confidence score
        toshow = true;

        // Set a confidence threshold (e.g., 60%)
        double threshold = 0.8;
        if (confidence >= threshold) {
          pokemon = classNames[maxIndex];
        } else {
          pokemon = null; // Return a fallback if confidence is low
        }
        isLoading = false;
      });
    } catch (e) {
      print("Error during inference: $e");
    }
  }

  int findLargestIndex(List<dynamic> numbers) {
    return numbers.indexOf(numbers.reduce((a, b) => a > b ? a : b));
  }

  Widget _loadimage() {
    if (kIsWeb) {
      return Image.network(widget.path);
    } else {
      return CustomButton(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.6,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.file(File(widget.path)),
          ));
    }
  }

  List<List<List<List<double>>>> imageToFloat32List(img.Image image) {
    return List.generate(
      1,
      (b) => List.generate(
        224,
        (y) => List.generate(
          224,
          (x) => [
            image.getPixel(x, y).r / 255.0,
            image.getPixel(x, y).g / 255.0,
            image.getPixel(x, y).b / 255.0,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Image.asset("assets/poke_title.png", width: 180, height: 100),
          Center(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButton(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: kIsWeb
                          ? Image.network(widget.path)
                          : Image.file(File(widget.path)),
                    ))),
          ),
          const SizedBox(height: 20),
          toshow
              ? (isLoading
                  ? Center(
                      child: LoadingAnimationWidget.inkDrop(
                        color: Colors.black,
                        size: 70,
                      ),
                    )
                  : (pokemon != null
                      ? Column(
                          children: [
                            CustomDetailpage(pokemon: pokemon!),
                            Text(
                              "Confidence: ${(confidence * 100).toStringAsFixed(2)}%",
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomButton(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.1,
                              child: const Center(
                                child: Text(
                                  "Unable to identify",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                ),
                              )),
                        )))
              : Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isLoading = true;
                      });

                      runInference();
                    },
                    child: CustomButton(
                      width: 100,
                      height: 40,
                      child: const Center(child: Text("Analyse")),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
