PROCEDURE "build_products" ( 
	        out ex_products table (PRODUCTID nvarchar(10),
                               CATEGORY nvarchar(20),
                               PRICE decimal(15,2) ),
            out ex_pc_productid nvarchar(10) )
   LANGUAGE SQLSCRIPT
   SQL SECURITY INVOKER
   --DEFAULT SCHEMA <default_schema_name>
   READS SQL DATA AS
BEGIN
 
 declare lt_products table like :ex_products;
 declare lv_index int = 0;
 declare lv_del_index int array;
 declare lv_array_index int = 0;

 lt_products = select PRODUCTID, CATEGORY, PRICE from "MD.Products";
 :ex_products.INSERT(:lt_products);
 :ex_products.INSERT(('ProductA', 'Software', '1999.99'), 1);
 :ex_products.INSERT(('ProductB', 'Software', '2999.99'), 2);
 :ex_products.INSERT(('ProductC', 'Software', '3999.99'), 3);

 FOR lv_index IN 1..record_count(:ex_products) DO
   :ex_products.(PRICE).UPDATE((:ex_products.PRICE[lv_index] * 1.25), lv_index);
 END FOR;

 FOR lv_index IN 1..record_count(:ex_products) DO
   IF :ex_products.PRICE[lv_index] <= 2500.00 THEN
    lv_array_index = lv_array_index + 1;
    lv_del_index[lv_array_index] = lv_index;
  END IF;
 END FOR;

 :ex_products.DELETE(:lv_del_index);
 
 lv_index = :ex_products.SEARCH("CATEGORY", 'PC', 1);  
 ex_pc_productid = :ex_products.PRODUCTID[lv_index];

END
