
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/generalFunction.dart';
import '../../services/loginRepo.dart';
import '../complaints/complaintHomePage.dart';
import '../forgotPassword/forgotPassword.dart';
import '../registration/registration.dart';
import '../resources/app_strings.dart';
import '../resources/app_text_style.dart';
import '../resources/assets_manager.dart';
import '../resources/values_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen_2 extends StatelessWidget {

  const LoginScreen_2({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isObscured = true;
  var loginProvider;

  // focus
  FocusNode phoneNumberfocus = FocusNode();
  FocusNode passWordfocus = FocusNode();

  bool passwordVisible = false;
  // Visible and Unvisble value
  int selectedId = 0;
  var msg;
  var result;
  var loginMap;
  double? lat, long;
  GeneralFunction generalFunction = GeneralFunction();

  void getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    debugPrint("-------------Position-----------------");
    debugPrint(position.latitude.toString());

    lat = position.latitude;
    long = position.longitude;
    print('-----------105----$lat');
    print('-----------106----$long');
    // setState(() {
    // });
    debugPrint("Latitude: ----1056--- $lat and Longitude: $long");
    debugPrint(position.toString());
  }
  turnOnLocationMsg(){
    if((lat==null && lat=='') ||(long==null && long=='')){
      displayToast("Please turn on Location");
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure?',style: AppTextStyle
            .font14OpenSansRegularBlackTextStyle,),
        content: new Text('Do you want to exit app',style: AppTextStyle
            .font14OpenSansRegularBlackTextStyle,),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), //<-- SEE HERE
            child: new Text('No'),
          ),
          TextButton(
            onPressed: () {
              //  goToHomePage();
              // exit the app
              exit(0);
            }, //Navigator.of(context).pop(true), // <-- SEE HERE
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ??
        false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
    if(lat==null || lat==''){
      turnOnLocationMsg();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _phoneNumberController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  void clearText() {
    _phoneNumberController.clear();
    passwordController.clear();
  }
  // bottomSheet
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.white,
          child: GestureDetector(
            onTap: (){
              print('---------');
            },
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: const Center(child: Padding(
                          padding: EdgeInsets.all(0.0),
                          child: Icon(Icons.close,size: 25,color: Colors.white),
                        )),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text("Can't Login?",style:AppTextStyle.font18OpenSansboldAppBasicTextStyle),
                  SizedBox(height: 10),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        /// After implement attion this comment is remove and OtpVerfication is hide
                        // Add your button onPressed logic here
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //         const ForgotPassword()));

                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), // Adjust as needed
                        ), // Text color
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Text(
                            'Forgot Password',style:TextStyle(
                            fontSize: 16,
                            color: Colors.white
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //onWillPop: _onWillPop,
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pop Screen Disabled.'),
            backgroundColor: Colors.red,
          ),
        );
        return false; // Prevent the back button action
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: GestureDetector(
            onTap: (){
              FocusScope.of(context).unfocus();
            },
            child: Padding(
                padding: const EdgeInsets.only(top: 25),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      // mention all widget here
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[

                          Container(
                            margin: const EdgeInsets.all(AppMargin.m10),
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/roundcircle.png"),
//image: AssetImage("assets/images/roundcircle.png"), // Correct path to background image
                                fit: BoxFit.cover,
                              ),
                            ),
                            width: AppSize.s50,
                            height: AppSize.s50,
                            child: Image.asset("assets/icon/icon.png",
                              //ImageAssets.logintopleft,
                              width: AppSize.s50,
                              height: AppSize.s50,
                            ),
                          ),
                          Expanded(child: Container()),
                          Container(
                            margin: const EdgeInsets.all(AppMargin.m10),
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/roundcircle.png"), // Correct path to background image
                                fit: BoxFit.cover,
                              ),
                            ),
                            width: AppSize.s50,
                            height: AppSize.s50,
                            child: Image.asset("assets/images/favicon.png",
                             // ImageAssets.toprightlogin,
                              width: AppSize.s50,
                              height: AppSize.s50,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: AppSize.s145,
                        width: AppSize.s145,
                        margin: const EdgeInsets.all(AppMargin.m20),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              ImageAssets.roundcircle,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        // "assets/images/login_icon.png",
                        child: Padding(
                          padding: const EdgeInsets.all(AppMargin.m16),
                          child: Center(
                            child: Image.asset(
                              "assets/icon/icon.png",
                             // ImageAssets.iclauncher, // Replace with your image asset path
                              width: AppSize.s145,
                              height: AppSize.s145,
                              fit: BoxFit.contain, // Adjust as needed
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Align(
                          alignment: Alignment.centerLeft, // Align to the left
                          child: Text(
                            AppStrings.txtLogin,
                            style: AppTextStyle.font14penSansBlackTextStyle,
                          ),
                        ),
                      ),
                      /// Todo here we mention main code for a login ui.
                      GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                        },
                        child: Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10,right: 10),
                            child: Column(
                              children: <Widget>[
                                Column(
                                  children: [
                                    SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: AppPadding.p15, right: AppPadding.p15),
                                      // PHONE NUMBER TextField
                                      child: TextFormField(
                                        focusNode: phoneNumberfocus,
                                        controller: _phoneNumberController,
                                        textInputAction: TextInputAction.next,
                                        onEditingComplete: () => FocusScope.of(context).nextFocus(),
                                        keyboardType: TextInputType.phone,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(10), // Limit to 10 digits
                                          //FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Only allow digits
                                        ],
                                        decoration: const InputDecoration(
                                          labelText: AppStrings.txtMobile,
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: AppPadding.p10,
                                            horizontal: AppPadding.p10, // Add horizontal padding
                                          ),

                                          prefixIcon: Icon(
                                            Icons.phone,
                                            color: Color(0xFF255899),
                                          ),
                                          // errorBorder
                                          // errorBorder: OutlineInputBorder(
                                          //     borderSide: BorderSide(color: Colors.green, width: 0.5))
                                        ),
                                        autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Enter mobile number';
                                          }
                                          if (value.length > 1 && value.length < 10) {
                                            return 'Enter 10 digit mobile number';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: AppPadding.p15, right: AppPadding.p15),
                                      // passWord TextFormField
                                      child: TextFormField(
                                        controller: passwordController,
                                        obscureText: _isObscured,
                                        decoration: InputDecoration(
                                          labelText: AppStrings.txtpassword,
                                          border: const OutlineInputBorder(),
                                          contentPadding: const EdgeInsets.symmetric(
                                            vertical: AppPadding.p10,
                                            horizontal: AppPadding.p10, // Add horizontal padding
                                          ),
                                          prefixIcon: const Icon(Icons.lock,color: Color(0xFF255899)),
                                          suffixIcon: IconButton(
                                            icon: Icon(_isObscured
                                                ? Icons.visibility
                                                : Icons.visibility_off),
                                            onPressed: () {
                                              setState(() {
                                                _isObscured = !_isObscured;
                                              });
                                            },
                                          ),
                                        ),
                                        autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Enter password';
                                          }
                                          if (value.length < 1) {
                                            return 'Please enter Valid Name';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 13,right: 13),
                                      child: InkWell(
                                        onTap: () async {
                                          getLocation();
                                          var phone = _phoneNumberController.text.trim();
                                          var password = passwordController.text.trim();
                                          print("---phone--$phone");
                                          print("----password ---$password");

                                          if(_formKey.currentState!.validate() && phone.isNotEmpty && password.isNotEmpty){
                                            // Call Api
                                            loginMap = await LoginRepo().login(context, phone!,password);
                                            print('---451----->>>>>---XXXXX---XXXX----$loginMap');
                                            result = "${loginMap['Result']}";
                                            msg = "${loginMap['Msg']}";
                                            //
                                             var token = "${loginMap['Msg']}";
                                            print('---361----$result');
                                            print('---362----$msg');
                                            /// to store the value in a local data base

                                          }else{
                                            if(_phoneNumberController.text.isEmpty){
                                              phoneNumberfocus.requestFocus();
                                            }else if(passwordController.text.isEmpty){
                                              passWordfocus.requestFocus();
                                            }
                                          } // condition to fetch a response form a api
                                          if(result=="1") {

                                            var sContactNo = "${loginMap['Data'][0]['sContactNo']}";
                                            var sCitizenName = "${loginMap['Data'][0]['sCitizenName']}";
                                            var sGender = "${loginMap['Data'][0]['sGender']}";
                                            var sEmailId = "${loginMap['Data'][0]['sEmailId']}";
                                            var sToken = "${loginMap['Data'][0]['sToken']}";
                                            // to store the value in local dataBase

                                            SharedPreferences prefs = await SharedPreferences.getInstance();
                                            prefs.setString('sGender',sGender);
                                            prefs.setString('sContactNo',sContactNo);
                                            prefs.setString('sCitizenName',sCitizenName);
                                            prefs.setString('sEmailId',sEmailId);
                                            prefs.setString('sToken',sToken);

                                            String? token = prefs.getString('sToken');
                                            print("------495----$token");
                                            //
                                            if((lat==null && lat=='') ||(long==null && long=='')){
                                              displayToast("Please turn on Location");

                                            }else{
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(builder: (context) => ComplaintHomePage(lat:lat,long:long)),
                                              );
                                            }


                                            // Navigator.pushReplacement(
                                            //   context,
                                            //   MaterialPageRoute(builder: (context) => OtpPage(phone:phone)),
                                            // );
                                          }else{
                                            print('----373---To display error msg---');
                                            displayToast(msg);

                                          }
                                        },
                                        child: Container(
                                          width: double.infinity, // Make container fill the width of its parent
                                          height: AppSize.s45,
                                          //  padding: EdgeInsets.all(AppPadding.p5),
                                          decoration: BoxDecoration(
                                            color: Color(0xFF255899), // Background color using HEX value
                                            borderRadius: BorderRadius.circular(
                                                AppMargin.m10), // Rounded corners
                                          ),
                                          child: const Center(
                                            child: Text(
                                              AppStrings.txtLogin,
                                              style: TextStyle(
                                                  fontSize: AppSize.s16,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 13,right: 13),
                                      child: Container(
                                        height: 45,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space between texts
                                          children: [
                                            GestureDetector(
                                              onTap:(){
                                               print("-----Forgot Password----");
                                               // ForgotPassword
                                               Navigator.push(
                                                 context,
                                                 MaterialPageRoute(builder: (context) => ForgotPassword()),
                                               );
                                               },
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Container(
                                                  child: Text(
                                                    "Forgot Password ?",
                                                    style: AppTextStyle.font14penSansBlackTextStyle,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: (){
                                                // Registration
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => const Registration()),
                                                );

                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(10.0), // 10dp padding around the text
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Color(0xFF255899)), // Gray border color
                                                  borderRadius: BorderRadius.circular(8.0), // Rounded corners for the border
                                                ),
                                                child: Text(
                                                  "Register Here",
                                                  style: AppTextStyle.font14penSansBlackTextStyle,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          )),
    );
  }
  // toast code
  void displayToast(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

