<?php
/*
This file is called when a sober person is done helping. Gets rid of all
relevant files.
*/
$user = $_GET['user'];
$rqno = $_GET['rqno'];

if(isset($user) && isset($rqno)) {

   #Removes the user from the sober database
   if (file_exists("../phpdata/Sober/" . $user . ".txt")) {
      unlink("../phpdata/Sober/" . $user . ".txt");
   }
   $helpreqs = scandir("../phpdata/" . $user . "/" . "helpreq/");

   #Removes all the user's pending help requests
   for ($i = 0; $i < count($helpreqs); ++$i) {

     if (substr($helpreqs[$i],-4)!=".txt") continue;
     if (file_exists("../phpdata/" . $user . "/" . "helpreq/" . $helpreqs[$i]));
     unlink("../phpdata/" . $user . "/" . "helpreq/" . $helpreqs[$i]);

   }

   #Removes any helping.txt that may remain in the user's folder
   if (file_exists("../phpdata/" . $user . "/" . "helping.txt")) {

      unlink("../phpdata/" . $user . "/" . "helping.txt");

   }

   echo "AK " . $rqno;

}

?>
