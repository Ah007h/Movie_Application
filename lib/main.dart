import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Devil Movies App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController input = TextEditingController();

  var output = "";
  var _poster = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 125, 57, 57),
      appBar: AppBar(
        title: const Center(child: Text('Devil Of Movies App')),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20.0,
              ),
              SizedBox(
                width: 350,
                child: TextField(
                  controller: input,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 186, 81, 81),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide.none),
                    hintText: "eg. The GodFhater",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      onPressed: input.clear,
                      icon: const Icon(Icons.clear),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: _loadMovie,
                  child: const Text("Search"),
                ),
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(1),
                  margin: const EdgeInsets.all(35),
                  child: Column(
                    children: [
                      Image.network(
                        _poster,
                        height: 220,
                        width: 150,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                              height: 220,
                              width: 150,
                              'assets/images/Devil_P.jfif');
                        },
                      ),
                      Card(
                        color: const Color.fromARGB(255, 236, 197, 195),
                        child: Column(
                          children: [
                            Text(
                              output,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 82, 25, 25),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _loadMovie() async {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Progress"), title: const Text("Searching..."));

    progressDialog.show();

    String numa = input.text;
    var apiid = "e4d67e89";
    var url =
        Uri.parse('http://www.omdbapi.com/?t=$numa&apikey=$apiid&units=metric');

    var response = await http.get(url);
    var rescode = response.statusCode;
    var jsonData = response.body;
    var parsedJson = json.decode(jsonData);
    if (parsedJson['Title'] != null) {
      setState(() {
        var poster = parsedJson['Poster'];
        var title = parsedJson['Title'];
        var released = parsedJson['Released'];
        var ImdbRating = parsedJson['imdbRating'];
        var genre = parsedJson['Genre'];
        var language = parsedJson["Language"];
        var plot = parsedJson['Plot'];
        output =
            'Movie Name: $title. \n Released: $released.\n Genre: $genre. \n Language: $language.\n \tStory:  $plot. \n IMDbRating: ($ImdbRating).';
        _poster = '$poster';
        Fluttertoast.showToast(
            msg: "Found",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: const Color.fromARGB(255, 55, 13, 10),
            fontSize: 16.0);
      });
    } else {
      setState(() {
        Fluttertoast.showToast(
            msg: "not Found",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            fontSize: 16.0);
        output = "No response";
      });
    }
    progressDialog.dismiss();
  }
}
