import 'package:flutter/material.dart';
import 'package:pokemate/app/app.locator.dart';
import 'package:pokemate/services/page_storage_service.dart';
import 'package:stacked/stacked.dart';

class PersistentViewModel extends ReactiveViewModel {
  final _pageStorageService = locator<PageStorageService>();

  late ScrollController _scrollController;
  ScrollController get scrollController => _scrollController;

  final String identifier;

  PersistentViewModel({
    required this.identifier,
  }) {
    _scrollController = ScrollController(
      keepScrollOffset: false,
      onDetach: (position) {
        _pageStorageService.write(position.pixels, identifier: 'scroll_offset-$identifier');
      },
    );
  }

  void restoreScrollOffset() {
    final scrollOffset = _pageStorageService.read('scroll_offset-$identifier');
    if (scrollOffset == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;
      scrollController.jumpTo(scrollOffset);
    });
  }

  void persistViewModel() {
    _pageStorageService.write(this, identifier: 'viewmodel-$identifier');
  }

  static T buildViewModel<T extends PersistentViewModel>({
    required T Function({required String identifier}) initial,
    required String identifier,
  }) {
    var viewModel = locator<PageStorageService>().read('viewmodel-$identifier');
    if (viewModel != null) {
      return viewModel;
    } else {
      return initial(identifier: identifier);
    }
  }
}
