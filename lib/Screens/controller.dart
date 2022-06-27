import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:on_audio_room/on_audio_room.dart';

final assetsAudioPlayer = AssetsAudioPlayer();
void plays(List<Audio> audio, int index) {
  //int index = ind == null ? 0 : ind;
  assetsAudioPlayer.open(Playlist(audios: audio, startIndex: index),
      notificationSettings: const NotificationSettings(stopEnabled: false));
}
