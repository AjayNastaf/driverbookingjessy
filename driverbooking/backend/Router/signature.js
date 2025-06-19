const express = require('express');
const router = express.Router();
// const fs = require('fs'); // signature png
const db = require('../db');
const nodemailer = require('nodemailer');
// const path = require('path');
// const multer=require('multer');
// const imageFolderPath = require('../imageurl');
// const imageFolderPath = require('../imageurl')


// // Define a constant for the base path to save images
// //const baseImagePath = path.join(__dirname, 'path_to_save_images');
// console.log(imageFolderPath,"ppppppppppppppppppppppppppppppppppp")
// const baseImagePath = path.join(__dirname, `${imageFolderPath}/signature_images`);
// console.log(path.join(__dirname, `${imageFolderPath}/imagesUploads_doc`),"ppp222222222")
// console.log(path.join(__dirname, `${imageFolderPath}/signature_images`),"ppp2222222222222")

// console.log(baseImagePath , 'path disdfnnnnnnnnnnnnnnn');
// function generateUniqueNumbers() {
//     return Math.floor(10000 + Math.random() * 90000);
//   }
// // -------this from jessaycabs signatureimage------------------------------
// router.post('/signatureimagesavedriver/:data', (req, res) => {
//     const { dataurlsign } = req.body;
//     const imageName=req.params.data;

//     const base64Data = dataurlsign.replace(/^data:image\/png;base64,/, '');
//     const imageBuffer = Buffer.from(base64Data, 'base64');
//   console.log("sucuess signature image update")
//     const imageName1 = `signature-${imageName}.png`;
//     const imagePath = path.join(baseImagePath, imageName1); // Use the base path
//     console.log(imagePath,"jjjjjj")

//     fs.writeFile(imagePath, imageBuffer, (error) => {
//         if (error) {
//             res.status(500).json({ error: 'Failed to save signature' });
//         }
//         res.send("saved")

//     })
// })


// const signatureImagePath = path.join(__dirname, '../../../../NASTAF-upload/NASTAF-IMAGES/signature_images');
// const signatureImagePath = path.join(__dirname, `${imageFolderPath}/signature_images`);

// const storage = multer.diskStorage({
//     destination: (req, file, cb) => {
//       cb(null, signatureImagePath)
//     },
//     filename: (req, file, cb) => {
  
  
//       cb(null, `signature-${req.params.data}.png`);
//     },
  
  
  
//   })
  
  
//   const uploadfile = multer({ storage: storage });

// router.post('/signatureimageuploaddriver/:data',uploadfile.single('signature_image'), (req, res) => {
    
//     const signature_image = req.file.filename;
//     const imageName=`signature-${req.params.data}.png`;;
//     console.log(signature_image,"immagge",imageName)
//  // const imageName = `signature-${Date.now()}.png`;
//      // Use the base path

  
//         res.send("saved")

    
// })
// ---------------------------------------------------------------------------------



// router.post('/api/saveSignature', (req, res) => {
//     const { tripid, signatureData,imageName } = req.body;
   

//     const base64Data = signatureData.replace(/^data:image\/png;base64,/, '');
//     const imageBuffer = Buffer.from(base64Data, 'base64');

//     // const imageName = `signature-${Date.now()}.png`;
//     const imagePath = path.join(baseImagePath, imageName); // Use the base path

//     fs.writeFile(imagePath, imageBuffer, (error) => {
//         if (error) {
//             res.status(500).json({ error: 'Failed to save signature' });
//         } else {
//             const uniquenumber=generateUniqueNumbers()
//             const relativeImagePath = path.relative(baseImagePath, imagePath); // Calculate relative path
//             const sql = 'INSERT INTO signatures (tripid, signature_path,unique_number) VALUES (?,?,?)';
//             db.query(sql, [tripid, relativeImagePath,uniquenumber], (dbError, results) => {
//                 if (dbError) {
//                     res.status(500).json({ error: 'Failed to save signature' });
//                 } else {
//                     res.json({ message: 'Signature saved successfully' });
//                 }
//             });
//         }
//     });
// });
// console.log(baseImagePath,"papaaa")
// router.post('/api/saveSignature', (req, res) => {
//     const { tripid, signatureData,imageName,endtrip,endtime} = req.body;
   

//     const base64Data = signatureData.replace(/^data:image\/png;base64,/, '');
//     const imageBuffer = Buffer.from(base64Data, 'base64');

//     // const imageName = `signature-${Date.now()}.png`;
//     const imagePath = path.join(baseImagePath, imageName); // Use the base path

//     fs.writeFile(imagePath, imageBuffer, (error) => {
//         if (error) {
//             res.status(500).json({ error: 'Failed to save signature' });
//         } else {
//             const uniquenumber=generateUniqueNumbers()
//             const relativeImagePath = path.relative(baseImagePath, imagePath); // Calculate relative path
//             const sql = 'INSERT INTO signatures (tripid, signature_path,unique_number) VALUES (?,?,?)';
//               const sql2=" UPDATE tripsheet set closedate=? , closetime = ?,vendorshedInDate = ?, vendorshedintime = ? where  tripid = ?"
//             db.query(sql, [tripid, relativeImagePath,uniquenumber], (dbError, results) => {
//                 if (dbError) {
//                     res.status(500).json({ error: 'Failed to save signature' });
//                 } else {
//                     db.query(sql2, [endtrip,endtime,endtrip,endtime,tripid], (dbError1, results1) => {
//                         if (dbError1) {
//                             res.status(500).json({ error: 'Failed to save signature' });
//                         } else {
        
                            
//                             res.json({ message: 'Signature saved successfully' });
//                         }
//                     });
//                     // res.json({ message: 'Signature saved successfully' });
//                 }
//             });
//         }
//     });
// });


router.post("/signaturedatatimesdriverapp/:tripid", (req, res) => {
    const tripid = req.params.tripid;
    const {
      status,
      datesignature,
      signtime } = req.body;
    console.log(tripid, status, datesignature, signtime, "jjjjjjj")
  
    db.query("insert into Signaturetimedetails(tripid,logdatetime,startsigntime,Signstatus) value(?,?,?,?)", [tripid, datesignature, signtime, status], (err, results) => {
      if (err) {
        return res.status(400).json(err)
      }
      console.log(results)
      return res.status(200).json("data insert successfully")
    })
  })


//send email from booking page
router.post('/send-email', async (req, res) => {
    try {
        // Create a Nodemailer transporter
        const transporter = nodemailer.createTransport({
            host: 'smtp.gmail.com',
            port: 465,
            secure: true,
            // auth: {
            //     user: 'akash02899@gmail.com',
            //     pass: 'yocakaoeoajdaawj',
            // },
            auth: {
                user: 'foxfahad386@gmail.com', // Your email address
                pass: 'vwmh mtxr qdnk tldd' // Your email password
            },
            tls: {
                // Ignore SSL certificate errors
                rejectUnauthorized: false
            }
        });

        const customerMailOptions = {
            from: 'foxfahad386@gmail.com',
            to: 'foxfahad386@gmail.com', 
            subject: 'Greetings from Jessy Cabs',
            text: `Hello,\n\nYour choice of [Your Cab Service] is much appreciated. We're committed to delivering exceptional service, and we can't wait to welcome you back for another remarkable journey\n\nRegards,\nJessy Cabs`,
        };

        // Send greeting email to the customer
        await transporter.sendMail(customerMailOptions);

        res.status(200).json({ message: 'Email sent successfully' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'An error occurred while sending the email' });
    }
});
//end booking mail

module.exports = router;
