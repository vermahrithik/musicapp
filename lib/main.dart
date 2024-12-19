import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicapp/utils/apiConstants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() => runApp(const MusicVisualizerApp());

class MusicVisualizerApp extends StatelessWidget {
  const MusicVisualizerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screentype) {
      return  MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MusicVisualizerScreen(),
      );
    },);
  }
}

class MusicVisualizerScreen extends StatefulWidget {
  @override
  State<MusicVisualizerScreen> createState() => _MusicVisualizerScreenState();
}

class _MusicVisualizerScreenState extends State<MusicVisualizerScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final List<double> _waveHeights = List.generate(50, (_) => Random().nextDouble() * 50);
  late StreamSubscription<Duration> _positionSubscription;

  Duration _totalDuration = Duration.zero;
  Duration _currentPosition = Duration.zero;

  bool _isDragging = false;
  double _dragPosition = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeAudioPlayer();
  }

  Future<void> _initializeAudioPlayer() async {
    try {
      await _audioPlayer.setUrl(
          ApiConstants.BASE_URL+ApiConstants.LOCAL_URL);

      _totalDuration = _audioPlayer.duration ?? Duration.zero;

      _audioPlayer.durationStream.listen((duration) {
        if (duration != null) {
          setState(() {
            _totalDuration = duration;
          });
        }
      });

      _positionSubscription = _audioPlayer.positionStream.listen((position) {
        if (!_isDragging) {
          setState(() {
            _currentPosition = position;
          });
        }
      });
    } catch (e) {
      print("Error initializing audio player: $e");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _positionSubscription.cancel();
    super.dispose();
  }

  void _onWaveDragUpdate(double dragX) {
    setState(() {
      _isDragging = true;
      _dragPosition = dragX;
    });
  }

  void _onWaveDragEnd() {
    final seekPosition =
        (_dragPosition / MediaQuery.of(context).size.width) * _totalDuration.inMilliseconds;
    _audioPlayer.seek(Duration(milliseconds: seekPosition.toInt()));
    setState(() {
      _isDragging = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            ClipRRect(borderRadius: BorderRadius.circular(20.sp),child: SizedBox(height: 50,width: 50, child: Image.asset('assets/images/background.png',fit: BoxFit.cover,alignment: Alignment.center,))),
            const SizedBox(height: 20),

            const Text(
              'Instant Crush',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              'feat. Julian Casablancas',
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
            const SizedBox(height: 20),

            SizedBox(
              height: 10.h,
              width: 80.w,
              child: GestureDetector(
                onHorizontalDragUpdate: (details) => _onWaveDragUpdate(details.localPosition.dx),
                onHorizontalDragEnd: (_) => _onWaveDragEnd(),
                child: CustomPaint(
                  size: Size(MediaQuery.of(context).size.width, 80),
                  painter: WavePainter(
                    waveHeights: _waveHeights,
                    progress:
                    _isDragging ? (_dragPosition / MediaQuery.of(context).size.width) : (_currentPosition.inMilliseconds / _totalDuration.inMilliseconds),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '${_formatDuration(_currentPosition)} / ${_formatDuration(_totalDuration)}',
              style: const TextStyle(color: Colors.grey),
            ),
            IconButton(
              icon: Icon(
                _audioPlayer.playing ? Icons.pause_circle_filled : Icons.play_circle_filled,
                color: Colors.white,
                size: 64,
              ),
              onPressed: () {
                if (_audioPlayer.playing) {
                  _audioPlayer.pause();
                } else {
                  _audioPlayer.play();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class WavePainter extends CustomPainter {
  final List<double> waveHeights;
  final double progress;

  WavePainter({required this.waveHeights, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;


    for (int i = 0; i < waveHeights.length; i++) {
      final x = i * (size.width / waveHeights.length);
      final height = waveHeights[i];
      paint.color = i / waveHeights.length <= progress ? Colors.white : Colors.grey;

      canvas.drawLine(Offset(x, size.height / 2 - height / 2),
          Offset(x, size.height / 2 + height / 2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
