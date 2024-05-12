import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MealDetailsScreen extends StatefulWidget {
  final String mealId;

  MealDetailsScreen({required this.mealId});

  @override
  _MealDetailsScreenState createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends State<MealDetailsScreen> {
  Map<String, dynamic> mealDetails = {};

  @override
  void initState() {
    super.initState();
    fetchMealDetails(widget.mealId);
  }

  Future<void> fetchMealDetails(String mealId) async {
    final response = await http.get(Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/lookup.php?i=$mealId'));

    if (response.statusCode == 200) {
      setState(() {
        mealDetails = jsonDecode(response.body)['meals'][0];
      });
    } else {
      throw Exception('Failed to load meal details');
    }
  }

  Widget _buildYouTubeButton() {
    final mealYoutube = mealDetails['strYoutube'];

    if (mealYoutube.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: ElevatedButton(
          onPressed: () => launchUrl(Uri.parse(mealYoutube)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'View on YouTube',
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
              SizedBox(width: 8.0),
              Icon(Icons.play_circle_outline_rounded, color: Colors.white),
            ],
          ),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  8.0), // Ubah bentuk tombol menjadi kotak
            ),
            backgroundColor: Colors.blueAccent[700], // Ubah warna tombol
          ),
        ),
      );
    }

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    if (mealDetails.isEmpty) {
      return Center(
          child:
          CircularProgressIndicator()); // Display loading indicator while fetching data
    }

    String mealName = mealDetails['strMeal'];
    String mealThumb = mealDetails['strMealThumb'];
    String mealInstructions = mealDetails['strInstructions'];
    String mealCategory = mealDetails['strCategory'];
    String mealArea = mealDetails['strArea'];

    return Scaffold(
      appBar: AppBar(
        title: Text(mealName),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Fixed-height image row
            SizedBox(
              height: 400.0, // Adjust height as needed
              child: Card(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Image.network(
                  mealThumb,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start, // Align content to the left
                children: [
                  Row(
                    children: [
                      Text(
                        'Category:',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8.0),
                      Text(mealCategory, style: TextStyle(fontSize: 16.0)),
                      Spacer(),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Area:',
                    style:
                    TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  Text(mealArea, style: TextStyle(fontSize: 16.0)),
                  SizedBox(height: 16.0),
                  Text(
                    'Instructions:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      mealInstructions,
                      style: TextStyle(fontSize: 16.0),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
            ),
            _buildYouTubeButton(), // Add the YouTube button at the bottom
          ],
        ),
      ),
    );
  }
}
