const express = require("express");
const config = require("config");
const app = express();
require("./startup/db");
require("./startup/route")(app);

if (!config.get("jwtPrivateKey")) {
  console.log(`[FATAL ERROR]: jwtPrivateKey is not defined.`);
  process.exit(1);
}

const server = app.listen(3000, "127.0.0.1", function() {
  const host = server.address().address;
  const port = server.address().port;

  console.log("App listening at http://%s:%s", host, port);
});
