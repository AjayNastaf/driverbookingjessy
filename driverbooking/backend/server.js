const express = require("express");
const nodemailer = require("nodemailer");
const bodyParser = require("body-parser");
// const fs = require('fs');
const path = require('path');
const db = require('./db');
const cors = require("cors");
require("dotenv").config();

const app = express();
// app.use(cors());
// app.use(bodyParser.json());
app.use(cors());
app.use(express.json());
app.use(bodyParser.json());

// Nodemailer setup
const transporter = nodemailer.createTransport({
  service: "gmail", // Use your email service
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS,
  },
});


app.use('/profile_photos', express.static(path.join(__dirname, 'profile_photos')));
//app.use('/signature_photos', express.static(path.join(__dirname, 'Router/path_to_save_images')));
//app.use('/signatures', express.static(path.join(__dirname, 'Router/path_to_save_images')));
app.use('/signatures', express.static(path.join(__dirname, '../../../Imagefolder/signature_images')));
app.use('/uploads', express.static(path.join(__dirname, '../../../Imagefolder/imagesUploads_doc')));
//app.use('/uploads', express.static(path.join(__dirname, 'uploads')));
// app.use('/images', express.static(path.join(__dirname, 'path_to_save_images')));
console.log(express.static(path.join(__dirname, 'profile_photos')),"ppp")

const loginRoutes = require('./Router/login');
const bookingdetails = require('./Router/bookingdetails');
const closedbookingdetails = require('./Router/closedbooking');
const historypagedetails = require('./Router/historypage');
const signaturerouter = require('./Router/signature');
const closedutyrouter = require('./Router/closeduty');
const uploadbill = require('./Router/upload');
const Mailer = require('./Router/mailer');
const vehcileloc = require('./Router/vehicle');




app.use('/', loginRoutes);
app.use('/', bookingdetails);
app.use('/', closedbookingdetails);
app.use('/', historypagedetails);
app.use('/', signaturerouter);
app.use('/', closedutyrouter);
app.use('/', uploadbill);
app.use('/',Mailer);
app.use('/',vehcileloc);

// Create a MySQL connection
// const db = mysql.createConnection({
//   host: process.env.DB_HOST,
//   user: process.env.DB_USER,
//   password: process.env.DB_PASSWORD,
//   database: process.env.DB_NAME,
// });

// db.connect((err) => {
//   if (err) {
//     throw err;
//   }
//   console.log("MySQL connected");
// });


// Get a registered OTP
// app.post("/retrieveotp", (req, res) => {
//   const { email } = req.body; // Expecting the email to be sent in the body


//   // Check if the email exists in the database
//   const checkOtpSql = "SELECT * FROM registeredotp WHERE email = ?";
//   db.query(checkOtpSql, [email], (err, results) => {
//     if (err) {
//       console.error("Database error:", err);
//       return res.status(500).send({ message: "Database error" });
//     }

//     // If no results, the email doesn't exist
//     if (results.length === 0) {
//       return res.status(404).send({ message: "Email not found" });
//     }

//     // If email exists, return the OTP
//     const otp = results[0].otp;
//     const username = results[0].username;
//     const password = results[0].password;
//     const phonenumber = results[0].phonenumber;

//     // Send OTP in response
//     res.status(200).send({
//       message: "OTP retrieved successfully",
//       otp: otp,
//       username: username,
//       password: password,
//       phonenumber: phonenumber,
//     });
//   });
// });

// Register a new user to register table
// app.post("/userregister", (req, res) => {
//   const { username, email, password, phonenumber} = req.body;

//     console.log("Received data:");
//     console.log("Username:", username);
//     console.log("Email:", email);
//     console.log("Phone:", phonenumber);  // Log received phone number
//     console.log("Password:", password);

//   // Check if username or email already exists
//   const checkUserSql = "SELECT * FROM register WHERE username = ? OR email = ?";
//   db.query(checkUserSql, [username, email], (err, results) => {

//     if (err) {
//       return res.status(500).send({ message: "Database error" });
//     }

//     if (results.length > 0) {
//       return res.status(409).send({ message: "Username or email already exists" });
//     }

