function resetForm() {
  "use strict";

  // Fetch all the forms we want to apply custom Bootstrap validation styles to
  var forms = document.querySelectorAll(".needs-validation");
  const reservationFormModal = document.getElementById("reservationFormModal");
  const modal = bootstrap.Modal.getInstance(reservationFormModal);

  modal.hide();
  // Loop over them and prevent submission
  Array.prototype.slice.call(forms).forEach(function (form) {
    form.classList.remove("was-validated");
    form.reset();
  });
}
