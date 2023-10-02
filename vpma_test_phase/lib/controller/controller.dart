import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayerController extends GetxController {
  final audioQuery = OnAudioQuery();
  final audioPlayer = AudioPlayer();
  TextEditingController playlistController = TextEditingController();

  var playIndex = 0.obs;
  var isPlaying = false.obs;

  var duration = ''.obs;
  var position = ''.obs;

  var min = 0.0.obs;
  var max = 0.0.obs;
  var value = 0.0.obs;

  // var isFavorite = false.obs;

  final RxString searchQuery = "".obs;
  final RxList<SongModel> filteredSongs = <SongModel>[].obs;
  final RxList<SongModel> songs = <SongModel>[].obs;

  final RxList<SongModel> favoriteSongs = <SongModel>[].obs;

  final RxList<AlbumModel> filteredAlbums = <AlbumModel>[].obs;
  final RxList<AlbumModel> albums1 = <AlbumModel>[].obs;

  List<AlbumModel> albums = [];

  final RxList<ArtistModel> filteredArtists =
      <ArtistModel>[].obs; // Add this line
  final RxList<ArtistModel> artists1 = <ArtistModel>[].obs;

  List<ArtistModel> artists = [];
  final List<Playlist> playlists = [];

  final Map<String, int> playlistIdMap = {};
  Map<String, int> numberOfSongsMap = {};
  //  final RxList<PlaylistModel> playlists = <PlaylistModel>[].obs;
  // final SharedPreferences prefs;
  @override
  void onInit() {
    super.onInit();

    checkPermission();
    fetchAlbums();
    fetchSongs();
    ever(searchQuery, (_) {
      filterSongs(songs);
      filterAlbums(albums);
      filterArtists(artists); // Add this line
    });
  }

  // // Example code to add a song to a playlist
  // Future<void> addSongToPlaylist(String playlistName, SongModel song) async {
  //   final audioQuery = OnAudioQuery(); // Initialize your audio query instance

  void filterArtists(List<ArtistModel> artistsToFilter) {
    print('Filtering artists...');
    final query = searchQuery.value.toLowerCase();
    final filtered = artistsToFilter.where((artist) {
      final artistName = artist.artist.toLowerCase();
      return artistName.contains(query);
    }).toList();
    filtered.forEach((artist) {
      print('Artist name: ${artist.artist}');
    });
    filteredArtists.assignAll(filtered);
  }

  void filterAlbums(List<AlbumModel> albumsToFilter) {
    print('Filtering albums...');
    final query = searchQuery.value.toLowerCase();
    final filtered = albumsToFilter.where((album) {
      final albumName = album.album.toLowerCase();
      final artist = album.artist?.toLowerCase() ?? '';
      return albumName.contains(query) || artist.contains(query);
    }).toList();
    filtered.forEach((album) {
      print('Album name: ${album.album}');
    });
    filteredAlbums.assignAll(filtered);
  }

  Future<List<AlbumModel>> fetchAlbums() async {
    albums.assignAll(await audioQuery.queryAlbums());
    return albums;
  }

  void filterSongs(List<SongModel> songsToFilter) {
    print('Filtering songs...');
    final query = searchQuery.value.toLowerCase();
    final filtered = songsToFilter.where((song) {
      final title = song.title.toLowerCase();
      final artist = song.artist?.toLowerCase() ?? '';
      final album = song.album?.toLowerCase() ?? '';
      return title.contains(query) ||
          artist.contains(query) ||
          album.contains(query);
    }).toList();
    filtered.forEach((song) {
      print('Song title: ${song.title}');
    });
    filteredSongs.assignAll(filtered);
  }

  void handleFavoriteTap(SongModel song) {
    if (isFavorite(song)) {
      removeFromFavorites(song);
    } else {
      addToFavorites(song);
    }
  }

  // Function to add a song to favorites
  void addToFavorites(SongModel song) {
    if (!favoriteSongs.contains(song)) {
      favoriteSongs.add(song);
    }
  }

  // Function to remove a song from favorites
  void removeFromFavorites(SongModel song) {
    if (favoriteSongs.contains(song)) {
      favoriteSongs.remove(song);
    }
  }

  // Function to check if a song is a favorite
  bool isFavorite(SongModel song) {
    return favoriteSongs.contains(song);
  }

  Future<List<ArtistModel>> fetchArtists() async {
    artists.assignAll(await audioQuery.queryArtists());
    return artists;
  }

  Future<List<SongModel>> fetchSongsByArtist(String artistName) async {
    final allSongs = await audioQuery.querySongs(
      ignoreCase: true,
      orderType: OrderType.ASC_OR_SMALLER, // You can adjust the sorting order
      sortType: SongSortType.ARTIST, // Sort by artist
      uriType: UriType.EXTERNAL,
    );

    // Filter songs by the specified artist
    final songsByArtist = allSongs.where((song) {
      final artist = song.artist?.toLowerCase() ?? '';
      return artist.contains(artistName.toLowerCase());
    }).toList();

    return songsByArtist;
  }

  Future<void> fetchSongs() async {
    songs.assignAll(await audioQuery.querySongs(
      ignoreCase: true,
      orderType: OrderType.ASC_OR_SMALLER,
      sortType: null,
      uriType: UriType.EXTERNAL,
    ));
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    print('Search query updated: $query');
  }

  // Function to fetch songs for an album
  Future<List<SongModel>> fetchSongsInAlbum(int albumId) async {
    final allSongs = await audioQuery.querySongs();
    final songsInAlbum =
    allSongs.where((song) => song.albumId == albumId).toList();
    return songsInAlbum;
  }

  // Function to refresh the playlist data
  Future<void> refreshPlaylists() async {
    final playlists = await audioQuery.queryPlaylists();
    // Update the playlists data in your controller
    // For example, you can use an RxList:
    playlists.assignAll(playlists);
  }

  updatePosition() {
    audioPlayer.durationStream.listen((p) {
      position.value = p.toString().split(".")[0];
      value.value = p!.inSeconds.toDouble();
    });
    audioPlayer.durationStream.listen((d) {
      duration.value = d.toString().split(".")[0];
      max.value = d!.inSeconds.toDouble();
    });
  }

  changeDurationToSeconds(seconds) {
    var duration = Duration(seconds: seconds);
    audioPlayer.seek(duration);
  }

  playSong(String? uri, index) {
    playIndex.value = index;
    try {
      audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      audioPlayer.play();
      isPlaying(true);
      updatePosition();
    } on Exception catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  checkPermission() async {
    var perm = await Permission.storage.request();
    if (perm.isGranted) {
      return audioQuery.querySongs(
          ignoreCase: true,
          orderType: OrderType.ASC_OR_SMALLER,
          sortType: null,
          uriType: UriType.EXTERNAL);
    } else {
      return checkPermission();
    }
  }

  // Function to add a song to a playlist
  void addSongToPlaylist(String playlistId, SongModel song) {
    // final controller = Get.find<PlayerController>();
    // // audioQuery.addToPlaylist(playlistId, song)
    final playlist = playlists.firstWhere((pl) => pl.id == playlistId);

    if (playlist != null) {
      playlist.songs.add(song);

      print('ADDEDD $song');

      // // Update the song count in SharedPreferences
      // final sharedPreferences = Get.find<SharedPreferences>();
      // final numberOfSongsKey = '${playlist.name}-songs';
      // final numberOfSongs = sharedPreferences.getInt(numberOfSongsKey) ?? 0;
      // sharedPreferences.setInt(numberOfSongsKey, numberOfSongs + 1);
      //
      savePlaylistsToSharedPreferences(); // Save the updated playlist to SharedPreferences
      updateNumberOfSongs(
          playlist.name); // Update the number of songs for the playlist
      print('Number of songs added: ${playlist.songs.length}');
    } else {
      print('Playlist not found');
    }
  }

  // Function to create a new playlist
  void createPlaylist(String playlistName) {
    final newPlaylist =
    Playlist(id: UniqueKey().toString(), name: playlistName);
    playlists.add(newPlaylist);
    savePlaylistsToSharedPreferences();

    // sharedPreferences.setInt(numberOfSongsKey, 0);
  }

  // Function to save playlists to SharedPreferences
  void savePlaylistsToSharedPreferences() async {
    final sharedPreferences = Get.find<SharedPreferences>();
    final playlistsData = playlists.map((playlist) => playlist.name).toList();
    await sharedPreferences.setStringList('playlists', playlistsData);
  }

  // Function to load playlists from SharedPreferences
  void loadPlaylistsFromSharedPreferences() async {
    final sharedPreferences = Get.find<SharedPreferences>();
    final playlistsData = sharedPreferences.getStringList('playlists');
    if (playlistsData != null) {
      playlists.clear();
      for (final playlistName in playlistsData) {
        createPlaylist(playlistName);

        // Update the number of songs for each playlist
        final numberOfSongsKey = '$playlistName-songs';
        final numberOfSongs = sharedPreferences.getInt(numberOfSongsKey) ?? 0;
        numberOfSongsMap[playlistName] = numberOfSongs;
      }
    }
  }

  void updateNumberOfSongs(String playlistName) async {
    final sharedPreferences = Get.find<SharedPreferences>();
    final numberOfSongsKey = '$playlistName-songs';
    final numberOfSongs = sharedPreferences.getInt(numberOfSongsKey) ?? 0;
    sharedPreferences.setInt(numberOfSongsKey, numberOfSongs + 1);
  }

// Function to fetch songs in a playlist by playlist ID
  // List<SongModel> fetchSongsInPlaylist(String playlistId) {
  //   final playlist = playlists.firstWhere(
  //     (pl) => pl.id == playlistId,
  //     orElse: () =>
  //         Playlist(id: '', name: '', songs: []), // Return an empty playlist
  //   );

  //   return playlist.songs;
  // }
  // Future<List<SongModel>> fetchSongsInPlaylist(String playlistId) async {
  //   final OnAudioQuery audioQuery = OnAudioQuery();
  //   final List<SongModel> songs = await audioQuery.querySongs(
  //     playlistId: playlistId,
  //   );
  //   return songs;
  // }

  // Future<List<SongModel>> fetchSongsInPlaylist(String playlistId) async {
  //   final OnAudioQuery audioQuery = OnAudioQuery();
  //   final List<SongModel> songs = await audioQuery.querySongs(
  //     playlistId: playlistId,
  //   );
  //   return songs;
  // }

  // Function to fetch songs in a playlist by playlist ID
  // List<SongModel> fetchSongsInPlaylist(String playlistId) {
  //   final playlist = playlists.firstWhere((pl) => pl.id == playlistId,
  //       orElse: () => Playlist(id: '', name: '', songs: []));
  //   return playlist.songs;
  // }
  // List<SongModel> fetchSongsInPlaylist(String playlistId) {
  //   print('Fetching songs for playlist ID: $playlistId');
  //   final playlist = playlists.firstWhere(
  //     (pl) => pl.id == playlistId,
  //     orElse: () => Playlist(id: '', name: '', songs: []),
  //   );
  //   print('Found ${playlist.songs.length} songs');
  //   return playlist.songs;
  // }

  // Future<List<SongModel>> fetchSongsInPlaylist(String playlistId) async {
  //   print('Fetching songs for playlist ID: $playlistId');

  //   // Find the playlist by ID
  //   final playlist = await playlists.firstWhere(
  //     (pl) => pl.id == playlistId,
  //     orElse: () => null, // Return null if not found
  //   );

  //   if (playlist != null) {
  //     print('Found ${playlist.songs.length} songs');
  //     return playlist.songs;
  //   } else {
  //     print('Playlist with ID $playlistId not found.');
  //     return []; // Return an empty list or handle the error as needed
  //   }
  // }
  // Future<List<SongModel>> fetchSongsInPlaylist(String playlistId) async {
  //   List<SongModel> playlistSongs = await audioQuery.querySongsFromPlaylist(
  //     playlistId: playlistId,
  //     sortType: SongSortType.DEFAULT,
  //   );
  //   return playlistSongs;
  // }
  // List<SongModel> fetchSongsInPlaylist(String playlistId) {
  //   print('Fetching songs for playlist ID: $playlistId');

  //   final playlist = playlists.firstWhere(
  //     (pl) => pl.id == playlistId,
  //     orElse: () => Playlist(id: '', name: '', songs: []),
  //   );

  //   print('Found ${playlist.songs.length} songs');
  //   return playlist.songs;
  // }
  // Function to fetch songs in a playlist by playlist ID
  List<SongModel> fetchSongsInPlaylist(String playlistId) {
    // Find the playlist by ID
    final playlist = playlists.firstWhere(
          (pl) => pl.id == playlistId,
      orElse: () => Playlist(id: '', name: '', songs: []),
    );

    // Return the songs in the playlist
    return playlist.songs;
  }

  Future<List<Playlist>> loadPlaylists() async {
    // Perform the logic to fetch playlists from your data source here
    // For example, you can load playlists from SharedPreferences as you did before
    // or fetch them from an API, database, or any other source.
    // Return the list of playlists as a result of this method.
    // Ensure that this method returns a Future<List<Playlist>>.

    // For example, if you were loading playlists from SharedPreferences:
    final sharedPreferences = Get.find<SharedPreferences>();
    final playlistsData = sharedPreferences.getStringList('playlists');

    if (playlistsData != null) {
      playlists.clear();
      for (final playlistName in playlistsData) {
        createPlaylist(playlistName);
        // ... Load and update the number of songs as needed
      }
      return playlists; // Return the loaded playlists
    } else {
      return []; // Return an empty list if no playlists are found
    }
  }
}

formatDuration(int durationMs) async {
  Duration duration = Duration(milliseconds: durationMs);
  int minutes = duration.inMinutes;
  int seconds = (duration.inSeconds % 60).toInt();
  String formattedDuration = '$minutes:${seconds.toString().padLeft(2, '0')}';
  return formattedDuration;
}

// Define a Playlist class to represent playlists
class Playlist {
  final String id;
  final String name;
  final List<SongModel> songs;

  Playlist({
    required this.id,
    required this.name,
    List<SongModel> songs = const [], // Initialize with an empty list of songs
  }) : songs = songs.toList();
}
