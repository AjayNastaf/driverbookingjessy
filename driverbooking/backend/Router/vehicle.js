const express = require('express');
const router = express.Router();
const db = require("../db")
// const multer = require('multer');

router.post("/addvehiclelocation", (req, res) => {
    const {vehicleno,latitudeloc,longitutdeloc,created_at}=req.body;
    const insertUserSql = "INSERT INTO  VehicleAccessLocation (Vehicle_No,Latitude_loc,Longtitude_loc,created_at) VALUES (?,?,?,?)";
    db.query(insertUserSql, [vehicleno,latitudeloc,longitutdeloc,created_at], (err, result) => {
      if (err) {
        return res.status(500).send({ message: "Failed to Add vehicle data " });
      }
      res.status(200).send({
        message: "vehicle registered successfully",
        // userId: result.insertId,
      });
    })
})

module.exports = router;