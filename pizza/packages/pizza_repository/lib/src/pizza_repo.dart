import 'package:pizza_repository/src/models/models.dart';

abstract class PizzaRepo {
  Future<List<Pizza>> getPizzas();
}
