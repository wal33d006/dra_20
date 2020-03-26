import 'package:dra_20/request_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: MyHomePage(title: 'COVID-19'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Item> _items = List<Item>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _populateRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
          itemCount: _items.length,
          itemBuilder: (context, index) {
            var item = _items[index];
            return Card(
              elevation: 4.0,
              child: Row(
                children: <Widget>[
                  Container(
                    width: 5.0,
                    height: 86.0,
                    color: item.priority == 'high' ? Colors.red : Colors.orange,
                  ),
                  Expanded(
                    child: ListTile(
                      isThreeLine: true,
                      title: Text(item.itemDetail),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(item.address),
                          Text('Family members: ${item.familyMemberCount}')
                        ],
                      ),
                      trailing: Column(
                        children: <Widget>[
                          Icon(Icons.call),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Icon(Icons.location_on),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => RequestPage(),
            ),
          );
        },
        tooltip: 'Increment',
        icon: Icon(Icons.fastfood),
        label: Text('Request something'),
      ),
    );
  }

  void _populateRequests() {
    _items.addAll(<Item>[
      Item(
        name: 'Waleed',
        address: 'House no 76, Rashid minhas road Karachi',
        contact: '03123434321',
        familyMemberCount: '3',
        itemDetail: 'Rice',
        priority: 'high',
      ),
      Item(
        name: 'Waleed',
        address: 'House no 45, F11 Islamabad',
        contact: '03123434321',
        familyMemberCount: '6',
        itemDetail: 'Flour',
        priority: 'low',
      ),
      Item(
        name: 'Waleed',
        address: 'House no 98, DHA 6 Karachi',
        contact: '03123434321',
        familyMemberCount: '2',
        itemDetail: 'Daal',
        priority: 'low',
      ),
      Item(
        name: 'Waleed',
        address: 'House no 76, Rashid minhas road Karachi',
        contact: '03123434321',
        familyMemberCount: '4',
        itemDetail: 'Sugar',
        priority: 'high',
      ),
    ]);
  }
}

class Item {
  final String name;
  final String contact;
  final String address;
  final String itemDetail;
  final String familyMemberCount;
  final String priority;

  Item({
    this.name,
    this.address,
    this.contact,
    this.familyMemberCount,
    this.itemDetail,
    this.priority,
  });
}
