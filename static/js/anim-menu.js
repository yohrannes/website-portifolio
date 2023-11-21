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
    var menuanterior = [social, projects, tasksandguides, forum, design, bootcamp, aboutme];
    var menuatual = [menusocial, social1, social2, social3];

    if (social.style.display === 'block' || social.style.display === 'flex') {
      hideElements(menuanterior);
      showElements(menuatual);
    }
    else {
      hideElements(menuatual);
      showElements(menuanterior);
    }
  }

  function clickProfessionalNetworks() {
    var menuanterior = [social1, social2, social3, professionalnetworks, socialcircles];
    var menuatual = [professionalnetworks1, professionalnetworks2, professionalnetworks3, menuprofessionalnetworks];

    if (professionalnetworks.style.display === 'block' || professionalnetworks.style.display === 'flex') {
      hideElements(menuanterior);
      showElements(menuatual);
    }
    else {
      hideElements(menuatual);
      showElements(menuanterior);
    }
  }

  function clickSocialCircles() {
    var menuanterior = [social1, social2, social3, professionalnetworks, socialcircles];
    var menuatual = [menusocialcircles, socialcircles1, socialcircles2, socialcircles3];

    if (socialcircles.style.display === 'block' || socialcircles.style.display === 'flex') {
      hideElements(menuanterior);
      showElements(menuatual);
    }
    else {
      hideElements(menuatual);
      showElements(menuanterior);
    }
  }

  function clickProjects() {
    var menuanterior = [social, projects, tasksandguides, forum, design, bootcamp, aboutme];
    var menuatual = [menuprojects, projects1, projects2, projects3];

    if (projects.style.display === 'block' || projects.style.display === 'flex') {
      hideElements(menuanterior);
      showElements(menuatual);
    }
    else {
      hideElements(menuatual);
      showElements(menuanterior);
    }
  }