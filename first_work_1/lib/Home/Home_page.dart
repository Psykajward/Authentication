import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'items.dart';

class HomePage extends StatefulWidget {
  final User? user; // Change User to User? to accept nullable User objects

  HomePage({this.user}); // Update the constructor to accept nullable User objects

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User? loggedInUser;
  late List<Item> items;
  late List<Item> filteredItems;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    initializeFirebase();
    _searchController = TextEditingController();
    items = [
      Item(
        title: 'Blue T-Shirt',
        description: 'Comfortable cotton shirt',
        image: 'images/11.jpg',
        price: '\$20',
      ),
      Item(
        title: 'Black Leather Bag',
        description: 'Spacious and stylish bag',
        image: 'images/22.jpg',
        price: '\$50',
      ),
      // Add more items as needed
    ];
    filteredItems = items;
  }

  Future<void> initializeFirebase() async {
    try {
      await Firebase.initializeApp();
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        setState(() {
          loggedInUser = currentUser;
        });
        print(loggedInUser);
      }
    } catch (e) {
      print(e);
    }
  }

  void filterItems(String searchText) {
    setState(() {
      filteredItems = items
          .where((item) =>
          item.title.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Search'),
                    content: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        filterItems(value);
                      },
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(), // Initialize Firebase only once
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  elevation: 4.0,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(12.0),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        items[index].image,
                        width: 80.0,
                        height: 80.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      items[index].title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4.0),
                        Text(
                          items[index].description,
                          style: TextStyle(fontSize: 14.0),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          'Price: ${items[index].price}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.favorite_border),
                      onPressed: () {
                        // Implement favorite button functionality
                      },
                    ),
                    onTap: () {
                      // Handle tapping on an item
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
