import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
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
import 'package:frontend/providers/theme_provider.dart';
import 'package:frontend/widgets/audioplayer_widget.dart';
import 'package:frontend/widgets/full_screen_audioplayer_widget.dart';

class ContentPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final citiesAsyncValue = ref.watch(citiesProvider);
    final contentAsyncValue = ref.watch(contentProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.selectCityFromContentPage),
      ),
      body: citiesAsyncValue.when(
        data: (cities) => contentAsyncValue.when(
          data: (alaguideObjects) => ListView.builder(
            itemCount: cities.length,
            itemBuilder: (context, index) => _buildCityListTile(
              context,
              ref,
              cities[index],
              alaguideObjects,
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildCityListTile(BuildContext context, WidgetRef ref, City city,
      List<AlaguideObject> alaguideObjects) {
    final isDarkMode = ref.watch(themeProvider) == ThemeMode.dark;
    final selectedCity = ref.watch(selectedCityProvider);
    final bool isSelected = selectedCity?.cityId == city.cityId;
    final Color customColor = const Color(0xFF5AD1E5);
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
      leading: SvgPicture.asset(
        'assets/images/alaguide_ui_icon.svg',
        color: isSelected ? customColor : Colors.grey,
      ),
      title: Text(
        localizedCityName ?? city.name ?? 'Unknown',
        style: TextStyle(
          color: isSelected
              ? customColor
              : (isDarkMode ? Colors.white : Colors.black),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        localizedCountryName ?? city.country ?? 'Unknown',
        style: TextStyle(
          color: isSelected
              ? (isDarkMode ? Colors.white : Colors.black)
              : Colors.grey,
        ),
      ),
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
                const SizedBox(width: 10),
                Text(
                  '$count',
                  style: TextStyle(
                    color: isSelected ? customColor : Colors.grey,
                  ),
                ),
              ],
            ),
            loading: () => const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            error: (error, stack) => Text(
              'Error',
              style: TextStyle(color: Colors.red),
            ),
          ),
          const SizedBox(width: 15),
          SvgPicture.asset('assets/images/arrow_right_icon.svg'),
        ],
      ),
      onTap: () {
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

  const CityContentPage({required this.city, required this.cityKey});

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
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: cityObjects.length,
            itemBuilder: (context, index) {
              final alaguideObject = cityObjects[index];

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(
                          alaguideObject.getLocalizedTitle(
                                  AppLocalizations.of(context)!) ??
                              'Unknown',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              '${AppLocalizations.of(context)!.author}: ${alaguideObject.getLocalizedAuthor(AppLocalizations.of(context)!) ?? 'N/A'}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${AppLocalizations.of(context)!.guide}: ${alaguideObject.getLocalizedGuide(AppLocalizations.of(context)!) ?? 'N/A'}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${AppLocalizations.of(context)!.category}: ${alaguideObject.getLocalizedCategory(AppLocalizations.of(context)!) ?? 'N/A'}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            if (alaguideObject.getLocalizedDescription(
                                        AppLocalizations.of(context)!) !=
                                    null &&
                                alaguideObject
                                    .getLocalizedDescription(
                                        AppLocalizations.of(context)!)!
                                    .trim()
                                    .isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${AppLocalizations.of(context)!.description}:',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Html(
                                    data:
                                        alaguideObject.getLocalizedDescription(
                                            AppLocalizations.of(context)!)!,
                                    style: {
                                      "body": Style(fontSize: FontSize(14)),
                                      "p": Style(
                                        textAlign: TextAlign.left,
                                        margin: Margins.only(left: -6.0),
                                        padding: HtmlPaddings.only(right: 0.0),
                                      ),
                                    },
                                  ),
                                ],
                              ),
                          ],
                        ),
                        trailing: IconButton(
                          icon:
                              const Icon(Icons.play_arrow, color: Colors.blue),
                          onPressed: () {
                            if (alaguideObject.audio_rus_url != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FullScreenAudioPlayer(
                                      object: alaguideObject),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Audio URL is not available.')),
                              );
                            }
                          },
                        ),
                        onTap: () {
                          _showFullScreenAudioPlayer(context, alaguideObject);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  void _showFullScreenAudioPlayer(
      BuildContext context, AlaguideObject alaguideObject) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenAudioPlayer(object: alaguideObject),
      ),
    );
  }
}
