// ignore: avoid_classes_with_only_static_members
import 'package:flutter/material.dart';

class Emotions {
  final String name;
  final Color color;

  Emotions({
    required this.name,
    required this.color,
  });
}

class Constants {
  // static List<String> get fortuneValues => const <String>[
  //       'Grogu-0',
  //       'Mace Windu-1',
  //       'Obi-Wan Kenobi-2',
  //       'Han Solo-3',
  //       'Luke Skywalker-4',
  //       'Darth Vader-5',
  //       'Yoda-6',
  //       'Ahsoka Tano-7',
  //       'Ahsoka Tano-8',
  //       'Ahsoka Tano-8',
  //     ];

  static List<Emotions> emotions = [
    Emotions(name: 'Emotion0', color: Colors.red),
    Emotions(name: 'Emotion1', color: Colors.green),
    Emotions(name: 'Emotion2', color: Colors.blue),
    Emotions(name: 'Emotion3', color: Colors.yellow),
    Emotions(name: 'Emotion4', color: Colors.orange),
    Emotions(name: 'Emotion5', color: Colors.brown),
    Emotions(name: 'Emotion6', color: Colors.purple),
    Emotions(name: 'Emotion7', color: Colors.lightBlue),
    Emotions(name: 'Emotion8', color: Colors.pink),
    Emotions(name: 'Emotion9', color: Colors.lightGreen),
    Emotions(name: 'Emotion10', color: Colors.teal),
    Emotions(name: 'Emotion11', color: Colors.lime),
    Emotions(name: 'Emotion12', color: Colors.indigo),
    // Emotions(name: 'Emotion13', color: Colors.red),
    // Emotions(name: 'Emotion14', color: Colors.green),
    // Emotions(name: 'Emotion15', color: Colors.blue),
    // Emotions(name: 'Emotion16', color: Colors.yellow),
    // Emotions(name: 'Emotion17', color: Colors.orange),
    // Emotions(name: 'Emotion18', color: Colors.brown),
    // Emotions(name: 'Emotion19', color: Colors.purple),
    // Emotions(name: 'Emotion20', color: Colors.lightBlue),
    // Emotions(name: 'Emotion21', color: Colors.pink),
    // Emotions(name: 'Emotion22', color: Colors.lightGreen),
    // Emotions(name: 'Emotion23', color: Colors.teal),
    // Emotions(name: 'Emotion24', color: Colors.lime),
    // Emotions(name: 'Emotion25', color: Colors.indigo),
  ];
}
