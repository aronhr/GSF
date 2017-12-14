<?php
/**
 * Created by PhpStorm.
 * User: Aron
 * Date: 08-Dec-17
 * Time: 3:50 PM
 */

include '../assets/config.php';
include '../assets/class/skoli.php';

$skoli = new skoli();
$error = "";
session_start();

########################  ADD NEW SCHOOL ########################
if (!empty($_POST['addSchool'])) {
    $name = trim(strip_tags($_POST['addSchoolName']));
    if ($name == ""){
        $error = "Provide Name!";
    }
    else {
        try {
            $skoli->newSchool($name);
        } catch (PDOException $e) {
            echo $e->getMessage();
        }
    }
}

########################  View SCHOOL ########################
if (!empty($_POST['ViewSchoolName'])) {
    $name = trim(strip_tags($_POST['ViewSchoolName']));
    if ($name == "") {
        $error = "Provide Name!";
    }
    else {
        try {
            if($schoolDetails=$skoli->viewSchool($name)){
                echo "Id:" . $schoolDetails->schoolID;
                echo "\r\nName:" . $schoolDetails->schoolName;
            }else{
                echo "No school with this name";
            }
        } catch (PDOException $e) {
            echo $e->getMessage();
        }
    }
}
$id = "";
$changeName = "";

########################  View STUDENT to form########################
if (!empty($_POST['changeSchoolName'])) {
    $name = trim(strip_tags($_POST['changeSchoolName']));
    if ($name == "") {
        $error = "Provide Name!";
    }
    else {
        try {
            if($schoolDetailsId=$skoli->viewSchool($name)){
                $_SESSION['schoolID'] = $schoolDetailsId->schoolID;
                $changeName = $schoolDetailsId->schoolName;
            }else{
                echo "No School with this name";
            }
        } catch (PDOException $e) {
            echo $e->getMessage();
        }
    }
}

########################  Change STUDENT ########################

if(!empty($_POST['changeSchoolName2'])){
    $id = $_SESSION['schoolID'];
    $name = trim(strip_tags($_POST['changeSchoolName2']));
    if ($name == ""){
        $error = "Provide Name!";
    }
    try{
        $skoli->changeSchool($id,$name);
    }catch (PDOException $e){
        echo $e->getMessage();
    }
}

########################  DELETE SCHOOL ########################
if (!empty($_POST['deleteSchoolId'])) {
    $id = trim(strip_tags($_POST['deleteSchoolId']));
    if ($id == "") {
        $error = "Provide Id!";
    }
    else {
        try {
            $skoli->deleteSchool($id);
        } catch (PDOException $e) {
            echo $e->getMessage();
        }
    }
}

if ($error != ""){
    echo $error;
}
?>

<html>
<head>

</head>
<body>
    <h1>Add New School</h1>
    <form method="post" action="" name="addSchoolForm">
        <label>Add New School</label>
        <input type="text" name="addSchoolName" autocomplete="off" placeholder="Nafn á Skóla"/>
        <input type="submit" class="button" name="addSchool" value="Add New School">
    </form>

    <h1>View School</h1>
    <form method="post" action="" name="ViewSchoolForm">
        <label>View School</label>
        <input type="text" name="ViewSchoolName" autocomplete="off" placeholder="Nafn á Skóla"/>
        <input type="submit" class="button" name="ViewSchool" value="View School">
    </form>

    <h1>Change School</h1>
    <form method="post" action="" name="changeSchoolFormId">
        <label>Change School</label>
        <input type="text" name="changeSchoolName" autocomplete="off" placeholder="School Name"/>
        <input type="submit" class="button" name="changeSchoolIdForm" value="Get School Information">
    </form>

    <form method="post" action="" name="changeSchoolForm">
        <input type="text" name="changeSchoolName2" autocomplete="off" <?php if(isset($_POST['changeSchoolName'])){echo 'value="' . $changeName . '"';} ?>/>
        <input type="submit" class="button" name="changeStudent" value="Change School Information">
    </form>

    <h1>Delete School</h1>
    <form method="post" action="" name="deleteSchoolForm">
        <label>Delete School</label>
        <input type="number" name="deleteSchoolId" autocomplete="off" placeholder="School Id"/>
        <input type="submit" class="button" name="deleteSchool" value="Delete School">
    </form>
</body>
</html>