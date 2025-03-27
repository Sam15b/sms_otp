import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sms_autofill/Api/Api.dart';
import 'package:flutter_sms_autofill/ContactsScreen.dart';
//import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String selectedCountryCode;

  const OtpVerificationScreen(this.phoneNumber, this.selectedCountryCode,
      {Key? key})
      : super(key: key);

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen>
    with CodeAutoFill {
  TextEditingController otpController = TextEditingController();
  int _resendTime = 20;
  late Timer _timer;
  Api _api = Api();

  @override
  void initState() {
    super.initState();
    print(
        "checking the value ${widget.phoneNumber} ${widget.selectedCountryCode}");

    sendOtpAndListen();

    startResendTimer();
    listenOtp(); // Start listening for SMS autofill
  }

  @override
  void dispose() {
    _timer.cancel();
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  Future<void> sendOtpAndListen() async {
    try {
      Map<String, dynamic> response = await _api.sendOtp(widget.phoneNumber);
      print(response); // You will see the response here
    } catch (e) {
      print("Error sending OTP: $e");
    }
  }

  void verifyingOtp(String phoneNumber, String otp) async {
    try {
      Map<String, dynamic> response = await _api.verifyOtp(phoneNumber, otp);
      print(response['msg']); // Show message from backend
      if (response['success']) {
        print("OTP Verified Successfully!");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ContactsScreen(),
          ),
        );
      } else {
        print("OTP Verification Failed: ${response['msg']}");
      }
    } catch (e) {
      print("API Error: $e");
    }
  }

  void startResendTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTime == 0) {
        timer.cancel();
      } else {
        setState(() {
          _resendTime--;
        });
      }
    });
  }

  void listenOtp() async {
    await SmsAutoFill().unregisterListener();
    listenForCode();
    await SmsAutoFill().listenForCode;
    print("OTP listen Called");
  }

  @override
  void codeUpdated() {
    setState(() {
      // String? code = SmsAutoFill().code as String?;
      print("check the code ${code}");
      // otpController.text = code;
    });
  }

  void onContinuePressed() {
    if (otpController.text.length == 4) {
      // Handle OTP verification logic here
      print('OTP Entered: ${otpController.text}');
      verifyingOtp(widget.phoneNumber, otpController.text);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter complete OTP')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9EEF2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Verification',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "We've sent you the verification code\non ${widget.selectedCountryCode} ${widget.phoneNumber}",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 60,
              // width: (50 * 4) + (18 * 3),
              child: PinFieldAutoFill(
                controller: otpController,
                codeLength: 4,
                decoration: BoxLooseDecoration(
                  strokeColorBuilder: PinListenColorBuilder(
                    Colors.blueAccent, // Border color when focused
                    Colors.grey.shade300, // Border color when not focused
                  ),
                  bgColorBuilder: FixedColorBuilder(Colors.white),
                  gapSpace: 12, // Closer spacing to match the design
                  radius: const Radius.circular(12), // Slightly rounded corners
                  textStyle: const TextStyle(
                    fontSize: 22, // Slightly smaller than before
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  strokeWidth: 1.5, // Thicker border like your design
                ),
                currentCode: otpController.text,
                onCodeChanged: (code) {
                  if (code != null && code.length == 4) {
                    print("Completed OTP: $code");
                    verifyingOtp(widget.phoneNumber, code);
                  }
                },
                onCodeSubmitted: (value) {
                  print("Completed OTP2: $value");
                  verifyingOtp(widget.phoneNumber, value);
                },
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: onContinuePressed,
                style: ElevatedButton.styleFrom(
                  //backgroundColor: Colors.orange,
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child:
                    const Text('Submit', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: _resendTime > 0
                  ? Text(
                      'Re-send code in 0:${_resendTime.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Re-send code in ',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _resendTime = 20;
                              startResendTimer();
                            });
                            listenOtp();
                            sendOtpAndListen();
                          },
                          child: const Text(
                            'resend',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(221, 37, 36, 36),
                              fontWeight: FontWeight.bold,
                              //decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }
}
