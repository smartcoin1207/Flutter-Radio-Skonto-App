import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_skonto/helpers/api_helper.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/models/interview_model.dart' as interview;
import 'package:radio_skonto/models/podcasts_model.dart';
import 'package:radio_skonto/providers/player_provider.dart';

enum PodcastType { audio, video, interview }

class PodcastsProvider with ChangeNotifier {
  ResponseState getAudioPodcastsResponseState = ResponseState.stateFirsLoad;
  ResponseState getVideoPodcastsResponseState = ResponseState.stateFirsLoad;
  ResponseState getInterviewPodcastsResponseState = ResponseState.stateFirsLoad;

  Podcasts audioPodcasts = Podcasts(
      apiVersion: '',
      filters: Filters(sort: [], categories: [], subCategories: []),
      data: [],
      banners: []);
  Podcasts videoPodcasts = Podcasts(
      apiVersion: '',
      filters: Filters(sort: [], categories: [], subCategories: []),
      data: [],
      banners: []);
  interview.Interview interviewPodcasts = interview.Interview(
      apiVersion: '',
      filters: interview.Filters(sort: [], categories: []),
      data: [],
      banners: []);
  Filters filtersAudio = Filters(sort: [], categories: [], subCategories: []);
  Filters filtersVideo = Filters(sort: [], categories: [], subCategories: []);
  interview.Filters filtersInterview =
      interview.Filters(sort: [], categories: []);

  int currentAppBarIndex = 0;

  Future<void> getAllPodcasts(BuildContext context,
      {required bool isFromInit, var playerProvider}) async {
    getAudioPodcasts(context, isFromInit, playerProvider: playerProvider);
    getVideoPodcasts(context, isFromInit);
    getInterviewPodcasts(context, isFromInit, playerProvider: playerProvider);
  }

  Future<void> initAllPodcasts(
      {required bool isFromInit, var playerProvider}) async {
    initAudioPodcasts(isFromInit, playerProvider: playerProvider);
  }

  Future<void> initAudioPodcasts(bool isFromInit, {var playerProvider}) async {
    getAudioPodcastsResponseState = ResponseState.stateLoading;
    if (isFromInit == false) {
      notifyListeners();
    }
    ApiHelper helper = ApiHelper();
    String languageCode =
        Singleton.instance.getLanguageCodeFromSharedPreferences();
    Sort sortElem = Sort(name: 'Test', sortBy: 'dateFrom', sortOrder: 'desc');
    'dateFrom';
    if (filtersAudio.sort.isNotEmpty) {
      sortElem = filtersAudio.sort.firstWhere((element) => element.isSelected);
    }

    String apiKey =
        '/api/podcasts/audio/$languageCode/${sortElem.sortBy}/${sortElem.sortOrder}';
    List<int> categoryList = getSelectedCategoriesAudio();
    if (categoryList.isEmpty) {
      categoryList.add(-1);
    }
    Map<String, dynamic> finishBody = {
      'category': categoryList.isEmpty ? null : categoryList
    };
    var body = json.encode(finishBody);

    final response = await helper.initPostRequestWithToken(
      url: apiKey,
      body: body,
    );

    var errorTest = jsonDecode(response.body);
    if (response != null && response.statusCode == 200) {
      var errorTest = jsonDecode(response.body);
      if (errorTest['error'] != null) {
        getAudioPodcastsResponseState = ResponseState.stateError;
        notifyListeners();
      } else {
        audioPodcasts = podcastsFromJson(response.body);
        // await Provider.of<PlayerProvider>(context, listen: false).updateAndroidAutoAndCarPlayItems(audioPodcasts.data);
        audioPodcasts.filters.sort.first.isSelected = true;
        if (filtersAudio.sort.isEmpty) {
          filtersAudio = audioPodcasts.filters;
        } else {
          audioPodcasts.filters = filtersAudio;
        }

        if (playerProvider != null) {
          await playerProvider
              .updateAndroidAutoAndCarPlayItems(audioPodcasts.data);
        }
        getAudioPodcastsResponseState = ResponseState.stateSuccess;
        notifyListeners();
      }
    } else {
      getAudioPodcastsResponseState = ResponseState.stateError;
      notifyListeners();
    }
  }

