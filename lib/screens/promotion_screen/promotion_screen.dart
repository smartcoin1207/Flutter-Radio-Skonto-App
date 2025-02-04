import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/constant.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/providers/translations_provider.dart';
import 'package:radio_skonto/screens/web_view_screen/web_view_screen.dart';

class PromotionScreen extends StatefulWidget {
  const PromotionScreen({Key? key}) : super(key: key);

  @override
  State<PromotionScreen> createState() => _PromotionScreenState();
}

class _PromotionScreenState extends State<PromotionScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: Provider.of<TranslationsProvider>(context),
        child: Consumer<TranslationsProvider>(builder: (context, translationsProvider, _) {
          String languageCode = Singleton.instance.getLanguageCodeFromSharedPreferences();
          final contestsUrl = languageCode == 'en' ?
          '/en/contests' : languageCode == 'lv' ?
          '/lv/konkursi' : '/ru/contests';
          return WebViewScreen(hideAppBar: true,
              url: apiBaseUrl + contestsUrl, bottomPadding: 81, hideBackButton: true);
        })
    );
  }
}
