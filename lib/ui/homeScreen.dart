// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../blocs/audio_bloc.dart';
//
// class MusicVisualizerScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => AudioBloc()..add(AudioLoadEvent('https://codeskulptor-demos.commondatastorage.googleapis.com/descent/background%20music.mp3')),
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         body: BlocBuilder<AudioBloc, AudioState>(
//           builder: (context, state) {
//             if (state is AudioInitial) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (state is AudioLoadedState || state is AudioPlayingState) {
//               return Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                    height:50,
//                    width:50,
//                    child:Center(child:Image.asset(
//                     'assets/images/Background.png',
//                     fit:BoxFit.cover,
//                     alignment:Alignment.center,
//                   ),)
//                   ),
//                   const SizedBox(height: 20),
//                   const Text(
//                     'Instant Crush',
//                     style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
//                   ),
//                   const Text(
//                     'feat. Julian Casablancas',
//                     style: TextStyle(color: Colors.grey, fontSize: 18),
//                   ),
//                   const SizedBox(height: 20),
//                   GestureDetector(
//                     onHorizontalDragUpdate: (details) {
//                       final width = MediaQuery.of(context).size.width;
//                       final dragPosition = (details.localPosition.dx / width) * state.duration.inMilliseconds;
//                       context.read<AudioBloc>().add(AudioSeekEvent(Duration(milliseconds: dragPosition.toInt())));
//                     },
//                     child: CustomPaint(
//                       size: Size(MediaQuery.of(context).size.width, 80),
//                       painter: WavePainter(
//                         waveHeights: state.waveHeights,
//                         progress: state is AudioPlayingState
//                             ? (state.currentPosition.inMilliseconds / state.duration.inMilliseconds)
//                             : 0.0,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Text(
//                     '${_formatDuration(state.currentPosition)} / ${_formatDuration(state.duration)}',
//                     style: const TextStyle(color: Colors.grey),
//                   ),
//                   IconButton(
//                     icon: Icon(
//                       state is AudioPlayingState && state.isPlaying
//                           ? Icons.pause_circle_filled
//                           : Icons.play_circle_filled,
//                       color: Colors.white,
//                       size: 64,
//                     ),
//                     onPressed: () {
//                       context.read<AudioBloc>().add(AudioPlayPauseEvent());
//                     },
//                   ),
//                 ],
//               );
//             } else if (state is AudioErrorState) {
//               return Center(child: Text(state.error, style: const TextStyle(color: Colors.red)));
//             } else {
//               return const Center(child: Text("Unknown state."));
//             }
//           },
//         ),
//       ),
//     );
//   }
//
//   String _formatDuration(Duration duration) {
//     final minutes = duration.inMinutes.toString().padLeft(2, '0');
//     final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
//     return '$minutes:$seconds';
//   }
// }
//
// class WavePainter extends CustomPainter {
//   final List<double> waveHeights;
//   final double progress;
//
//   WavePainter({required this.waveHeights, required this.progress});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..style = PaintingStyle.fill
//       ..strokeCap = StrokeCap.round;
//
//     for (int i = 0; i < waveHeights.length; i++) {
//       final x = i * (size.width / waveHeights.length);
//       final height = waveHeights[i];
//       paint.color = i / waveHeights.length <= progress ? Colors.white : Colors.grey;
//
//       canvas.drawLine(Offset(x, size.height / 2 - height / 2),
//           Offset(x, size.height / 2 + height / 2), paint);
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }
