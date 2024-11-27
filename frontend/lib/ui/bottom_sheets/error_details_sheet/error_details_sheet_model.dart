import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokemate/app/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ErrorDetailsSheetModel extends BaseViewModel {
  final String message;
  final String detailedMessage;

  ErrorDetailsSheetModel({
    required this.message,
    required this.detailedMessage,
  });

  final _routerService = locator<RouterService>();

  final _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  void close() {
    _routerService.back();
  }

  void copy() {
    Clipboard.setData(ClipboardData(text: '$message\n$detailedMessage'));
  }
}
