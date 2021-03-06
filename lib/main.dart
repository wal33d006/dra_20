import 'package:dra_20/request_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  Location location = new Location();
  Geoflutterfire geo = Geoflutterfire();
  bool _isLoading = false;

  String _disasterName = '...';
  double _radius = 10.0;

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _fetchCurrentLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
  }

  @override
  void initState() {
    super.initState();
    _populateRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_disasterName),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _items == null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Unable to fetch requests',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .title
                          .copyWith(color: Colors.grey),
                    ),
                  ),
                )
              : _items.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Looks like everyone around has been served well =]',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .title
                              .copyWith(color: Colors.grey),
                        ),
                      ),
                    )
                  : ListView.builder(
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
                                color: item.priority == 'high'
                                    ? Colors.red
                                    : Colors.orange,
                              ),
                              Expanded(
                                child: ListTile(
                                  isThreeLine: true,
                                  title: Text(item.itemDetail),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(item.address),
                                      Text(
                                          'Family members: ${item.familyMemberCount}')
                                    ],
                                  ),
                                  trailing: Column(
                                    children: <Widget>[
                                      GestureDetector(
                                          child: Icon(Icons.call),
                                          onTap: () async =>
                                              _makePhoneCall('tel:${item.contact}')),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
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
        onPressed: () async {
          bool isRequested = false;
          isRequested = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => RequestPage(
                location: _locationData,
              ),
            ),
          );
          if (isRequested) _populateRequests();
        },
        tooltip: 'Increment',
        icon: Icon(Icons.fastfood),
        label: Text('Request something'),
      ),
    );
  }

  void _populateRequests() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _getDisasterDetail();
      await _fetchCurrentLocation();

      var collectionReference = Firestore.instance.collection('requests');
      GeoFirePoint myLocation = geo.point(
        latitude: _locationData.latitude,
        longitude: _locationData.longitude,
      );
      String field = 'position';

      var docs = await geo
          .collection(collectionRef: collectionReference)
          .within(center: myLocation, radius: _radius, field: field)
          .first;
//    var docs = (await collectionReference.getDocuments()).documents;
      for (var doc in docs) {
        _items.add(Item.fromSnapshot(doc));
      }
      setState(() {});
    } catch (ex) {
      print(ex);
      setState(() {
        _items = null;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future _getDisasterDetail() async {
    var disasterDetail = await Firestore.instance.collection('config').document('disasterDetail').get();
    setState(() {
      _disasterName = disasterDetail.data['name'];
      _radius = double.tryParse(disasterDetail.data['radius'].toString());
    });
  }
}

class Item {
  final String name;
  final String contact;
  final String address;
  final String itemDetail;
  final String familyMemberCount;
  final String priority;
  final GeoFirePoint position;
  final DocumentReference reference;

  Item({
    this.name,
    this.address,
    this.contact,
    this.familyMemberCount,
    this.itemDetail,
    this.priority,
    this.reference,
    this.position,
  });

  Item.fromMap(Map<String, dynamic> map, {this.reference})
      : name = map['name'],
        contact = map['contact'],
        address = map['address'],
        itemDetail = map['item'],
        familyMemberCount = map['familyMemberCount'],
        position = null,
        priority = map['priority'];

  Map<String, dynamic> toJson() => {
        "name": name,
        "contact": contact,
        "address": address,
        "item": itemDetail,
        "familyMemberCount": familyMemberCount,
        "priority": priority,
        "position": position.data,
      };

  Item.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
