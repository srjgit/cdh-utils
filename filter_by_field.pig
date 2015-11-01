-- Usage : pig -f filter_by_field.pig -param input=/tmp/input/2015-08-30/ARS_1440988626_20150830.txt -param search_string=System
-- input param : location of input file, is a delimited file by '|' 
-- search_string param : keyword to search or filter upon
-- outputs the resulting records after filtering by search_string 
 
user_data = LOAD '$input' using PigStorage('|') as (category: chararray, rule_type: chararray, risk_category: chararray, risk_detail: chararray, risk_level: chararray,potential_impact: chararray, burt_id: chararray, risk_id: chararray, ontap: chararray, product_part_number: chararray, part_count: chararray, public: chararray, severity: chararray, eos_date: chararray, internal_info: chararray, more_info: chararray, error_detail: chararray, corrective_action: chararray, burt_link: chararray,  kb_article: chararray); 
sys_rows = FILTER user_data BY (category matches '.*${search_string}.*');
sys_rows1 = STREAM sys_rows  THROUGH `sed 's/\"//g'`;   -- eliminate surrounding quote chars 
--dump sys_rows1;
STORE sys_rows1 INTO 'demo_out_without_quots_cmd' USING PigStorage(',');