  Future<void> getAudioPodcasts(BuildContext context, bool isFromInit,
      {var playerProvider}) async {
    getAudioPodcastsResponseState = ResponseState.stateLoading;
    if (isFromInit == false) {
      notifyListeners();
    }
    ApiHelper helper = ApiHelper();
    String languageCode =
        Singleton.instance.getLanguageCodeFromSharedPreferences();
    Sort sortElem = Sort(name: 'Test', sortBy: 'dateFrom', sortOrder: 'desc');
    'dateFrom';
    if (filtersAudio.sort.isNotEmpty) {
      sortElem = filtersAudio.sort.firstWhere((element) => element.isSelected);
    }

    String apiKey =
        '/api/podcasts/audio/$languageCode/${sortElem.sortBy}/${sortElem.sortOrder}';
    List<int> categoryList = getSelectedCategoriesAudio();
    if (categoryList.isEmpty) {
      categoryList.add(-1);
    }
    Map<String, dynamic> finishBody = {
      'category': categoryList.isEmpty ? null : categoryList
    };
    var body = json.encode(finishBody);

    final response = await helper.postRequestWithToken(
        url: apiKey, body: body, context: context);

    //var errorTest = jsonDecode(response.body);
    if (response != null && response.statusCode == 200) {
      var errorTest = jsonDecode(response.body);
      if (errorTest['error'] != null) {
        getAudioPodcastsResponseState = ResponseState.stateError;
        notifyListeners();
      } else {
        audioPodcasts = podcastsFromJson(response.body);
        // await Provider.of<PlayerProvider>(context, listen: false).updateAndroidAutoAndCarPlayItems(audioPodcasts.data);
        audioPodcasts.filters.sort.first.isSelected = true;
        if (filtersAudio.sort.isEmpty) {
          filtersAudio = audioPodcasts.filters;
        } else {
          audioPodcasts.filters = filtersAudio;
        }

        if (playerProvider != null) {
          await playerProvider
              .updateAndroidAutoAndCarPlayItems(audioPodcasts.data);
        }
        getAudioPodcastsResponseState = ResponseState.stateSuccess;
        notifyListeners();
      }
    } else {
      getAudioPodcastsResponseState = ResponseState.stateError;
      notifyListeners();
    }
  }

  Future<void> getVideoPodcasts(BuildContext context, bool isFromInit,
      {var playerProvider}) async {
    getVideoPodcastsResponseState = ResponseState.stateLoading;
    if (isFromInit == false) {
      notifyListeners();
    }
    ApiHelper helper = ApiHelper();
    String languageCode =
        Singleton.instance.getLanguageCodeFromSharedPreferences();
    Sort sortElem = Sort(name: 'Test', sortBy: 'dateFrom', sortOrder: 'desc');
    'dateFrom';
    if (filtersAudio.sort.isNotEmpty) {
      sortElem = filtersAudio.sort.firstWhere((element) => element.isSelected);
    }

    String apiKey =
        '/api/podcasts/video/$languageCode/${sortElem.sortBy}/${sortElem.sortOrder}';
    List<int> categoryList = getSelectedCategoriesVideo();
    if (categoryList.isEmpty) {
      categoryList.add(-1);
    }
    Map<String, dynamic> finishBody = {
      'category': categoryList.isEmpty ? '0' : categoryList
    };
    var body = json.encode(finishBody);

    final response = await helper.postRequestWithToken(
        url: apiKey, body: body, context: context);

    if (response != null && response.statusCode == 200) {
      var errorTest = jsonDecode(response.body);
      if (errorTest['error'] != null) {
        getVideoPodcastsResponseState = ResponseState.stateError;
        notifyListeners();
      } else {
        videoPodcasts = podcastsFromJson(response.body);
        if (playerProvider != null) {
          await playerProvider
              .updateAndroidAutoAndCarPlayItems(videoPodcasts.data);
        }
        videoPodcasts.filters.sort.first.isSelected = true;
        if (filtersVideo.sort.isEmpty) {
          filtersVideo = videoPodcasts.filters;
        }
        getVideoPodcastsResponseState = ResponseState.stateSuccess;
        notifyListeners();
      }
    } else {
      getVideoPodcastsResponseState = ResponseState.stateError;
      notifyListeners();
    }
  }

