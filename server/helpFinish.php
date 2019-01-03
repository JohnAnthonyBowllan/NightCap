<?php
/*
This file is called when a user has a done.txt file in their folder.
*/
$user = $_GET['user'];
$rqno = $_GET['rqno'];

if (isset($user) && isset($rqno)) {

  if (file_exists("../phpdata/" . $user . "/done.txt")) {

     unlink("../phpdata/" . $user . "/done.txt");

  }

  echo "AK " . $rqno . "|";

}

?>
