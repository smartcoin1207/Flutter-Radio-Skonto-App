import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/providers/main_screen_provider.dart';
import 'package:radio_skonto/providers/playlists_provider.dart';
import 'package:radio_skonto/providers/podcasts_provider.dart';
import 'package:radio_skonto/providers/translations_provider.dart';
import 'package:radio_skonto/screens/settings/options_switch_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String currentLocaleName = Singleton.instance.getCurrentLanguageName();
    final String langCode = Singleton.instance.getLanguageCodeFromSharedPreferences();

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
            color: AppColors.white
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(Singleton.instance.translate('general_settings'), style: AppTextStyles.main18bold),
            const SizedBox(height: 30),
            Text(Singleton.instance.translate('application_language'), style: AppTextStyles.main18regular),
            DropdownButton<String>(
              isExpanded: true,
              hint: Row(
                children: [
                  CircleFlag(langCode == 'en' ? 'gb' : langCode, size: 17),
                  const SizedBox(width: 10),
                  Text(currentLocaleName,
                      style: AppTextStyles.main16regular.copyWith(color: AppColors.black))
                ],
              ),
              items: Singleton.instance.translations.data.values.map((value) {
                String languageName = value['name_of_language'];
                String lCode = languageName.toLowerCase() == 'русский' ? 'ru' :
                languageName.toLowerCase() == 'english' ? 'en' : 'lv';
                return DropdownMenuItem<String>(
                  value: languageName,
                  child: Row(
                    children: [
                      CircleFlag(lCode == 'en' ? 'gb' : lCode, size: 17),
                      const SizedBox(width: 10),
                      Text(languageName,
                          style: AppTextStyles.main16regular.copyWith(color: AppColors.black))
                    ],
                  ),
                  //Text(languageName),
                );
              }).toList(),
              onChanged: (value) {
                String langCode =  Singleton.instance.getLanguageCodeByLanguageName(value!);
                Singleton.instance.writeLanguageCodeToSharedPreferences(langCode);
                setState(() {
                });
                Provider.of<TranslationsProvider>(context, listen: false).notifyListeners();
                Provider.of<PodcastsProvider>(context, listen: false).getAllPodcasts(context, isFromInit: false);
                Provider.of<MainScreenProvider>(context, listen: false).getMainScreenData(false, context);
                Provider.of<PlaylistsProvider>(context, listen: false).getPlaylistData(false);
              },
            ),
            const SizedBox(height: 30),
            OptionsSwitch(
              title: Singleton.instance.translate('allow_downloads_only_wifi'),
              value: Singleton.instance.getIsAllowWiFiDownloadFromSharedPreferences(),
              onToggle: (locationSwitcher) {
                Singleton.instance.writeIsAllowWiFiDownloadToSharedPreferences(locationSwitcher);
                setState(() {});
              },
            ),
            const SizedBox(height: 40),
            OptionsSwitch(
              title: Singleton.instance.translate('allow_push_notifications'),
              value: true,
              onToggle: (locationSwitcher) {
                //toggleLocation(locationSwitcher);
              },
            )
          ],
        ),
      ),
    );
  }
}
