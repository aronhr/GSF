# New Student

use Verkefni_4;

DELIMITER $$

CREATE PROCEDURE `newStudent`(IN `s_studentID` INT(11), IN `s_studentName` VARCHAR(255), IN `s_trackID` INT, IN `s_semester_ID` INT)
  BEGIN
    INSERT INTO Verkefni_4.students (studentID, studentName, trackID, semester_ID) VALUES (s_studentID, s_studentName, s_trackID, s_semester_ID);
  END $$

DELIMITER ;

CALL newStudent(1304982049, 'Adam Bæhrenz', 9, 5);


# Select Student

use Verkefni_4;

DELIMITER $$

CREATE PROCEDURE `selectStudent`(IN `s_studentID` INT(11))
  BEGIN
    SELECT * FROM students WHERE studentID = s_studentID;
  END $$

DELIMITER ;

CALL selectStudent(1304982049);


# Update student


use Verkefni_4;

DELIMITER $$

CREATE PROCEDURE `changeStudent`(IN `s_studentID` INT(11), IN `s_studentName` VARCHAR(255), IN `s_trackID` INT, IN `s_semester_ID` INT)
  BEGIN
    UPDATE Verkefni_4.students SET studentName = s_studentName, trackID = s_trackID, semester_ID = s_semester_ID WHERE students.studentID = s_studentID;
  END $$

DELIMITER ;

CALL changeStudent(1304982049, 'Adam', 7, 8);


# Delete Student

use Verkefni_4;

DELIMITER $$

CREATE PROCEDURE `deleteStudent`(IN `s_studentID` INT(11))
  BEGIN
    DELETE FROM Verkefni_4.students WHERE students.studentID = s_studentID;
  END $$

DELIMITER ;

CALL deleteStudent(1304982049);


####################################### SCHOOL #######################################


# New School

use Verkefni_4;

DELIMITER $$

CREATE PROCEDURE `newSchool`(IN `s_schoolName` VARCHAR(255))
  BEGIN
    INSERT INTO Verkefni_4.schools (schoolName) VALUES (s_schoolName);
  END $$

DELIMITER ;

CALL newSchool('Menntaskólinn í Reykjavík');

#Veiw School

use Verkefni_4;

DELIMITER $$

CREATE PROCEDURE `viewSchool`(IN `s_name` VARCHAR(255))
  BEGIN
    SELECT * FROM `schools` WHERE schoolName = s_name;
  END $$

DELIMITER ;

CALL viewSchool('Menntaskólinn í Reykjavík');

# ChangeSchool

use Verkefni_4;

DELIMITER $$

CREATE PROCEDURE `changeSchool`(IN `s_id` INT, IN `s_name` VARCHAR(255))
  BEGIN
    UPDATE `Verkefni_4`.`schools` SET `schoolName` = s_name WHERE `schools`.`schoolID` = s_id;
  END $$

DELIMITER ;

CALL changeSchool(5, 'Skólinn');

#delete School

use Verkefni_4;

DELIMITER $$
CREATE PROCEDURE `deleteSchool`(IN `s_schoolID` INT)
  BEGIN
    DELETE FROM `Verkefni_4`.`schools` WHERE `schools`.`schoolID` = s_schoolID;
  END $$

DELIMITER ;

CALL deleteSchool(3);

# new course

USE Verkefni_4;

DELIMITER $$

CREATE PROCEDURE `newCourse`(IN `s_courseNumber` VARCHAR(25), IN `s_courseName` VARCHAR(255), IN `s_courseCredits` INT)
BEGIN
  INSERT INTO `Verkefni_4`.`courses` (`courseNumber`, `courseName`, `courseCredits`) VALUES (s_courseNumber, s_courseName, s_courseCredits);
END $$

DELIMITER ;

# SelectCourse

use Verkefni_4;

DELIMITER $$

CREATE PROCEDURE `selectCourse`(IN `s_courseNumber` VARCHAR(25))
BEGIN
  SELECT * FROM `courses`WHERE courseNumber = s_courseNumber;
END $$

DELIMITER ;


#Update course

use Verkefni_4;

DELIMITER $$

CREATE PROCEDURE `changeCourse`(IN `s_courseNumber` VARCHAR(25), IN `s_courseName` VARCHAR(255), IN `s_courseCredits` INT)
  BEGIN
    UPDATE `Verkefni_4`.`courses` SET `courseNumber` = s_courseNumber, `courseName` = s_courseName, `courseCredits` = s_courseCredits WHERE `courses`.`courseNumber` = s_courseNumber;
  END $$

DELIMITER ;


#Delete Course

use Verkefni_4;

DELIMITER $$

CREATE PROCEDURE `deleteCourse`(IN `s_courseNumber` VARCHAR(25))
  BEGIN
    DELETE FROM `Verkefni_4`.`courses` WHERE `courses`.`courseNumber` = s_courseNumber;
  END $$

DELIMITER ;









