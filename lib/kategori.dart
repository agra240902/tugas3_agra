import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tugas_3_agra/list.dart'; // Import the MealsList class

class Kategori extends StatefulWidget {
  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<Kategori> {
  List<dynamic> categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php'));

    if (response.statusCode == 200) {
      setState(() {
        categories = jsonDecode(response.body)['categories'];
      });
    } else {
      throw Exception('Failed to load categories');
    }
  }

  void navigateToMeals(String categoryName) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MealsList(categoryName: categoryName)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            String categoryName = categories[index]['strCategory'];
            String categoryThumb = categories[index]['strCategoryThumb'];
            String description = categories[index]['strCategoryDescription'];
            // Limit description to 30 words (adjust as needed)
            if (description.length > 300) {
              description = description.substring(0, 300) + "...";
            }

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Colors.primaries[index % Colors.primaries.length],
              elevation: 5,
              child: InkWell(
                onTap: () => navigateToMeals(categoryName),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        child: Image.network(categoryThumb,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 100),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      categoryName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
