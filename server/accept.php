<?php
/*
This file is called when a sober person accepts a help request. It takes care
of removing all forms of the help request and puts the two users in tandem with
a helper and helpee file.
*/
$user = $_GET['user'];
$rqst = $_GET['rqst'];
$rqno = $_GET['rqno'];

if (isset($user) && isset($rqst) && isset($rqno)) {

  #Defense in case two people accept the same person around the same time
  if (!(file_exists("../phpdata/Help/" . $rqst . ".txt"))) {

    echo "CA " . $rqno;

  }

  else {

    $sobers = scandir("../phpdata/Sober/");

    #Deletes the help request from every user except the one who accepted
    for ($i = 0; $i < count($sobers); ++$i) {

      #Only checks through text files
      if (substr($sobers[$i],-4)!=".txt") continue;

      $requests = scandir( "../phpdata/" . (substr($sobers[$i], 0, strlen($sobers[$i])-4)) . "/" . "helpreq/");

      #Find the request in this sober person's directory and clear it out
      for ($j = 0; $j < count($requests); ++$j) {

        if (strcmp(substr($requests[$j], 0, -4), $rqst) == 0) {

         unlink("../phpdata/" . substr($sobers[$i], 0, -4) . "/" . "helpreq/" . $requests[$j]);

        }
      }
    }


    if (file_exists("../phpdata/Help/" . $rqst . ".txt")) {
     unlink("../phpdata/Help/" . $rqst . ".txt");
    }

    #Need to send requestee the info of the helper
    $helploc = file("../phpdata/" . $user . "/loc.txt", FILE_IGNORE_NEW_LINES);
    $helper = "../phpdata/" . $rqst . "/" . "helper.txt";
    $userinfo = file("../phpdata/" . $user . "/user.txt", FILE_IGNORE_NEW_LINES);
    $helpfile = fopen($helper, "w") or die("ER FileOpenError:" . $user . "_helper.txt");
    fwrite($helpfile, $userinfo[0] . "\n" . $helploc[0] . " " . $helploc[1] . " " . $helploc[2] . "\n" . "Nowhere");
    fclose($helpfile);

    #Sends helper info of drunk person
    $drunkloc = file("../phpdata/" . $rqst . "/loc.txt", FILE_IGNORE_NEW_LINES);
    $helpee = "../phpdata/" . $user . "/" . "helping.txt";
    $drunkinfo = file("../phpdata/" . $rqst . "/user.txt", FILE_IGNORE_NEW_LINES);
    $drunkfile = fopen($helpee, "w") or die("ER FileOpenError:" . $rqst . "_helping.txt");
    fwrite($drunkfile, $drunkinfo[0] . "\n" . $drunkloc[0] . " " . $drunkloc[1] . " " . $drunkloc[2] . "\n" . "Nowhere");
    fclose($drunkfile);

    echo "AK " . $rqno;

  }


}
?>
