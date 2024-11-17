import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
            ],
          ),
        );
      },
    );
  }

  Widget VideoWidget({required File videoFile}) {
    final VideoPlayerController controller = VideoPlayerController.file(videoFile);

    return FutureBuilder(
      future: controller.initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
