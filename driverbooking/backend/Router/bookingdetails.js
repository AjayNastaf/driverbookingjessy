const express = require('express');
const router = express.Router();
const db = require('../db');

//get duty type based on login driver name when the apps waiting
//router.get('/tripsheet/:username', async (req, res) => {
//  const username = req.params.username;
//  console.log(username, "ajay90")
//  try {
////    const query = 'SELECT * FROM tripsheet WHERE driverName = ? AND apps = "waiting" ';
//    const query = 'SELECT * FROM tripsheet WHERE driverName = ? AND apps IN ("Waiting", "On_Going", "Accept")';
//
//    db.query(query, [username], (err, results) => {
//      if (err) {
//        res.status(500).json({ message: 'Internal server error' });
//        return;
//      }
//console.log(results,"aaaaaaa")
//      res.status(200).json(results);
//    });
//  } catch (err) {
//    res.status(500).json({ message: 'Internal server error' });
//  }
//});

router.get('/tripsheet/:username/:startdate', async (req, res) => {
  const username = req.params.username;
  const startdate = req.params.startdate;

  console.log(username, "ajay90")
  try {

//const query = `SELECT * FROM tripsheet WHERE driverName = ? AND apps IN ("Waiting", "On_Going", "Accept") AND startdate = ? ORDER BY STR_TO_DATE(reporttime, '%H:%i') ASC`;
const query = `SELECT * FROM tripsheet WHERE driverName = ? AND apps IN ("Waiting", "On_Going", "Accept") AND status NOT IN ('Cancelled') AND startdate = ? ORDER BY STR_TO_DATE(starttime, '%H:%i:%S') ASC`;

    db.query(query, [username,startdate], (err, results) => {
      if (err) {
        res.status(500).json({ message: 'Internal server error' });
        return;
      }
// console.log(results,"aaaaaaa")
      res.status(200).json(results);
    });
  } catch (err) {
    res.status(500).json({ message: 'Internal server error' });
  }
});
//end

//get duty type based on login driver name when the apps closed
router.get('/tripsheetRides/:username', async (req, res) => {
  const username = req.params.username;
  try {
    const query = "SELECT * FROM tripsheet WHERE driverName = ? AND apps = 'Closed' ORDER BY closetime DESC";
    db.query(query, [username], (err, results) => {
      if (err) {
        res.status(500).json({ message: 'Internal server error' });
        return;
      }

      res.status(200).json(results);
    });
  } catch (err) {
    res.status(500).json({ message: 'Internal server error' });
  }
});
//end


router.get('/closedtripsheetbasedDate/:username/:todaydate', async (req, res) => {
    const username = req.params.username;
    const todaydate = req.params.todaydate;

    console.log(username,"userrrrr name")

    try {
      // const query = "SELECT * FROM tripsheet WHERE driverName = ? AND apps <> 'waiting' ";
//      const query = "SELECT * FROM tripsheet WHERE driverName = ? AND apps  ('closed') and closedate = ?";
const query = "SELECT * FROM tripsheet WHERE driverName = ? AND apps = 'Closed' AND closedate = ?";

      db.query(query, [username,todaydate], (err, results) => {
        if (err) {
          res.status(500).json({ message: 'Internal server error' });
          return;
        }
        // console.log(results,"rrrrr")

        res.status(200).json(results);
      });
    } catch (err) {
      res.status(500).json({ message: 'Internal server error' });
    }
  });




router.get('/tripsheets/:duty/:tripId', async (req, res) => {
  const { tripId, duty } = req.params;
  console.log('Received request with tripId:', tripId, 'and duty:', duty);  // Should log the request parameters

  try {
    const query = 'SELECT * FROM tripsheet WHERE tripid = ? AND duty = ?';
    console.log('Executing query:', query, 'with values:', [tripId, duty]);

    db.query(query, [tripId, duty], (err, results) => {
      if (err) {
        console.log('Database query error:', err);
        res.status(500).json({ message: 'Internal server error' });
        return;
      }

      // console.log('Query results:', results); // Should log the query results
      if (results.length === 0) {
        console.log('No trip sheet found for tripId:', tripId, 'and duty:', duty);
        res.status(404).json({ message: 'Trip sheet not found' });
        return;
      }

      // console.log('Found trip sheet data:', results[0]);  // Should log the found trip sheet data
      res.status(200).json(results[0]);  // Send the first result
    });
  } catch (err) {
    console.log('Unexpected error:', err);  // Log unexpected errors
    res.status(500).json({ message: 'Internal server error' });
  }
});



