import 'package:firebase/play_button_notifier.dart';
import 'package:firebase/progress_notifier.dart';
import 'package:flutter/material.dart';
import 'package:firebase/pagemanager.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

class PlayerControl extends StatefulWidget {
  const PlayerControl({super.key});

  @override
  State<PlayerControl> createState() => _PlayerControlState();
}

late final PageManager _pagemanager;

class _PlayerControlState extends State<PlayerControl> {
  @override
  void initState() {
    super.initState();
    _pagemanager = PageManager();
  }

  @override
  void dispose() {
    _pagemanager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('building');
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            CurrentSongTitle(),
            Playlist(),
            AudioProgressBar(),
            AudioControlButtons(),
          ],
        ),
      ),
    );
  }
}

class CurrentSongTitle extends StatelessWidget {
  const CurrentSongTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: _pagemanager.currentSongTitleNotifier,
      builder: (_, title, __) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 40),
          ),
        );
      },
    );
  }
}

class Playlist extends StatelessWidget {
  const Playlist({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ValueListenableBuilder<List<String>>(
          valueListenable: _pagemanager.playlistNotifier,
          builder: (context, playlitTitles, _) {
            return ListView.builder(
                itemCount: playlitTitles.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(playlitTitles[index]),
                  );
                });
          }),
    );
  }
}

class AudioProgressBar extends StatelessWidget {
  const AudioProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ProgressBarState>(
      valueListenable: _pagemanager.progressNotifier,
      builder: (_, value, __) {
        return ProgressBar(
          progress: value.current,
          buffered: value.buffered,
          total: value.total,
          onSeek: _pagemanager.seek,
        );
      },
    );
  }
}

class AudioControlButtons extends StatelessWidget {
  const AudioControlButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          PreviousSongButton(),
          PlayButton(),
          NextSongButton(),
        ],
      ),
    );
  }
}

class PreviousSongButton extends StatelessWidget {
  const PreviousSongButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _pagemanager.isFirstSongNotifier,
      builder: (_, isFirst, __) {
        return IconButton(
          icon: const Icon(Icons.skip_previous),
          onPressed:
              (isFirst) ? null : _pagemanager.onPreviousSongButtonPressed,
        );
      },
    );
  }
}

class PlayButton extends StatelessWidget {
  const PlayButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ButtonState>(
      valueListenable: _pagemanager.playButtonNotifier,
      builder: (_, value, __) {
        switch (value) {
          case ButtonState.loading:
            return Container(
              margin: const EdgeInsets.all(8.0),
              width: 32,
              height: 32,
              child: const CircularProgressIndicator(),
            );
          case ButtonState.paused:
            return IconButton(
              onPressed: _pagemanager.play,
              icon: const Icon(Icons.play_arrow),
              iconSize: 32,
            );
          case ButtonState.playing:
            return IconButton(
              onPressed: _pagemanager.pause,
              icon: const Icon(Icons.pause),
              iconSize: 32,
            );
        }
      },
    );
  }
}

class NextSongButton extends StatelessWidget {
  const NextSongButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _pagemanager.isLastSongNotifier,
      builder: (_, isLast, __) {
        return IconButton(
          icon: const Icon(
            Icons.skip_next,
          ),
          onPressed: (isLast) ? null : _pagemanager.onNextSongButtonPressed,
        );
      },
    );
  }
}
