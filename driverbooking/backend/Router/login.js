const express = require('express');
const router = express.Router();
const db = require('../db');
const multer = require('multer');
// const path = require('path'); // Import path module

const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, './profile_photos'); // Store uploaded files in the 'uploads' directory
    },
    filename: (req, file, cb) => {
        // const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
        // cb(null, `${uniqueSuffix}-${file.originalname}`);
        cb(null, `${file.fieldname}_${Date.now()}-${file.originalname}`);
    },
});
const upload = multer({ storage: storage });





router.post('/login', (req, res) => {
    const { username, userpassword } = req.body;
    console.log(username ,userpassword,"yser")

    db.query('SELECT * FROM drivercreation WHERE username = ? AND userpassword = ?', [username, userpassword], (err, result) => {

        if (err) {
            return res.status(500).json({ error: 'Failed to retrieve user details from MySQL' });
        }
       
        if(result.length > 0){
      
        // console.log(user,"uuuuuppp",result[0]?.length)
        db.query("UPDATE drivercreation SET active ='yes' WHERE username = ? AND userpassword = ?", [username,userpassword], (err, result1) => {
            if (err) {
                console.log(err, "error");
                return res.status(500).json({ error: 'Failed to update status' });
            }
            console.log(result, 'result');
            return res.status(200).json({ message: 'Login successful', user : result });
//             return res.status(200).json(result);
        });
    }
    else{
        // console.log("login failed")
        return res.status(404).json({ error: 'Invalid credentials. Please check your username and userpassword.' });
    }

   
    });
});

router.post('/logoutDriver',(req,res)=>{
    const { username, userpassword } = req.body;
    
   
    db.query("UPDATE drivercreation SET active ='no' WHERE drivername = ? AND userpassword = ?", [username,userpassword], (err, result) => {
        if (err) {
            console.log(err, "error");
            return res.status(500).json({ error: 'Failed to update status' });
        }
        // console.log(result, 'result');
        return res.status(200).json({ message: 'Login successful' });
    });})

//get profile details

// router.get('/getDriverProfile', (req, res) => {
//     const username = req.query.username;
//     const query = 'SELECT * FROM usercreation WHERE username = ?';
//     db.query(query, [username], (err, results) => {
//         if (err) {
//             return res.status(500).json({ error: 'Server error' });
//         }
//         if (results.length === 0) {
//             return res.status(404).json({ error: 'Driver not found' });
//         }
//         const driverProfile = results[0];
//         res.status(200).json(driverProfile);
//     });
// });


router.post('/getDriverProfile', (req, res) => {
        const { username } = req.body;
console.log(username,'username checkkk');
//    const query = 'SELECT * FROM drivercreation WHERE drivername = ?';
    const query = 'SELECT * FROM drivercreation WHERE username = ?';
    db.query(query, [username], (err, results) => {
        if (err) {
            return res.status(500).json({ error: 'Server error' });
        }
        if (results.length === 0) {
            return res.status(404).json({ error: 'Driver not found' });
        }
        const driverProfile = results[0];
        // console.log(driverProfile)
        res.status(200).json(driverProfile);
    });
});
// updating profile page



//router.post('/update_updateprofile', (req, res) => {
//    const { username, mobileno, userpassword, email, drivername } = req.body;
//
//
//    const query = 'UPDATE drivercreation SET username = ?, Mobileno = ?, userpassword = ?, Email = ? WHERE drivername = ?';
//
//    db.query(query, [username, mobileno, userpassword, email, drivername], (err, results) => {
//        if (err) {
//            res.status(500).json({ message: 'Internal server error' });
//            return;
//        }
//
//        res.status(200).json({ message: 'Status updated successfully' });
//    });
//});


router.post('/update_updateprofile', (req, res) => {
    const { username, mobileno, userpassword, email } = req.body;


    const query = 'UPDATE drivercreation SET  Mobileno = ?, userpassword = ?, Email = ? WHERE username = ?';

    db.query(query, [ mobileno, userpassword, email, username], (err, results) => {
        if (err) {
            res.status(500).json({ message: 'Internal server error' });
            return;
        }

        res.status(200).json({ message: 'Status updated successfully' });
    });
});





//end
//uploading profile image
// router.post('/uploadProfilePhoto', upload.single('avatar'), (req, res) => {
//     const { username } = req.query;
//     const filePath = req.file.path;
//     const updateQuery = 'UPDATE usercreation SET profile_image = ? WHERE username = ?';
//     db.query(updateQuery, [filePath, username], (err, results) => {
//         if (err) {
//             res.status(500).json({ message: 'Internal server error' });
//             return;
//         }
//         res.status(200).json({ message: 'Profile photo uploaded successfully' });
//     });
// });




router.post('/uploadProfilePhoto', upload.single('Profile_image'), (req, res) => {
    const { username } = req.query;
    const filePath = req.file.path;
    console.log(filePath,"data")
    
    
let parts = filePath.split("\\");
let fileName = parts.pop();
console.log(fileName); // Output: 1715926172877-792287503-car.jpeg

//    const updateQuery = 'UPDATE drivercreation SET Profile_image = ? WHERE drivername = ?';
    const updateQuery = 'UPDATE drivercreation SET Profile_image = ? WHERE username = ?';
    db.query(updateQuery, [fileName, username], (err, results) => {
        if (err) {
            res.status(500).json({ message: 'Internal server error' });
            return;
        }
       
        res.status(200).json({ message: 'Profile photo uploaded successfully' });
    });
});
//end

router.get('/profile_photos', (req, res) => {
    const { username } = req.query;
   
    const selectQuery = 'SELECT Profile_image FROM drivercreation WHERE drivername = ?';
//    const selectQuery = 'SELECT Profile_image FROM drivercreation WHERE username = ?';
    db.query(selectQuery, [username], (err, results) => {
        if (err) {
            res.status(500).json({ message: 'Internal server error' });
            return;
        }
        if (results.length === 0) {
            res.status(404).json({ message: 'Profile not found' });
            return;
        }
          
      
        const profileImagePath = results[0].Profile_image;
        res.status(200).json({ profileImagePath });
    });
});


module.exports = router;