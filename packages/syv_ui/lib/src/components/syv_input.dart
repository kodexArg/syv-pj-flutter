import 'package:flutter/material.dart';

import '../tokens/syv_tokens.dart';

/// A borderless "typewriter" text field. At rest only the platen baseline rule
/// shows; on focus the rule greens. [invalid] turns the rule red. The interior
/// is monospace (DM Mono). Label is mono uppercase with a green `›` marker.
class SyvInput extends StatefulWidget {
  /// Creates an input field.
  const SyvInput({
    super.key,
    this.label,
    this.hint,
    this.invalid = false,
    this.value,
    this.placeholder,
    this.disabled = false,
    this.onChanged,
    this.controller,
  });

  /// Mono uppercase label rendered above the field, prefixed with `›`.
  final String? label;

  /// Mono helper text below the field; reddens when [invalid].
  final String? hint;

  /// Error state — reddens the baseline rule and the hint.
  final bool invalid;

  /// Initial text (ignored when a [controller] is supplied).
  final String? value;

  /// Placeholder shown when empty.
  final String? placeholder;

  /// Disables interaction and dims the field.
  final bool disabled;

  /// Change callback.
  final ValueChanged<String>? onChanged;

  /// Optional external controller; created internally when null.
  final TextEditingController? controller;

  @override
  State<SyvInput> createState() => _SyvInputState();
}

class _SyvInputState extends State<SyvInput> {
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController(text: widget.value);
  final FocusNode _focus = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() => _focused = _focus.hasFocus));
  }

  @override
  void dispose() {
    _focus.dispose();
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color rule = widget.invalid
        ? SyvColors.bad
        : _focused
            ? SyvColors.green500
            : SyvColors.ink600;

    final field = Opacity(
      opacity: widget.disabled ? 0.42 : 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _focused
              ? const Color(0x0F7B8A4E)
              : const Color(0x05FFFFFF),
          borderRadius: const BorderRadius.all(SyvRadius.md),
          border: Border(bottom: BorderSide(color: rule, width: 1.5)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 11, 12, 8),
          child: TextField(
            controller: _controller,
            focusNode: _focus,
            enabled: !widget.disabled,
            onChanged: widget.onChanged,
            cursorColor: SyvColors.green500,
            cursorWidth: 8,
            cursorHeight: 2,
            style: SyvType.mono_.copyWith(fontSize: 15, height: 1.5),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: widget.placeholder,
              hintStyle: SyvType.mono_.copyWith(
                fontSize: 15,
                color: SyvColors.ink500,
                letterSpacing: 0.6,
              ),
            ),
          ),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (widget.label != null) ...<Widget>[
          Text.rich(
            TextSpan(
              children: <InlineSpan>[
                const TextSpan(
                  text: '› ',
                  style: TextStyle(color: SyvColors.green500),
                ),
                TextSpan(text: widget.label!.toUpperCase()),
              ],
              style: SyvType.mono_.copyWith(
                fontSize: 11,
                letterSpacing: 1.2,
                color: SyvColors.warm200,
              ),
            ),
          ),
          const SizedBox(height: 7),
        ],
        field,
        if (widget.hint != null) ...<Widget>[
          const SizedBox(height: 7),
          Text(
            widget.hint!,
            style: SyvType.mono_.copyWith(
              fontSize: 11,
              color: widget.invalid ? SyvColors.bad : SyvColors.ink500,
            ),
          ),
        ],
      ],
    );
  }
}
