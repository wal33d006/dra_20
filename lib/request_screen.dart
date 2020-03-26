import 'package:flutter/material.dart';

class RequestPage extends StatefulWidget {
  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request something'),
      ),
      body: Form(
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
                ),
              ),
              ListTile(
                title: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    labelText: 'Address',
                  ),
                ),
              ),
              ListTile(
                title: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    labelText: 'Contact number',
                  ),
                ),
              ),
              ListTile(
                title: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    labelText: 'Family members',
                  ),
                ),
              ),
              ListTile(
                title: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    labelText: 'Item',
                  ),
                ),
              ),
              ExpansionTile(
                title: Text('Priority'),
                leading: Icon(Icons.error_outline),
                children: <Widget>[
                  ListTile(
                    title: Text('High'),
                  ),
                  ListTile(
                    title: Text('Medium'),
                  ),
                  ListTile(
                    title: Text('Low'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        tooltip: 'Increment',
        icon: Icon(Icons.cloud_done),
        label: Text('Submit'),
      ),
    );
  }
}
