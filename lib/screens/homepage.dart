import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/consts/colors.dart';
import 'package:firebase/consts/style.dart';
import 'package:firebase/pagemanager.dart';
import 'package:firebase/playerController.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class Homepage extends StatelessWidget {
  Homepage({super.key});
  final String title = 'Firebase';
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDarkColor,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                // color: bgColors,
              ))
        ],
        leading: InkWell(
          onTap: () {},
          child: const Icon(
            Icons.sort_rounded,
            // color: bgColors,
          ),
        ),
        title: Text(
          title,
          style: style(
            family: 'Young',
            size: 18,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('songs').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> songs = snapshot.data!.docs[index].data();

                return Padding(
                  padding: const EdgeInsets.fromLTRB(6, 1, 6, 1),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: bgColors),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PlayerControl()));
                      },
                      title: Text(
                        songs['title'],
                        style: style(family: 'Young'),
                      ),
                      subtitle: Text(
                        songs['artist'],
                        style: style(
                          family: 'Young',
                          size: 10,
                        ),
                      ),
                      leading: const Icon(
                        Icons.music_note,
                        color: whiteColor,
                      ),
                      trailing: const Icon(
                        Icons.play_arrow,
                        color: whiteColor,
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(
            child: Text("Something went wrong"),
          );
        },
      ),
    );
  }
}
