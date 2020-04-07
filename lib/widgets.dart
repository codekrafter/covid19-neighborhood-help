import 'package:country_pickers/countries.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';

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
          ),
        ),
      ],
    );
  }
}

class PhoneNumberField extends StatefulWidget {
  PhoneNumberField({@required this.countryCode, this.onSelected, Key key})
      : assert(countryCode != null),
        super(key: key);

  final Function(Country) onSelected;
  final String countryCode;

  @override
  _PhoneNumberFieldState createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: 'Your phone number',
            style: styles.textFieldNameStyle,
            children: [
              TextSpan(text: ' *', style: styles.requiredMarkStyle),
            ],
          ),
        ),
        SizedBox(height: 10),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OutlineButton(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flags.getMiniFlag(
                        countryList
                            .firstWhere((c) => c.phoneCode == "${widget.countryCode}")
                            .isoCode,
                        null,
                        null),
                    SizedBox(width: 10),
                    Text(
                      '+${widget.countryCode}',
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                    SizedBox(width: 5),
                    SizedBox(
                      width: 15,
                      child: Icon(
                        Icons.expand_more,
                        color: styles.requestBlue,
                        size: 25,
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => Theme(
                      data: Theme.of(context).copyWith(primaryColor: Colors.pink),
                      child: CountryPickerDialog(
                        titlePadding: EdgeInsets.all(8.0),
                        searchCursorColor: Colors.pinkAccent,
                        searchInputDecoration: InputDecoration(hintText: 'Search...'),
                        isSearchable: true,
                        title: Text('Select your phone code'),
                        onValuePicked:
                            (widget.onSelected != null) ? widget.onSelected : (country) {},
                        itemFilter: (c) => [
                          'AD',
                          'AE',
                          'AF',
                          'AG',
                          'AI',
                          'AL',
                          'AM',
                          'AO',
                          'AR',
                          'AS',
                          'AT',
                          'AU',
                          'AW',
                          'AX',
                          'AZ',
                          'BA',
                          'BB',
                          'BD',
                          'BE',
                          'BF',
                          'BG',
                          'BH',
                          'BI',
                          'BJ',
                          'BL',
                          'BM',
                          'BN',
                          'BO',
                          'BR',
                          'BS',
                          'BT',
                          'BV',
                          'BW',
                          'BY',
                          'BZ',
                          'CA',
                          'CC',
                          'CD',
                          'CF',
                          'CG',
                          'CH',
                          'CI',
                          'CK',
                          'CL',
                          'CM',
                          'CN',
                          'CO',
                          'CR',
                          'CU',
                          'CV',
                          'CW',
                          'CX',
                          'CY',
                          'CZ',
                          'DE',
                          'DJ',
                          'DK',
                          'DM',
                          'DO',
                          'DZ',
                          'EC',
                          'EE',
                          'EG',
                          'ER',
                          'ES',
                          'ET',
                          'EU',
                          'FI',
                          'FJ',
                          'FK',
                          'FM',
                          'FO',
                          'FR',
                          'GA',
                          'GB',
                          'GB-ENG',
                          'GB-NIR',
                          'GB-SCT',
                          'GB-WLS',
                          'GB-ZET',
                          'GD',
                          'GE',
                          'GF',
                          'GG',
                          'GH',
                          'GI',
                          'GL',
                          'GM',
                          'GN',
                          'GP',
                          'GQ',
                          'GR',
                          'GS',
                          'GT',
                          'GU',
                          'GW',
                          'GY',
                          'HK',
                          'HM',
                          'HN',
                          'HR',
                          'HT',
                          'HU',
                          'ID',
                          'IE',
                          'IL',
                          'IM',
                          'IN',
                          'IO',
                          'IQ',
                          'IR',
                          'IS',
                          'IT',
                          'JE',
                          'JM',
                          'JO',
                          'JP',
                          'KE',
                          'KG',
                          'KH',
                          'KI',
                          'KM',
                          'KN',
                          'KP',
                          'KR',
                          'KW',
                          'KY',
                          'KZ',
                          'LA',
                          'LB',
                          'LC',
                          'LGBT',
                          'LI',
                          'LK',
                          'LR',
                          'LS',
                          'LT',
                          'LU',
                          'LV',
                          'LY',
                          'MA',
                          'MC',
                          'MD',
                          'ME',
                          'MF',
                          'MG',
                          'MH',
                          'MK',
                          'ML',
                          'MM',
                          'MN',
                          'MO',
                          'MP',
                          'MQ',
                          'MR',
                          'MS',
                          'MT',
                          'MU',
                          'MV',
                          'MW',
                          'MX',
                          'MY',
                          'MZ',
                          'NA',
                          'NC',
                          'NE',
                          'NF',
                          'NG',
                          'NI',
                          'NL',
                          'NO',
                          'NP',
                          'NR',
                          'NU',
                          'NZ',
                          'OM',
                          'PA',
                          'PE',
                          'PF',
                          'PG',
                          'PH',
                          'PK',
                          'PL',
                          'PM',
                          'PN',
                          'PR',
                          'PS',
                          'PT',
                          'PW',
                          'PY',
                          'QA',
                          'RE',
                          'RO',
                          'RS',
                          'RU',
                          'RW',
                          'SA',
                          'SB',
                          'SC',
                          'SD',
                          'SE',
                          'SG',
                          'SH',
                          'SI',
                          'SJ',
                          'SK',
                          'SL',
                          'SM',
                          'SN',
                          'SO',
                          'SR',
                          'SS',
                          'ST',
                          'SV',
                          'SX',
                          'SY',
                          'SZ',
                          'TC',
                          'TD',
                          'TF',
                          'TG',
                          'TH',
                          'TJ',
                          'TK',
                          'TL',
                          'TM',
                          'TN',
                          'TO',
                          'TR',
                          'TT',
                          'TV',
                          'TW',
                          'TZ',
                          'UA',
                          'UG',
                          'UM',
                          'US',
                          'US-CA',
                          'UY',
                          'UZ',
                          'VA',
                          'VC',
                          'VE',
                          'VG',
                          'VI',
                          'VN',
                          'VU',
                          'WF',
                          'WS',
                          'XK',
                          'YE',
                          'YT',
                          'ZA',
                          'ZM',
                          'ZW'
                        ].contains(c.isoCode),
                        priorityList: [
                          CountryPickerUtils.getCountryByIsoCode('TR'),
                          CountryPickerUtils.getCountryByIsoCode('US'),
                        ],
                        itemBuilder: (country) => ListTile(
                          leading: Flags.getMiniFlag(country.isoCode.toUpperCase(), null, null),
                          title: Text(country.name),
                          trailing: Text('+${country.phoneCode}'),
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(width: 15),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    border:
                        OutlineInputBorder(borderSide: BorderSide(color: styles.inputBorderColor)),
                    enabledBorder:
                        OutlineInputBorder(borderSide: BorderSide(color: styles.inputBorderColor)),
                    focusedBorder:
                        OutlineInputBorder(borderSide: BorderSide(color: styles.requestBlue)),
                    hintText: '',
                    hintStyle: TextStyle(color: styles.inputBorderColor),
                    contentPadding: EdgeInsets.fromLTRB(15, 2, 3, 2),
                  ),
                  cursorColor: styles.requestBlue,
                  keyboardType: TextInputType.phone,
                  onChanged: (val) => null,
                  onEditingComplete: () => null,
                  //focusNode: _focus,
                  //controller: _controller,
                ),
              ),
            ],
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
