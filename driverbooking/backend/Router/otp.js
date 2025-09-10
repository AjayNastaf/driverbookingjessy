

// module.exports =  router;
const express = require("express");
const router = express.Router();
const nodemailer = require("nodemailer");
const twilio = require("twilio");
require("dotenv").config();
const axios= require("axios");
const db = require('../db');
//app.use(express.json());
//app.use(express.urlencoded({ extended: true }));




  const now = new Date();

       const formattedDate = now.getFullYear() +
         '/' + String(now.getMonth() + 1).padStart(2, '0') +
         '/' + String(now.getDate()).padStart(2, '0');

       console.log('date format',formattedDate); // Example: "2025/06/23"


function generateOTP() {
    return Math.floor(1000 + Math.random() * 9000).toString();
}

//router.post('/send-otp', async (req, res) => {
//const { mobile, email , name, senderEmail, senderPass, tripId } = req.body;
//
//   console.log('Raw request body:', req.body);
//   console.log('Raw request body:', mobile);
//   console.log('Raw request body:', email);
//
//   console.log('Raw request body:', name);
//   console.log('Raw request body:',tripId );
//
//   const isValidEmail = (value) => {
//  if (!value) return false;
//  const email = value.trim();
//  if (email === '' || /^_+$/.test(email)) return false;
//  // Basic email format regex
//  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
//  return emailRegex.test(email);
//};
//
//const sendEmail = isValidEmail(email);
//
//
//
//  if (!mobile) {
//    return res.status(400).json({ message: "mobile is required" });
//  }
//
//  const otp = generateOTP();
//
//  const mailOptions = {
//    from:senderEmail,
//    to:email,
//    subject: 'Your OTP Code',
//    text: `Dear ${name}, Your booking OTP is ${otp}. Valid for 5 minutes. Please do not share your OTP with anyone. - JESSYCABS.`,
//  };
//
//  try {
//
//    if(sendEmail){
//
//      const transporter = nodemailer.createTransport({
//              host: 'smtp.gmail.com',
//              port: 465,
//              secure: true,
//               auth: {
//                   user:senderEmail,
//                   pass:senderPass,
//               },
//
//              tls: {
//                  rejectUnauthorized: false
//              }
//          });
//
//   console.log(mailOptions , "mailOptions")
//    // Send Email
//    await transporter.sendMail(mailOptions);
//    console.log(" Email sent successfully");
//
//    } else {
//      console.log("❌ No valid email provided. Skipping email sending.");
//    }
//
//
//    // Prepare SMS body
//    const smsBody = {
//      SenderId: process.env.SMS_SENDERID,
//      // Message: `Dear ${name}, your OTP is ${otp}. Valid for 5 minutes. Do not share. - JESSYCABS.`,
//      Message:`Dear ${name}, Your Boarding  OTP is ${otp}. Valid for 5 minutes. Please do not share your OTP with anyone. - JESSYCABS`,
//      MobileNumbers: mobile,
//      TemplateId: process.env.SMS_TEMPLATEID_On,
//      ApiKey: process.env.SMS_APIKEY,
//      ClientId: process.env.SMS_CLIENTID,
//    };
//
//    // Send SMS
//    // console.log('sms body',smsBody);
//
//    const smsResponse = await axios.post(process.env.SMS_APIURL, smsBody);
//    // console.log(smsResponse,"smsre")
//    const smsData = smsResponse.data.Data?.[0]; // Optional chaining for safety
//
//    if (!smsData) {
//      console.log("SMS API returned unexpected format");
//      return res.status(500).json({ message: "SMS API error: Invalid response format", otp });
//    }
//
//    const { MessageErrorCode, MessageErrorDescription, MessageId } = smsData;
//     console.log(MessageErrorCode, MessageErrorDescription, MessageId ,"smsrerr")
//
//    if (MessageErrorCode !== 0) {
//      console.error('SMS Error:', MessageErrorDescription);
//      console.log("OTP Email sent, but SMS failed");
//      return res.status(500).json({
//        message: "OTP Email sent, but SMS failed",
//        smsError: MessageErrorDescription,
//        otp,
//      });
//    }
//
//        const insertQuery = `INSERT INTO SmsReport (SmsMessageid, smsDate, tripid) VALUES (?, ?, ?)`;
//
//       db.query(insertQuery, [MessageId, formattedDate, tripId], (err) => {
//                      if(err){
//                      return res.status(400).send({ message : "Server Error"});
//                      }
//                console.log("inserted messageId and Date for onboard");
//
//
//    // console.log(' SMS sent successfully, Message ID:', MessageId);
//    return res.status(200).json({
//      message: "OTP sent via Email and SMS",
//      otp,
//      messageId: MessageId,
//    });
//
//    });
//
//  } catch (err) {
//    console.error(" Error sending OTP:", err.message || err);
//    return res.status(500).json({ message: "Failed to send OTP", error: err.message });
//  }
//});

