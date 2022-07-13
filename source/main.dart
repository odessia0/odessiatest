


  
   



import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
 


void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        scaffoldBackgroundColor: const Color(0xfff5f5f5),
        primarySwatch: Colors.blue,
      ),
      
    );
  }




  
  
    
    



 
  
    
  


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  bool status1 = false;
  bool status2 = true;
  bool status3 = false;
  bool status4 = false;
  bool status5 = false;
  bool status6 = false;
  bool status7 = false;
  bool status8 = false;
  bool isSwitchOn = false;
  double _value = 10;

  Color _textColor = Colors.black;
  Color _appBarColor = Color.fromRGBO(36, 41, 46, 1);
  Color _scaffoldBgcolor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        textTheme: TextTheme(
          bodyText1: TextStyle(color: _textColor),
          bodyText2: TextStyle(color: _textColor),
        ),
      ),
      child: Scaffold(
        backgroundColor: _scaffoldBgcolor,
        appBar: AppBar(
          backgroundColor: _appBarColor,
          title: Text(
            "Ayarlar Demo",
            style: TextStyle(color:Color.fromARGB(255, 255, 255, 255)),
          ),
          actions: [
            FlutterSwitch(
              value: isSwitchOn,
              onToggle: (value) {
                setState(() {
                  isSwitchOn = value;
                });
              },
            ),
          ],
        ),
        
       
        
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Padding(

                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      'Bot Aktifligi:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlutterSwitch(
                      showOnOff: true,
                      activeTextColor: Colors.black,
                      inactiveTextColor: Color.fromARGB(255, 61, 129, 179),
                      value: status3,
                      onToggle: (val) {
                        setState(() {
                          status3 = val;
                        });
                      },
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Value: $status3",
                      ),
                    ),
                  ],
                ),
            
                Padding(

                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Choose Position Side:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  

                 ToggleSwitch(
                    minWidth: 60.0,
                    minHeight: 60.0,
                    fontSize: 16.0,
                    initialLabelIndex: 4,
                    activeBgColor: [Color.fromARGB(255, 68, 188, 243)],
                    activeFgColor: Colors.white,
                    inactiveBgColor: Color.fromARGB(255, 156, 155, 155),
                    inactiveFgColor: Colors.grey[900],
                    totalSwitches: 3,
                    labels: ['Long', 'Short','Both' ],
                    onToggle: (index) {
                      print('switched to: $index');
                    },
                    
                  ),
                  
                  Padding(

                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Set Risk:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  
                  ToggleSwitch(
                    minWidth: 40.0,
                    minHeight: 45.0,
                    fontSize: 16.0,
                    initialLabelIndex: 19,
                    activeBgColor: [Color.fromARGB(255, 68, 188, 243)],
                    activeFgColor: Colors.white,
                    inactiveBgColor: Color.fromARGB(255, 156, 155, 155),
                    inactiveFgColor: Colors.grey[900],
                    totalSwitches: 5,
                    labels: ['0', '1','2','3','4', ],
                    onToggle: (index) {
                      print('switched to: $index');
                    },
                    
                  ),
Padding(

                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      'StopLoss:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
     
     
  
  SfSlider(
       min: 0,
       max: 100.0,
       stepSize:1,
       value: _value,
       interval: 10,
       activeColor: Colors.blue,
       inactiveColor:Colors.red,
       showTicks: true,
       showLabels: true,
    
       enableTooltip: true,
       minorTicksPerInterval: 0,
        
       onChanged: (dynamic value){
         setState(() {
           _value = value;
         });
       },
     ),

       Padding(

                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Set Leverage:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  
                  ToggleSwitch(
                    minWidth: 40.0,
                    minHeight: 45.0,
                    fontSize: 16.0,
                    initialLabelIndex: 21,
                    activeBgColor: [Color.fromARGB(255, 68, 188, 243)],
                    activeFgColor: Colors.white,
                    inactiveBgColor: Color.fromARGB(255, 156, 155, 155),
                    inactiveFgColor: Colors.grey[900],
                    totalSwitches: 20,
                    labels: ['1', '2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20' ],
                    onToggle: (index) {
                      print('switched to: $index');
                    },
                    
                  ), 
                  Padding(

                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Set Margin Type:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),          
                  
                  ToggleSwitch(
                    minWidth: 90.0,
                    minHeight: 65.0,
                    fontSize: 16.0,
                    initialLabelIndex: 4,
                    activeBgColor: [Color.fromARGB(255, 68, 188, 243)],
                    activeFgColor: Colors.white,
                    inactiveBgColor: Color.fromARGB(255, 156, 155, 155),
                    inactiveFgColor: Colors.grey[900],
                    totalSwitches: 2,
                    labels: ['Isolated', 'Crossed' ],
                    onToggle: (index) {
                      print('switched to: $index');
                    },
                    
                  ),

                  Padding(

                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Allow Repeating Signals:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),          
                  
                  ToggleSwitch(
                    minWidth: 50.0,
                    minHeight: 50.0,
                    fontSize: 16.0,
                    initialLabelIndex: 4,
                    activeBgColor: [Color.fromARGB(255, 52, 205, 243)],
                    activeFgColor: Color.fromARGB(255, 255, 255, 255),
                    inactiveBgColor: Color.fromARGB(255, 155, 148, 148),
                    inactiveFgColor: Colors.grey[900],
                    totalSwitches: 2,
                    labels: ['YES', 'NO' ],
                    onToggle: (index) {
                      print('switched to: $index');
                    },
                    
                  ),
                
                
                
                
                
                
                
                
                
              ],
            ),
          ),
        ),
      ),
    );
    
  }
  

 

  }
  

