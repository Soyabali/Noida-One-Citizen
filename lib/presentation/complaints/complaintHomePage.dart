
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/generalFunction.dart';
import '../../services/citizenMyPostedComplaint.dart';
import '../changePassword/changePassword.dart';
import '../notification/notification.dart';
import '../onlineComplaint/onlineComplaint.dart';
import '../potholedetection/potholeDetection.dart';
import '../resources/app_text_style.dart';
import 'grievanceStatus/grievanceStatus.dart';


class ComplaintHomePage extends StatefulWidget {

  final lat,long;
  const ComplaintHomePage({super.key, double? this.lat, double? this.long});

  @override
  State<ComplaintHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ComplaintHomePage> {

  GeneralFunction generalFunction = GeneralFunction();
  //  drawerFunction
  String? sCitizenName;
  String? sContactNo;
  String? sContactNo2;
  String? sContactNo3;
  bool isLoading = true;
  List<Map<String, dynamic>>? pendingInternalComplaintList;
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredData = [];
  //

  pendingInternalComplaintResponse() async {
    pendingInternalComplaintList = await CitizenMyPostComplaintRepo().cityzenpostcomplaint(context);
    print('-----53----$pendingInternalComplaintList');
    _filteredData = List<Map<String, dynamic>>.from(pendingInternalComplaintList ?? []);

    setState(() {
      // parkList=[];
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getLocatdata();
    pendingInternalComplaintResponse();
    _searchController.addListener(_search);
    var latitude = "${widget.lat}";
    var longitude = "${widget.long}";
    print("----44--lat---$latitude");
    print("----45--long---$longitude");
    super.initState();
  }
  getLocatdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    sCitizenName = prefs.getString('sCitizenName');
    sContactNo = prefs.getString('sContactNo');
    print('---46--$sCitizenName');
    print('---47--$sContactNo');
    setState(() {
    });
  }
  //
  void _search() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredData = pendingInternalComplaintList?.where((item) {
        String location = item['sPointTypeName'].toLowerCase();
        String pointType = item['iCompCode'].toLowerCase();
        String sector = item['sSectorName'].toLowerCase();
        return location.contains(query) ||
            pointType.contains(query) ||
            sector.contains(query);
      }).toList() ??
          [];
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget logoutDialogBox(BuildContext context){
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(color: Colors.orange, width: 2),
      ),
      title: Text('Do you want to log out?'),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey, // Background color
          ),
          child: Text('No'),
          onPressed: () {
            Navigator.of(context).pop(); // Dismiss the dialog
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange, // Background color
          ),
          child: Text('Yes'),
          onPressed: () {
            // Add your logout functionality here
            Navigator.of(context).pop(); // Dismiss the dialog
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
         child: GestureDetector(
         onTap: (){
          FocusScope.of(context).unfocus();
    },
      child: Scaffold(
        backgroundColor: Colors.white,
        // appBar
       appBar: appBarFunction(context,"Noida One Citizen"),
       drawer: generalFunction.drawerFunction_2(context,"$sCitizenName","$sContactNo"),
        body: Stack(
         // fit: StackFit.expand, // Make the stack fill the entire screen
          children: [
            /// todo here you applh border Image
            Container(
              height: 210, // Set the height of the container
              width: double.infinity, // Optionally set width to full screen
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/noidaCitizen.png"), // Path to your image
                  fit: BoxFit.fill, // Adjust the image to fill the container
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 200, left: 0, right: 0, bottom: 5),
              child:Container(
                 // width: 300, // Set the width of the container
                  height: MediaQuery.of(context).size.height, // Set the height of the container
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/images/background.png'), // Your asset path
                      fit: BoxFit.cover, // Adjust how the image fits the container
                    ),
                    borderRadius: BorderRadius.circular(15), // Optional: Rounded corners
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.watch_later_rounded),
                            SizedBox(width: 15),
                            Text("Funtional Activites",style: AppTextStyle.font16penSansExtraboldBlack45TextStyle),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                // Navigator.pushAndRemoveUntil(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => OnlineComplaint(name: "Online Complaint"),
                                //   ),
                                //       (Route<dynamic> route) => false, // This removes all previous routes.
                                // );
                             Navigator.push(context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          OnlineComplaint(name: "Online Complaint")),
                                );
                                },
                              child: Container(
                                height: 120,
                                width: MediaQuery.of(context).size.width / 2 - 14,
                                decoration: const BoxDecoration(
                                  // border
                                border: Border(
                                    left: BorderSide(
                                      color: Colors.green,
                                      // Specify your desired border color here
                                      width: 5.0, // Adjust the width of the border
                                    ),
                                  ),
                                borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                    // Adjust the radius for the top-left corner
                                bottomLeft: Radius.circular(10.0), // Adjust the radius for the bottom-left corner
                                  ),
                                ),
                                // color: Colors.black,
                                child: Card(
                                    elevation: 10,
                                    margin: EdgeInsets.all(5.0),
                                    shadowColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(color: Colors.green, width: 0.5),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              image: const DecorationImage(
                                                image: AssetImage('assets/images/background_circle_1.png'), // Path to the asset
                                                fit: BoxFit.cover, // Adjust how the image fits within the container
                                              ),
                                              borderRadius: BorderRadius.circular(12), // Optional: Adds rounded corners
                                            ),
                                            child: const Center(
                                                child: Image(
                                              image: AssetImage(
                                              'assets/images/online_Complain.png'),
                                              width: 45,
                                              height: 45,
                                            )),
                                          ),
                                          SizedBox(height: 10),
                                         Container(
                                           height: 1,
                                           color: Colors.black12,
                                         ),
                                          SizedBox(height: 5),
                                          // complaint_status
                                          Text('Online Complaint',
                                            style: AppTextStyle.font14penSansExtraboldGreenTextStyle,
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                            SizedBox(width: 5),
                            InkWell(
                              onTap: () {
                                // Add your onTap functionality here
                                print('-----109------');
                                // Navigator.pushAndRemoveUntil(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => GrievanceStatus(name: "Complaint List"),
                                //   ),
                                //       (Route<dynamic> route) => false, // This removes all previous routes.
                                // );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          GrievanceStatus(name: "Complaint List")),
                                );
                              },
                              child: Container(
                                height: 120,
                                width: MediaQuery.of(context).size.width / 2 - 14,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    // right border side
                                    right: BorderSide(
                                      color: Colors.orange,
                                      // Specify your desired border color here
                                      width: 5.0, // Adjust the width of the border
                                    ),
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10.0),
                                    // Adjust the radius for the top-left corner
                                    bottomRight: Radius.circular(10.0), // Adjust the radius for the bottom-left corner
                                  ),
                                ),
                                // color: Colors.black,
                                child: Card(
                                    elevation: 10,
                                    shadowColor: Colors.orange,
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                      color: Colors.orange, width: 0.5),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              image: const DecorationImage(
                                                image: AssetImage('assets/images/background_circle_2.png'), // Path to the asset
                                                fit: BoxFit.cover, // Adjust how the image fits within the container
                                              ),
                                              borderRadius: BorderRadius.circular(12), // Optional: Adds rounded corners
                                            ),
                                            child: const Center(
                                             child: Image(
                                              image: AssetImage('assets/images/complaint_list.png'),
                                              width: 45,
                                              height: 45,
                                            )),
                                          ),
                                          // complaint_status.png
                                          SizedBox(height: 10),
                                          Container(
                                            height: 1,
                                            color: Colors.black12,
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            'Complaint List',
                                            style: AppTextStyle
                                                .font14penSansExtraboldOrangeTextStyle,
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            InkWell(
                              onTap: () {

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChangePassword(name: "Change Password"),
                                  ),
                                      (Route<dynamic> route) => false, // This removes all previous routes.
                                );
                              },
                              child: Container(
                                height: 120,
                                width: MediaQuery.of(context).size.width / 2 - 14,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      color: Colors.orange,
                                      // Specify your desired border color here
                                      width: 5.0, // Adjust the width of the border
                                    ),
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    // Adjust the radius for the top-left corner
                                    bottomLeft: Radius.circular(
                                        10.0), // Adjust the radius for the bottom-left corner
                                  ),
                                ),
                                // color: Colors.black,
                                child: Card(
                                    elevation: 10,
                                    margin: EdgeInsets.all(5.0),
                                    shadowColor: Colors.orange,
                                    shape: RoundedRectangleBorder(
                                      side:
                                      BorderSide(color: Colors.orange, width: 0.5),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              image: const DecorationImage(
                                                image: AssetImage('assets/images/background_circle_4.png'), // Path to the asset
                                                fit: BoxFit.cover, // Adjust how the image fits within the container
                                              ),
                                              borderRadius: BorderRadius.circular(12), // Optional: Adds rounded corners
                                            ),
                                            child: const Center(
                                                child: Image(
                                                  image: AssetImage(
                                                      'assets/images/changePassword.png'),
                                                  width: 45,
                                                  height: 45,
                                                )),
                                          ),
                                          SizedBox(height: 10),
                                          Container(
                                            height: 1,
                                            color: Colors.black12,
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            'Change Password',
                                            style: AppTextStyle
                                                .font14penSansExtraboldOrangeTextStyle,
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                            SizedBox(width: 5),
                            InkWell(
                              onTap: () {
                                // Navigator.pushAndRemoveUntil(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => NotificationPage(),
                                //   ),
                                //       (Route<dynamic> route) => false, // This removes all previous routes.
                                // );
                                // Navigator.of(context).pushReplacement(
                                //   MaterialPageRoute(
                                //       builder: (context) =>
                                //           NotificationPage()),
                                // );
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NotificationPage(),
                                  ),
                                      (Route<dynamic> route) => route.settings.name == "/SpecificScreen", // Keeps the desired screen
                                );

                              },
                              child: Container(
                                height: 120,
                                width: MediaQuery.of(context).size.width / 2 - 14,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                      color: Colors.green,
                                      // Specify your desired border color here
                                      width: 5.0, // Adjust the width of the border
                                    ),
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10.0),
                                    // Adjust the radius for the top-left corner
                                    bottomRight: Radius.circular(
                                        10.0), // Adjust the radius for the bottom-left corner
                                  ),
                                ),
                                // color: Colors.black,
                                child: Card(
                                    elevation: 10,
                                    shadowColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          color: Colors.green, width: 0.5),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              image: const DecorationImage(
                                                image: AssetImage('assets/images/background_circle_4.png'), // Path to the asset
                                                fit: BoxFit.cover, // Adjust how the image fits within the container
                                              ),
                                              borderRadius: BorderRadius.circular(12), // Optional: Adds rounded corners
                                            ),
                                            child: const Center(
                                                child: Image(
                                                  image: AssetImage(
                                                      'assets/images/notification.png'),
                                                  width: 45,
                                                  height: 45,
                                                )),
                                          ),
                                          SizedBox(height: 10),
                                          Container(
                                            height: 1,
                                            color: Colors.black12,
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            'Notification',
                                            style: AppTextStyle
                                                .font14penSansExtraboldGreenTextStyle,
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            InkWell(
                              onTap: () {

                                Navigator.push(context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          patholeDectionForm(name: "Pothole Detections", iCategoryCode: null,)),
                                );
                                print("---531----");
                              },
                              child: Container(
                                height: 120,
                                width: MediaQuery.of(context).size.width / 2 - 14,
                                decoration: const BoxDecoration(
                                  // border
                                  border: Border(
                                    left: BorderSide(
                                      color: Colors.green,
                                      // Specify your desired border color here
                                      width: 5.0, // Adjust the width of the border
                                    ),
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    // Adjust the radius for the top-left corner
                                    bottomLeft: Radius.circular(10.0), // Adjust the radius for the bottom-left corner
                                  ),
                                ),
                                // color: Colors.black,
                                child: Card(
                                    elevation: 10,
                                    margin: EdgeInsets.all(5.0),
                                    shadowColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(color: Colors.green, width: 0.5),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              image: const DecorationImage(
                                                image: AssetImage('assets/images/background_circle_1.png'), // Path to the asset
                                                fit: BoxFit.cover, // Adjust how the image fits within the container
                                              ),
                                              borderRadius: BorderRadius.circular(12), // Optional: Adds rounded corners
                                            ),
                                            child: const Center(
                                                child: Image(
                                                  image: AssetImage(
                                                      'assets/images/online_Complain.png'),
                                                  width: 45,
                                                  height: 45,
                                                )),
                                          ),
                                          SizedBox(height: 10),
                                          Container(
                                            height: 1,
                                            color: Colors.black12,
                                          ),
                                          SizedBox(height: 5),
                                          // complaint_status
                                          Text('Pothole Detections',
                                            style: AppTextStyle.font14penSansExtraboldGreenTextStyle,
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                            SizedBox(width: 5),
                            //
                            // InkWell(
                            //   onTap: () {
                            //
                            //     Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (context) =>
                            //               GarbagePickUpRequest(name: "Complaint List", iCategoryCode: null,)),
                            //     );
                            //
                            //   },
                            //   child: Container(
                            //     height: 120,
                            //     width: MediaQuery.of(context).size.width / 2 - 14,
                            //     decoration: const BoxDecoration(
                            //       border: Border(
                            //         // right border side
                            //         right: BorderSide(
                            //           color: Colors.orange,
                            //           // Specify your desired border color here
                            //           width: 5.0, // Adjust the width of the border
                            //         ),
                            //       ),
                            //       borderRadius: BorderRadius.only(
                            //         topRight: Radius.circular(10.0),
                            //         // Adjust the radius for the top-left corner
                            //         bottomRight: Radius.circular(10.0), // Adjust the radius for the bottom-left corner
                            //       ),
                            //     ),
                            //     // color: Colors.black,
                            //     child: Card(
                            //         elevation: 10,
                            //         shadowColor: Colors.orange,
                            //         shape: RoundedRectangleBorder(
                            //           side: const BorderSide(
                            //               color: Colors.orange, width: 0.5),
                            //           borderRadius: BorderRadius.circular(10.0),
                            //         ),
                            //         child: Padding(
                            //           padding: const EdgeInsets.only(top: 10),
                            //           child: Column(
                            //             children: <Widget>[
                            //               Container(
                            //                 width: 60,
                            //                 height: 60,
                            //                 decoration: BoxDecoration(
                            //                   image: const DecorationImage(
                            //                     image: AssetImage('assets/images/background_circle_2.png'), // Path to the asset
                            //                     fit: BoxFit.cover, // Adjust how the image fits within the container
                            //                   ),
                            //                   borderRadius: BorderRadius.circular(12), // Optional: Adds rounded corners
                            //                 ),
                            //                 child: const Center(
                            //                     child: Image(
                            //                       image: AssetImage('assets/images/complaint_list.png'),
                            //                       width: 45,
                            //                       height: 45,
                            //                     )),
                            //               ),
                            //               // complaint_status.png
                            //               SizedBox(height: 10),
                            //               Container(
                            //                 height: 1,
                            //                 color: Colors.black12,
                            //               ),
                            //               SizedBox(height: 5),
                            //               Text(
                            //                 'Garbage Pickup Request',
                            //                 style: AppTextStyle
                            //                     .font14penSansExtraboldOrangeTextStyle,
                            //               ),
                            //             ],
                            //           ),
                            //         )),
                            //   ),
                            // ),
                          ],
                        ),

                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   children: [
                        //     Icon(Icons.watch_later_rounded),
                        //     SizedBox(width: 15),
                        //     Text("Current Complaint",style: AppTextStyle.font16penSansExtraboldBlack45TextStyle),
                        //   ],
                        // ),
                        // // Here you should redraw list
                        // isLoading
                        //     ? Center(child:
                        // Container())
                        //     : (pendingInternalComplaintList == null || pendingInternalComplaintList!.isEmpty)
                        //     ? NoDataScreenPage()
                        //     :
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.stretch,
                        //   children: <Widget>[
                        //     Expanded(
                        //       child: ListView.builder(
                        //         itemCount: _filteredData.length ?? 0,
                        //         itemBuilder: (context, index) {
                        //           Map<String, dynamic> item = _filteredData[index];
                        //           //  fRating="${item['fRating']}";
                        //           //double? ratingValue = double.tryParse(fRating);
                        //
                        //           return Padding(
                        //             padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
                        //             child: Container(
                        //               child: Column(
                        //                 children: [
                        //                   Card(
                        //                     elevation: 4,
                        //                     shadowColor: Colors.white,
                        //                     child: Container(
                        //                       color: Colors.white,
                        //                       child: Column(
                        //                         mainAxisAlignment: MainAxisAlignment.start,
                        //                         crossAxisAlignment: CrossAxisAlignment.start,
                        //                         children: [
                        //                           SizedBox(height: 5),
                        //                           Row(
                        //                             mainAxisAlignment: MainAxisAlignment.start,
                        //                             children: <Widget>[
                        //                               SizedBox(width: 5),
                        //                               CircleWithSpacing(),
                        //                               Text('Complaint No',
                        //                                   style: AppTextStyle
                        //                                       .font14OpenSansRegularBlackTextStyle),
                        //                             ],
                        //                           ),
                        //                           Padding(
                        //                             padding: const EdgeInsets.only(left: 24),
                        //                             child: Text(item['iCompCode'].toString() ?? '',
                        //                                 style: AppTextStyle
                        //                                     .font14OpenSansRegularRedTextStyle),
                        //                           ),
                        //                           Row(
                        //                             mainAxisAlignment: MainAxisAlignment.start,
                        //                             children: <Widget>[
                        //                               SizedBox(width: 5),
                        //                               CircleWithSpacing(),
                        //                               Text('Sector',
                        //                                   style: AppTextStyle
                        //                                       .font14OpenSansRegularBlackTextStyle),
                        //                             ],
                        //                           ),
                        //                           Padding(
                        //                             padding: const EdgeInsets.only(left: 24),
                        //                             child: Text(item['sSectorName'] ?? '',
                        //                                 style: AppTextStyle
                        //                                     .font14penSansExtraboldBlackTextStyle),
                        //                           ),
                        //                           Row(
                        //                             mainAxisAlignment: MainAxisAlignment.start,
                        //                             children: <Widget>[
                        //                               SizedBox(width: 5),
                        //                               CircleWithSpacing(),
                        //                               Text('Agency Name',
                        //                                   style: AppTextStyle
                        //                                       .font14OpenSansRegularBlack45TextStyle),
                        //                             ],
                        //                           ),
                        //                           Padding(
                        //                             padding: const EdgeInsets.only(left: 24),
                        //                             child: Text(item['sAgencyName'] ?? '',
                        //                                 style: AppTextStyle
                        //                                     .font14penSansExtraboldBlack26TextStyle),
                        //                           ),
                        //                         ],
                        //                       ),
                        //                     ),
                        //                   ),
                        //
                        //                 ],
                        //               ),
                        //             ),
                        //           );
                        //         },
                        //       ),
                        //     )
                        //   ],
                        // ),

                      ],
                    ),
                  ),
                ),
              ),

            // here you should rendered list


          ],
        ),
      ),
    )
    );
  }
}
