const Joi = require("joi");

const userSchema = {
  username: Joi.string()
    .min(2)
    .max(255)
    .required(),
  password: Joi.string()
    .min(5)
    .max(255)
    .required()
};

exports.userSchema = userSchema;
