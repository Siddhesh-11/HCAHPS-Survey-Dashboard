--select * from "postgres"."Hospital_Data".hospital_beds
--select * from "postgres"."Hospital_Data".hcahps_data
create table "postgres"."Hospital_Data".Tableau_File as

with hospital_beds_prep as
(
select lpad(cast(provider_ccn as text),6,'0') as provider_ccn
		,hospital_name
		,to_date(fiscal_year_begin_date, 'MM/DD/YYYY') as fiscal_year_begin_date
		,to_date(fiscal_year_end_date, 'MM/DD/YYYY') as fiscal_year_end_date
		,number_of_beds
		,row_number() over (partition by provider_ccn order by to_date(fiscal_year_end_date, 'MM/DD/YYYY') desc) as nth_row
from "postgres"."Hospital_Data".hospital_beds
)

select lpad(cast(facility_id as text),6,'0') as provider_ccn
		,to_date(start_date, 'MM/DD/YYYY') as start_date_converted
		,to_date(end_date, 'MM/DD/YYYY') as end_date_converted
		,hcaps.*
		,beds.number_of_beds
		,beds.fiscal_year_begin_date as beds_report_start_period
		,beds.fiscal_year_end_date as beds_report_end_period    
from "postgres"."Hospital_Data".hcahps_data as hcaps
left join hospital_beds_prep as beds
	on lpad(cast(facility_id as text),6,'0') = beds.provider_ccn 
and beds.nth_row = 1

