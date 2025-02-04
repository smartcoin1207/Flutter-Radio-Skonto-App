// import 'package:audio_service/audio_service.dart';
// import 'package:just_audio/just_audio.dart';
//
// class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
//   static final _item = MediaItem(
//     playable: true,
//     id: 'https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3',
//     album: "Science Friday",
//     title: "A Salute To Head-Scratching Science",
//     artist: "Science Friday and WNYC Studios",
//     duration: const Duration(milliseconds: 5739820),
//     artUri: Uri.parse(
//         'https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg'),
//   );
//   static final _item2 = MediaItem(
//     playable: true,
//     id: 'https://commondatastorage.googleapis.com/codeskulptor-demos/DDR_assets/Sevish_-__nbsp_.mp3',
//     album: "Science Friday",
//     title: "A Salute To Head-Scratching Science",
//     artist: "Science Friday and WNYC Studios",
//     duration: const Duration(milliseconds: 5739820),
//     artUri: Uri.parse(
//         'https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg'),
//   );
//   static final _item3 = MediaItem(
//     id: 'https://commondatastorage.googleapis.com/codeskulptor-demos/DDR_assets/Kangaroo_MusiQue_-_The_Neverwritten_Role_Playing_Game.mp3',
//     album: "Science Friday",
//     title: "A Salute To Head-Scratching Science",
//     artist: "Science Friday and WNYC Studios",
//     duration: const Duration(milliseconds: 5739820),
//     artUri: Uri.parse(
//         'https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg'),
//   );
//
//   final _player = AudioPlayer();
//   late ConcatenatingAudioSource _playlist;
//
//   void _setInitialPlaylist() async {
//     const prefix = 'https://www.soundhelix.com/examples/mp3';
//     final song1 = Uri.parse('$prefix/SoundHelix-Song-1.mp3');
//     final song2 = Uri.parse('$prefix/SoundHelix-Song-2.mp3');
//     final song3 = Uri.parse('$prefix/SoundHelix-Song-3.mp3');
//     _playlist = ConcatenatingAudioSource(children: [
//       AudioSource.uri(song1, tag: 'Song 1'),
//       AudioSource.uri(song2, tag: 'Song 2'),
//       AudioSource.uri(song3, tag: 'Song 3'),
//     ]);
//     await _player.setAudioSource(_playlist);
//   }
//
//   void _listenForChangesInSequenceState() {
//     _player.sequenceStateStream.listen((sequenceState) {
//       if (sequenceState == null) return;
//       // TODO: update current song title
//       // TODO: update playlist
//       // TODO: update shuffle mode
//       // TODO: update previous and next buttons
//     });
//   }
//
//   /// Initialise our audio handler.
//   AudioPlayerHandler() {
//     // So that our clients (the Flutter UI and the system notification) know
//     // what state to display, here we set up our audio handler to broadcast all
//     // playback state changes as they happen via playbackState...
//     _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
//     // ... and also the current media item via mediaItem.
//
//     // mediaItem.add(_item);
//     // mediaItem.add(_item2);
//     // mediaItem.add(_item3);
//     //
//     // // Load the player.
//     // _player.setAudioSource(AudioSource.uri(Uri.parse(_item.id)));
//     //_setInitialPlaylist();
//
//     List<MediaItem> mediaItems = [];
//     mediaItems.add(_item);
//     mediaItems.add(_item2);
//     mediaItems.add(_item3);
//
//     addQueueItems(mediaItems);
//     playMediaItem(mediaItems.first);
//
//     //_player.setAudioSource(AudioSource.uri(Uri.parse(_item.id)));
//   }
//
//   @override
//   Future<void> addQueueItems(List<MediaItem> mediaItems) async {
//     // manage Just Audio
//     final audioSource = mediaItems.map(_createAudioSource);
//     _playlist.addAll(audioSource.toList());
//
//     // notify system
//     final newQueue = queue.value..addAll(mediaItems);
//     queue.add(newQueue);
//   }
//
//   UriAudioSource _createAudioSource(MediaItem mediaItem) {
//     return AudioSource.uri(
//       Uri.parse(mediaItem.extras!['url'] as String),
//       tag: mediaItem,
//     );
//   }
//
//   // In this simple example, we handle only 4 actions: play, pause, seek and
//   // stop. Any button press from the Flutter UI, notification, lock screen or
//   // headset will be routed through to these 4 methods so that you can handle
//   // your audio playback logic in one place.
//
//   @override
//   Future<void> play() => _player.play();
//
//   @override
//   Future<void> pause() => _player.pause();
//
//   @override
//   Future<void> seek(Duration position) => _player.seek(position);
//
//   @override
//   Future<void> stop() => _player.stop();
//
//   /// Transform a just_audio event into an audio_service state.
//   ///
//   /// This method is used from the constructor. Every event received from the
//   /// just_audio player will be transformed into an audio_service state so that
//   /// it can be broadcast to audio_service clients.
//   PlaybackState _transformEvent(PlaybackEvent event) {
//     return PlaybackState(
//       controls: [
//         MediaControl.rewind,
//         if (_player.playing) MediaControl.pause else MediaControl.play,
//         MediaControl.stop,
//         MediaControl.fastForward,
//       ],
//       systemActions: const {
//         MediaAction.seek,
//         MediaAction.seekForward,
//         MediaAction.seekBackward,
//       },
//       androidCompactActionIndices: const [0, 1, 3],
//       processingState: const {
//         ProcessingState.idle: AudioProcessingState.idle,
//         ProcessingState.loading: AudioProcessingState.loading,
//         ProcessingState.buffering: AudioProcessingState.buffering,
//         ProcessingState.ready: AudioProcessingState.ready,
//         ProcessingState.completed: AudioProcessingState.completed,
//       }[_player.processingState]!,
//       playing: _player.playing,
//       updatePosition: _player.position,
//       bufferedPosition: _player.bufferedPosition,
//       speed: _player.speed,
//       queueIndex: event.currentIndex,
//     );
//   }
// }