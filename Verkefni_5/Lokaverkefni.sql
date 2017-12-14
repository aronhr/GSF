use 0712982139_progresstracker_v1;

DROP PROCEDURE IF EXISTS ElectedCourses;

DELIMITER $$

CREATE PROCEDURE ElectedCourses(IN s_studentID INT(11))

BEGIN
	SELECT courseNumber, courseName, courseCredits
     FROM courses
       WHERE NOT EXISTS
         (SELECT courseNumber
           FROM studentcourses
             WHERE studentcourses.courseNumber = courses.courseNumber AND studentcourses.studentID = s_studentID )ORDER BY RAND() LIMIT 5 ;
END $$

DELIMITER ;

CALL ElectedCourses(0712982139);