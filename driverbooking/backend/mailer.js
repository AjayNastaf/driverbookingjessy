const express = require("express");
const nodemailer = require("nodemailer");
const bodyParser = require("body-parser");

const app = express();
app.use(bodyParser.json());

// Nodemailer setup
const transporter = nodemailer.createTransport({
  service: "gmail", // Use your email service
  auth: {
    user: "fahadlee2000727@gmail.com", // Your email
    pass: "hcwc uygz pdxc kqgb", // Your email password or app password
  },
});

app.post("/register", async (req, res) => {
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

app.listen(3000, () => {
  console.log("Server running on port 3000");
});
