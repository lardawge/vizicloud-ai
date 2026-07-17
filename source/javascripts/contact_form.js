// Vizicloud contact form — vanilla JS AJAX submission handler.
// Replace YOUR_FORM_ID below with a real Formspree form id.
(function () {
  "use strict";

  var FORMSPREE_ENDPOINT = "https://formspree.io/f/YOUR_FORM_ID";

  var form = document.getElementById("contact-form");
  if (!form) return;

  var submitButton = document.getElementById("cf-submit");
  var errorEl = document.getElementById("cf-error");
  var successEl = document.getElementById("cf-success");
  var turnstileToken = null;

  // Called by the Turnstile widget via data-callback once a challenge is solved.
  window.onTurnstileSuccess = function (token) {
    turnstileToken = token;
    submitButton.disabled = false;
  };

  function resetTurnstile() {
    turnstileToken = null;
    submitButton.disabled = true;
    if (window.turnstile) {
      window.turnstile.reset();
    }
  }

  function showError(message) {
    errorEl.textContent = message;
    errorEl.classList.remove("hidden");
  }

  function hideError() {
    errorEl.classList.add("hidden");
    errorEl.textContent = "";
  }

  form.addEventListener("submit", function (event) {
    event.preventDefault();

    if (!turnstileToken) {
      showError("Please complete the challenge above before submitting.");
      return;
    }

    hideError();
    submitButton.disabled = true;
    submitButton.textContent = "Sending…";

    var formData = new FormData(form);

    fetch(FORMSPREE_ENDPOINT, {
      method: "POST",
      headers: { Accept: "application/json" },
      body: formData
    })
      .then(function (response) {
        if (response.ok) {
          form.classList.add("hidden");
          successEl.classList.remove("hidden");
          resetTurnstile();
          if (window.sa_event) {
            window.sa_event("booking_completed");
          }
        } else {
          return response.json().then(function () {
            throw new Error("submission_failed");
          });
        }
      })
      .catch(function () {
        showError("Something went wrong sending your message. Please try again.");
        submitButton.textContent = "Send Inquiry";
        resetTurnstile();
      });
  });
})();
