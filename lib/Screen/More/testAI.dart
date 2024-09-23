import 'package:flutter/material.dart';
class Workout extends StatelessWidget {
  const Workout({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          constraints: const BoxConstraints.expand(),
          color: Color(0xFFFFFFFF),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  color: Color(0xFFF6F6F9),
                  width: double.infinity,
                  height: double.infinity,
                  child: SingleChildScrollView(
                      padding: const EdgeInsets.only( top: 31, left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only( bottom: 11),
                            child: Text(
                              "Good Morning 🔥",
                              style: TextStyle(
                                color: Color(0xFF192126),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only( bottom: 22),
                            child: Text(
                              "Thinh Ngoc Pham",
                              style: TextStyle(
                                color: Color(0xFF192126),
                                fontSize: 24,
                              ),
                            ),
                          ),
                          IntrinsicHeight(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Color(0xFFFFFFFF),
                              ),
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.only( bottom: 29, right: 20),
                              width: double.infinity,
                              child: Row(
                                  children: [
                                    IntrinsicHeight(
                                      child: Container(
                                        margin: const EdgeInsets.only( right: 16),
                                        width: 15,
                                        child: Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(2),
                                                        ),
                                                        height: 15,
                                                        width: double.infinity,
                                                        child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(2),
                                                            child: Image.network(
                                                              "https://i.imgur.com/1tMFzp8.png",
                                                              fit: BoxFit.fill,
                                                            )
                                                        )
                                                    ),
                                                  ]
                                              ),
                                              Positioned(
                                                bottom: 0,
                                                right: 0,
                                                width: 3,
                                                height: 3,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Color(0xFF8C9093),
                                                      width: 1,
                                                    ),
                                                    borderRadius: BorderRadius.circular(2),
                                                  ),
                                                  transform: Matrix4.translationValues(1, 1, 0),
                                                  width: 3,
                                                  height: 3,
                                                  child: SizedBox(),
                                                ),
                                              ),
                                            ]
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        width: double.infinity,
                                        child: Text(
                                          "Search",
                                          style: TextStyle(
                                            color: Color(0xFF192126),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only( bottom: 15),
                            child: Text(
                              "Popular Workouts",
                              style: TextStyle(
                                color: Color(0xFF192126),
                                fontSize: 18,
                              ),
                            ),
                          ),
                          IntrinsicHeight(
                            child: Container(
                              margin: const EdgeInsets.only( bottom: 29, right: 20),
                              width: double.infinity,
                              child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      IntrinsicHeight(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(23),
                                            gradient: LinearGradient(
                                              begin: Alignment(-1, 1),
                                              end: Alignment(1, -1),
                                              colors: [
                                                Color(0x80000000),
                                                Color(0x80000000),
                                              ],
                                            ),
                                          ),
                                          padding: const EdgeInsets.only( right: 20),
                                          margin: const EdgeInsets.only( right: 20),
                                          width: 280,
                                          child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                IntrinsicHeight(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        begin: Alignment(-1, 1),
                                                        end: Alignment(1, -1),
                                                        colors: [
                                                          Color(0xFF353535),
                                                          Color(0xFF4B4B4B),
                                                        ],
                                                      ),
                                                    ),
                                                    padding: const EdgeInsets.only( top: 27, bottom: 27, left: 20),
                                                    width: 147,
                                                    child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            margin: const EdgeInsets.only( bottom: 17),
                                                            width: double.infinity,
                                                            child: Text(
                                                              "Lower Body\nTraining",
                                                              style: TextStyle(
                                                                color: Color(0xFFFFFFFF),
                                                                fontSize: 24,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(9),
                                                              color: Color(0xCCFFFFFF),
                                                            ),
                                                            padding: const EdgeInsets.symmetric(vertical: 8),
                                                            margin: const EdgeInsets.only( bottom: 10),
                                                            width: 80,
                                                            height: 26,
                                                            child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Container(
                                                                      margin: const EdgeInsets.only( right: 7),
                                                                      width: 9,
                                                                      height: 11,
                                                                      child: Image.network(
                                                                        "https://i.imgur.com/1tMFzp8.png",
                                                                        fit: BoxFit.fill,
                                                                      )
                                                                  ),
                                                                  Text(
                                                                    "500 Kcal",
                                                                    style: TextStyle(
                                                                      color: Color(0xFF192126),
                                                                      fontSize: 12,
                                                                    ),
                                                                  ),
                                                                ]
                                                            ),
                                                          ),
                                                          Container(
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(9),
                                                              color: Color(0xCCFFFFFF),
                                                            ),
                                                            padding: const EdgeInsets.only( top: 8, bottom: 8, left: 11, right: 11),
                                                            width: 72,
                                                            height: 26,
                                                            child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Container(
                                                                    margin: const EdgeInsets.only( bottom: 1),
                                                                    width: 3,
                                                                    height: 1,
                                                                    child: SizedBox(),
                                                                  ),
                                                                  IntrinsicHeight(
                                                                    child: Container(
                                                                      width: double.infinity,
                                                                      child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Container(
                                                                                width: 9,
                                                                                height: 9,
                                                                                child: Image.network(
                                                                                  "https://i.imgur.com/1tMFzp8.png",
                                                                                  fit: BoxFit.fill,
                                                                                )
                                                                            ),
                                                                            Text(
                                                                              "50 Min",
                                                                              style: TextStyle(
                                                                                color: Color(0xFF192126),
                                                                                fontSize: 12,
                                                                              ),
                                                                            ),
                                                                          ]
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ]
                                                            ),
                                                          ),
                                                        ]
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                    width: 38,
                                                    height: 38,
                                                    child: Image.network(
                                                      "https://i.imgur.com/1tMFzp8.png",
                                                      fit: BoxFit.fill,
                                                    )
                                                ),
                                              ]
                                          ),
                                        ),
                                      ),
                                      IntrinsicHeight(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(23),
                                            gradient: LinearGradient(
                                              begin: Alignment(-1, 1),
                                              end: Alignment(1, -1),
                                              colors: [
                                                Color(0x80000000),
                                                Color(0x80000000),
                                              ],
                                            ),
                                          ),
                                          width: 280,
                                          child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      begin: Alignment(-1, 1),
                                                      end: Alignment(1, -1),
                                                      colors: [
                                                        Color(0xFF353535),
                                                        Color(0xFF4B4B4B),
                                                      ],
                                                    ),
                                                  ),
                                                  padding: const EdgeInsets.only( top: 27, bottom: 27, left: 20, right: 20),
                                                  width: 147,
                                                  height: 174,
                                                  child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          margin: const EdgeInsets.only( bottom: 17),
                                                          width: double.infinity,
                                                          child: Text(
                                                            "Hand\nTraining",
                                                            style: TextStyle(
                                                              color: Color(0xFFFFFFFF),
                                                              fontSize: 24,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(9),
                                                            color: Color(0xCCFFFFFF),
                                                          ),
                                                          padding: const EdgeInsets.only( top: 8, bottom: 8, left: 11, right: 11),
                                                          margin: const EdgeInsets.only( bottom: 10),
                                                          width: 80,
                                                          height: 26,
                                                          child: Row(
                                                              children: [
                                                                Container(
                                                                    margin: const EdgeInsets.only( right: 7),
                                                                    width: 9,
                                                                    height: 11,
                                                                    child: Image.network(
                                                                      "https://i.imgur.com/1tMFzp8.png",
                                                                      fit: BoxFit.fill,
                                                                    )
                                                                ),
                                                                Expanded(
                                                                  child: Container(
                                                                    width: double.infinity,
                                                                    child: Text(
                                                                      "600 Kcal",
                                                                      style: TextStyle(
                                                                        color: Color(0xFF192126),
                                                                        fontSize: 12,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ]
                                                          ),
                                                        ),
                                                        Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(9),
                                                            color: Color(0xCCFFFFFF),
                                                          ),
                                                          padding: const EdgeInsets.only( top: 8, bottom: 8, left: 11, right: 11),
                                                          width: 72,
                                                          height: 26,
                                                          child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Container(
                                                                  margin: const EdgeInsets.only( bottom: 1),
                                                                  width: 3,
                                                                  height: 1,
                                                                  child: SizedBox(),
                                                                ),
                                                                IntrinsicHeight(
                                                                  child: Container(
                                                                    width: double.infinity,
                                                                    child: Row(
                                                                        children: [
                                                                          Container(
                                                                              margin: const EdgeInsets.only( right: 7),
                                                                              width: 9,
                                                                              height: 9,
                                                                              child: Image.network(
                                                                                "https://i.imgur.com/1tMFzp8.png",
                                                                                fit: BoxFit.fill,
                                                                              )
                                                                          ),
                                                                          Expanded(
                                                                            child: Container(
                                                                              width: double.infinity,
                                                                              child: Text(
                                                                                "40 Min",
                                                                                style: TextStyle(
                                                                                  color: Color(0xFF192126),
                                                                                  fontSize: 12,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ]
                                                                    ),
                                                                  ),
                                                                ),
                                                              ]
                                                          ),
                                                        ),
                                                      ]
                                                  ),
                                                ),
                                              ]
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only( bottom: 15),
                            child: Text(
                              "Today Plan",
                              style: TextStyle(
                                color: Color(0xFF192126),
                                fontSize: 18,
                              ),
                            ),
                          ),
                          IntrinsicHeight(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(23),
                                color: Color(0xFFFFFFFF),
                              ),
                              padding: const EdgeInsets.only( bottom: 10),
                              margin: const EdgeInsets.only( bottom: 20, right: 20),
                              width: double.infinity,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        margin: const EdgeInsets.only( top: 10, right: 12),
                                        width: 100,
                                        height: 100,
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.circular(16),
                                            child: Image.network(
                                              "https://i.imgur.com/1tMFzp8.png",
                                              fit: BoxFit.fill,
                                            )
                                        )
                                    ),
                                    IntrinsicHeight(
                                      child: Container(
                                        width: 209,
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                color: Color(0xFF192126),
                                                padding: const EdgeInsets.symmetric(vertical: 5),
                                                margin: const EdgeInsets.only( bottom: 11),
                                                width: 81,
                                                height: 19,
                                                child: Column(
                                                    children: [
                                                      Text(
                                                        "Intermediate",
                                                        style: TextStyle(
                                                          color: Color(0xFFFFFFFF),
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                    ]
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only( bottom: 11, left: 2),
                                                child: Text(
                                                  "Push Up",
                                                  style: TextStyle(
                                                    color: Color(0xFF192126),
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only( bottom: 16, left: 1),
                                                child: Text(
                                                  "100 Push up a day",
                                                  style: TextStyle(
                                                    color: Color(0xFF192126),
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ),
                                              IntrinsicHeight(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(3),
                                                    color: Color(0xFFF2F2F2),
                                                  ),
                                                  width: double.infinity,
                                                  child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(3),
                                                            color: Color(0xFFBBF246),
                                                          ),
                                                          padding: const EdgeInsets.symmetric(vertical: 5),
                                                          width: 65,
                                                          height: 16,
                                                          child: Column(
                                                              children: [
                                                                Text(
                                                                  "45%",
                                                                  style: TextStyle(
                                                                    color: Color(0xFF192126),
                                                                    fontSize: 8,
                                                                  ),
                                                                ),
                                                              ]
                                                          ),
                                                        ),
                                                      ]
                                                  ),
                                                ),
                                              ),
                                            ]
                                        ),
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                          ),
                          IntrinsicHeight(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(26),
                                color: Color(0xFFFFFFFF),
                              ),
                              padding: const EdgeInsets.only( bottom: 10),
                              margin: const EdgeInsets.only( bottom: 20, right: 20),
                              width: double.infinity,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(19),
                                        ),
                                        margin: const EdgeInsets.only( top: 10, right: 12),
                                        width: 100,
                                        height: 100,
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.circular(19),
                                            child: Image.network(
                                              "https://i.imgur.com/1tMFzp8.png",
                                              fit: BoxFit.fill,
                                            )
                                        )
                                    ),
                                    IntrinsicHeight(
                                      child: Container(
                                        width: 209,
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                color: Color(0xFF192126),
                                                padding: const EdgeInsets.symmetric(vertical: 5),
                                                margin: const EdgeInsets.only( bottom: 7),
                                                width: 61,
                                                height: 19,
                                                child: Column(
                                                    children: [
                                                      Text(
                                                        "Beginner",
                                                        style: TextStyle(
                                                          color: Color(0xFFFFFFFF),
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                    ]
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only( bottom: 12, left: 1),
                                                child: Text(
                                                  "Sit Up",
                                                  style: TextStyle(
                                                    color: Color(0xFF192126),
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only( bottom: 19, left: 1),
                                                child: Text(
                                                  "20 Sit up a day",
                                                  style: TextStyle(
                                                    color: Color(0xFF192126),
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ),
                                              IntrinsicHeight(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(3),
                                                    color: Color(0xFFF2F2F2),
                                                  ),
                                                  width: double.infinity,
                                                  child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(3),
                                                            color: Color(0xFFBBF246),
                                                          ),
                                                          padding: const EdgeInsets.only( top: 5, bottom: 5, left: 50, right: 50),
                                                          width: 185,
                                                          height: 16,
                                                          child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  "90%",
                                                                  style: TextStyle(
                                                                    color: Color(0xFF192126),
                                                                    fontSize: 8,
                                                                  ),
                                                                ),
                                                              ]
                                                          ),
                                                        ),
                                                      ]
                                                  ),
                                                ),
                                              ),
                                            ]
                                        ),
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                          ),
                          IntrinsicHeight(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(26),
                                color: Color(0xFFFFFFFF),
                              ),
                              padding: const EdgeInsets.only( bottom: 10),
                              margin: const EdgeInsets.only( right: 20),
                              width: double.infinity,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    IntrinsicHeight(
                                      child: Container(
                                        margin: const EdgeInsets.only( top: 10, right: 14),
                                        width: 100,
                                        child: Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(19),
                                                        ),
                                                        height: 100,
                                                        width: double.infinity,
                                                        child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(19),
                                                            child: Image.network(
                                                              "https://i.imgur.com/1tMFzp8.png",
                                                              fit: BoxFit.fill,
                                                            )
                                                        )
                                                    ),
                                                  ]
                                              ),
                                              Positioned(
                                                bottom: 6,
                                                left: 0,
                                                width: 340,
                                                height: 64,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(32),
                                                    color: Color(0xFF192126),
                                                  ),
                                                  padding: const EdgeInsets.only( left: 14, right: 14),
                                                  transform: Matrix4.translationValues(-5, 0, 0),
                                                  width: 340,
                                                  height: 64,
                                                  child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        IntrinsicHeight(
                                                          child: Container(
                                                            margin: const EdgeInsets.only( top: 14),
                                                            width: double.infinity,
                                                            child: Row(
                                                                children: [
                                                                  IntrinsicHeight(
                                                                    child: Container(
                                                                      decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(43),
                                                                        color: Color(0xFFBBF246),
                                                                      ),
                                                                      padding: const EdgeInsets.symmetric(vertical: 6),
                                                                      margin: const EdgeInsets.only( right: 18),
                                                                      width: 114,
                                                                      child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          children: [
                                                                            Container(
                                                                                margin: const EdgeInsets.only( right: 5),
                                                                                width: 24,
                                                                                height: 24,
                                                                                child: Image.network(
                                                                                  "https://i.imgur.com/1tMFzp8.png",
                                                                                  fit: BoxFit.fill,
                                                                                )
                                                                            ),
                                                                            Text(
                                                                              "Workout",
                                                                              style: TextStyle(
                                                                                color: Color(0xFF192126),
                                                                                fontSize: 13,
                                                                              ),
                                                                            ),
                                                                          ]
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                      width: 24,
                                                                      height: 24,
                                                                      child: Image.network(
                                                                        "https://i.imgur.com/1tMFzp8.png",
                                                                        fit: BoxFit.fill,
                                                                      )
                                                                  ),
                                                                  Expanded(
                                                                    child: Container(
                                                                      width: double.infinity,
                                                                      child: SizedBox(),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    padding: const EdgeInsets.all(4),
                                                                    margin: const EdgeInsets.only( right: 54),
                                                                    width: 20,
                                                                    height: 20,
                                                                    child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Container(
                                                                              width: 5,
                                                                              height: 8,
                                                                              child: Image.network(
                                                                                "https://i.imgur.com/1tMFzp8.png",
                                                                                fit: BoxFit.fill,
                                                                              )
                                                                          ),
                                                                          Container(
                                                                              width: 5,
                                                                              height: 13,
                                                                              child: Image.network(
                                                                                "https://i.imgur.com/1tMFzp8.png",
                                                                                fit: BoxFit.fill,
                                                                              )
                                                                          ),
                                                                        ]
                                                                    ),
                                                                  ),
                                                                  IntrinsicHeight(
                                                                    child: Container(
                                                                      width: 16,
                                                                      child: Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Container(
                                                                                margin: const EdgeInsets.only( bottom: 3, left: 4, right: 4),
                                                                                height: 8,
                                                                                width: double.infinity,
                                                                                child: Image.network(
                                                                                  "https://i.imgur.com/1tMFzp8.png",
                                                                                  fit: BoxFit.fill,
                                                                                )
                                                                            ),
                                                                            Container(
                                                                              decoration: BoxDecoration(
                                                                                border: Border.all(
                                                                                  color: Color(0xFFFFFFFF),
                                                                                  width: 1,
                                                                                ),
                                                                                borderRadius: BorderRadius.circular(20),
                                                                              ),
                                                                              height: 6,
                                                                              width: double.infinity,
                                                                              child: SizedBox(),
                                                                            ),
                                                                          ]
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ]
                                                            ),
                                                          ),
                                                        ),
                                                      ]
                                                  ),
                                                ),
                                              ),
                                            ]
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only( top: 22, right: 39),
                                      child: Text(
                                        "Knee Push Up",
                                        style: TextStyle(
                                          color: Color(0xFF192126),
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    IntrinsicHeight(
                                      child: Container(
                                        color: Color(0xFF192126),
                                        padding: const EdgeInsets.symmetric(vertical: 5),
                                        width: 61,
                                        child: Column(
                                            children: [
                                              Text(
                                                "Beginner",
                                                style: TextStyle(
                                                  color: Color(0xFFFFFFFF),
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ]
                                        ),
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}