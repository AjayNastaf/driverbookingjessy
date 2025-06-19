const mysql = require("mysql");
require("dotenv").config();



console.log('dottt DB pass', process.env.DB_PASSWORD);
console.log('dottt DB host',process.env.DB_HOST);
console.log('dottt DB user',process.env.DB_USER);
console.log('dottt DB name',process.env.DB_NAME);
console.log('dottt DB port',process.env.DB_PORT);

const db = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  port: process.env.DB_PORT,
});

db.connect((err) => {
  if (err) {
    throw err;
  }
  console.log("MySQL connected");
});

module.exports = db;