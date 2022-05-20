import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project/Screens/homescreen.dart';
import 'package:project/playr.dart';

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
//
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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color.fromARGB(159, 0, 0, 0), Color.fromARGB(255, 0, 0, 0)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    "${item.data![index].artist}",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: const Icon(Icons.more_horiz),
                ),
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
                artworkHeight: 60,
                artworkWidth: 60,
                id: int.parse(myAudio.metas.id!),
                type: ArtworkType.AUDIO,
                artworkBorder: BorderRadius.circular(8),
              ),
              title: Text(
                myAudio.metas.title!,
                style: const TextStyle(color: Color.fromARGB(255, 10, 9, 9)),
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
                      icon: const Icon(
                        Icons.skip_previous_rounded,
                        color: Color.fromARGB(255, 0, 0, 0),
                        size: 43,
                      )),
                  // play pause
                  PlayerBuilder.isPlaying(
                      player: play,
                      builder: (context, isPlaying) {
                        return IconButton(
                          icon: Icon(
                            isPlaying ? Icons.pause_circle : Icons.play_circle,
                            size: 43,
                          ),
                          onPressed: () {
                            play.playOrPause();
                          },
                          color: Colors.black,
                        );
                      }),

                  // next
                  IconButton(
                      iconSize: 45,
                      onPressed: () {
                        play.next();
                      },
                      icon: const Icon(
                        Icons.skip_next_rounded,
                        color: Colors.black,
                        size: 43,
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
