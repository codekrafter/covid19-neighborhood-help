import 'package:flutter/material.dart';

import 'styles.dart' as styles;

class CustomTextField extends StatefulWidget {
  const CustomTextField(
      {@required this.placeholder,
      @required this.name,
      this.isRequired = false,
      this.keyboardType = TextInputType.text,
      this.minLines,
      this.maxLines,
      this.onEditingCompleted,
      this.initialValue,
      Key key})
      : assert(placeholder != null),
        assert(name != null),
        assert(isRequired != null),
        assert(keyboardType != null),
        super(key: key);

  final String placeholder;
  final String name;
  final bool isRequired;
  final TextInputType keyboardType;
  final int minLines;
  final int maxLines;
  final Function(String) onEditingCompleted;
  final String initialValue;

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  String _currentValue;

  @override
  void initState() {
    super.initState();

    _currentValue = widget.initialValue != null ? widget.initialValue : "";
  }

  @override
  Widget build(BuildContext context) {
    final normalBorder = OutlineInputBorder(borderSide: BorderSide(color: styles.inputBorderColor));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(text: widget.name, style: styles.textFieldNameStyle, children: [
            if (widget.isRequired) TextSpan(text: ' *', style: styles.requiredMarkStyle),
          ]),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 3),
          child: TextField(
            decoration: InputDecoration(
              border: normalBorder,
              enabledBorder: normalBorder,
              focusedBorder:
                  normalBorder.copyWith(borderSide: BorderSide(color: styles.requestBlue)),
              hintText: widget.placeholder,
              hintStyle: TextStyle(color: styles.inputBorderColor),
              contentPadding: EdgeInsets.fromLTRB(
                  15, 5, 3, (widget.keyboardType == TextInputType.multiline) ? 10 : 3),
            ),
            cursorColor: styles.requestBlue,
            keyboardType: widget.keyboardType,
            minLines: widget.minLines,
            maxLines: widget.maxLines,
            onChanged: (val) => _currentValue = val,
            onEditingComplete: () => widget.onEditingCompleted(_currentValue),
          ),
        ),
      ],
    );
  }
}
