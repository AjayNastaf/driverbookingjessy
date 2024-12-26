const express = require('express');
const router = express.Router();
const db = require('../db');
const multer = require('multer');
const path = require('path');
// const bodyParser=require('body-parser');
// const app = express();
// const router = express.Router();

// Middleware to parse JSON bodies
// app.use(bodyParser.json());

// Middleware to parse URL-encoded bodies
// app.use(bodyParser.urlencoded({ extended: true }));

// const storage = multer.diskStorage({
//     destination: function (req, file, cb) {
//         cb(null, 'uploads'); // Specify the path where uploaded files will be stored
//     },
//     // filename: function (req, file, cb) {
//     //     cb(null, file.originalname); // Use the original filename as the stored filename
//     // },
//     filename: (req, file, cb) => {
//         const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
//         cb(null, `${uniqueSuffix}-${file.originalname}`);
//     },
// });

const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        // console.log(req,"jj")
      cb(null, 'uploads',)
    },
    filename: (req, file, cb) => {
         console.log(req,"lllll")
      cb(null, file.fieldname + "_" + req.params.data + path.extname(file.originalname))
    }
  
  })
const upload = multer({ storage: storage });

//file upload in tripsheet

// jesscabs app stored image from jesscabs------------------------------------------------
router.post('/uploadfolrderapp/:data', upload.single('image'), (req, res) => {
    console.log(req.params.data,"kk")
    const fileData = {
        name: req.file.originalname,
        mimetype: req.file.mimetype,
        size: req.file.size,
        path: req.file.path.replace(/\\/g, '/').replace(/^path_to_save_uploads\//, ''),
        }
    console.log(fileData,"data")
   res.send("success upload")
   
   
});
// -----------------------------------------------------------------------------------------------------------

router.post('/uploadsdriverapp/:data', upload.single('file'), (req, res) => {
    const selecteTripid = req.body.tripid;
    console.log(req.params.data,"daa")
    const documenttypedata=req.body.documenttype
    // const data=req.body.datadate;
    const fileData = {
        name: req.file.originalname,
        mimetype: req.file.mimetype,
        size: req.file.size,
        path: req.file.path.replace(/\\/g, '/').replace(/^uploads\//, ''),
        // path: req.file.path.replace(/\\/g, '/').replace(/^path_to_save_uploads\//, ''),
        // tripid: req.body.tripid,
        
        tripid: selecteTripid,
        documenttype:documenttypedata
    };
    console.log(req.file,"dadadate233233")
    console.log(documenttypedata,"dooocccc")
    console.log(fileData,selecteTripid,"data")
    const updateQuery = 'INSERT INTO tripsheetupload SET ?';
    db.query(updateQuery, [fileData], (err, results) => {
        if (err) {
            res.status(500).json({ message: 'Internal server error' });
            return;
        }
        res.status(200).json({ message: 'Profile photo uploaded successfully' });
    });
});
//end tripsheet file upload
// updating trip toll and parking
router.post('/update_updatetrip', (req, res) => {
    const { toll, parking, tripid } = req.body;
    const query = 'UPDATE tripsheet SET toll = ?, parking = ? WHERE tripid = ?';

    db.query(query, [toll, parking, tripid], (err, results) => {
        if (err) {
            res.status(500).json({ message: 'Internal server error' });
            return;
        }
        res.status(200).json({ message: 'Status updated successfully' });
    });
});
//end

module.exports = router;