import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/app_colors.dart';

class HomeLandingPage extends StatefulWidget {
  const HomeLandingPage({super.key});

  @override
  State<HomeLandingPage> createState() => _HomeLandingPageState();
}

class _HomeLandingPageState extends State<HomeLandingPage> {
  String? _customImagePath;
  String _overlayText = "Welcome to Acumen Hymn Book";
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _overlayText = prefs.getString('landing_overlay_text') ??
          "Welcome to Acumen Hymn Book";
      _customImagePath = prefs.getString('landing_image_path');
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('landing_overlay_text', _overlayText);
    if (_customImagePath != null) {
      await prefs.setString('landing_image_path', _customImagePath!);
    }
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        _customImagePath = result.files.single.path;
      });
      await _saveSettings();
    }
  }

  void _editPlaceholder() {
    final controller = TextEditingController(text: _overlayText);
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: SizedBox(
                width: 450,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.edit_note, color: AppColors.mainColor),
                              SizedBox(width: 10),
                              Text(
                                "Edit Overlay Text",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: controller,
                            maxLength: 140,
                            maxLines: 3,
                            autofocus: true,
                            onChanged: (value) => setDialogState(() {}),
                            decoration: InputDecoration(
                              hintText: "What's on your mind?",
                              filled: true,
                              fillColor: Colors.grey.withAlpha(20),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: AppColors.mainColor, width: 2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _overlayText = controller.text;
                                  });
                                  _saveSettings();
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.mainColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text("Update Heading"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          setState(() {
            _showControls = !_showControls;
          });
        },
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: _customImagePath != null
                  ? Image.file(
                      File(_customImagePath!),
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/sunset.jpg',
                      fit: BoxFit.cover,
                    ),
            ),

            // SDA Logo Top Right
            Positioned(
              top: 40,
              right: 40,
              child: Image.asset(
                'assets/images/sda.png',
                width: 150,
                color: Colors.white.withAlpha(200),
                colorBlendMode: BlendMode.modulate,
              ),
            ),

            // Text Overlay
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  _overlayText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Controls (Hidden when page is "active" to avoid distraction)
            if (_showControls)
              Positioned(
                bottom: 20,
                right: 20,
                child: Row(
                  children: [
                    FloatingActionButton(
                      heroTag: "edit_text",
                      onPressed: _editPlaceholder,
                      backgroundColor: AppColors.mainColor,
                      child: const Icon(Icons.edit, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    FloatingActionButton(
                      heroTag: "pick_image",
                      onPressed: _pickImage,
                      backgroundColor: AppColors.mainColor,
                      child: const Icon(Icons.image, color: Colors.white),
                    ),
                  ],
                ),
              ),

            if (_showControls)
              Positioned(
                top: 20,
                left: 20,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Tap anywhere to hide/show controls. Hover to the left for the sidebar.",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
