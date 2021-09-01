import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MusicPreviewPage extends StatefulWidget {
  final String musicUrl;

  const MusicPreviewPage({Key? key, required this.musicUrl}) : super(key: key);

  @override
  _MusicPreviewPageState createState() => _MusicPreviewPageState();
}

class _MusicPreviewPageState extends State<MusicPreviewPage> {
  AudioPlayer? player;


  @override
  void initState() {
    super.initState();
    startPlayer();
  }

  startPlayer()async{
    player = new AudioPlayer();
    await player!.setUrl(widget.musicUrl);
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Text("Playing the audio file"),
      ),
    );
  }
}
