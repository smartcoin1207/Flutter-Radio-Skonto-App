import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/providers/auth_provider.dart';
import 'package:radio_skonto/providers/translations_provider.dart';
import 'package:volume_controller/volume_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool hasError = false;


  @override
  void initState() {
    Singleton.instance.needInitCarPlayWithoutRunApp = false;
    Singleton.instance.firstInitPlayerAndLoadData(context);
    Provider.of<AuthProvider>(context, listen: false).getPlacesOfResidence();
    getTranslations();
    _setDefaultVolume();
    super.initState();
  }

  void _setDefaultVolume() async {
    VolumeController().setVolume(0.2);
    //await VolumeController.instance.setVolume(0.2);
  }

  // void _initPlayerAndLoadData() async {
  //   var playerProvider = Provider.of<PlayerProvider>(context, listen: false);
  //   await playerProvider.initPlayerHandle(context);
  //   await playerProvider.setupCarPlay(context);
  //   final mainScreenProvider = Provider.of<MainScreenProvider>(context, listen: false);
  //   mainScreenProvider.getMainScreenData(true, context);
  //   await Provider.of<PodcastsProvider>(context, listen: false).getAllPodcasts(context);
  // }

  Future<void> getTranslations() async {
    await Provider.of<TranslationsProvider>(context, listen: false).getTranslationsData().then((value) async {
      if (value == true) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        setState(() {
          hasError = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Locale myLocale = Localizations.localeOf(context);
    // Singleton.instance.writeLanguageCodeToSharedPreferences(myLocale.languageCode);
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: hasError == false ?
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Image.asset(
            'assets/image/main_icon.png',
          ),
        ) :
        IconButton(
          icon:const Icon(Icons.refresh, color: AppColors.red, size: 50,),
          onPressed: () {
            setState(() {
              hasError = false;
            });
            getTranslations();
          },
        )
      ),
    );
  }
}