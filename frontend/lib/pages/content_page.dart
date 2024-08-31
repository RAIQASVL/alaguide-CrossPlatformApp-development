import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/l10n/l10n.dart';
import 'package:frontend/models/alaguide_object_model.dart';
import 'package:frontend/models/city_model.dart';
import 'package:frontend/providers/audio_url_provider.dart';
import 'package:frontend/providers/city_object_count_provider.dart';
import 'package:frontend/providers/content_provider.dart';
import 'package:frontend/providers/city_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend/widgets/audioplayer_widget.dart';

class ContentPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final citiesAsyncValue = ref.watch(citiesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.selectCityFromContentPage),
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
    final String countryKey = city.country.toString();
    final String cityKey = city.cityId.toString();
    final String name = city.name;

    // Fetch localized city and country names
    String? localizedCityName =
        AppLocalizations.of(context)!.getCityName(cityKey);
    String? localizedCountryName =
        AppLocalizations.of(context)!.getCountryName(countryKey);

    // Fetch the object count for the city
    final objectCountAsyncValue = ref.watch(cityObjectCountProvider(name));

    return ListTile(
      leading: SvgPicture.asset('assets/images/alaguide_ui_icon.svg',
          color: isSelected ? customColor : Colors.grey),
      title: Text(localizedCityName ?? city.name ?? 'Unknown',
          style: TextStyle(
              color: isSelected ? customColor : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      subtitle: Text(localizedCountryName ?? city.country ?? 'Unknown',
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.grey,
          )),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          objectCountAsyncValue.when(
            data: (count) => Row(
              children: [
                SvgPicture.asset(
                  'assets/images/location_pin_icon.svg',
                  width: 16,
                  height: 16,
                  color: isSelected ? customColor : Colors.grey,
                ),
                SizedBox(width: 10),
                Text(
                  '$count', // Display the object count
                  style: TextStyle(
                    color: isSelected ? customColor : Colors.grey,
                  ),
                ),
              ],
            ),
            loading: () => CircularProgressIndicator(),
            error: (error, stack) => Text(
              'Error',
              style: TextStyle(color: Colors.red),
            ),
          ),
          SizedBox(width: 15),
          SvgPicture.asset('assets/images/arrow_right_icon.svg'),
        ],
      ),
      onTap: () {
        print('Selected city: ${city.toString()}');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CityContentPage(city: city, cityKey: cityKey),
          ),
        );
      },
    );
  }
}

class CityContentPage extends ConsumerWidget {
  final City city;
  final String cityKey;

  CityContentPage({required this.city, required this.cityKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alaguideObjectsAsyncValue = ref.watch(contentProvider);
    String? cityName = AppLocalizations.of(context)!.getCityName(cityKey);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${AppLocalizations.of(context)!.contentPageOfCity} ${cityName ?? 'Unknown City'}',
        ),
      ),
      body: alaguideObjectsAsyncValue.when(
        data: (alaguideObjects) {
          final cityObjects =
              alaguideObjects.where((obj) => obj.city == city.name).toList();

          if (cityObjects.isEmpty) {
            return Center(
              child: Text(
                '${AppLocalizations.of(context)!.noContentAvailableForCity} ${cityName ?? 'Unknown City'}',
              ),
            );
          }
          return ListView.builder(
            itemCount: cityObjects.length,
            itemBuilder: (context, index) {
              final alaguideObject = cityObjects[index];
              final audioUrl = ref.watch(audioInfoProvider(alaguideObject));

              return ListTile(
                // leading: alaguideObject.image_url != null
                //     ? Image.network(alaguideObject.image_url!,
                //         width: 50, height: 50, fit: BoxFit.cover)
                //     : Icon(Icons.image_not_supported),
                title: Text(alaguideObject.title ?? 'Unknown'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Author: ${alaguideObject.author ?? 'N/A'}'),
                    Text('Guide: ${alaguideObject.guide ?? 'N/A'}'),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.play_arrow),
                  onPressed: () {
                    if (alaguideObject.audio_rus_url != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FullScreenPlayerPage(object: alaguideObject),
                        ),
                      );
                    } else {
                      // Handle the null case, e.g., show an error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Audio URL is not available.')),
                      );
                    }
                  },
                ),
                onTap: () {
                  _showDetailDialog(context, alaguideObject);
                },
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  void _showDetailDialog(BuildContext context, AlaguideObject object) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(object.title ?? 'Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (object.image_url != null) Image.network(object.image_url!),
                SizedBox(height: 16),
                Text('Author: ${object.author ?? ''}'),
                Text('Guide: ${object.guide ?? ''}'),
                Text('Description: ${object.description ?? ''}'),
                Text('Category: ${object.category ?? ''}'),
                Text(
                    'Location: ${object.landmark}, ${object.city}, ${object.country}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}

class FullScreenPlayerPage extends ConsumerWidget {
  final AlaguideObject object;

  const FullScreenPlayerPage({Key? key, required this.object})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioUrl = ref.watch(audioInfoProvider(object));

    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Playing audio from: $audioUrl'),
            SizedBox(height: 20),
            AudioPlayerWidget(object: object),
          ],
        ),
      ),
    );
  }
}
