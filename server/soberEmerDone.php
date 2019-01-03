<?php
/*
This file is called when a sober helper decides that their request is in a
good position and ends the help session. It removes all the necessary files and
resets the message number. Creates a done file for the other user to end their
session as well.
*/
$user = $_GET['user'];
$rqno = $_GET['rqno'];

if (isset($user) && isset($rqno)) {

   $helpee = "";
   if (file_exists("../phpdata/" . $user . "/helping.txt")) {

      $name = file("../phpdata/" . $user . "/helping.txt", FILE_IGNORE_NEW_LINES);
      $helpee .= $name[0];
      unlink("../phpdata/" . $user . "/helping.txt");

    }

   if (file_exists("../phpdata/" . $helpee . "/helper.txt")) {

      unlink("../phpdata/" . $helpee . "/helper.txt");

   }


   #Update the message numbers
   file_put_contents("../phpdata/" . $user . "/messages/number.txt", "1");

   if (strlen($helpee) != 0) {
      file_put_contents("../phpdata/" . $helpee . "/messages/number.txt", "1");
   }



   $messages = scandir("../phpdata/" . $user . "/" . "messages/");

   #Delete all message text files and reset the number.txt to 1
   for ($j = 0; $j < count($messages); ++$j) {

      if (substr($messages[$j],-4)!=".txt") continue;
      if (strcmp($messages[$j], "number.txt") != 0) {

         unlink("../phpdata/" . $user . "/" . "messages/" . $messages[$j]);

      }

   }



   #Creates done.txt to assist in ending the session (coordinated with update.php and helpFInish.php)
   if (strlen($helpee) != 0 && (time()-filemtime("../phpdata/" . $helpee . "/loc.txt") < 5)) {
      $dntag = "../phpdata/" . $helpee . "/done.txt";
      $dnfile = fopen($dntag, "w") or die("ER FileOpenError:" . $helpee . "_done.txtCreationSober");
      fwrite($dnfile, "");
      fclose($dnfile);
   }



   echo "AK " . $rqno;

}

?>
