import 'package:firebase/play_button_notifier.dart';
import 'package:firebase/progress_notifier.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PageManager {
  final currentSongTitleNotifier = ValueNotifier<String>('');
  final playlistNotifier = ValueNotifier<List<String>>([]);
  final progressNotifier = ProgressNotifier();
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final playButtonNotifier = PlayButtonNotifier();
  final isLastSongNotifier = ValueNotifier<bool>(true);
  late AudioPlayer _audioPlayer;
  // late String url;
  PageManager() {
    _init();
  }

  void _init() async {
    _audioPlayer = AudioPlayer();
  }

  void songs(Map<String, dynamic> song) async {
    //  QuerySnapshot data = await FirebaseFirestore.instance.collection('songs').get();
    // _audioPlayer = audioPlayer;
    _setInitialPlaylist(song['url']);
    _listenForChangesInPlayerState();
    _listenForChangesInPlayerPosition();
    _listenForChangesInBufferedPosition();
    _listenForChangesInTotalDuration();
    _listenForChangesInSequenceState();
  }

  void _setInitialPlaylist(String url) async {
    await _audioPlayer.setUrl(url);
    print(url);
  }

  void _listenForChangesInPlayerState() {
    _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        playButtonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        playButtonNotifier.value = ButtonState.paused;
      } else if (processingState != ProcessingState.completed) {
        playButtonNotifier.value = ButtonState.playing;
      } else {
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.pause();
      }
    });
  }

  void _listenForChangesInPlayerPosition() {
    _audioPlayer.positionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });
  }

  void _listenForChangesInBufferedPosition() {
    _audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });
  }

  void _listenForChangesInTotalDuration() {
    _audioPlayer.durationStream.listen((totalDuration) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });
  }

  void _listenForChangesInSequenceState() {
    // TODO
  }

  void play() async {
    _audioPlayer.play();
    print('playing');
  }

  void pause() {
    _audioPlayer.pause();
    print('pause');
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  void dispose() {
    _audioPlayer.dispose();
  }

  void onRepeatButtonPressed() {
    // TODO
  }

  void onPreviousSongButtonPressed() {
    // TODO
  }

  void onNextSongButtonPressed() {
    // TODO
  }

  void onShuffleButtonPressed() async {
    // TODO
  }

  void addSong() {
    // TODO
  }

  void removeSong() {
    // TODO
  }
}
