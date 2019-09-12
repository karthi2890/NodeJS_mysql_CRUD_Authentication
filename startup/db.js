const mysql = require("mysql");
const connection = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "Chennai@91",
  database: "touchtosuccess"
});

connection.connect(function(err) {
  if (err) throw err;
  console.log("We are now connected with mysql database...");
});

exports.connection = connection;
