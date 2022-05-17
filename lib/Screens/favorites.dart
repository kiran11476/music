import 'package:flutter/material.dart';

class FavScreen extends StatelessWidget {
  const FavScreen({Key? key}) : super(key: key);

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
        appBar: AppBar(
          title: const Text('Favorites'),
          backgroundColor: Colors.black,
        ),
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
                    child: const ListTile(
                      title:
                          Text('music', style: TextStyle(color: Colors.white)),
                      subtitle: Text('Sushin shyam',style: TextStyle(color: Colors.white),),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://m.media-amazon.com/images/M/MV5BMWEwNjhkYzYtNjgzYy00YTY2LThjYWYtYzViMGJkZTI4Y2MyXkEyXkFqcGdeQXVyNTM0OTY1OQ@@._V1_FMjpg_UX1000_.jpg'),
                        radius: 30,
                        backgroundColor: Colors.green,
                      ),
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