router.post('/send-otp', async (req, res) => {
const { mobile, email, name, senderEmail, senderPass, tripId } = req.body;

   console.log('Raw request body for first otp:', req.body);
   console.log('Raw request body:', mobile);
   console.log('Raw request body:', email);

   console.log('Raw request body:', name);
   console.log('Raw request body:',tripId );

   const isValidEmail = (value) => {
  if (!value) return false;
  const email = value.trim();
  if (email === '' || /^_+$/.test(email)) return false;
  // Basic email format regex
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
};

const sendEmail = isValidEmail(email);



  if (!mobile) {
    return res.status(400).json({ message: "mobile is required" });
  }

  const otp = generateOTP();


    console.log('oooooooo', otp);

  // const mailOptions = {
  //   from:senderEmail,
  //   to:email,
  //   subject: 'JESSY CABS PVT LTD YOUR BOARDING OTP Code',
  //   text: ` Dear ${name},\n\nGreetings from *JESSY CABS PVT LTD!*\n\nYour boarding OTP is: ${otp}\n\nThis OTP is valid for 5 minutes and has also been sent to your registered contact number.\n\nPlease do not share your OTP with anyone.\n\nWe are committed to providing you the best service at all times.\n\nYour trusted travel partner,\n*JESSY CABS PVT LTD*,`,
  // };
  const mailOptions = {
  from: senderEmail,
  to: email,
  subject: 'JESSY CABS PVT LTD YOUR BOARDING OTP Code',
  html: `
    <p>Dear ${name},</p>
    <p>Greetings from <strong>JESSY CABS PVT LTD!</strong></p>
    <p>Your boarding OTP is: <strong>${otp}</strong></p>
    <p>This OTP is valid for 5 minutes and has also been sent to your registered contact number.</p>
    <p><strong>Please do not share your OTP with anyone.</strong></p>
    <p>We are committed to providing you the best service at all times.</p>
    <p>Your trusted travel partner,<br/><strong>JESSY CABS PVT LTD</strong></p>
  `,
};

  try {

    if(sendEmail){

      const transporter = nodemailer.createTransport({
              host: 'smtp.gmail.com',
              port: 465,
              secure: true,
               auth: {
                   user:senderEmail,
                   pass:senderPass,
               },

              tls: {
                  rejectUnauthorized: false
              }
          });

   console.log(mailOptions , "mailOptions")
    // Send Email
    await transporter.sendMail(mailOptions);
    console.log(" Email sent successfully");

    } else {
      console.log("❌ No valid email provided. Skipping email sending gg.");
    }


    // Prepare SMS body
    const smsBody = {
      SenderId: process.env.SMS_SENDERID,
      // Message: `Dear ${name}, your OTP is ${otp}. Valid for 5 minutes. Do not share. - JESSYCABS.`,
      Message:`Dear ${name}, Your Boarding  OTP is ${otp}. Valid for 5 minutes. Please do not share your OTP with anyone. - JESSYCABS`,
      MobileNumbers: mobile,
      TemplateId: process.env.SMS_TEMPLATEID_On,
      ApiKey: process.env.SMS_APIKEY,
      ClientId: process.env.SMS_CLIENTID,
    };

    // Send SMS
    // console.log('sms body',smsBody);

    const smsResponse = await axios.post(process.env.SMS_APIURL, smsBody);
    // console.log(smsResponse,"smsre")
    const smsData = smsResponse.data.Data?.[0]; // Optional chaining for safety

    if (!smsData) {
      console.log("SMS API returned unexpected format");
      return res.status(500).json({ message: "SMS API error: Invalid response format", otp });
    }

    const { MessageErrorCode, MessageErrorDescription, MessageId } = smsData;
     console.log(MessageErrorCode, MessageErrorDescription, MessageId ,"smsrerr")

    if (MessageErrorCode !== 0) {
      console.error('SMS Error:', MessageErrorDescription);
      console.log("OTP Email sent, but SMS failed");
      return res.status(500).json({
        message: "OTP Email sent, but SMS failed",
        smsError: MessageErrorDescription,
        otp,
      });
    }

        const insertQuery = `INSERT INTO SmsReport (SmsMessageid, smsDate, tripid) VALUES (?, ?, ?)`;

       db.query(insertQuery, [MessageId, formattedDate, tripId], (err) => {
                      if(err){
                      return res.status(400).send({ message : "Server Error"});
                      }
                console.log("inserted messageId and Date for onboard");


    // console.log(' SMS sent successfully, Message ID:', MessageId);
    return res.status(200).json({
      message: "OTP sent via Email and SMS",
      otp,
      messageId: MessageId,
    });

    });

  } catch (err) {
    console.error(" Error sending OTP:", err.message || err);
    return res.status(500).json({ message: "Failed to send OTP", error: err.message });
  }
});


