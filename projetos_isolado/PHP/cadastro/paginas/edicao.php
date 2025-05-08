<?php
require '../config/database.php';
session_start();

if (!isset($_SESSION['user_id'])) {
    header("Location: login.php");
    exit;
}

$user_id = $_SESSION['user_id'];
$stmt = $pdo->prepare("SELECT * FROM users WHERE id = ?");
$stmt->execute([$user_id]);
$user = $stmt->fetch();

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $name = $_POST['name'];
    $stmt = $pdo->prepare("UPDATE users SET name = ? WHERE id = ?");
    if ($stmt->execute([$name, $user_id])) {
        echo "Dados atualizados!";
    } else {
        echo "Erro ao atualizar.";
    }
}
?>
<form method="POST">
    <input type="text" name="name" value="<?= htmlspecialchars($user['name']) ?>" required>
    <button type="submit">Atualizar</button>
</form>
