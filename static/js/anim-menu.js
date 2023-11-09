  function toggleDisplay(element, displayValue) {
    element.style.display = element.style.display === displayValue ? 'none' : displayValue;
  }

  function resetDisplay(elements) {
    elements.forEach(function (element) {
      element.style.display = 'none';
    });
  }

  function showElements(elements) {
    elements.forEach(function (element) {
      element.style.display = 'block';
    });
  }

  function hideElements(elements) {
    elements.forEach(function (element) {
      element.style.display = 'none';
    });
  }

  function clickSocial() {
    toggleDisplay(menusocial, 'block');
    resetDisplay([menuforum, menudevelop, menudesign, menutasksandguides, menubootcamp, menuaboutme]);

    if (menusocial.style.display === 'block') {
      hideElements([social, forum, develop, tasksandguides, design, bootcamp, aboutme]);
      showElements([social1, social2, social3]);
    } else {
      showElements([social, forum, develop, tasksandguides, design, bootcamp, aboutme]);
      hideElements([social1, social2, social3]);
    }

    if (social1.style.display === 'block') {
      hideElements([social, forum, develop, design, tasksandguides, bootcamp, aboutme]);
      showElements([social1, social2, social3]);
    } else {
      showElements([social, forum, develop, design, tasksandguides, bootcamp, aboutme]);
      hideElements([social1, social2, social3]);
    }
  }

  function clickForum() {
    toggleDisplay(menuforum, 'block');
    resetDisplay([menusocial, menudevelop, menudesign, menutasksandguides, menubootcamp, menuaboutme]);

    if (menuforum.style.display === 'block') {
      hideElements([social, develop, design, tasksandguides, bootcamp, aboutme]);
      showElements([forum, forum1, forum2, forum3]);
    } else {
      showElements([social, develop, design, tasksandguides, forum, bootcamp, aboutme]);
      hideElements([forum1, forum2, forum3]);
    }

    if (forum1.style.display === 'block') {
      hideElements([social, forum, develop, design, tasksandguides, bootcamp, aboutme]);
      showElements([forum1, forum2, forum3]);
    } else {
      showElements([social, forum, develop, design, tasksandguides, bootcamp, aboutme]);
      hideElements([forum1, forum2, forum3]);
    }
  }

  function clickDevelop() {
    toggleDisplay(menudevelop, 'block');
    resetDisplay([menusocial, menuforum, menudesign, menutasksandguides, menubootcamp, menuaboutme]);

    if (menudevelop.style.display === 'block') {
      hideElements([social, forum, design, tasksandguides, bootcamp, aboutme]);
      showElements([develop, develop1, develop2, develop3]);
    } else {
      showElements([social, forum, design, tasksandguides, develop, bootcamp, aboutme]);
      hideElements([develop1, develop2, develop3]);
    }

    if (develop1.style.display === 'block') {
      hideElements([social, forum, develop, design, tasksandguides, bootcamp, aboutme]);
      showElements([develop1, develop2, develop3]);
    } else {
      showElements([social, forum, develop, design, tasksandguides, bootcamp, aboutme]);
      hideElements([develop1, develop2, develop3]);
    }
  }

  function clickDesign() {
    toggleDisplay(menudesign, 'block');
    resetDisplay([menusocial, menuforum, menudevelop, menutasksandguides, menubootcamp, menuaboutme]);

    if (menudesign.style.display === 'block') {
      hideElements([social, forum, develop, tasksandguides, bootcamp, aboutme]);
      showElements([design, design1, design2, design3]);
    } else {
      showElements([social, forum, develop, tasksandguides, design, bootcamp, aboutme]);
      hideElements([design1, design2, design3]);
    }

    if (design1.style.display === 'block') {
      hideElements([social, forum, develop, design, tasksandguides, bootcamp, aboutme]);
      showElements([design1, design2, design3]);
    } else {
      showElements([social, forum, develop, design, tasksandguides, bootcamp, aboutme]);
      hideElements([design1, design2, design3]);
    }
  }

  function clickTasksandguides() {
    toggleDisplay(menutasksandguides, 'block');
    resetDisplay([menusocial, menuforum, menudevelop, menudesign, menubootcamp, menuaboutme]);

    if (menutasksandguides.style.display === 'block') {
      hideElements([social, forum, develop, design, bootcamp, aboutme]);
      showElements([tasksandguides, tasksandguides1, tasksandguides2, tasksandguides3]);
    } else {
      showElements([social, forum, develop, design, tasksandguides, bootcamp, aboutme]);
      hideElements([tasksandguides1, tasksandguides2, tasksandguides3]);
    }

    if (tasksandguides1.style.display === 'block') {
      hideElements([social, forum, develop, tasksandguides, bootcamp, aboutme]);
      showElements([tasksandguides1, tasksandguides2, tasksandguides3]);
    } else {
      showElements([social, forum, develop, tasksandguides, bootcamp, aboutme]);
      hideElements([tasksandguides1, tasksandguides2, tasksandguides3]);
    }
  }

  function clickBootcamp() {
    toggleDisplay(menubootcamp, 'block');
    resetDisplay([menusocial, menuforum, menudevelop, menudesign, menutasksandguides, menuaboutme]);

    if (menubootcamp.style.display === 'block') {
      hideElements([social, forum, develop, design, tasksandguides, bootcamp, aboutme]);
      showElements([bootcamp, bootcamp1, bootcamp2, bootcamp3]);
    } else {
      showElements([social, forum, develop, design, tasksandguides, bootcamp, aboutme]);
      hideElements([bootcamp1, bootcamp2, bootcamp3]);
    }

    if (bootcamp1.style.display === 'block') {
      hideElements([social, forum, develop, tasksandguides, bootcamp, aboutme]);
      showElements([bootcamp1, bootcamp2, bootcamp3]);
    } else {
      showElements([social, forum, develop, tasksandguides, bootcamp, aboutme]);
      hideElements([bootcamp1, bootcamp2, bootcamp3]);
    }
  }

  function clickAboutme() {
    toggleDisplay(menuaboutme, 'block');
    resetDisplay([menubootcamp, menusocial, menuforum, menudevelop, menudesign, menutasksandguides]);

    if (menuaboutme.style.display === 'block') {
      hideElements([social, forum, develop, design, tasksandguides, bootcamp, aboutme]);
      showElements([aboutme, aboutme1, aboutme2, aboutme3]);
    } else {
      showElements([social, forum, develop, design, tasksandguides, bootcamp, aboutme]);
      hideElements([aboutme1, aboutme2, aboutme3]);
    }

    if (aboutme1.style.display === 'block') {
      hideElements([social, forum, develop, tasksandguides, bootcamp, aboutme]);
      showElements([aboutme1, aboutme2, aboutme3]);
    } else {
      showElements([social, forum, develop, tasksandguides, bootcamp, aboutme]);
      hideElements([aboutme1, aboutme2, aboutme3]);
    }
  }