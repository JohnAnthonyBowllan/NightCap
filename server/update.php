<?php
/*
This file is the main hub for communication with the app. It is called every 10
seconds by sober helpers, and called every 3 seconds by both helpers and helpees
when they are put in tandem. Messaging, trading location information, and showing
new help requests.
*/

$user = $_GET['user'];
$loc = $_GET['loc'];
$conn = $_GET['conn'];
$bssid = $_GET['bssid'];

if(isset($user) && isset($loc) && (strcmp($loc, "0.0 0.0") != 0)) {

   #Updates the user's location in the database
   $lines = file("../phpdata/" . $user . "/" . "loc.txt", FILE_IGNORE_NEW_LINES);
   $lat_long = explode("_", $loc);
   $lines[0] = $lat_long[0];
   $lines[1] = $lat_long[1];
   $lines[2] = $lat_long[2];
   $my_lat = floatval($lat_long[0]);
   $my_long = floatval($lat_long[1]);
   $my_alt = floatval($lat_long[2]);

   #Checks for the user's location
   $locs = scandir("../phpdata/Locations/");
   $ids = scandir("../phpdata/BSSID/");
   $location = "";

   if (strlen($bssid) != 0) {
   #Give exact location based on router

      echo "BS " . $bssid . "|";
      for ($j = 0; $j < count($ids); ++$j) {

         if (substr($ids[$j],-4)!=".txt") continue;

         #BSSID match is found
         if (strcmp(substr($ids[$j], 0, -4), $bssid) == 0) {

         $place = file("../phpdata/BSSID/" . $ids[$j], FILE_IGNORE_NEW_LINES);
         $location .= str_replace(" ", "%", $place[0]);
         break;

         }
      }
   }

   #No bssid given (wifi is off or something)
   if (strlen($location) == 0) {

      for ($i = 0; $i < count($locs); ++$i) {

         if (substr($locs[$i],-4)!=".txt") continue;
         $place = file("../phpdata/Locations/" . $locs[$i], FILE_IGNORE_NEW_LINES);
         $loclat = explode("_", $place[0]);
         $loclong = explode("_", $place[1]);
         $minlat = floatval($loclat[0]);
         $maxlat = floatval($loclat[1]);
         $minlong = floatval($loclong[0]);
         $maxlong = floatval($loclong[1]);

         if ( (($minlat < $my_lat) && ($maxlat > $my_lat))  &&  (($minlong < $my_long) && ($maxlong > $my_long))) {

            $location .= substr($locs[$i], 0, -4);
            break;

         }

      }

      #Coordinates don't correspond to any of the locations
      if (strlen($location) == 0) {

         $location .= "Off%Campus";

      }
   }

   $lines[3] = $location;
   $contents = implode("\n", $lines);
   file_put_contents("../phpdata/" . $user . "/" . "loc.txt", $contents);


   #Looks through the user's help requests and echoes them with HR tag
   $helparr = scandir("../phpdata/" . $user . "/" . "helpreq/", FILE_IGNORE_NEW_LINES);

   for ($i = 0; $i < count($helparr); ++$i) {

      if (substr($helparr[$i],-4)!=".txt") continue;

      $userloc = file("../phpdata/" . $user . "/" . "helpreq/" . $helparr[$i], FILE_IGNORE_NEW_LINES);
      $info = file("../phpdata/" . substr($helparr[$i], 0, -4) . "/user.txt");

      #Still need to add email, $user was replaced with the name in user.txt
      echo "HR " . $info[0] . " " . $userloc[0] . "|";

   }





   #Looks through the user's messages and echoes them with MG tag
   $msgarr = scandir("../phpdata/" . $user . "/messages/");

   for ($j = 0; $j < count($msgarr); ++$j) {

      if (substr($msgarr[$j], -4) != ".txt") continue;

      if (strcmp($msgarr[$j], "number.txt") != 0) {

         $msg = file("../phpdata/" . $user . "/messages/" . $msgarr[$j], FILE_IGNORE_NEW_LINES);
         echo "MG " . substr($msgarr[$j], 7, -4) . " " . $msg[0] . " " . $msg[1] . "|";
         unlink("../phpdata/" . $user . "/messages/" . $msgarr[$j]);

      }
   }




   #Helps complete session
   if (file_exists("../phpdata/" . $user . "/done.txt")) {

      echo "DN Fin|";

   }





   #For user, updates their helper's file and sends back these updates with HB tag
   if (file_exists("../phpdata/" . $user . "/helper.txt")) {

     $helper = file("../phpdata/" . $user . "/helper.txt", FILE_IGNORE_NEW_LINES);

     #make variables for cleaerer coding (set helper[0] = some varname)
     $soberloc = file("../phpdata/" . $helper[0] . "/loc.txt", FILE_IGNORE_NEW_LINES);
     $helper[1] = $soberloc[0] . " " . $soberloc[1] . " " . $soberloc[2];

     file_put_contents("../phpdata/" . $user . "/helper.txt", $helper[0] . "\n" . $helper[1] . "\n" . $soberloc[3]);
     echo "HB " . $helper[0] . " " . $soberloc[3] . "|";

     #Checks if user's helper has been disconnected
     if (time()-filemtime("../phpdata/" . $helper[0] . "/loc.txt") > 6 && (strcmp($conn, "yes") == 0)) {

        echo "DN Con|";

     }

   }






   #SOBER CODE
   #For sober user, updates their helpee's file and sends back these updates with HP tag
   if (file_exists("../phpdata/" . $user . "/helping.txt")) {

     $helpee = file("../phpdata/" . $user . "/helping.txt", FILE_IGNORE_NEW_LINES);
     $drnkloc =  file("../phpdata/" . $helpee[0] . "/loc.txt", FILE_IGNORE_NEW_LINES);
     $helpee[1] = $drnkloc[0] . " " . $drnkloc[1] . " " . $drnkloc[2];

     file_put_contents("../phpdata/" . $user . "/helping.txt", $helpee[0] . "\n" . $helpee[1] . "\n" . $drnkloc[3]);
     echo "HP " . $helpee[0] . " " . $drnkloc[3] . "|";

     #Checks if user's helper has been disconnected
     if (time()-filemtime("../phpdata/" . $helpee[0] . "/loc.txt") > 6 && (strcmp($conn, "yes") == 0)) {

        echo "DN Con|";

     }
   }
}

?>