//     // Insert the new user along with the OTP
//     const insertUserSql = "INSERT INTO register (username, email, password, phone_number) VALUES (?, ?, ?, ?)";
//     db.query(insertUserSql, [username, email, password, phonenumber], (err, result) => {
//       if (err) {
//         return res.status(500).send({ message: "Failed to register user" });
//       }
//       res.status(200).send({
//         message: "User registered successfully",
//         userId: result.insertId,
//       });
//     });
//   });
// });



// Register a new user with OTP
app.post("/registerotp", (req, res) => {
  const { username, email, password, phonenumber, otp } = req.body;



  // Check if username or email already exists
  const checkUserSql = "SELECT * FROM registeredotp WHERE username = ? OR email = ?";
  db.query(checkUserSql, [username, email], (err, results) => {
    if (err) {
      return res.status(500).send({ message: "Database error" });
    }



    // Insert the new user along with the OTP
    const insertUserSql = "INSERT INTO registeredotp (username, email, password, phonenumber, otp) VALUES (?, ?, ?, ?, ?)";
    db.query(insertUserSql, [username, email, password, phonenumber, otp], (err, result) => {
      if (err) {
        return res.status(500).send({ message: "Failed to register user" });
      }
      res.status(200).send({
        message: "User registered successfully",
        userId: result.insertId,
      });
    });
  });
});


// Register User API
// app.post('/register', (req, res) => {
//   const { username, email, password, phone_number } = req.body;

//   // Check if username or email already exists
//   const checkUserSql = "SELECT * FROM register WHERE username = ? OR email = ?";
//   db.query(checkUserSql, [username, email], (err, results) => {
//     if (err) {
//       return res.status(500).send({ message: "Database error" });
//     }

//     if (results.length > 0) {
//       // If user already exists, send a conflict response
//       return res.status(409).send({ message: "Username or email already exists" });
//     }

//     // Insert the new user if they don't already exist
//     const insertUserSql = "INSERT INTO register (username, email, password, phone_number) VALUES (?, ?, ?, ?)";
//     db.query(insertUserSql, [username, email, password, phone_number], (err, result) => {
//       if (err) {
//         return res.status(500).send({ message: "Failed to register user" });
//       }

//       // Registration successful
//       res.status(200).send({
//         message: "User registered successfully",
//         userId: result.insertId,
//       });
//     });
//   });
// });

// new register change  db----------------------------------------------------------------
app.post('/register', (req, res) => {
  const { username, email, password, phone_number,created_at} = req.body;

  // Check if username or email already exists
  const checkUserSql = "SELECT * FROM drivercreation WHERE username = ? OR Email = ?";
  db.query(checkUserSql, [username, email], (err, results) => {
    if (err) {
      return res.status(500).send({ message: "Database error" });
    }

    if (results.length > 0) {
      // If user already exists, send a conflict response
      return res.status(409).send({ message: "Username or email already exists" });
    }

    // Insert the new user if they don't already exist
    const insertUserSql = "INSERT INTO drivercreation (drivername,username,Email,userpassword,Mobileno,created_at) VALUES (?,?,?,?,?,?)";
    db.query(insertUserSql, [username,username,email, password, phone_number,created_at], (err, result) => {
      if (err) {
        return res.status(500).send({ message: "Failed to register user" });
      }

      // Registration successful
      // res.status(200).send({
      //   message: "User registered successfully",
      //   userId: result.insertId,
      // });
      res.status(200).send({
        message: "User registered successfully",
        // userId: result.insertId,
      });
    });
  });
});

// Check existing user
// app.post("/checkexistuser", (req, res) => {
//   const { username, email} = req.body;

//     console.log("Received data:");
//     console.log("Username:", username);
//     console.log("Email:", email);

//   // Check if username or email already exists
//   const checkUserSql = "SELECT * FROM register WHERE username = ? OR email = ?";
//   db.query(checkUserSql, [username, email], (err, results) => {
//     if (err) {
//       return res.status(500).send({ message: "Database error" });
//     }

//     if (results.length > 0) {
//       return res.status(409).send({ message: "Username or email already exists" });
//     }
//     else{
//         res.status(200).send({
//             message: "User registered successfully",
// //            userId: result.insertId,
//           });
//     }
//     });
// });

