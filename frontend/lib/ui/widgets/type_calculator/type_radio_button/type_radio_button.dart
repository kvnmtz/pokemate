import 'package:flutter/material.dart';
import 'package:pokemate/extensions/build_context_extensions.dart';
import 'package:pokemate/common/pokemon_data/pokemon_types.dart';

class TypeRadioButton extends StatelessWidget {
  final PokemonType? value;
  final PokemonType? groupValue;

  final void Function() onTap;

  final bool isDisabled;
  final bool isVisible;

  const TypeRadioButton({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onTap,
    required this.isDisabled,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: InkWell(
        mouseCursor: isDisabled ? SystemMouseCursors.forbidden : null,
        borderRadius: BorderRadius.circular(8),
        onTap: isDisabled ? null : onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min, // important for wrapping
          children: [
            // InkWell will handle taps, so radio should ignore them
            IgnorePointer(
              child: SizedBox(
                width: 32,
                height: 32,
                child: Radio<PokemonType?>(
                  value: value,
                  groupValue: groupValue,
                  onChanged: isDisabled ? null : (value) {},
                ),
              ),
            ),
            value == null
                ? SizedBox(
                    width: 100,
                    child: Text(context.t.typeNone),
                  )
                : SizedBox(
                    width: 100,
                    child: Image.asset(
                      'assets/images/type_icons/type_${value!.name}_${context.locale.languageCode}.png',
                      width: 100,
                      // half opacity if type is already selected
                      opacity: AlwaysStoppedAnimation(
                        isDisabled ? 0.5 : 1,
                      ),
                    ),
                  ),
            const SizedBox(width: 6),
          ],
        ),
      ),
    );
  }
}
