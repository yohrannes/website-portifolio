document.addEventListener("DOMContentLoaded", function() {
    var social = document.getElementById("social");
    var social1 = document.getElementById("social1");
    var social2 = document.getElementById("social2");
    var social3 = document.getElementById("social3");

    social.addEventListener("click", function() {

        if (social.style.display === "block") {

            social1.style.display = "block";
            social2.style.display = "block";
            social3.style.display = "block";
            social.style.display = "none";
        }
        else {
            social1.style.display = "none";
            social2.style.display = "none";
            social3.style.display = "none";
            social.style.display = "block";
        }
    });

    social1.addEventListener("click", function() {

        if (social1.style.display === "block") {

            social1.style.display = "none";
            social2.style.display = "none";
            social3.style.display = "none";
            social.style.display = "block";
        }
        else {
            social1.style.display = "block";
            social2.style.display = "block";
            social3.style.display = "block";
            social.style.display = "none"
        }
    });
});
