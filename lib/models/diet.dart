import 'package:flutter/material.dart';

class Diet {
  final int dietId;
  final String id, name, image, shortDescription, longDescription, type;

  Diet({
    @required this.id,
    @required this.dietId,
    @required this.name,
    @required this.image,
    @required this.shortDescription,
    @required this.longDescription,
    @required this.type,
  });
}
