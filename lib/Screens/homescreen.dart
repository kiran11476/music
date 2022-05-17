import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:project/Screens/drawer.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:project/Screens/library.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

AssetsAudioPlayer play = AssetsAudioPlayer.withId('0');

class _HomeScreenState extends State<HomeScreen> {
  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }

  double _currentSliderValue = 20;
  int _currentSelectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const Drag(),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(213, 0, 0, 0),
          title: const Text('Music Player'),
          centerTitle: true,
        ),
        body: play.builderCurrent(
            builder: (BuildContext context, Playing? playing) {
          final myAudio = find(songs, playing!.audio.assetAudioPath);
          return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(159, 0, 0, 0),
                    Color.fromARGB(255, 0, 0, 0)
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Center(
                        child: SizedBox(
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
                      height: 10.0,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: Text(
                          myAudio.metas.title!,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 22.0),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Slider(
                        thumbColor: const Color.fromARGB(231, 255, 255, 255),
                        activeColor: const Color.fromARGB(138, 255, 255, 255),
                        value: _currentSliderValue,
                        max: 100,
                        onChanged: (double value) {
                          setState(() {
                            _currentSliderValue = value;
                          });
                        }),
                    Container(
                      height: 120,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.favorite),
                            color: Colors.red,
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
                                      iconSize: 50,
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
