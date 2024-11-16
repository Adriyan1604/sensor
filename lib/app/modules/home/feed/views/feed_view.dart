import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../controllers/feed_controller.dart';

class FeedView extends GetView<FeedController> {
  const FeedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed Page'),
      ),
      body: Center(
        child: Obx(() {
          if (controller.isInitialized.value) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: controller.videoControllers[controller.currentVideoIndex.value].value.aspectRatio,
                    child: VideoPlayer(controller.videoControllers[controller.currentVideoIndex.value]),
                  ),
                ),
                const SizedBox(height: 20),
                IconButton(
                  icon: Icon(
                    controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
                    size: 50,
                  ),
                  onPressed: () {
                    controller.playPause();
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (controller.currentVideoIndex.value > 0) {
                          controller.switchVideo(controller.currentVideoIndex.value - 1);
                        }
                      },
                      child: const Text('Previous Video'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        if (controller.currentVideoIndex.value < controller.videoControllers.length - 1) {
                          controller.switchVideo(controller.currentVideoIndex.value + 1);
                        }
                      },
                      child: const Text('Next Video'),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return const CircularProgressIndicator();
          }
        }),
      ),
    );
  }
}
