import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    final bool isSelected = selectedCity?.cityId == city.cityId;
    final Color customColor = Color(0xFF5AD1E5);

    return ListTile(
      leading: SvgPicture.asset('assets/images/alaguide_ui_icon.svg',
          color: isSelected ? customColor : Colors.grey),
      title: Text(city.name ?? 'Unknown',
          style: TextStyle(
              color: isSelected ? customColor : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      subtitle: Text(city.country ?? 'Unknown',
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.grey,
          )),
      trailing: isSelected ? Icon(Icons.check, color: customColor) : null,
      onTap: () {
        print('Selected city: ${city.toString()}');
        ref.read(selectedCityProvider.notifier).state = city;
        Navigator.pop(context);
      },
    );
  }
}