// new register change  db----------------------------------------------------------------
app.post("/checkexistuser", (req, res) => {
  const { username, email} = req.body;

    console.log("Received data:");
    console.log("Username:", username);
    console.log("Email:", email);

  // Check if username or email already exists
  // const checkUserSql = "SELECT * FROM register WHERE username = ? OR email = ?";
  const checkUserSql = "SELECT * FROM drivercreation WHERE username = ? OR Email = ?";
  db.query(checkUserSql, [username, email], (err, results) => {
    if (err) {
      return res.status(500).send({ message: "Database error" });
    }

    if (results.length > 0) {
      return res.status(409).send({ message: "Username or email already exists" });
    }
    else{
        res.status(200).send({
            message: "User registered successfully",
//            userId: result.insertId,
          });
    }
    });
});

// Login a user
// app.post("/login", (req, res) => {
//   const { username, password } = req.body;
//   const sql = "SELECT * FROM register WHERE username = ?";

//   db.query(sql, [username], (err, results) => {
//     if (err) {
//       return res.status(500).send(err);
//     }
//     if (results.length === 0) {
//       return res.status(404).send({ message: "Username not found" });
//     }

//     // Check password
//     const user = results[0];
//     if (user.password !== password) {
//       return res.status(401).send({ message: "Incorrect password" });
//     }

//     const userid = user.id;


//     res.status(200).send({
//         message: "Login successful",
//         userId: userid
//     });
//   });
// });

// Get user details
// app.post("/getUserDetails", (req, res) => {
//   const { id } = req.body; // Expecting the email to be sent in the body
//   // Check if the email exists in the database
//   const checkOtpSql = "SELECT * FROM register WHERE id = ?";
//   db.query(checkOtpSql, [id], (err, results) => {
//     if (err) {
//       console.error("Database error:", err);
//       return res.status(500).send({ message: "Database error" });
//     }

//     // If no results, the email doesn't exist
//     if (results.length === 0) {
//       return res.status(404).send({ message: "Email not found" });
//     }

//     // If email exists, return the OTP
//     const username = results[0].username;
//     const password = results[0].password;
//     const phonenumber = results[0].phone_number;
//     const email = results[0].email;


//     // Send OTP in response
//     res.status(200).send({
//       message: "Details retrieved successfully",
//       username: username,
//       password: password,
//       phonenumber: phonenumber,
//       email: email,
//     });
//   });
// });

// new register change  db----------------------------------------------------------------
app.post("/getUserDetails", (req, res) => {
  const { username} = req.body; // Expecting the email to be sent in the body
  // Check if the email exists in the database
  // const checkOtpSql = "SELECT * FROM register WHERE id = ?";
  const checkOtpSql = "SELECT * FROM drivercreation WHERE username = ?";
  db.query(checkOtpSql, [username], (err, results) => {
    if (err) {
      console.error("Database error:", err);
      return res.status(500).send({ message: "Database error" });
    }

    // If no results, the email doesn't exist
    if (results.length === 0) {
      return res.status(404).send({ message: "Email not found" });
    }

    // If email exists, return the OTP
    // const username = results[0].username;
    // const password = results[0].password;
    // const phonenumber = results[0].phone_number;
    // const email = results[0].email;

    const username = results[0].username;
    const password = results[0].userpassword;
    const phonenumber = results[0].Mobileno;
    const email = results[0].Email;

    // Send OTP in response
    res.status(200).send({
      message: "Details retrieved successfully",
      username: username,
      password: password,
      phonenumber: phonenumber,
      email: email,
    });
  });
});


// Update user details
// app.post("/updateUser", (req, res) => {
//   const { userId, username, password, phonenumber, email } = req.body;

//   // Log received data for debugging
//   console.log("Received data:", { userId, username, password, phonenumber, email });

//   // Validate required fields
//   if (!userId || !username || !email) {
//     return res.status(400).send({ message: "User ID, username, and email are required" });
//   }

//   // Check if the user exists
//   const checkUserSql = "SELECT * FROM register WHERE id = ?";
//   db.query(checkUserSql, [userId], (err, results) => {
//     if (err) {
//       console.error("Error checking user:", err); // Detailed error log
//       return res.status(500).send({ message: "Database error while checking user" });
//     }

//     if (results.length === 0) {
//       console.log("User not found with ID:", userId);
//       return res.status(404).send({ message: "User not found" });
//     }

//     // Update the user's information
//     const updateUserSql = `
//       UPDATE register
//       SET username = ?, password = ?, phone_number = ?, email = ?
//       WHERE id = ?`;

