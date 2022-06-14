<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, FILES");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, X-Requested-With");
date_default_timezone_set('America/Sao_Paulo');
class Connection
{
       private static $connection;

       private function __construct()
       {
       }

       public static function getConnection()
       {

              try {
                     if (!isset($connection)) {
                            $connection =  new PDO('mysql:dbname=id15192641_clinica;host=localhost', 'id15192641_nikollas2', 'Kof4o5i*B_H#x$S0');
                            $connection->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
                     }
                     return $connection;
              } catch (PDOException $e) {
                     $mensagem = "Drivers disponiveis: " . implode(",", PDO::getAvailableDrivers());
                     $mensagem .= "\nErro: " . $e->getMessage();
                     throw new Exception($mensagem);
              }
       }
}


function auth($login, $senha)
{
       try {
              $Conexao = Connection::getConnection();
              $query = $Conexao->query('call login ("' . $login . '", "' . $senha . '")');
              $usuario = $query->fetchAll(PDO::FETCH_OBJ);
              if (count($usuario) > 0) {
                     return $usuario[0];
              } else {
                     return 0;
              }
       } catch (Exception $e) {
              echo json_encode('{"err": "' . $e . '"}');
       }
}

function login()
{
       try {
              $Conexao = Connection::getConnection();
              $usu = auth($_POST['email'], $_POST['senha']);
              if ($usu) {
                     $procedure = '';
                     if ($usu->fk_tipo === '1') {
                            $procedure = 'get_paciente';
                     } else if ($usu->fk_tipo === '2') {
                            $procedure = 'get_atendente';
                     } else if ($usu->fk_tipo === '3') {
                            $procedure = 'get_medico';
                     }
                     $query = $Conexao->query('call ' . $procedure . ' (' . intval($usu->id_usuario) . ')');
                     $res = $query->fetchAll(PDO::FETCH_OBJ);
                     if (count($res) > 0) {
                            echo json_encode($res[0]);
                     } else {
                            echo false;
                     }
              } else {
                     echo false;
              }
       } catch (Exception $e) {
              echo json_encode('{"err": "' . $e . '"}');
       }
}

function alterar_usuario($email, $senha, $usuario)
{
       try {
              $Conexao = Connection::getConnection();
              $Conexao->query('call alterar_usuario ("' . $email . '", "' . $senha . '", ' . $usuario . ')');
       } catch (Exception $e) {
              echo json_encode('{"err": "' . $e . '"}');
       }
}
