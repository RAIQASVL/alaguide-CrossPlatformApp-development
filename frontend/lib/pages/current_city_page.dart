import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:frontend/models/city_model.dart";
import 'package:frontend/providers/city_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend/services/city_service.dart';

class CurrentCityPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final citiesAsyncValue = ref.watch(citiesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.selectCity),
      ),
      body: citiesAsyncValue.when(
        data: (cities) => ListView.builder(
          itemCount: cities.length,
          itemBuilder: (context, index) =>
              _buildCityListTile(context, ref, cities[index]),
        ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildCityListTile(BuildContext context, WidgetRef ref, City city) {
    final selectedCity = ref.watch(selectedCityProvider);
    return ListTile(
      title: Text(city.name ?? 'Unknown'),
      subtitle: Text(city.country ?? 'Unknown'),
      trailing: selectedCity?.cityId == city.cityId ? Icon(Icons.check) : null,
      onTap: () {
        print('Selected city: ${city.toString()}');
        ref.read(selectedCityProvider.notifier).state = city;
        Navigator.pop(context);
      },
    );
  }
}
