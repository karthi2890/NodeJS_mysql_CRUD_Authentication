const error = require("../middleware/error");
const store = require("../routes/store");
const customer = require("../routes/customer");
const user = require("../routes/user");
const bodyParser = require("body-parser");
const cors = require("cors");

module.exports = function(app) {
  app.use(cors());
  app.use(bodyParser.json());
  app.use(
    bodyParser.urlencoded({
      extended: true
    })
  );
  app.use("/api/store", store);
  app.use("/api/customer", customer);
  app.use("/api/user", user);
  app.use(error);
};
