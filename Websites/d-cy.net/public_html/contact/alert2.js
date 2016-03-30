//Contact Form Alerts2

function validateForm() {
    var x = document.forms["contactForm"]["subject"].value;
    if (x == null || x == "") {
        alert("Name must be filled out");
        return false;
    }
}