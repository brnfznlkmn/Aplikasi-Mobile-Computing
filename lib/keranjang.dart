import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class KeranjangPage extends StatefulWidget {
  @override
  _KeranjangPageState createState() => _KeranjangPageState();
}

class _KeranjangPageState extends State<KeranjangPage> {
  List keranjangLaptops = [];
  double subtotal = 0;

  @override
  void initState() {
    super.initState();
    fetchKeranjangLaptops();
  }

  Future<void> fetchKeranjangLaptops() async {
    final response = await http.get(Uri.parse(
        'https://mobilecomputing.my.id/api_brian/keranjang.php?action=read'));
    if (response.statusCode == 200) {
      setState(() {
        keranjangLaptops = (json.decode(response.body) as List).map((item) {
          item['quantity'] = 1; // Set default quantity to 1
          item['price'] = double.parse(item['price'].toString());
          return item;
        }).toList();
        calculateSubtotal();
      });
    }
  }

  void calculateSubtotal() {
    subtotal = keranjangLaptops.fold(
        0, (sum, item) => sum + item['quantity'] * item['price']);
  }

  Future<void> deleteKeranjangLaptops(int id) async {
    final response = await http.post(
      Uri.parse(
          'https://mobilecomputing.my.id/api_brian/keranjang.php?action=delete'),
      body: {'id': id.toString()},
    );

    if (response.statusCode == 200) {
      fetchKeranjangLaptops();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Laptop removed from keranjangs'),
        backgroundColor: Colors.green,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to remove Laptop from keranjangs'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> placeOrder() async {
    for (var laptop in keranjangLaptops) {
      await http.post(
        Uri.parse(
            'https://mobilecomputing.my.id/api_brian/orders.php?action=create'),
        body: {
          'id': laptop['id'].toString(),
          'quantity': laptop['quantity'].toString(),
          'date': DateTime.now().toString(),
          'subtotal': (laptop['quantity'] * laptop['price']).toString(),
        },
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Order placed successfully'),
      backgroundColor: Colors.green,
    ));
    setState(() {
      keranjangLaptops.clear();
      subtotal = 0;
    });
    fetchKeranjangLaptops(); // Refresh keranjang
  }

  String formatCurrency(double value) {
    return value.toStringAsFixed(0).replaceAll(RegExp(r'\.0+$'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: keranjangLaptops.isEmpty
                ? Center(child: Text('Tidak ada barang di keranjang'))
                : ListView.builder(
                    itemCount: keranjangLaptops.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.all(10.0),
                        child: ListTile(
                          leading: keranjangLaptops[index]['image'] != null
                              ? Image.network(
                                  'https://mobilecomputing.my.id/api_brian/${keranjangLaptops[index]['image']}',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  'assets/logo.png',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                          title: Text(keranjangLaptops[index]['name']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Harga: Rp ${formatCurrency(keranjangLaptops[index]['price'])}'),
                              Row(
                                children: [
                                  Text('Kuantitas: '),
                                  IconButton(
                                    icon: Icon(Icons.remove),
                                    onPressed: () {
                                      setState(() {
                                        if (keranjangLaptops[index]
                                                ['quantity'] >
                                            1) {
                                          keranjangLaptops[index]['quantity']--;
                                          calculateSubtotal();
                                        }
                                      });
                                    },
                                  ),
                                  Text(
                                      '${keranjangLaptops[index]['quantity']}'),
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                      setState(() {
                                        keranjangLaptops[index]['quantity']++;
                                        calculateSubtotal();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              deleteKeranjangLaptops(
                                  int.parse(keranjangLaptops[index]['id']));
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text('Subtotal: Rp ${formatCurrency(subtotal)}'),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: placeOrder,
                  child: Text('Pesan'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
