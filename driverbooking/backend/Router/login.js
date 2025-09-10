const express = require('express');
const router = express.Router();
const db = require('../db');
const multer = require('multer');
require("dotenv").config();
// const path = require('path');
const axios= require("axios")
const imageFolderPath = require('../imageurl');

// const path = require('path'); // Import path module
// console.log(`${imageFolderPath}/user_profile`)
// const baseImagePath = path.join(`${imageFolderPath}/user_profile`);
// console.log(baseImagePath,"kkjkjkkk")

const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, `${imageFolderPath}/user_profile`); // Store uploaded files in the 'uploads' directory
    },
    filename: (req, file, cb) => {
        // const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
        // cb(null, `${uniqueSuffix}-${file.originalname}`);
        cb(null, `${file.fieldname}_${Date.now()}-${file.originalname}`);
    },
});
const upload = multer({ storage: storage });





router.post('/login', (req, res) => {
    const { username, userpassword } = req.body;
    console.log(username ,userpassword,"yser")

    db.query('SELECT * FROM drivercreation WHERE username = ? AND userpassword = ?', [username, userpassword], (err, result) => {

        if (err) {
            return res.status(500).json({ error: 'Failed to retrieve user details from MySQL' });
        }
       
        if(result.length > 0){
      
        // console.log(user,"uuuuuppp",result[0]?.length)
        db.query("UPDATE drivercreation SET active ='yes' WHERE username = ? AND userpassword = ?", [username,userpassword], (err, result1) => {
            if (err) {
                console.log(err, "error");
                return res.status(500).json({ error: 'Failed to update status' });
            }
            console.log(result, 'result');
            return res.status(200).json({ message: 'Login successful', user : result });
//             return res.status(200).json(result);
        });
    }
    else{
        // console.log("login failed")
        return res.status(404).json({ error: 'Invalid credentials. Please check your username and userpassword.' });
    }

   
    });
});





router.post("/signup", async (req, res) => {
  try {
    const { name, email = "", phone, vechiNo= "" } = req.body;

       const now = new Date();

       const formattedDate = now.getFullYear() +
         '/' + String(now.getMonth() + 1).padStart(2, '0') +
         '/' + String(now.getDate()).padStart(2, '0');

       console.log('date format',formattedDate); // Example: "2025/06/23"

    console.log('first step phone number received', name, email, phone, vechiNo);

    const otp = Math.floor(1000 + Math.random() * 9000).toString();
    const mobile = phone;

//    const selectQuery = 'SELECT * FROM drivercreation WHERE username = ?';
    const selectQuery = 'SELECT * FROM drivercreation WHERE Mobileno = ?';
    console.log(selectQuery,'ddddddddd');

    db.query(selectQuery, [phone], (selectErr, selectResult) => {
      if (selectErr) {
        console.error("Database select error:", selectErr);
        return res.status(500).json({ message: "Database error", success: false });
      }

      console.log(selectResult,'rrrrrrrrrr');

      if (selectResult.length > 0) {
        console.log('user already exists');

        return res.status(409).json({
          message: "User Already Exists",
          success: false
        });
      }

      const insertQuery = 'INSERT INTO drivercreation (username, Drivername, Email, Mobileno, driverhiretype, vegRegNo) VALUES (?, ?, ?, ?, "Outside Driver", ?)';
      db.query(insertQuery, [name, name, email, phone, vechiNo], async (insertErr, insertResult) => {
        console.log('insert successfully');

        if (insertErr) {
          console.error("Database insert error:", insertErr);
          return res.status(500).json({ message: "Database error", success: false });
        }

        const userId = insertResult.insertId;
        console.log('insert Id is', userId);

        const smsBody = {
          SenderId: process.env.SMS_SENDERID,

          // Don't remove and add anything here

          Message:`Your JESSYCABS Driver verification code is: ${otp}
Please enter this OTP to verify your phone number.
Do not share this code with anyone.

- JESSYCABS PVT LTD`,

//

//          Message:`Your JESSYCABS Driver verification code is: 4343
// Please enter this OTP to verify your phone number.
// Do not share this code with anyone.

// - JESSYCABS PVT LTD`,

          MobileNumbers: mobile,
          TemplateId: process.env.SMS_TEMPLATEID_SIGNUP,
          ApiKey: process.env.SMS_APIKEY,
          ClientId: process.env.SMS_CLIENTID,
        };
            console.log('sms body from first', smsBody);


        try {
          const smsResponse = await axios.post(process.env.SMS_APIURL, smsBody);
          console.log('sms response', smsResponse);

          const smsData = smsResponse.data.Data?.[0];

          console.log('sms data', smsData);

          if (!smsData) {
            return res.status(500).json({
              message: "SMS API error",
              success: false
            });
          }

    const { MessageErrorCode, MessageErrorDescription, MessageId } = smsData;

          if (MessageErrorCode !== 0) {
            return res.status(500).json({
              message: "SMS sending failed",
              smsError: MessageErrorDescription,
              success: false,
            });
          }

          console.log('otp send from first');
          console.log('otp send from first', otp);
          console.log("messageId", MessageId);

        const insertQuery = `INSERT INTO SmsReport (SmsMessageid, smsDate) VALUES (?, ?)`;

       db.query(insertQuery, [MessageId, formattedDate], (err) => {
                if(err){
                return res.status(400).send({ message : "Server Error"});
                }
                    console.log("inserted messageId and Date");
          return res.status(200).json({
            message: "OTP sent successfully",
            otp,
            userId,
            success: true,
          });
        })
        } catch (smsError) {
          console.log("SMS API error:", smsError);
          return res.status(500).json({ message: "Failed to send OTP", success: false });
        }
      });
       });
     } catch (error) {
       console.error("Signup error:", error);
       return res.status(500).json({
         message: "Server Error",
         success: false
       });
     }
   });


