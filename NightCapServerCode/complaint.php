<?php
$user = $_GET['user'];
$info = $_GET['info'];
$rqno = $_GET['rqno'];

if (isset($user) && isset($info) & isset($rqno)) {

   $fname = "../phpdata/Complaints/" . $user . "-comp" .  ".txt";
   $file = fopen($fname, "w") or die("ER FileOpenError:" . $user . "complaint.txt");

   #Won't be in final code just need a way to display sentences on URL
   $data = explode("_", $info);
   $complaint = implode(" ", $data);

   fwrite($file, $complaint);
   fclose($file);

   echo "AK " . $rqno;
}
?>
