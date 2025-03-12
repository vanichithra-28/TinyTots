import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        children: [
          Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 400.0, left: 100),
                child: Container(
                  
                  height: 150,
                  width: 545,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      const Color(0xFffffffc), // Golden
                      Color(0xFFffffff),
                    ], begin: Alignment.centerLeft, end: Alignment.centerRight),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  child: Text(
                    'welcome',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xffffffff),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        height: 400,
                        width: 400,
                        child: Text(
                          'ddhefh',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xffffffff),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        height: 400,
                        width: 400,
                        child: Text(
                          'ddhefh',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              Container(
                height: 500,
                width: 270,
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                child: Text(
                  'calendar',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
