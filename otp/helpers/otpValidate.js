const otpVerification = async (OtpTime) => {
      try {
            console.log(`Milliseconds is: ${OtpTime}`)

            const cDateTime = new Date();
            var differenceValue = (OtpTime - cDateTime.getTime())/1000;
            differenceValue /= 60;

            const minutes = Math.abs(differenceValue)

            console.log('Expired minutes:- ',minutes)

            if(minutes>1){
                  return true;
            }

            return false;
      }
      catch (err) {
            console.log("Error", err.message)
      }
}

module.exports ={
      otpVerification
}