-- ********************** -- Skrifið eftirfarandi stored procedures: --**********************

-- 1:	CourseList()
-- Birtir lista(yfirlit) af öllum áföngum sem geymdir eru í gagnagrunninum.
-- Áfangarnir eru birtir í stafrófsröð 

use 0712982139_progresstracker_v1;

DELIMITER $$

DROP PROCEDURE IF EXISTS `CourseList` $$

CREATE PROCEDURE CourseList()

BEGIN
  SELECT * FROM `0712982139_progresstracker_v1`.courses;
END $$

DELIMITER ;

CALL CourseList();

-- 2:	SingleCourse()
-- 	Birtir upplýsingar um einn ákveðin kúrs.
--  Færibreytan er áfanganúmerið

use 0712982139_progresstracker_v1;

DELIMITER $$

DROP PROCEDURE IF EXISTS `SingleCourse` $$

CREATE PROCEDURE SingleCourse(IN course_Number VARCHAR(255))

BEGIN
  SELECT * FROM `0712982139_progresstracker_v1`.courses WHERE courseNumber = course_Number;
END $$

DELIMITER ;

CALL SingleCourse('FOR35GU');

-- 3:   NewCourse()
--  Nýskráir áfanga í gagnagrunninn.
--  Skoðið ERD myndina til að finna út hvaða gögn á að vista(hvaða færibreytur á að nota)
--  NewCourse er með out parameterinn number_of_inserted_rows sem skilar fjölda þeirra
--  raða sem vistaðar voru í gagnagrunninum.  Til þess notið þið MySQL function: row_count()

use 0712982139_progresstracker_v1;

DELIMITER $$

DROP PROCEDURE IF EXISTS `NewCourse` $$

CREATE PROCEDURE NewCourse(IN course_Number VARCHAR(255), IN course_Name VARCHAR(255), IN course_Credits INT)

BEGIN
  INSERT INTO `0712982139_progresstracker_v1`.courses (courseNumber, courseName, courseCredits) VALUES (course_Number, course_Name, course_Credits);
END $$

DELIMITER ;

CALL NewCourse('FOR35GU', 'Leikjaforritun', 3);



-- 4:	UpdateCourse()
--  Hér eru notaðar sömu færibreytur og í lið 3.  Áfanganúmerið er notað til að uppfæra réttan kúrs.alter
-- row_count( fallið er hér notað líka.

use 0712982139_progresstracker_v1;

DELIMITER $$

DROP PROCEDURE IF EXISTS `UpdateCourse` $$

CREATE PROCEDURE UpdateCourse(IN old_course_Number VARCHAR(255),IN course_Number VARCHAR(255), IN course_Name VARCHAR(255), IN course_Credits INT)

BEGIN
  UPDATE  0712982139_progresstracker_v1.courses SET  courseNumber =  course_Number, courseName =  course_Name, courseCredits = course_Credits  WHERE  courses.courseNumber =  old_course_Number;
END $$

DELIMITER ;

CALL UpdateCourse('FOR35Gh','FOR35GU', 'Leikjaforritun 2', 3);


-- 5:	DeleteCourse()
-- Áfanganúmer(courseNumber) er notað hérna til að eyða réttum kúrs.
-- ATH: Ef verið er að nota kúrsinn einhversstaðar(sé hann skráður á TrackCourses) þá má EKKI eyða honum.
-- Sé hins vegar hvergi verið að nota hann má eyða honum úr Courses töflunni og einnig Restrictors töflunni.alter
-- sem fyrr er out parameter notaður til að "skila" fjölda þeirra raða sem eytt var úr töflunni Courses

## DELETE FROM `0712982139_progresstracker_v1`.`courses` WHERE `courses`.`courseNumber` = 'FOR3G3U'

use 0712982139_progresstracker_v1;

DELIMITER $$

DROP PROCEDURE IF EXISTS `DeleteCourse` $$

CREATE PROCEDURE DeleteCourse(IN course_Number VARCHAR(255))

BEGIN
 DELETE FROM 0712982139_progresstracker_v1.courses WHERE courses.courseNumber = course_Number;
END $$

DELIMITER ;

CALL DeleteCourse('STÆ703');


-- ********************** -- Skrifið eftirfarandi functions: --**********************

-- 6:	NumberOfCourses()
-- fallið skilar heildarfjölda allra áfanga í grunninum

use 0712982139_progresstracker_v1;

DELIMITER $$

DROP FUNCTION IF EXISTS NumberOfCourses $$

CREATE FUNCTION NumberOfCourses()

RETURNS INT(11)

BEGIN
RETURN(SELECT COUNT(courseNumber) FROM courses);
END $$

DELIMITER ;

SELECT NumberOfCourses();



-- 7:	TotalTRackCredits()
--  Fallið skilar heildar einingafjölda ákveðinnar námsbrautar(track)
--  Senda þarf trackID inn sem færibreytu

use 0712982139_progresstracker_v1;

DELIMITER $$

DROP FUNCTION IF EXISTS TotalTRackCredits;

CREATE FUNCTION TotalTRackCredits(track_ID INT)

RETURNS INT(11)

BEGIN
    RETURN(SELECT COUNT(*) FROM TrackCourses WHERE trackID = track_ID);
END $$

DELIMITER ;

SELECT TotalTRackCredits(9);

-- 8:   HighestCredits()
-- Fallið skilar einingafjölda þess námskeiðs(þeirra námskeiða) sem hafa flestar eininar.
-- ATH:  Það geta fleiri en einn kúrs verið með sama einingafjöldann. :að á ekki að hafa 
-- áhfri á niðurstöðuna.

use 0712982139_progresstracker_v1;

DELIMITER $$

DROP FUNCTION IF EXISTS HighestCredits;

CREATE FUNCTION HighestCredits()

RETURNS INT(11)

BEGIN
    RETURN(SELECT MAX(courseCredits) FROM Courses);
END $$

DELIMITER ;

SELECT HighestCredits();


-- 9:  TopTracksDivision()
-- Fallið skilað toppfjölda námsbrauta(tracks) sem tilheyra námsbrautum(Divisions)

use 0712982139_progresstracker_v1;

DELIMITER $$

DROP FUNCTION IF EXISTS TopTracksDivision;

CREATE FUNCTION TopTracksDivision()

RETURNS INT(11)

BEGIN
    RETURN(SELECT COUNT(*) AS Track_Count FROM Tracks GROUP BY divisionID ORDER BY Track_Count DESC LIMIT 1);
END $$

DELIMITER ;

SELECT TopTracksDivision();


-- 10:  leastRestrictedCourseNumber()
-- Fallið skilar minnsta fjölda kúrsa í Restrictors töflunni.
-- ATH:  Ef kúrs eða kúrsar eru t.d. með einn undanfara þog ekkert meir þá myndi fallið skila 1

use 0712982139_progresstracker_v1;

DELIMITER $$

DROP FUNCTION IF EXISTS leastRestrictedCourseNumber;

CREATE FUNCTION leastRestrictedCourseNumber()

RETURNS INT(11)

BEGIN
    RETURN(SELECT COUNT(*) AS Course_Count FROM Restrictors GROUP BY courseNumber ORDER BY Course_Count ASC LIMIT 1);
END $$

DELIMITER ;

SELECT leastRestrictedCourseNumber();