router.post("/signup_again_otp", async (req, res) => {

    const {phone} = req.body;

    console.log('second step phone number received', phone);


  try {

    const otp = Math.floor(1000 + Math.random() * 9000).toString();
    const mobile = phone;

    const smsBody = {
      SenderId: process.env.SMS_SENDERID,
          Message:`Your JESSYCABS Driver verification code is: ${otp}
Please enter this OTP to verify your phone number.
Do not share this code with anyone.

- JESSYCABS PVT LTD`,
      MobileNumbers: mobile,
      TemplateId: process.env.SMS_TEMPLATEID_SIGNUP,
      ApiKey: process.env.SMS_APIKEY,
      ClientId: process.env.SMS_CLIENTID,
    };

    console.log('sms body from second', smsBody);


    const smsResponse = await axios.post(process.env.SMS_APIURL, smsBody);
    const smsData = smsResponse.data.Data?.[0];

    if (!smsData) {
      return res.status(500).json({
        message: "SMS API error",
        success: false
      });
    }

    const { MessageErrorCode, MessageErrorDescription } = smsData;

    if (MessageErrorCode !== 0) {
      return res.status(500).json({
        message: "SMS sending failed",
        smsError: MessageErrorDescription,
        success: false,
      });
    }

        console.log('otp send from second');
        console.log('otp send from second', otp);

    return res.status(200).json({
      message: "OTP sent successfully",
      otp,
      success: true,
    });

  } catch (error) {
    console.error("OTP send error:", error);
    return res.status(500).json({
      message: "Server Error",
      success: false
    });
  }
});

