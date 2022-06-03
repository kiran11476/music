import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project/Screens/drawer.dart';
import 'package:project/Screens/homescreen.dart';
import 'package:project/playr.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

List<SongModel> fetchedSong = [];
List<SongModel> allSongs = [];
List<Audio> songs = [];
OnAudioQuery audioquery = OnAudioQuery();
AssetsAudioPlayer player = AssetsAudioPlayer.withId('0');

class _ListScreenState extends State<ListScreen> {
  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }

  @override
  void initState() {
    super.initState();
    requestpermission();
  }

  void requestpermission() async {
    Permission.storage.request();
    OnAudioQuery play = OnAudioQuery();
    fetchedSong = await play.querySongs();

    for (var item in fetchedSong) {
      songs.add(
        Audio.file(
          item.uri.toString(),
          metas: Metas(
            id: item.id.toString(),
            title: item.title,
            artist: item.artist,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      child: Scaffold(
        drawer: const Drag(),
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Library'),
        ),
        body: FutureBuilder<List<SongModel>>(
            future: audioquery.querySongs(
              sortType: null,
              orderType: OrderType.ASC_OR_SMALLER,
              uriType: UriType.EXTERNAL,
              ignoreCase: true,
            ),
            builder: (contex, item) {
              if (item.data == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (item.data!.isEmpty) {
                return const Center(child: Text('No songs found'));
              }
              return ListView.builder(
                itemBuilder: (context, index) => ListTile(
                    onTap: (() {
                      HomeScreen(
                        index: index,
                      );
                      for (var item in allSongs) {
                        songs.add(Audio.file(item.uri.toString(),
                            metas: Metas(id: item.id.toString())));
                      }
                      OpenPlayer(allSongs: songs, index: index)
                          .openAssetPlayer(index: index);
                    }),
                    leading: ArtworkType.AUDIO == null
                        ? const CircleAvatar(
                            backgroundColor: Colors.green,
                          )
                        : QueryArtworkWidget(
                            id: item.data![index].id, type: ArtworkType.AUDIO),
                    title: Text(
                      item.data![index].displayNameWOExt,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 255, 250, 250),
                          fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      "${item.data![index].artist}",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: PopupMenuButton(
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          child: Icon(Icons.favorite_border_outlined),
                          value: 1,
                        ),
                        const PopupMenuItem(
                          child: Icon(Icons.favorite_border_rounded),
                          value: 2,
                        )
                      ],
                    )),
                itemCount: item.data!.length,
              );
            }),
        bottomSheet: play.builderCurrent(
            builder: (BuildContext context, Playing? playing) {
          final myAudio = find(songs, playing!.audio.assetAudioPath);
          return Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(0)),
            child: ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
                // OpenPlayer(allSongs: , index: index)
              },
              tileColor: Colors.white,
              leading: QueryArtworkWidget(
                artworkHeight: 60.h,
                artworkWidth: 60.w,
                id: int.parse(myAudio.metas.id!),
                type: ArtworkType.AUDIO,
                artworkBorder: BorderRadius.circular(8),
              ),
              title: Text(
                myAudio.metas.title!,
                style: const TextStyle(color: Color.fromARGB(255, 10, 9, 9)),
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                myAudio.metas.artist!.toLowerCase(),
                style: const TextStyle(color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  //  previous
                  IconButton(
                      onPressed: () {
                        play.previous();
                      },
                      icon: Icon(
                        Icons.skip_previous_rounded,
                        color: Color.fromARGB(255, 0, 0, 0),
                        size: 43.sp,
                      )),
                  // play pause
                  PlayerBuilder.isPlaying(
                      player: play,
                      builder: (context, isPlaying) {
                        return IconButton(
                          icon: Icon(
                            isPlaying ? Icons.pause_circle : Icons.play_circle,
                            size: 45.sp,
                          ),
                          onPressed: () {
                            play.playOrPause();
                          },
                          color: Colors.black,
                        );
                      }),

                  // next
                  IconButton(
                      iconSize: 45.sp,
                      onPressed: () {
                        play.next();
                      },
                      icon: Icon(
                        Icons.skip_next_rounded,
                        color: Colors.black,
                        size: 43.sp,
                      )),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
