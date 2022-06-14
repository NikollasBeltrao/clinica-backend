<?php
require_once "../conexao.php";
$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'POST':
        if (isset($_POST['editarPaciente'])) {
            editarPaciente();
        } else if (isset($_POST['auth'])) {
            login();
        } else if (isset($_POST['cadastrarPaciente'])) {
            cadastrarPaciente();
        }
        break;
    case 'GET':
        if (isset($_GET['listarConsultas'])) {
            listarConsultasPa();
        } else if (isset($_GET['listar_especialidades'])) {
            listar_especialidades();
        } else if (isset($_GET['listarPacientes'])) {
            listarPacientes();
        } else if (isset($_GET['listarStatus'])) {
            listarStatus();
        }

        break;
    default:
        echo '{"err": "Método inválido"}';
        break;
}

function editarPaciente()
{
       try {
              alterar_usuario($_POST['email'], $_POST['senha'], $_POST['id_usuario']);
              $Conexao = Connection::getConnection();
              $Conexao->query('call alterar_paciente ("' . $_POST['nome_paciente'] . '", "' . $_POST['rg'] . '", "' . $_POST['cpf'] . '"
              , "' . $_POST['telefone'] . '", "' . $_POST['data_nascimento'] . '", ' . $_POST['id_paciente'] . ')');
              $query = $Conexao->query('call get_paciente (' . intval($_POST['id_usuario']) . ')');
              $res = $query->fetchAll(PDO::FETCH_OBJ);
              echo json_encode($res[0]);
       } catch (Exception $e) {
              echo ('{"err": "err"}');
       }
}


function listarConsultasPa()
{
    try {
        $Conexao = Connection::getConnection();
        $query = $Conexao->query('call listar_consultas_paciente ('.$_GET['id_paciente'].')');
        $res = $query->fetchAll(PDO::FETCH_OBJ);
        if (count($res) > 0) {
            echo json_encode($res);
        } else {
            echo false;
        }
    } catch (Exception $e) {
        echo json_encode('{"err": "' . $e . '"}');
    }
}


function listarPacientes()
{
    try {
        $Conexao = Connection::getConnection();
        $query = $Conexao->query('SELECT * FROM listar_pacientes');
        $res = $query->fetchAll(PDO::FETCH_OBJ);
        if (count($res) > 0) {
            echo json_encode($res);
        } else {
            echo false;
        }
    } catch (Exception $e) {
        echo json_encode('{"err": "' . $e . '"}');
    }
}

function listarStatus()
{
    try {
        $Conexao = Connection::getConnection();
        $query = $Conexao->query('SELECT * FROM listar_status');
        $res = $query->fetchAll(PDO::FETCH_OBJ);
        if (count($res) > 0) {
            echo json_encode($res);
        } else {
            echo false;
        }
    } catch (Exception $e) {
        echo json_encode('{"err": "' . $e . '"}');
    }
}

function cadastrarPaciente()
{
    try {
        $Conexao = Connection::getConnection();
        $Conexao->query('call cadastrar_paciente ("' . $_POST['nome_paciente'] . '", "' . $_POST['email'] . '"
              , "' . $_POST['senha'] . '", "' . $_POST['rg'] . '", "' . $_POST['cpf'] . '", "' . $_POST['telefone'] . '"
              , "' . $_POST['data_nascimento'] . '")');
    } catch (Exception $e) {
        echo json_encode('{"err": "' . $e . '"}');
    }
}

