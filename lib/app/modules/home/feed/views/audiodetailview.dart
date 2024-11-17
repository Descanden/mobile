import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioDetailView extends StatefulWidget {
  final File audioFile;

  const AudioDetailView({Key? key, required this.audioFile}) : super(key: key);

  @override
  State<AudioDetailView> createState() => _AudioDetailViewState();
}

class _AudioDetailViewState extends State<AudioDetailView> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // Toggle between playing and pausing the audio
  void _togglePlayPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(DeviceFileSource(widget.audioFile.path));
    }

    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Detail'),
        backgroundColor: const Color(0xFFAC9365),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.audiotrack,
              size: 100,
              color: Color(0xFFAC9365),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _togglePlayPause,
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFAC9365)),
              child: Text(isPlaying ? 'Pause Audio' : 'Play Audio'),
            ),
            const SizedBox(height: 20),
            if (!isPlaying) 
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);  // To go back to the previous screen
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFAC9365)),
                child: const Text('Back'),
              ),
          ],
        ),
      ),
    );
  }
}
