import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../../resources/app_icons.dart';

class TestPage extends StatefulWidget {
  static const routName = '/test';

  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  List _elements = [
    {'name': 'John', 'group': DateTime(2022, 08, 24)},
    {'name': 'Will', 'group': DateTime(2022, 08, 23)},
    {'name': 'Beth', 'group': DateTime(2022, 08, 23)},
    {'name': 'Miranda', 'group': DateTime(2022, 08, 20)},
    {'name': 'Mike', 'group': DateTime(2022, 08, 20)},
    {'name': 'Danny', 'group': DateTime(2022, 08, 24)},
  ];


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Grouped List View Example'),
        ),
        body: GroupedListView<dynamic, String>(
          elements: _elements,
          groupBy: (element) => element['group'].toString(),
          groupComparator: (value1, value2) => value1.compareTo(value2),
          itemComparator: (item1, item2) =>
              item1['name'].compareTo(item2['name']),
          order: GroupedListOrder.DESC,
          //useStickyGroupSeparators: false,
          groupSeparatorBuilder: (String value) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          itemBuilder: (c, element) {
            return Card(
              elevation: 8.0,
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Container(
                child: ListTile(
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  leading: Icon(Icons.account_circle),
                  title: Text(element['name']),
                  trailing: Icon(Icons.arrow_forward),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
