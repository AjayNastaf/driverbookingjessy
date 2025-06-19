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
//router.post('/update_updatekm', (req, res) => {
//  const { starttime, startdate, startkm, tripid } = req.body;
//  const query = 'UPDATE tripsheet SET starttime = ?, startdate = ?, startkm = ? WHERE tripid = ?';
//
//  db.query(query, [starttime, startdate, startkm, tripid], (err, results) => {
//    if (err) {
//      res.status(500).json({ message: 'Internal server error' });
//      return;
//    }
//    res.status(200).json({ message: 'Status updated successfully' });
//  });
//});
//end
// checkingmethod
router.put('/startkmupdatetripsheet', (req, res) => {
console.log( "checking123 received");

  // const {startkm, tripid } = req.body;
  const { tripId,startkm ,Hcl,duty} = req.body;
  // const query = 'UPDATE tripsheet SET starttime = ?, startdate = ?, startkm = ? WHERE tripid = ?';
console.log(tripId,startkm ,Hcl,duty , "checking received");
console.log('ajay',typeof(tripId));
console.log('ajay1',typeof(startkm));
//console.log('ajay2',typeof(closekm));
console.log('ajay3',typeof(Hcl));
console.log('ajay4',typeof(duty));

  let sql = "";
  let values = [];
  let hclStartKm = 0;
  if (Hcl === 1 && duty === "Outstation") {
  console.log('hcl1',Hcl);
    // First condition
    sql = "UPDATE tripsheet SET startkm = ? WHERE tripid = ?";
    values = [startkm, tripId];
  } else if (Hcl === 1 && duty !== "Outstation") {
    console.log('hcl2',Hcl);

    // Second condition
    sql = "UPDATE tripsheet SET startkm = ?, vendorshedoutkm = ? WHERE tripid = ?";
    values = [hclStartKm,hclStartKm, tripId];
  } else {
    console.log('hcl3');

    // Default case or other conditions
    sql = "UPDATE tripsheet SET startkm = ? WHERE tripid = ?";
    values = [startkm, tripId];
  }

  db.query(sql,values,(err, result) => {
      if (err) {
        console.log('Error updating tripsheet:', err);
        return res.status(500).send('Failed to update');
      }
      // console.log(result, "data of the tripsheet data of the tripsheettttt")
//      return res.status(200).send('Successfully updated');
      return res.status(200).json({ success: true, message: 'Successfully updated' });

    }
  );

  // db.query(query, [starttime, startdate, startkm, tripid], (err, results) => {
  //   if (err) {
  //     res.status(500).json({ message: 'Internal server error' });
  //     return;
  //   }
  //   res.status(200).json({ message: 'Status updated successfully' });
  // });
});


router.put('/closekmupdatetripsheet', (req, res) => {
  // const {startkm, tripid } = req.body;
  const { tripId, closekm ,Hcl,duty} = req.body;
  // const query = 'UPDATE tripsheet SET starttime = ?, startdate = ?, startkm = ? WHERE tripid = ?';
console.log(tripId, closekm ,Hcl,duty , "checking received");
console.log('ajay',typeof(tripId));
console.log('ajay2',typeof(closekm));
console.log('ajay3',typeof(Hcl),Hcl);
console.log('ajay4',typeof(duty));

  let sql = "";
  let values = [];

  if (Hcl === '1' && duty === "Outstation") {
    // First condition
    console.log("firstttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt")
    sql = "UPDATE tripsheet SET  closekm = ? WHERE tripid = ?";
    values = [closekm,tripId];
  } else if (Hcl === '1' && duty !== "Outstation") {
    // Second condition
        console.log("secondddddddddd")
    sql = "UPDATE tripsheet SET closekm = ?,vendorshedinkm = ? WHERE tripid = ?";
    values = [ closekm, closekm,tripId];
  } else {
    // Default case or other conditions
        console.log("thirddddd")
    sql = "UPDATE tripsheet SET  closekm = ? WHERE tripid = ?";
    values = [ closekm,tripId];
  }

  db.query(sql,values,(err, result) => {
      if (err) {
        console.log('Error updating tripsheet:', err);
        return res.status(500).send('Failed to update');
      }
      // console.log(result, "data of the tripsheet data of the tripsheet")
      return res.status(200).send('Successfully updated');
    }
  );

  // db.query(query, [starttime, startdate, startkm, tripid], (err, results) => {
  //   if (err) {
  //     res.status(500).json({ message: 'Internal server error' });
  //     return;
  //   }
  //   res.status(200).json({ message: 'Status updated successfully' });
  // });
});

module.exports = router;