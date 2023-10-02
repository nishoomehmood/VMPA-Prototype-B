import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:get/get.dart';
import 'package:vpma_test_phase/constants/constants.dart';
import 'package:vpma_test_phase/controller/controller.dart';

class AlbumSongs extends StatelessWidget {
  final List<SongModel>? songs;

  AlbumSongs({this.songs});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());
    return Scaffold(
      appBar: AppBar(
        title: Text('Album Songs'),
      ),
      body: songs != null
          ? ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: songs!.length,
              itemBuilder: (context, index) {
                final song = songs![index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 8), // Adjust padding as needed
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tileColor: bgColor,
                    leading: QueryArtworkWidget(
                      id: song.id,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: const Icon(
                        Icons.music_note,
                        size: 48,
                      ),
                    ),
                    title: Text(
                      song.displayNameWOExt,
                      style: TextStyle(
                        fontSize: 16,
                        color: whiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      _formatDuration(song.duration ?? 0),
                      style: TextStyle(fontSize: 12, color: whiteColor),
                    ),
                    onTap: () {
                      // Get.to(
                      //   () => Player(
                      //     data: songs ?? [],
                      //   ),
                      //   transition: Transition.downToUp,
                      // );
                      controller.playSong(song.uri, index);
                    },
                  ),
                );
              },
            )
          : Center(
              child: Text('No songs available for this album.'),
            ),
    );
  }

  String _formatDuration(int durationMs) {
    Duration duration = Duration(milliseconds: durationMs);
    int minutes = duration.inMinutes;
    int seconds = (duration.inSeconds % 60).toInt();
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
