import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'package:get/get.dart';
import 'package:vpma_test_phase/constants/constants.dart';
import 'package:vpma_test_phase/controller/controller.dart';

class ArtistSongs extends StatelessWidget {
  final List<SongModel>? songs;
  final String? artistName;
  final PlayerController controller;

  ArtistSongs({this.songs, this.artistName, required this.controller});

  // In your widget where you handle tapping to mark a song as favorite
 

  String _formatDuration(int durationMs) {
    Duration duration = Duration(milliseconds: durationMs);
    int minutes = duration.inMinutes;
    int seconds = (duration.inSeconds % 60).toInt();
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PlayerController());
    return Scaffold(
      appBar: AppBar(
        title: Text('Songs by $artistName'),
      ),
      body: songs != null
          ? ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: songs!.length,
              itemBuilder: (context, index) {
                final song = songs![index];
                bool isFavorite = controller
                    .isFavorite(song); // Check if the song is a favorite
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
                      style: const TextStyle(
                        fontSize: 16,
                        color: whiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      _formatDuration(song.duration ?? 0),
                      style: const TextStyle(fontSize: 12, color: whiteColor),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            controller.handleFavoriteTap(song);
                          },
                          icon: Obx(
                            () => Icon(
                              controller.isFavorite(song)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: controller.isFavorite(song)
                                  ? Colors.red
                                  : whiteColor,
                              size: 26,
                            ),
                          ),
                        ),
                      ],
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
              child: Text('No songs available for this artist.'),
            ),
    );
  }
}

String _formatDuration(int durationMs) {
  Duration duration = Duration(milliseconds: durationMs);
  int minutes = duration.inMinutes;
  int seconds = (duration.inSeconds % 60).toInt();
  return '$minutes:${seconds.toString().padLeft(2, '0')}';
}
