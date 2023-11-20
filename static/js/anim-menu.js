function hideElements(elements) {
  for (var i = 0; i < elements.length; i++) {
    elements[i].style.display = 'none';
  }
}
function showElements(elements) {
  for (var i = 0; i < elements.length; i++) {
    elements[i].style.display = 'block';
  }
}
document.addEventListener('DOMContentLoaded', function () {
  setTimeout(function () {
    clickSocial();
  }, 10);
});
function clickSocial() {
    var menuanterior = [social, develop, tasksandguides, forum, design, bootcamp, aboutme];
    var menuatual = [social1, social2, social3, professionalnetworks, socialcircles];

    if (social.style.display === 'block') {
      hideElements(menuanterior);
      showElements(menuatual);
    }
    else {
      hideElements(menuatual);
      showElements(menuanterior);
    }
  }
