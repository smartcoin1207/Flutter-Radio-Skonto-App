import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:radio_skonto/helpers/app_colors.dart';

class AppBottomNavigationBar extends StatelessWidget {
  static const height = 80.0;

  //final StatefulNavigationShell navigationShell;

  const AppBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    //final routeName =
    //navigationShell.shellRouteContext.routerState.uri.toString();
    //debugPrint('AppBottomNavigationBar.build: uri - $routeName');

    final iconThemeData = const IconThemeData.fallback()
        .copyWith(size: 24, color: AppColors.white);
    return Container(
      height: height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.center,
          colors: AppColors.blackGradient,
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        selectedIconTheme: iconThemeData,
        unselectedIconTheme: iconThemeData,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        selectedItemColor: AppColors.white,
        unselectedItemColor: AppColors.white,
        showSelectedLabels: false,
        currentIndex: 1,
        onTap: (index) {
          // final initialLocation = index == navigationShell.currentIndex;
          // if (initialLocation && routeName == CategoriesScreen.routeName) {
          //   context
          //       .go('${CategoriesScreen.routeName}/${SearchScreen.routeName}');
          //   return;
          // }
          // navigationShell.goBranch(index, initialLocation: initialLocation);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.house_fill),
            activeIcon: Icon(CupertinoIcons.house_fill),
            label: 'Sākums',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
            activeIcon: Icon(CupertinoIcons.search),
            label: 'Meklēt',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.book_fill),
            activeIcon: Icon(CupertinoIcons.book_fill),
            label: 'Mana bibliotēka',
          ),
        ],
      ),
    );
  }
}
