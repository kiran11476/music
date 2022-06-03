import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';
import 'package:project/Screens/controller.dart';
import 'package:project/Screens/homescreen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlaylistInfo extends StatefulWidget {
  int playlistKey;
  List<SongEntity> songs;
  String title;
  PlaylistInfo(
      {Key? key,
      required this.title,
      required this.songs,
      required this.playlistKey})
      : super(key: key);

  @override
  State<PlaylistInfo> createState() => _PlaylistInfoState();
}

class _PlaylistInfoState extends State<PlaylistInfo> {
  final OnAudioRoom _audioRoom = OnAudioRoom();
  @override
  Widget build(BuildContext context) {
    List<Audio> playlistSong = [];
    for (var song in widget.songs) {
      playlistSong.add(Audio.file(song.lastData,
          metas: Metas(
              title: song.title, artist: song.artist, id: song.id.toString())));
    }
    return Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Text(widget.title),
        ),
        body: playlistSong.isEmpty
            ? const Center(
                child: Text(
                  'Nothing Found',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : ListView.separated(
                separatorBuilder: (context, index) => SizedBox(
                  height: 1.h,
                ),
                itemBuilder: (ctx, index) => Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(186, 255, 255, 255),
                    ),
                    child: ListTile(
                      onTap: () {
                        plays(playlistSong, index);
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (ctx) => HomeScreen()));
                      },
                      title: Text(
                        widget.songs[index].title,
                        style: const TextStyle(color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(widget.songs[index].artist!,
                          style: const TextStyle(
                              color: Colors.black,
                              overflow: TextOverflow.ellipsis)),
                      leading: QueryArtworkWidget(
                        id: widget.songs[index].id,
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget: const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Icon(
                            Icons.music_note,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                      trailing: PopupMenuButton(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                        ),
                        color: Colors.blue, elevation: 30,
                        icon: const Icon(Icons
                            .more_vert_outlined), //don't specify icon if you want 3 dot menu

                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 0,
                            child: Text(
                              "Delete song",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                        onSelected: (item) => {
                          if (item == 0)
                            {
                              setState(() {
                                _audioRoom.deleteFrom(
                                    RoomType.PLAYLIST, widget.songs[index].id,
                                    playlistKey: widget.playlistKey);
                              })
                            }
                        },
                      ),
                    ),
                  ),
                ),
                itemCount: widget.songs.length,
              ));
  }
}
