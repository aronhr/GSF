<?php
/**
 * Created by PhpStorm.
 * User: Aron
 * Date: 08-Dec-17
 * Time: 11:23 PM
 */

include '../assets/config.php';
include '../assets/class/courses.php';

$course = new courses();
$error = "";
session_start();

########################  ADD NEW Course ########################
if (!empty($_POST['addCourse'])) {
    $addCourseNumber = trim(strip_tags($_POST['addCourseNumber']));
    $addCourseName = trim(strip_tags($_POST['addCourseName']));
    $addCourseCredits = trim(strip_tags($_POST['addCourseCredits']));
    if ($addCourseNumber == "") {
        $error = "Provide Kennitala!";
    }elseif ($addCourseName == ""){
        $error = "Provide Name!";
    }elseif ($addCourseCredits == ""){
        $error = "Provide Braut!";
    }
    else {
        try {
            $course->newCourse($addCourseNumber, $addCourseName, $addCourseCredits);
        } catch (PDOException $e) {
            echo $e->getMessage();
        }
    }
}

########################  View SCHOOL ########################
if (!empty($_POST['viewCourseName'])) {
    $name = trim(strip_tags($_POST['viewCourseName']));
    if ($name == "") {
        $error = "Provide Name!";
    }
    else {
        try {
            if($courseDetails=$course->viewCourse($name)){
                echo "Id: " . $courseDetails->courseNumber;
                echo "\r\nName: " . $courseDetails->courseName;
                echo "Course credits: " . $courseDetails->courseCredits;
            }else{
                echo "No course with this number";
            }
        } catch (PDOException $e) {
            echo $e->getMessage();
        }
    }
}
$id = "";
$changeName = "";
$changeCredits = "";

########################  View STUDENT to form########################
if (!empty($_POST['changeCourseNumber'])) {
    $number = trim(strip_tags($_POST['changeCourseNumber']));
    if ($number == "") {
        $error = "Provide Number!";
    }
    else {
        try {
            if($courseDetailsNumber=$course->viewCourse($number)){
                $_SESSION['courseNumber'] = $courseDetailsNumber->courseNumber;
                $changeName = $courseDetailsNumber->courseName;
                $changeCredits = $courseDetailsNumber->courseCredits;
            }else{
                echo "No School with this name";
            }
        } catch (PDOException $e) {
            echo $e->getMessage();
        }
    }
}

########################  Change STUDENT ########################

if(!empty($_POST['changeCourseName2'])){
    $id = $_SESSION['courseNumber'];
    $name = trim(strip_tags($_POST['changeCourseName2']));
    $credit2 = trim(strip_tags($_POST['changeCourseCredit']));
    if ($name == ""){
        $error = "Provide Name!";
    }elseif ($credit2 = ""){
        $error = "Provide credit!";
    }
    try{
        $course->changeCourse($id, $name, $credit2);
    }catch (PDOException $e){
        echo $e->getMessage();
    }
}

########################  DELETE SCHOOL ########################
if (!empty($_POST['deleteCourseName'])) {
    $number = trim(strip_tags($_POST['deleteCourseName']));
    if ($number == "") {
        $error = "Provide Course Number!";
    }
    else {
        try {
            $course->deleteCourse($number);
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
<h1>Add New Course</h1>
<form method="post" action="" name="addCourseForm">
    <label>Add New Course</label>
    <input type="text" name="addCourseNumber" autocomplete="off" placeholder="Númer á braut"/>
    <input type="text" name="addCourseName" autocomplete="off" placeholder="Nafn á Braut"/>
    <input type="number" name="addCourseCredits" autocomplete="off" placeholder="Fjöldi eininga"/>
    <input type="submit" class="button" name="addCourse" value="Add New Course">
</form>

<h1>View Course</h1>
<form method="post" action="" name="ViewCourseForm">
    <label>View Course</label>
    <input type="text" name="viewCourseName" autocomplete="off" placeholder="Númer á braut"/>
    <input type="submit" class="button" name="ViewCourse" value="View Course">
</form>

<h1>Change Course</h1>
<form method="post" action="" name="changeCourseFormId">
    <label>Change School</label>
    <input type="text" name="changeCourseNumber" autocomplete="off" placeholder="Course Number"/>
    <input type="submit" class="button" name="changeCourseNumberForm" value="Get Course Information">
</form>

<form method="post" action="" name="changeCourseForm">
    <input type="text" name="changeCourseName2" autocomplete="off" <?php if(isset($_POST['changeCourseNumber'])){echo 'value="' . $changeName . '"';} ?>/>
    <input type="number" name="changeCourseCredit" autocomplete="off" <?php if(isset($_POST['changeCourseNumber'])){echo 'value="' . $changeCredits . '"';} ?>/>
    <input type="submit" class="button" name="changeCourse" value="Change Course Information">
</form>

<h1>Delete Course</h1>
<form method="post" action="" name="deleteCourseForm">
    <label>Delete School</label>
    <input type="text" name="deleteCourseName" autocomplete="off" placeholder="Course Number"/>
    <input type="submit" class="button" name="deleteCourse" value="Delete Course">
</form>
</body>
</html>