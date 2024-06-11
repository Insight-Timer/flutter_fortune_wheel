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

  static final List<Emotions> _emotions = [
    Emotions(name: 'Angry', color: Color(0xFFF94144)),
    Emotions(name: 'Fearful', color: Color(0xFFF37226)),
    Emotions(name: 'Surprised', color: Color(0xFFF8961E)),
    Emotions(name: 'Happ4', color: Color(0xFFF9C747)),
    Emotions(name: 'Peaceful5', color: Color(0xFFF90BE6D)),
    Emotions(name: 'Bad6', color: Color(0xFF43AA8B)),
    Emotions(name: 'Sad7', color: Color(0xFF577590)),
  ];

  static List<Emotions> emotions = _emotions + _emotions;
  static List<Emotions> feelings = _feelings + _feelings;
  static final List<Emotions> _feelings = [
    Emotions(name: 'Intimate', color: Color(0xFFF94144)),
    Emotions(name: 'Valued', color: Color(0xFFF37226)),
    Emotions(name: 'Respected', color: Color(0xFFF8961E)),
    Emotions(name: 'Accepted', color: Color(0xFFF9C747)),
    Emotions(name: 'Trusting', color: Color(0xFFF90BE6D)),
    Emotions(name: 'Grateful', color: Color(0xFF43AA8B)),
    Emotions(name: 'Content', color: Color(0xFF577590)),
    Emotions(name: 'Centered', color: Color(0xFFF94144)),
    Emotions(name: 'Relaxed', color: Color(0xFFF37226)),
    Emotions(name: 'Harmonius', color: Color(0xFFF8961E)),
    Emotions(name: 'Free', color: Color(0xFFF9C747)),
    Emotions(name: 'Aware', color: Color(0xFFF90BE6D)),
    Emotions(name: 'Pensive', color: Color(0xFF43AA8B)),
    Emotions(name: 'Loving', color: Color(0xFF577590)),
    Emotions(name: 'Nurturing', color: Color(0xFF577590)),
  ];
}
