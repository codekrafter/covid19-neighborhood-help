import 'package:country_pickers/countries.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'styles.dart' as styles;

final customTextFieldNormalBorder =
    OutlineInputBorder(borderSide: BorderSide(color: styles.inputBorderColor));

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
      this.errorText,
      this.onChanged,
      this.inputFormatters,
      Key key})
      : assert(placeholder != null),
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
  final String errorText;
  final Function(String) onChanged;
  final List<TextInputFormatter> inputFormatters;

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  String _currentValue;
  final _focus = FocusNode();
  final _controller = TextEditingController();
  bool _modified = false;

  @override
  void initState() {
    super.initState();

    _currentValue = widget.initialValue != null ? widget.initialValue : "";
    _controller.text = _currentValue;
    _focus.addListener(() {
      if (widget.onEditingCompleted != null) widget.onEditingCompleted(_currentValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_modified) {
      if (widget.initialValue != null && widget.initialValue != _controller.text) {
        _currentValue = widget.initialValue;
        _controller.text = _currentValue;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.name != null)
          RichText(
            text: TextSpan(text: widget.name, style: styles.textFieldNameStyle, children: [
              if (widget.isRequired) TextSpan(text: ' *', style: styles.requiredMarkStyle),
            ]),
          ),
        if (widget.name != null) SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 3),
          child: TextField(
            decoration: InputDecoration(
              border: customTextFieldNormalBorder,
              enabledBorder: customTextFieldNormalBorder,
              focusedBorder: customTextFieldNormalBorder.copyWith(
                  borderSide: BorderSide(color: styles.requestBlue)),
              hintText: widget.placeholder,
              hintStyle: TextStyle(color: styles.inputBorderColor),
              contentPadding: EdgeInsets.fromLTRB(
                  15, 5, 3, (widget.keyboardType == TextInputType.multiline) ? 10 : 3),
              errorText: widget.errorText,
            ),
            cursorColor: styles.requestBlue,
            keyboardType: widget.keyboardType,
            minLines: widget.minLines,
            maxLines: widget.maxLines,
            onChanged: (val) {
              _modified = true;
              _currentValue = val;
              if (widget.onChanged != null) widget.onChanged(val);
            },
            onEditingComplete: () {
              if (widget.onEditingCompleted != null) widget.onEditingCompleted(_currentValue);
            },
            focusNode: _focus,
            controller: _controller,
            inputFormatters: widget.inputFormatters,
          ),
        ),
      ],
    );
  }
}

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class RadioRow extends StatelessWidget {
  const RadioRow(
      {@required this.label, @required this.value, @required this.groupValue, this.onChanged, key})
      : assert(label != null),
        assert(value != null),
        assert(groupValue != null),
        super(key: key);

  final String label;
  final String value;
  final String groupValue;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged ?? (val) {},
          activeColor: styles.requestBlue,
        ),
        GestureDetector(
          child: Text(label),
          onTap: () => (onChanged != null) ? onChanged(value) : null,
        ),
      ],
    );
  }
}

class CheckboxRow extends StatelessWidget {
  const CheckboxRow({@required this.label, @required this.value, this.onChanged, key})
      : assert(label != null),
        assert(value != null),
        super(key: key);

  final String label;
  final bool value;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged ?? (val) {},
          activeColor: styles.requestBlue,
        ),
        GestureDetector(
          child: Text(label),
          onTap: () => (onChanged != null) ? onChanged(!value) : null,
        ),
      ],
    );
  }
}

class PhoneNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue
  ) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = StringBuffer();
    if (newTextLength >= 1) {
      newText.write('(');
      if (newValue.selection.end >= 1)
        selectionIndex++;
    }
    if (newTextLength >= 4) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 3) + ') ');
      if (newValue.selection.end >= 3)
        selectionIndex += 2;
    }
    if (newTextLength >= 7) {
      newText.write(newValue.text.substring(3, usedSubstringIndex = 6) + '-');
      if (newValue.selection.end >= 6)
        selectionIndex++;
    }
    if (newTextLength >= 11) {
      newText.write(newValue.text.substring(6, usedSubstringIndex = 10) + ' ');
      if (newValue.selection.end >= 10)
        selectionIndex++;
    }
    // Dump the rest.
    if (newTextLength >= usedSubstringIndex)
      newText.write(newValue.text.substring(usedSubstringIndex));
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
