import 'package:flutter/material.dart';

import 'package:on_audio_room/on_audio_room.dart';
import 'package:project/Screens/function.dart';
import 'package:project/Screens/playlistinfo.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({Key? key}) : super(key: key);

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  final OnAudioRoom _audioRoom = OnAudioRoom();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color.fromARGB(41, 0, 0, 0), Color.fromARGB(255, 0, 0, 0)],
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Playlist'),
            backgroundColor: Colors.black,
            actions: [
              IconButton(
                  onPressed: () {
                    createPlaylistFrom(context, () {
                      setState(() {});
                    });
                  },
                  icon: const Icon(Icons.playlist_add))
            ],
          ),
          body: FutureBuilder<List<PlaylistEntity>>(
              future: _audioRoom.queryPlaylists(),
              builder: (context, item) {
                if (item.data == null) {
                  return const Center(
                    child: Text(
                      'Nothing Found',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                return ListView.separated(
                    itemBuilder: (ctx, index) => ListTile(
                          trailing: PopupMenuButton(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20.0),
                              ),
                            ),
                            color: const Color.fromARGB(255, 27, 27, 31),
                            elevation: 50,
                            icon: const Icon(
                              Icons.more_vert_outlined,
                              color: Colors.white,
                            ),
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 0,
                                child: Text(
                                  "Remove playlist",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              const PopupMenuItem(
                                value: 1,
                                child: Text(
                                  "Rename",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                            onSelected: (item1) => {
                              if (item1 == 0)
                                {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Remove playlist"),
                                        content: const Text(
                                            "Would you like to delete the  playlist?"),
                                        actions: [
                                          TextButton(
                                            child: Text("Cancel"),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          TextButton(
                                            child: Text("Continue"),
                                            onPressed: () {
                                              setState(() {
                                                _audioRoom.deletePlaylist(
                                                    item.data![index].key);
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                },
                              if (item1 == 1)
                                {
                                  dialog(
                                      context,
                                      item.data![index].key,
                                      // playlistNameController.text
                                      item.data![index].playlistName)
                                }
                            },
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => PlaylistInfo(
                                          title: item.data![index].playlistName,
                                          songs:
                                              item.data![index].playlistSongs,
                                          playlistKey: item.data![index].key,
                                        )));
                          },
                          contentPadding: const EdgeInsets.only(left: 20),
                          title: Text(
                            item.data![index].playlistName,
                            style: const TextStyle(color: Colors.white),
                          ),
                          leading: const Icon(
                            Icons.playlist_add,
                            color: Color.fromARGB(255, 199, 201, 205),
                          ),
                        ),
                    separatorBuilder: (ctx, index) => Divider(),
                    itemCount: item.data!.length);
              })),
    );
  }

  void dialog(BuildContext context, int key, String str) {
    final playlistNameController = TextEditingController(text: str);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx1) => AlertDialog(
              content: TextFormField(
                  controller: playlistNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    //filled: true,
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    hintText: str,
                  )),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(ctx1);
                    },
                    child: Text('Cancel')),
                TextButton(
                    onPressed: () {
                      setState(() {
                        _audioRoom.renamePlaylist(
                            key, playlistNameController.text);
                      });
                      Navigator.pop(ctx1);
                    },
                    child: Text('Ok'))
              ],
            ));
  }
}
