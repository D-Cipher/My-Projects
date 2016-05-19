//Contact Form Alerts

function validateForm() {
    var eml = document.forms["contactForm"]["email"].value
    var subj = document.forms["contactForm"]["subject"].value;
    var msg = document.getElementById("msgField").value;

    var atpos = eml.indexOf("@");
    var dotpos = eml.lastIndexOf(".");

    if (subj === null || subj === "" || msg === "") {
        alert("Subject and message fields must be filled out.");
        return false;

    } else if (atpos < 1 || dotpos < atpos + 2 || dotpos + 2 > eml.length) {
        alert("Please enter a valid email.")
        return false;

    } else {
        if (confirm("Are you sure you want to send this email?")) {
            //alert("Email sent!")
            return true;

        } else {
            return false;
        }
    }
}