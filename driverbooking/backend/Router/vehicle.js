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



// router.post("/addvehiclelocationUniqueLatlong", (req, res) => {
//     const { vehicleno, latitudeloc, longitutdeloc, Trip_id, Runing_Date, Runing_Time, Trip_Status, Tripstarttime, TripEndTime, created_at,reach_30minutes } = req.body;

//     console.log('vengy');

//     // Query to check if the trip status is already 'Reached'
//     const sqlReachedQuery = "SELECT * FROM VehicleAccessLocation WHERE Trip_id = ? AND Trip_Status = 'Reached'";

//     db.query(sqlReachedQuery, [Trip_id], (err, reachedresult) => {
//         if (err) {
//             console.log("Error checking trip status:", err);
//             return res.status(500).send({ message: "Database error while checking trip status." });
//         }

//         // console.log(reachedresult, "reachhhhhhhhhhhhhhhh");

//         // If trip status is already 'Reached', do not insert
//         if (reachedresult.length > 0) {
//             return res.status(200).send({ message: "Trip already marked as 'Reached'. No further insertion required." });
//         }

//         // Query to get the last location for this trip
//         const uniquelatlong = `
//             SELECT * FROM VehicleAccessLocation
//             WHERE Trip_id = ? AND Runing_Date = ?
//             ORDER BY veh_id DESC
//             LIMIT 1;
//         `;

//         db.query(uniquelatlong, [Trip_id, Runing_Date], (err, result) => {
//             if (err) {
//                 return res.status(500).send({ message: "Failed to retrieve last location data." });
//             }

//             console.log(Trip_id, Runing_Date, "trip result got");

//             if (result.length > 0) {
//                 const lastLatitude = Number(result[0].Latitude_loc);
//                 console.log(lastLatitude, "Last recorded latitude");

//                 if (lastLatitude === latitudeloc) {
//                     console.log("Duplicate location, skipping insert.");
//                     return res.status(200).send({ message: "Location already recorded. No insert required." });
//                 }
//             }

//             // Insert the new location entry since it's a new location
//             const insertUserSql = `
//                 INSERT INTO VehicleAccessLocation
//                 (Vehicle_No, Trip_id, Latitude_loc, Longtitude_loc, Runing_Date, Runing_Time, Trip_Status, Tripstarttime, TripEndTime, created_at,reach_30minutes)
//                 VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?)
//             `;

//                if(Trip_Status !== "Reached"){

//             db.query(insertUserSql, [vehicleno, Trip_id, latitudeloc, longitutdeloc, Runing_Date, Runing_Time, Trip_Status, Tripstarttime, TripEndTime, created_at,reach_30minutes], (err, insertResult) => {
//                 if (err) {
//                     console.log("Error inserting vehicle data:", err);
//                     return res.status(500).send({ message: "Failed to add vehicle data." });
//                 }

//                 res.status(200).send({ message: "Vehicle registered successfully." });
//             });
//             }
//         });
//     });
// });





