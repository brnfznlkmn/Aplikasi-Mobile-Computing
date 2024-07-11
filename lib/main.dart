import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'laptop.dart';
import 'keranjang.dart';
import 'profile.dart';
import 'search.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expert Laptop Store',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;

  Future<void> _login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    final response = await http.post(
      Uri.parse('https://mobilecomputing.my.id/api_brian/login.php'),
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('username', username);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Login Berhasil'),
          backgroundColor: Colors.green,
        ));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Login Gagal'),
          backgroundColor: Colors.red,
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.reasonPhrase}')),
      );
    }
  }

  Widget _buildUsernameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Username',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 60.0,
          child: TextField(
            controller: _usernameController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.black,
              ),
              hintText: 'Enter your Username',
              hintStyle: TextStyle(
                color: Colors.black,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 60.0,
          child: TextField(
            controller: _passwordController,
            obscureText: true,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.black,
              ),
              hintText: 'Enter your Password',
              hintStyle: TextStyle(
                color: Colors.black,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        onPressed: _login,
        child: Text(
          'LOGIN',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF73AEF5),
                      Color(0xFF61A4F1),
                      Color(0xFF478DE0),
                      Color(0xFF398AE5),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 120.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/logo.png', // pastikan Anda memiliki file gambar logo di folder assets Anda
                        height: 100,
                      ),
                      SizedBox(height: 30.0),
                      Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      _buildUsernameTF(),
                      SizedBox(height: 30.0),
                      _buildPasswordTF(),
                      SizedBox(
                          height:
                              30.0), // Menambahkan jarak antara password dan login button
                      _buildLoginBtn(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    HomePage(),
    SearchPage(),
    AddLaptopPage(),
    KeranjangPage(),
    ProfilePage(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expert Laptop Store'),
        backgroundColor: Color(0xFF398AE5),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            backgroundColor: Color(0xFF398AE5),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            backgroundColor: Color(0xFF398AE5),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            backgroundColor: Color(0xFF398AE5),
            label: 'Add Laptop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            backgroundColor: Color(0xFF398AE5),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_pin),
            backgroundColor: Color(0xFF398AE5),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List laptops = [];
  Map<int, String> branchNames = {};

  @override
  void initState() {
    super.initState();
    fetchLaptops();
  }

  Future<void> fetchLaptops() async {
    final response = await http.get(Uri.parse(
        'https://mobilecomputing.my.id/api_brian/laptop.php?action=read'));
    if (response.statusCode == 200) {
      setState(() {
        laptops = json.decode(response.body);
      });
    }
  }

  Future<void> deleteLaptop(int id) async {
    final response = await http.post(
      Uri.parse(
          'https://mobilecomputing.my.id/api_brian/laptop.php?action=delete'),
      body: {'id': id.toString()},
    );

    if (response.statusCode == 200) {
      fetchLaptops();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Laptop deleted successfully'),
        backgroundColor: Colors.green,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete Laptop'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> addKeranjangLaptop(int id) async {
    final response = await http.post(
      Uri.parse(
          'https://mobilecomputing.my.id/api_brian/keranjang.php?action=create'),
      body: {'id': id.toString()},
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Laptop added to keranjangs'),
        backgroundColor: Colors.green,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to add Laptop to keranjangs'),
        backgroundColor: Colors.red,
      ));
    }
  }

  void navigateToEditLaptop(Map laptop) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditLaptopPage(laptop: laptop),
      ),
    ).then((value) {
      if (value == true) {
        fetchLaptops();
      }
    });
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
      body: laptops.isEmpty
          ? Center(child: Text('Tidak ada data laptops'))
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio:
                    0.70, // Adjusted aspect ratio to prevent overflow
              ),
              itemCount: laptops.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(10.0),
                  child: InkWell(
                    onTap: () {
                      showLaptopDetails(laptops[index]);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        laptops[index]['image'] != null
                            ? Image.network(
                                'https://mobilecomputing.my.id/api_brian/${laptops[index]['image']}',
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
                                laptops[index]['name'],
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
                                      .format(
                                          int.parse(laptops[index]['price'])),
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
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      navigateToEditLaptop(laptops[index]);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      deleteLaptop(
                                          int.parse(laptops[index]['id']));
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.shopping_cart),
                                    onPressed: () {
                                      addKeranjangLaptop(
                                          int.parse(laptops[index]['id']));
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
