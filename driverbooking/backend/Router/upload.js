const express = require('express');
const router = express.Router();
const db = require('../db');
// const multer = require('multer');
// const path = require('path');
const axios = require('axios');
// const Imagepathuploads = require('../imageurl')

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
//const uploadDir = path.join(__dirname, '../../../../NASTAF-upload/NASTAF-IMAGES/imagesUploads_doc');
// const uploadDir = path.join(__dirname,`${Imagepathuploads}/imagesUploads_doc`);

// const storage = multer.diskStorage({
//     destination: (req, file, cb) => {
//         // console.log(req,"jj")
//       cb(null, uploadDir,)
//     },
//     filename: (req, file, cb) => {
//          console.log(req,"lllll")
//       cb(null, file.fieldname + "_" + req.params.data + path.extname(file.originalname))
//     }
  
//   })
// const upload = multer({ storage: storage });



//file upload in tripsheet

// jesscabs app stored image from jesscabs------------------------------------------------
// router.post('/uploadfolrderapp/:data', upload.single('image'), (req, res) => {
//     console.log(req.params.data,"kk")
//     const fileData = {
//         name: req.file.originalname,
//         mimetype: req.file.mimetype,
//         size: req.file.size,
//         path: req.file.path.replace(/\\/g, '/').replace(/^path_to_save_uploads\//, ''),
//         }
//     console.log(fileData,"data")
//    res.send("success upload")
   
   
// });
// -----------------------------------------------------------------------------------------------------------
//existing and working for single
//router.post('/uploadsdriverapp/:data', upload.single('file'), (req, res) => {
//    const selecteTripid = req.body.tripid;
//    console.log(req.params.data,"daaaa");
//    const documenttypedata=req.body.documenttype
//    // const data=req.body.datadate;
//    console.log(req.file,"fff")
//
//    const fileData = {
//        name: req.file.originalname,
//        mimetype: req.file.mimetype,
//        size: req.file.size,
//        path: req.file.path.replace(/\\/g, '/').replace(/^uploads\//, ''),
//        tripid: selecteTripid,
//        documenttype:documenttypedata,
//    };
//
//    console.log(req.file,"dadadate233233")
//    console.log(documenttypedata,"dooocccc")
//    console.log(fileData,selecteTripid,"dataaaaaaaaaaaaaaaaa")
//    const updateQuery = 'INSERT INTO tripsheetupload SET ?';
//    db.query(updateQuery, [fileData], (err, results) => {
//        if (err) {
//            res.status(500).json({ message: 'Internal server error' });
//            return;
//        }
//        res.status(200).json({ message: 'Profile photo uploaded successfully' });
//    });
//});







//existing and working for multiple



// router.post('/uploadsdriverapp/:data', upload.array('file', 10), (req, res) => {
//   const selectedTripId = req.body.tripid;
//   const documentType = req.body.documenttype;

//   console.log("Request Params:", req.params.data);
//   console.log("Uploaded Files:", req.files);

//   if (!req.files || req.files.length === 0) {
//     return res.status(400).json({ message: 'No files uploaded' });
//   }

//   const fileDataArray = req.files.map(file => ({
//     name: file.originalname,
//     mimetype: file.mimetype,
//     size: file.size,
// //    path: file.path.replace(/\\/g, '/').replace(/^uploads\//, ''),
//   path: file.filename,

//     tripid: selectedTripId,
//     documenttype: documentType,
//   }));

//   console.log("Processed File Data:", fileDataArray);

//   const updateQuery = 'INSERT INTO tripsheetupload (name, mimetype, size, path, tripid, documenttype) VALUES ?';

//   // Map file data to the format required for bulk insert
//   const values = fileDataArray.map(file => [file.name, file.mimetype, file.size, file.path, file.tripid, file.documenttype]);

//   db.query(updateQuery, [values], (err, results) => {
//     if (err) {
//       console.error("Database Error:", err);
//       return res.status(500).json({ message: 'Internal server error' });
//     }
//     res.status(200).json({ message: 'Files uploaded successfully', data: results });
//   });
// });
//end tripsheet file upload























// updating trip toll and parking
router.post('/update_updatetrip', (req, res) => {
    const { toll, parking, tripid } = req.body;
    const query = 'UPDATE tripsheet SET toll = ?, parking = ?,vendorparking = ?,vendortoll = ? WHERE tripid = ?';

    db.query(query, [toll, parking,parking ,toll,tripid], (err, results) => {
        if (err) {
            res.status(500).json({ message: 'Internal server error' });
            return;
        }
        res.status(200).json({ message: 'Status updated successfully' });
    });
});
//end


