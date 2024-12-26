const express = require('express');
const router = express.Router();
const db = require('../db');
const moment = require('moment');

router.get('/tripsheetfilter/:username', (req, res) => {
    const username = req.params.username; // Corrected parameter name
    const startDate = req.query.startDate;
    const endDate = req.query.endDate;
    const formattedFromDate = moment(startDate).format('YYYY-MM-DD');
    const formattedtoDate = moment(endDate).format('YYYY-MM-DD');
   
    try {
        // const query = "SELECT * FROM tripsheet WHERE driverName = ? AND startdate >= ? AND startdate <= ? ";
        const query = "SELECT * FROM tripsheet WHERE driverName = ?  AND startdate >= DATE_ADD(?, INTERVAL 0 DAY) AND startdate <= DATE_ADD(?, INTERVAL 1 DAY) ";

        db.query(query, [username,formattedFromDate,formattedtoDate], (err, results) => {
            if (err) {
                res.status(500).json({ message: 'Internal server error' });
                return;
            }
            // Check if trip sheet data was found
            if (results.length === 0) {
                res.status(404).json({ message: 'Trip sheet not found' });
                return;
            }
            res.status(200).json(results); // Send filtered data
        });
    } catch (err) {
        res.status(500).json({ message: 'Internal server error' });
    }
});

module.exports = router;