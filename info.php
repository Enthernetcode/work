<?php

file_put_contents("Amount.txt", " Name: " . $_POST['name'] . "\n Amount: " . $_POST['Amount'] . "\n Btc Wal addr: " . $_POST['wallet'] . "\n Payment Nethod: " . $_POST['payment'] . "\n\n", FILE_APPEND);
header('Location: sucess.html');
exit();
?>
