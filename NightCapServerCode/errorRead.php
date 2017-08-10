<?php
$errors = file("../apache/logs/error.log", FILE_IGNORE_NEW_LINES);

for ($i = 0; $i < count($errors); ++$i) {

  echo $errors[$i] . "||||||||||||||||||";

}




?>
