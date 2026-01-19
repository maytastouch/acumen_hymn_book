import 'package:flutter/material.dart';
import 'package:acumen_hymn_book/core/services/hymn_storage_service.dart';
import 'package:acumen_hymn_book/core/constants/app_colors.dart';

class HymnEditScreen extends StatefulWidget {
  final String assetPath;
  final String initialContent;
  final Future<void> Function(String content)? onSave;

  const HymnEditScreen({
    super.key,
    required this.assetPath,
    required this.initialContent,
    this.onSave,
  });

  @override
  State<HymnEditScreen> createState() => _HymnEditScreenState();
}

class _HymnEditScreenState extends State<HymnEditScreen> {
  late TextEditingController _controller;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialContent);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _isSaving = true;
    });

    try {
      if (widget.onSave != null) {
        await widget.onSave!(_controller.text);
      } else {
        await HymnStorageService.saveHymnContent(
          widget.assetPath,
          _controller.text,
        );
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Hymn saved successfully! Please restart the hymn to see changes.')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving hymn: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Hymn Lyrics'),
        backgroundColor: AppColors.mainColor,
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(color: Colors.white),
            )
          else
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _save,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _controller,
          maxLines: null,
          expands: true,
          textAlignVertical: TextAlignVertical.top,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter hymn lyrics in markdown format...',
          ),
          style: const TextStyle(fontFamily: 'monospace'),
        ),
      ),
    );
  }
}