router.get('/tripsheets_fulldetails/:tripId', async (req, res) => {
  const { tripId } = req.params;
  console.log('Received request with tripId:', tripId);  // Should log the request parameters

  try {
    const query = 'SELECT * FROM tripsheet WHERE tripid = ?';
    console.log('Executing query:', query, 'with values:', [tripId]);

    db.query(query, [tripId], (err, results) => {
      if (err) {
        console.log('Database query error:', err);
        res.status(500).json({ message: 'Internal server error' });
        return;
      }

      // console.log('Query results:', results); // Should log the query results
      if (results.length === 0) {
        console.log('No trip sheet found for tripId:', tripId,);
        res.status(404).json({ message: 'Trip sheet not found' });
        return;
      }

      // console.log('Found trip sheet dataaaa:', results[0]);  // Should log the found trip sheet data
      res.status(200).json(results[0]);  // Send the first result
    });
  } catch (err) {
    console.log('Unexpected error:', err);  // Log unexpected errors
    res.status(500).json({ message: 'Internal server error' });
  }
});

//end




// router.get('/tripduration/:tripId', (req, res) => {
//   const { tripId } = req.params;
//console.log('ccc',tripId)
//   const SelectQuery = `
//     SELECT
//       v.created_at,
//       s.logdatetime
//     FROM
//       VehicleAccessLocation AS v
//     LEFT JOIN
//       Signaturetimedetails AS s
//       ON v.Trip_id = s.tripid
//     WHERE
//       v.Trip_Status = 'Started'
//       AND s.Signstatus = 'Updated'
//       AND v.Trip_id = ?
//   `;
//
//   db.query(SelectQuery, [tripId], (err, results) => {
//     if (err) {
//       console.error(err);
//       return res.status(500).send("Database error");
//     }
//
//     if (results.length === 0) {
//       return res.status(404).json({ message: "No data found for this trip." });
//     }
//
//     const { created_at, logdatetime } = results[0];
//
//     // Convert to Date objects
//     const start = new Date(created_at);
//     const end = new Date(logdatetime);
//
//     console.log('start time', start);
//     console.log('end time', end);
//
//
//
//     if (isNaN(start) || isNaN(end)) {
//       return res.status(400).json({ message: "Invalid date format." });
//     }
//
//     const diffMs = end - start;
//
//     if (diffMs < 0) {
//       return res.status(400).json({ message: "End time is before start time." });
//     }
//
//     console.log('diffff', diffMs);
//
//     const totalMinutes = Math.floor(diffMs / (1000 * 60));
//     const hours = Math.floor(totalMinutes / 60);
//     const minutes = totalMinutes % 60;
//
//     const formattedDuration = `${hours.toString().padStart(2, '0')} H :${minutes.toString().padStart(2, '0')} M`;
//
//     res.status(200).json({ tripDuration: formattedDuration });
//   });
// });



 router.get('/tripduration/:tripId', (req, res) => {
   const { tripId } = req.params;
console.log('ccc',tripId)


  const SelectQuery = `
      SELECT t.starttime,t.startdate,s.logdatetime
          FROM tripsheet as t
          LEFT JOIN Signaturetimedetails as s
          on t.tripid=s.tripid
          WHERE s.Signstatus="Updated" AND t.tripid = ?;
      `;

   db.query(SelectQuery, [tripId], (err, results) => {
     if (err) {
       console.error(err);
       return res.status(500).send("Database error");
     }

      if (results.length === 0) {
            return res.status(404).json({ message: "No data found for this trip." });
          }

          // 🧠 Duration logic here

    //      const { created_at, logdatetime } = results[0];

    const { starttime, startdate, logdatetime } = results[0];

    //       console.log("this is created_at", created_at);
           console.log("this is start time", starttime,);
           console.log("this is start date", startdate,);
              console.log("trip is logdatetime", logdatetime);

         const start = new Date(`${startdate}T${starttime}`);
         const end = new Date(logdatetime);



    //      const diffMs = end - start;
    //      const totalMinutes = Math.floor(diffMs / (1000 * 60));
    //      const hours = Math.floor(totalMinutes / 60);
    //      const minutes = totalMinutes % 60;

            const diffMs = end - start;
            const totalMinutes = Math.floor(diffMs / (1000 * 60));
            const hours = Math.floor(totalMinutes / 60);
            const minutes = totalMinutes % 60;


    //      const formattedDuration = `${hours.toString().padStart(2, '0')} H : ${minutes.toString().padStart(2, '0')} M`;
          const formattedDuration = `${hours.toString().padStart(2, '0')} H : ${minutes.toString().padStart(2, '0')} M`;

            console.log(formattedDuration,'ffffffffffddd');
            // Create a Nodemailer transporter
     res.status(200).json({ tripDuration: formattedDuration });
   });
 });


























// updating trip app status
router.post('/update_trip_apps', (req, res) => {
  const { tripid, apps } = req.body;

  console.log(tripid,apps,"updateapps")

  // Update the database with the new status
  const query = 'UPDATE tripsheet SET apps = ? WHERE tripid = ?';

  db.query(query, [apps, tripid], (err, results) => {
    if (err) {
      res.status(500).json({ message: 'Internal server error' });
      return;
    }
    console.log(results)

    res.status(200).json({ message: 'Status updated successfully' });
  });
});
//end


module.exports = router;