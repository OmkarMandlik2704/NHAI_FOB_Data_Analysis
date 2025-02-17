create database FOB_Analysis;
use fob_analysis;
select * from fob_data;

# 1.	Retrieve all incidents related to FOB issues
create view All_incidents_of_FOB as
select Reason_for_Avoiding_FOB from fob_data;

select * from All_incidents_of_FOB ;

# 2.	Count the number of locations where FOBs are too far from crossing points.
create view Locations_FOB_Too_Far_from_crossing_point as
select Reason_for_Avoiding_FOB, count(location) from fob_data
where  Reason_for_Avoiding_FOB ="FOB too far from crossing point"
group by Reason_for_Avoiding_FOB;

select * from Locations_FOB_Too_Far_from_crossing_point;

#3.	Identify the top 3 locations with the highest number of FOB-related complaints.
create view top_3_locations_High_fOB_Complains as
select Survey_Feedback, count(location) as Top__locations
from fob_data
where Survey_Feedback >= "3"
group by Survey_Feedback 
order by Top__locations DESC LIMIT 4;

ALTER TABLE fob_data
CHANGE COLUMN `Survey_Feedback (1-5)` `Survey_Feedback` INT;

select * from top_3_locations_High_fOB_Complains;

#4.	Find the total number of FOB complaints categorized by issue type (structural, behavioral, situational).
create view Structural_complaints_count as
SELECT COUNT(Reason_for_Avoiding_FOB) AS Structural_complaints
FROM fob_data  
WHERE Reason_for_Avoiding_FOB IN (
    'FOB is old, not maintained',
    'Poor lighting, unsafe at night',
    'FOB under construction',
    'Stairs are steep, no ramp',
    'No shelter during rain',
    'Crowded FOB, needs expansion'
);
create view Behavioral_Complaints_count as
SELECT COUNT(Reason_for_Avoiding_FOB) AS Behavioral_complaints
FROM fob_data  
WHERE Reason_for_Avoiding_FOB IN (
	'FOB is far from bus stop',
    'FOB too far from crossing point',
    'People ignore FOB, take risks',
    'People unaware of safety risks'
    );
create view Situational_Complaints_Count as
SELECT COUNT(Reason_for_Avoiding_FOB) AS Situational_complaints
FROM fob_data  
WHERE Reason_for_Avoiding_FOB IN (
	'No shelter during rain',
    'Poor lighting, unsafe at night'
    );
    
select * from Behavioral_Complaints_count ;
select * from Structural_complaints_count;
select * from Situational_Complaints_Count;

#5.Get the percentage of FOB issues that involve accessibility concerns.
create view percentage_of_FOB_issues_Of_accessibility_concerns as
SELECT 
    (COUNT(CASE WHEN Reason_for_Avoiding_FOB IN (
        'FOB is old, not maintained',
        'Stairs are steep, no ramp',
        'Poor lighting, unsafe at night',
        'No shelter during rain',
        'Crowded FOB, needs expansion'
    ) THEN 1 END) * 100.0 / COUNT(*)) AS Accessibility_Percentage
FROM fob_data;

# 6.List the locations where FOBs are in poor maintenance condition.
create view List_of_location_FOB_not_maintained as
SELECT Location, Reason_for_Avoiding_FOB 
FROM fob_data 
WHERE Reason_for_Avoiding_FOB = 'FOB is old, not maintained';

# 7.Find the most common reasons why pedestrians avoid using FOBs.
create view common_reasons_why_pedestrians_avoid_using_FOBs as
SELECT Reason_for_Avoiding_FOB, COUNT(*) AS Occurrence_Count
FROM fob_data
WHERE Reason_for_Avoiding_FOB IN (
    'FOB is old, not maintained',
    'Poor lighting, unsafe at night',
    'FOB under construction',
    'Stairs are steep, no ramp',
    'No shelter during rain',
    'Crowded FOB, needs expansion'
)
GROUP BY Reason_for_Avoiding_FOB
ORDER BY Occurrence_Count DESC;

#8.Identify the number of incidents where pedestrians requested additional FOBs. 
create view request_for_additional_Fob as
select count(Suggested_Improvement) from fob_data
where Suggested_Improvement = 'More FOBs at frequent spots' ;

#9.	Find the total number of accidents reported near FOBs due to non-usage.
create view Ciidennt_count_due_to_FOB_nonusage as
select Reason_for_Avoiding_FOB,count(Accident_Count)
from fob_data
where Reason_for_Avoiding_FOB ='People ignore FOB, take risks';

#10. List the top 3 cities with the most FOB safety concerns
create view Top_3_Cities_Safety_concerns as
SELECT Location, COUNT(*) AS Safety_Concern_Count
FROM fob_data
GROUP BY Location
ORDER BY Safety_Concern_Count DESC
LIMIT 3;

# 10. Get the trend of FOB-related complaints over the past 5 years.
create view FOB_complaints_over_past_5_Years as
SELECT YEAR(Date) AS Year, COUNT(*) AS Total_Complaints
FROM fob_data
WHERE Date >= DATE_SUB(CURDATE(), INTERVAL 5 YEAR)
GROUP BY Year
ORDER BY Year ASC;

#11.	Identify the locations where escalators or lifts are requested for FOBs
create view Request_for_Escalators_location as
select location , Suggested_Improvement
from fob_data
where Suggested_Improvement = 'Add escalators';
select * from Request_for_Escalators_location;

#12.	Count the number of suggestions for improving FOB accessibility (e.g., ramps, escalators).
create view No_of_suggestions_for_improving_FOB_Accessibility as
select count(Suggested_Improvement) as Suggestions_for_improving_FOB
from fob_data 
where Suggested_Improvement IN (
         'Add escalators',
         'Add roof & shelters',
         'Improve lighting, CCTV',
         'Renovate FOB',
         'Add roof & shelters',
         'Widen FOB, add escalator'
         )
order by Suggestions_for_improving_FOB;

#13.	Identify locations where pedestrian education programs could improve FOB usage.
create view Location_education_for_pedestrian as
select Location, Suggested_Improvement as Pedestrian_education_programs
from fob_data
where Suggested_Improvement='Awareness campaign needed';