import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/city_provider.dart';
import 'package:frontend/services/city_service.dart';

final cityObjectCountProvider =
    FutureProvider.family<int, String>((ref, name) async {
  final cityService = ref.watch(cityServiceProvider);
  print('Fetching object count for cityId: $name');
  try {
    final count = await cityService.fetchObjectCount(name);
    print('Fetched count for cityId $name: $count');
    return count;
  } catch (e) {
    print('Error fetching object count for city $name: $e');
    return 0;
  }
});
