🔐 Flutter SMS Auto Filler – OTP Authentication
This project implements a seamless OTP-based authentication flow using Flutter on the frontend and Node.js on the backend. Users receive an OTP via SMS, which is automatically detected and filled in the input field using SMS Auto Fill. The OTP is verified on the server, and upon success, the user is authenticated and navigated to the Dashboard.

✨ Features

🔢 OTP input with SMS auto-fill

📩 Automatic OTP detection using ```sms_autofill```

🔐 OTP generation and verification using a Node.js backend

🛡️ Secure user authentication

🧭 Navigation to Dashboard on successful verification

⚙️ Backend (Node.js)
The backend is built using Node.js and uses the otp-generator package to generate secure OTPs. Here's a quick overview of how the backend works:

🔧 Technologies Used

   • Node.js
   
   • Express.js
   
   • otp-generator
   
📤 Example OTP Generation

 ``` javascript
const otpGenerator = require('otp-generator'); 

 const otp = otpGenerator.generate(4, { upperCaseAlphabets: false, lowerCaseAlphabets: false, specialChars: false, });
 ``` 

🔍 OTP Verification Endpoint
The server also exposes an endpoint where the client sends the OTP for verification. If matched, authentication proceeds.

📽️ Demo Video
Check out the demo of the full OTP authentication flow:

<a data-start="223" data-end="337" rel="noopener" target="_new" class="" href="https://www.linkedin.com/posts/sam-sde_flutter-otp-flutterdev-activity-7317796035832025088-ham0?utm_source=share&utm_medium=member_desktop&rcm=ACoAAEztkXcB7v8aQJ1eKeIOBmmBCzZ9XxNr4jk"><img alt="Watch the Demo" data-start="224" data-end="289" src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQsZ6QrBIz7NPCtHuk-6EeZkInb_SBrXWX_yGFZjpoEuvzhWwzW0N8S1Fp1S_sp5SUXg8E" style="max-width:100%;width:110vh;"></a>

📦 Flutter Packages Used

  • sms_autofill
  • flutter
  • Navigation & Routing

🚀 Getting Started

🖥️ Flutter Frontend

1) Clone the repo:
`
git clone https://github.com/your-username/flutter-sms-autofill.git
`

2) Install dependencies:
`
flutter pub get
`

3) Run the app:
`
flutter run
`

🧪 Node.js Backend

1) Navigate to backend directory:
`
cd backend
`

2) Install dependencies:
`
npm install
`

4) Start the server:
`
node index.js
`
