import 'package:flutter/material.dart';

import 'styles.dart' as styles;

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {@required this.placeholder,
      @required this.name,
      this.isRequired = false,
      this.keyboardType = TextInputType.text,
      this.minLines,
      this.maxLines,
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

  @override
  Widget build(BuildContext context) {
    final normalBorder = OutlineInputBorder(borderSide: BorderSide(color: styles.inputBorderColor));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(text: name, style: styles.textFieldNameStyle, children: [
            if (isRequired) TextSpan(text: ' *', style: styles.requiredMarkStyle),
          ]),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 3),
          child: TextField(
            decoration: InputDecoration(
              border: normalBorder,
              enabledBorder: normalBorder,
              hintText: placeholder,
              hintStyle: TextStyle(color: styles.inputBorderColor),
              contentPadding: EdgeInsets.fromLTRB(15, 3, 3, 3),
            ),
            keyboardType: keyboardType,
            minLines: minLines,
            maxLines: maxLines,
          ),
        ),
      ],
    );
  }
}
