// import 'package:flutter/material.dart';
// import 'package:radio_skonto/helpers/audio_player_handler.dart';
// import 'package:audio_service/audio_service.dart';
// import 'package:radio_skonto/screens/test_player/audio_player_handler_impl.dart';
// import 'package:radio_skonto/screens/test_player/common.dart';
// import 'package:radio_skonto/screens/test_player/queue_state.dart';
//
// class ControlButtons extends StatelessWidget {
//   final AudioPlayerHandler audioHandler;
//
//   const ControlButtons(this.audioHandler, {Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         IconButton(
//           icon: const Icon(Icons.volume_up),
//           onPressed: () {
//             showSliderDialog(
//               context: context,
//               title: "Adjust volume",
//               divisions: 10,
//               min: 0.0,
//               max: 1.0,
//               value: audioHandler.volume.value,
//               stream: audioHandler.volume,
//               onChanged: audioHandler.setVolume,
//             );
//           },
//         ),
//         StreamBuilder<QueueState>(
//           stream: audioHandler.queueState,
//           builder: (context, snapshot) {
//             final queueState = snapshot.data ?? QueueState.empty;
//             return IconButton(
//               icon: const Icon(Icons.skip_previous),
//               onPressed:
//               queueState.hasPrevious ? audioHandler.skipToPrevious : null,
//             );
//           },
//         ),
//         StreamBuilder<PlaybackState>(
//           stream: audioHandler.playbackState,
//           builder: (context, snapshot) {
//             final playbackState = snapshot.data;
//             final processingState = playbackState?.processingState;
//             final playing = playbackState?.playing;
//             if (processingState == AudioProcessingState.loading ||
//                 processingState == AudioProcessingState.buffering) {
//               return Container(
//                 margin: const EdgeInsets.all(8.0),
//                 width: 64.0,
//                 height: 64.0,
//                 child: const CircularProgressIndicator(),
//               );
//             } else if (playing != true) {
//               return IconButton(
//                 icon: const Icon(Icons.play_arrow),
//                 iconSize: 64.0,
//                 onPressed: audioHandler.play,
//               );
//             } else {
//               return IconButton(
//                 icon: const Icon(Icons.pause),
//                 iconSize: 64.0,
//                 onPressed: audioHandler.pause,
//               );
//             }
//           },
//         ),
//         StreamBuilder<QueueState>(
//           stream: audioHandler.queueState,
//           builder: (context, snapshot) {
//             final queueState = snapshot.data ?? QueueState.empty;
//             return IconButton(
//               icon: const Icon(Icons.skip_next),
//               onPressed: queueState.hasNext ? audioHandler.skipToNext : null,
//             );
//           },
//         ),
//         StreamBuilder<double>(
//           stream: audioHandler.speed,
//           builder: (context, snapshot) => IconButton(
//             icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
//                 style: const TextStyle(fontWeight: FontWeight.bold)),
//             onPressed: () {
//               showSliderDialog(
//                 context: context,
//                 title: "Adjust speed",
//                 divisions: 10,
//                 min: 0.5,
//                 max: 1.5,
//                 value: audioHandler.speed.value,
//                 stream: audioHandler.speed,
//                 onChanged: audioHandler.setSpeed,
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }