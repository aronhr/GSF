<?php
/**
 * Created by PhpStorm.
 * User: Aron
 * Date: 08-Dec-17
 * Time: 9:23 PM
 */

class courses
{
    private $conn;
    /**
     * userClass constructor.
     */
    public function __construct()
    {
        $database = new Database();
        $db = $database->dbConnection();
        $this->conn = $db;
    }
    /**
     * @param $sql
     * @return PDOStatement
     */
    public function runQuery($sql)
    {
        $stmt = $this->conn->prepare($sql);
        return $stmt;
    }

    /**
     * @param $courseNumber
     * @param $courseName
     * @param $courseCredits
     * @return PDOStatement
     */
    public function newCourse($courseNumber, $courseName, $courseCredits){
        try
        {
            $stmt = $this->conn->prepare("CALL newCourse(:courseNumber, :courseName, :courseCredits);");
            $stmt->bindParam(":courseNumber", $courseNumber);
            $stmt->bindParam(":courseName", $courseName);
            $stmt->bindParam(":courseCredits", $courseCredits);
            $stmt->execute();
            return $stmt;
        }
        catch(PDOException $e)
        {
            echo $e->getMessage();
        }
    }

    /**
     * @param $courseNumber
     * @return mixed
     */
    public function viewCourse($courseNumber){
        try{
            $stmt = $this->conn->prepare("CALL selectCourse(:courseNumber);");
            $stmt->bindParam(":courseNumber", $courseNumber);
            $stmt->execute();
            $data = $stmt->fetch(PDO::FETCH_OBJ); //User data
            return $data;
        }
        catch (PDOException $e){
            echo $e->getMessage();
        }
    }

    /**
     * @param $courseNumber
     * @param $courseName
     * @param $courseCredits
     * @return PDOStatement
     */
    public function changeCourse($courseNumber,$courseName,$courseCredits){
        try{
            $stmt = $this->conn->prepare("CALL changeCourse(:courseNumber, :courseName, :courseCredits);");
            $stmt->bindParam(":courseNumber", $courseNumber);
            $stmt->bindParam(":courseName", $courseName);
            $stmt->bindParam(":courseCredits", $courseCredits);
            $stmt->execute();
            return $stmt;
        }catch (PDOException $e){
            echo $e->getMessage();
        }
    }

    /**
     * @param $courseNumber
     * @return PDOStatement
     */
    public function deleteCourse($courseNumber){
        try{
            $stmt = $this->conn->prepare("CALL deleteCourse(:courseNumber);");
            $stmt->bindParam(":courseNumber", $courseNumber);
            $stmt->execute();
            return $stmt;
        }
        catch (PDOException $e){
            echo $e->getMessage();
        }
    }

}