import 'dart:io';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/providers/main/main_block.dart';
import 'package:radio_skonto/providers/player_provider.dart';
import 'package:radio_skonto/screens/player/animation_controller.dart';
import 'package:radio_skonto/screens/player/player.dart';
import 'package:radio_skonto/widgets/bottom_bar/bottom_navigation_bar_widget.dart';
import 'package:radio_skonto/widgets/bottom_bar/error_bar_widget.dart';
import 'package:radio_skonto/widgets/mini_app_player.dart';

extension BuildContextExtension on BuildContext {
  double get bottom {
    if (watch<PlayerProvider>().getIsOpening) {
      return 0;
    }

    var bottom = AppBottomNavigationBar.height;
    if (watch<PlayerProvider>().getShowMiniPlayer) {
      bottom += MiniAppPlayer.height;
    }
    if (watch<MainBloc>().state.errorConnect) {
      bottom += AppErrorBar.height;
      bottom += AppErrorBar.margin;
    }
    return bottom;
  }

  Future openPlayer(int? index, List<dynamic>? playlist, AppPlayer player, AnimationController controller) {
    return showMaterialModalBottomSheet(
      context: this,
      backgroundColor: AppColors.darkBlack,
      isDismissible: true,
      closeProgressThreshold: 0.1,
      secondAnimation: controller,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 1,
          expand: false,
          builder: (context, controller) {
            return player;
          },
        );
      },
    );
  }
}

extension DoubleExtension on double {
  Widget get hs {
    return SizedBox(height: this);
  }

  Widget get ws {
    return SizedBox(width: this);
  }
}

extension IntExtension on int {
  Widget get hs {
    return SizedBox(height: toDouble());
  }

  Widget get ws {
    return SizedBox(width: toDouble());
  }
}

extension StringExtension on String {
  Color get toColor {
    var hexColor = toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    var value = int.tryParse(hexColor, radix: 16) ?? 0;
    return Color(value);
  }
}

extension DurationExtension on Duration {
  String get time {
    String seconds = inSeconds.remainder(60).toString();
    String minutes = inMinutes.remainder(60).toString();
    String hours = inHours.toString();
    if (seconds.length == 1) seconds = '0$seconds';
    if (minutes.length == 1) minutes = '0$minutes';
    if (hours.length == 1) hours = '0$hours';
    if (inHours == 0) {
      return "${inMinutes.remainder(60)}:$seconds";
    } else {
      return "$inHours:${inMinutes.remainder(60)}:$seconds";
    }
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
