const express = require("express");
const router = express.Router();
const { connection } = require("../startup/db");
const mysql = require("mysql");
const auth = require("../middleware/auth");
const { storeSchema } = require("../models/store");
const Joi = require("joi");

//Story 2 - Retrieving list of Stores
router.get("/", auth, async function(req, res, next) {
  try {
    let sql = `CALL getStoreDetails()`;
    await connection.query(sql, function(error, results, fields) {
      if (error) throw error;
      const data = JSON.parse(JSON.stringify(results[0]));
      res.send({ success: true, data });
    });
  } catch (ex) {
    next(ex);
  }
});

//Story 1 - Retrieving a Store by ID
router.get("/:Id", auth, async function(req, res, next) {
  try {
    let { error } = Joi.validate({ Id: req.params.Id }, storeSchema);
    if (error) return res.status(400).send(error.details[0].message);
    let sql = `CALL getStoreDetailsById(?)`;
    await connection.query(sql, [req.params.Id], function(
      error,
      results,
      fields
    ) {
      if (error) throw error;
      const data = JSON.parse(JSON.stringify(results[0]));
      res.send({ success: true, data });
    });
  } catch (ex) {
    next(ex);
  }
});
//Story 3 - Update a Store
router.patch("/:Id", auth, async function(req, res, next) {
  try {
    let { error } = Joi.validate(
      { ...req.body, Id: req.params.Id },
      storeSchema
    );
    if (error) return res.status(400).send(error.details[0].message);

    let sql = `CALL UpdateStore(?,?,?,?,?,?,?)`;
    await connection.query(
      sql,
      [
        req.body.Phone,
        req.body.Name,
        req.body.Domain,
        req.body.Status,
        req.body.Street,
        req.body.State,
        req.params.Id
      ],
      (error, results, fields) => {
        if (error) throw error;
        res.status(204).send({ success: true });
      }
    );
  } catch (ex) {
    next(ex);
  }
});

//Story 4 - Retrieving list of Stores w/ total customers count
router.get("/list/customers", auth, async function(req, res, next) {
  try {
    let sql = `CALL getStoreCustomers()`;
    await connection.query(sql, function(error, results, fields) {
      if (error) throw error;
      const data = JSON.parse(JSON.stringify(results[0]));
      res.send({ success: true, data });
    });
  } catch (ex) {
    next(ex);
  }
});
//Story 5 - Retrieve a Stores Customers
router.get("/:Id/customers", auth, async function(req, res, next) {
  try {
    let { error } = Joi.validate({ Id: req.params.Id }, storeSchema);
    if (error) return res.status(400).send(error.details[0].message);
    let sql = `CALL getStoreCustomersById(?)`;
    await connection.query(sql, req.params.Id, function(
      error,
      results,
      fields
    ) {
      if (error) throw error;
      const data = JSON.parse(JSON.stringify(results[0]));
      res.send({ success: true, data });
    });
  } catch (ex) {
    next(ex);
  }
});

//Story 7 - Search for Store
router.get("/search/:name", auth, async function(req, res, next) {
  try {
    let sql = `CALL searchStore(?)`;
    await connection.query(sql, req.params.name, function(
      error,
      results,
      fields
    ) {
      if (error) throw error;
      const data = JSON.parse(JSON.stringify(results[0]));
      res.send({ success: true, data });
    });
  } catch (ex) {
    next(ex);
  }
});

module.exports = router;