//     db.query(updateUserSql, [username, password, phonenumber, email, userId], (err, result) => {
//       if (err) {
//         console.error("Error updating user details:", err); // Detailed error log
//         return res.status(500).send({ message: "Failed to update user details" });
//       }

//       if (result.affectedRows > 0) {
//         console.log("User details updated successfully for ID:", userId);
//         res.status(200).send({ message: "User details updated successfully" });
//       } else {
//         console.log("No changes made to user details for ID:", userId);
//         res.status(400).send({ message: "No changes made to user details" });
//       }
//     });
//   });
// });
// new register change  db----------------------------------------------------------------
app.post("/updateUser", (req, res) => {
  const { userId, username, password, phonenumber, email } = req.body;

  // Log received data for debugging
  console.log("Received data:", { userId, username, password, phonenumber, email });

  // // Validate required fields
  // if (!userId || !username || !email) {
  //   return res.status(400).send({ message: "User ID, username, and email are required" });
  // }

  // Check if the user exists
  // const checkUserSql = "SELECT * FROM register WHERE id = ?";
  // db.query(checkUserSql, [userId], (err, results) => {
  //   if (err) {
  //     console.error("Error checking user:", err); // Detailed error log
  //     return res.status(500).send({ message: "Database error while checking user" });
  //   }

  //   if (results.length === 0) {
  //     console.log("User not found with ID:", userId);
  //     return res.status(404).send({ message: "User not found" });
  //   }

    // Update the user's information
    const updateUserSql = `
      UPDATE drivercreation
      SET username = ?,drivername = ?, userpassword = ?, Mobileno = ?, Email = ?
      WHERE driverid = ?`;

    db.query(updateUserSql, [username,username, password, phonenumber, email, userId], (err, result) => {
      if (err) {
        console.error("Error updating user details:", err); // Detailed error log
        return res.status(500).send({ message: "Failed to update user details" });
      }

      if (result.affectedRows > 0) {
        console.log("User details updated successfully for ID:", userId);
        res.status(200).send({ message: "User details updated successfully" });
      } else {
        console.log("No changes made to user details for ID:", userId);
        res.status(400).send({ message: "No changes made to user details" });
      }
    });
  // });
});

// check current password
// app.post("/checkCurrentPassword", (req, res) => {
//   const { userId, password } = req.body;

//   console.log("Received data:", { userId, password });
//   const sql = "SELECT * FROM register WHERE id = ?";

//   db.query(sql, [userId], (err, results) => {
//     if (err) {
//       return res.status(500).send(err);
//     }
//     if (results.length === 0) {
//       return res.status(404).send({ message: "User not found" });
//     }

//     // Check password
//     const user = results[0];
//     if (user.password !== password) {
//         console.log('ssssssssssssssssss');
//         return res.status(401).send({ message: "Incorrect password" });
//     }

//     const userid = user.id;


//     res.status(200).send({
//         message: "Login successful",
//         userId: userid
//     });
//   });
// });

// change password
app.post("/changePassword", (req, res) => {
  const { userId, newPassword } = req.body;

  console.log("Received new data:", { userId, newPassword });
  // const sql = "SELECT * FROM register WHERE id = ?";

  // db.query(sql, [userId], (err, results) => {
  //   if (err) {
  //     return res.status(500).send(err);
  //   }
  //   if (results.length === 0) {
  //     return res.status(404).send({ message: "User not found" });
  //   }

    const updateUserSql = `
          UPDATE drivercreation
          SET userpassword = ?
          WHERE  driverid  = ?`;

        db.query(updateUserSql, [newPassword, userId], (err, result) => {
          if (err) {
            console.error("Error updating user details:", err); // Detailed error log
            return res.status(500).send({ message: "Failed to update user details" });
          }

          if (result.affectedRows > 0) {
            console.log("User details updated successfully for ID:", userId);
            res.status(200).send({ message: "User details updated successfully" });
          } else {
            console.log("No changes made to user details for ID:", userId);
            res.status(400).send({ message: "No changes made to user details" });
          }
        });


  });


  
// });

// Forgot Password Email Verification
// app.post("/forgotPasswordEmailVerification", (req, res) => {
//   const { email } = req.body;

//    console.log("Received new data:", { email });

//   const sql = "SELECT * FROM register WHERE email = ?";

