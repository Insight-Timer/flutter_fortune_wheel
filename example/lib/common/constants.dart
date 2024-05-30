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

// ignore: avoid_classes_with_only_static_members
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

  static List<Emotions> emotions = _emotions + _emotions;
  static final List<Emotions> _emotions = [
    Emotions(name: 'Angry', color: Color(0xFFF94144)),
    Emotions(name: 'Fearful', color: Color(0xFFF37226)),
    Emotions(name: 'Surprised', color: Color(0xFFF8961E)),
    Emotions(name: 'Happy', color: Color(0xFFF9C747)),
    Emotions(name: 'Peaceful', color: Color(0xFFF90BE6D)),
    Emotions(name: 'Bad', color: Color(0xFF43AA8B)),
    Emotions(name: 'Sad', color: Color(0xFF577590)),
  ];
}
