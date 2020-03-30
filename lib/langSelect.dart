import 'package:flutter/material.dart';
import 'package:flag/flag.dart';

class LanguageSelect extends StatelessWidget {
  const LanguageSelect({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(Localizations.localeOf(context).countryCode);
    return Row(
      children: [
        Flags.getMiniFlag(Localizations.localeOf(context).countryCode.toUpperCase(), null, null),
        SizedBox(width: 8),
        Text(
          Localizations.localeOf(context).languageCode.toUpperCase(),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        //SizedBox(width: 8),
        GestureDetector(
          child: Icon(
            Icons.expand_more,
            color: Colors.white,
            size: 30,
          ),
          onTap: () {},
        ),
        SizedBox(width: 15),
      ],
    );
  }
}
