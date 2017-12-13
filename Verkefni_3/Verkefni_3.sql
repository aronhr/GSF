use 0712982139_progresstracker_v1;

DROP FUNCTION IF EXISTS progressTrackerJSON;
DELIMITER $$

CREATE FUNCTION progressTrackerJSON(s_ID int) RETURNS JSON
	BEGIN
		DECLARE s_studentID char(11);
		DECLARE s_studentName varchar(255);
		DECLARE done int;
		DECLARE c_course char(11);
		DECLARE c_trackID int;
		DECLARE s_name char(11);
		DECLARE s_courses JSON;
		DECLARE s_info JSON;
		DECLARE json JSON;

		DEClARE json_cursor CURSOR FOR
			SELECT studentID, studentName, trackID FROM students;

		DEClARE course_cursor CURSOR FOR
			SELECT courseNumber FROM studentcourses WHERE studentID = s_studentID AND semesterID = s_ID;

		DECLARE CONTINUE HANDLER
		FOR NOT FOUND SET done = 1;

		SET s_name = (SELECT semesterName FROM semesters WHERE semesterID = s_ID);
		SET json = JSON_OBJECT('semester', JSON_OBJECT('name', s_name, 'students', JSON_ARRAY()));

		OPEN json_cursor;
		json_loop: LOOP
			FETCH json_cursor INTO s_studentID, s_studentName, c_trackID;

			IF done = 1 THEN
				LEAVE json_loop;
			END IF;

			SET s_courses = JSON_ARRAY();

			OPEN course_cursor;
			courses_loop: LOOP
				FETCH course_cursor INTO c_course;

				IF done = 1 THEN
					SET done = 0;
					LEAVE courses_loop;
				END IF;

				SET s_courses = JSON_ARRAY_APPEND(s_courses, '$', c_course);

			END LOOP courses_loop;
			CLOSE course_cursor;

			SET s_info = JSON_OBJECT('ID', s_studentID, 'studentName', s_studentName, 'trackID', c_trackID, 'courses', s_courses);

			SET json = JSON_ARRAY_APPEND(json, '$.semester.students', s_info);

		END LOOP json_loop;
		CLOSE json_cursor;

		RETURN(json);

	END $$

DELIMITER ;

SELECT progressTrackerJSON(5);