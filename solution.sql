-- SELECT
-- 1. Selezionare tutti gli studenti nati nel 1990 (160)
SELECT `name`, `surname`
FROM `students`
WHERE `date_of_birth` LIKE '1990-%';
-- 2. Selezionare tutti i corsi che valgono più di 10 crediti (479)
SELECT * 
FROM `courses`
WHERE `cfu` > 10;
-- 3. Selezionare tutti gli studenti che hanno più di 30 anni
SELECT * 
FROM `students`
WHERE TIMESTAMPDIFF (YEAR, `date_of_birth`, CURDATE()) > 30;
-- 4. Selezionare tutti i corsi del primo semestre del primo anno di un qualsiasi corso di laurea (286)
SELECT * 
FROM `courses`
WHERE `period`= 'I semestre'
AND `year` = 1;
-- 5. Selezionare tutti gli appelli d'esame che avvengono nel pomeriggio (dopo le 14) del 20/06/2020 (21)
SELECT * 
FROM `exams`
WHERE `date` = '2020-06-20'
AND HOUR(`hour`) >= 14;
-- 6. Selezionare tutti i corsi di laurea magistrale (38)
SELECT * 
FROM `degrees`
WHERE `level` = 'magistrale';
-- 7. Da quanti dipartimenti è composta l'università? (12)
SELECT COUNT(*) AS `tot_departments` 
FROM `departments`;
-- 8. Quanti sono gli insegnanti che non hanno un numero di telefono? (50)
SELECT COUNT(*) AS 'teachers without phone' 
FROM `teachers`
WHERE `phone` IS NULL;

-- GROUP BY
-- 1. Contare quanti iscritti ci sono stati ogni anno
SELECT YEAR(`enrolment_date`) AS `year_of_registration`, COUNT(*) AS `n_registered`
FROM `students`
GROUP BY `year_of_registration`;
-- 2. Contare gli insegnanti che hanno l'ufficio nello stesso edificio
SELECT `office_address`,  COUNT(*) AS `n_teachers` 
FROM `teachers`
GROUP BY `office_address`;
-- 3. Calcolare la media dei voti di ogni appello d'esame
SELECT ROUND(AVG(`vote`)) AS `point_average`, `exam_id`
FROM `exam_student`
GROUP BY `exam_id`;
-- 4. Contare quanti corsi di laurea ci sono per ogni dipartimento
SELECT COUNT(*) AS `n_courses`, `department_id`
FROM `degrees`
GROUP BY `department_id`;

-- JOIN
-- 1. Selezionare tutti gli studenti iscritti al Corso di Laurea in Economia
SELECT D.`name`, S.`name`, S.`surname`
FROM `students` AS S
JOIN `exam_student` AS ES
ON S.`id` = ES.`student_id`
JOIN `exams` AS E 
ON E.`id` = ES.`exam_id`
JOIN `courses` AS C
ON C.`id` = E.`course_id`
JOIN `degrees` AS D 
ON D.`id` = C.`degree_id` 
WHERE D.`name` = 'Corso di Laurea in Economia';
-- 2. Selezionare tutti i Corsi di Laurea del Dipartimento di Neuroscienze
SELECT * 
FROM `degrees` AS DEG
JOIN `departments` AS DEP 
ON DEP.`id` = DEG.`department_id`
WHERE DEP.`name` = 'Dipartimento di Neuroscienze';
-- 3. Selezionare tutti i corsi in cui insegna Fulvio Amato (id=44)
SELECT C.`name`, T.`name`, T.`surname`, CT.`teacher_id`
FROM `course_teacher` AS CT
JOIN `teachers` AS T 
ON T.`id` = CT.`teacher_id`
JOIN `courses` AS C 
ON C.`id` = CT.`course_id`
WHERE T.`surname` = 'Amato'
AND T.`name` = 'Fulvio';
-- 4. Selezionare tutti gli studenti con i dati relativi al corso di laurea a cui sono iscritti e il relativo dipartimento, in ordine alfabetico per cognome e nome
SELECT DEP.`name`, DEG.`name`, S.`name`, S.`surname`
FROM `students` AS S
JOIN `exam_student` AS ES
ON S.`id` = ES.`student_id`
JOIN `exams` AS E 
ON E.`id` = ES.`exam_id`
JOIN `courses` AS C
ON C.`id` = E.`course_id`
JOIN `degrees` AS DEG 
ON DEG.`id` = C.`degree_id` 
JOIN `departments` AS DEP 
ON DEP.`id` = DEG.`department_id`
ORDER BY S.`surname` ASC;
-- 5. Selezionare tutti i corsi di laurea con i relativi corsi e insegnanti
SELECT  D.`name`, C.`name`,T.`name`, T.`surname` 
FROM `degrees` AS D
JOIN `courses` AS C
ON D.`id` = C.`degree_id`
JOIN `course_teacher` AS CT
ON C.`id` = CT.`course_id` 
JOIN `teachers` AS T 
ON T.`id` = CT.`teacher_id`;
-- 6. Selezionare tutti i docenti che insegnano nel Dipartimento di Matematica (54)
SELECT  DEP.`name`, T.`name`, T.`surname`
FROM `departments` AS DEP 
JOIN `degrees` AS DEG 
ON DEP.`id` = DEG.`department_id` 
JOIN `courses`AS C 
ON DEG.`id` = C.`degree_id`
JOIN `course_teacher` AS CT 
ON C.`id` = CT.`course_id`
JOIN `teachers` AS T
ON T.`id` = CT.`teacher_id`
WHERE DEP.`name` = 'Dipartimento di Matematica';
-- 7. BONUS: Selezionare per ogni studente quanti tentativi d’esame ha sostenuto per superare ciascuno dei suoi esami