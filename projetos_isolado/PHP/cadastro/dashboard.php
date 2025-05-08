<?php
require 'includes/header.php';
session_start();

if (!isset($_SESSION['user_id'])) {
    header("Location: pages/login.php");
    exit;
}

echo "<h1 class='text-center mt-4'>Bem-vindo ao Sistema!</h1>";
require 'includes/footer.php';
?>