// Login VIA number backend code
router.post("/loginVia", async (req, res) => {
  const { phone } = req.body;
  console.log('third step phone number received', phone);

  const otp = Math.floor(1000 + Math.random() * 9000).toString();
  const mobile = phone;

  const selectQuery = 'SELECT * FROM drivercreation WHERE Mobileno = ?';

  db.query(selectQuery, [phone], async (selectErr, selectResult) => {
    if (selectErr) {
      console.error("Database select error:", selectErr);
      return res.status(500).json({ message: "Database error", success: false });
    }


    console.log(selectResult, 'rrrrrr');

    if (selectResult.length === 0) {
      console.log('Invalid User');
      return res.status(409).json({ message: "Invalid User", success: false });
    }

     const username = selectResult[0].drivername;

    console.log(username, 'wwwwwwwwwwwww');

    const smsBody = {
      SenderId: process.env.SMS_SENDERID,
          Message:`Your JESSYCABS Driver verification code is: ${otp}
Please enter this OTP to verify your phone number.
Do not share this code with anyone.

- JESSYCABS PVT LTD`,
      MobileNumbers: mobile,
      TemplateId: process.env.SMS_TEMPLATEID_SIGNUP,
      ApiKey: process.env.SMS_APIKEY,
      ClientId: process.env.SMS_CLIENTID,
    };

    try {
      const smsResponse = await axios.post(process.env.SMS_APIURL, smsBody);
      const smsData = smsResponse.data.Data?.[0];

      if (!smsData || smsData.MessageErrorCode !== 0) {
        return res.status(500).json({
          message: "SMS sending failed",
          smsError: smsData?.MessageErrorDescription || "Unknown SMS error",
          success: false,
        });
      }

      return res.status(200).json({
        message: "OTP sent successfully",
        otp,
        username,
        success: true,
      });

    } catch (smsError) {
      console.log("SMS API error:", smsError);
      return res.status(500).json({ message: "Failed to send OTP", success: false });
    }
  });
});

router.post("/loginVia_again_otp", async (req, res) => {

    const {phone} = req.body;

    console.log('fourth step phone number received', phone);


  try {

    const otp = Math.floor(1000 + Math.random() * 9000).toString();
    const mobile = phone;

    const smsBody = {
      SenderId: process.env.SMS_SENDERID,
          Message:`Your JESSYCABS Driver verification code is: ${otp}
Please enter this OTP to verify your phone number.
Do not share this code with anyone.

- JESSYCABS PVT LTD`,
      MobileNumbers: mobile,
      TemplateId: process.env.SMS_TEMPLATEID_SIGNUP,
      ApiKey: process.env.SMS_APIKEY,
      ClientId: process.env.SMS_CLIENTID,
    };

    console.log('sms body from second', smsBody);


    const smsResponse = await axios.post(process.env.SMS_APIURL, smsBody);
    const smsData = smsResponse.data.Data?.[0];

    if (!smsData) {
      return res.status(500).json({
        message: "SMS API error",
        success: false
      });
    }

    const { MessageErrorCode, MessageErrorDescription } = smsData;

    if (MessageErrorCode !== 0) {
      return res.status(500).json({
        message: "SMS sending failed",
        smsError: MessageErrorDescription,
        success: false,
      });
    }

        console.log('otp send from fourth');
        console.log('otp send from fourth', otp);

    return res.status(200).json({
      message: "OTP sent successfully",
      otp,
      success: true,
    });

  } catch (error) {
    console.error("OTP send error:", error);
    return res.status(500).json({
      message: "Server Error",
      success: false
    });
  }
});




router.post('/logoutDriver',(req,res)=>{
    const { username, userpassword } = req.body;
    
   
    db.query("UPDATE drivercreation SET active ='no' WHERE drivername = ? AND userpassword = ?", [username,userpassword], (err, result) => {
        if (err) {
            console.log(err, "error");
            return res.status(500).json({ error: 'Failed to update status' });
        }
        // console.log(result, 'result');
        return res.status(200).json({ message: 'Login successful' });
    });})

//get profile details

// router.get('/getDriverProfile', (req, res) => {
//     const username = req.query.username;
//     const query = 'SELECT * FROM usercreation WHERE username = ?';
//     db.query(query, [username], (err, results) => {
//         if (err) {
//             return res.status(500).json({ error: 'Server error' });
//         }
//         if (results.length === 0) {
//             return res.status(404).json({ error: 'Driver not found' });
//         }
//         const driverProfile = results[0];
//         res.status(200).json(driverProfile);
//     });
// });


router.post('/getDriverProfile', (req, res) => {
        const { username } = req.body;
console.log(username,'username checkkk');
//    const query = 'SELECT * FROM drivercreation WHERE drivername = ?';
    const query = 'SELECT * FROM drivercreation WHERE username = ?';
    db.query(query, [username], (err, results) => {
        if (err) {
            return res.status(500).json({ error: 'Server error' });
        }
        if (results.length === 0) {
            return res.status(404).json({ error: 'Driver not found' });
        }
        const driverProfile = results[0];
        // console.log(driverProfile)
        res.status(200).json(driverProfile);
    });
});
// updating profile page



