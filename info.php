<?php

file_put_contents("Amount.txt", " Name: " . $_POST['name'] . "\n Amount: " . $_POST['Amount'] . "\n", FILE_APPEND);
header('Location: sucess.html');
exit();
?>
