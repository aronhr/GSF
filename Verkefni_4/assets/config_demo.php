<?php
/**
 * Created by PhpStorm.
 * User: Aron
 * Date: 02-Dec-17
 * Time: 11:28 PM
 */
class Database
{
    private $host = "localhost";
    private $db_name = "Verkefni_4";
    private $username = "USERNAME"; // Your username
    private $password = "PASSWORD"; // Your Password
    public $conn;

    public function dbConnection()
    {
        $this->conn = null;
        try {
            $this->conn = new PDO("mysql:host=" . $this->host . ";dbname=" . $this->db_name, $this->username, $this->password);
            $this->conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        } catch (PDOException $exception) {
            echo "Connection error: " . $exception->getMessage();
        }
        return $this->conn;
    }
}