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

//FIRST MENU
var startmenu = [social, projects, tasksandguides, bootcamp, handsonprojects, aboutme, achievementsandcertifications];

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
var tasksandguidesmenu = [tasksandguides1, tasksandguides2, tasksandguides3, kubernetes, vpsnetwork, hostingservices, databases, webservers, miscellaneous]

function clickTasksAndGuides() {
  var currentmenu = [menutasksandguides, tasksandguides1, tasksandguides2, tasksandguides3];
  handleClick(startmenu, currentmenu, tasksandguides);
}

function clickKubernetes() {
  var currentmenu = [menukubernetes, kubernetes1, kubernetes2, kubernetes3]
  handleClick (tasksandguidesmenu, currentmenu, kubernetes)
}

function clickVpsnetwork() {
  var currentmenu = [menuvpsnetwork, vpsnetwork1, vpsnetwork2, vpsnetwork3]
  handleClick (tasksandguidesmenu, currentmenu, vpsnetwork)
}

function clickHostingServices() {
  var currentmenu = [menuhostingservices, hostingservices1, hostingservices2, hostingservices3];
  handleClick (tasksandguidesmenu, currentmenu, hostingservices);
}

function clickDatabases() {
  var currentmenu = [menudatabases, databases1, databases2, databases3]
  handleClick (tasksandguidesmenu, currentmenu, databases)
}

function clickWebservers() {
  var currentmenu = [menuwebservers, webservers1, webservers2, webservers3]
  handleClick (tasksandguidesmenu, currentmenu, webservers)
}

function clickMiscellaneous() {
  var currentmenu = [menumiscellaneous, miscellaneous1, miscellaneous2, miscellaneous3]
  handleClick (tasksandguidesmenu, currentmenu, miscellaneous)
}

//BOOTCAMPS MENU
function clickBootcamp() {
  var currentmenu = [menubootcamp, bootcamp1, bootcamp2, bootcamp3];
  handleClick(startmenu, currentmenu, bootcamp);
}

//HANDS-ON PROJECTS MENU
var handsonprojectsmenu = [handsonprojects1, handsonprojects2, handsonprojects3, googlecloudhandson, oraclecloudhandson]

function clickHandsOnProjects(){
  var currentmenu = [menuhandsonprojects, handsonprojects1, handsonprojects2, handsonprojects3];
  handleClick(startmenu, currentmenu, handsonprojects);
}

  function clickGoogleCloudHandsOn(){
    var currentmenu = [googlecloudhandson1, googlecloudhandson2, googlecloudhandson3, menugooglecloudhandson];
    handleClick(handsonprojectsmenu, currentmenu, googlecloudhandson);
  }

  function clickOracleCloudHandsOn(){
    var currentmenu = [oraclecloudhandson1, oraclecloudhandson2, oraclecloudhandson3, menuoraclecloudhandson]
    handleClick(handsonprojectsmenu, currentmenu, oraclecloudhandson)
  }

//ACHIEVEMENTS AND CERTIFICATIONS
var achievementsandcertificationsmenu = [achievementsandcertifications1, achievementsandcertifications2, achievementsandcertifications3, gcpcert, devcert, devopscicdcert, k8sdockercert, monitoringcert]

function clickAchievementsAndCertifications() {
  var currentmenu = [menuachievementsandcertifications, achievementsandcertifications1, achievementsandcertifications2, achievementsandcertifications3];
  handleClick(startmenu, currentmenu, achievementsandcertifications);
}
  
  function clickGcpCert(){
  var currentmenu = [googlecloudcertifications1, googlecloudcertifications2, googlecloudcertifications3,  menugooglecloudcertifications];
  handleClick(achievementsandcertificationsmenu, currentmenu, gcpcert);
  }

  function clickDevCert(){
  var currentmenu = [developmentcertifications1, developmentcertifications2, developmentcertifications3,  menudevelopmentcertifications];
  handleClick(achievementsandcertificationsmenu, currentmenu, devcert);
  }

  function clickDvOpCiCdCert(){
  var currentmenu = [devopscicdcertifications1, devopscicdcertifications2, devopscicdcertifications3,  menudevopscicdcertifications];
  handleClick(achievementsandcertificationsmenu, currentmenu, devopscicdcert);
  }

  function clickK8sDockerCert(){
  var currentmenu = [kubernetesdockercertifications1, kubernetesdockercertifications2, kubernetesdockercertifications3,  menukubernetesdockercertifications];
  handleClick(achievementsandcertificationsmenu, currentmenu, k8sdockercert);
  }

  function clickMonitCert(){
    var currentmenu = [monitoringcertifications1, monitoringcertifications2, monitoringcertifications3, menumonitoringcertifications];
    handleClick(achievementsandcertificationsmenu, currentmenu, monitoringcert);
  }
  
//ABOUT ME MENU
function clickAboutMe() {
  var currentmenu = [menuaboutme, aboutme1, aboutme2, aboutme3];
  handleClick(startmenu, currentmenu, aboutme);
}
  
  