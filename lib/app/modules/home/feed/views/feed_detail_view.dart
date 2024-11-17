import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pemrograman_mobile/app/modules/home/feed/controllers/feed_controller.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import '../../settings/controllers/settings_controller.dart';

class FeedDetailView extends StatefulWidget {
  final Feed feed;

  const FeedDetailView({Key? key, required this.feed}) : super(key: key);

  @override
  _FeedDetailViewState createState() => _FeedDetailViewState();
}

class _FeedDetailViewState extends State<FeedDetailView> {
  VideoPlayerController? _videoController;
  bool _isVideoPlaying = false;

  @override
  void initState() {
    super.initState();

    // Initialize video player if media is a video
    if (widget.feed.mediaType == "video" && widget.feed.media != null) {
      _videoController = VideoPlayerController.file(widget.feed.media!)
        ..initialize().then((_) {
          setState(() {});
          _videoController?.play();
          _isVideoPlaying = true;
        }).catchError((error) {
          debugPrint('Error initializing video: $error');
        });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  // Toggle video play/pause
  void _toggleVideoPlayback() {
    setState(() {
      if (_isVideoPlaying) {
        _videoController?.pause();
        _isVideoPlaying = false;
      } else {
        _videoController?.play();
        _isVideoPlaying = true;
      }
    });
  }

  // Share feed content, including media path if available
  void _shareFeed() {
    final String feedContent = widget.feed.message;
    final String? mediaPath = widget.feed.media?.path;

    final String shareText = mediaPath != null
        ? '$feedContent\n\nMedia: $mediaPath'
        : feedContent;

    Share.share(shareText);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Get.find<SettingsController>().isDarkMode.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed Detail'),
        backgroundColor: isDarkMode ? Colors.black : Color(0xFFAC9365),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Media display
              if (widget.feed.media != null)
                widget.feed.mediaType == "video"
                    ? _videoController != null && _videoController!.value.isInitialized
                        ? Column(
                            children: [
                              AspectRatio(
                                aspectRatio: _videoController!.value.aspectRatio,
                                child: VideoPlayer(_videoController!),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      _isVideoPlaying ? Icons.pause : Icons.play_arrow,
                                      size: 30,
                                      color: Color(0xFFAC9365),
                                    ),
                                    onPressed: _toggleVideoPlayback,
                                  ),
                                ],
                              ),
                            ],
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          )
                    : widget.feed.mediaType == "image"
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              widget.feed.media!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          )
                        : const Center(
                            child: Text(
                              'Unsupported media type',
                              style: TextStyle(color: Color(0xFFAC9365)),
                            ),
                          ),
              const SizedBox(height: 20),

              // Feed message
              Text(
                widget.feed.message,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Color(0xFFAC9365),
                ),
              ),
              const SizedBox(height: 20),

              // Share button
              ElevatedButton.icon(
                onPressed: _shareFeed,
                icon: const Icon(Icons.share, color: Colors.white),
                label: const Text(
                  'Share this Feed',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode ? Colors.grey[800] : Color(0xFFAC9365),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Footer or additional details
              Text(
                'Thank you for exploring this feed!',
                style: TextStyle(
                  color: isDarkMode ? Colors.grey : Color(0xFFAC9365),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