router.post("/addvehiclelocationUniqueLatlong", (req, res) => {
    const { vehicleno, latitudeloc, longitutdeloc, Trip_id, Runing_Date, Runing_Time, Trip_Status, Tripstarttime, TripEndTime, created_at, reach_30minutes } = req.body;

    console.log('vengy');

if(reach_30minutes == 'okay'){
console.log(reach_30minutes,'eeeeeeeeeee');
}
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


                        const selectQuery =`SELECT *
                                FROM VehicleAccessLocation
                                WHERE Trip_id = ? AND reach_30minutes = 'okay'
                                ORDER BY veh_id DESC
                                LIMIT 1`;

                       db.query(selectQuery, [Trip_id], (err, result) => {
    if (err) {
        console.log('Select query error:', err);
        return res.status(500).send({ message: "Server Error" });
    }

    let allowInsert = true;

    if (reach_30minutes === "okay" && result.length > 0) {



//         function addMinutesToTimeStrPure(timeStr, minutesToAdd) {
//         const [hh, mm, ssMs] = timeStr.split(":");
//         const [ss, micro] = ssMs.split(".");

//   // Convert to total milliseconds
//   const totalMs =
//     parseInt(hh) * 3600000 +
//     parseInt(mm) * 60000 +
//     parseInt(ss) * 1000 +
//     parseInt(micro.padEnd(6, "0")) / 1000;

//   // Add 3 minutes in ms
//   const newTotalMs = totalMs + (minutesToAdd * 60 * 1000);

//   // Convert back to HH:mm:ss.ffffff
//   const newHh = String(Math.floor(newTotalMs / 3600000)).padStart(2, "0");
//   const newMm = String(Math.floor((newTotalMs % 3600000) / 60000)).padStart(2, "0");
//   const newSs = String(Math.floor((newTotalMs % 60000) / 1000)).padStart(2, "0");
//   const newMicro = String(Math.round((newTotalMs % 1000) * 1000)).padStart(6, "0");

//   return `${newHh}:${newMm}:${newSs}.${newMicro}`;
// }

// Util function: convert HH:mm:ss.ffffff string to milliseconds
function timeStrToMilliseconds(timeStr) {
  const [hh, mm, ssMs] = timeStr.split(":");
  const [ss, micro = "0"] = ssMs.split(".");
  return (
    parseInt(hh) * 3600000 +
    parseInt(mm) * 60000 +
    parseInt(ss) * 1000 +
    parseInt(micro.padEnd(6, "0")) / 1000
  );
}

// Reuse your existing add-3-minutes logic
function addMinutesToTimeStrPure(timeStr, minutesToAdd) {
  const [hh, mm, ssMs] = timeStr.split(":");
  const [ss, micro = "0"] = ssMs.split(".");

  const totalMs =
    parseInt(hh) * 3600000 +
    parseInt(mm) * 60000 +
    parseInt(ss) * 1000 +
    parseInt(micro.padEnd(6, "0")) / 1000;

  const newTotalMs = totalMs + (minutesToAdd * 60 * 1000);

  const newHh = String(Math.floor(newTotalMs / 3600000)).padStart(2, "0");
  const newMm = String(Math.floor((newTotalMs % 3600000) / 60000)).padStart(2, "0");
  const newSs = String(Math.floor((newTotalMs % 60000) / 1000)).padStart(2, "0");
  const newMicro = String(Math.round((newTotalMs % 1000) * 1000)).padStart(6, "0");

  return `${newHh}:${newMm}:${newSs}.${newMicro}`;
}



const currentTime = Tripstarttime;                // From frontend
const addedTime = addMinutesToTimeStrPure(result[0].Tripstarttime, 3); // +3 min from DB

console.log("Current Time:", currentTime);
console.log("Last + 3min Time:", addedTime);

// Convert to milliseconds to compare safely
const currentMs = timeStrToMilliseconds(currentTime);
const allowedMs = timeStrToMilliseconds(addedTime);


console.log(typeof currentMs, 'Current Time: Datatype');
console.log(typeof allowedMs, 'Last + 3min Time: Datatype');
console.log(`Current Time finally ${currentMs}`);
console.log(`Last + 3min Time: finally ${allowedMs}`);

if (currentMs < allowedMs) {
            allowInsert = false;
        }
    }

    if (!allowInsert) {
        console.log("Blocked: 'okay' message too soon after last one");
        return res.status(200).send({ message: "Skipped duplicate okay message." });
    }
            // Insert the new location entry since it's a new location
            const insertUserSql = `
                INSERT INTO VehicleAccessLocation
                (Vehicle_No, Trip_id, Latitude_loc, Longtitude_loc, Runing_Date, Runing_Time, Trip_Status, Tripstarttime, TripEndTime, created_at, reach_30minutes)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            `;

               if(Trip_Status !== "Reached"){

            db.query(insertUserSql, [vehicleno, Trip_id, latitudeloc, longitutdeloc, Runing_Date, Runing_Time, Trip_Status, Tripstarttime, TripEndTime, created_at, reach_30minutes], (err, insertResult) => {
                if (err) {
                    console.log("Error inserting vehicle data:", err);
                    return res.status(500).send({ message: "Failed to add vehicle data." });
                }

                res.status(200).send({ message: "Vehicle registered successfully." });
            });
            }
        });
    });
 });
})













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


//router.post('/insertStartData', (req, res) => {
//    console.log("📢 Received request at /insertStartData");
//    console.log("📝 Request Body:", req.body);
//    const sqlStartCheckQuery = `Select * FROM VehicleAccessLocation WHERE Trip_Status = ? AND Trip_id = ?`;
//    const Trip_idCheck = req.body.Trip_id;
//    db.query(sqlStartCheckQuery ,Trip_idCheck,(error,Startresult) =>{
//    if(Startresult.length == 0){
//
//    }
//    })
//    const insertUserSql = `
//        INSERT INTO VehicleAccessLocation
//        (Vehicle_No, Trip_id, Latitude_loc, Longtitude_loc, Runing_Date, Runing_Time, Trip_Status, Tripstarttime, TripEndTime, created_at)
//        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
//    `;
//
//    const values = [
//        req.body.Vehicle_No,
//        req.body.Trip_id,
//        req.body.Latitude_loc,
//        req.body.Longtitude_loc,
//        req.body.Runing_Date,
//        req.body.Runing_Time,
//        req.body.Trip_Status,
//        req.body.Tripstarttime,
//        req.body.TripEndTime,
//        new Date().toISOString() // Auto-generate created_at timestamp
//    ];
//
//    console.log("📌insert Query to be executed:", insertUserSql);
//    console.log("📊 Query Values:", values);
//
//    db.query(insertUserSql, values, (error, result) => {
//        if (error) {
//            console.error("❌ Database Error:", error);
//            return res.status(500).send({ message: "Database error", error: error });
//        }
//
//        console.log("✅ Data inserted successfully:", result);
//        res.status(200).send({ message: "Start Vehicle registered successfully." });
//    });
//});

