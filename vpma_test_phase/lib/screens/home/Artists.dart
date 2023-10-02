import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:get/get.dart';
import 'package:vpma_test_phase/controller/controller.dart';

import 'ArtistSongs.dart';

class Artists extends StatelessWidget {
  final PlayerController controller;
  final RxString searchQuery;
  const Artists(
      {Key? key, required this.controller, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    // Call the fetchArtists function to fetch artists
    controller.fetchArtists();

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 48, 77, 62),
      body: Obx(() {
        final filteredArtists = controller.filteredArtists;

        // Debug print statements
        print('Filtered Artists: $filteredArtists');
        print('Search Query: ${searchQuery.value}');

        if (filteredArtists.isEmpty && searchQuery.isEmpty) {
          // Display all artists when there is no search query
          return buildAllArtistsList(controller.artists);
        } else if (filteredArtists.isEmpty) {
          // Display "No Artist Found" when the search query doesn't match any artists
          return Center(
            child: Text(
              "No Artist Found",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          );
        } else {
          // Display the filtered list
          return buildAllArtistsList(filteredArtists);
        }
      }),
    );
  }

  // Rest of your code...

  Widget buildAllArtistsList(List<ArtistModel> artists) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: artists.length,
      itemBuilder: (BuildContext context, int index) {
        final artist = artists[index];

        // You can customize the UI for each artist item here
        return ListTile(
          tileColor: Color.fromARGB(255, 48, 77, 59),
          leading: QueryArtworkWidget(
            id: artist.id,
            type: ArtworkType.ARTIST,
            nullArtworkWidget: const Icon(
              Icons.person,
              color: Colors.white,
              size: 48,
            ),
          ),
          title: Text(
            '${artist.artist}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            '${artist.numberOfTracks} Songs',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
          onTap: () async {
            final songs = await controller.fetchSongsByArtist(artist.artist);

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ArtistSongs(
                    songs: songs,
                    artistName: artist.artist,
                    controller: controller),
              ),
            );

            // Handle artist item tap here
            // Example: controller.playSongsByArtist(artist.name);
          },
        );
      },
    );
  }
}
