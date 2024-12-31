const express = require('express');
const router = express.Router();
const nodemailer = require("nodemailer");


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
      console.log(result, 'dsgvd')
      return res.status(200).json(result);

  });
})
const transporter = nodemailer.createTransport({
  service: "gmail", // Use your email service
  auth: {
    user: "fahadlee2000727@gmail.com", // Your email
    pass: "hcwc uygz pdxc kqgb", // Your email password or app password
  },
});


router.post("/register", async (req, res) => {
  const { username, email, password } = req.body;

  // Register user logic here (e.g., save to database)

  // Send welcome email
  const mailOptions = {
    from: "fahadlee2000727@gmail.com",
    to: email,
    subject: "Welcome to Our NASTAF",
    text: `Hi ${username},\n\nWelcome to our app! We're glad to have you on board.\n\n Username: ${username}\n Password: ${password} \nBest,\nThe Team`,
  };

  transporter.sendMail(mailOptions, (error, info) => {
    if (error) {
      return res
        .status(500)
        .send({
          message: "Registration successful, but email failed to send.",
        });
    }
    res
      .status(201)
      .send({ message: "Registration successful and email sent!" });
      console.log({ message: "Registration successful and email sent!" });

  });
});

router.get('/TemplateForDriverCreation', async (req, res) => {
  const query = 'SELECT TemplateMessageData FROM TemplateMessage WHERE TemplateInfo = "DriverInfo"';
  db.query(query, (err, results) => {
      if (err) {
          console.log('Database error:', err);
          return res.status(500).json({ error: 'Failed to fetch data from MySQL' });
      }
      console.log('Database results:', results);
      return res.status(200).json(results);
  });
});

module.exports = router;

