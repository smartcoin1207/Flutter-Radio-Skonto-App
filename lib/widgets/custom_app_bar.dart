import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/main.dart';
import 'package:radio_skonto/providers/player_provider.dart';
import 'package:radio_skonto/screens/search/search_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key,});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: Provider.of<PlayerProvider>(context),
        child: Consumer<PlayerProvider>(builder: (context, playerProvider, _) {
          return playerProvider.navigationBarMustBeShown ?
          AppBar(
            toolbarHeight: playerProvider.appBarHeight,
            backgroundColor: playerProvider.currentTabBarIndex == 0 ? AppColors.red : AppColors.darkBlack,
            automaticallyImplyLeading: false,
            elevation: 0.0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(
                Icons.search,
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),);
              },
            ),
            actions: [
              IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/alarm_icon.svg',
                  colorFilter: ColorFilter.mode(Theme.of(context).appBarTheme.iconTheme!.color!, BlendMode.srcIn),
                ),
                onPressed: () {

                },
              ),
              IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/heart_icon.svg',
                  colorFilter: ColorFilter.mode(Theme.of(context).appBarTheme.iconTheme!.color!, BlendMode.srcIn),
                ),
                onPressed: () {

                },
              ),
              IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/burger_icon.svg',
                  colorFilter: ColorFilter.mode(Theme.of(context).appBarTheme.iconTheme!.color!, BlendMode.srcIn),
                ),
                onPressed: () {
                  Singleton.instance.isMainMenu = true;
                  scaffoldKey.currentState?.openEndDrawer();
                },
              )
            ],
          )
           :
          const SizedBox();
    })
    );
  }
}