// Last OTP

// router.post('/verifyotp', async (req, res) => {

//   const { mobile,email, name } = req.body;

//         console.log('Raw request body2:', req.body);
//         console.log('Received verify email for OTP', email)
//         console.log('Received verify number for OTP', mobile)
//         console.log('Received verify name for OTP', name)

//         console.log("Sender mail for verify", process.env.EMAIL_USER)
//     if (!email || !mobile) {
//         return res.status(400).json({ message: "Email and mobile are required" });
//     }

//     const otp = generateOTP();

//     const mailOptions = {
//         from: process.env.EMAIL_USER,
//         to: email,
//         subject: 'Your OTP Code',
//         text: `Dear ${name}, Your De-Boarding OTP is ${otp}. Valid for 5 minutes. Please do not share your OTP with anyone. - JESSYCABS.`,

//     };


//     try {
//         await transporter.sendMail(mailOptions);
//         console.log("Email send success last");

//         return res.status(200).json({ message: "OTP sent via Email and SMS", otp });
//     } catch (err) {
//         console.error("Error sending OTP:", err);
//         return res.status(500).json({ message: "Failed to send OTP", error: err.message });
//     }
// });


//router.post('/verifyotp', async (req, res) => {
//const { mobile, email, name, senderEmail, senderPass, tripId} = req.body;
//  // console.log('Raw request body 2:', req.body);
//
//
//   const isValidEmail = (value) => {
//  if (!value) return false;
//  const email = value.trim();
//  if (email === '' || /^_+$/.test(email)) return false;
//  // Basic email format regex
//  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
//  return emailRegex.test(email);
//};
//
//const sendEmail = isValidEmail(email);
//
//
//  if (!mobile) {
//    return res.status(400).json({ message: "Email and mobile are required" });
//  }
//
//
//  const otp = generateOTP();
//
//  const mailOptions = {
//    from: senderEmail,
//    to: email,
//    subject: 'Your OTP Code',
//    text: `Dear ${name}, Your De-Boarding OTP is ${otp}. Valid for 5 minutes. Please do not share your OTP with anyone. - JESSYCABS`,
//
//
//    //Dear {#var#}, Your De-Boarding OTP is {#var#}. Valid for 5 minutes. Please do not share your OTP with anyone. - JESSYCABS
//  };
//
//  try {
//
//    if(sendEmail){
//
//       const transporter = nodemailer.createTransport({
//              host: 'smtp.gmail.com',
//              port: 465,
//              secure: true,
//               auth: {
//                   user: senderEmail,
//                   pass: senderPass,
//               },
//              // auth: {
//              //     user: process.env.MAIL_AUTH,
//              //     pass:process.env.MAIL_PASS,
//              // },
//  //            auth: {
//  //                user: Sendmailauth,
//  //                pass: Mailauthpass,
//  //            },
//              tls: {
//                  rejectUnauthorized: false
//              }
//          });
//    // Send Email
//    await transporter.sendMail(mailOptions);
//    console.log(" Email sent successfully");
//
//    } else {
//      console.log(" No valid email provided. Skipping  sending email.");
//    }
//
//    // Prepare SMS body
//    const smsBody = {
//      SenderId: process.env.SMS_SENDERID,
//      // Message: Dear ${name}, your OTP is ${otp}. Valid for 5 minutes. Do not share. - JESSYCABS.,
//      Message:`Dear ${name}, Your De-Boarding  OTP is ${otp}. Valid for 5 minutes. Please do not share your OTP with anyone. - JESSYCABS`,
//      MobileNumbers: mobile,
//      TemplateId: process.env.SMS_TEMPLATEID_De,
//      ApiKey: process.env.SMS_APIKEY,
//      ClientId: process.env.SMS_CLIENTID,
//    };
//
//    // Send SMS
//    // console.log('sms body',smsBody);
//
//    const smsResponse = await axios.post(process.env.SMS_APIURL, smsBody);
//    // console.log(smsResponse,"smsre")
//    const smsData = smsResponse.data.Data?.[0]; // Optional chaining for safety
//
//    if (!smsData) {
//      console.log("SMS API returned unexpected format");
//      return res.status(500).json({ message: "SMS API error: Invalid response format", otp });
//    }
//
//    const { MessageErrorCode, MessageErrorDescription, MessageId } = smsData;
//    // console.log(MessageErrorCode, MessageErrorDescription, MessageId ,"smsrerr")
//
//    if (MessageErrorCode !== 0) {
//      console.error('SMS Error:', MessageErrorDescription);
//      console.log("OTP Email sent, but SMS failed");
//      return res.status(500).json({
//        message: "OTP Email sent, but SMS failed",
//        smsError: MessageErrorDescription,
//        otp,
//      });
//    }
//
//        console.log("otp send from backend for verify", otp);
//
//          const insertQuery = `INSERT INTO SmsReport (SmsMessageid, smsDate, tripid) VALUES (?, ?, ?)`;
//
//          db.query(insertQuery, [MessageId, formattedDate, tripId], (err) => {
//                              if(err){
//                             console.log("error for inserting messageID",err);
//
//                              return res.status(400).send({ message : "Server Error"});
//                              }
//                        console.log("inserted messageId and Date for deboard");
//
//
//
//    console.log(' SMS sent successfully, Message ID:', MessageId);
//    return res.status(200).json({
//      message: "OTP sent via Email and SMS",
//      otp,
//      messageId: MessageId,
//    });
//});
//  } catch (err) {
//    console.error(" Error sending OTP:", err.message || err);
//    return res.status(500).json({ message: "Failed to send OTP", error: err.message });
//  }
//});

