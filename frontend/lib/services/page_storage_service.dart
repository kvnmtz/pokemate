import 'package:flutter/material.dart';
import 'package:pokemate/extensions/build_context_extensions.dart';

class PageStorageService {
  final _pageStorageKey = GlobalKey();
  GlobalKey get pageStorageKey => _pageStorageKey;

  dynamic read(String identifier) {
    final context = pageStorageKey.currentContext!;
    return context.pageStorage.readState(
      context,
      identifier: identifier,
    );
  }

  void write(dynamic data, {required String identifier}) {
    final context = pageStorageKey.currentContext!;
    context.pageStorage.writeState(
      context,
      data,
      identifier: identifier,
    );
  }
}
