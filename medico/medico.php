<?php
require_once "../conexao.php";
$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
       case 'POST':
              if (isset($_POST['editarMedico'])) {
                     editarMedico();
              } else if (isset($_POST['auth'])) {
                     login();
              } else if (isset($_POST['cadastrarMedico'])) {
                     cadastrarMedico();
              }
              break;
       case 'GET':
              if (isset($_GET['listarConsultas'])) {
                     listarConsultas();
              } else if (isset($_GET['listar_especialidades'])) {
                     listar_especialidades();
              } else if (isset($_GET['listarMedicos'])) {
                     listarMedicos();
              }

              break;
       default:
              echo '{"err": "Método inválido"}';
              break;
}

function editarMedico()
{
       try {
              alterar_usuario($_POST['email'], $_POST['senha'], $_POST['id_usuario']);
              $Conexao = Connection::getConnection();
              $Conexao->query('call alterar_medico ("' . $_POST['nome_medico'] . '", ' . $_POST['fk_especialidade'] . ', ' . $_POST['id_medico'] . ')');
              $query = $Conexao->query('call get_medico (' . intval($_POST['id_usuario']) . ')');
              $res = $query->fetchAll(PDO::FETCH_OBJ);
              echo json_encode($res[0]);
       } catch (Exception $e) {
              echo ('{"err": "err"}');
       }
}


function listarConsultas()
{
       try {
              $Conexao = Connection::getConnection();
              $query = $Conexao->query('call listar_consultas_medico(1)');
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

function listarMedicos()
{
       try {
              $Conexao = Connection::getConnection();
              $query = $Conexao->query('SELECT * FROM listar_medicos');
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

function cadastrarMedico()
{
       try {
              $Conexao = Connection::getConnection();
              $Conexao->query('call cadastrar_medico ("' . $_POST['nome_medico'] . '", ' . $_POST['fk_especialidade'] . ', "' . $_POST['email'] . '"
              , "' . $_POST['senha'] . '")');
       } catch (Exception $e) {
              echo json_encode('{"err": "' . $e . '"}');
       }
}
