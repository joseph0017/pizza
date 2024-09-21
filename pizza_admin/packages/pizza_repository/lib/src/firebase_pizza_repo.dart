import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pizza_repository/pizza_repository.dart';
import 'dart:html' as html;

class FirebasePizzaRepo implements PizzaRepo {
  final pizzaCollection = FirebaseFirestore.instance.collection('pizzas');

  @override
  Future<List<Pizza>> getPizzas() async {
    try {
      return await pizzaCollection.get().then((value) => value.docs
          .map((e) => Pizza.fromEntity(PizzaEntity.fromDocument(e.data())))
          .toList());
    } catch (err) {
      log(err.toString());
      rethrow;
    }
  }

  @override
  Future<String> sendImage(Uint8List file, String name) async {
    try {
      Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(name);

      await firebaseStorageRef.putData(
          file, SettableMetadata(contentType: 'image/jpeg'));
      return await firebaseStorageRef.getDownloadURL();
    } catch (err) {
      log(err.toString());
      rethrow;
    }
  }

  @override
  Future<void> createPizzas(Pizza pizza) async {
    try {
      return await pizzaCollection
          .doc(pizza.pizzaId)
          .set(pizza.toEntity().toDocument());
    } catch (err) {
      log(err.toString());
      rethrow;
    }
  }
}
