import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class FeedController extends GetxController {
  late List<VideoPlayerController> videoControllers;
  var isPlaying = false.obs;
  var isInitialized = false.obs;
  var currentVideoIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();

    // Inisialisasi beberapa video
    videoControllers = [
      VideoPlayerController.asset('lib/assets/baju1.mp4'),
      VideoPlayerController.asset('lib/assets/baju2.mp4'),
    ];

    // Inisialisasi video pertama
    _initializeVideo(currentVideoIndex.value);
  }

  void _initializeVideo(int index) {
    isInitialized.value = false;
    videoControllers[index].initialize().then((_) {
      isInitialized.value = true;
      videoControllers[index].play();
      isPlaying.value = true;
      update();
    });
  }

  void playPause() {
    if (videoControllers[currentVideoIndex.value].value.isPlaying) {
      videoControllers[currentVideoIndex.value].pause();
      isPlaying.value = false;
    } else {
      videoControllers[currentVideoIndex.value].play();
      isPlaying.value = true;
    }
  }

  void switchVideo(int index) {
    if (index < 0 || index >= videoControllers.length) return; // Cegah indeks di luar batas

    // Hentikan video saat ini
    videoControllers[currentVideoIndex.value].pause();
    isPlaying.value = false;
    videoControllers[currentVideoIndex.value].seekTo(Duration.zero);

    // Set video baru dan inisialisasi
    currentVideoIndex.value = index;
    _initializeVideo(index);
  }

  @override
  void onClose() {
    // Dispose semua videoControllers
    for (var controller in videoControllers) {
      controller.dispose();
    }
    super.onClose();
  }
}
