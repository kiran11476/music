import 'package:flutter/material.dart';

class PlayScreen extends StatelessWidget {
  const PlayScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 53, 85, 53),
            Color.fromARGB(255, 75, 71, 71)
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('Playlist'),
        backgroundColor: Colors.black,),
        body: SafeArea(
          child: SafeArea(
            child: ListView.separated(
              itemCount: 4,
              separatorBuilder: (ctx, index) {
                return const Divider();
              },
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(),
                  child: Container(
                    decoration: const BoxDecoration(),
                    child: ListTile(
                      title:
                          Text('Playlist $index', style: const TextStyle(color: Colors.white)),
                      subtitle: const Text('Sushin shyam',style: TextStyle(color: Colors.white),),
                      leading: const Icon(Icons.playlist_add,size: 50.0,color: Colors.white,),
                    ),
                  ),
                );
              },
            ),
          ),
      ),
      ),
      
      
    );
  }
}