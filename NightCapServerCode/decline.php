<?php
/*
This fileis called when a sober person declines a user's request.
*/

$user = $_GET['user'];
$rqst = $_GET['rqst'];
$rqno = $_GET['rqno'];

if (isset($user) && isset($rqst) && isset($rqno)) {

    if (file_exists("../phpdata/" . $user . "/" . "helpreq/" . $rqst . ".txt")) {
       unlink("../phpdata/" . $user . "/" . "helpreq/" . $rqst . ".txt");
    }
    echo "AK " . $rqno;

}
