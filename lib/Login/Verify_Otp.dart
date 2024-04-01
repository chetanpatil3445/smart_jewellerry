import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../Constants/Constants.dart';
import '../Constants/Globals.dart';
import 'Phone_Otp.dart';
import 'Registration.dart';


class VeirfyOtp extends StatefulWidget {
  const VeirfyOtp({super.key});

  @override
  State<VeirfyOtp> createState() => _VeirfyOtpState();
}

class _VeirfyOtpState extends State<VeirfyOtp> {
  TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
               image: AssetImage("assets/BG1.png"),
              fit: BoxFit.cover,
            )
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                    Text("Verify With OTP",style: TextStyle(color: Colors.black , fontSize: 18 , fontWeight: FontWeight.w700),),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                    Text("Sent via SMS to $globalphone",style: TextStyle(color: Colors.black , fontSize: 15),),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.06,),
                    Pinput(
                      controller: otpController,
                      keyboardType: TextInputType.number,
                      length: 6,
                      onChanged: (value) {
                        globalOtp = value;
                      },
                      defaultPinTheme: PinTheme(
                          height: 50,
                          width: 50,
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: PrimeColor,
                              border: Border.all(color: allHeadingPrimeColor, width: 1),
                              borderRadius: BorderRadius.circular(5)

                          )
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04,),

                    Text("Check text messages for your OTP ",style: TextStyle(color: Colors.black , fontSize: 16),),
                  ],
                ),
              ),
            ),
            // SizedBox(height: 20,),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       '$_counter sec',
            //       style: TextStyle(
            //         fontSize: 18,
            //         color: Colors.red,
            //         fontWeight:FontWeight.w400,
            //
            //       ),
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: GestureDetector(
            //         onTap:  () {
            //           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> OtpLogin()));
            //         },
            //         child: Text("Send Otp Again",style: TextStyle(
            //             color: AllTextColor,
            //             fontWeight:FontWeight.bold,
            //             fontSize: 17
            //         ),),
            //       ),
            //     ),
            //   ],
            // ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20 , bottom: 20),
                  child: Container(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          allHeadingPrimeColor
                        )
                      ),
                      onPressed: () {
                        print("#################################$globalOtp");
                        if (globalOtp.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Registration()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: allHeadingPrimeColor,
                              content: Text("Please Enter OTP"),
                            ),
                          );
                        }
                      },
                      child: Row(
                        children: [
                          Text("Verify",style: TextStyle(color: Colors.white , fontSize: 18),),
                          SizedBox(width: 10,),
                          Icon(Icons.arrow_forward , color: Colors.white,)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
