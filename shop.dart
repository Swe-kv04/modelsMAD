import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Product {
  final String name;
  final double price;
  final String image;
  final String category;

  Product(
      {required this.name,
      required this.price,
      required this.image,
      required this.category});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Shopping App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ProductListPage(),
    );
  }
}

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<Product> allProducts = [
    Product(
        name: 'Shirt',
        price: 29.99,
        image: 'https://via.placeholder.com/150',
        category: 'Clothing'),
    Product(
        name: 'Laptop',
        price: 999.99,
        image: 'https://via.placeholder.com/150',
        category: 'Electronics'),
    Product(
        name: 'Shoes',
        price: 49.99,
        image: 'https://via.placeholder.com/150',
        category: 'Footwear'),
    Product(
        name: 'Jeans',
        price: 39.99,
        image: 'https://via.placeholder.com/150',
        category: 'Clothing'),
    Product(
        name: 'Headphones',
        price: 199.99,
        image: 'https://via.placeholder.com/150',
        category: 'Electronics'),
    Product(
        name: 'Sandals',
        price: 19.99,
        image: 'https://via.placeholder.com/150',
        category: 'Footwear'),
  ];

  List<Product> cart = [];
  String searchQuery = "";
  String selectedCategory = "All";

  List<String> categories = ['All', 'Clothing', 'Electronics', 'Footwear'];

  @override
  Widget build(BuildContext context) {
    List<Product> filteredProducts = allProducts
        .where((product) =>
            (selectedCategory == 'All' ||
                product.category == selectedCategory) &&
            product.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage(cart: cart)),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(hintText: 'Search products...'),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<String>(
              value: selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue!;
                });
              },
              items: categories.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                Product product = filteredProducts[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(product.image),
                    title: Text(product.name),
                    subtitle: Text('Rs${product.price.toStringAsFixed(2)}'),
                    trailing: IconButton(
                      icon: Icon(Icons.add_shopping_cart),
                      onPressed: () {
                        setState(() {
                          cart.add(product);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  final List<Product> cart;
  CartPage({required this.cart});

  @override
  Widget build(BuildContext context) {
    double totalPrice = cart.fold(0, (sum, item) => sum + item.price);

    return Scaffold(
      appBar: AppBar(title: Text("Shopping Cart")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final item = cart[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text("Rs${item.price.toStringAsFixed(2)}"),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_circle),
                    onPressed: () {
                      cart.removeAt(index);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CartPage(cart: cart)),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Total: Rs${totalPrice.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CheckoutPage(totalPrice: totalPrice)),
              );
            },
            child: Text("Proceed to Checkout"),
          ),
        ],
      ),
    );
  }
}

class CheckoutPage extends StatefulWidget {
  final double totalPrice;
  CheckoutPage({required this.totalPrice});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  void _submitOrder() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Order placed successfully!")),
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Checkout")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text("Total: Rs${widget.totalPrice.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Full Name"),
                validator: (value) =>
                    value!.isEmpty ? "Please enter your name" : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
                validator: (value) =>
                    value!.isEmpty ? "Please enter your email" : null,
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: "Shipping Address"),
                validator: (value) =>
                    value!.isEmpty ? "Please enter your address" : null,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submitOrder,
                child: Text("Submit Order"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