router.post('/verifyotp', async (req, res) => {
const { mobile, email, name, senderEmail, senderPass, tripId} = req.body;


   console.log('Raw request body for verify otp:', req.body);


   const isValidEmail = (value) => {
  if (!value) return false;
  const email = value.trim();
  if (email === '' || /^_+$/.test(email)) return false;
  // Basic email format regex
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
};

const sendEmail = isValidEmail(email);


  if (!mobile) {
    return res.status(400).json({ message: "Email and mobile are required" });
  }


  const otp = generateOTP();


  console.log('ottttttt', otp);

  // const mailOptions = {
  //   from: senderEmail,
  //   to: email,
  //   subject: 'JESSY CABS PVT LTD YOUR DE-BOARDING OTP Code',
  //   text: `Dear ${name},\n\nGreetings from *JESSY CABS PVT LTD!*\n\nYour De-boarding OTP is: ${otp}\n\nThis OTP is valid for 5 minutes and has also been sent to your registered contact number.\n\nPlease do not share your OTP with anyone.\n\nWe are committed to providing you the best service at all times.\n\nYour trusted travel partner,\n*JESSY CABS PVT LTD*`,


  //   //Dear {#var#}, Your De-Boarding OTP is {#var#}. Valid for 5 minutes. Please do not share your OTP with anyone. - JESSYCABS
  // };

  const mailOptions = {
  from: senderEmail,
  to: email,
  subject: 'JESSY CABS PVT LTD YOUR DE-BOARDING OTP Code',

  html: `
    <p>Dear ${name},</p>
    <p>Greetings from <strong>JESSY CABS PVT LTD!</strong></p>
    <p>Your De-boarding OTP is: <strong>${otp}</strong></p>
    <p>This OTP is valid for 5 minutes and has also been sent to your registered contact number.</p>
    <p><strong>Please do not share your OTP with anyone.</strong></p>
    <p>We are committed to providing you the best service at all times.</p>
    <p>Your trusted travel partner,<br/><strong>JESSY CABS PVT LTD</strong></p>
  `,
};

  try {

    if(sendEmail){

       const transporter = nodemailer.createTransport({
              host: 'smtp.gmail.com',
              port: 465,
              secure: true,
               auth: {
                   user: senderEmail,
                   pass: senderPass,
               },
              // auth: {
              //     user: process.env.MAIL_AUTH,
              //     pass:process.env.MAIL_PASS,
              // },
  //            auth: {
  //                user: Sendmailauth,
  //                pass: Mailauthpass,
  //            },
              tls: {
                  rejectUnauthorized: false
              }
          });
    // Send Email
    await transporter.sendMail(mailOptions);
    console.log(" Email sent successfully");

    } else {
      console.log(" No valid email provided. Skipping  sending email.");
    }

    // Prepare SMS body
    const smsBody = {
      SenderId: process.env.SMS_SENDERID,
      // Message: Dear ${name}, your OTP is ${otp}. Valid for 5 minutes. Do not share. - JESSYCABS.,
      Message:`Dear ${name}, Your De-Boarding  OTP is ${otp}. Valid for 5 minutes. Please do not share your OTP with anyone. - JESSYCABS`,
      MobileNumbers: mobile,
      TemplateId: process.env.SMS_TEMPLATEID_De,
      ApiKey: process.env.SMS_APIKEY,
      ClientId: process.env.SMS_CLIENTID,
    };

    // Send SMS
    // console.log('sms body',smsBody);

    const smsResponse = await axios.post(process.env.SMS_APIURL, smsBody);
    // console.log(smsResponse,"smsre")
    const smsData = smsResponse.data.Data?.[0]; // Optional chaining for safety

    if (!smsData) {
      console.log("SMS API returned unexpected format");
      return res.status(500).json({ message: "SMS API error: Invalid response format", otp });
    }

    const { MessageErrorCode, MessageErrorDescription, MessageId } = smsData;
    // console.log(MessageErrorCode, MessageErrorDescription, MessageId ,"smsrerr")

    if (MessageErrorCode !== 0) {
      console.error('SMS Error:', MessageErrorDescription);
      console.log("OTP Email sent, but SMS failed");
      return res.status(500).json({
        message: "OTP Email sent, but SMS failed",
        smsError: MessageErrorDescription,
        otp,
      });
    }

        console.log("otp send from backend for verify", otp);

          const insertQuery = `INSERT INTO SmsReport (SmsMessageid, smsDate, tripid) VALUES (?, ?, ?)`;

          db.query(insertQuery, [MessageId, formattedDate, tripId], (err) => {
                              if(err){
                             console.log("error for inserting messageID",err);

                              return res.status(400).send({ message : "Server Error"});
                              }
                        console.log("inserted messageId and Date for deboard");



    console.log(' SMS sent successfully, Message ID:', MessageId);
    return res.status(200).json({
      message: "OTP sent via Email and SMS",
      otp,
      messageId: MessageId,
    });
});
  } catch (err) {
    console.error(" Error sending OTP:", err.message || err);
    return res.status(500).json({ message: "Failed to send OTP", error: err.message });
  }
});

router.get('/organizationdata', (req, res) => {


  console.log('backend origin start');

     db.query('SELECT * FROM organizationdetails', (err, result) => {
        if (err) {
          console.log('Error is',err);
            return res.status(500).json({ error: 'Failed to retrieve route data from MySQL' });
        }

        if (result.length === 0) {
          console.log('result not found', result);
            return res.status(404).json({ error: 'Route data not found' });
        }
        // console.log('response', result);

        const routeData = result;
        return res.status(200).json(routeData);
});
});









module.exports = router;

