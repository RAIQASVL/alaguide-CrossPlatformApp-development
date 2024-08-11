import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:frontend/models/city_model.dart";
import 'package:frontend/services/city_service.dart';

final cityServiceProvider = Provider((ref) => CityService());

final citiesProvider = FutureProvider<List<City>>((ref) async {
  final cityService = ref.read(cityServiceProvider);
  return await cityService.fetchCities();
});

final selectedCityProvider = StateProvider<City?>((ref) => null);
