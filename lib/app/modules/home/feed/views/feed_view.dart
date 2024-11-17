import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../settings/controllers/settings_controller.dart';
import '../controllers/feed_controller.dart';
import 'feed_detail_view.dart';
import 'package:video_player/video_player.dart';

class FeedView extends StatelessWidget {
  const FeedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FeedController controller = Get.put(FeedController());
    final settingsController = Get.find<SettingsController>();

    return Scaffold(
      backgroundColor: settingsController.isDarkMode.value
          ? const Color(0xFF121212)
          : Colors.white,
      appBar: AppBar(
        title: const Text('Sensor-Driven Feeds'),
        backgroundColor: settingsController.isDarkMode.value
            ? Colors.black
            : const Color(0xFFAC9365),
      ),
      drawer: _buildFloatingSidebar(context, controller, settingsController),
      body: SafeArea(
        child: Obx(() {
          if (controller.feeds.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_not_supported,
                      size: 50, color: Color(0xFFAC9365)),
                  const SizedBox(height: 10),
                  Text(
                    'No feeds available. Add one to get started!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: settingsController.isDarkMode.value
                          ? Colors.grey[400]
                          : Color(0xFFAC9365),
                    ),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.0,
              ),
              itemCount: controller.feeds.length,
              itemBuilder: (context, index) {
                final feed = controller.feeds[index];
                return GestureDetector(
                  onTap: () {
                    Get.to(() => FeedDetailView(feed: feed));
                  },
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: feed.media != null
                              ? feed.mediaType == "image"
                                  ? ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                      ),
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: Image.file(feed.media!,
                                            fit: BoxFit.cover),
                                      ),
                                    )
                                  : feed.mediaType == "video"
                                      ? VideoWidget(videoFile: feed.media!)
                                      : const Center(
                                          child: Text('Unsupported media'))
                              : const Center(child: Text('No media available')),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            feed.message,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: settingsController.isDarkMode.value
                                  ? Colors.white
                                  : Color(0xFFAC9365),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildFloatingSidebar(BuildContext context, FeedController controller,
      SettingsController settingsController) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          color: settingsController.isDarkMode.value
              ? const Color(0xFF1E1E1E)
              : Color(0xFFAC9365).withOpacity(0.2),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: settingsController.isDarkMode.value
                    ? Colors.black
                    : Color(0xFFAC9365),
              ),
              child: const Text(
                'Feed Options',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.add,
                  color: settingsController.isDarkMode.value
                      ? Colors.white
                      : Color(0xFFAC9365)),
              title: Text(
                'Add Feed',
                style: TextStyle(
                    color: settingsController.isDarkMode.value
                        ? Colors.white
                        : Color(0xFFAC9365)),
              ),
              onTap: () {
                Navigator.pop(context);
                _showAddFeedDialog(context, controller);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete,
                  color: settingsController.isDarkMode.value
                      ? Colors.white
                      : Color(0xFFAC9365)),
              title: Text(
                'Delete Selected Feed',
                style: TextStyle(
                    color: settingsController.isDarkMode.value
                        ? Colors.white
                        : Color(0xFFAC9365)),
              ),
              onTap: () {
                Navigator.pop(context);
                Get.snackbar(
                    'Feature Not Implemented', 'Delete feed logic is pending.');
              },
            ),
            ListTile(
              leading: Icon(Icons.edit,
                  color: settingsController.isDarkMode.value
                      ? Colors.white
                      : Color(0xFFAC9365)),
              title: Text(
                'Update Feed',
                style: TextStyle(
                    color: settingsController.isDarkMode.value
                        ? Colors.white
                        : Color(0xFFAC9365)),
              ),
              onTap: () {
                Navigator.pop(context);
                Get.snackbar(
                    'Feature Not Implemented', 'Update feed logic is pending.');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddFeedDialog(BuildContext context, FeedController controller) {
    final messageController = TextEditingController();
    String? selectedMediaType;

    final speech = stt.SpeechToText();
    bool isListening = false;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Feed'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: messageController,
                decoration: const InputDecoration(labelText: 'Message'),
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                hint: const Text('Select Media Type'),
                value: selectedMediaType,
                items: <String>['image', 'video'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedMediaType = value;
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  File? mediaFile;
                  if (selectedMediaType != null) {
                    mediaFile = await controller.pickMedia(selectedMediaType!);
                  }

                  if (mediaFile != null) {
                    controller.addFeed(
                      selectedMediaType!,
                      messageController.text,
                      mediaFile,
                    );
                    Navigator.of(context).pop();
                  } else {
                    Get.snackbar('Error', 'Please select a valid media file');
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFAC9365)),
                child: const Text('Add', style: TextStyle(color: Colors.white)),
              ),
              IconButton(
                icon: Icon(Icons.mic,
                    color: isListening ? Colors.red : Colors.grey),
                onPressed: () async {
                  if (isListening) {
                    await speech.stop();
                    isListening = false;
                  } else {
                    await _startListening(speech, messageController);
                    isListening = true;
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _startListening(stt.SpeechToText speech,
      TextEditingController messageController) async {
    bool available = await speech.initialize(onStatus: (status) {
      print('Speech status: $status');
    }, onError: (error) {
      print('Speech error: $error');
    });

    if (available) {
      speech.listen(
        onResult: (result) {
          messageController.text = result.recognizedWords;
        },
      );
    } else {
      Get.snackbar(
        'Error',
        'Microphone access is required for speech-to-text functionality.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

class VideoWidget extends StatelessWidget {
  final File videoFile;
  const VideoWidget({required this.videoFile});

  @override
  Widget build(BuildContext context) {
    return VideoPlayerWidget(videoFile: videoFile);
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final File videoFile;
  const VideoPlayerWidget({required this.videoFile});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : const Center(child: CircularProgressIndicator());
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
