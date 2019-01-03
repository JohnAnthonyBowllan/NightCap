<?php
/*
This file is sued to log the different BSSiDs across campus along with their
associated locations. It also echoes back all the current BSSIDS and their
associated locations.
*/
$bssid = $_GET['bssid'];
$loc = $_GET['loc'];

if (isset($bssid) && isset($loc)) {

  $location = rawurldecode($loc);

  #Creates bssid file
  $idtxt = "../phpdata/BSSID/" . $bssid . ".txt";
  $idfile = fopen($idtxt, "w") or die("ER FileOpenError:" . $bssid . "_bssidMaker");
  fwrite($idfile, $location);
  fclose($idfile);

  $bssids = scandir("../phpdata/BSSID/");

  for ($i = 0; $i < count($bssids); ++$i) {

     $place = file("../phpdata/BSSID/" . $bssids[$i], FILE_IGNORE_NEW_LINES);
     echo "ID " . substr($bssids[$i], 0, -4) . " " . $place[0] . "|";

  }

}

?>
