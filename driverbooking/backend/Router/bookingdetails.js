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
//    const query = 'SELECT * FROM tripsheet WHERE driverName = ? AND apps = "waiting" ';
//    const query = 'SELECT * FROM tripsheet WHERE driverName = ? AND apps IN ("Waiting", "On_Going", "Accept") and startdate = ? order by tripid desc' ;
//    const query = 'SELECT * FROM tripsheet WHERE driverName = ? AND apps IN ("Waiting", "On_Going", "Accept") and startdate = ? order by tripid Asc' ;
const query = `SELECT * FROM tripsheet WHERE driverName = ? AND apps IN ("Waiting", "On_Going", "Accept") AND startdate = ? ORDER BY STR_TO_DATE(reporttime, '%H:%i') ASC`;
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
    const query = 'SELECT * FROM tripsheet WHERE driverName = ? AND apps = "Closed"';
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
const query = "SELECT * FROM tripsheet WHERE driverName = ? AND apps = 'closed' AND closedate = ?";

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