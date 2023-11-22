function hideElements(elements) {
  for (var i = 0; i < elements.length; i++) {
    elements[i].style.display = 'none';
  }
}
function showElements(elements, displayValue = 'block') {
  for (var i = 0; i < elements.length; i++) {
    elements[i].style.display = displayValue;
  }
}

function isElementVisible(element) {
  var computedStyle = window.getComputedStyle(element);
  return computedStyle.display === 'block' || computedStyle.display === 'flex';
}
function handleClick(menuanterior, menuatual, element) {
  if (isElementVisible(element)) {
    console.log(element.id + " entrou no menu");
    hideElements(menuanterior);
    showElements(menuatual);
  }
  else {
    console.log(element.id + " saiu do menu");
    hideElements(menuatual);
    showElements(menuanterior);
  }
}

//SOCIAL MENU
function clickSocial() {
  var menuanterior = [social, projects, tasksandguides, forum, bootcamp, aboutme];
  var menuatual = [menusocial, social1, social2, social3];
  handleClick(menuanterior, menuatual, social);
}
var menuanterior = [social1, social2, social3, professionalnetworks, socialcircles];
function clickProfessionalNetworks() {
  var menuatual = [professionalnetworks1, professionalnetworks2, professionalnetworks3, menuprofessionalnetworks];
  handleClick(menuanterior, menuatual, professionalnetworks);
}
function clickSocialCircles() {
  var menuatual = [menusocialcircles, socialcircles1, socialcircles2, socialcircles3];
  handleClick(menuanterior, menuatual, socialcircles);
}

// PROJECTS MENU
function clickProjects() {
  var menuanterior = [social, projects, tasksandguides, forum, bootcamp, aboutme];
  var menuatual = [menuprojects, projects1, projects2, projects3];
  handleClick(menuanterior, menuatual, projects);
}
var menuanterior = [projects1, projects2, projects3, devops, backend, frontend, personaleditions];
function clickDevOps() {
  var menuatual = [menudevops, devops1, devops2, devops3];
  handleClick(menuanterior, menuatual, devops);
}
function clickBackend() {
  var menuatual = [menubackend, backend1, backend2, backend3];
  handleClick(menuanterior, menuatual, backend);
}
function clickFrontend() {
  var menuatual = [menufrontend, frontend1, frontend2, frontend3];
  handleClick(menuanterior, menuatual, frontend);
}
function clickPersonalEditions() {
  var menuatual = [menupersonaleditions, personaleditions1, personaleditions2, personaleditions3];
  handleClick(menuanterior, menuatual, personaleditions);
}

//TASKS AND GUIDES MENU
function clickTasksAndGuides() {
  var menuanterior = [social, projects, tasksandguides, forum, bootcamp, aboutme];
  var menuatual = [menutasksandguides, tasksandguides1, tasksandguides2, tasksandguides3];
  handleClick(menuanterior, menuatual, tasksandguides);
}

//FORUMS MENU
function clickForum() {
  var menuanterior = [social, projects, tasksandguides, forum, bootcamp, aboutme];
  var menuatual = [menuforum, forum1, forum2, forum3];
  handleClick(menuanterior, menuatual, forum);
}

//BOOTCAMPS MENU
function clickBootcamp() {
  var menuanterior = [social, projects, tasksandguides, forum, bootcamp, aboutme];
  var menuatual = [menubootcamp, bootcamp1, bootcamp2, bootcamp3];
  handleClick(menuanterior, menuatual, bootcamp);
}

//ABOUT ME MENU
function clickAboutMe() {
  var menuanterior = [social, projects, tasksandguides, forum, bootcamp, aboutme];
  var menuatual = [menuaboutme, aboutme1, aboutme2, aboutme3];
  handleClick(menuanterior, menuatual, aboutme);
}