<html>
<body>

<?php
$to = "cy@cynonymous.com";
$subject = $_REQUEST['subject'];
$email = $_REQUEST['email'];
$message = $_REQUEST['message'];
$headers = "From: $email";
$sent = mail($to, $subject, $message, $headers);
print('<a href="/contact/">Thank you for your email. Click here to return to the previous page.</a>');
?>

</body>
<html>