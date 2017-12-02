use 0712982139_progresstracker_v1;

DROP FUNCTION IF EXISTS progressTrackerToJSON;
DELIMITER $$

CREATE FUNCTION progressTrackerToJSON(semID int) RETURNS JSON
BEGIN
	DECLARE cur_studentID char(10); -- kennitala
	DECLARE cur_studentName varchar(255);
	DECLARE v_finished INTEGER DEFAULT 0;
    DECLARE cur_course char(10);
    DECLARE cur_trackID int;
    DECLARE sem_name char(10);
    DECLARE student_courses JSON;
    DECLARE student_info JSON;

    DECLARE j JSON;

	DEClARE json_cursor CURSOR FOR
		SELECT studentID, studentName, trackID FROM Students;

	DEClARE course_cursor CURSOR FOR
		SELECT courseNumber FROM StudentCourses
			WHERE studentID = cur_studentID AND semesterID = semID;

	-- declare NOT FOUND handler
	DECLARE CONTINUE HANDLER
		FOR NOT FOUND SET v_finished = 1;

	SET sem_name = (SELECT semesterName FROM Semesters WHERE semesterID = semID);

	SET j = JSON_OBJECT('semester', JSON_OBJECT('name', sem_name, 'students', JSON_ARRAY()));

	OPEN json_cursor;
		json_loop: LOOP

			FETCH json_cursor INTO cur_studentID, cur_studentName, cur_trackID;

			IF v_finished = 1 THEN
				LEAVE json_loop;
			END IF;

            SET student_courses = JSON_ARRAY();

			OPEN course_cursor;
				courses_loop: LOOP

					FETCH course_cursor INTO cur_course;

					IF v_finished = 1 THEN
						SET v_finished = 0;
						LEAVE courses_loop;
					END IF;

                    SET student_courses = JSON_ARRAY_APPEND(student_courses, '$', cur_course);



				END LOOP courses_loop;
			CLOSE course_cursor;

			SET student_info = JSON_OBJECT('ID', cur_studentID, 'studentName', cur_studentName,
            'trackID', cur_trackID, 'courses', student_courses);

            SET j = JSON_ARRAY_APPEND(j, '$.semester.students', student_info);

        END LOOP json_loop;
	CLOSE json_cursor;

    RETURN(j);


END $$

DELIMITER ;

SELECT progressTrackerToJSON('6');