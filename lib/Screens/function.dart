import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final OnAudioRoom _audioRoom = OnAudioRoom();
void dialogbox(
    BuildContext context, int id, int inde, List<SongModel> songmodel) {
  showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (context, setState) {
            return SimpleDialog(
              children: [
                SimpleDialogOption(
                    child: SizedBox(
                  height: 120.h,
                  width: 200.w,
                  child: FutureBuilder<List<PlaylistEntity>>(
                      future: _audioRoom.queryPlaylists(),
                      builder: (context, item) {
                        if (item.data == null || item.data!.isEmpty) {
                          return const Center(
                            child: Text('Nothing Found'),
                          );
                        }

                        return ListView.separated(
                          shrinkWrap: true,
                          itemCount: item.data!.length,
                          itemBuilder: (ctx, index) => GestureDetector(
                              onTap: () async {
                                print(songmodel);
                                _audioRoom.addTo(RoomType.PLAYLIST,
                                    songmodel[inde].getMap.toSongEntity(),
                                    playlistKey: item.data![index].key,
                                    ignoreDuplicate: false);
                                print('added');
                                Navigator.pop(ctx);
                              },
                              child: Center(
                                  child: Text(
                                item.data![index].playlistName,
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w400),
                              ))),
                          separatorBuilder: (ctx, index) => const SizedBox(
                            height: 18,
                          ),
                        );
                      }),
                )),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                      onPressed: () {
                        //           createPlaylistFrom(context, () {
                        //   setState(() {});
                        // });
                        Navigator.pop(context);
                        createPlaylist(context, setState);
                      },
                      child: const Text('Create new playlist')),
                ),
              ],
            );
          }));
}

void createPlaylist(
    BuildContext context, void Function(void Function()) setState) {
  final _formKey = GlobalKey<FormState>();

  final playlistNameController = TextEditingController();
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
            content: Form(
              key: _formKey,
              child: TextFormField(
                  controller: playlistNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    //filled: true,
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    hintText: 'Playlist Name',
                  )),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    createNewPlaylist(playlistNameController.text);
                    Navigator.pop(context);
                    setState(() {});

                    // dialogBox(context);
                  },
                  child: const Text('Ok'))
            ],
          ));
}

void createPlaylistFrom(BuildContext ctx, VoidCallback refresh) {
  final _formKey = GlobalKey<FormState>();
  final playlistNameController = TextEditingController();
  //  final _formKey = GlobalKey<FormState>();
  showDialog(
      barrierDismissible: false,
      context: ctx,
      builder: (ctx1) => Form(
            key: _formKey,
            child: AlertDialog(
              content: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  controller: playlistNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    //filled: true,
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    hintText: 'Playlist Name',
                  )),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: Text('Cancel')),
                TextButton(
                    onPressed: () {
                      // }
                      if (_formKey.currentState!.validate()) {
                        createNewPlaylist(playlistNameController.text);
                        refresh();
                        Navigator.pop(ctx);
                        // dialogBox(context);

                      }
                    },
                    child: Text('Ok'))
              ],
            ),
          ));
}

void createNewPlaylist(String name) {
  final x = _audioRoom.createPlaylist(name);
  print(x);
}
