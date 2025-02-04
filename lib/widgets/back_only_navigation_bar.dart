import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/providers/player_provider.dart';
import 'package:radio_skonto/screens/navigation_bar/navigation_bar.dart';
import 'package:radio_skonto/screens/podcasts_screen/podcasts_screen.dart';

class BackOnlyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BackOnlyAppBar({super.key,});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  //kToolbarHeight

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        //title: Text('test', style: AppTextStyles.main16bold.copyWith(color: AppColors.white),),
        centerTitle: true,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
            ),
            onPressed: () {
              context.read<PlayerProvider>().showNavigationBar();
              Navigator.of(context).pop();
            },
          )
      ),
    );
  }
}
