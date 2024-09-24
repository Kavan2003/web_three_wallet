import 'package:flutter/material.dart';

class MnemonicDisplay extends StatelessWidget {
  final String mnemonic;

  const MnemonicDisplay({super.key, required this.mnemonic});

  @override
  Widget build(BuildContext context) {
    List<String> words = mnemonic.split(' ');

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.teal.shade800
            : Colors.teal.shade50,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: words.map((word) {
          return Container(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.teal.shade700
                  : Colors.teal.shade100,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              word,
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