//closing kilometer fetching
//router.get('/KMForParticularTrip', async (req, res) => {
//    const { Trip_id } = req.query;
//
//    if (!Trip_id) {
//        return res.status(400).json({ error: "Trip_id is required" });
//    }
//
//    const Trip_Status = ["Started", "On_Going", "Reached"];
//    const sqlQuery = `SELECT Latitude_loc, Longtitude_loc FROM VehicleAccessLocation
//                      WHERE Trip_id = ? AND Trip_Status IN (?) ORDER BY Runing_Time ASC`;
//
//    const sqlTripsheetQuery = `SELECT startkm FROM tripsheet WHERE tripid = ?`;
//
//    db.query(sqlQuery, [Trip_id, Trip_Status], async (err, results) => {
//        if (err) {
//            console.error("Error fetching trip data:", err);
//            return res.status(500).json({ error: "Internal Server Error" });
//        }
//
//        if (results.length < 2) {
//            return res.json({ message: "Not enough data points to calculate distance." });
//        }
//
//        const origins = `${results[0].Latitude_loc},${results[0].Longtitude_loc}`;
//        const destinations = `${results[results.length - 1].Latitude_loc},${results[results.length - 1].Longtitude_loc}`;
//        const waypoints = results.slice(1, -1).map(point => `${point.Latitude_loc},${point.Longtitude_loc}`).join('|');
//
//        try {
//            const response = await axios.get(`https://maps.googleapis.com/maps/api/distancematrix/json`, {
//                params: {
//                    origins,
//                    destinations,
//                    waypoints,
//                    key: GOOGLE_MAPS_API_KEY,
//                    mode: 'driving'
//                }
//            });
//
//            let distance = response.data.rows[0].elements[0].distance.value / 1000; // Convert meters to KM
//            distance = Math.round(distance); // Round up to the next whole number
//            let distanceCheck = response.data.rows[0].elements[0].distance.value / 1000; // Convert meters to KM
//
//            console.log(`Total Distance for Trip ID ${Trip_id}: ${distance} KM`,distanceCheck);
//
//            // Fetch startkm from tripsheet
//            db.query(sqlTripsheetQuery, [Trip_id], (err, tripResults) => {
//                if (err) {
//                    console.error("Error fetching trip sheet data:", err);
//                    return res.status(500).json({ error: "Internal Server Error" });
//                }
//
//                if (tripResults.length === 0) {
//                    return res.status(404).json({ error: "Trip sheet data not found" });
//                }
//
//                const startkm = tripResults[0].startkm.toString(); // Ensure startkm is a string
//                const totalKM = (parseFloat(startkm) + distance).toFixed(0); // Add and round to whole number
//console.log(Trip_id, startkm, distance, totalKM,"finallllllllllllllllllllllllllll");
//
//                res.json({ Trip_id, startkm, totalDistance: distance, finalKM: totalKM });
//            });
//
//        } catch (apiError) {
//            console.log("Error fetching data from Google API:", apiError);
//            res.status(500).json({ error: "Error fetching distance from Google API" });
//        }
//    });
//});
const GOOGLE_MAPS_API_KEY = 'AIzaSyCn47dR5-NLfhq0EqxlgaFw8IEaZO5LnRE'; // Replace with your API key
router.get('/KMForParticularTrip', async (req, res) => {
    const { Trip_id } = req.query;

    if (!Trip_id) {
        console.log("❌ Missing Trip_id in request");
        return res.status(400).json({ error: "Trip_id is required" });
    }

    console.log(`📌 Received request for Trip ID: ${Trip_id}`);

    const Trip_Status = ["Started", "On_Going", "Reached"];
    const sqlQuery = `SELECT Latitude_loc, Longtitude_loc FROM VehicleAccessLocation
                      WHERE Trip_id = ? AND Trip_Status IN (?) ORDER BY Runing_Time ASC`;

    const sqlTripsheetQuery = `SELECT startkm FROM tripsheet WHERE tripid = ?`;

    db.query(sqlQuery, [Trip_id, Trip_Status], async (err, results) => {
        if (err) {
            console.error("❌ Database Error:", err);
            return res.status(500).json({ error: "Database Error", details: err.message });
        }

        console.log(`✅ Fetched ${results.length} location records for Trip ID: ${Trip_id}`);

        if (results.length < 2) {
            return res.json({ message: "Not enough data points to calculate distance." });
        }

        const origins = `${results[0].Latitude_loc},${results[0].Longtitude_loc}`;
        const destinations = `${results[results.length - 1].Latitude_loc},${results[results.length - 1].Longtitude_loc}`;
        const waypoints = results.slice(1, -1).map(point => `${point.Latitude_loc},${point.Longtitude_loc}`).join('|');

        try {
            console.log(`🔍 Fetching distance from Google API: origins=${origins}, destinations=${destinations}`);

            const response = await axios.get(`https://maps.googleapis.com/maps/api/distancematrix/json`, {
                params: {
                    origins,
                    destinations,
                    waypoints,
                    key: GOOGLE_MAPS_API_KEY,
                    mode: 'driving'
                }
            });

            if (response.data.status !== "OK") {
                console.error("❌ Google API Error:", response.data);
                return res.status(500).json({ error: "Google API Error", details: response.data });
            }

            let distance = response.data.rows[0].elements[0].distance.value / 1000;
            distance = Math.round(distance);

            console.log(`📏 Calculated Distance: ${distance} KM`);

            db.query(sqlTripsheetQuery, [Trip_id], (err, tripResults) => {
                if (err) {
                    console.error("❌ Error fetching trip sheet data:", err);
                    return res.status(500).json({ error: "Database Error", details: err.message });
                }

                if (tripResults.length === 0) {
                    console.log("⚠️ No trip sheet data found for Trip ID:", Trip_id);
                    return res.status(404).json({ error: "Trip sheet data not found" });
                }

                const startkm = tripResults[0].startkm.toString();
                const totalKM = (parseFloat(startkm) + distance).toFixed(0);

                console.log(`✅ Final Distance for Trip ID ${Trip_id}: Start KM: ${startkm}, Total KM: ${totalKM}`);

                res.json({ Trip_id, startkm, totalDistance: distance, finalKM: totalKM });
            });

        } catch (apiError) {
            console.error("❌ Google API Request Error:", apiError.message);
            res.status(500).json({ error: "Google API Request Failed", details: apiError.message });
        }
    });
});


