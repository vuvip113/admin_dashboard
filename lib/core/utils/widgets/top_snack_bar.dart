import 'package:flutter/material.dart';

class TopSnackBar {
  static void show(
    BuildContext context,
    String message, {
    Color backgroundColor = Colors.green,
    Duration duration = const Duration(seconds: 3),
    double top = 0, // khoảng cách từ trên cùng
    double horizontalMargin = 20,
    double borderRadius = 12,
    double maxWidth = 300,
    EdgeInsets padding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 10,
    ),
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: top,
        left: 0,
        right: 0,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: _TopSnackBarContent(
              message: message,
              backgroundColor: backgroundColor,
              borderRadius: borderRadius,
              maxWidth: maxWidth,
              padding: padding,
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }
}

/// Nội dung SnackBar
class _TopSnackBarContent extends StatefulWidget {
  final String message;
  final Color backgroundColor;
  final double borderRadius;
  final double maxWidth;
  final EdgeInsets padding;

  const _TopSnackBarContent({
    required this.message,
    required this.backgroundColor,
    required this.borderRadius,
    required this.maxWidth,
    required this.padding,
  });

  @override
  State<_TopSnackBarContent> createState() => _TopSnackBarContentState();
}

class _TopSnackBarContentState extends State<_TopSnackBarContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -1),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        constraints: BoxConstraints(maxWidth: widget.maxWidth),
        padding: widget.padding,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          widget.message,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
