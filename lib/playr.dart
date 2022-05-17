
import 'package:assets_audio_player/assets_audio_player.dart';

class OpenPlayer {
  List<Audio> allSongs;
  int index;
  bool? notify;

  OpenPlayer({required this.allSongs, required this.index});

  final AssetsAudioPlayer player = AssetsAudioPlayer.withId('0');

  openAssetPlayer({List<Audio>? song, required int index}) async {
    player.open(
      Playlist(audios: allSongs, startIndex: index),
      showNotification: notify == null || notify == true ? true : false,
      notificationSettings: const NotificationSettings(
        stopEnabled: false,
      ),
      autoStart: true,
      loopMode: LoopMode.playlist,
      headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
      playInBackground: PlayInBackground.enabled,
    );
  }
}