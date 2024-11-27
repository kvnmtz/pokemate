import 'package:flutter/material.dart';
import 'package:pokemate/extensions/build_context_extensions.dart';
import 'package:stacked/stacked.dart';

import 'error_details_sheet_model.dart';

class ErrorDetailsSheet extends StackedView<ErrorDetailsSheetModel> {
  final String message;
  final String detailedMessage;

  const ErrorDetailsSheet({
    super.key,
    required this.message,
    required this.detailedMessage,
  });

  @override
  Widget builder(
    BuildContext context,
    ErrorDetailsSheetModel viewModel,
    Widget? child,
  ) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 600),
      child: Scrollbar(
        interactive: true,
        thumbVisibility: true,
        controller: viewModel.scrollController,
        radius: context.theme.platform == TargetPlatform.android ? const Radius.circular(2) : null,
        child: CustomScrollView(
          controller: viewModel.scrollController,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: 24,
              ),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.t.errorDetails,
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(message),
                    const SizedBox(height: 8),
                    Text(detailedMessage),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
              ),
              sliver: SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: viewModel.copy,
                          child: const Text('Copy'),
                        ),
                        const SizedBox(width: 24),
                        FilledButton(
                          onPressed: viewModel.close,
                          child: Text(context.t.ok),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  ErrorDetailsSheetModel viewModelBuilder(BuildContext context) {
    return ErrorDetailsSheetModel(
      message: message,
      detailedMessage: detailedMessage,
    );
  }
}
