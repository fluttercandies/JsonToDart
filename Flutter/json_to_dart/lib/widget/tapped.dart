import 'package:flutter/material.dart';

class Tapped extends StatefulWidget {
  const Tapped({this.child, this.onTap, this.onLongTap});
  final Widget? child;
  final Function? onTap;
  final Function? onLongTap;

  @override
  _TappedState createState() => _TappedState();
}

class _TappedState extends State<Tapped> with TickerProviderStateMixin {
  bool _isChangeAlpha = false;
  Duration duration = const Duration(milliseconds: 50);
  Duration showDuration = const Duration(milliseconds: 660);
  AnimationController? _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(value: 1, vsync: this);
    _animation = CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeInOutCubic,
    );
    _animation.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  bool _tapDown = false;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Future<void>.delayed(const Duration(milliseconds: 100), () {});
        widget.onTap?.call();
      },
      onLongPress: widget.onLongTap == null
          ? null
          : () async {
              await Future<void>.delayed(
                  const Duration(milliseconds: 100), () {});
              widget.onLongTap!();
            },
      onTapDown: (TapDownDetails detail) async {
        _tapDown = true;
        _isChangeAlpha = true;
        await _controller!.animateTo(0.4, duration: duration);
        if (!_tapDown) {
          await _controller!.animateTo(1, duration: showDuration);
        }
        _tapDown = false;
        _isChangeAlpha = false;
      },
      onTapUp: (TapUpDetails detail) async {
        _tapDown = false;
        if (_isChangeAlpha == true) {
          return;
        }
        await _controller!.animateTo(1, duration: showDuration);
        _isChangeAlpha = false;
      },
      onTapCancel: () async {
        _tapDown = false;
        _controller!.value = 1;
        _isChangeAlpha = false;
      },
      child: Opacity(
        opacity: _animation.value,
        child: widget.child,
      ),
    );
  }
}
