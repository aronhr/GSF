-- 1.
--  Hannið viðbætur við ProgressTracker gagnagrunninn þannig að nú sé hægt að skrá nemanda og að
--  sá nemandi geti valið sér námsleið(innan námsbrautar).

use 0712982139_progresstracker_v1;

DROP TABLE IF EXISTS students;

CREATE TABLE students
(
	studentID INT,
    studentName VARCHAR(255),
    trackID INT,
    CONSTRAINT studentID PRIMARY KEY (studentID),
	constraint student_track_FK FOREIGN KEY (trackID) REFERENCES Tracks(trackID)
);

INSERT INTO Students(studentID, studentName, trackID) VALUES ('0712982139', 'Aron Hrafnsson', 9);
INSERT INTO Students(studentID, studentName, trackID) VALUES ('1304982499', 'Adam Bæhrenz', 9);
INSERT INTO Students(studentID, studentName, trackID) VALUES ('1803982799', 'Alexandra Jóný', 8);

-- 2.
--  Skrifið trigger fyrir insert aðgerð í töfluna Restrictors. Triggerinn kemur í veg fyrir að
--  courseNumber og RestrictorID séu sami kúrsinn. Sé um sama kúrs að ræða, kastar triggerinn villu,
--  skrifar út villutexta og kemur í veg fyrir insert. Dæmi um insert sem triggerinn stoppar:
--  insert into Restrictors values('GSF2B3U','GSF2B3U',1);

use 0712982139_progresstracker_v1;

DROP TRIGGER IF EXISTS Restrictors_insert;

DELIMITER $$

CREATE TRIGGER Restrictors_insert BEFORE INSERT ON Restrictors

FOR EACH ROW

BEGIN
	IF NEW.courseNumber = NEW.restrictorID THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Ekki er haegt ad skra i gagnagrunn. courseNumber og RestrictorID er sami kúrsinn';
    END IF;
END $$

DELIMITER ;

insert into Restrictors values('GSF2B3U','GSF2B3U',1);

-- 3.
--	Skrifið samskonar trigger fyrir update aðgerð í töfluna Restrictors.

use 0712982139_progresstracker_v1;

DROP TRIGGER IF EXISTS Restrictors_update;

DELIMITER $$

CREATE TRIGGER Restrictors_update BEFORE UPDATE ON Restrictors

FOR EACH ROW

BEGIN
	IF NEW.courseNumber = NEW.restrictorID THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Ekki er haegt ad skra i gagnagrunn. courseNumber og RestrictorID er sami kúrsinn';
    END IF;
END $$

DELIMITER ;

insert into Restrictors values('GSF2B3U','GSF2B3U',1);

-- 4.
--	Skrifið stored procedure sem leggur saman allar einingar sem nemandinn hefur lokið á ákv.
--	námskeiðum.
--	ATH:
--	Á tölvubrautinni tilheyra almennu fögin strangt til tekið Tæknimenntaskólanum(NTT13
--	Náttúrufræðibraut tölvutækni). Það þýðir að hafi nemandi lokið fjórum þriggja eininga áföngum í
--	t.d. eðlisfræði og stærðfræði og fimm þriggja eininga kúrsum á tölvubraut þá fæst eitthvað svona:
--	 NTT13 12
--	 TBR16 15
--	Aðeins skal velja áfanga þar sem einkunn er >= 5.
--	Sé verið að nota staðið/fallið þá skal velja "staðið".

use 0712982139_progresstracker_v1;

DROP PROCEDURE IF EXISTS StudentProgress;

DELIMITER $$

CREATE PROCEDURE StudentProgress(IN sID char(10))
BEGIN
    SELECT Tracks.trackName, sum(Courses.courseCredits) as totalCredits
    FROM StudentCourses
    INNER JOIN Courses
    ON StudentCourses.courseNumber = Courses.courseNumber
	INNER JOIN TrackCourses
    ON Courses.courseNumber = TrackCourses.courseNumber
	INNER JOIN Tracks
    ON TrackCourses.trackID = Tracks.trackID
    INNER JOIN Students
    ON Students.studentID = StudentCourses.studentID
    WHERE StudentCourses.grade >= 5 AND StudentCourses.studentID = sID
    GROUP BY Tracks.trackName;
END $$

DELIMITER ;

call StudentProgress('0712982139');



-- 5.
--	Skrifið cursor sem sækir alla skylduáfanga sem nemandi þarf að taka og setur þá í töfluna sem
--	geymir áfanga sem hann hefur valið. Setjið cursorinn í stored procedure sem gæti heitið eitthvað
--	"AddMandtoryCourses” og er keyrður þegar nemandinn velur sér námsleið(sú aðgerð gæti verið í
--	SP sem heitir "NewStudent”)