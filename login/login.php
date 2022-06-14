<?php
require_once "../conexao.php";
$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'POST':
        if (isset($_POST['auth'])) {
            login();
        }
        break;
}
