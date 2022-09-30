const express = require("express");
const app = express();
require("dotenv").config();

app.get("/", (req, res) => {
  res.json(process.env);
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
  });
});

app.listen(process.env.PORT, () =>
  console.log(`🚀 Listening on: http://localhost:${process.env.PORT}`)
);
