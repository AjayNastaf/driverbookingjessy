const express = require('express');
const router = express.Router();
const nodemailer = require("nodemailer");
const db = require('../db')

// const app = express();
// app.use(bodyParser.json());

// Nodemailer setup

router.get('/organisationdatafordriveremail', (req, res) => {
  db.query( 'SELECT EmailApp_Password as Sendmailauth , Sender_Mail as Mailauthpass FROM usercreation WHERE EmailApp_Password IS NOT NULL AND EmailApp_Password != "" AND Sender_Mail IS NOT NULL AND Sender_Mail != ""', (err, result) => {
      if (err) {
          return res.status(500).json({ error: 'Failed to retrieve route data from MySQL' });
      }
      if (result.length === 0) {
          return res.status(404).json({ error: 'Email data not found' });
      }
      // console.log(result, 'dsgvd')
      return res.status(200).json(result);

  });
})
//const transporter = nodemailer.createTransport({
//  service: "gmail", // Use your email service
//  auth: {
//    user: "fahadlee2000727@gmail.com", // Your email
//    pass: "hcwc uygz pdxc kqgb", // Your email password or app password
//  },
//});


//router.post("/register", async (req, res) => {
//  const { username, email, password ,mobileNumber} = req.body;
//
//  // Register user logic here (e.g., save to database)
// const sqlQuery = "INSERT INTO drivercreation (drivername , username, Mobilenumber, Email, userpassword)";
//   db.query(sqlQuery,[username,username,mobileNumber,email,password],(error,result)=>{
//   if(error){
//   console.log(error,"error register")
//   }
//           res.status(200).json({ message: 'Driver Credential Registered successfully' });
//
//   })
//  // Send welcome email
//  const mailOptions = {
//    from: "fahadlee2000727@gmail.com",
//    to: email,
//    subject: "Welcome to Our NASTAF",
//    text: `Hi ${username},\n\nWelcome to our app! We're glad to have you on board.\n\n Username: ${username}\n Password: ${password} \nBest,\nThe Team`,
//  };
//
//  transporter.sendMail(mailOptions, (error, info) => {
//    if (error) {
//      return res
//        .status(500)
//        .send({
//          message: "Registration successful, but email failed to send.",
//        });
//    }
//    res
//      .status(201)
//      .send({ message: "Registration successful and email sent!" });
//      console.log({ message: "Registration successful and email sent!" });
//
//  });
//});

// Email Transporter Configuration
const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: "sharan1228s@gmail.com", // Use environment variables
    pass: "uqbh faoi ipum dhqb", // Store password securely
  },
});


router.post("/driverCredentialRegister", async (req, res) => {
  const { username, email, password, mobileNumber } = req.body;

  if (!username || !email || !password || !mobileNumber) {
    return res.status(400).json({ message: "All fields are required." });
  }

  // SQL Query to insert driver credentials
  const sqlQuery =
    "INSERT INTO drivercreation (drivername, username, Mobileno, Email, userpassword) VALUES (?, ?, ?, ?, ?)";

  db.query(
    sqlQuery,
    [username, username, mobileNumber, email, password],
    (error, result) => {
      if (error) {
        console.error("Error during registration:", error);
        return res.status(500).json({ message: "Failed to register driverrrr." });
      }

      // Send welcome email
      const mailOptions = {
        from: "fahadlee2000727@gmail.com",
        to: email,
        subject: "Welcome to NASTAF",
        text: `Hi ${username},\n\nWelcome to our app! We're glad to have you on board.\n\nUsername: ${username}\nPassword: ${password}\n\nBest,\nThe NASTAF Team`,
      };

      transporter.sendMail(mailOptions, (emailError, info) => {
        if (emailError) {
          console.error("Email sending failed:", emailError);
          return res.status(500).json({
            message: "Registration successful, but email failed to send.",
          });
        }

        console.log("Registration and email sent successfully!");
        return res
          .status(201)
          .json({ message: "Registration successful and email sent!" });
      });
    }
  );
});


router.get('/TemplateForDriverCreation', async (req, res) => {
  const query = 'SELECT TemplateMessageData FROM TemplateMessage WHERE TemplateInfo = "DriverInfo"';
  db.query(query, (err, results) => {
      if (err) {
          console.log('Database error:', err);
          return res.status(500).json({ error: 'Failed to fetch data from MySQL' });
      }
      // console.log('Database results:', results);
      return res.status(200).json(results);
  });
});





