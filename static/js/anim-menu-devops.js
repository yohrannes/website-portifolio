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
var startmenu = [plan, code, build, test, release, operate, deploy, monitor];

//PLAN MENU
var planmenu = [plan1, plan2, plan3, professionalnetworks, socialcircles];

function clickPlan() {
  var currentmenu = [menuplan, plan1, plan2, plan3];
  handleClick(startmenu, currentmenu, plan);
}

// CODE MENU
var codemenu = [code1, code2, code3, devops, backend, frontend, personaleditions];

function clickCode() {
  var currentmenu = [menucode, code1, code2, code3];
  handleClick(startmenu, currentmenu, code);
}

//BUILD MENU
var buildmenu = [build1, build2, build3, kubernetes, vpsnetwork, hostingservices, databases, miscellaneous]

//TEST MENU
function clickTest() {
  var currentmenu = [menutest, test1, test2, test3];
  handleClick(startmenu, currentmenu, test);
}

//RELEASE MENU
var releasemenu = [release1, release2, release3, googlecloudhandson, oraclecloudhandson]

function clickRelease(){
  var currentmenu = [menurelease, release1, release2, release3]
  handleClick(startmenu, currentmenu, release)
}

//DEPLOY MENU
function clickDeploy() {
  var currentmenu = [menudeploy, deploy1, deploy2, deploy3];
  handleClick(startmenu, currentmenu, deploy);
}

//OPERATE MENU
function clickOperate() {
  var currentmenu = [menuoperate, operate1, operate2, operate3];
  handleClick(startmenu, currentmenu, operate);
}

//MONITOR MENU
function clickMonitor() {
  var currentmenu = [menumonitor, monitor1, monitor2, monitor3];
  handleClick(startmenu, currentmenu, monitor);
}