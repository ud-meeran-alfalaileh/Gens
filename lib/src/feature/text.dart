import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;

  const ExpandableText({Key? key, required this.text}) : super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final displayText = _isExpanded || widget.text.length <= 20
        ? widget.text
        : '${widget.text.substring(0, 20)}...';

    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Text(
        displayText,
        style: TextStyle(color: Colors.blue),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: const Text('Expandable Text Example')),
      body: Center(
        child: ExpandableText(
          text:
              'This is an example of a long text that should be truncated and expanded when clicked.',
        ),
      ),
    ),
  ));
}
