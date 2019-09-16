const jwt = require("jsonwebtoken");
const config = require("config");
//middleware authentication function for authenticating the end points
module.exports = function(req, res, next) {
  const token = req.header("x-auth-token");
  if (!token) return res.status(401).send("Acess denied. No token provided.");
  try {
    const decoded = jwt.verify(token, config.get("jwtPrivateKey"));
    req.username = decoded;
    next();
  } catch (ex) {
    res.status(401).send("Invalid token.");
  }
};
