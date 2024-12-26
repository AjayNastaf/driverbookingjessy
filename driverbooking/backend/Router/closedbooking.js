const express = require('express');
const router = express.Router();
const db = require('../db');

//get duty type based on login driver name when the apps waiting
router.get('/closedtripsheet/:username', async (req, res) => {
  const username = req.params.username;
  console.log(username,"userr")

  try {
    // const query = "SELECT * FROM tripsheet WHERE driverName = ? AND apps <> 'waiting' ";
    const query = "SELECT * FROM tripsheet WHERE driverName = ? AND apps NOT IN ('waiting', 'closed')";

    db.query(query, [username], (err, results) => {
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
//end
// updating trip app status
router.post('/update_starttrip_apps', (req, res) => {
  const { tripid, apps } = req.body;

  // Update the database with the new status
  const query = 'UPDATE tripsheet SET apps = ? WHERE tripid = ?';

  db.query(query, [apps, tripid], (err, results) => {
    if (err) {
      res.status(500).json({ message: 'Internal server error' });
      return;
    }

    res.status(200).json({ message: 'Status updated successfully' });
  });
});
//end

// updating trip toll and parking
router.post('/update_updatekm', (req, res) => {
  const { starttime, startdate, startkm, tripid } = req.body;
  const query = 'UPDATE tripsheet SET starttime = ?, startdate = ?, startkm = ? WHERE tripid = ?';

  db.query(query, [starttime, startdate, startkm, tripid], (err, results) => {
    if (err) {
      res.status(500).json({ message: 'Internal server error' });
      return;
    }
    res.status(200).json({ message: 'Status updated successfully' });
  });
});
//end

module.exports = router;