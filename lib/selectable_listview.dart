import 'package:flutter/material.dart';

class SelectableListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(),
    );
  }
}

class SelectableListViewItem extends StatefulWidget {
  final String title;
  final bool selected;

  SelectableListViewItem({this.title, this.selected = false});

  @override
  _SelectableListViewItemState createState() => _SelectableListViewItemState();
}

class _SelectableListViewItemState extends State<SelectableListViewItem> {
  bool _selected;
  final selectedColor = Colors.blue;
  final unselectedColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      selected: _selected,
      title: Text(widget.title),
      value: _selected,
      onChanged: (value) {
        setState(() {
          _selected = value;
        });
      },
    );
  }
}
