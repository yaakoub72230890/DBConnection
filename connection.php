<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json; charset=UTF-8");

$conn = mysqli_init();

$success = $conn->real_connect(
    getenv('MYSQLHOST'), 
    getenv('MYSQLUSER'), 
    getenv('MYSQLPASSWORD'), 
    getenv('MYSQLDATABASE'), 
    getenv('MYSQLPORT'),
    NULL,
    MYSQLI_CLIENT_SSL
);

if (!$success) {
    die(json_encode(["error" => "Connection failed: " . mysqli_connect_error()]));
}
?>