//closing kilometer fetching end


// calculate start time and end time
router.get('/calculate_time/:tripId', (req, res) => {
  const { tripId } = req.params;

  console.log("Id received", tripId);

  const SelectQuery = `
    SELECT created_at, Trip_Status
    FROM vehicleaccesslocation
    WHERE Trip_id = ?
    AND Trip_Status IN ('Started', 'Reached')
  `;

  db.query(SelectQuery, [tripId], (err, result) => {
    if (err) {
      console.log("Error is", err.message);
      return res.status(400).send({ message: "Data Fetching Failed", err });
    }
    if (result.length === 0) {
      console.log('Data not found');
      return res.status(404).send({ message: "No data found" });
    }

    const startedRow = result.find(row => row.Trip_Status === 'Started');
    const reachedRow = result.find(row => row.Trip_Status === 'Reached');

    if (!startedRow || !reachedRow) {
      return res.status(404).send({ message: "Started or Reached status missing" });
    }


    const startedTime = startedRow.created_at.split("T")[1];
    const reachedTime = reachedRow.created_at.split("T")[1];

    function timeToSeconds(timeStr) {
      const [hours, minutes, rest] = timeStr.split(":");
      const seconds = parseFloat(rest);
      return parseInt(hours) * 3600 + parseInt(minutes) * 60 + seconds;
    }

    let startSeconds = timeToSeconds(startedTime);
    let reachedSeconds = timeToSeconds(reachedTime);

    let durationSeconds = reachedSeconds - startSeconds;

    if (durationSeconds < 0) {
      durationSeconds += 24 * 3600;
    }

    function secondsToHMS(seconds) {
      const h = Math.floor(seconds / 3600).toString().padStart(2, '0');
      const m = Math.floor((seconds % 3600) / 60).toString().padStart(2, '0');
      const s = Math.floor(seconds % 60).toString().padStart(2, '0');
      return `${h}:${m}:${s}`;
    }

    const durationHMS = secondsToHMS(durationSeconds);

    console.log("Duration in HH:mm:ss:", durationHMS);
    console.log("Duration Datatype",typeof durationHMS);

    res.status(200).send({ success : true , durationHMS} );
  });
});


module.exports = router;