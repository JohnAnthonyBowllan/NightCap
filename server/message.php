<?php
/*
When help is requested, create a message folder and in there create a message
number text file in this messages folder, message text files will be saved and
deleted upon being read.
*/
$user = $_GET['user'];
$msg = $_GET['msg'];
$dest = $_GET['dest'];
$rqno = $_GET['rqno'];


if(isset($user) && isset($msg) && isset($dest) && isset($rqno)) {

   #Updates the user's location in the database
   $message = rawurldecode($msg);

   #Use this to get the name of the sender with $userinfo[0], email with $userinfo[3]
   $userinfo = file("../phpdata/" . $user . "/user.txt", FILE_IGNORE_NEW_LINES);

   #Makes a new message file in the destination user's messages folder
   $msgnum = file("../phpdata/" . $dest . "/messages/number.txt", FILE_IGNORE_NEW_LINES);
   $usernum = file("../phpdata/" . $user . "/messages/number.txt", FILE_IGNORE_NEW_LINES);
   $destname = "../phpdata/" . $dest . "/messages" . "/message" . (string) $msgnum[0] . ".txt";
   $msgfile = fopen($destname, "w") or die("ER FileOpenError:" . $dest . "_newMessageSend");
   fwrite($msgfile, $userinfo[0] . "\n" . $message);
   fclose($msgfile);

   $msgnum[0] =(string) ((int) $msgnum[0] + 1);
   file_put_contents("../phpdata/" . $dest. "/messages/number.txt", $msgnum[0]);

   #Makes a new message file in the sender's message folder
   $username = "../phpdata/" . $user . "/messages" . "/message" . (string) $usernum[0] . ".txt";
   $userfile = fopen($username, "w") or die("ER FileOpenError:" . $user . "_newMessageCreate");
   fwrite($userfile, $userinfo[0] . "\n" . $message);
   fclose($userfile);

   $usernum[0] = (string) ((int) $usernum[0] + 1);
   file_put_contents("../phpdata/" . $user . "/messages/number.txt", $usernum[0]);

   echo "AK " . $rqno . "|";
}


?>
