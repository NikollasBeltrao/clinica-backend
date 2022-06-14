<?php
require_once "../conexao.php";
$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'POST':
        if (isset($_POST['editarAtendente'])) {
            editarAtendente();
        } else if (isset($_POST['auth'])) {
            login();
        } else if (isset($_POST['cadastrarConsulta'])) {
            cadastrarConsulta();
        }
        break;
    case 'GET':
        if (isset($_GET['listarConsultas'])) {
            listarConsultasAt();
        } else if (isset($_GET['listar_especialidades'])) {
            listar_especialidades();
        }
        else if (isset($_GET['getLucro'])) {
            getLucro();
        }
        
        break;
    default:
        echo '{"err": "Método inválido"}';
        break;
}

function editarAtendente()
{
    try {
        alterar_usuario($_POST['email'], $_POST['senha'], $_POST['id_usuario']);
        $Conexao = Connection::getConnection();
        $Conexao->query('call alterar_atendente ("' . $_POST['nome_atendente'] . '", ' . $_POST['id_atendente'] . ')');
        $query = $Conexao->query('call get_atendente (' . intval($_POST['id_usuario']) . ')');
        $res = $query->fetchAll(PDO::FETCH_OBJ);
        echo json_encode($res[0]);
    } catch (Exception $e) {
        echo ('{"err": "err"}');
    }
}


function listarConsultasAt()
{
    try {
        $Conexao = Connection::getConnection();
        $query = $Conexao->query('SELECT * FROM listar_consultas');
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


function listar_especialidades()
{
    try {
        $Conexao = Connection::getConnection();
        $query = $Conexao->query('SELECT * FROM listar_especialidades');
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

function cadastrarConsulta () {       
    try {
           $Conexao = Connection::getConnection();
           $Conexao->query('call cadastrar_consulta ('.$_POST['fk_medico'].', '.$_POST['fk_paciente'].', '.$_POST['fk_status'].'
           , "'.$_POST['data'].'", "'.$_POST['descricao'].'", '.$_POST['valor'].')');
    } catch (Exception $e) {
           echo json_encode('{"err": "' . $e . '"}');
    }
}


function getLucro () {       
    try {
           $Conexao = Connection::getConnection();
           $query = $Conexao->query('SELECT lucro_consultas("2022-01-01", "2022-12-30") AS lucro');
           $res = $query->fetchAll(PDO::FETCH_OBJ);
           echo json_encode($res[0]->lucro);
    } catch (Exception $e) {
           echo json_encode('{"err": "' . $e . '"}');
    }
}
