import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: SafeArea(
          child: SelectableListView(),
        ),
      ),
    );
  }
}

enum ScreenMode { edit, browse }

class SelectableListView extends StatefulWidget {
  @override
  _SelectableListViewState createState() => _SelectableListViewState();
}

class _SelectableListViewState extends State<SelectableListView> {
  final listSelectableItems = List.generate(
    20,
    (index) => SelectableListViewItem(
      title: 'Item $index',
    ),
  );

  List<Widget> listTileItems;
  List<Widget> currentList;
  ScreenMode mode = ScreenMode.browse;

  @override
  void initState() {
    super.initState();

    listTileItems = List.generate(
      20,
      (index) => ListTile(
        title: Text('Item $index'),
        onLongPress: () {
          setState(() {
            currentList = List.generate(
              20,
              (i) => SelectableListViewItem(
                title: 'Item $i',
                selected: index == i,
              ),
            );
            mode = ScreenMode.edit;
          });
        },
      ),
    );

    currentList = listTileItems;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: mode == ScreenMode.edit,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.close,
                ),
                onPressed: () {
                  setState(() {
                    currentList = listTileItems;
                    mode = ScreenMode.browse;
                  });
                },
              ),
              FlatButton.icon(
                icon: Icon(Icons.delete),
                label: Text('Delete all'),
                onPressed: () {},
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: listSelectableItems.length,
              itemBuilder: (context, index) => currentList[index]),
        ),
      ],
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
      // onTap: (){
      //  setState(() {
      //    _selected = false;
      //  });
      // },
      // onLongPress: () {
      //   setState(() {
      //     _selected = !_selected;
      //   });
    );
  }
}
