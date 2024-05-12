import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tugas_3_agra/details.dart';

class MealsList extends StatefulWidget {
  final String categoryName;

  MealsList({required this.categoryName});

  @override
  _MealsListState createState() => _MealsListState();
}

class _MealsListState extends State<MealsList> {
  List<dynamic> meals = [];

  @override
  void initState() {
    super.initState();
    fetchMeals(widget.categoryName);
  }

  Future<void> fetchMeals(String categoryName) async {
    final response = await http.get(Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/filter.php?c=$categoryName'));

    if (response.statusCode == 200) {
      setState(() {
        meals = jsonDecode(response.body)['meals'];
      });
    } else {
      throw Exception('Failed to load meals');
    }
  }

  void navigateToMealDetails(String mealId) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MealDetailsScreen(mealId: mealId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meals for ${widget.categoryName}'),
      ),
      body: GridView.builder(
        itemCount: meals.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Change this to adjust the number of columns
          childAspectRatio:
          1, // Adjust this to control the aspect ratio of each tile
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          String mealName = meals[index]['strMeal'];
          if (mealName.length > 40) {
            mealName = mealName.substring(0, 40) + "...";
          }
          String mealThumb = meals[index]['strMealThumb'];
          String mealId = meals[index]['idMeal'];

          return GestureDetector(
            onTap: () => navigateToMealDetails(mealId),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Color.fromARGB(
                255,
                (index * 10) % 256,
                (index * 15) % 256,
                (index * 20) % 256,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      child: Image.network(
                        mealThumb,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      mealName,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
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
