import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ScrollToSectionPage(),
    );
  }
}

class ScrollToSectionPage extends StatefulWidget {
  @override
  _ScrollToSectionPageState createState() => _ScrollToSectionPageState();
}

class _ScrollToSectionPageState extends State<ScrollToSectionPage> {
  final ScrollController _scrollController = ScrollController();

  // Heights of each section
  final double section1Height = 500.0;
  final double section2Height = 500.0;
  final double section3Height = 500.0;

  void scrollToSection(int sectionIndex) {
    double position;

    // Calculate the scroll position based on the section index
    switch (sectionIndex) {
      case 1:
        position = 0;
        break;
      case 2:
        position = section1Height;
        break;
      case 3:
        position = section1Height + section2Height;
        break;
      default:
        position = 0;
    }

    _scrollController.animateTo(
      position,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scroll to Section'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => scrollToSection(1),
                child: Text('Go to Section 1'),
              ),
              ElevatedButton(
                onPressed: () => scrollToSection(2),
                child: Text('Go to Section 2'),
              ),
              ElevatedButton(
                onPressed: () => scrollToSection(3),
                child: Text('Go to Section 3'),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              controller: _scrollController,
              children: [
                Container(
                  height: section1Height,
                  color: Colors.red,
                  child: Center(
                      child: Text('Section 1 Details',
                          style: TextStyle(fontSize: 24))),
                ),
                Container(
                  height: section2Height,
                  color: Colors.green,
                  child: Center(
                      child: Text('Section 2 Details',
                          style: TextStyle(fontSize: 24))),
                ),
                Container(
                  height: section3Height,
                  color: Colors.blue,
                  child: Center(
                      child: Text('Section 3 Details',
                          style: TextStyle(fontSize: 24))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
