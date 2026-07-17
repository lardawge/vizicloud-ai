// Fires the section_view_fit analytics event once per session when #fit
// (the self-qualification section) is at least 50% visible (spec §6).
(function () {
  "use strict";

  var SESSION_KEY = "sa_section_view_fit_fired";

  var target = document.getElementById("fit");
  if (!target || !window.IntersectionObserver) return;
  if (sessionStorage.getItem(SESSION_KEY)) return;

  var observer = new IntersectionObserver(
    function (entries) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) {
          if (window.sa_event) {
            window.sa_event("section_view_fit");
          }
          sessionStorage.setItem(SESSION_KEY, "1");
          observer.disconnect();
        }
      });
    },
    { threshold: 0.5 }
  );

  observer.observe(target);
})();