//   db.query(sql, [email], (err, results) => {
//     if (err) {
//       return res.status(500).send(err);
//     }
//     if (results.length === 0) {
//       return res.status(404).send({ message: "User not found" });
//     }

//     // Check password
//     const user = results[0];

//     const userid = user.id;

//     res.status(200).send({
//         message: "Email Verified",
//         userId: userid
//     });
//   });
// });


// new forgotmail db--------------------------
app.post("/forgotPasswordEmailVerification", (req, res) => {
  const { email } = req.body;

   console.log("Received new data:", { email });

  const sql = "SELECT * FROM drivercreation WHERE Email = ?";

  db.query(sql, [email], (err, results) => {
    if (err) {
      return res.status(500).send(err);
    }
    if (results.length === 0) {
      return res.status(404).send({ message: "User not found" });
    }

    // Check password
    const user = results[0];

    // const userid = user.id;
    const userid = user.driverid;

    res.status(200).send({
        message: "Email Verified",
        userId: userid
    });
  });
});

// add forgot password OTP
// app.post("/addForgotPasswordOtp", (req, res) => {
//   const { email, otp } = req.body;

//   // Check if username or email already exists
// //  const checkUserSql = "SELECT * FROM registeredotp WHERE username = ? OR email = ?";
// //  db.query(checkUserSql, [username, email], (err, results) => {
// //    if (err) {
// //      return res.status(500).send({ message: "Database error" });
// //    }



//     // Insert the new OTP
//     const insertForgotPasswordOtpSql = "INSERT INTO registeredotp ( email, otp) VALUES (?, ?)";
//     db.query(insertForgotPasswordOtpSql, [ email, otp], (err, result) => {
//       if (err) {
//         return res.status(500).send({ message: "Failed to register user" });
//       }
//       res.status(200).send({
//         message: "Otp inserted successfully",
//         userId: result.insertId,
//       });
//     });
// //  });
// });


// Check Forgot Password Otp
// app.post("/checkForgotPasswordOtp", (req, res) => {
//   const { email } = req.body;

//   const sql = "SELECT * FROM registeredotp WHERE email = ? ORDER BY id DESC LIMIT 1";

//   db.query(sql, [email], (err, results) => {
//     if (err) {
//       return res.status(500).send(err);
//     }
//     if (results.length === 0) {
//       return res.status(404).send({ message: "User not found" });
//     }

//     // Check password
//     const user = results[0];

//     const userid = user.id;
//     const otp = user.otp

//     res.status(200).send({
//         message: "Email Verified",
//         userId: userid,
//         otp: otp
//     });
//   });
// });


// change password forgot
// app.post("/changePasswordForgot", (req, res) => {
//   const { userId, newPassword } = req.body;

//   console.log("Received new data:", { userId, newPassword });
//   const sql = "SELECT * FROM register WHERE id = ?";

//   db.query(sql, [userId], (err, results) => {
//     if (err) {
//       return res.status(500).send(err);
//     }
//     if (results.length === 0) {
//       return res.status(404).send({ message: "User not found" });
//     }

//     const updateUserSql = `
//           UPDATE register
//           SET password = ?
//           WHERE id = ?`;

//         db.query(updateUserSql, [ newPassword, userId], (err, result) => {
//           if (err) {
//             console.error("Error updating user details:", err); // Detailed error log
//             return res.status(500).send({ message: "Failed to update user details" });
//           }

//           if (result.affectedRows > 0) {
//             console.log("User details updated successfully for ID:", userId);
//             res.status(200).send({ message: "User details updated successfully" });
//           } else {
//             console.log("No changes made to user details for ID:", userId);
//             res.status(400).send({ message: "No changes made to user details" });
//           }
//         });

//   });
// });





// Verify OTP API
// app.post("/customerotp", (req, res) => {
//   const { otp } = req.body;

//   // Check if OTP is provided
//   if (!otp) {
//     return res.status(400).json({ success: false, message: "OTP is required" });
//   }

//   // Query the database for the OTP
//   const query = "SELECT username FROM customer_otp WHERE otp = ?";
//   db.query(query, [otp], (err, result) => {
//     if (err) {
//       console.error("Error querying the database:", err);
//       return res.status(500).json({ success: false, message: "Database query error" });
//     }

