import 'package:flutter/material.dart';
import 'package:frontend/Route%20Page/route_item.dart';
import 'package:frontend/Route%20Page/route_lesson_item.dart';
import 'package:frontend/const.dart' as constaint;
import 'package:http/http.dart' as http;
import 'dart:convert';

class RouteDetail extends StatefulWidget {
  final String description;
  final String routeId;

  const RouteDetail(
      {super.key, required this.description, required this.routeId});

  @override
  State<RouteDetail> createState() => _RouteDetailState();
}

class _RouteDetailState extends State<RouteDetail> {
  late List customLessonsData = [];
  late List courseLessonData = [];
  late int completeLessonsCount = 0;
  late int totalLessonCount = 1;

  Future<void> fetchRouteDetail(String routeId) async {
    Map<String, String> headers = {
      'Content-Type':
          'application/json', // Set the content type for POST request
      // Add other headers if needed
    };

    Map<String, dynamic> postData = {'routeId': routeId};

    try {
      final response = await http.post(
        Uri.parse('${constaint.apiUrl}/studyRoute/getStudyRouteDetail'),
        headers: headers,
        body: jsonEncode(postData), // Encode the POST data to JSON
      );

      if (response.statusCode == 200) {
        // Successfully fetched data
        final jsonData = json.decode(response.body);
        final routeDetailData = jsonData['data'];

        setState(() {
          customLessonsData = routeDetailData['customLessons'];
          courseLessonData = routeDetailData['lessonData'];

          completeLessonsCount = customLessonsData
              .where((element) => element['isCompleted'] == true)
              .length;
          totalLessonCount = courseLessonData.length;
        });
      } else {
        // Request failed with an error status code
        print('Failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      // Catch and handle any errors that occur during the API call
      print('Error: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRouteDetail(widget.routeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Route Detail",
          style: TextStyle(fontSize: 16),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/bg1.jpg"), fit: BoxFit.cover),
        ),
        padding: EdgeInsets.all(8),
        width: MediaQuery.of(context).size.width,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          //description
          Container(
            padding: EdgeInsets.all(8),

            //width: MediaQuery.of(context).size.width * 0.95,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 241, 241, 241),
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(8)),
            child: Text(
              widget.description,
              style: TextStyle(fontSize: 16),
            ),
          ),

          //progress
          Container(
            height: 75,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Complete " +
                      completeLessonsCount.toString() +
                      "/" +
                      totalLessonCount.toString() +
                      " lessons",
                  style: TextStyle(fontSize: 20),
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.amber,
                      border: Border.all(color: Colors.black, width: 1)),
                  child: Center(
                    child: Text(
                      ((completeLessonsCount / totalLessonCount).ceil() * 100).toString() + "%",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black, width: 1)),
            ),
          ),

          //list lesson
          Expanded(
            child: ListView.builder(
                itemBuilder: (context, index) {
                  return RouteLessonItem(index: index, lessonId: customLessonsData[index]['lessonId'], routeId:  widget.routeId, title: courseLessonData[index]['title']);
                },
                itemCount: customLessonsData.length),
          )
        ]),
      ),
    );
  }
}
