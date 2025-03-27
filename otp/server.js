const express = require('express')
const app = express()
const mongoose = require('mongoose')

mongoose.connect('mongodb://127.0.0.1:27017/otpdb')

const userRoutes = require('./routes/userRoutes')
app.use('/api',userRoutes)

app.listen(3000,function (){
      console.log("Server is listen on port 3000")
})