router.post('/insertStartData', (req, res) => {
    console.log("📢 Received request at /insertStartData");
    console.log("📝 Request Body:", req.body);

    const sqlStartCheckQuery = `SELECT * FROM VehicleAccessLocation WHERE Trip_Status = ? AND Trip_id = ?`;
    const TripStatusCheck = req.body.Trip_Status;
    const TripIdCheck = req.body.Trip_id;

    db.query(sqlStartCheckQuery, [TripStatusCheck, TripIdCheck], (error, Startresult) => {
        if (error) {
            console.error("❌ Error while checking existing trip:", error);
            return res.status(500).send({ message: "Database error", error: error });
        }

        if (Startresult.length === 0) {
            const insertUserSql = `
                INSERT INTO VehicleAccessLocation
                (Vehicle_No, Trip_id, Latitude_loc, Longtitude_loc, Runing_Date, Runing_Time, Trip_Status, Tripstarttime, TripEndTime, created_at, reach_30minutes)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"okay")
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
                req.body.created_at,
            ];

            console.log("📌 Insert query to be executed starting:", insertUserSql);
            console.log("📊 Query Values:", values);

            db.query(insertUserSql, values, (error, result) => {
                if (error) {
                    console.error("❌ Insert Error:", error);
                    return res.status(500).send({ message: "Insert error", error: error });
                }

                console.log("✅ Data inserted successfully starting:", result);
                res.status(200).send({ message: "Start Vehicle registered successfully starting." });
            });

        } else {
            console.log("🚫 Trip already exists with same Trip_Status and Trip_id.");
            res.status(409).send({ message: "Trip already started or data already exists." });
        }
    });
});


router.post('/insertReachedData', (req, res) => {
    console.log("📢 Received request at /insertReachedData");
    console.log("📝 Request Body:", req.body);
    const { vehicleno, latitudeloc, longitutdeloc, Trip_id, Runing_Date, Runing_Time, Trip_Status, Tripstarttime, TripEndTime, created_at } = req.body;

        console.log('vengy');

        // Query to check if the trip status is already 'Reached'
        const sqlReachedQuery = "SELECT * FROM VehicleAccessLocation WHERE Trip_id = ? AND Trip_Status = 'Reached'";

        db.query(sqlReachedQuery, [Trip_id], (err, reachedresult) => {
            if (err) {
                console.log("Error checking trip status:", err);
                return res.status(500).send({ message: "Database error while checking trip status." });
            }

            // console.log(reachedresult, "reachhhhhhhhhhhhhhhh");

            // If trip status is already 'Reached', do not insert
            if (reachedresult.length > 0) {
                return res.status(200).send({ message: "Trip already marked as 'Reached'. No further insertion required." });
            }




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
        req.body.created_at,
    ];

    console.log("📌 Query to be executed:", insertUserSql);
    console.log("📊 Query Valuess:", values);

    db.query(insertUserSql, values, (error, result) => {
        if (error) {
            console.error("❌ Database Error:", error);
            return res.status(500).send({ message: "Database error", error: error });
        }

        console.log("✅ Data inserted successfully:", result);
        res.status(200).send({ message: "Reached successfully." });
    });
});
});


router.post('/insertWayPointData', (req, res) => {
    console.log("📢 Received request at /insertReachedData for way point");
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




router.get('/getokaymessage/:trip_id',(req,res)=>{

    const {trip_id} = req.params;

    console.log('params id received', trip_id);


    const selectQuery = `SELECT Tripstarttime, reach_30minutes
                           FROM VehicleAccessLocation
                           WHERE reach_30minutes = 'okay' AND Trip_id = ?
                           ORDER BY Tripstarttime DESC
                           LIMIT 1`;

    db.query(selectQuery,[trip_id],(err, result)=>{
            if(err){
                console.log(`Error is for okay message ${err}`);
                return res.status(400).send({ message:'server error'});
            }
            if(result.length == 0){
                console.log(`No data found for okay message${err}`);
                return res.status(404).send({ message:'No data found'});
            }
            console.log('resulttttttttt', result);

            const TripStartTime = result[0].Tripstarttime;

            console.log('separate',TripStartTime);

            return res.status(200).send({ message: 'Data found', TripStartTime});
    })
})





module.exports = router;