const express = require("express");
const router = express.Router();
const { connection } = require("../startup/db");
const { userSchema } = require("../models/user");
const mysql = require("mysql");
const Joi = require("joi");
const jwt = require("jsonwebtoken");
const config = require("config");

router.post("/register", async function(req, res, next) {
  try {
    const { error } = Joi.validate(req.body, userSchema);
    if (error) return res.send(error.details[0].message);
    let sql = `CALL createUser(?,?)`;
    await connection.query(
      sql,
      [req.body.username, req.body.password],
      function(error, results, fields) {
        if (error) throw error;
        const data = results[0][0].result;
        if (!data) {
          return res.status(400).send("User Already Exists");
        }
        res
          .status(201)
          .send({ success: true, message: "User added successfully" });
      }
    );
  } catch (ex) {
    next(ex);
  }
});

router.post("/login", async function(req, res, next) {
  try {
    const { error } = Joi.validate(req.body, userSchema);
    if (error) res.send(error.details[0].message);

    let sql = `CALL validateUser(?,?)`;
    await connection.query(
      sql,
      [req.body.username, req.body.password],
      function(error, results, fields) {
        if (error) throw error;
        const Id = results[0][0].Id;
        if (!Id) {
          return res.status(401).send("Invalid username or passsword.");
        }
        const token = jwt.sign({ id: Id }, config.get("jwtPrivateKey"));
        res.send({
          success: true,
          message: { username: req.body.username, token }
        });
      }
    );
  } catch (ex) {
    next(ex);
  }
});

module.exports = router;
