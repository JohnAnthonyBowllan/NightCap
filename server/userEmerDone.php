<?php
/*
This file is called when a user decides that the session is over.
It removes all the necessary files and resets the message number. Creates a
done file for the helper to end their session as well.
*/
$user = $_GET['user'];
$rqno = $_GET['rqno'];

if (isset($user) && isset($rqno)) {

   $helper = "";
   if (file_exists("../phpdata/" . $user . "/helper.txt")) {

      $name = file("../phpdata/" . $user . "/helper.txt", FILE_IGNORE_NEW_LINES);
      $helper .= $name[0];
      unlink("../phpdata/" . $user . "/helper.txt");

    }

   if (file_exists("../phpdata/" . $helper . "/helping.txt")) {

      unlink("../phpdata/" . $helper . "/helping.txt");

   }



   #Update the message numbers
   file_put_contents("../phpdata/" . $user . "/messages/number.txt", "1");

   if (strlen($helper) != 0) {
      file_put_contents("../phpdata/" . $helper . "/messages/number.txt", "1");
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
   if (strlen($helper) != 0 && (time()-filemtime("../phpdata/" . $helper . "/loc.txt") < 5)) {
      $dntag = "../phpdata/" . $helper . "/done.txt";
      $dnfile = fopen($dntag, "w") or die("ER FileOpenError:" . $helper . "_done.txtCreationDrunk");
      fwrite($dnfile, "");
      fclose($dnfile);
   }

   echo "AK " . $rqno;
}

?>