//router.post('/update_updateprofile', (req, res) => {
//    const { username, mobileno, userpassword, email, drivername } = req.body;
//
//
//    const query = 'UPDATE drivercreation SET username = ?, Mobileno = ?, userpassword = ?, Email = ? WHERE drivername = ?';
//
//    db.query(query, [username, mobileno, userpassword, email, drivername], (err, results) => {
//        if (err) {
//            res.status(500).json({ message: 'Internal server error' });
//            return;
//        }
//
//        res.status(200).json({ message: 'Status updated successfully' });
//    });
//});


router.post('/update_updateprofile', (req, res) => {
    const { username, mobileno, userpassword, email } = req.body;


    const query = 'UPDATE drivercreation SET  Mobileno = ?, userpassword = ?, Email = ? WHERE username = ?';

    db.query(query, [ mobileno, userpassword, email, username], (err, results) => {
        if (err) {
            res.status(500).json({ message: 'Internal server error' });
            return;
        }

        res.status(200).json({ message: 'Status updated successfully' });
    });
});





//end
//uploading profile image
// router.post('/uploadProfilePhoto', upload.single('avatar'), (req, res) => {
//     const { username } = req.query;
//     const filePath = req.file.path;
//     const updateQuery = 'UPDATE usercreation SET profile_image = ? WHERE username = ?';
//     db.query(updateQuery, [filePath, username], (err, results) => {
//         if (err) {
//             res.status(500).json({ message: 'Internal server error' });
//             return;
//         }
//         res.status(200).json({ message: 'Profile photo uploaded successfully' });
//     });
// });




router.post('/uploadProfilePhoto', upload.single('Profile_image'), (req, res) => {
    const { username } = req.query;
    const filePath = req.file.path;
    console.log(filePath,"data")
    
    
let parts = filePath.split("\\");
let fileName = parts.pop();
console.log(fileName); // Output: 1715926172877-792287503-car.jpeg

//    const updateQuery = 'UPDATE drivercreation SET Profile_image = ? WHERE drivername = ?';
    const updateQuery = 'UPDATE drivercreation SET Profile_image = ? WHERE username = ?';
    db.query(updateQuery, [fileName, username], (err, results) => {
        if (err) {
            res.status(500).json({ message: 'Internal server error' });
            return;
        }
       
        res.status(200).json({ message: 'Profile photo uploaded successfully' });
    });
});
//end

router.get('/profile_photos', (req, res) => {
    const { username } = req.query;
   
    const selectQuery = 'SELECT Profile_image FROM drivercreation WHERE drivername = ?';
//    const selectQuery = 'SELECT Profile_image FROM drivercreation WHERE username = ?';
    db.query(selectQuery, [username], (err, results) => {
        if (err) {
            res.status(500).json({ message: 'Internal server error' });
            return;
        }
        if (results.length === 0) {
            res.status(404).json({ message: 'Profile not found' });
            return;
        }
          
      
        const profileImagePath = results[0].Profile_image;
        res.status(200).json({ profileImagePath });
    });
});






router.get("/fetchtripstatus/:tripId",(req,res)=>{

  const {tripId} = req.params;

 const selectQuery ="SELECT status, driverName FROM tripsheet WHERE tripid = ?";

  db.query(selectQuery,[tripId],(err, result)=>{

    if(err){

      console.log("Fetching Error", err);
      return res.status(404).send({ message : "Server Error"});
    }

    if(result.length == 0){

      console.log("No result found");
      return res.status(400).send({ message : "Data Not Found"});
    }

    const status = result[0].status;
    const drivername = result[0].driverName;

      if(status === "Cancelled"){

      const updateQuery = "UPDATE tripsheet SET apps = 'Closed' WHERE tripid = ?";

      db.query(updateQuery,[tripId],(err)=>{

        if(err){
          console.log('Update Error',err);
          return res.status(404).send({ message : "Failed to update"});
        }

          console.log('Status changed to Cancelled and apps closed');

          return res.status(200).send({ status : 'Cancelled', name : drivername});
      })
    } else {

      console.log("Status is not Cancelled:", status);
      return res.status(200).send({ status: status});

    }

  })

})



module.exports = router;