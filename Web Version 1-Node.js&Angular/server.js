const express = require("express");
const app = express();
const axios = require("axios");
const port = process.env.PORT || 3000;
const path = require("path");

const yelp = require("yelp-fusion");
const client = yelp.client(
  "abcdefg"
);

const businessSearchApi = "https://api.yelp.com/v3/businesses/search";
const businessDetailsApi = "https://api.yelp.com/v3/businesses/";
const businessReviewsApi = "https://api.yelp.com/v3/businesses/";
const autoCompleteApi = "https://api.yelp.com/v3/autocomplete?text=sushi";

const Authorization =
  "abcdefg";

const geoCodeApi = "https://maps.googleapis.com/maps/api/geocode/json?";
const geoCodeKey = "abcdefg";

const publicPath = path.join(__dirname, "/dist/hw8_app");

app.use(express.static(publicPath));

app.get("*", (req, res) => {
  res.sendFile(path.join(__dirname + "/dist/hw8_app/index.html"));
});

app.use((req, res, next) => {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader(
    "Access-Control-Allow-Headers",
    "Origin, X-Requested-With, Content-Type, Accept"
  );
  res.setHeader(
    "Access-Control-Allow-Methods",
    "GET, POST, PATCH, DELETE, OPTIONS"
  );
  next();
});

app.get("/api/businessSearch", async function (req, res, next) {
  const query = req.query;
  const term = query.term;
  const latitude = query.latitude;
  const longitude = query.longitude;
  const radius = query.radius;
  let categories = query.categories;
  const config = {
    params: {
      term: term,
      categories: categories,
      latitude: latitude,
      longitude: longitude,
      radius: radius,
    },
    headers: {
      Authorization: Authorization,
    },
  };
  const response = await axios.get(businessSearchApi, config);

  res.json(response.data);
});

app.get("/api/businessDetails", async function (req, res, next) {
  const query = req.query;
  const id = query.id;
  const response = await axios.get(businessDetailsApi + id, {
    headers: {
      Authorization: Authorization,
    },
  });

  res.json(response.data);
});

app.get("/api/businessReviews", async function (req, res, next) {
  const query = req.query;
  const id = query.id;
  const response = await axios.get(businessDetailsApi + id + "/reviews", {
    headers: {
      Authorization: Authorization,
    },
  });

  res.json(response.data);
});

app.get("/api/autocomplete", async function (req, res, next) {
  const query = req.query;
  const text = query.text;
  client
    .autocomplete({
      text: text,
    })
    .then((response) => {
      console.log(response.jsonBody.terms);
      res.json(response.jsonBody.terms);
    })
    .catch((e) => {
      console.log(e);
    });
});

app.get("/api/geoCode", async function (req, res, next) {
  const query = req.query;
  const location = query.location;
  const params = {
    address: location,
    key: geoCodeKey,
  };
  const response = await axios.get(geoCodeApi, { params: params });
  res.json(response.data);
});

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});
