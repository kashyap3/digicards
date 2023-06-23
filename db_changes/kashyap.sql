------------------creating client_details table -------------------START
CREATE TABLE IF NOT EXISTS client_details(
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(15),
    referral_code CHAR(5),
    password VARCHAR(255)
);
------------------creating client_details table -------------------END

------------------client_details dummy data -------------------start
INSERT INTO client_details (name, referral_code, phone, email, password) VALUES
    ('Kashyap', 'ABC12', '9876543210', 'kashyap@example.com', 'hashed_password_1'),
    ('Poojan', 'DEF34', '8888888888', 'poojan@example.com', 'hashed_password_2'),
    ('Nihar', 'GHI56', '9999999999', 'nihar@example.com', 'hashed_password_3');
------------------client_details dummy data -------------------end


-------------------table business_master-------------------start
CREATE TABLE IF NOT EXISTS business_master (
    business_id INT AUTO_INCREMENT,
    business_name VARCHAR(255),
    client_id INT,
    payment CHAR(1),
    start_date DATE,
    end_date DATE,
    referral_code CHAR(6),
    PRIMARY KEY (business_id),
    CONSTRAINT fk_client_id
        FOREIGN KEY (client_id)
        REFERENCES client_details(id)
);
-------------------table business_master-------------------end


------------------dummy entries business_master-----------------start
INSERT INTO business_master (business_name, client_id, payment, start_date, end_date, referral_code)
VALUES
    ('Mangalam Furniture', 1, 'Y', '2023-01-01', '2024-01-01', 'ABCDE1'),
    ('Umiya electrical', 2, 'N', '2023-02-15', '2024-02-1', 'FGHIJ2'),
    ('ashirvad motors', 3, 'Y', '2023-03-10', '2024-03-1', 'KLMNO3'),
    ('Umiya mobiles', 2, 'Y', '2023-04-05', '2024-04-055', 'PQRST4'),
    ('gosa ortho works', 1, 'N', '2023-05-20', '20234-05-200', 'UVWXY5');
------------------dummy entries business_master-----------------start



-------------------table template_details------------------------start
CREATE TABLE IF NOT EXISTS template_details (
    id INT AUTO_INCREMENT PRIMARY KEY,
    business_name VARCHAR(255),
    business_id INT,
    about LONGTEXT,
    products LONGTEXT,
    images LONGTEXT,
    address LONGTEXT,
    CONSTRAINT fk_business_id
        FOREIGN KEY (business_id)
        REFERENCES business_master(business_id)
);
-------------------table template_details------------------------end


--------------------dummy entries template_details----------------start
INSERT INTO template_details (business_name, business_id, about, products, images, address)
VALUES
    ('Mangalam Furniture', 1, 'About mangalam furniture', 'Product 1, Product 2, Product 3', 'image1.jpg|image2.jpg', '123 ABC Street, City, State, Country'),
    ('Umiya electrical', 2, 'About Umiya electrical', 'Product A, Product B, Product C', 'image3.jpg|image4.jpg', '456 XYZ Road, City, State, Country'),
    ('ashirvad motors', 3, 'About ashirvad motors', 'Product X, Product Y, Product Z', 'image5.jpg|image6.jpg', '789 PQR Avenue, City, State, Country'),
    ('Umiya mobiles', 4, 'About Umiya mobiles', 'Product X, Product Y, Product Z', 'image12.jpg|image13.jpg', '152 PQR town, City, State, Country'),
    ('gosa ortho works', 5, 'About gosa ortho works', 'Product X, Product Y, Product Z', 'image55.jpg|image56.jpg', '152 jklasd, City, State, Country');
--------------------dummy entries template_details----------------end



----------------SIGNUP-----------------------
DELIMITER $$
CREATE PROCEDURE sp_client_signup(
    IN client_name VARCHAR(255),
    IN client_email VARCHAR(255),
    IN client_phone VARCHAR(15),
    IN client_password VARCHAR(255)
)
BEGIN
    DECLARE li_email_count INT;
    DECLARE li_phone_count INT;

    SELECT count(*) INTO li_email_count FROM client_details WHERE email = client_email;
    SELECT count(*) INTO li_phone_count FROM client_details WHERE phone = client_phone;

    IF li_email_count > 0 THEN
        SELECT 'email already exists' as message;
    ELSE IF li_phone_count THEN
        SELECT 'phone number already exists' as message;
    ELSE 
        INSERT INTO client_details(name, email, phone, password) VALUES (client_name, client_email, client_phone, client_password);
        SELECT 'client added successfully' as message;
    END IF;
END $$
DELIMITER ;
------------------SIGUP-------------------

--------------SIGN-IN------------------------------
DELIMITER $$
CREATE OR REPLACE PROCEDURE sp_client_signin(
    IN client_phone VARCHAR(15)
)
sign_in:BEGIN
    DECLARE li_client_count INT;

    SELECT count(*) INTO li_client_count FROM client_details WHERE phone = client_phone;
    IF li_client_count = 0 THEN 
        SELECT 'phone number does not exists please check your phone number' as message, '-1' as code;
        LEAVE sign_in;
    END IF;

    
    SELECT password as data, '1' as code FROM client_details WHERE phone = client_phone;
END $$

DELIMITER;
------------SIGN-IN----------------------------------------

