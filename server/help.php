<?php
/*
This file is called to send out a user's help request. It filters through the
sober people and only sends the request to the relevant ones. It also creates a
global help file to add to helpers that login after this was initially sent out.
*/
$user = $_GET['user'];
$loc = $_GET['loc'];
$pref = $_GET['pref'];
$rqno = $_GET['rqno'];

if (isset($user) && isset($loc) && isset($pref) && isset($rqno)) {

 $sobers = scandir("../phpdata/Sober/");
 $locarr = explode("_", $loc);
 $location = $locarr[0] . " " . $locarr[1];

 #Add this helprequest to all relevant sober user's folders
 $count = 0;

 for ($i = 0; $i < count($sobers); ++$i) {

    #Only checks through text files
    if (substr($sobers[$i],-4)!=".txt") continue;

    #Filter who the request is sent to based on preferences
    $info = file("../phpdata/" . substr($sobers[$i], 0, -4)  . "/user.txt", FILE_IGNORE_NEW_LINES);


    #Filters based on user preferences
    if (strcmp($pref, $info[2]) == 0 || strcmp($pref, "None") == 0 || ((strcmp($pref, "Male/Female") == 0) && (strcmp($info[2], "Other") != 0)) || ((strcmp($pref, "Male/Other") == 0) && (strcmp($info[2], "Female") != 0)) || ((strcmp($pref, "Female/Other") == 0) && (strcmp($info[2], "Male") != 0)) ) {

       #Writes a text file for the help request in sober person's helpreq directory
       $newreq = "../phpdata/" . (substr($sobers[$i], 0, strlen($sobers[$i])-4))  . "/" . "helpreq/" . $user . ".txt";
       $file = fopen($newreq, "w") or die("ER FileOpenError:" . $user . "_helpRequestCreate");
       fwrite($file, $location);
       fclose($file);
       ++$count;

    }

 }

 #Create global help request in Help folder
 $updateHelp = "../phpdata/Help/" . $user . ".txt";
 $helpfile = fopen($updateHelp, "w") or die("ER FileOpenError:" . $user . "_helpFileMade");
 fwrite($helpfile, $location . "\n" . $pref . "\n" . $rqno);
 fclose($helpfile);

 #Count is used to see how many people actually got the help request
 echo "AK " . $rqno . " " . $count . "|";

}


?>
