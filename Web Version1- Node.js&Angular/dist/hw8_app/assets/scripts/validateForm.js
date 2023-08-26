// Example starter JavaScript for disabling form submissions if there are invalid fields
(function () {
  "use strict";

  var today = new Date().toISOString().split("T")[0];
  console.log(today);
  document.getElementById("date").setAttribute("min", today);

  // Fetch all the forms we want to apply custom Bootstrap validation styles to
  var forms = document.querySelectorAll(".needs-validation");

  // Loop over them and prevent submission
  Array.prototype.slice.call(forms).forEach(function (form) {
    form.addEventListener(
      "submit",
      function (event) {
        if (!form.checkValidity()) {
          event.preventDefault();
          event.stopPropagation();
          form.classList.add("was-validated");
        } else {
          const reservationFormModal = document.getElementById(
            "reservationFormModal"
          );
          const modal = bootstrap.Modal.getInstance(reservationFormModal);
          window.alert("Reservation created!");
          modal.hide();
          resetForm();
        }
      },
      false
    );
  });
  console.log(forms);
})();
