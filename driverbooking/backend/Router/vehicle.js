const express = require('express');
const router = express.Router();
const db = require("../db")
// const multer = require('multer');

router.post("/addvehiclelocation", (req, res) => {
    const {vehicleno,latitudeloc,longitutdeloc,Trip_id,Runing_Date,Runing_Time,Trip_Status,Tripstarttime,TripEndTime,created_at}=req.body;
    const insertUserSql = "INSERT INTO  VehicleAccessLocation (Vehicle_No,Trip_id,Latitude_loc,Longtitude_loc,Runing_Date,Runing_Time,Trip_Status,Tripstarttime,TripEndTime,created_at) VALUES (?,?,?,?,?,?,?,?,?,?)";
    db.query(insertUserSql, [vehicleno,Trip_id,latitudeloc,longitutdeloc,Runing_Date,Runing_Time,Trip_Status,Tripstarttime,TripEndTime,created_at], (err, result) => {
      if (err) {
        return res.status(500).send({ message: "Failed to Save Lat Long" });
      }
      res.status(200).send({
        message: "Lat Long Saved successfully",
        // userId: result.insertId,
      });
    })
})



//router.post("/addvehiclelocationUniqueLatlong", (req, res) => {
//    const {vehicleno,latitudeloc,longitutdeloc,Trip_id,Runing_Date,Runing_Time,Trip_Status,Tripstarttime,TripEndTime,created_at}=req.body;
//console.log('vengy');
//    const uniquelatlong = `
//    select * from   VehicleAccessLocation
//    where Trip_id = ? and Runing_Date = ? ORDER BY  veh_id DESC
//LIMIT 1;`
//
//    const insertUserSql = "INSERT INTO  VehicleAccessLocation (Vehicle_No,Trip_id,Latitude_loc,Longtitude_loc,Runing_Date,Runing_Time,Trip_Status,Tripstarttime,TripEndTime,created_at) VALUES (?,?,?,?,?,?,?,?,?,?)";
//    // db.query(insertUserSql, [vehicleno,latitudeloc,longitutdeloc,created_at], (err, result) => {
//    //   if (err) {
//    //     return res.status(500).send({ message: "Failed to Add vehicle data " });
//    //   }
//    //   res.status(200).send({
//    //     message: "vehicle registered successfully",
//    //     // userId: result.insertId,
//    //   });
//    // })
//const sqlReachedQuery = "SELECT * FROM VehicleAccessLocation WHERE Trip_id =? AND Trip_Status ='Reached' ";
//db.query(sqlReachedQuery,[Trip_id],(err,reachedresult)=>{
//if(err){
//console.log(err)
//}
//console.log(reachedresult,"reachhhhhhhhhhhhhhhh")
//})
//    db.query(uniquelatlong, [Trip_id,Runing_Date], (err, result) => {
//      if (err) {
//        return res.status(500).send({ message: "Failed to Add vehicle data " });
//      }
////      console.log(result, "result got")
//      console.log(Trip_id,Runing_Date, "tripresult got")
//      console.log(typeof(Trip_id));
//      if(result.length > 0){
//        const  data = Number(result[0].Latitude_loc);
//        console.log(data, "data fetched");
//        console.log(latitudeloc,"lattttttt",typeof(latitudeloc))
//    if(data === latitudeloc){
//    console.log("ajayyy");
//     return res.status(200).send({
////      console.log("sdfghjkl.");
//        message: "vehicle registered successfully",
//        // userId: result.insertId,
//      });
//
//
//    }
//    else{
//         db.query(insertUserSql, [vehicleno,Trip_id,latitudeloc,longitutdeloc,Runing_Date,Runing_Time,Trip_Status,Tripstarttime,TripEndTime,created_at], (err, result2) => {
//      if (err) {
//        return res.status(500).send({ message: "Failed to Add vehicle data " });
//      }
//      res.status(200).send({
//        message: "vehicle registered successfully",
//        // userId: result.insertId,
//      });
//    })
//  }
//
//      }
//      else{
//        db.query(insertUserSql, [vehicleno,Trip_id,latitudeloc,longitutdeloc,Runing_Date,Runing_Time,Trip_Status,Tripstarttime,TripEndTime,created_at], (err, result) => {
//          if (err) {
//          console.log(err,'no result')
//            return res.status(500).send({ message: "Failed to Add vehicle data " });
//          }
//          res.status(200).send({
//            message: "vehicle registered successfully",
//            // userId: result.insertId,
//          });
//        })
//      }
//
//      // res.status(200).send({
//      //   message: "vehicle registered successfully",
//      //   // userId: result.insertId,
//      });
//
//})


