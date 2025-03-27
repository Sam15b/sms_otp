const OtpModel = require('../models/otp')
const { otpVerification } = require('../helpers/otpValidate')

const otpGenerator = require('otp-generator')

const sendOtp = async (req, res) => {
      try {
            const { phoneNumber } = req.body
            const otp = otpGenerator.generate(4, { upperCaseAlphabets: false, lowerCaseAlphabets: false, specialChars: false })


            const cDate = new Date()

            await OtpModel.findOneAndUpdate(
                  { phoneNumber },
                  { otp, otpExpiration: new Date(cDate.getTime()) },
                  { upsert: true, new: true, setDefaultsOnInsert: true }
            );

            return res.status(200).json({
                  success: true,
                  msg: `OTP Sent Successfully in your phone ${phoneNumber}! And the Otp is ${otp}`
            })
      }
      catch (err) {
            return res.status(400).json({
                  success: false,
                  msg: err.message
            })
      }
}

const verifyOtp = async (req, res) => {
      try {
            const { phoneNumber, otp } = req.body

            if (!phoneNumber || !otp) {
                  return res.status(400).json({
                        success: false,
                        msg: "You have to Enter Otp"
                  })
            }

            const otpData = await OtpModel.findOne({ otp, phoneNumber })

            if (!otpData) {
                  return res.status(400).json({
                        success: false,
                        msg: "You Enter Wrong Otp"
                  })
            }

            console.log(otpData.otpExpiration)

            const isotpExpired = await otpVerification(otpData.otpExpiration)

            if(isotpExpired){
                  return res.status(400).json({
                        success: false,
                        msg: "Your Otp has been Expired"
                  })
            }

            return res.status(200).json({
                  success: true,
                  msg: "Otp Verified Successfully"
            })

      }
      catch (err) {
            return res.status(400).json({
                  success: false,
                  msg: err.message
            })
      }
}

module.exports = {
      sendOtp,
      verifyOtp
}