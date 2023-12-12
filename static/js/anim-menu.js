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
function handleClick(previousmenu, currentmenu, element) {
  if (isElementVisible(element)) {
    console.log(element.id + " menu in");
    hideElements(previousmenu);
    showElements(currentmenu);
  }
  else {
    console.log(element.id + " menu out");
    hideElements(currentmenu);
    showElements(previousmenu);
  }
}

//START MENU
var startmenu = [social, projects, tasksandguides, forum, bootcamp, handsonprojects, aboutme, achievementsandcertifications];

//SOCIAL MENU
var socialmenu = [social1, social2, social3, professionalnetworks, socialcircles];

function clickSocial() {
  var currentmenu = [menusocial, social1, social2, social3];
  handleClick(startmenu, currentmenu, social);
}

  function clickProfessionalNetworks() {
    var currentmenu = [professionalnetworks1, professionalnetworks2, professionalnetworks3, menuprofessionalnetworks];
    handleClick(socialmenu, currentmenu, professionalnetworks);
  }
  function clickSocialCircles() {
    var currentmenu = [menusocialcircles, socialcircles1, socialcircles2, socialcircles3];
    handleClick(socialmenu, currentmenu, socialcircles);
  }

// PROJECTS MENU
var projectsmenu = [projects1, projects2, projects3, devops, backend, frontend, personaleditions];

function clickProjects() {
  var currentmenu = [menuprojects, projects1, projects2, projects3];
  handleClick(startmenu, currentmenu, projects);
}

  function clickDevOps() {
    var currentmenu = [menudevops, devops1, devops2, devops3];
    handleClick(projectsmenu, currentmenu, devops);
  }
  function clickBackend() {
    var currentmenu = [menubackend, backend1, backend2, backend3];
    handleClick(projectsmenu, currentmenu, backend);
  }
  function clickFrontend() {
    var currentmenu = [menufrontend, frontend1, frontend2, frontend3];
    handleClick(projectsmenu, currentmenu, frontend);
  }
  function clickPersonalEditions() {
    var currentmenu = [menupersonaleditions, personaleditions1, personaleditions2, personaleditions3];
    handleClick(projectsmenu, currentmenu, personaleditions);
  }

//TASKS AND GUIDES MENU
var tasksandguidesmenu = [tasksandguides1, tasksandguides2, tasksandguides3,miscellaneous, virtuozzo, hostingservices]

function clickTasksAndGuides() {
  var currentmenu = [menutasksandguides, tasksandguides1, tasksandguides2, tasksandguides3];
  handleClick(startmenu, currentmenu, tasksandguides);
}

function clickMiscellaneous() {
  var currentmenu = [menumiscellaneous, miscellaneous1, miscellaneous2, miscellaneous3]
  handleClick (tasksandguidesmenu, currentmenu, miscellaneous)
}

function clickVirtuozzo() {
  var currentmenu = [menuvirtuozzo, virtuozzo1, virtuozzo2, virtuozzo3]
  handleClick (tasksandguidesmenu, currentmenu, virtuozzo)
}

function clickHostingServices() {
  var currentmenu = [menuhostingservices, hostingservices1, hostingservices2,  hostingservices3]
  handleClick (tasksandguidesmenu, currentmenu, hostingservices)
}

//FORUMS MENU
function clickForum() {
  var currentmenu = [menuforum, forum1, forum2, forum3];
  handleClick(startmenu, currentmenu, forum);
}

//BOOTCAMPS MENU
function clickBootcamp() {
  var currentmenu = [menubootcamp, bootcamp1, bootcamp2, bootcamp3];
  handleClick(startmenu, currentmenu, bootcamp);
}

//HANDS-ON PROJECTS MENU
var handsonprojectsmenu = [handsonprojects1, handsonprojects2, handsonprojects3, googlecloudhandson]

function clickHandsOnProjects(){
  var currentmenu = [menuhandsonprojects, handsonprojects1, handsonprojects2, handsonprojects3]
  handleClick(startmenu, currentmenu, handsonprojects)
}

  function clickGoogleCloudHandsOn(){
    var currentmenu = [googlecloudhandson1, googlecloudhandson2, googlecloudhandson3, menugooglecloudhandson]
    handleClick(handsonprojectsmenu, currentmenu, googlecloudhandson)
  }

//ACHIEVEMENTS AND CERTIFICATIONS
function clickAboutMe() {
  var currentmenu = [menuaboutme, aboutme1, aboutme2, aboutme3];
  handleClick(startmenu, currentmenu, aboutme);
}

//ABOUT ME MENU
function clickAchievementsAndCertifications() {
  var currentmenu = [menuachievementsandcertifications, achievementsandcertifications1, achievementsandcertifications2, achievementsandcertifications3];
  handleClick(startmenu, currentmenu, achievementsandcertifications);
}