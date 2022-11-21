import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class MovieModel with ChangeNotifier {
  String movieName = "No Result Found",
      year = "",
      poster = "",
      rating = "",
      genre = "",
      plot = "";

  void getProvider(String movieTitle) async {
    /*ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Progress"), title: const Text("Searching..."));
    progressDialog.show();*/

    var apiid = "be897ed";
    var url = Uri.parse(
        'http://www.omdbapi.com/?t=$movieTitle&apikey=$apiid&units=metric');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = response.body;
      var parsedData = json.decode(jsonData);
      movieName = parsedData['Title'];
      year = parsedData['Year'];
      poster = parsedData['Poster'];
      rating = parsedData['Ratings'][0]['Value'];
      genre = parsedData['Genre'];
      plot = parsedData['Plot'];
      notifyListeners();
    }
  }
}
