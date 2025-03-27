import 'package:flutter/material.dart';
import 'package:flutter_sms_autofill/OtpVerificationScreen.dart';
import 'package:sms_autofill/sms_autofill.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  String selectedCountryCode = '+91'; // Default country code

  TextEditingController phoneController = TextEditingController();

  Map<String, int> selectedCountryCodeLength = {
    '+91': 10, // India
    '+1': 10, // USA/Canada (10 digits without country code)
    '+44': 10, // UK (usually 10 digits for mobiles, landlines vary)
    '+61': 9, // Australia (mobiles are typically 9 digits)
    '+81': 10, // Japan (mobiles are 10 digits, some landlines can vary)
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Center(
                child: Text(
                  'Create Account',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 5),
              const Center(
                child: Text(
                  'Create your account to connect with friends',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  // Country code dropdown
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedCountryCode,
                        items: ['+1', '+91', '+44', '+61', '+81']
                            .map((code) => DropdownMenuItem(
                                  value: code,
                                  child: Text(code),
                                ))
                            .toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            print(newValue);
                            selectedCountryCode = newValue!;
                            phoneController.clear();
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Phone number input
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      controller: phoneController,
                      decoration: InputDecoration(
                        hintText: 'Enter your phone number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (value) {
                        int maxLength =
                            selectedCountryCodeLength[selectedCountryCode] ??
                                10;
                        if (value.length > maxLength) {
                          // Restrict length manually
                          phoneController.text = value.substring(0, maxLength);
                          phoneController.selection =
                              TextSelection.fromPosition(
                            TextPosition(offset: phoneController.text.length),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(value: true, onChanged: (value) {}),
                  const Text('I agree with Terms & Conditions'),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    int requiredLength =
                        selectedCountryCodeLength[selectedCountryCode] ?? 10;
                    if (phoneController.text.isEmpty) {
                      // Show error for empty phone number
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Please enter your phone number')),
                      );
                    } else if (phoneController.text.length != requiredLength) {
                      // Show error for incorrect length
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Phone number must be $requiredLength digits for $selectedCountryCode'),
                        ),
                      );
                    } else {
                      // Proceed with sign up logic
                      print('Phone number is valid, proceed to next step');

                      var appSignatureID = await SmsAutoFill().getAppSignature;
                      Map sendOtpData = {
                        "mobile_number": phoneController.text,
                        "app_signature_id": appSignatureID
                      };
                      print("Sending App SignatureId");
                      print(sendOtpData);
                      String PhoneNumber = phoneController.text.toString();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OtpVerificationScreen(PhoneNumber, selectedCountryCode),),
                      );
                    }
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('Or'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              //const Spacer(),
              const SizedBox(height: 10),
              buildSocialButton(
                text: 'Continue with Google',
                color: Colors.red[100]!,
                icon:
                    'assets/google-logo.png', // Use better Google icon if available
                iconColor: Colors.red,
              ),
              const SizedBox(height: 10),
              buildSocialButton(
                text: 'Continue with Facebook',
                color: Colors.blue[100]!,
                icon: 'assets/facebook.png',
                iconColor: Colors.blue,
              ),
              const SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Already registered?'),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Log In',
                          style: TextStyle(color: Colors.blueAccent)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSocialButton({
    required String text,
    required Color color,
    required String icon,
    required Color iconColor,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          foregroundColor: Colors.black,
        ),
        icon: Image.asset(
          icon,
          width: 24,
          height: 24,
        ),
        onPressed: () {},
        label: Text(
          text,
          style: TextStyle(color: iconColor),
        ),
      ),
    );
  }
}
