import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

class WaveformWidget extends StatefulWidget {
  final AudioPlayer player;

  const WaveformWidget({super.key, required this.player});

  @override
  State<WaveformWidget> createState() => _WaveformWidgetState();
}

class _WaveformWidgetState extends State<WaveformWidget> {
  late PlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PlayerController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AudioFileWaveforms(
      playerController: _controller,
      size: const Size(double.infinity, 200),
      waveformType: WaveformType.long,
      playerWaveStyle: PlayerWaveStyle(
        waveThickness: 2,
        liveWaveColor: Colors.blue,
        seekLineColor: Colors.red,
      ),
    );
  }
}
