import 'package:flutter_project1/page/calendar.dart';
import 'package:flutter_project1/page/CreatEvent_page.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentTab = 0;
  final List<Widget> screens = [
    const CreatEvent(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = CreatEvent();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      floatingActionButton: FloatingActionButton(
        
        onPressed: () {
        setState(() {
          currentScreen = CreatEvent();
          currentTab = 4;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
         children: [
          Icon(
            Icons.school_outlined,
            color: Color.fromARGB(255, 26, 125, 206),
          ),
          Text(
            'FSTT',
            style: TextStyle(
              color: currentTab == 4 ? Colors.greenAccent : Colors.blue,
            ),
          ),
        ],
      ),
    ),
      
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 100,
                    onPressed: () {
                      setState(() {
                        currentScreen = CreatEvent();
                        currentTab = 4;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.format_list_bulleted_add,
                          color: currentTab == 4 ? Colors.greenAccent : Colors.blue,
                        ),
                        Text(
                          'Events',
                          style: TextStyle(
                            color: currentTab == 4 ? Colors.greenAccent : Colors.blue,
                          ),
                        )
                      ],
                    ),
                  ),
                  // MaterialButton(
                  //   minWidth: 40,
                  //   onPressed: () {
                  //     setState(() {
                  //       currentScreen = ChatPage();
                  //       currentTab = 1;
                  //     });
                  //   },
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Icon(
                  //         Icons.chat,
                  //         color: currentTab == 1 ? Colors.blue : Colors.grey,
                  //       ),
                  //       Text(
                  //         'Chat',
                  //         style: TextStyle(
                  //           color: currentTab == 1 ? Colors.blue : Colors.grey,
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 100,
                    onPressed: () {
                      setState(() {
                        currentScreen = Calendar();
                        currentTab = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_month,
                          color: currentTab == 3 ? Colors.greenAccent : Colors.blue,
                        ),
                        Text(
                          'calendrier',
                          style: TextStyle(
                            color: currentTab == 3 ? Colors.greenAccent : Colors.blue,
                          ),
                        )
                      ],
                    ),
                  ),
                  
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
