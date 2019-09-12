const Joi = require("joi");

const storeSchema = {
  Id: Joi.number(),
  Phone: Joi.string(),
  Name: Joi.string(),
  Domain: Joi.string(),
  Status: Joi.string(),
  Street: Joi.string(),
  State: Joi.string()
};

exports.storeSchema = storeSchema;
