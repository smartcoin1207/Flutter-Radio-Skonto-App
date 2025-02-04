import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/constant.dart';
import 'package:radio_skonto/helpers/custom_app_icons_bars_icons.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/main.dart';
import 'package:radio_skonto/providers/main_screen_provider.dart';
import 'package:radio_skonto/providers/player_provider.dart';
import 'package:radio_skonto/providers/podcasts_provider.dart';
import 'package:radio_skonto/providers/translations_provider.dart';
import 'package:radio_skonto/screens/instructions_screen/instructions_screen.dart';
import 'package:radio_skonto/screens/playlists_screen/playlists_screen.dart';
import 'package:radio_skonto/screens/podcasts_screen/podcasts_screen.dart';
import 'package:radio_skonto/screens/promotion_screen/promotion_screen.dart';
import 'package:radio_skonto/screens/web_view_screen/web_view_screen.dart';
import 'package:radio_skonto/widgets/bottom_bar/bottom_bar_widget.dart';
import 'package:radio_skonto/widgets/drawer_widget.dart';
import '../home_screen/home_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class MyNavigationBar extends StatefulWidget {
  const MyNavigationBar({super.key});

  static const String routeName = '/home';

  @override
  State<MyNavigationBar> createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  List<Widget> screens = [];
  List<PersistentBottomNavBarItem> navItems = [];
  int currentScreenIndex = 0;

  @override
  void initState() {
    super.initState();

    final isTutorialShown = Singleton.instance.getIsTutorialShownFromSharedPreferences();
    if(isTutorialShown == false) {
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const InstructionScreen(),
        ),);
      });
    }
    
    _initPackageInfo();

    screens = [
      const HomeScreen(),
      const PodcastsScreen(),
      const PlaylistsScreen(),
      const PromotionScreen()
    ];

    initNavigationItems();
  }

  void initNavigationItems() {
    TextStyle titleStyle = const TextStyle(
        fontSize: 9
    );

    navItems = [
      PersistentBottomNavBarItem(
        textStyle: titleStyle,
        icon: const Icon(
          CustomAppIconsBars.radio_icon,
        ),
        title: (Singleton.instance.translate('radio')),
        activeColorPrimary: AppColors.red,
        inactiveColorPrimary: AppColors.black,
      ),
      PersistentBottomNavBarItem(
        textStyle: titleStyle,
        icon: const Icon(
          size: 32,
          CustomAppIconsBars.microphone,
        ),
        title: (Singleton.instance.translate('podcasts')),
        activeColorPrimary: AppColors.red,
        inactiveColorPrimary: AppColors.black,
      ),
      PersistentBottomNavBarItem(
        //contentPadding: 0,
        textStyle: titleStyle,
        icon: const Icon(
          size: 32,
          CustomAppIconsBars.music,
        ),
        title: (Singleton.instance.translate('live_broadcasts')),
        activeColorPrimary: AppColors.red,
        inactiveColorPrimary: AppColors.black,
      ),
      PersistentBottomNavBarItem(
        textStyle: titleStyle,
        icon: const Icon(
          size: 30,
          CustomAppIconsBars.pressent,
        ),
        title: (Singleton.instance.translate('promotions')),
        activeColorPrimary: AppColors.red,
        inactiveColorPrimary: AppColors.black,
      ),
    ];
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      Singleton.instance.packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: Provider.of<PodcastsProvider>(context),
        child: Consumer<PodcastsProvider>(builder: (context, podcastsProvider, _) {
          return ChangeNotifierProvider.value(
              value: Provider.of<PlayerProvider>(context),
              child: Consumer<PlayerProvider>(builder: (context, playerProvider, _) {
                return Scaffold(
                  key: scaffoldKey,
                  endDrawer: DrawerWidget(appInfo: Singleton.instance.packageInfo),
                  onEndDrawerChanged: (isOpen) {
                    if (isOpen == false && Singleton.instance.isMainMenu == false) {
                      podcastsProvider.refreshDataAfterApplyingFilters(context);
                    }
                  },
                  floatingActionButton: const AppBottomBar(),
                  floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                  body: ChangeNotifierProvider.value(
                      value: Provider.of<TranslationsProvider>(context),
                      child: Consumer<TranslationsProvider>(builder: (context, translationsProvider, _) {
                        initNavigationItems();
                        return PersistentTabView(
                          key: const ValueKey<int>(87633),
                          margin: EdgeInsets.zero,
                          padding: const EdgeInsets.only(top: 15, bottom: 0),
                          context,
                          isVisible: playerProvider.navigationBarMustBeShown,
                          controller: playerProvider.tabBarController,
                          screens: screens,
                          items: navItems,
                          //confineInSafeArea: true,
                          backgroundColor: Colors.white,
                          handleAndroidBackButtonPress: true,
                          resizeToAvoidBottomInset: false,
                          stateManagement: true,
                          decoration: const NavBarDecoration(
                            colorBehindNavBar: Colors.white,
                          ),
                          animationSettings: const NavBarAnimationSettings(
                            navBarItemAnimation: ItemAnimationSettings(
                              // Navigation Bar's items animation properties.
                              duration: Duration(milliseconds: 400),
                              curve: Curves.ease,
                            ),
                            screenTransitionAnimation: ScreenTransitionAnimationSettings(
                              // Screen transition animation on change of selected tab.
                              animateTabTransition: true,
                              duration: Duration(milliseconds: 300),
                              screenTransitionAnimationType:
                              ScreenTransitionAnimationType.fadeIn,
                            ),
                            onNavBarHideAnimation: OnHideAnimationSettings(
                              duration: Duration(milliseconds: 100),
                              curve: Curves.bounceInOut,
                            ),
                          ),
                          navBarStyle: NavBarStyle.style6,
                          onItemSelected: (index) {
                            final mainProvider = Provider.of<MainScreenProvider>(context, listen: false);
                            if (mainProvider.scrollControllerHomeScreen.hasClients) {
                              mainProvider.scrollControllerHomeScreen.jumpTo(0);
                              mainProvider.notifyListeners();
                              playerProvider.tabBarIndexIsChanged(index);
                            }
                          },
                        );
                      })
                  ),
                );
              }));
      })
    );
  }
}
