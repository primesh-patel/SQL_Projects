SELECT * FROM insurance_data;

-- 1, top five patients who claimed the highest insurence amounts.
SELECT *,
DENSE_RANK() OVER(ORDER BY claim DESC) AS position
FROM insurance_data
LIMIT 5;

-- 2, the average insurance claimed by patients based on the no of children they have.
SELECT children, average_claim, row_no
FROM (SELECT *,
AVG(claim) OVER (PARTITION BY children) AS average_claim,
ROW_NUMBER () OVER (PARTITION BY children) AS row_no
FROM insurance_data) t
WHERE t.row_no = 1;


-- 3, the highest and lowest claimed amount by patients in each reason.
SELECT region, min_claim, max_claim
FROM (SELECT *,
MIN(claim) OVER (PARTITION BY region) AS min_claim,
MAX(claim) OVER (PARTITION BY region) AS max_claim,
ROW_NUMBER() OVER (PARTITION BY region) AS row_no
FROM insurance_data) t
WHERE t.row_no = 1;

-- 4, the percentage of smokers in each group. 


-- 5, the difference between the claimed amount of each patient and the claimed amount of the first patient. 
SELECT *,
claim - FIRST_VALUE(claim) OVER() AS diff
FROM insurance_data;

-- 6, for each patient, the difference between their claimed amount
-- and the average amount claimed amount of patients with the same no of children.
SELECT *,
claim - AVG(claim) OVER(PARTITION BY children) AS diff
FROM insurance_data;


-- 7, the patient with the highest BMI in each region and their respective over all rank. 
SELECT * FROM (SELECT *,
RANK() OVER(PARTITION BY region ORDER BY bmi DESC) AS group_rank,
RANK() OVER(ORDER BY bmi DESC) AS overall_rank
FROM insurance_data) t
WHERE t.group_rank = 1;

-- 8, the difference between the claimed amount of each patient and the claimed amount of
-- the patient who has the highest bmi in their region. 
SELECT *,
claim - FIRST_VALUE(claim) OVER(PARTITION BY region ORDER BY bmi DESC)
FROM insurance_data;


-- 9, for each patient, calculate the difference in claim amount between the 
-- patient and the patient with the highest claim amount among patients with 
-- the smoker status within the same region. return the result in descending order difference.
 SELECT *,
 (MAX(claim) OVER(PARTITION BY region, smoker) - claim ) AS claim_diff
 FROM insurance_data
 ORDER BY claim_diff DESC;
 
 -- 10, for each patient, the maximum BMI value among their next three records
 -- (ordered by age).
 SELECT *,
 MAX(bmi) OVER (ORDER BY age ROWS BETWEEN 1 FOLLOWING AND 3 FOLLOWING)
 FROM insurance_data;
 
 
 -- 11, for each patient, find the rolling average of the last two claims. 
 SELECT *,
 AVG(claim) OVER(ROWS BETWEEN 2 PRECEDING AND 1 PRECEDING)
 FROM insurance_data;
 
 
 -- 12, the first claimed insurance value for male and female patient,
 -- within each region order the data by patient age in ascending order,
 -- and only include patients who are non-diabetic and have BMI value between 25 and 30.
 WITH filtered_data AS (
   SELECT * FROM insurance_data
   WHERE diabetic = 'No' AND bmi BETWEEN 25 AND 30
 )
 
 SELECT * FROM ( SELECT *,
 FIRST_VALUE(claim) OVER(PARTITION BY region, gender ORDER BY age),
 ROW_NUMBER () OVER(PARTITION BY region, gender ORDER BY age) AS row_no
 FROM filtered_data) t
 WHERE t.row_no = 1;