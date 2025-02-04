import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/providers/translations_provider.dart';

class InstructionMainView extends StatelessWidget {
  const InstructionMainView({
    super.key,
    required this.imageName,
    required this.firstText,
    required this.secondText,
    required this.needLanguageSelector
  });

  final String imageName;
  final String firstText;
  final String secondText;
  final bool needLanguageSelector;

  @override
  Widget build(BuildContext context) {
    final String langCode = Singleton.instance.getLanguageCodeFromSharedPreferences();
    final String currentLocaleName = Singleton.instance.getCurrentLanguageName();
    const double dropdownWight = 135.0;

    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            needLanguageSelector ?
            Padding(padding: const EdgeInsets.only(top: 80, right: 20),
                child: Column(
                  children: [
                    Text(Singleton.instance.translate('application_language'),
                      style: AppTextStyles.main16regular.copyWith(color: AppColors.white),
                      textAlign: TextAlign.center,
                    ),
                    DropdownButton<String>(
                      iconEnabledColor: AppColors.white,
                      hint: SizedBox(
                        width: dropdownWight,
                        child: Row(
                          children: [
                            CircleFlag(langCode == 'en' ? 'gb' : langCode, size: 17),
                            const SizedBox(width: 5),
                            Text(currentLocaleName,
                                style: AppTextStyles.main16regular.copyWith(color: AppColors.white))
                          ],
                        ),
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
                        Provider.of<TranslationsProvider>(context, listen: false).notifyListeners();
                      },
                    )
                  ],)
            ) : const SizedBox(height: 80,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  imageName,
                ),
                const SizedBox(height: 10),
                Padding(padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Text(firstText,
                    style: AppTextStyles.main27bold.copyWith(color: AppColors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Text(secondText,
                    style: AppTextStyles.main16regular.copyWith(color: AppColors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ],
        ),
      ),
    );
  }
}