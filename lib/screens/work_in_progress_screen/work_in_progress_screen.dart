import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/helpers/constant.dart';
import 'package:get/route_manager.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/providers/translations_provider.dart';

class WorkInProgressScreen extends StatefulWidget {
  const WorkInProgressScreen({super.key});

  @override
  State<WorkInProgressScreen> createState() => _WorkInProgressScreenState();
}

class _WorkInProgressScreenState extends State<WorkInProgressScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String currentLocaleName = Singleton.instance.getCurrentLanguageName();
    final double dropdownWight = 135;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(padding: EdgeInsets.only(top: 50),
            child: Column(
              children: [
                Text(Singleton.instance.translate('application_language'),
                  style: AppTextStyles.main16regular,
                  textAlign: TextAlign.center,
                ),
                DropdownButton<String>(
                  hint: SizedBox(
                    width: dropdownWight,
                    child: Text(currentLocaleName,
                        style: AppTextStyles.main18regular),
                  ),
                  items: Singleton.instance.translations.data.values.map((value) {
                    String languageName = value['name_of_language'];
                    return DropdownMenuItem<String>(
                      value: languageName,
                      child: Text(languageName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    String langCode =  Singleton.instance.getLanguageCodeByLanguageName(value!);
                    Singleton.instance.writeLanguageCodeToSharedPreferences(langCode);
                    setState(() {
                    });
                    Provider.of<TranslationsProvider>(context, listen: false).notifyListeners();
                  },
                )
              ],)
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: SvgPicture.asset(
                    'assets/image/skonto_logo_svg.svg',
                    width: 110,
                  ),
                ),
                const SizedBox(height: 30),
                Text(Singleton.instance.translate('applications_improvement_works'),
                  style: AppTextStyles.main27bold,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(Singleton.instance.translate('we_are_currently_working'),
                  style: AppTextStyles.main16regular,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(Singleton.instance.translate('come_back_later'),
                  style: AppTextStyles.main16regular,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 50)
          ],
        ),
      )
    );
  }
}
