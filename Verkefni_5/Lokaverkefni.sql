/*
Skrifið Stored Procedure EN: ElectedCourses / IS: MittVal.

Kalla skal á þennan SP með nemendanúmeri og hann skilar til baka vali fyrir næstu önn.

[x] 1:  Það má alveg takmarka fjölda áfnaga við t.d. 5 eða einhvern max einingafjölda/feiningafjölda.
[x] 2:  SP þarf að finna þessa áfanga útfrá óloknum áföngum. Skoða þarf hvaða áfangar koma næst sé það hægt.
[x] 3:  Ekki þarf að kanna fall í núverandi áföngum(þeir áfangar sem nemandinn er í en hefur ekki klárað þegar val fer fram).
[x] 4:  Ef allt klikkar þá velur SP random úr þeim áföngum sem nemandinn á eftir að taka.

 */

use 0712982139_progresstracker_v1;

DROP procedure IF EXISTS ElectedCourses;

DELIMITER $$

CREATE PROCEDURE ElectedCourses (IN s_studentID int(11))

BEGIN

  DECLARE fails INT ;
  DECLARE courseLimit INT ;

  # Ath ef nemandi hafi fallið á önn
  SET fails = (SELECT COUNT(courseNumber)
                      FROM studentcourses
                        JOIN students ON students.studentID = studentcourses.studentID
                          WHERE studentcourses.grade <= 4
                            AND studentcourses.semesterID = (students.semester_ID - 1)
                              AND students.studentID = s_studentID);

# Ef nemandi féll í 5 eða fleiri fögum fær hann ekki að skrá sig á næstu önn
IF(fails >= 5) THEN
	SET courseLimit = 0;
  SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Nemandi féll á önn. Nemandi hefur ekki heimild til að skrá sig á næstu önn.';
    END IF;

# Ef nemandi féll í 4 eða færri fögum fær hann 5 áfanga á næstu önn
IF(fails < 5) THEN
	SET courseLimit = 6;
    END IF;

# Nær í courseNumber, courseName og courseCredits og byrtir ekki áfanga sem nemandi hefur náð.
# Ef nemandi hefur fengið 4 eða lægra í áfanga byrtist hann aftur í þessari skipun þar sem nemandi náði ekki áfanganum.
SELECT courseNumber, courseName, courseCredits
     FROM courses
       WHERE NOT EXISTS
         (SELECT courseNumber
           FROM studentcourses
             WHERE studentcourses.courseNumber = courses.courseNumber AND studentcourses.grade >= 5 AND studentcourses.studentID = s_studentID )ORDER BY RAND() LIMIT courseLimit;


END $$

DELIMITER ;

# Nemandi sem hefur fallið í 5 fögum (Fær villu!).
Call ElectedCourses(0712982139);

# Nemandi sem hefur fallið í STÆ203 en féll ekki á önn.
CALL ElectedCourses(1304982059);