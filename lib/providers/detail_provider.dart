import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_skonto/helpers/api_helper.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/models/interview_model.dart';
import 'package:radio_skonto/models/main_screen_data.dart';
import 'package:radio_skonto/models/podcasts_model.dart';
import 'package:radio_skonto/providers/player_provider.dart';
import 'package:radio_skonto/screens/podcasts_screen/interviews/interview_detail_screen_html.dart';
import 'package:radio_skonto/screens/podcasts_screen/interviews/interview_detail_screen_songs.dart';
import 'package:radio_skonto/screens/podcasts_screen/interviews/interview_detail_screen_video.dart';
import 'package:radio_skonto/screens/podcasts_screen/podcasts_detail.dart';

class DetailProvider with ChangeNotifier {

  ResponseState getDetailDataResponseState = ResponseState.stateFirsLoad;

  Podcast? podcastData;
  InterviewData? interviewData;
  Episode? episode;
  MainData? playList;

  Future<void> getDetailData(BuildContext context, int mediaId, String mediaType) async {
    try {
      getDetailDataResponseState = ResponseState.stateLoading;
      notifyListeners();
      ApiHelper helper = ApiHelper();
      String apiKey = '';
      String languageCode = Singleton.instance.getLanguageCodeFromSharedPreferences();
      if (mediaType.toLowerCase() == 'podcast') {
        apiKey = '/api/podcasts/$mediaId/$languageCode';
      } else if (mediaType.toLowerCase() == 'interview') {
        apiKey = '/api/interviews/$mediaId/$languageCode';
      } else if (mediaType.toLowerCase() == 'episode') {
        apiKey = '/api/podcasts/episode/$mediaId/$languageCode';
      } else if (mediaType.toLowerCase() == 'playlist') {
        apiKey = '/api/playlists/$mediaId/$languageCode';
      }
      final response = await helper.get(apiKey, null);

      if (response != null && response.statusCode == 200) {
        var errorTest = jsonDecode(response.body);
        if (errorTest['error'] != null) {
          getDetailDataResponseState = ResponseState.stateError;
          notifyListeners();
        } else {
          try {
            if (mediaType.toLowerCase() == 'podcast') {
              var d = jsonDecode(response.body)['data'];
              podcastData = singlePodcastFromJson(d);
              openMediaDetail(podcastData, context);
              getDetailDataResponseState = ResponseState.stateSuccess;
              notifyListeners();
            }
            if (mediaType.toLowerCase() == 'interview') {
              var d = jsonDecode(response.body)['data'];
              interviewData = singleInterviewDataFromJson(d);
              openMediaDetail(interviewData, context);
              getDetailDataResponseState = ResponseState.stateSuccess;
              notifyListeners();
            }
            if (mediaType.toLowerCase() == 'playlist') {
              var d = jsonDecode(response.body)['data'];
              playList = singleMainScreenDataFromJson(d);
              openMediaDetail(playList, context);
              getDetailDataResponseState = ResponseState.stateSuccess;
              notifyListeners();
            }
            if (mediaType.toLowerCase() == 'episode') {
              var d = jsonDecode(response.body)['data'];
              episode = singleEpisodeFromJson(d);
              openMediaDetail(episode, context);
              getDetailDataResponseState = ResponseState.stateSuccess;
              notifyListeners();
            }
          } catch (exc) {
            getDetailDataResponseState = ResponseState.stateError;
            notifyListeners();
          }
        }
      } else {
        getDetailDataResponseState = ResponseState.stateError;
        notifyListeners();
      }
    } catch (exc) {
      getDetailDataResponseState = ResponseState.stateError;
      notifyListeners();
    }
  }

  void openMediaDetail(dynamic media, BuildContext context) {
    if (media != null) {
      if (media is InterviewData) {
        _openDetailInterview(media, context);
      }
      if (media is Episode) {
        _playEpisode(context, media);
      }
      if (media is MainData) {
        _playPlaylist(context, media);
      }
      if (media is Podcast) {
        _openPodcast(context, media);
      }
    }
  }

  void _openDetailInterview(InterviewData interview, BuildContext context) {
    Provider.of<PlayerProvider>(context, listen: false).hideNavigationBar();
    if (interview.contentData.cards.first.type == 'video') {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => InterviewDetailScreenVideo(interview: interview),
      ));
    }
    if (interview.contentData.cards.first.type == 'html') {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => InterviewDetailScreenHTML(interview: interview)
      ));
    }
    if (interview.contentData.cards.first.type == 'audio') {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => InterviewDetailScreenSongs(interview: interview)
      ));
    }
  }

  void _openPodcast(BuildContext context, Podcast podcast) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => PodcastDetailScreen(podcast: podcast),
      fullscreenDialog: true
    ));
  }

  void _playEpisode(BuildContext context, Episode episodeData) {
    Provider.of<PlayerProvider>(context, listen: false).playAllTypeMedia([episodeData], 0, episodeData.title, '');
  }

  void _playPlaylist(BuildContext context, MainData playlistData) {
    Provider.of<PlayerProvider>(context, listen: false).playAllTypeMedia([playlistData], 0, '', '');
  }
}
