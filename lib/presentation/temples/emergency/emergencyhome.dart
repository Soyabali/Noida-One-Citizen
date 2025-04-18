
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:puri/app/generalFunction.dart';
import 'package:puri/presentation/temples/emergency/policeStation.dart';
import 'hospital.dart';

class EmergencyHome extends StatefulWidget {

  const EmergencyHome({super.key});

  @override
  State<EmergencyHome> createState() => _FacilitiesHomeState();
}

class _FacilitiesHomeState extends State<EmergencyHome> with SingleTickerProviderStateMixin {

  TabController? _tabController;
  GeneralFunction generalFunction = GeneralFunction();

  final List<Map<String, String>> itemList = [
    {'image': 'https://www.drishtiias.com/images/uploads/1698053713_image1.png','temple': 'Jagannath Temple'},
    {'image': 'https://s3.ap-southeast-1.amazonaws.com/images.deccanchronicle.com/dc-Cover-hinohp2v89f6sovfrqk7d6bfj7-20231002122234.Medi.jpeg','temple': 'PanchaTirtha'},
    {'image': 'https://images.indianexpress.com/2021/08/Puri-temple-1.jpeg','temple': 'Lokanath Temple'},
    {'image': 'https://t4.ftcdn.net/jpg/03/57/53/11/360_F_357531159_cumH01clbXOo32Ytvkb7qGYspCJjj4gB.jpg','temple': 'Vimala Temple'},
    {'image': 'https://w0.peakpx.com/wallpaper/672/441/HD-wallpaper-puri-jagannath-temple-cloud.jpg','temple': 'Varahi Temple'},
  ];


  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        // appBar
        appBar: getAppBar("Emergency"),
        drawer: generalFunction.drawerFunction(context,'Suaib Ali','9871950881'),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TabBar(
                        controller: _tabController,
                        indicatorColor: Colors.transparent,
                        labelColor: Colors.red,
                        isScrollable:true,
                        //labelPadding: EdgeInsets.symmetric(horizontal: 20.0),
                        labelPadding: EdgeInsets.only(left: 20,right: 40),
                        unselectedLabelColor: Colors.black45,

                        tabs: const [
                          Tab(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image(image: AssetImage("assets/images/facilities.png"),
                                  height: 25,
                                  width: 25,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(height: 2),
                                Text('HOSPITAL',style: TextStyle(fontSize: 12),)
                              ],
                            ),
                          ),
                          Tab(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image(image: AssetImage("assets/images/policefade.png"),
                                  height: 25,width: 25,
                                  fit: BoxFit.cover,),
                                SizedBox(height: 2),
                                Text('POLICE STATIION',style: TextStyle(fontSize: 12),)
                              ],
                            ),
                          ),
                          // Tab(
                          //   child: Column(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     children: [
                          //       Image(image: AssetImage("assets/images/administrationfade.png"),height: 25,width: 25,
                          //         fit: BoxFit.cover,),
                          //       SizedBox(height: 2),
                          //       Text('ADMINISTRATION',style: TextStyle(fontSize: 12),)
                          //     ],
                          //   ),
                          // ),


                        ]),
                  ),
                  SizedBox(height: 5),
                  Container(
                    height: MediaQuery.of(context).size.height - 50.0,
                    width:  double.infinity,
                    child: TabBarView(
                      controller: _tabController,
                      children: const <Widget>[
                        /// here you put gallery code
                        // CookiePage(),
                        Hospital(),
                        PoliceStation(),
                       // Administration(),
                      ],
                    ),
                  ),
                  SizedBox(height: 50),

                ]
            ),
          ),
        )
      // ],
    );
  }
}
