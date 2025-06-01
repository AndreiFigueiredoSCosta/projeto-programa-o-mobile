import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TelaExercicio extends StatefulWidget {
  const TelaExercicio({super.key});

  @override
  State<TelaExercicio> createState() => _TelaExercicioState();
}

class _TelaExercicioState extends State<TelaExercicio> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Supino",
            style: TextStyle(
                color: Colors.white
            ),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF700000),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 25,
            ),
            onPressed: () {},
          ),
        ),
        backgroundColor: Colors.black26,
        body: Center(
          child: Container(
            width: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FloatingActionButton(
                      onPressed: (){},
                      backgroundColor: Color(0xFF700000),
                      child: Icon(
                        Icons.trending_up,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                    Row(
                      children: [
                        FloatingActionButton(
                          onPressed: (){},
                          backgroundColor: Color(0xFF700000),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        FloatingActionButton(
                          onPressed: (){},
                          backgroundColor: Color(0xFF700000),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 25,
                          ),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  "3 séries",
                  style: TextStyle(
                    fontSize: 20
                  ),
                ),
                Text(
                  "8-12 reps",
                  style: TextStyle(
                      fontSize: 20
                  ),
                ),
                Text(
                  "3 min de descanso",
                  style: TextStyle(
                      fontSize: 20
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse in ullamcorper ligula. Vivamus pharetra libero in dui laoreet, et venenatis elit hendrerit. Nam non molestie tortor. Cras libero odio, tincidunt et tincidunt quis, mollis venenatis felis. Donec facilisis venenatis ullamcorper.",
                  style: TextStyle(
                      fontSize: 20
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
