import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';

import 'function.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:project/Screens/library.dart';
import 'package:on_audio_room/on_audio_room.dart';

class HomeScreen extends StatefulWidget {
  int? index;
  List<SongModel> fullsongs = [];
  List<SongModel>? songModel2;

  HomeScreen({Key? key, this.index})
      : super(
          key: key,
        );

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

AssetsAudioPlayer play = AssetsAudioPlayer.withId('0');

class _HomeScreenState extends State<HomeScreen> {
  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }

  final OnAudioRoom _audioRoom = OnAudioRoom();
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> songmodel = [];

  bool isFav = false;
  @override
  Widget build(BuildContext context) {
    List<SongModel> songmodel = [];
    if (widget.songModel2 == null) {
      _audioQuery.querySongs().then((value) {
        songmodel = value;
      });
    } else {
      songmodel = widget.songModel2!;
    }
    _audioQuery.querySongs().then((value) {
      widget.fullsongs = value;
    });

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(213, 0, 0, 0),
          title: const Text('Music Player'),
          centerTitle: true,
        ),
        body: play.builderCurrent(
            builder: (BuildContext context, Playing? playing) {
          final myAudio = find(songs, playing!.audio.assetAudioPath);

          int? key;

          return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(177, 0, 0, 0),
                    Color.fromARGB(255, 0, 0, 0)
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.white, width: 4)),
                          child: QueryArtworkWidget(
                            artworkHeight: 60,
                            artworkWidth: 60,
                            id: int.parse(myAudio.metas.id!),
                            type: ArtworkType.AUDIO,
                            artworkBorder: BorderRadius.circular(8),
                          ),
                          width: 350,
                          height: 400,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    const SizedBox(
                      height: 40.0,
                    ),
                    play.builderRealtimePlayingInfos(
                        builder: (context, RealtimePlayingInfos infos) {
                      return ProgressBar(
                        timeLabelTextStyle: const TextStyle(
                            color: Color.fromARGB(255, 230, 230, 230)),
                        timeLabelType: TimeLabelType.remainingTime,
                        baseBarColor: const Color.fromARGB(255, 240, 235, 235),
                        progressBarColor:
                            const Color.fromARGB(122, 26, 90, 154),
                        thumbColor: Colors.blue,
                        barHeight: 4,
                        thumbRadius: 8,
                        progress: infos.currentPosition,
                        total: infos.duration,
                        onSeek: (slide) {
                          play.seek(slide);
                        },
                      );
                    }),
                    const SizedBox(
                      height: 20,
                    ),

                    //     }),
                    Container(
                      height: 120,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () async {
                              if (isFav != true) {
                                _audioRoom.addTo(
                                    RoomType.FAVORITES,
                                    widget.fullsongs[playing.index].getMap
                                        .toFavoritesEntity(),
                                    ignoreDuplicate: false);
                              } else {
                                _audioRoom.deleteFrom(RoomType.FAVORITES, key!);
                              }
                            },
                            icon: Icon(
                              isFav
                                  ? Icons.favorite_border_outlined
                                  : Icons.favorite,
                              size: 30,
                              color: Colors.red,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              play.previous();
                            },
                            icon: const Icon(
                              Icons.skip_previous,
                              size: 40,
                              color: Color.fromARGB(255, 3, 2, 2),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 25.0),
                            child: IconButton(
                              onPressed: () {},
                              icon: PlayerBuilder.isPlaying(
                                  player: play,
                                  builder: (context, isPlaying) {
                                    return IconButton(
                                      onPressed: () {
                                        play.playOrPause();
                                      },
                                      icon: Icon(isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow),
                                      iconSize: 40,
                                    );
                                  }),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                play.next();
                              },
                              icon: const Icon(
                                Icons.skip_next,
                                size: 40.0,
                                color: Color.fromARGB(255, 12, 12, 12),
                              )),
                          IconButton(
                            onPressed: () async {
                              dialogbox(
                                  context,
                                  int.parse(playing.playlist.current.metas.id!),
                                  playing.playlist.currentIndex,
                                  songmodel);
                              // dialogBox(
                              //     context,
                              //     int.parse(playing.playlist.current.metas.id!),
                              //     playing.playlist.currentIndex,
                              //     songmodel);
                            },
                            icon: const Icon(
                              Icons.playlist_add,
                              size: 40.0,
                              color: Color.fromARGB(255, 12, 12, 12),
                            ),
                          ),
                        ],
                      ),
                      color: Colors.white,
                    ),
                    const SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0),
                        )
                        // color: Colors.white,
                        ),
                  ],
                ),
              ));
        }));
  }
}
