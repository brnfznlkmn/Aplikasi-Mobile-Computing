import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddLaptopPage extends StatefulWidget {
  @override
  _AddLaptopPageState createState() => _AddLaptopPageState();
}

class _AddLaptopPageState extends State<AddLaptopPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  List categories = [];
  File? _image;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<void> createLaptop() async {
    final String name = _nameController.text;
    final String description = _descriptionController.text;
    final String price = _priceController.text;

    if (name.isEmpty ||
        description.isEmpty ||
        price.isEmpty ||
        _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('All fields and image are required'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    final request = http.MultipartRequest(
      'POST',
      Uri.parse(
          'https://mobilecomputing.my.id/api_brian/laptop.php?action=create'),
    );

    request.fields['name'] = name;
    request.fields['description'] = description;
    request.fields['price'] = price;
    request.files.add(await http.MultipartFile.fromPath('image', _image!.path));

    final response = await request.send();

    final responseBody = await response.stream.bytesToString();
    print('Response status: ${response.statusCode}');
    print('Response body: $responseBody');

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Laptop created successfully'),
        backgroundColor: Colors.green,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image'),
              ),
              _image != null ? Image.file(_image!) : Container(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: createLaptop,
                child: Text('Add Laptop'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditLaptopPage extends StatefulWidget {
  final Map laptop;

  EditLaptopPage({required this.laptop});

  @override
  _EditLaptopPageState createState() => _EditLaptopPageState();
}

class _EditLaptopPageState extends State<EditLaptopPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  List categories = [];
  File? _image;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.laptop['name'];
    _descriptionController.text = widget.laptop['description'];
    _priceController.text = widget.laptop['price'].toString();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<void> updateLaptop() async {
    final String name = _nameController.text;
    final String description = _descriptionController.text;
    final String price = _priceController.text;

    if (name.isEmpty || description.isEmpty || price.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('All fields are required'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    final request = http.MultipartRequest(
      'POST',
      Uri.parse(
          'https://mobilecomputing.my.id/api_brian/laptop.php?action=update'),
    );

    request.fields['id'] = widget.laptop['id'].toString();
    request.fields['name'] = name;
    request.fields['description'] = description;
    request.fields['price'] = price;

    if (_image != null) {
      request.files
          .add(await http.MultipartFile.fromPath('image', _image!.path));
    }

    final response = await request.send();

    final responseBody = await response.stream.bytesToString();
    print('Response status: ${response.statusCode}');
    print('Response body: $responseBody');

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Laptop updated successfully'),
        backgroundColor: Colors.green,
      ));
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Laptop'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image'),
              ),
              _image != null
                  ? Image.file(_image!)
                  : widget.laptop['image'] != null
                      ? Image.network(
                          'https://mobilecomputing.my.id/api_brian/${widget.laptop['image']}',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        )
                      : Container(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateLaptop,
                child: Text('Update Laptop'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
