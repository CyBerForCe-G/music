import 'package:flutter/material.dart';

class Content {
  final int id;
  final String name;
  final String imageUrl;
  final String audioUrl;
  final Color color;
  final String category;
  final String movie;

  const Content({
    required this.id,
    required this.name,
    required this.audioUrl,
    required this.imageUrl,
    required this.color,
    required this.category,
    required this.movie,
  });
}
