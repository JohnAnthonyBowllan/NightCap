<?php
$userbase = scandir("../phpdata/");

for ($i = 0; $i < count($userbase); ++$i) {

  if (file_exists("../phpdata/" . $userbase[$i] . "/loc.txt")) {

     $helpreqs = scandir("../phpdata/" . $userbase[$i] . "/helpreq" . "/");

     echo $userbase[$i] . "--";
     for ($j = 0; $j < count($helpreqs); ++$j) {

        if (substr($helpreqs[$j],-4)==".txt") {
           echo $helpreqs[$j] . "*";
        }

     }

     echo "\t";

     if (file_exists("../phpdata/" . $userbase[$i] . "/helper.txt" )) {

       echo "Being helped currently";

     }

     if (file_exists("../phpdata/" . $userbase[$i] . "/helping.txt" )) {

       echo "Being of help currently";

     }

  }

}

?>
