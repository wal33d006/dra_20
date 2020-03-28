import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';
import 'main.dart';

class RequestPage extends StatefulWidget {
  final LocationData location;
  RequestPage({this.location});
  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String name;
  String address;
  String contact;
  String familyMemberCount;
  String itemDesc;
  String priority = 'Tap to select priority';

  Geoflutterfire geo = Geoflutterfire();

  int _key;

  bool _isLoading = false;

  bool _isPrioritySelected = false;

  bool _isPriorityError = false;

  _collapse() {
    int newKey;
    do {
      _key = new Random().nextInt(10000);
    } while (newKey == _key);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _collapse();
//    _fetchCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request something'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ListView(
            children: <Widget>[
              ListTile(
                title: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    labelText: 'Name',
                  ),
                  validator: (value) {
                    if (value.isEmpty) return 'Name is required';
                    name = value;
                    return null;
                  },
                ),
              ),
              ListTile(
                title: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    labelText: 'Address',
                  ),
                  validator: (value) {
                    if (value.isEmpty) return 'Address is required';
                    address = value;
                    return null;
                  },
                ),
              ),
              ListTile(
                title: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    labelText: 'Contact number',
                  ),
                  validator: (value) {
                    if (value.isEmpty) return 'Name is required';
                    contact = value;
                    return null;
                  },
                ),
              ),
              ListTile(
                title: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    labelText: 'Number of family members',
                  ),
                  validator: (value) {
                    if (value.isEmpty) return 'Family member count is required';
                    familyMemberCount = value;
                    return null;
                  },
                ),
              ),
              ListTile(
                title: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      labelText: 'Item description',
                      helperText: 'Comma separated values for items'),
                  validator: (value) {
                    if (value.isEmpty) return 'Item description is required';
                    itemDesc = value;
                    return null;
                  },
                ),
              ),
              ExpansionTile(
                key: Key(_key.toString()),
                title: Text('Priority'),
                subtitle: Text(
                  priority,
                  style: TextStyle(
                      color: _isPriorityError ? Colors.red : Colors.grey[700]),
                ),
                leading: Icon(Icons.error_outline),
                children: <Widget>[
                  ListTile(
                    title: Text('High'),
                    onTap: () {
                      setState(() {
                        priority = 'high';
                        _collapse();
                        _isPrioritySelected = true;
                      });
                    },
                  ),
                  ListTile(
                    title: Text('Medium'),
                    onTap: () {
                      setState(() {
                        priority = 'medium';
                        _collapse();
                        _isPrioritySelected = true;
                      });
                    },
                  ),
                  ListTile(
                    title: Text('Low'),
                    onTap: () {
                      setState(() {
                        priority = 'low';
                        _collapse();
                        _isPrioritySelected = true;
                      });
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isLoading
            ? null
            : () async {
                setState(() {
                  _isPriorityError = false;
                });
                if (!_formKey.currentState.validate()) return;
                if (!_isPrioritySelected) {
                  setState(() {
                    _isPriorityError = true;
                  });
                  return;
                }
                setState(() {
                  _isLoading = true;
                });
                try {
                  GeoFirePoint myLocation = geo.point(
                    latitude: widget.location.latitude,
                    longitude: widget.location.longitude,
                  );
//                  print(_locationData.latitude);
                  await Firestore.instance
                      .collection('requests')
                      .document()
                      .setData(Item(
                        name: name,
                        address: address,
                        contact: contact,
                        familyMemberCount: familyMemberCount,
                        itemDetail: itemDesc,
                        priority: priority,
                        position: myLocation,
                      ).toJson());
                  Navigator.of(context).pop(true);
                } catch (ex) {
                  print(ex.message);
                } finally {
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
        icon: Icon(Icons.cloud_done),
        label: Text('Submit'),
      ),
    );
  }
}
