import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_skonto/core/extensions.dart';
import 'package:radio_skonto/helpers/api_helper.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/providers/player_provider.dart';
import 'package:radio_skonto/providers/playlists_provider.dart';
import 'package:radio_skonto/screens/playlists_screen/playlist_horisontal_grid_widget.dart';
import 'package:radio_skonto/screens/playlists_screen/playlist_vertical_grid_widget.dart';
import 'package:radio_skonto/widgets/custom_app_bar.dart';
import 'package:radio_skonto/widgets/drawer_widget.dart';
import 'package:radio_skonto/widgets/progress_indicator_widget.dart';

class PlaylistsScreen extends StatefulWidget {
  const PlaylistsScreen({super.key});

  @override
  State<PlaylistsScreen> createState() => _PlaylistsScreenState();
}

class _PlaylistsScreenState extends State<PlaylistsScreen> {

  final appBar = const CustomAppBar();

  @override
  void initState() {
    Provider.of<PlaylistsProvider>(context, listen: false).getPlaylistData(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      endDrawer: DrawerWidget(appInfo: Singleton.instance.packageInfo),
      body: ChangeNotifierProvider.value(
          value: Provider.of<PlaylistsProvider>(context),
          child: ChangeNotifierProvider.value(
              value: Provider.of<PlaylistsProvider>(context),
              child: Consumer<PlaylistsProvider>(builder: (context, playlistProvider, _) {
                return playlistProvider.getPlaylistDataResponseState == ResponseState.stateLoading ?
                AppProgressIndicatorWidget(
                  responseState: playlistProvider.getPlaylistDataResponseState,
                  onRefresh: () {
                    playlistProvider.getPlaylistData(false);
                  },
                ) :
                Padding(padding: const EdgeInsets.only(top: 35),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        playlistProvider.playlistData == null ? const SizedBox() :
                        PlaylistHorizontalGridWidget(
                            onItemTap: (index){
                              context.read<PlayerProvider>().playAllTypeMedia(playlistProvider.playlistData!.data.playlists, index, '', '');
                            },
                            mainDataList: playlistProvider.playlistData!.data.playlists,
                            title: Singleton.instance.translate('radio_recommendations')
                        ),
                        20.hs,
                        playlistProvider.playlistData == null ? const SizedBox() :
                        PlaylistHorizontalGridWidget(
                            onItemTap: (index){
                              context.read<PlayerProvider>().playAllTypeMedia(playlistProvider.playlistData!.data.mostListened, index, '', '');
                            },
                            mainDataList: playlistProvider.playlistData!.data.mostListened,
                            title: Singleton.instance.translate('most_popular_items')
                        ),
                        20.hs,
                        playlistProvider.playlistData == null ? const SizedBox() :
                        PlaylistVerticalGridWidget(
                            onItemTap: (index){
                              context.read<PlayerProvider>().playAllTypeMedia(playlistProvider.playlistData!.data.suggestedByRadio, index, '', '');
                            },
                            mainDataList: playlistProvider.playlistData!.data.suggestedByRadio,
                            title: Singleton.instance.translate('all_live_broadcasts_and_playlists')
                        )
                      ],
                    ),
                  ),
                );
              })
          ))
    );
  }
}
