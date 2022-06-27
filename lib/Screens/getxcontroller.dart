import 'package:get/get.dart';
import 'package:on_audio_room/on_audio_room.dart';

class RenamePlayListcontoller extends GetxController {
  final OnAudioRoom _audioRoom = OnAudioRoom();

  void renamePlaylist(key, dynamic playlistNameController) {
    _audioRoom.renamePlaylist(key, playlistNameController.text);

    update();
  }

  void deletePlaylis(item, index) {
    _audioRoom.deletePlaylist(item.data![index].key);
    update();
  }

  void playListDelete(playlistKey, songs, index) {
    _audioRoom.deleteFrom(RoomType.PLAYLIST, songs[index].id,
        playlistKey: playlistKey);
    update();
  }
}
