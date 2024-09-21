import 'dart:typed_data';

import 'package:pizza_repository/src/models/models.dart';
import 'dart:html' as html;

abstract class PizzaRepo {
  Future<List<Pizza>> getPizzas();
  Future<String> sendImage(Uint8List file, String name);
  Future<void> createPizzas(Pizza pizza);
}
