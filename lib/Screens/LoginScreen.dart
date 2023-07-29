import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import '../Constant/Colors.dart';
import '../Design/CustomeTextField.dart';
import '../Design/HorizontalLine.dart';
import '../Design/MainButton.dart';
import '../Design/myDialogues.dart';
import '../main.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String dialCodeDigits = "";
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _usernamecontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool _isSwitchOn = true;

 // var manager = Get.put(AuthenticationManager());

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: appbackgroundColor,
      body: SafeArea(
        child: Container(
          height: screenHeight,
          width: screenWidth,
          color: Colors.transparent,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: screenHeight * 0.07,
                ),
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.11),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Welcome",
                      style: TextStyle(
                          letterSpacing: 2,
                          color: alterColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 40),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.025,
                ),
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.11),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Sign in to continue",
                      style: TextStyle(
                          letterSpacing: 1.5,
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                Container(
                  // height: screenHeight * 0.44,
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  width: screenWidth * 0.87,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: subBackgroundColor,
                            blurRadius: 50,
                            spreadRadius: 5)
                      ],
                      color: subBackgroundColor,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15))),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        // SizedBox(
                        //   height: screenHeight * 0.009,
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 4),
                        //   child: Row(
                        //     mainAxisSize: MainAxisSize.min,
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       CountryCodePicker(
                        //         backgroundColor: appbackgroundColor,
                        //         flagDecoration:
                        //             const BoxDecoration(shape: BoxShape.circle),
                        //         boxDecoration:
                        //             BoxDecoration(color: appbackgroundColor),
                        //         onChanged: (country) {
                        //           setState(() {
                        //             dialCodeDigits =
                        //                 country.dialCode.toString();
                        //           });
                        //         },
                        //         initialSelection: "PK",
                        //         textStyle:
                        //             TextStyle(color: textColor, fontSize: 16),
                        //         dialogTextStyle:
                        //             TextStyle(color: textColor, fontSize: 16),
                        //         showCountryOnly: false,
                        //         showOnlyCountryWhenClosed: false,
                        //         favorite: const [
                        //           "+1",
                        //           "US",
                        //           "+92",
                        //           "PAK",
                        //           "+61",
                        //           "AUS"
                        //         ],
                        //       ),
                        //       Expanded(
                        //         flex: 1,
                        //         child: TextFormField(
                        //           // maxLength: 12,
                        //           validator: (value) {
                        //             if (value!.isEmpty) {
                        //               return "Please Enter Your Number";
                        //             } else {
                        //               return null;
                        //             }
                        //           },
                        //           style: TextStyle(color: textColor),
                        //           cursorColor: textColor,
                        //           textAlign: TextAlign.start,
                        //           keyboardType: TextInputType.number,
                        //           controller: _controller,
                        //           decoration: InputDecoration(
                        //             border: InputBorder.none,
                        //             hintText: "Phone Number",
                        //             hintStyle: TextStyle(color: textColor),
                        //           ),
                        //         ),
                        //       )
                        //     ],
                        //   ),
                        // ),
                        // const HorizontelLine(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: CustomTextField(
                            hintText: "Username",
                            cntrlr: _usernamecontroller,
                            ispasswordfield: false,
                            isPassword: false,
                            isEmail: false,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter Your username";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        const HorizontelLine(),
                          SizedBox(
                            height: screenHeight * 0.005,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: CustomTextField(
                              hintText: "Password",
                              cntrlr: _passwordcontroller,
                              ispasswordfield: true,
                              isPassword: true,
                              isEmail: false,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter Your Password";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          const HorizontelLine(),
                          // SizedBox(
                          //   height: screenHeight * 0.05,
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 20),
                          //   child: Row(
                          //     mainAxisSize: MainAxisSize.min,
                          //     mainAxisAlignment: MainAxisAlignment.start,
                          //     children: [
                          //       FlutterSwitch(
                          //           value: _isSwitchOn,
                          //           height: 20.0,
                          //           width: 35.0,
                          //           activeColor: alterColor,
                          //
                          //           //padding: 4.0,
                          //           toggleSize: 15,
                          //           borderRadius: 12,
                          //           activeToggleColor: Colors.white,
                          //           inactiveToggleColor: Colors.white,
                          //           onToggle: (val) {
                          //             setState(() {
                          //               _isSwitchOn = !_isSwitchOn;
                          //             });
                          //           }),
                          //       const SizedBox(
                          //         width: 5,
                          //       ),
                          //       Text(
                          //         "remember me",
                          //         style: TextStyle(color: textColor),
                          //       ),
                          //       const Spacer(),
                          //       TextButton(
                          //           onPressed: () {
                          //        //     Get.to(() => ForgotPasswordScreen());
                          //           },
                          //           child: Text(
                          //             "forgot password?",
                          //             style: TextStyle(
                          //                 color: textColor,
                          //                 fontSize: screenHeight * 0.018,
                          //                 decoration: TextDecoration.underline),
                          //           ))
                          //     ],
                          //   ),
                          // ),
                        SizedBox(
                          height: screenHeight * 0.04,
                        ),
                        Obx(() => authController.loading.value ? MainButton(
                            title: "SIGN IN",
                            onTap: () async {
                              if (_formkey.currentState!.validate()) {
                                FocusScope.of(context).unfocus();
                                await authController.login(
                                  username: _usernamecontroller.text,
                                  password:
                                  _passwordcontroller.text.trim(),
                                  save: _isSwitchOn,
                                );
                              }
                            }) :
                        Center(child: CircularProgressIndicator(),) ),

                        // GetBuilder<AuthController>(builder: (controller){
                        //   return controller.getLoading()?
                        //   MainButton(
                        //       title: "SIGN IN",
                        //       onTap: () async {
                        //         if (_formkey.currentState!.validate()) {
                        //           FocusScope.of(context).unfocus();
                        //           await authController.login(
                        //             username: _usernamecontroller.text,
                        //             password:
                        //             _passwordcontroller.text.trim(),
                        //             save: _isSwitchOn,
                        //           );
                        //         }
                        //       }) :
                        //   Center(child: CircularProgressIndicator(),);
                        // }),
                        SizedBox(
                          height: screenHeight * 0.03,
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Text("Don't have an account ?",
                        //         style: TextStyle(color: textColor)),
                        //     TextButton(
                        //         onPressed: () {
                        //           // Get.to(() => SignUpScreen());
                        //         },
                        //         child: Text("   SignUp   ",
                        //             style: TextStyle(
                        //               color: alterColor,
                        //               fontWeight: FontWeight.bold,
                        //               fontSize: 15,
                        //             )))
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),

                // TextButton(onPressed: (){
                //   showUploadType(context);
                // }, child: Text("dialogue"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
