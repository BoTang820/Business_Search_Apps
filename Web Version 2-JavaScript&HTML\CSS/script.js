const autoDetectCheckbox = document.getElementById("checkbox");
const submitButton = document.getElementById("submitButton");
const clearButton = document.getElementById("clearButton");
const userInputs = document.querySelectorAll("input, select");
const postTemplate = document.getElementById("single-post");
const listElement = document.querySelector(".posts");
const table = document.getElementById("table");
const headers = table.querySelectorAll(".sortTarget");
const card = document.getElementById("card");
const tableBody = table.querySelector("tbody");
const noRecordMessage = document.querySelector(".noRecordMessage");

const geoCodeApi = "https://maps.googleapis.com/maps/api/geocode/json?";
const ipinfoApi = "https://ipinfo.io/json?token=abcdefg";
const businessSearchApi = "http://127.0.0.1:5000/businessSearch";
const businessDetailsApi = "http://127.0.0.1:5000/businessDetails";

[].forEach.call(headers, function (header, index) {
  const sort = sortColumn.bind(null, index);
  header.addEventListener("click", sort);
});

function makeTableVisible() {
  table.classList.remove("none");
}

function makeTableInvisible() {
  table.classList.add("none");
}

function makeCardVisible() {
  card.classList.remove("none");
}

function makeCardInvisible() {
  card.classList.add("none");
}

function clearButtonHandler() {
  userInputs[0].value = "";
  userInputs[1].value = "";
  userInputs[2].value = "Default";
  userInputs[3].value = "";
  userInputs[3].classList.remove("disable_section");
  userInputs[3].disabled = false;
  userInputs[4].checked = false;
  makeCardInvisible();
  makeTableInvisible();
}

function autoDetectCheckboxHandler() {
  if (autoDetectCheckbox.checked) {
    const locationInput = document.getElementById("locationInput");
    locationInput.classList.add("disable_section");
    locationInput.value = "";
    locationInput.disabled = true;
    console.log("Checkbox is checked.");
  } else {
    const locationInput = document.getElementById("locationInput");
    locationInput.classList.remove("disable_section");
    locationInput.disabled = false;
    console.log("Checkbox is not checked.");
  }
}

async function getLocation() {
  if (autoDetectCheckbox.checked === true) {
    const response = await axios.get(ipinfoApi);
    const loc = await response.data["loc"].split(",").map(function (item) {
      return parseFloat(item);
    });
    console.log(loc);
    return loc;
  } else {
    const locationInput = document.getElementById("locationInput").value;
    const params = {
      address: locationInput,
      key: "abcdefg",
    };
    const response = await axios.get(geoCodeApi, { params: params });
    console.log(response.data);
    if (response.data.status === "ZERO_RESULTS") {
      return null;
    }
    const loc = [
      response.data.results[0].geometry.location.lat,
      response.data.results[0].geometry.location.lng,
    ];
    console.log(loc);
    return loc;
  }
}

function removeAllChildNodes(parent) {
  while (parent.firstChild) {
    parent.removeChild(parent.firstChild);
  }
}

// Transform the content of given cell in given column
const transform = function (index, content) {
  // Get the data type of column
  const type = headers[index].getAttribute("data-type");
  switch (type) {
    case "number":
      return parseFloat(content);
    case "string":
    default:
      return content;
  }
};

const directions = Array.from(headers).map(function (header) {
  return "";
});

function sortColumn(index) {
  // Get the current direction
  const direction = directions[index] || "asc";

  // A factor based on the direction
  const multiplier = direction === "asc" ? 1 : -1;

  // Clone the rows
  const newRows = Array.from(rows);

  // Sort rows by the content of cells
  newRows.sort(function (rowA, rowB) {
    const cellA = rowA.querySelectorAll("td")[index + 2].innerHTML;
    const cellB = rowB.querySelectorAll("td")[index + 2].innerHTML;

    const a = transform(index, cellA);
    const b = transform(index, cellB);

    switch (true) {
      case a > b:
        return 1 * multiplier;
      case a < b:
        return -1 * multiplier;
      case a === b:
        return 0;
    }
  });

  // Remove old rows
  [].forEach.call(rows, function (row) {
    tableBody.removeChild(row);
  });

  directions[index] = direction === "asc" ? "desc" : "asc";

  let i = 1;
  // Append new row
  newRows.forEach(function (newRow) {
    newRow.querySelector(".no").textContent = i;
    i++;
    tableBody.appendChild(newRow);
  });
}

