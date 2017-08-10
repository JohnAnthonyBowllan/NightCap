<?php
/*
This file is called at the very beginning of the program to create a folder for
the user. It also creates all the necessary text files for other files to carry
out their functionalities. There is also defensive coding at the end of the file
to get rid of any files that may not have been deleted from previous sessions.
*/
$user = $_GET['user'];
$gend = $_GET['gend'];
$rqno = $_GET['rqno'];

if (isset($user) && isset($gend) && isset($rqno)){

   if (!(file_exists("../phpdata/" . $user))) {
      mkdir("../phpdata/" . $user);
      mkdir("../phpdata/" . $user . "/helpreq");
      mkdir("../phpdata/" . $user . "/messages");
   }

   #Creates location file for user
   $loctxt = "../phpdata/" . $user . "/loc.txt";
   $locfile = fopen($loctxt, "w") or die("ER FileOpenError:" . $user . "_loc.txt");
   fwrite($locfile, "0" . "\n" . "0" . "\n" . "0" . "\n" . "Nowhere");
   fclose($locfile);

   #Creates user info file
   $year = rand(18, 21);
   $usertxt = "../phpdata/" . $user . "/user.txt";
   $userfile = fopen($usertxt, "w") or die("ER FileOpenError:" . $user . "_user.txt");
   fwrite($userfile, $user . "\n" . "###########" . "\n" . $gend . "\n" . $user . "@middlebury.edu");
   fclose($userfile);

   #Creates messages file
   $msgtxt = "../phpdata/" . $user . "/messages/number.txt";
   $msgfile = fopen($msgtxt, "w") or die("ER FileOpenError:" . $user . "_number.txt");
   fwrite($msgfile, "1");
   fclose($msgfile);



   $sobers = scandir("../phpdata/Sober/");

   for ($i = 0; $i < count($sobers); ++$i) {

     #Only checks through text files
     if (substr($sobers[$i],-4)!=".txt") continue;
     if (file_exists("../phpdata/" . substr($sobers[$i], 0, strlen($sobers[$i])-4) . "/")) continue;

     $requests = scandir( "../phpdata/" . (substr($sobers[$i], 0, strlen($sobers[$i])-4))  . "/" . "helpreq/");

     for ($j = 0; $j < count($requests); ++$j) {

       #Deletes the help request from all sober user's helpreq folder
       if (substr($requests[$j],-4)!=".txt") continue;
       if (strcmp(substr($requests[$j], 0, strlen($requests[$j])-4), $user) == 0) {

          unlink("../phpdata/" . (substr($sobers[$i], 0, strlen($sobers[$i])-4))  . "/" . "helpreq/" . $requests[$j]);

       }
     }
   }

   #Deletes the global help request as well
   if (file_exists("../phpdata/Help/" . $user . ".txt")) {

     unlink("../phpdata/Help/" . $user . ".txt");

   }

   if (file_exists("../phpdata/" . $user . "/helper.txt")) {

     unlink("../phpdata/" . $user . "/helper.txt");

   }

   if (file_exists("../phpdata/" . $user . "/helping.txt")) {

     unlink("../phpdata/" . $user . "/helping.txt");

   }

   if (file_exists("../phpdata/" . $user . "/done.txt")) {

     unlink("../phpdata/" . $user . "/done.txt");

   }

   echo "AK " . $rqno . "|";

}

?>
