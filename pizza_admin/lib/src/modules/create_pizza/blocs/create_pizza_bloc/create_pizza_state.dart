part of 'create_pizza_bloc.dart';

@immutable
sealed class CreatePizzaState {}

final class CreatePizzaInitial extends CreatePizzaState {}

final class CreatePizzaFailure extends CreatePizzaState {}

final class CreatePizzaLoading extends CreatePizzaState {}

final class CreatePizzaSuccess extends CreatePizzaState {}
