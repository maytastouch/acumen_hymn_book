// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_colors.dart';
import 'back_widget.dart';
import 'text_widget.dart';

class HymnTemplate extends StatefulWidget {
  const HymnTemplate({
    super.key,
    required this.title,
    required this.hymnNumber,
    required this.body,
  });

  final String title;
  final String hymnNumber;
  final String body;

  @override
  State<HymnTemplate> createState() => _HymnTemplateState();
}

class _HymnTemplateState extends State<HymnTemplate> {
  late bool _isInFavorites;
  late ScrollController _controller;

  void _handleKeyDownEvent(RawKeyEvent keyEvent) {
    if (keyEvent is RawKeyDownEvent) {
      if (keyEvent.logicalKey == LogicalKeyboardKey.arrowDown) {
        if (_controller.offset < _controller.position.maxScrollExtent) {
          _controller.animateTo(
            _controller.offset + 200.0,
            duration: const Duration(milliseconds: 100),
            curve: Curves.linear,
          );
        }
      } else if (keyEvent.logicalKey == LogicalKeyboardKey.arrowUp) {
        if (_controller.offset > 0.0) {
          _controller.animateTo(
            _controller.offset - 200.0,
            duration: const Duration(milliseconds: 100),
            curve: Curves.linear,
          );
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();

    // Listen for the up and down key events
    _controller = ScrollController();
    RawKeyboard.instance.addListener(_handleKeyDownEvent);
  }

  @override
  void dispose() {
    RawKeyboard.instance.removeListener(_handleKeyDownEvent);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackWidget(),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.mainColor,
        title: TextWidget(
          text: "${widget.hymnNumber} - ${widget.title}",
          color: Colors.white,
          textSize: 18,
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isInFavorites ? Icons.favorite : Icons.favorite_border,
              color: _isInFavorites ? Colors.red : Colors.grey,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        color: AppColors.pageColor, // Set the background color to light blue
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: ListView(
            controller: _controller,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 30),
                child: Text(
                  widget.title,
                  maxLines: 10,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              //body

              Padding(
                padding: const EdgeInsets.only(right: 35),
                child: Text(
                  widget.body,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      height: 1.3,
                      wordSpacing: 2.5),
                ),
              ),

              const SizedBox(
                height: 240,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
