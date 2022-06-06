import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavScreen extends StatefulWidget {
  const FavScreen({Key? key}) : super(key: key);

  @override
  State<FavScreen> createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  int? key;

  @override
  Widget build(BuildContext context) {
    final OnAudioRoom _audioroom = OnAudioRoom();
    List<FavoritesEntity>? favoriteSongs = [];
    final OnAudioRoom _audioRoom = OnAudioRoom();
    return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(color: Color.fromARGB(255, 3, 3, 3)),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text('Favorites'),
              backgroundColor: Colors.black,
            ),
            body: FutureBuilder(
              builder: (context, item) {
                if (item.data == null) {
                  return const Center(
                      child: Text(
                    'No songs',
                    style: TextStyle(color: Colors.white),
                  ));
                }

                favoriteSongs = item.data as List<FavoritesEntity>?;

                return ListView.builder(
                    itemCount: favoriteSongs!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: QueryArtworkWidget(
                            id: favoriteSongs![index].id,
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: Padding(
                              padding: EdgeInsets.only(top: 5.h),
                            )),
                        title: Text(
                          favoriteSongs![index].title,
                          style: const TextStyle(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          favoriteSongs![index].album.toString(),
                          style: const TextStyle(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: PopupMenuButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              const Radius.circular(20.0).r,
                            ),
                          ),
                          color: const Color.fromARGB(255, 233, 235, 237),
                          elevation: 30.r,
                          icon: const Icon(
                            Icons.more_vert_outlined,
                            color: Color.fromARGB(255, 246, 246, 246),
                          ), //don't specify icon if you want 3 dot menu
                          // color: Colors.blue,
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 0,
                              child: Text(
                                "Remove from Favorites",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0)),
                              ),
                            ),
                          ],
                          onSelected: (item) => {
                            if (item == 0)
                              {
                                setState(() {
                                  _audioRoom.deleteFrom(RoomType.FAVORITES,
                                      favoriteSongs![index].key);
                                  Fluttertoast.showToast(
                                      msg: "Deleted from favorites",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.SNACKBAR,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: const Color.fromARGB(
                                          255, 174, 27, 16),
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                })
                              }
                          },
                        ),
                      );
                    });
              },
              future: _audioroom.queryFavorites(),
            )));
  }
}