  Future<void> getInterviewPodcasts(BuildContext context, bool isFromInit,
      {var playerProvider}) async {
    getInterviewPodcastsResponseState = ResponseState.stateLoading;
    if (isFromInit == false) {
      notifyListeners();
    }
    ApiHelper helper = ApiHelper();
    String languageCode =
        Singleton.instance.getLanguageCodeFromSharedPreferences();
    interview.Sort sortElem =
        interview.Sort(name: 'Test', sortBy: 'dateFrom', sortOrder: 'desc');
    'dateFrom';
    if (filtersInterview.sort.isNotEmpty) {
      sortElem =
          filtersInterview.sort.firstWhere((element) => element.isSelected);
    }

    String apiKey =
        '/api/interviews/$languageCode/${sortElem.sortBy}/${sortElem.sortOrder}';
    List<int> categoryList = getSelectedCategoriesInterview();
    Map<String, dynamic> finishBody = {
      'category': categoryList.isEmpty ? null : categoryList
    };
    var body = json.encode(finishBody);

    final response = await helper.postRequestWithToken(
        url: apiKey, body: body, context: context);

    if (response != null && response.statusCode == 200) {
      var errorTest = jsonDecode(response.body);
      if (errorTest['error'] != null) {
        getInterviewPodcastsResponseState = ResponseState.stateError;
        notifyListeners();
      } else {
        interviewPodcasts = interview.interviewFromJson(response.body);
        //await Provider.of<PlayerProvider>(context, listen: false).updateAndroidAutoAndCarPlayItems(interviewPodcasts.data);
        if (playerProvider != null) {
          await playerProvider
              .updateAndroidAutoAndCarPlayItems(interviewPodcasts.data);
        }
        interviewPodcasts.filters.sort.first.isSelected = true;
        if (filtersInterview.sort.isEmpty) {
          filtersInterview = interviewPodcasts.filters;
        } else {
          interviewPodcasts.filters = filtersInterview;
        }
        getInterviewPodcastsResponseState = ResponseState.stateSuccess;
        notifyListeners();
      }
    } else {
      getInterviewPodcastsResponseState = ResponseState.stateError;
      notifyListeners();
    }
  }

  void refreshDataAfterApplyingFilters(BuildContext context) {
    if (currentAppBarIndex == 0) {
      getAudioPodcasts(context, false);
    }
    if (currentAppBarIndex == 1) {
      getVideoPodcasts(context, false);
    }
    if (currentAppBarIndex == 2) {
      getInterviewPodcasts(context, false);
    }
  }

  bool isFiltersHasChanges() {
    for (var i = 0; i < audioPodcasts.filters.sort.length; i++) {
      if (audioPodcasts.filters.sort[i].isSelected !=
          filtersAudio.sort[i].isSelected) {
        return true;
      }
    }

    for (var c in audioPodcasts.filters.sort) {
      for (var d in filtersAudio.sort) {
        if (c.isSelected != d.isSelected) {
          return true;
        }
      }
    }

    for (var c in audioPodcasts.filters.categories) {
      for (var d in filtersAudio.categories) {
        if (c.isSelected != d.isSelected) {
          return true;
        }
      }
    }

    for (var c in audioPodcasts.filters.subCategories) {
      for (var d in filtersAudio.subCategories) {
        if (c.isSelected != d.isSelected) {
          return true;
        }
      }
    }

    return false;
  }

  void setCurrentSortFilter(int sortIndex) {
    if (currentAppBarIndex == 0) {
      for (var element in filtersAudio.sort) {
        element.isSelected = false;
      }
      filtersAudio.sort[sortIndex].isSelected = true;
    }
    if (currentAppBarIndex == 1) {
      for (var element in filtersVideo.sort) {
        element.isSelected = false;
      }
      filtersVideo.sort[sortIndex].isSelected = true;
    }
    if (currentAppBarIndex == 2) {
      for (var element in filtersInterview.sort) {
        element.isSelected = false;
      }
      filtersInterview.sort[sortIndex].isSelected = true;
    }
  }

  List<int> getSelectedCategoriesAudio() {
    List<int> selectedCategories = [];
    for (var c in filtersAudio.categories) {
      if (c.isSelected) {
        selectedCategories.add(c.id);
      }
    }
    for (var c in filtersAudio.subCategories) {
      if (c.isSelected) {
        selectedCategories.add(c.id);
      }
    }
    return selectedCategories;
  }

  List<int> getSelectedCategoriesVideo() {
    List<int> selectedCategories = [];
    for (var c in filtersVideo.categories) {
      if (c.isSelected) {
        selectedCategories.add(c.id);
      }
    }
    for (var c in filtersVideo.subCategories) {
      if (c.isSelected) {
        selectedCategories.add(c.id);
      }
    }
    return selectedCategories;
  }

  List<int> getSelectedCategoriesInterview() {
    List<int> selectedCategories = [];
    for (var c in filtersInterview.categories) {
      if (c.isSelected) {
        selectedCategories.add(c.id);
      }
    }
    return selectedCategories;
  }

  void onFavoriteTap(dynamic item) {}
}
