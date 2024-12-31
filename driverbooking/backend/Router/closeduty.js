const express = require('express');
const router = express.Router();
const db = require('../db');

// updating trip app status
router.post('/update_closetrip_apps', (req, res) => {
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
// router.post('/update_updateclosekm', (req, res) => {
//   const { closekm, closedate, closetime, tripid } = req.body;
//   const query = 'UPDATE tripsheet SET closekm = ?, closedate = ?, closetime = ? WHERE tripid = ?';

//   db.query(query, [closekm, closedate, closetime, tripid], (err, results) => {
//     if (err) {
//       res.status(500).json({ message: 'Internal server error' });
//       return;
//     }
//     res.status(200).json({ message: 'Status updated successfully' });
//   });
// });
//end

module.exports = router;