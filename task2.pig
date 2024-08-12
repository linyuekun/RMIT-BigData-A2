-- Load cust_order.csv and order_line.csv
cust_order = LOAD 'hdfs:///input/cust_order.csv' USING PigStorage(',') as (
    order_id:int,
    order_date:chararray,
    customer_id:int,
    shipping_method_id:int,
    dest_address_id:int
);

order_line = LOAD 'hdfs:///input/order_line.csv' USING PigStorage(',') as (
    line_id:int,
    order_id:int,
    book_id:int,
    price:float
);

-- Filter out the header row (skip the first row)
cust_order = FILTER cust_order BY order_id > 0;
order_line = FILTER order_line BY order_id > 0;

-- Remove double quotes
clean_cust_order = FOREACH cust_order GENERATE
    order_id, 
    REPLACE(order_date, '\\"', '') as order_date, 
    customer_id, shipping_method_id, 
    dest_address_id;

-- Format date and retrieve only necessary data
-- Add brackets and use only M and d to avoid 0 in front of single-digit day and month
cust_order_data = FOREACH cust_order GENERATE
    ToString(ToDate(REPLACE(order_date, '\\"', ''), 'yyyy-MM-dd HH:mm:ss'), '(yyyy,M,d)') 
    as order_date,
    order_id;

-- Join cust_order and order_line with order_id
joined_data = JOIN cust_order_data by order_id, order_line by order_id;

-- Register python UDF
REGISTER 'hdfs:///input/note.py' USING streaming_python as myfuncs;

-- Group the data by order_date
grouped_data = GROUP joined_data by order_date;

-- Select only necessary data for result
-- Each row is for a particular date
-- Count number of books for each row
-- Count unique orders for each row
-- Calculate total price for each row
result = FOREACH grouped_data {
    unique_orders = DISTINCT joined_data.cust_order_data::order_id;
    GENERATE
        group as order_date,
        COUNT(joined_data.order_line::book_id) as num_books,
        COUNT(unique_orders) as num_orders,
        SUM(joined_data.order_line::price) as total_price;
}

-- Add note
result_with_categories = FOREACH result GENERATE
	order_date,
	num_books,
	num_orders,
	total_price,
	myfuncs.price_note(total_price) as note;

-- Sort the final result by total price, from high to low
sorted_result = ORDER result_with_categories BY total_price DESC;

STORE sorted_result INTO 'hdfs:///output/task2';
