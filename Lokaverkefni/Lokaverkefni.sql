use 0712982139_progresstracker_v1;

DROP PROCEDURE IF EXISTS ElectedCourses;

DELIMITER $$

CREATE PROCEDURE ElectedCourses(IN s_studentID INT)
  BEGIN
    DECLARE s_studentID char(11);
		DECLARE done int;
		DECLARE course_Number char(11);
		DECLARE course_Name int;
		DECLARE course_Credits int;
    DECLARE s_courses json;
		DECLARE s_info JSON;
		DECLARE json JSON;

		DEClARE json_cursor CURSOR FOR
			SELECT courseNumber, courseName, courseCredits FROM courses;

		DEClARE course_cursor CURSOR FOR
			SELECT courseNumber FROM studentcourses WHERE studentID = s_studentID;

		DECLARE CONTINUE HANDLER
		FOR NOT FOUND SET done = 1;

		SET json = JSON_OBJECT('semester', JSON_OBJECT('Kennitala', s_studentID, 'Courses', JSON_ARRAY()));

		OPEN json_cursor;
		json_loop: LOOP
			FETCH json_cursor INTO course_Number, course_Name, course_Credits;

			IF done = 1 THEN
				LEAVE json_loop;
			END IF;

			SET s_courses = JSON_ARRAY();

			OPEN course_cursor;
			courses_loop: LOOP
				FETCH course_cursor INTO course_Number;

				IF done = 1 THEN
					SET done = 0;
					LEAVE courses_loop;
				END IF;

				SET s_courses = JSON_ARRAY_APPEND(s_courses, '$', course_Number);

			END LOOP courses_loop;
			CLOSE course_cursor;

			SET s_info = JSON_OBJECT('kennitala', s_studentID, 'courses', s_courses);

			SET json = JSON_ARRAY_APPEND(json, '$.semester.students', s_info);

		END LOOP json_loop;
		CLOSE json_cursor;

		RETURN(json);

  END $$

DELIMITER ;

CALL ElectedCourses(0712982139);