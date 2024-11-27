import 'package:flutter/material.dart';
import 'package:pokemate/app/app.locator.dart';
import 'package:pokemate/extensions/build_context_extensions.dart';
import 'package:stacked_services/stacked_services.dart';

class WebCachedFrontendOutdatedDialog extends StatelessWidget {
  const WebCachedFrontendOutdatedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.t.viewingOutdatedVersion),
      icon: const Icon(Icons.warning),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 32,
      ),
      content: Text(context.t.fixingOutdatedCache),
      actions: [
        FilledButton(
          onPressed: locator<RouterService>().back,
          child: Text(context.t.keepUsingOutdatedVersion),
        ),
      ],
    );
  }
}
