const Joi = require("joi");

const customerSchema = {
  storeid: Joi.number(),
  firstname: Joi.string()
    .min(2)
    .max(255)
    .required(),
  lastname: Joi.string()
    .min(2)
    .max(255)
    .required(),
  phone: Joi.string(),
  email: Joi.string()
    .email()
    .required()
};

exports.customerSchema = customerSchema;