router.post('/send-email1', async (req, res) => {
console.log('fffffffffffffffffffffffffffffffffffffffffffffffffff')
    try {
//        const { guestname,guestmobileno,email,Startkm, closekm, duration,Sender_Mail,EmailApp_Password } = req.body;
        const { guestname,guestmobileno,email,Startkm, closekm, duration,Sender_Mail,EmailApp_Password, TripId,Vechicle_Number,Vechicl_Name,Duty_type,Report_time,Release_time,Report_date,Release_date,StartPoint,EndPoint } = req.body;
        console.log(guestname,guestmobileno,email,Startkm, closekm, duration,Sender_Mail,EmailApp_Password, TripId,Vechicle_Number,Vechicl_Name,Duty_type,Report_time,Release_time,Report_date,Release_date,StartPoint,EndPoint, "mailto")

        // Create a Nodemailer transporter
        const transporter = nodemailer.createTransport({
            host: 'smtp.gmail.com',
            port: 465,
            secure: true,

            auth: {
                user:Sender_Mail,
                pass:EmailApp_Password,
            },
            tls: {
                rejectUnauthorized: false
            }
        });




            const customerMailOptions1 = {
                from:`${Sender_Mail}`,
                to: `${email}`,
                subject: `JESSY CABS PVT LTD BOOKING CONFIRMATION FOR ${guestname} `,
                html: `

<div style="margin:0; padding:0; font-family: 'Segoe UI', sans-serif; background-color: #f4f4f4;">

  <div style="max-width: 700px; margin: 30px auto; background: white; border-radius: 12px; overflow: hidden; box-shadow: 0 5px 15px rgba(0,0,0,0.1);">

    <!-- HEADER -->
    <div style="display: flex; background: linear-gradient(90deg, #203f7d, #4c68d7); color: white;">
      <div style="flex: 1; padding: 30px;">
        <h1 style="margin: 0; font-size: 26px;">Thanks for Riding, ${guestname}!</h1>
        <p style="margin: 8px 0 0; color:#ffffff;">We hope you had a great experience with Jessy Cabs.</p>
      </div>
      <div style="flex: 1; display: flex; align-items: center; justify-content: center; padding: 20px;">
        <img src="https://images.icon-icons.com/2093/PNG/512/taxi_cab_transportation_automobile_car_vehicle_icon_128574.png

" alt="Car Icon" width="120" />
      </div>
    </div>

    <!-- TRIP DETAILS -->
    <div style="padding: 30px;">
      <h2 style="color: #333; font-size: 20px; margin-bottom: 20px;">Trip Summary</h2>

      <div style=" padding:20px;">
        <div style="min-width: 200px;max-width: 700px; margin-Top:15px; background: #f1f1f1; padding: 15px; border-radius: 8px;">
          <strong>Trip No:</strong><br> ${TripId}
        </div>


        <div style=" min-width: 200px;max-width: 700px; margin-Top:15px; background: #f1f1f1;margin-Top:15px; padding: 15px; border-radius: 8px;">
          <strong>Vehicle Number:</strong><br> ${Vechicle_Number}
        </div>



        <div style="min-width: 200px;max-width: 700px; margin-Top:15px; background: #f1f1f1; padding: 15px; border-radius: 8px;">
          <strong>Vehicle Name:</strong><br> ${Vechicl_Name}
        </div>


        <div style="min-width: 200px;max-width: 700px; margin-Top:15px; background: #f1f1f1; padding: 15px; border-radius: 8px;">
          <strong>Duty Type:</strong><br> ${Duty_type}
        </div>


        <div style="min-width: 200px;max-width: 700px; margin-Top:15px; background: #f1f1f1; padding: 15px; border-radius: 8px;">
          <strong>Reporting Time:</strong><br> ${Report_time}
        </div>
        <div style="min-width: 200px;max-width: 700px; margin-Top:15px; background: #f1f1f1; padding: 15px; border-radius: 8px;">
          <strong>Releasing Time:</strong><br> ${Release_time}
        </div>
        <div style="min-width: 200px;max-width: 700px; margin-Top:15px; background: #f1f1f1; padding: 15px; border-radius: 8px;">
          <strong>Reporting Date:</strong><br> ${Report_date}
        </div>
        <div style=" min-width: 200px;max-width: 700px; margin-Top:15px; background: #f1f1f1; padding: 15px; border-radius: 8px;">
          <strong>Releasing Date:</strong><br> ${Release_date}
        </div>
        <div style="min-width: 200px;max-width: 700px; margin-Top:15px; background: #f1f1f1; padding: 15px; border-radius: 8px;">
          <strong>Total Kilometers:</strong><br> ${closekm}
        </div>
        <div style="min-width: 200px;max-width: 700px; margin-Top:15px; background: #f1f1f1; padding: 15px; border-radius: 8px;">
          <strong>Trip Duration:</strong><br> ${duration}
        </div>




      </div>

      <!-- ROUTE TIMELINE -->
      <div style="margin-top: 40px;">
        <h3 style="font-size: 18px; color: #333;">Journey Route</h3>
        <div style="position: relative; padding-left: 25px; margin-top: 20px;">

          <!-- Start -->
          <div style="position: relative; margin-bottom: 30px;">
            <div style="position: absolute; left: 0; top: 5px; width: 12px; height: 12px; background: #6a11cb; border-radius: 50%;"></div>
            <div style="background: #e3e8f7; padding: 15px; border-radius: 8px;">
              <strong>Start Point</strong><br>
              ${StartPoint}
            </div>
          </div>

          <!-- End -->
          <div style="position: relative;">
            <div style="position: absolute; left: 0; top: 5px; width: 12px; height: 12px; background: #ff5722; border-radius: 50%;"></div>
            <div style="background: #fbe9e7; padding: 15px; border-radius: 8px;">
              <strong>End Point</strong><br>
              ${EndPoint}
            </div>
          </div>
        </div>
      </div>

      <!-- FOOTER -->
      <div style="margin-top: 50px; font-size: 14px; color: #666;">
        <hr style="border: none; border-top: 1px solid #ddd; margin: 30px 0;">
        <p style="margin: 0;">Need help? Contact us anytime:</p>
        <p style="margin: 5px 0 0;">
          <strong>Jessy Cabs Pvt Ltd</strong><br>
          📍 Flat No 2, II Floor, Swathi Complex, Nandanam, Chennai - 600017<br>
          📞 04449105959 / 8754515959<br>
          📧 booking@jessycabs.in<br>
          🌐 <a href="https://www.jessycabs.in" style="color: #2575fc; text-decoration: none;">www.jessycabs.in</a>
        </p>
      </div>
    </div>
  </div>

</div>


          `,
            }
            // await transporter.sendMail(ownerMailOptions1);

console.log(customerMailOptions1, "iopoi")
            await transporter.sendMail(customerMailOptions1);
            res.status(200).json({ message: 'Email sent successfully' });



    } catch (error) {
    console.log(error,"mailll")
        res.status(500).json({ message: 'An error occurred while sending the email' });
    }
});















module.exports = router;

