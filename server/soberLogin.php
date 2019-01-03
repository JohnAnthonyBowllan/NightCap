<?php
/*
This file is called when a user chooses "I can help" in the main menu. This
labels them as sober and also adds all the current, relevant help requests to
their folder.
*/
$user = $_GET['user'];
$rqno = $_GET['rqno'];

if(isset($user) && isset($rqno)) {

   $addSober = "../phpdata/Sober/" . $user . ".txt";
   $file = fopen($addSober, "w") or die("ER FileOpenError:" . $user  . "_soberLogin");
   fwrite($file, "");

   $helpreqs = scandir("../phpdata/Help/");

   #Updates helpreqs directory with all current help requests
   for ($i = 0; $i < count($helpreqs); ++$i) {

      if (substr($helpreqs[$i],-4)!=".txt") continue;

      $userinfo = file("../phpdata/" . $user  . "/user.txt", FILE_IGNORE_NEW_LINES);
      $helpinfo = file("../phpdata/Help/" . $helpreqs[$i], FILE_IGNORE_NEW_LINES);

      #Filter so only rel help requests are in displayed list
      if (strcmp($userinfo[2], $helpinfo[1]) == 0 || strcmp($helpinfo[1], "None") == 0 || (strcmp($helpinfo[1], "Male/Female") == 0) && ((strcmp($userinfo[2], "Other") != 0)) || ((strcmp($helpinfo[1], "Male/Other") == 0) && (strcmp($userinfo[2], "Female") != 0)) || ((strcmp($helpinfo[1], "Female/Other") == 0) && (strcmp($userinfo[2], "Male") != 0))) {

         $newreq = "../phpdata/" . $user . "/" . "helpreq/" .  $helpreqs[$i];
         $reqfile = fopen($newreq, "w") or die("ER FileOpenError:" . $user . "_soberLoginAddHelpreqs");
         fwrite($reqfile, $helpinfo[0]);
         fclose($reqfile);

      }

   }

   echo "AK " . $rqno . "|";

}

?>
