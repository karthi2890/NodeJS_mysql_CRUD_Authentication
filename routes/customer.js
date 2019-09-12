const express = require("express");
const router = express.Router();
const { connection } = require("../startup/db");
const mysql = require("mysql");
const auth = require("../middleware/auth");
const { customerSchema } = require("../models/customer");
const Joi = require("joi");

//Story 6 - Create a Customer
router.post("/", auth, async function(req, res, next) {
  try {
    const { error } = Joi.validate(req.body, customerSchema);
    if (error) return res.status(400).send(error.details[0].message);
    let sql = `CALL InsertCustomer(?,?,?,?,?)`;
    await connection.query(
      sql,
      [
        req.body.storeid,
        req.body.firstname,
        req.body.lastname,
        req.body.phone,
        req.body.email
      ],
      function(error, results, fields) {
        if (error) throw error;
        res.status(201).send({ success: true, message: `Customer inserted.` });
      }
    );
  } catch (ex) {
    next(ex);
  }
});

module.exports = router;