router.post("/addvehiclelocationUniqueLatlong", (req, res) => {
    const { vehicleno, latitudeloc, longitutdeloc, Trip_id, Runing_Date, Runing_Time, Trip_Status, Tripstarttime, TripEndTime, created_at } = req.body;

    console.log('vengy');

    // Query to check if the trip status is already 'Reached'
    const sqlReachedQuery = "SELECT * FROM VehicleAccessLocation WHERE Trip_id = ? AND Trip_Status = 'Reached'";

    db.query(sqlReachedQuery, [Trip_id], (err, reachedresult) => {
        if (err) {
            console.log("Error checking trip status:", err);
            return res.status(500).send({ message: "Database error while checking trip status." });
        }

        console.log(reachedresult, "reachhhhhhhhhhhhhhhh");

        // If trip status is already 'Reached', do not insert
        if (reachedresult.length > 0) {
            return res.status(200).send({ message: "Trip already marked as 'Reached'. No further insertion required." });
        }

        // Query to get the last location for this trip
        const uniquelatlong = `
            SELECT * FROM VehicleAccessLocation
            WHERE Trip_id = ? AND Runing_Date = ?
            ORDER BY veh_id DESC
            LIMIT 1;
        `;

        db.query(uniquelatlong, [Trip_id, Runing_Date], (err, result) => {
            if (err) {
                return res.status(500).send({ message: "Failed to retrieve last location data." });
            }

            console.log(Trip_id, Runing_Date, "trip result got");

            if (result.length > 0) {
                const lastLatitude = Number(result[0].Latitude_loc);
                console.log(lastLatitude, "Last recorded latitude");

                if (lastLatitude === latitudeloc) {
                    console.log("Duplicate location, skipping insert.");
                    return res.status(200).send({ message: "Location already recorded. No insert required." });
                }
            }

            // Insert the new location entry since it's a new location
            const insertUserSql = `
                INSERT INTO VehicleAccessLocation
                (Vehicle_No, Trip_id, Latitude_loc, Longtitude_loc, Runing_Date, Runing_Time, Trip_Status, Tripstarttime, TripEndTime, created_at)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            `;

            db.query(insertUserSql, [vehicleno, Trip_id, latitudeloc, longitutdeloc, Runing_Date, Runing_Time, Trip_Status, Tripstarttime, TripEndTime, created_at], (err, insertResult) => {
                if (err) {
                    console.log("Error inserting vehicle data:", err);
                    return res.status(500).send({ message: "Failed to add vehicle data." });
                }

                res.status(200).send({ message: "Vehicle registered successfully." });
            });
        });
    });
});



//for inserting start data
//router.post('/insertStartData',(req,res)=>{
//  const insertUserSql = ` INSERT INTO VehicleAccessLocation
//                (Vehicle_No, Trip_id, Latitude_loc, Longtitude_loc, Runing_Date, Runing_Time, Trip_Status, Tripstarttime, TripEndTime, created_at)
//                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?) `;
//            db.query(insertUserSql,(error,result)=>{
//            if(error){
//            console.log(error,"error")
//            }
//                            res.status(200).send({ message: "Start Vehicle registered successfully." });
//            })
//})


