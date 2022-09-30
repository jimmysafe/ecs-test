const express = require("express");
const app = express();
require("dotenv").config();

const env = process.env.vars ? JSON.parse(process.env.vars) : process.env;

app.get("/", (req, res) => {
  res.json(env);
});

app.get("/users", (req, res) => {
  res.json({
    users: ["me", "myself", "I"],
    success: true,
  });
});

app.get("/reviews", (req, res) => {
  res.json({
    users: ["Cool Movie!"],
    success: true,
  });
});

app.listen(process.env.PORT, () =>
  console.log(`🚀 Listening on: http://localhost:${process.env.PORT}`)
);
