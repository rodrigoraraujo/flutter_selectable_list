import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light().copyWith(
        //primarySwatch: Colors.white.,
        disabledColor: Colors.grey[900],
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                color: Colors.grey[900],
                fontSize: 22.0,
              ),
            ),
      ),
      home: CustomInheritedWidget(
        child: CustomWidget(),
      ),
    );
  }
}

enum ScreenMode { browse, edit }

class Model {
  final String title;
  final bool selected;

  Model({this.title, this.selected});
}

class CustomInheritedWidget extends InheritedWidget {
  CustomInheritedWidget({Widget child}) : super(child: child);

  final List<Model> selectedItems = [];
  final ValueNotifier<int> itemsLength = ValueNotifier(0);
  final ValueNotifier<ScreenMode> screenMode = ValueNotifier(ScreenMode.browse);

  static CustomInheritedWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CustomInheritedWidget>();
  }

  static void reset(BuildContext context) {
    CustomInheritedWidget.of(context).selectedItems.clear();
    CustomInheritedWidget.of(context).screenMode.value = ScreenMode.browse;
  }

  @override
  bool updateShouldNotify(CustomInheritedWidget oldWidget) =>
      oldWidget.selectedItems.length != selectedItems.length;
}

class CustomWidget extends StatefulWidget {
  @override
  _CustomWidgetState createState() => _CustomWidgetState();
}

class _CustomWidgetState extends State<CustomWidget> {
  static final data = List.generate(
    30,
    (index) => Model(
      title: 'Item ${index + 1}',
      selected: false,
    ),
  );

  bool _allItemsSelected;

  @override
  Widget build(BuildContext context) {
    Key listViewKey = UniqueKey();

    return ValueListenableBuilder(
        valueListenable: CustomInheritedWidget.of(context).itemsLength,
        builder: (context, _, __) {
          _allItemsSelected =
              CustomInheritedWidget.of(context).selectedItems.length ==
                  data.length;

          return ValueListenableBuilder(
            valueListenable: CustomInheritedWidget.of(context).screenMode,
            builder: (context, _, __) => Scaffold(
              appBar: CustomInheritedWidget.of(context).screenMode.value ==
                      ScreenMode.edit
                  ? AppBar(
                      backgroundColor: Colors.grey[500],
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          listViewKey = UniqueKey();
                          CustomInheritedWidget.reset(context);
                        },
                      ),
                      title: Text(
                        '${CustomInheritedWidget.of(context).selectedItems.length} selected',
                      ),
                      actions: [
                        IconButton(
                          icon: Icon(
                              _allItemsSelected ? Icons.clear : Icons.check),
                          onPressed: () {
                            listViewKey = UniqueKey();

                            CustomInheritedWidget.of(context)
                                .selectedItems
                                .clear();
                            CustomInheritedWidget.of(context)
                                .itemsLength
                                .value = 0;

                            if (!_allItemsSelected) {
                              CustomInheritedWidget.of(context)
                                  .itemsLength
                                  .value = data.length;

                              for (final model in data) {
                                CustomInheritedWidget.of(context)
                                    .selectedItems
                                    .add(
                                      Model(
                                        title: model.title,
                                        selected: true,
                                      ),
                                    );
                              }
                            }
                          },
                        ),
                        Visibility(
                          visible: CustomInheritedWidget.of(context)
                                  .selectedItems
                                  .length >
                              0,
                          child: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    )
                  : AppBar(
                      title: Text('List'),
                    ),
              body: SafeArea(
                key: listViewKey,
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) => CustomLIstItem(
                    title: data[index].title,
                    selected: CustomInheritedWidget.of(context)
                        .selectedItems
                        .firstWhere(
                          (element) => element.title == data[index].title,
                          orElse: () => Model(selected: false),
                        )
                        .selected,
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class CustomLIstItem extends StatefulWidget {
  final String title;
  final bool selected;

  CustomLIstItem({
    @required this.title,
    @required this.selected,
  });

  @override
  _CustomLIstItemState createState() => _CustomLIstItemState();
}

class _CustomLIstItemState extends State<CustomLIstItem> {
  bool _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading:
            _selected ? Icon(CupertinoIcons.check_mark_circled_solid) : null,
        selected: _selected,
        title: Text(
          widget.title,
          //style: Theme.of(context).textTheme.headline6,
        ),
        onLongPress: CustomInheritedWidget.of(context).screenMode.value ==
                ScreenMode.edit
            ? () {}
            : () {
                setState(() {
                  _selected = !_selected;
                });

                CustomInheritedWidget.of(context).screenMode.value =
                    ScreenMode.edit;
                final model = Model(title: widget.title, selected: true);
                CustomInheritedWidget.of(context).selectedItems.add(model);
              },
        onTap: CustomInheritedWidget.of(context).screenMode.value ==
                ScreenMode.edit
            ? () {
                setState(() {
                  _selected = !_selected;
                });

                final model = Model(title: widget.title, selected: _selected);

                if (_selected) {
                  CustomInheritedWidget.of(context).selectedItems.add(model);
                } else {
                  CustomInheritedWidget.of(context).selectedItems.removeWhere(
                        (element) => element.title == model.title,
                      );
                }

                if (CustomInheritedWidget.of(context).selectedItems.length ==
                    0) {
                  CustomInheritedWidget.reset(context);
                }

                CustomInheritedWidget.of(context).itemsLength.value =
                    CustomInheritedWidget.of(context).selectedItems.length;

                print(CustomInheritedWidget.of(context).selectedItems.length);
              }
            : () {});
  }
}