router.post('/insertStartData', (req, res) => {
    console.log("📢 Received request at /insertStartData");
    console.log("📝 Request Body:", req.body);

    const insertUserSql = `
        INSERT INTO VehicleAccessLocation
        (Vehicle_No, Trip_id, Latitude_loc, Longtitude_loc, Runing_Date, Runing_Time, Trip_Status, Tripstarttime, TripEndTime, created_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `;

    const values = [
        req.body.Vehicle_No,
        req.body.Trip_id,
        req.body.Latitude_loc,
        req.body.Longtitude_loc,
        req.body.Runing_Date,
        req.body.Runing_Time,
        req.body.Trip_Status,
        req.body.Tripstarttime,
        req.body.TripEndTime,
        new Date().toISOString() // Auto-generate created_at timestamp
    ];

    console.log("📌 Query to be executed:", insertUserSql);
    console.log("📊 Query Values:", values);

    db.query(insertUserSql, values, (error, result) => {
        if (error) {
            console.error("❌ Database Error:", error);
            return res.status(500).send({ message: "Database error", error: error });
        }

        console.log("✅ Data inserted successfully:", result);
        res.status(200).send({ message: "Start Vehicle registered successfully." });
    });
});


router.post('/insertReachedData', (req, res) => {
    console.log("📢 Received request at /insertReachedData");
    console.log("📝 Request Body:", req.body);

    const insertUserSql = `
        INSERT INTO VehicleAccessLocation
        (Vehicle_No, Trip_id, Latitude_loc, Longtitude_loc, Runing_Date, Runing_Time, Trip_Status, Tripstarttime, TripEndTime, created_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `;

    const values = [
        req.body.Vehicle_No,
        req.body.Trip_id,
        req.body.Latitude_loc,
        req.body.Longtitude_loc,
        req.body.Runing_Date,
        req.body.Runing_Time,
        req.body.Trip_Status,
        req.body.Tripstarttime,
        req.body.TripEndTime,
        new Date().toISOString() // Auto-generate created_at timestamp
    ];

    console.log("📌 Query to be executed:", insertUserSql);
    console.log("📊 Query Values:", values);

    db.query(insertUserSql, values, (error, result) => {
        if (error) {
            console.error("❌ Database Error:", error);
            return res.status(500).send({ message: "Database error", error: error });
        }

        console.log("✅ Data inserted successfully:", result);
        res.status(200).send({ message: "Reached successfully." });
    });
});


router.post('/insertWayPointData', (req, res) => {
    console.log("📢 Received request at /insertReachedData");
    console.log("📝 Request Body:", req.body);

    const insertUserSql = `
        INSERT INTO VehicleAccessLocation
        (Vehicle_No, Trip_id, Latitude_loc, Longtitude_loc, Runing_Date, Runing_Time, Trip_Status, Tripstarttime, TripEndTime, created_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `;

    const values = [
        req.body.Vehicle_No,
        req.body.Trip_id,
        req.body.Latitude_loc,
        req.body.Longtitude_loc,
        req.body.Runing_Date,
        req.body.Runing_Time,
        req.body.Trip_Status,
        req.body.Tripstarttime,
        req.body.TripEndTime,
        new Date().toISOString() // Auto-generate created_at timestamp
    ];

    console.log("📌 Query to be executed:", insertUserSql);
    console.log("📊 Query Values:", values);

    db.query(insertUserSql, values, (error, result) => {
        if (error) {
            console.error("❌ Database Error:", error);
            return res.status(500).send({ message: "Database error", error: error });
        }

        console.log("✅ Data inserted successfully:", result);
        res.status(200).send({ message: "Reached successfully." });
    });
});







router.get('/Vehilcereachedstatus/:tripid', (req, res) => {
  const { tripid } = req.params;

  console.log("Received tripidddddddooo:", tripid);

  db.query(
    'SELECT * FROM VehicleAccessLocation WHERE Trip_id = ? AND Trip_Status = "Reached"',
    [tripid],
    (err, result) => {
      if (err) {
        console.error("Database error:", err);
        return res.status(500).json({ error: 'Failed to retrieve data' });
      }

      console.log("Query Result:", result);
      return res.status(200).json(result);
    }
  );
});





module.exports = router;