import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_skonto/providers/main/main_block.dart';
import 'package:radio_skonto/providers/player_provider.dart';
import 'package:radio_skonto/widgets/bottom_bar/error_bar_widget.dart';
import 'package:radio_skonto/widgets/mini_app_player.dart';

class AppBottomBar extends StatelessWidget {
  // final StatefulNavigationShell navigationShell;

  const AppBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    if (context.watch<MainBloc>().state.errorConnect) {
      children.add(const AppErrorBar());
    }
    if (context.watch<PlayerProvider>().getShowMiniPlayer) {
      children.add(const MiniAppPlayer());
    }

    //children.add(const CustomAppBar());

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: context.watch<PlayerProvider>().getIsOpening
          ? const SizedBox.shrink()
          : Column(mainAxisSize: MainAxisSize.min, children: children),
    );
  }
}
