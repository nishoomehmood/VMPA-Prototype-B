import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpma_test_phase/screens/home/Artists.dart';
import 'package:vpma_test_phase/screens/home/MusicList.dart';
import 'package:vpma_test_phase/screens/home/album.dart';

import '../../controller/controller.dart';

class HomePage extends StatelessWidget {
  final PlayerController controller;
  const HomePage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());
    return DefaultTabController(
      length: 3,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Color.fromARGB(255, 101, 136, 96).withOpacity(0.6),
              const Color(0xFF303151).withOpacity(0.9),
            ])),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 15, right: 20, bottom: 20),
                    child: Container(
                      height: 50,
                      width: 380,
                      decoration: BoxDecoration(
                        color:
                            Color.fromARGB(255, 101, 136, 96).withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            height: 50,
                            width: 200,
                            child: TextFormField(
                              onChanged: (query) {
                                controller.updateSearchQuery(query);
                              },
                              decoration: InputDecoration(
                                hintText: "Search the music",
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(
                              Icons.search,
                              size: 30,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const TabBar(
                    isScrollable: true,
                    labelStyle: TextStyle(fontSize: 18),
                    indicator: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 3,
                          color: Color.fromARGB(255, 32, 163, 76),
                        ),
                      ),
                    ),
                    tabs: [
                      Tab(
                        text: "All Songs",
                      ),
                      Tab(
                        text: "Album",
                      ),
                      Tab(
                        text: "Artist",
                      ),
                    ],
                  ),
                  Flexible(
                    flex: 1,
                    child: TabBarView(
                      children: [
                        MusicList(
                          controller: controller,
                          songs: controller.filteredSongs,
                          searchQuery: controller.searchQuery,
                        ),
                        Albums(
                            controller: controller,
                            searchQuery: controller.searchQuery),
                        Artists(
                            controller: controller,
                            searchQuery: controller.searchQuery),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
