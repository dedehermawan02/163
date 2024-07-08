import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'inventory.dart';
import 'api_service.dart';

void main() {
  runApp(MIGEApp());
}

class MIGEApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MIGE',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: InventoryList(),
    );
  }
}

class InventoryList extends StatefulWidget {
  @override
  _InventoryListState createState() => _InventoryListState();
}

class _InventoryListState extends State<InventoryList> {
  late Future<List<Inventory>> futureInventories;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    futureInventories = apiService.getInventories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MIGE - Inventori Gudang'),
      ),
      body: FutureBuilder<List<Inventory>>(
        future: futureInventories,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index].name),
                  subtitle: Text('Quantity: ${snapshot.data![index].quantity}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      apiService.deleteInventory(snapshot.data![index].id).then((value) {
                        setState(() {
                          futureInventories = apiService.getInventories();
                        });
                        Fluttertoast.showToast(msg: 'Item deleted successfully');
                      });
                    },
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddInventory(apiService: apiService)),
          ).then((value) {
            setState(() {
              futureInventories = apiService.getInventories();
            });
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddInventory extends StatefulWidget {
  final ApiService apiService;
  AddInventory({required this.apiService});

  @override
  _AddInventoryState createState() => _AddInventoryState();
}

class _AddInventoryState extends State<AddInventory> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Inventori'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nama'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nama';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Kuantitas'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan kuantitas';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Inventory newInventory = Inventory(
                      id: '', // ID akan diatur oleh server
                      name: _nameController.text,
                      quantity: int.parse(_quantityController.text),
                    );
                    widget.apiService.createInventory(newInventory).then((value) {
                      Navigator.pop(context);
                      Fluttertoast.showToast(msg: 'Item created successfully');
                    });
                  }
                },
                child: Text('Tambah'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
