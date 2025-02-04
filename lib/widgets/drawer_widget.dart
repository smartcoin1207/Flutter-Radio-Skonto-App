import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/providers/auth_provider.dart';
import 'package:radio_skonto/screens/alarm_clock/alarm_clock_screen.dart';
import 'package:radio_skonto/screens/instructions_screen/instructions_screen.dart';
import 'package:radio_skonto/screens/login_screen/login_screen.dart';
import 'package:radio_skonto/screens/podcasts_screen/filters/filters_widget.dart';
import 'package:radio_skonto/screens/profile_screen/profile_screen.dart';
import 'package:radio_skonto/screens/report_bug/report_bug.dart';
import 'package:radio_skonto/screens/settings/settings_screen.dart';

import '../main.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({required this.appInfo, super.key,});

  final PackageInfo appInfo;

  @override
  Widget build(BuildContext context) {
    String refToken = Singleton.instance.getRefreshTokenFromSharedPreferences();
    String userName = Singleton.instance.getUserNameFromSharedPreferences();
    double? height = AppBar().preferredSize.height + kToolbarHeight;

    return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.only(top: height),
              child: RawMaterialButton(
                onPressed: () {
                  scaffoldKey.currentState?.closeEndDrawer();
                  },
                //elevation: 2.0,
                fillColor: AppColors.gray,
                padding: const EdgeInsets.all(8.0),
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.close,
                  size: 25.0,
                ),
              ),
            ),
            Singleton.instance.isMainMenu ?
            Drawer(child: Padding(padding: EdgeInsets.only(top: 0),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                      padding: const EdgeInsets.all(15),
                      height: 80 + height,
                      color: AppColors.gray,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Text(refToken == '' ?
                                  Singleton.instance.translate('login_or_register') :
                                  userName,
                                    style: AppTextStyles.main24bold,
                                  ),
                                  //width: 220,
                                ),
                                Text(
                                  Singleton.instance.translate('my_profile_title'),
                                  style: AppTextStyles.main14regular,
                                )
                              ],
                            ),
                            onTap: () {
                              if (refToken == '') {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                    fullscreenDialog: true
                                ));
                              } else {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const ProfileScreen(),
                                    fullscreenDialog: true
                                ));
                              }
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              if (refToken == '') {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ));
                              } else {
                                Navigator.of(context).pop();
                                Provider.of<AuthProvider>(context, listen: false).logout(context);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.black.withAlpha(60)
                              ),
                              child: SvgPicture.asset(
                                refToken == '' ?
                                'assets/icons/log_in_icon.svg' :
                                'assets/icons/logout_icon.svg',
                                colorFilter: const ColorFilter.mode(AppColors.darkBlack, BlendMode.srcIn),
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                  ListTile(
                    title: Text(Singleton.instance.translate('settings'), style: AppTextStyles.main16regular),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                          fullscreenDialog: true
                      ));
                    },
                  ),
                  //const Divider(),
                  // ListTile(
                  //   title: Text(Singleton.instance.translate('alarm_clock'), style: AppTextStyles.main16regular),
                  //   onTap: () {
                  //     Navigator.of(context).pop();
                  //     Navigator.of(context).push(MaterialPageRoute(
                  //         builder: (context) => const AlarmClockScreen(),
                  //         fullscreenDialog: true
                  //     ));
                  //   },
                  // ),
                  // ListTile(
                  //   title: Text('Test player', style: AppTextStyles.main16regular),
                  //   onTap: () {
                  //     Navigator.of(context).pop();
                  //     Navigator.of(context).push(MaterialPageRoute(
                  //       builder: (context) => PlayerTest(audioHandler: Singleton.instance.audioHandler),
                  //     ));
                  //   },
                  // ),
                  const Divider(),
                  ListTile(
                    title: Text(Singleton.instance.translate('additional_resources'), style: AppTextStyles.main16bold),
                    onTap: () {},
                  ),
                  // ListTile(
                  //   title: Text(Singleton.instance.translate('news_title'), style: AppTextStyles.main16regular),
                  //   onTap: () async {
                  //     Navigator.of(context).pop();
                  //     String url = 'https://skonto2.tst.lv/en/news';
                  //     String langCode = Singleton.instance.getLanguageCodeFromSharedPreferences();
                  //     if (langCode == 'en') {
                  //       url = 'https://skonto2.tst.lv/en/news';
                  //     }
                  //     if (langCode == 'lv') {
                  //       url = 'https://skonto2.tst.lv/lv/jaunumi';
                  //     }
                  //     if (langCode == 'ru') {
                  //       url = 'https://skonto2.tst.lv/ru/news';
                  //     }
                  //     Singleton.instance.openUrl(url, context);
                  //   },
                  // ),
                  ListTile(
                    title: Text(Singleton.instance.translate('app_tutorial'), style: AppTextStyles.main16regular),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const InstructionScreen(),
                      ));
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: Text(Singleton.instance.translate('privacy_policy_title'), style: AppTextStyles.main16regular),
                    onTap: () async {
                      Navigator.of(context).pop();
                      Singleton.instance.openUrl('https://skonto2.tst.lv', context);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: Text(Singleton.instance.translate('general_tender_rules'), style: AppTextStyles.main16regular),
                    onTap: () async {
                      Navigator.of(context).pop();
                      Singleton.instance.openUrl('https://skonto2.tst.lv', context);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: Text(Singleton.instance.translate('others_title'), style: AppTextStyles.main16bold),
                    onTap: () {},
                  ),
                  const Divider(),
                  ListTile(
                    title: Text(Singleton.instance.translate('report_bug'), style: AppTextStyles.main16regular),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ReportBugScreen(),
                          fullscreenDialog: true
                      ));
                      // Navigator.of(context).push(MaterialPageRoute(
                      //   builder: (context) => const WorkInProgressScreen(),
                      // ));
                    },
                  ),
                  ListTile(
                    title: Text('${Singleton.instance.translate('app_version')} v${appInfo.version}', style: AppTextStyles.main16regular),
                    onTap: () {},
                  ),
                ],
              ),
            ),) :
            const FiltersWidget(),
          ],
        );
  }
}