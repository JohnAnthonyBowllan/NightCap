<?php
/*
This file is called when a user cancels their help request. It gets rid of all
traces of their request.
*/
$user = $_GET['user'];
$rqno = $_GET['rqno'];

if (isset($user) && isset($rqno)) {

   $sobers = scandir("../phpdata/Sober/");

   for ($i = 0; $i < count($sobers); ++$i) {

     #Only checks through text files
     if (substr($sobers[$i],-4)!=".txt") continue;

     $requests = scandir( "../phpdata/" . (substr($sobers[$i], 0, strlen($sobers[$i])-4))  . "/" . "helpreq/");

     for ($j = 0; $j < count($requests); ++$j) {

       #Deletes the help request from all sober user's helpreq folder
       if (strcmp(substr($requests[$j], 0, strlen($requests[$j])-4), $user) == 0) {

          unlink("../phpdata/" . (substr($sobers[$i], 0, strlen($sobers[$i])-4))  . "/" . "helpreq/" . $requests[$j]);

       }
     }
   }

   #Deletes the global help request as well
   if (file_exists("../phpdata/Help/" . $user . ".txt")) {
      unlink("../phpdata/Help/" . $user . ".txt");
   }

   echo "AK ". $rqno;
}
?>
