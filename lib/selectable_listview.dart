import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectableListView extends StatelessWidget {
  final List<String> data;
  final int selectedIndex;

  SelectableListView({
    @required this.data,
    @required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.all(8.0),
          child: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        actions: [
          FlatButton.icon(
            icon: Icon(Icons.check_box),
            label: Text('Select all'),
            onPressed: () {},
          ),
          FlatButton.icon(
            icon: Icon(CupertinoIcons.delete),
            label: Text('Delete all'),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(

        children: data
            .map(
              (item) => SelectableListViewItem(
                title: item,
                selected: item == data[selectedIndex],
              ),
            )
            .toList(),
      ),
    );
  }
}

class SelectableListViewItem extends StatefulWidget {
  final String title;
  final bool selected;

  SelectableListViewItem({
    @required this.title,
    this.selected = false,
  });

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
