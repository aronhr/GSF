/*
Skrifið Stored Procedure EN: ElectedCourses / IS: MittVal.

Kalla skal á þennan SP með nemendanúmeri og hann skilar til baka vali fyrir næstu önn.

[x] 1:  Það má alveg takmarka fjölda áfnaga við t.d. 5 eða einhvern max einingafjölda/feiningafjölda.
[x] 2:  SP þarf að finna þessa áfanga útfrá óloknum áföngum. Skoða þarf hvaða áfangar koma næst sé það hægt.
[x] 3:  Ekki þarf að kanna fall í núverandi áföngum(þeir áfangar sem nemandinn er í en hefur ekki klárað þegar val fer fram).
[x] 4:  Ef allt klikkar þá velur SP random úr þeim áföngum sem nemandinn á eftir að taka.
*/


use 0712982139_progresstracker_v1;

DROP PROCEDURE IF EXISTS ElectedCourses;

DELIMITER $$

CREATE PROCEDURE ElectedCourses(IN s_studentID INT(11))
BEGIN
  DECLARE counting INT;
  DECLARE limit_q INT;

  SET counting = (SELECT count(courseNumber) FROM studentcourses WHERE studentcourses.studentID = s_studentID);

  IF(counting >= 1) THEN
	SET limit_q = 5;
    END IF;

  IF(counting = 0) THEN
    set limit_q = 5;
      END IF;

	SELECT courseNumber, courseName, courseCredits
     FROM courses
       WHERE NOT EXISTS
         (SELECT courseNumber
           FROM studentcourses
             WHERE studentcourses.courseNumber = courses.courseNumber AND studentcourses.studentID = s_studentID )ORDER BY RAND() LIMIT limit_q ;


END $$

DELIMITER ;

CALL ElectedCourses(0712980139);