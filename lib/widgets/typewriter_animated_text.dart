import 'package:flutter/material.dart';
import 'dart:async';

class TypewriterAnimatedText extends StatefulWidget {
  final List<String> texts;
  final int typingSpeed; // Characters per minute
  final Duration pauseDuration;

  const TypewriterAnimatedText({
    super.key,
    required this.texts,
    this.typingSpeed = 150,
    this.pauseDuration = const Duration(seconds: 2),
  });

  @override
  State<TypewriterAnimatedText> createState() => _TypewriterAnimatedTextState();
}

class _TypewriterAnimatedTextState extends State<TypewriterAnimatedText> {
  late String _currentText;
  late int _currentIndex;
  late int _charIndex;
  late bool _isTyping;
  late bool _isDeleting;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _charIndex = 0;
    _currentText = '';
    _isTyping = true;
    _isDeleting = false;
    _startTyping();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTyping() {
    // Calculate delay based on typing speed (characters per minute)
    final int delayMilliseconds = (60 * 50) ~/ widget.typingSpeed;
    
    _timer = Timer.periodic(Duration(milliseconds: delayMilliseconds), (timer) {
      setState(() {
        if (_isTyping) {
          if (_charIndex < widget.texts[_currentIndex].length) {
            _currentText = widget.texts[_currentIndex].substring(0, _charIndex + 1);
            _charIndex++;
          } else {
            _isTyping = false;
            _timer.cancel();
            // Pause before deleting
            Future.delayed(widget.pauseDuration, () {
              if (mounted) {
                setState(() {
                  _isDeleting = true;
                  _startTyping();
                });
              }
            });
          }
        } else if (_isDeleting) {
          if (_charIndex > 0) {
            _charIndex--;
            _currentText = widget.texts[_currentIndex].substring(0, _charIndex);
          } else {
            _isDeleting = false;
            _currentIndex = (_currentIndex + 1) % widget.texts.length;
            _isTyping = true;
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        _currentText,
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).colorScheme.onSurface,
          height: 1.3,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