async function getBusinessDetails(id) {
  const response = await axios.get(businessDetailsApi, {
    params: {
      id: id,
    },
  });
  const responseData = await response.data;
  console.log(response.data);

  const statusDiv = document.getElementById("statusDiv");

  const categoryDiv = document.getElementById("categoryDiv");
  const addressDiv = document.getElementById("addressDiv");
  const phoneNumberDiv = document.getElementById("phoneNumberDiv");
  const transactionSupportedDiv = document.getElementById(
    "transactionSupportedDiv"
  );
  const priceDiv = document.getElementById("priceDiv");
  const yelpLinkDiv = document.getElementById("yelpLinkDiv");
  statusDiv.classList.add("none");
  categoryDiv.classList.add("none");
  addressDiv.classList.add("none");
  phoneNumberDiv.classList.add("none");
  transactionSupportedDiv.classList.add("none");
  priceDiv.classList.add("none");
  yelpLinkDiv.classList.add("none");

  document.getElementById("cardHeader").textContent = await responseData.name;
  if ((await responseData.hours) != undefined) {
    const isOpenNowData = await responseData.hours[0].is_open_now;
    const status = document.getElementById("status");
    if (isOpenNowData === true) {
      status.textContent = "Open Now";
      status.classList.remove("closed");
      status.classList.add("open");
    } else {
      status.textContent = "Closed";
      status.classList.remove("open");
      status.classList.add("closed");
    }
    if (status.textContent != "") {
      statusDiv.classList.remove("none");
    }
  }

  const category = document.getElementById("category");
  category.textContent = "";
  const categoriesData = await responseData.categories;
  const categoriesLength = categoriesData.length;
  for (let i = 0; i < categoriesLength - 1; i++) {
    category.textContent += categoriesData[i].title + " | ";
  }
  category.textContent += categoriesData[categoriesLength - 1].title;
  if (category.textContent != "") {
    categoryDiv.classList.remove("none");
  }

  const address = document.getElementById("address");
  address.textContent = await responseData.location.display_address;
  if (address.textContent != "") {
    addressDiv.classList.remove("none");
  }

  const phoneNumber = document.getElementById("phoneNumber");
  phoneNumber.textContent = await responseData.display_phone;
  if (phoneNumber.textContent != "") {
    phoneNumberDiv.classList.remove("none");
  }

  const transactionSupported = document.getElementById("transactionSupported");
  transactionSupported.textContent = "";
  const transactionsData = await responseData.transactions;
  const transactionsDataLength = transactionsData.length;
  if (transactionsDataLength > 0) {
    for (let i = 0; i < transactionsDataLength - 1; i++) {
      transactionSupported.textContent += transactionsData[i] + " | ";
    }
    transactionSupported.textContent +=
      transactionsData[transactionsDataLength - 1];
  }
  if (transactionSupported.textContent != "") {
    transactionSupportedDiv.classList.remove("none");
  }

  const price = document.getElementById("price");
  price.textContent = await responseData.price;
  if (price.textContent != "") {
    priceDiv.classList.remove("none");
  }

  const yelpLink = document.getElementById("yelpLink");
  yelpLink.href = await responseData.url;
  if (yelpLink.href != "") {
    yelpLinkDiv.classList.remove("none");
  }

  const pictures = document.querySelectorAll(".picture");
  const pictureContainers = document.querySelectorAll(".pictureContainer");
  for (let i = 0; i < 3; i++) {
    pictures[i].src = "";
    pictureContainers[i].classList.add("none");
  }

  const pictureURLs = await responseData.photos;
  const pictureURLsLength = pictureURLs.length;
  for (let i = 0; i < pictureURLsLength; i++) {
    pictures[i].src = pictureURLs[i];
    pictureContainers[i].classList.remove("none");
  }

  makeCardVisible();
  card.scrollIntoView();
}

async function submitButtonHandler() {
  makeCardInvisible();
  const term = userInputs[0].value;
  console.log(userInputs[1].value);
  let radius = 10 * 1609;
  if (userInputs[1].value != "") {
    radius = userInputs[1].value * 1609;
  }

  console.log("radius: ", radius);

  const categoriesInput = userInputs[2].value;
  let categories = "all";
  if (categoriesInput === "Arts & Entertainment") {
    categories = "arts";
  } else if (categoriesInput === "Health & Medical") {
    categories = "health";
  } else if (categoriesInput === "Hotels & Travel") {
    categories = "hotelstravel";
  } else if (categoriesInput === "Food") {
    categories = "food";
  } else if (categoriesInput === "Professional Services") {
    categories = "professional";
  }

  const location = userInputs[3].value;
  if (term !== "" && (location !== "" || autoDetectCheckbox.checked === true)) {
    try {
      console.log("radius: ", radius);
      const loc = await getLocation();
      if (loc == null) {
        noRecordMessage.classList.remove("none");
        makeCardInvisible();
        makeTableInvisible();
        return;
      }
      const latitude = await loc[0];
      const longitude = await loc[1];
      const response = await axios.get(businessSearchApi, {
        params: {
          term: term,
          categories: categories,
          latitude: latitude,
          longitude: longitude,
          radius: radius,
        },
      });
      removeAllChildNodes(listElement);
      const listOfPosts = response.data.businesses;
      if (typeof listOfPosts === "undefined" || listOfPosts.length === 0) {
        noRecordMessage.classList.remove("none");
        makeCardInvisible();
        makeTableInvisible();
      } else {
        noRecordMessage.classList.add("none");
        let i = 1;
        for (const post of listOfPosts) {
          const postEl = document.importNode(postTemplate.content, true);
          console.log(postEl.childNodes[1]);
          // console.log(post.name);
          postEl.childNodes[1].querySelector(".no").textContent = i;
          i++;
          postEl.childNodes[1].querySelector(
            ".image"
          ).innerHTML = `<img src=${post.image_url} alt='hello' class='imageContent'/>`;
          const businessName =
            postEl.childNodes[1].querySelector(".businessName");
          businessName.innerHTML = `<a href="#card" class="cardLink">${post.name}</a>`;
          businessName
            .querySelector("a")
            .addEventListener("click", getBusinessDetails.bind(null, post.id));
          postEl.childNodes[1].querySelector(".rating").textContent =
            post.rating;
          postEl.childNodes[1].querySelector(".distance").textContent = (
            post.distance / 1609
          ).toFixed(2);
          listElement.append(postEl);
          // console.log(post);
        }
        makeTableVisible();
        table.scrollIntoView();

        rows = tableBody.querySelectorAll("tr");
      }
    } catch (error) {
      alert(error.message);
    }
  }
}

submitButton.addEventListener("click", submitButtonHandler);

clearButton.addEventListener("click", clearButtonHandler);

// clearButton.addEventListener("click", clearButtonHandler);

autoDetectCheckbox.addEventListener("change", autoDetectCheckboxHandler);

// console.log(autoDetectCheckbox);
// console.log(submitButton);
// console.log(clearButton);
// console.log(userInputs);
