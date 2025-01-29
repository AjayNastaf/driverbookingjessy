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



router.post("/addvehiclelocationUniqueLatlong", (req, res) => {
    const {vehicleno,latitudeloc,longitutdeloc,Trip_id,Runing_Date,Runing_Time,Trip_Status,Tripstarttime,TripEndTime,created_at}=req.body;
console.log('vengy');
    const uniquelatlong = `
    select * from   VehicleAccessLocation
    where Trip_id = ? and Runing_Date = ? ORDER BY  veh_id DESC
LIMIT 1;`

    const insertUserSql = "INSERT INTO  VehicleAccessLocation (Vehicle_No,Trip_id,Latitude_loc,Longtitude_loc,Runing_Date,Runing_Time,Trip_Status,Tripstarttime,TripEndTime,created_at) VALUES (?,?,?,?,?,?,?,?,?,?)";
    // db.query(insertUserSql, [vehicleno,latitudeloc,longitutdeloc,created_at], (err, result) => {
    //   if (err) {
    //     return res.status(500).send({ message: "Failed to Add vehicle data " });
    //   }
    //   res.status(200).send({
    //     message: "vehicle registered successfully",
    //     // userId: result.insertId,
    //   });
    // })

    db.query(uniquelatlong, [Trip_id,Runing_Date], (err, result) => {
      if (err) {
        return res.status(500).send({ message: "Failed to Add vehicle data " });
      }
//      console.log(result, "result got")
      console.log(Trip_id,Runing_Date, "tripresult got")
      console.log(typeof(Trip_id));
      if(result.length > 0){
        const  data = Number(result[0].Latitude_loc);
        console.log(data, "data fetched");
        console.log(latitudeloc,"lattttttt",typeof(latitudeloc))
    if(data === latitudeloc){
    console.log("ajayyy");
     return res.status(200).send({
//      console.log("sdfghjkl.");
        message: "vehicle registered successfully",
        // userId: result.insertId,
      });


    }
    else{
         db.query(insertUserSql, [vehicleno,Trip_id,latitudeloc,longitutdeloc,Runing_Date,Runing_Time,Trip_Status,Tripstarttime,TripEndTime,created_at], (err, result2) => {
      if (err) {
        return res.status(500).send({ message: "Failed to Add vehicle data " });
      }
      res.status(200).send({
        message: "vehicle registered successfully",
        // userId: result.insertId,
      });
    })
  }

      }
      else{
        db.query(insertUserSql, [vehicleno,Trip_id,latitudeloc,longitutdeloc,Runing_Date,Runing_Time,Trip_Status,Tripstarttime,TripEndTime,created_at], (err, result) => {
          if (err) {
          console.log(err,'no result')
            return res.status(500).send({ message: "Failed to Add vehicle data " });
          }
          res.status(200).send({
            message: "vehicle registered successfully",
            // userId: result.insertId,
          });
        })
      }

      // res.status(200).send({
      //   message: "vehicle registered successfully",
      //   // userId: result.insertId,
      });

})
module.exports = router;