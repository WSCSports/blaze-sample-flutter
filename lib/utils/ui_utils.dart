import 'package:flutter/material.dart';

Padding buildTitleListItems(
  String title,
  BuildContext context,
  Widget Function()? nextScreenProvider,
) {
  return Padding(
    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w800,
          ),
        ),
        InkWell(
          onTap: () {
            if (nextScreenProvider != null) {
              final nextScreen = nextScreenProvider();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => nextScreen),
              );
            }
          },
          child: const Text(
            "View more",
            style: TextStyle(
              color: Colors.black,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    ),
  );
}
