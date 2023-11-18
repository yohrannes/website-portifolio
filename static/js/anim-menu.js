function toggleDisplay(element, displayValue) {
    element.style.display = element.style.display === displayValue ? 'none' : displayValue;
  }
///bora tentaar arrumar esta bagaça que eu não faço ideia de como resolver mas tamo aí ne.....uma hora agente consegue..
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
    toggleDisplay(social, 'block');
    resetDisplay([menuforum, menudevelop, menudesign, menutasksandguides, menubootcamp, menuaboutme]);

    if (social.style.display === 'block') {
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