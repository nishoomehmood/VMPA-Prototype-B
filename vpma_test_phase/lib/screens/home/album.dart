import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:get/get.dart';
import 'package:vpma_test_phase/controller/controller.dart';
import 'package:vpma_test_phase/screens/home/albumSongs.dart';

class Albums extends StatelessWidget {
  final PlayerController controller;
  final RxString searchQuery; // Add this line
  const Albums(
      {Key? key,
      required this.controller,
      required this.searchQuery}); // Modify the constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 48, 77, 66),
      body: Obx(() {
        final filteredAlbums = controller.filteredAlbums; // Add this line

        // You can adjust the condition here to control when to show the filtered list
        if (filteredAlbums.isEmpty && searchQuery.isEmpty) {
          // Display all albums when there is no search query
          return buildAllAlbumsList(controller.albums);
        } else if (filteredAlbums.isEmpty) {
          // Display "No Album Found" when the search query doesn't match any albums
          return const Center(
            child: Text(
              "No Album Found",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          );
        } else {
          // Display the filtered list
          return buildAllAlbumsList(filteredAlbums);
        }
      }),
    );
  }

  Widget buildAllAlbumsList(List<AlbumModel> albums) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: albums.length,
      itemBuilder: (BuildContext context, int index) {
        final album = albums[index];

        return ListTile(
          tileColor: Color.fromARGB(255, 58, 99, 73),
          leading: QueryArtworkWidget(
            id: album.id,
            type: ArtworkType.ALBUM,
            nullArtworkWidget: const Icon(
              Icons.album,
              color: Colors.white,
              size: 48,
            ),
          ),
          title: Text(
            album.album,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            '${album.numOfSongs} Songs - ${album.artist}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
          onTap: () async {
            final songs = await controller.fetchSongsInAlbum(album.id);

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AlbumSongs(songs: songs),
              ),
            );

            // Handle album item tap here
            // Example: controller.playAlbum(album.id);
          },
        );
      },
    );
  }
}
