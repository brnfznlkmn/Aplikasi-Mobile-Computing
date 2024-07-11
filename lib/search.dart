import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List laptops = [];
  List filteredLaptops = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchLaptops();
    searchController.addListener(() {
      filterLaptops();
    });
  }

  Future<void> fetchLaptops() async {
    final response = await http.get(Uri.parse(
        'https://mobilecomputing.my.id/api_brian/laptop.php?action=read'));
    if (response.statusCode == 200) {
      setState(() {
        laptops = json.decode(response.body);
        filteredLaptops = laptops;
      });
    }
  }

  void filterLaptops() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredLaptops = laptops.where((laptop) {
        return laptop['name'].toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> addKeranjangLaptop(int id) async {
    final response = await http.post(
      Uri.parse(
          'https://mobilecomputing.my.id/api_brian/keranjang.php?action=create'),
      body: {'id': id.toString()},
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Laptop added to keranjang'),
        backgroundColor: Colors.green,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to add Laptop to keranjang'),
        backgroundColor: Colors.red,
      ));
    }
  }

  void showLaptopDetails(Map laptop) {
    int quantity = 1;
    TextEditingController quantityController =
        TextEditingController(text: quantity.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(laptop['name']),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                laptop['image'] != null
                    ? Image.network(
                        'https://mobilecomputing.my.id/api_brian/${laptop['image']}',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/logo.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                SizedBox(height: 10),
                Text('Deskripsi: ${laptop['description']}'),
                SizedBox(height: 10),
                Text('Harga: ${laptop['price']}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: filteredLaptops.isEmpty
          ? Center(child: Text('No laptops found'))
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio:
                    0.70, // Adjusted aspect ratio to prevent overflow
              ),
              itemCount: filteredLaptops.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(10.0),
                  child: InkWell(
                    onTap: () {
                      showLaptopDetails(filteredLaptops[index]);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        filteredLaptops[index]['image'] != null
                            ? Image.network(
                                'https://mobilecomputing.my.id/api_brian/${filteredLaptops[index]['image']}',
                                width: double.infinity,
                                height: 120,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/logo.png',
                                width: double.infinity,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10.0),
                              Text(
                                filteredLaptops[index]['name'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Center(
                                child: Text(
                                  NumberFormat.currency(
                                          locale: 'id',
                                          symbol: 'Rp ',
                                          decimalDigits: 0)
                                      .format(int.parse(
                                          filteredLaptops[index]['price'])),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.shopping_cart),
                                    onPressed: () {
                                      addKeranjangLaptop(int.parse(
                                          filteredLaptops[index]['id']));
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
