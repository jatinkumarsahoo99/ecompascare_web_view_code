import 'package:flutter/material.dart';

class AsyncIconButton extends StatefulWidget {
  const AsyncIconButton({
    Key? key,
    this.onPressed,
    required this.icon,
    required this.toolTip,
    this.isDense = false,
  })  : text = null,
        caption = null,
        super(key: key);

  const AsyncIconButton.text({
    Key? key,
    this.onPressed,
    this.text,
    this.caption,
    required this.icon,
    required this.toolTip,
    this.isDense = false,
  })  : assert((text != null && caption == null) ||
            (text == null && caption != null)),
        super(key: key);

  final Function()? onPressed;
  final Widget? text;
  final Widget icon;
  final String? caption;
  final String toolTip;
  final bool isDense;

  @override
  State<AsyncIconButton> createState() => _AsyncIconButtonState();
}

class _AsyncIconButtonState extends State<AsyncIconButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Widget child = (widget.text == null && widget.caption == null)
        ? widget.icon
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.icon,
              const SizedBox(height: 2),
              if (widget.text != null) widget.text!,
              if (widget.caption != null)
                Text(
                  widget.caption!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          );
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: widget.isDense ? const BoxConstraints() : null,
      onPressed: () async {
        setState(() => isLoading = true);
        if (widget.onPressed != null) {
          await widget.onPressed!();
        }
        setState(() => isLoading = false);
      },
      icon: isLoading ? const CircularProgressIndicator() : child,
    );
  }
}