//     if (result.length === 0) {
//       // OTP not found
//       return res.status(404).json({ success: false, message: "Invalid OTP" });
//     }

//     // OTP is valid
//     return res.status(200).json({
//       success: true,
//       message: "OTP verified successfully",
//       username: result[0].username, // Include username if needed
//     });
//   });
// });




// Signature Photo API
//app.get('/signature_photos', (req, res) => {
//  const { tripid } = req.query;
//  const selectQuery = 'SELECT signature_path FROM signatures WHERE tripid = ?';
//
//  db.query(selectQuery, [tripid], (err, results) => {
//    if (err) return res.status(500).json({ message: 'Internal server error' });
//    if (results.length === 0) return res.status(404).json({ message: 'Signature not found' });
//
//    const uploadedImagePath = results[0].signature_path;
//    const cleanedPath = path.relative(path.join(__dirname, 'path_to_save_images'), uploadedImagePath)
//                            .split(path.sep).filter(segment => segment !== '..').join(path.sep);
//
//    res.status(200).json({ uploadedImagePath: cleanedPath });
//
//  });
//
//});


app.get('/signature_photos', (req, res) => {
  const { tripid } = req.query;
  const selectQuery = 'SELECT signature_path FROM signatures WHERE tripid = ?';

  db.query(selectQuery, [tripid], (err, results) => {
    if (err) return res.status(500).json({ message: 'Internal server error' });
    if (results.length === 0) return res.status(404).json({ message: 'Signature not found' });

    const uploadedImagePath = results[0].signature_path;
    console.log(`Raw path from DB: ${uploadedImagePath}`);

    // Extract the image filename from the full path
    const imageName = path.basename(uploadedImagePath);
    console.log(`Extracted image name: ${imageName}`);

    // Return the correct URL
    const fullImageUrl = `signatures/${imageName}`;
    console.log(`Final Image URL: ${fullImageUrl}`);

    res.status(200).json({ uploadedImagePath: fullImageUrl });
  });
});


// Uploads API
app.get('/uploads', (req, res) => {
  const { tripid } = req.query;
  const selectQuery = 'SELECT path FROM tripsheetupload WHERE tripid = ?';

  db.query(selectQuery, [tripid], (err, results) => {
    if (err) return res.status(500).json({ message: 'Internal server error' });
    if (results.length === 0) return res.status(404).json({ message: 'No uploads found' });

    const attachedImagePaths = results.map(result => result.path);
    res.status(200).json({ attachedImagePaths });
  });
});


app.get('/uploads', (req, res) => {
  const { tripid } = req.query;
  const selectQuery = 'SELECT path FROM tripsheetupload WHERE tripid = ?  And documenttype  not in ("startkm","closekm")';

  db.query(selectQuery, [tripid], (err, results) => {
    if (err) return res.status(500).json({ message: 'Internal server error' });
    if (results.length === 0) return res.status(404).json({ message: 'No uploads found' });

    const attachedImagePaths = results.map(result => result.path);
    res.status(200).json({ attachedImagePaths });
  });
});



app.get('/uploadsfordocumenttype', (req, res) => {
  const { tripid,documenttype} = req.query;
  const selectQuery = 'SELECT path FROM tripsheetupload WHERE tripid = ? and documenttype = ?';

  db.query(selectQuery, [tripid,documenttype], (err, results) => {
    if (err) return res.status(500).json({ message: 'Internal server error' });
    if (results.length === 0) return res.status(404).json({ message: 'No uploads found' });

    const attachedImagePaths = results.map(result => result.path);
    res.status(200).json({ attachedImagePaths });
  });
});



app.get('/getAllUploadsByTripId', (req, res) => {
  const { tripid } = req.query;

  if (!tripid) {
    return res.status(400).json({ message: 'Trip ID is required' });
  }

  const selectQuery = 'SELECT * FROM tripsheetupload WHERE tripid = ?';

  db.query(selectQuery, [tripid], (err, results) => {
    if (err) {
      return res.status(500).json({ message: 'Internal server error', error: err });
    }
    if (results.length === 0) {
      return res.status(404).json({ message: 'No uploads found' });
    }

    res.status(200).json({ uploads: results });
  });
});














//local
//app.listen(3004, () => {
//  console.log("Server started on ports 30059");
//});



//jessycabs

app.listen(7128, () => {
  console.log("Server started on port 710000");
});

