const express = require("express");
const app = express();
require("dotenv").config();

app.get("/", (req, res) => {
  res.json({
    api: "ecs-test",
    live: true,
  });
});

app.get("/users", (req, res) => {
  res.json({
    users: ["me", "myself", "I"],
    success: true,
  });
});

app.listen(process.env.PORT, () =>
  console.log(`🚀 Listening on: http://localhost:${process.env.PORT}`)
);
