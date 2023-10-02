import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vpma_test_phase/constants/constants.dart';
import 'package:vpma_test_phase/constants/text_style.dart';
import 'package:vpma_test_phase/controller/controller.dart';

class MusicList extends StatelessWidget {
  final RxList<SongModel> songs;
  final RxString searchQuery;
  final PlayerController controller;
  MusicList({
    Key? key,
    required this.songs,
    required this.searchQuery,
    required this.controller,
  });

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
      backgroundColor: Color.fromARGB(255, 101, 136, 96).withOpacity(0.6),
      body: Obx(() {
        final filteredSongs = controller.filteredSongs;

        // You can adjust the condition here to control when to show the filtered list
        if (filteredSongs.isEmpty && controller.searchQuery.isEmpty) {
          // Display all songs when there is no search query
          return buildAllSongsList(controller.songs);
        } else if (filteredSongs.isEmpty) {
          // Display "No Song Found" when the search query doesn't match any songs
          return Center(
            child: Text(
              "No Song Found",
              style: ourStyle(),
            ),
          );
        } else {
          // Display the filtered list
          return buildAllSongsList(filteredSongs);
        }
      }),
    );
  }

  Widget buildAllSongsList(List<SongModel> songs) {
    final controller = Get.put(PlayerController());
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: songs.length,
      itemBuilder: (BuildContext context, int index) {
        SongModel song = songs[index];

        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: QueryArtworkWidget(
                        id: song.id,
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget: const Icon(
                          Icons.music_note,
                          color: white,
                          size: 32,
                        ),
                      ),
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: primaryText28),
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.displayName,
                      maxLines: 1,
                      style: TextStyle(
                          color: TColor.primaryText60,
                          fontSize: 13,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      _formatDuration(song.duration ?? 0),
                      maxLines: 1,
                      style:
                          const TextStyle(color: primaryText28, fontSize: 10),
                    )
                  ],
                )),
                IconButton(
                  onPressed: () {},
                  icon: Image.asset(
                    "assets/images/play_btn.png",
                    width: 25,
                    height: 25,
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.white.withOpacity(0.07),
              indent: 50,
            ),
          ],
        );
      },
    );
  }
}
