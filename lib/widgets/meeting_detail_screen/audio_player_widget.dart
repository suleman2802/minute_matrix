import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AudioPlayerWidget extends StatefulWidget {
  final int startSeconds;
  bool startWithDialogue;
  String meetingName;
  String meetingType;

  AudioPlayerWidget({
    Key? key,
    required this.startSeconds,
    required this.startWithDialogue,
    required this.meetingName,
    required this.meetingType,
  });

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;

  // Duration? lastPosition;

  @override
  void initState() {
    super.initState();
    _initializeRecording();
    // if(widget.startSeconds > 0){
    //   print("inside if");
    //   playRecording();
    // }
  }

  Future<void> _initializeRecording() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final url = await FirebaseStorage.instance
          .ref(
              '${userId}/${widget.meetingType}Meeting/${userId + widget.meetingName}/${widget.meetingName}.wav')
          .getDownloadURL();

      await _player.setUrl(url);
    } catch (e) {
      print('Failed to load audio: $e');
    }
  }

  playRecording() {
    print("playrecordingstart");
    if (widget.startWithDialogue) {
      _player.seek(Duration(
        seconds:
            //lastPosition == null?
            widget.startSeconds,
        // : lastPosition!.inSeconds
      ));
    }
    _player.play();
    setState(() {
      _isPlaying = true;
      // lastPosition = null;
      widget.startWithDialogue = false;
    });
    _player.playerStateStream.listen((state) {
      setState(() => _isPlaying = true);
    });
  }

  stopRecording() {
    _player.pause();
    setState(() {
      _isPlaying = false;
      widget.startWithDialogue = false;
      // lastPosition = _player.position;
    });
    _player.playerStateStream.listen((state) {
      setState(() => _isPlaying = false);
    });
  }

  String _formatDuration(Duration d) {
    return d.toString().split('.').first.padLeft(8, "0");
  }

  @override
  Widget build(BuildContext context) {
    if (widget.startSeconds > 0 && widget.startWithDialogue) {
      print("inside if");
      playRecording();
    }
    return Container(
      color: Theme.of(context).cardColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StreamBuilder<Duration>(
            stream: _player.positionStream,
            builder: (context, snapshot) {
              final position = snapshot.data ?? Duration.zero;
              final duration = _player.duration ?? Duration.zero;
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Column(
                  children: [
                    // Text(
                    //     "${_formatDuration(position)} / ${_formatDuration(duration)}"),
                    Slider(
                      value: position.inSeconds.toDouble(),
                      min: 0,
                      max: duration.inSeconds.toDouble(),
                      onChanged: (value) {
                        _player.seek(Duration(seconds: value.toInt()));
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${_formatDuration(position)}"),
                          Text("${_formatDuration(duration)}"),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                onPressed: () {
                  if (!_isPlaying) {
                    playRecording();
                  } else {
                    stopRecording();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
