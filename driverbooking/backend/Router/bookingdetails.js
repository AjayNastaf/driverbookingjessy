const express = require('express');
const router = express.Router();
const db = require('../db');

//get duty type based on login driver name when the apps waiting
router.get('/tripsheet/:username', async (req, res) => {
  const username = req.params.username;

  try {
    const query = 'SELECT * FROM tripsheet WHERE driverName = ? AND apps = "waiting"';
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
//get duty type details based on login duty type and tripid
router.get('/tripsheet/:tripid/:duty', async (req, res) => {
  const { tripid, duty } = req.params;
  console.log(tripid,duty,"ffff")

  try {
    const query = 'SELECT * FROM tripsheet WHERE tripid = ? AND duty = ?';
    db.query(query, [tripid, duty], (err, results) => {
      if (err) {
        res.status(500).json({ message: 'Internal server error' });
        return;
      }

      // Check if trip sheet data was found
      if (results.length === 0) {
        res.status(404).json({ message: 'Trip sheet not found' });
        return;
      }

      res.status(200).json(results[0]); // Assuming you want to send the first result
    });
  } catch (err) {
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