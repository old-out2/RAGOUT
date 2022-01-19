import 'package:app/screens/tutorial/user_others.dart';
import 'package:app/screens/tutorial/user_physical.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sliding_tutorial/flutter_sliding_tutorial.dart';

class SlidingTutorial extends StatefulWidget {
  const SlidingTutorial({
    required this.controller,
    required this.notifier,
    required this.pageCount,
    Key? key,
  }) : super(key: key);

  final ValueNotifier<double> notifier;
  final int pageCount;
  final PageController controller;

  @override
  State<StatefulWidget> createState() => _SlidingTutorial();
}

class _SlidingTutorial extends State<SlidingTutorial> {
  late PageController _pageController;

  @override
  void initState() {
    _pageController = widget.controller;

    /// Listen to [PageView] position updates.
    _pageController..addListener(_onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBackgroundColor(
      pageController: _pageController,
      pageCount: widget.pageCount,

      /// You can use your own color list for page background
      colors: const [
        Color(0xFFF0C85A),
        Color(0xFFF0C85A),
      ],
      child: Container(
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              children: List<Widget>.generate(
                widget.pageCount,
                (index) => _getPageByIndex(index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Create different [SlidingPage] for indexes.
  Widget _getPageByIndex(int index) {
    switch (index % 2) {
      case 0:
        return UserphysicalPage(index, widget.notifier);
      case 1:
        return UserothersPage(index, widget.notifier);
      default:
        throw ArgumentError("Unknown position: $index");
    }
  }

  /// Notify [SlidingPage] about current page changes.
  _onScroll() {
    widget.notifier.value = _pageController.page ?? 0;
  }
}
