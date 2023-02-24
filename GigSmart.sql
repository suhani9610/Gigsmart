/*                              GigSmart Database 									*/
CREATE SCHEMA gigsmart;
USE gigsmart;
DROP TABLE CUSTOMER, BILLING, JOB_SCHEDULING_TRACKING, QUOTATION, SERVICE_BOOKING, SERVICE_CATEGORY, SERVICE_LIST_PROVIDER;
CREATE TABLE CUSTOMER (
	CustomerID			VarChar(4)		NOT NULL,
    CustomerFullName	Char(100)		NOT NULL,
    CustomerPhone		Numeric(10)		NOT NULL,
    CustomerEmail		VarChar(150)	NULL,
    CustomerAddress		VarChar(200)	NULL,
    LoyaltyPoints		Numeric			NULL,
    CustomerRating		Numeric(2,1)	NULL,
    CONSTRAINT	CustomerPK			PRIMARY KEY(CustomerID),
	CONSTRAINT	CustomerAK			UNIQUE(CustomerFullName),
    CONSTRAINT	CustomerRatingCK	CHECK
					((CustomerRating >= 0) AND (CustomerRating <=5))
);
    
CREATE TABLE SERVICE_CATEGORY (
	ServiceCategoryID	VarChar (5)		NOT NULL,
    ServiceCategoryName	Char(100)		NOT NULL,
    MarketRate			Decimal(2,0)	NOT NULL,
    CONSTRAINT	ServiceCategoryPK		PRIMARY KEY(ServiceCategoryID),
	CONSTRAINT	ServiceCategoryAK		UNIQUE(ServiceCategoryName)
);
    
CREATE TABLE SERVICE_LIST_PROVIDER (
	ServiceProviderID	VarChar(5)		NOT NULL,
    ServiceProviderName	Char(100)		NOT NULL,
    ServiceCategoryID	VarChar (5)		NOT NULL,
    ServiceLocation		VarChar(200)	NULL,
    ServiceProviderHourlyRate	Decimal(2,0)	NULL,
    ServiceProviderRating		Numeric(2,1)	NULL,
    CONSTRAINT	ServiceProviderPK		PRIMARY KEY(ServiceProviderID),
	CONSTRAINT	ServiceProviderAK		UNIQUE(ServiceProviderName),
    CONSTRAINT	ServiceProviderFK		FOREIGN KEY(ServiceCategoryID)
					REFERENCES	SERVICE_CATEGORY(ServiceCategoryID)
						ON UPDATE NO ACTION
                        ON DELETE NO ACTION,
	CONSTRAINT	ServiceProviderRatingCK	CHECK
					((ServiceProviderRating >= 0) AND (ServiceProviderRating <=5))
);
    
CREATE TABLE SERVICE_BOOKING (
	JobID				VarChar(6)		NOT NULL,
    ServiceProviderID	VarChar(5)		NOT NULL,
    CustomerID			VarChar(4)		NOT NULL,
    ServiceDescription	Char(255)		NOT NULL,
    ServiceProviderRating	Numeric(2,1)	NULL,
    CustomerRating		Numeric(2,1)		NULL,
    RequestedDate		Date			NULL,
    RequestedTime		Time			NULL,
    ExpectedHours		Decimal(2,0)	NULL,
    CONSTRAINT	JobPK		PRIMARY KEY(JobID),
	CONSTRAINT	JobAK		UNIQUE(ServiceDescription),
    CONSTRAINT	JobFK1		FOREIGN KEY(ServiceProviderID)
					REFERENCES	SERVICE_LIST_PROVIDER(ServiceProviderID)
						ON UPDATE NO ACTION
                        ON DELETE NO ACTION,
	CONSTRAINT	JobFK2		FOREIGN KEY(CustomerID)
					REFERENCES	CUSTOMER(CustomerID)
						ON UPDATE NO ACTION
                        ON DELETE NO ACTION
);

CREATE TABLE QUOTATION (
	QuotationID				VarChar(4)		NOT NULL,
    JobID			VarChar(6)		NOT NULL,
    InitialAssessmentFee	Decimal(10,0)	NULL,
    DistanceFee				Decimal (5,0)	NULL,
    CONSTRAINT	QuotationPK		PRIMARY KEY(QuotationID),
    CONSTRAINT	JobFK3		FOREIGN KEY(JobID)
					REFERENCES	SERVICE_BOOKING(JobID)
						ON UPDATE NO ACTION
                        ON DELETE NO ACTION
);

CREATE TABLE JOB_SCHEDULING_TRACKING (
	JobID				VarChar(6)		NOT NULL,
    CompletionStatus	Decimal(5,0)	NULL,
    ReminderLastSentOn	Date			NULL,
    CheckinMade			Char (3)		NULL,
	RescheduleRequired	Char (3)		NULL,
    DepositStatus Char(3)       NOT NULL ,
    DepositAmount         Int           NULL,   

    CONSTRAINT	JobPK				PRIMARY KEY(JobID),
    CONSTRAINT	CompletionStatus	CHECK
					((CompletionStatus >= 0) AND (CompletionStatus <=100))
);

CREATE TABLE BILLING (
	JobID			VarChar(6)		NOT NULL,
    PaymentDate		Date			NULL,
    PaymentTime		Time			NULL,
    BalanceAmount		Decimal(10,2)	NULL,
    CONSTRAINT	JobPK		PRIMARY KEY(JobID)
);


SET FOREIGN_KEY_CHECKS=0;



INSERT INTO CUSTOMER(CustomerID, CustomerFullName, CustomerPhone, CustomerEmail, CustomerAddress, LoyaltyPoints, CustomerRating)
VALUES
('C100', 'Gaylord Balcom', 6929963841, 'GaylordBalcom@gmail.com', 'AA', 875, 4.2),
('C101', 'Hosea Jack', 1456032778, 'HoseaJack@gmail.com', 'FD', 567, 3.7),
('C102', 'Vera Fuselier', 6284891582, 'VeraFuselier@gmail.com', 'HG', 2345, 2.4),
('C103',	'Kacy Poplar', 2130077630, 'KacyPoplar@gmail.com',	'KH', 765, 4.3),
('C104',	'Scottie Wallen', 6321222854, 'ScottieWallen@gmail.com', 'BG', 876, 4.4),
('C105',	'Deeanna Soukup', 2561058706, 'DeeannaSoukup@gmail.com', 'SD', 345, 3.8),
('C106',	'Brant Dipaola', 2398362872, 'BrantDipaola@gmail.com', 'JG', 987, 3.5),
('C107',	'Jeffie Parnell', 1421478556, 'JeffieParnell@gmail.com', 'ER', 357, 3.9),
('C108',	'Monte Heilig',	2999195601, 'MonteHeilig@gmail.com', 'DD', 134,	4.1),
('C109', 'Terrell Metzer', 3147055899, 'TerrellMetzer@gmail.com', 'KJ', 45, 2.2),
('C110',	'Annelle Ziolkowski', 3279631324, 'AnnelleZiolkowski@gmail.com', 'FG', 754,	2.9),
('C111',	'Lucila Tiger',	9802220047, 'LucilaTiger@gmail.com', 'KJ', 75, 3.3),
('C112',	'Marybelle Ensign',	3882223406,	'MarybelleEnsign@gmail.com', 'CV', 357, 4.8),
('C113', 'Carmen Caylor', 5094263397, 'CarmenCaylor@gmail.com', 'ER', 35, 4.1),
('C114', 'Coretta Harriss', 3804024811, 'CorettaHarriss@gmail.com', 'KG', 865, 2.1)
;


INSERT INTO SERVICE_CATEGORY (ServiceCategoryID, ServiceCategoryName, MarketRate)
VALUES
('SC100', 'Waste Management', 20),
('SC101', 'IT/Telecom', 34),
('SC102', 'Human Resouces', 54),
('SC103', 'Maintenance Contracts', 50),
('SC104', 'Mail/Shipping', 90),
('SC105', 'Advertising',	87),
('SC106', 'Utilities', 76),
('SC107', 'Other', 45),
('SC108', 'Transportation/Fleet', 96),
('SC109', 'Treasury', 65),
('SC110', 'Insurance', 48),
('SC111', 'Taxes', 25),
('SC112', 'Janitorial', 62),
('SC113', 'Textiles', 83),
('SC114', 'Supplies', 38),
('SC115', 'Medical',	78)
;


INSERT INTO SERVICE_LIST_PROVIDER (ServiceProviderID, ServiceProviderName, ServiceCategoryID, ServiceLocation, ServiceProviderHourlyRate, ServiceProviderRating)
VALUES
('SP100', 'AAA',	'SC100', 'LOCATION1', 24, 4.2),
('SP101','AAB',	'SC100', 'LOCATION3', 35, 3.7),
('SP102', 'AAC',	'SC102', 'LOCATION3', 58, 2.4),
('SP103', 'AAD',	'SC102', 'LOCATION2', 56, 4.3),
('SP104', 'AAE',	'SC101', 'LOCATION1', 84, 4.4),
('SP105', 'AAF',	'SC103', 'LOCATION1', 88, 3.8),
('SP106', 'AAG',	'SC104', 'LOCATION3', 74, 3.5),
('SP107', 'AAH',	'SC107', 'LOCATION4', 47, 3.9),
('SP108', 'AAI',	'SC111', 'LOCATION2', 92, 4.1),
('SP109', 'AAJ',	'SC113', 'LOCATION3', 66, 2.2),
('SP110', 'AAK', 'SC111', 'LOCATION4', 45, 2.9),
('SP111', 'AAL',	'SC102', 'LOCATION4', 20, 3.3),
('SP112', 'AAM',	'SC105', 'LOCATION1', 60, 4.8),
('SP113', 'AAN',	'SC107', 'LOCATION5', 79, 4.1),
('SP114', 'AAO',	'SC106', 'LOCATION5', 33, 2.1),
('SP115', 'AAP',	'SC115', 'LOCATION2', 74, 3.5);


INSERT INTO SERVICE_BOOKING (JobID,	ServiceProviderID,	CustomerID,	ServiceDescription,	ServiceProviderRating,	CustomerRating,	RequestedDate, RequestedTime, ExpectedHours)
VALUES
('Job100', 'SP106', 'C108', 'BAA', 4.4, 3.9,	'2018-10-01', '09:45', 3),
('Job101', 'SP103', 'C111', 'BAB', 4.3, 3.6, '2019-04-27', '08:50', 5),
('Job102', 'SP101', 'C120', 'BAC', 4.3, 4.9, '2018-11-20', '13:05',	2),
('Job103', 'SP114', 'C114', 'BAD', 3.8, 4.6, '2017-10-03', '14:50', 4),
('Job104', 'SP105', 'C116', 'BAE', 3.7, 4.3, '2020-05-30', '20:06',	5),
('Job105', 'SP106', 'C115', 'BAF', 3.7, 3.8,	'2019-09-08', '21:40', 6),
('Job106', 'SP101', 'C110', 'BAG', 4.1, 3.5, '2019-04-09', '15:30', 3),
('Job107', 'SP108', 'C112', 'BAH', 4.9, 4.5, '2021-09-20', '10:30', 4),
('Job108', 'SP102', 'C115', 'BAI', 4.6, 2.4, '2017-04-04', '11:08', 6),
('Job109', 'SP106', 'C100', 'BAJ', 3.7, 4.8,	'2019-03-30', '12:09', 1),
('Job110', 'SP102', 'C118', 'BAK', 3.9, 3.7, '2018-03-30', '14:05', 4),
('Job111', 'SP104', 'C110', 'BAL', 3.2, 4.7, '2021-05-31', '13:06', 6),
('Job112', 'SP107', 'C103', 'BAM', 4.1, 4.6,	'2017-09-13', '13:50', 4),
('Job113', 'SP109', 'C104', 'BAN', 4.6, 3.6, '2020-07-05', '15:08', 5),
('Job114', 'SP111', 'C112', 'BAO', 4.7, 3.8, '2020-05-20', '16:38', 9),
('Job115', 'SP115', 'C112', 'BAP', 4.8, 4.9, '2021-04-03', '17:05', 5);


INSERT INTO QUOTATION ( QuotationID, JobID, InitialAssessmentFee,DistanceFee)
VALUES
('Q100', 'Job100',	45,	3),
('Q101', 'Job101',	23,	6),
('Q102', 'Job102',	53,	2),
('Q103', 'Job103',	13,	0),
('Q104', 'Job104',	64,	7),
('Q105', 'Job105',	24,	4),
('Q106', 'Job106',	54,	0),
('Q107', 'Job107',	23,	2),
('Q108', 'Job108',	76,	0),
('Q109', 'Job109',	45,	3),
('Q110', 'Job110',	35,	0),
('Q111', 'Job111',	23,	0),
('Q112', 'Job112',	76,	0),
('Q113', 'Job113',	45,	6),
('Q114', 'Job114',	23,	2);



INSERT INTO JOB_SCHEDULING_TRACKING (JobID,	CompletionStatus, ReminderLastSentOn, CheckinMade, RescheduleRequired,DepositStatus,DepositAmount)
VALUES
('Job100', 86, '2018-01-10', 'YES', 'YES', 'YES', 5),
('Job101', 83, null, 'YES', 'NO', 'NO', 0),
('Job102', 26, '2018-11-20',	'NO', 'NO', 'NO', 0),
('Job103', 35, '2017-10-03', 'NO', 'YES', 'YES', 8),
('Job104', 39, null, 'NO', 'NO', 'NO', 0),
('Job105', 5, '2019-09-08', 'YES', 'NO', 'YES', 4),
('Job106', 58, '2019-04-09',	'NO', 'NO', 'YES', 2),
('Job107', 67, null, 'YES', 'NO', 'NO', 0),
('Job108', 59, '2017-04-04', 'YES', 'NO', 'YES', 7),
('Job109', 35, '2019-03-30', 'NO', 'YES', 'NO', 0),
('Job110', 32, '2018-03-30', 'NO', 'NO', 'YES', 6),
('Job111', 99, null, 'YES', 'NO', 'YES', 8),
('Job112', 63, '2017-09-13', 'NO', 'YES', 'YES', 5),
('Job113', 8, null, 'NO', 'YES', 'NO', 0),
('Job114', 91, '2020-05-20', 'YES', 'NO', 'YES', 2),
('Job115', 40, '2021-04-03', 'NO', 'NO', 'YES', 7);


INSERT INTO BILLING (JobID,	PaymentDate, PaymentTime, BalanceAmount)
VALUES
('Job100', '2018-01-10',	'9:45', 65),
('Job101', '2019-04-27',	'8:50', 76),
('Job102', '2018-11-20',	'13:05', 87),
('Job103', '2017-10-03',	'14:50', 45),
('Job104', '2020-05-30',	'20:06', 82),
('Job105', '2019-09-08',	'21:40', 56),
('Job106', '2019-04-09',	'15:30', 61),
('Job107', '2021-09-20',	'10:30', 94),
('Job108', '2017-04-04',	'11:08', 112),
('Job109', '2019-03-30',	'12:09', 54),
('Job110', '2018-03-30',	'14:05', 117),
('Job111', '2021-05-31',	'13:06', 50),
('Job112', '2017-09-13',	'13:50', 124),
('Job113', '2020-07-05',	'15:08', 32),
('Job114', '2020-05-20',	'16:38', 170),
('Job115', '2021-04-03',	'17:05', 23);

# Query # Query 1
SELECT quotation.JobID AS "JobID",
       DepositAmount, # job scheduling table
       billing.BalanceAmount, # billing table
	   ExpectedHours, # service_booking table
       ServiceProviderHourlyRate, # service_list_provider table
       InitialAssessmentFee, DistanceFee, # quotation table
       DepositAmount+ExpectedHours*ServiceProviderHourlyRate+InitialAssessmentFee+DistanceFee - billing.BalanceAmount AS "Final Amount to be paid"
FROM quotation INNER JOIN service_booking
ON quotation.JobID = service_booking.JobID
INNER JOIN job_scheduling_tracking
ON service_booking.JobID = job_scheduling_tracking.JobID
INNER JOIN billing
ON job_scheduling_tracking.JobID = billing.JobID
INNER JOIN service_list_provider
ON service_booking.ServiceProviderID = service_list_provider.ServiceProviderID;



#Query 2
SELECT job_scheduling_tracking.JobID AS "JobID", DepositStatus, DepositAmount, BalanceAmount
FROM job_scheduling_tracking
INNER JOIN billing
ON job_scheduling_tracking.JobID = billing.JobID
WHERE DepositStatus = "YES";

# Query 3
SELECT job_scheduling_tracking.JobID, CheckinMade, CompletionStatus AS "Completion Status (%)"
FROM job_scheduling_tracking
INNER JOIN service_booking
ON job_scheduling_tracking.JobID = service_booking.JobID;

# Query 4
SELECT sub.*
FROM (
SELECT * FROM service_list_provider
ORDER BY ServiceProviderRating DESC
LIMIT 3) sub
ORDER BY sub.ServiceProviderHourlyRate ASC
LIMIT 2;
/* We have given the two best options here considering two factors:
1) Service Provider Hourly Rate
2) Service Provider Rating
*/

# Query 5
SELECT JobID, ReminderLastSentOn, CheckinMade
FROM job_scheduling_tracking
WHERE CheckinMade = "YES";

# Query 6
# For Service Provider
SELECT service_booking.ServiceProviderID AS ServiceProviderID, ServiceProviderName,COUNT(CustomerID) AS Total_Customers,
	   avg(service_booking.ServiceProviderRating) AS Average_SP_Rating
FROM service_booking
INNER JOIN service_list_provider
ON service_booking.ServiceProviderID = service_list_provider.ServiceProviderID
GROUP BY ServiceProviderID;
# For Customer
SELECT service_booking.CustomerID, CustomerFullName, COUNT(ServiceProviderID) AS Service_Providers,
avg(service_booking.CustomerRating) AS Average_Customer_Rating
FROM service_booking
INNER JOIN customer
ON service_booking.CustomerID = customer.CustomerID
GROUP BY CustomerID;

# Query 7
# BEST SERVICE PROVIDER
SELECT ServiceProviderID, ServiceProviderName, ServiceProviderHourlyRate, ServiceProviderRating
FROM service_list_provider
WHERE ServiceProviderRating > 4.2
HAVING MIN(ServiceProviderHourlyRate);

# WORST SERVICE PROVIDER
SELECT ServiceProviderID, ServiceProviderName, ServiceProviderHourlyRate, ServiceProviderRating
FROM service_list_provider
WHERE ServiceProviderRating < 2.5
HAVING MAX(ServiceProviderHourlyRate);

# BEST CUSTOMER
SELECT CustomerID, CustomerFullName, CustomerRating
FROM customer
ORDER BY CustomerRating DESC
LIMIT 1;

# WORST CUSTOMER
SELECT CustomerID, CustomerFullName, CustomerRating
FROM customer
ORDER BY CustomerRating ASC
LIMIT 1;

##BONUS QUESTIONS
##1. creating procedures 
/* Creating a procedure to return service provider info if service id is given */
DELIMITER //
CREATE PROCEDURE ReturnAllSP(IN NewSPID VarChar(20))

  BEGIN
  SELECT ServiceProviderName,ServiceLocation,ServiceProviderHourlyRate,ServiceProviderRating
  FROM SERVICE_LIST_PROVIDER
  WHERE ServiceProviderID = NewSPID
  ORDER BY ServiceProviderID;
  
  END
  //

DELIMITER ;

/* Testing the new Procedure */
CALL ReturnAllSP('SP114');
  
  
/* procedure to insert a new customer */
DELIMITER //
CREATE PROCEDURE InsertNewCustomer 
  ( IN NewID			VarChar(4),		
    IN NewFullName	    Char(100),		
    IN NewPhone		Numeric(10),		
	IN NewEmail		VarChar(150),	
    IN NewAddress		VarChar(200),	
    IN NewLoyaltyPoints Numeric,			
    IN NewRating Numeric(2,1))	
    

BEGIN

DECLARE	CustomerCount Int;
##This will check to see if the Customer Data Exists already
SELECT		CustomerCount = COUNT(*)
FROM CUSTOMER
WHERE CustomerFullName = newFullName
AND   CustomerPhone =  NewPhone;

##creating an IF function for incrementing count in case the customer exists
IF (CustomerCount > 0)
		THEN
			ROLLBACK;
SELECT 'Customer already exists'
				AS ErrorMessage;
		END IF;

##If it does not then we will insert new customer in our database
INSERT INTO CUSTOMER
(CustomerID, CustomerFullName,CustomerPhone,CustomerEmail,CustomerAddress,LoyaltyPoints,CustomerRating)
VALUES
(NewID,NewFullName,NewPhone,NewEmail,NewAddress,NewLoyaltyPoints,NewRating);

SELECT 'New Customer has been added to the customer database'
		AS NewCustomerAdded;

END
//

DELIMITER ;

/* Testing the new Procedure */
CALL InsertNewCustomer ('C115','Cyrus Miley', 7814512233, 'cyrusmiley@gmail.com','AA',901,4.7);

SELECT * 
FROM CUSTOMER; 



DELIMITER //
## creating a Procedure to update existing phone and email info
CREATE PROCEDURE UpdateInfo
(	IN NewFullName	 Char(100),		
    IN OldPhone     Numeric(10),
    IN NewPhone		Numeric(10),	
	IN OldEmail     VarChar(150),
	IN NewEmail		VarChar(150))
 	
    
    
Updatingproc: BEGIN
	Declare newcount		    Int;
	Declare CustomerIDcheck		VarChar(10);
    

	/* checking if the customer is in the database */
	SELECT COUNT(*) INTO newcount
		FROM 		CUSTOMER AS C
        WHERE 		C.CustomerFullName = NewFullName
		AND		    C.CustomerPhone = OldPhone
        AND         C.CustomerEmail = OldEmail;
        
        IF (newcount = 0)
		THEN
				SELECT 'Customer does not exist'
				AS PhoneErrorMessage;
				ROLLBACK;
				LEAVE Updatingproc;
		END IF;
        
        /* Updating the existing phone number */
        
        SELECT CustomerID INTO CustomerIDcheck
		FROM   CUSTOMER AS C
        WHERE 		C.CustomerFullName = NewFullName
		AND		    C.CustomerPhone = OldPhone;
        
        UPDATE CUSTOMER
        SET CustomerPhone = NewPhone
		WHERE CustomerID = CustomerIDcheck;
        
        /* Updating the existing email ID  */
        UPDATE CUSTOMER
         SET CustomerEmail = NewEmail
         WHERE CustomerID = CustomerIDcheck;
        
        
        SELECT 'Customer Phone and Email has been updated'
		AS UpdatePInfoResult;
        
     

END Updatingproc;
//

Delimiter ;

/*  Testing the new Procedure */

CALL UpdateInfo('Cyrus Miley',7814512233,5408083420,'cyrusmiley@gmail.com','cyrusmile25y@gmail.com');

SELECT *
FROM CUSTOMER;

/* Q2. A user can have open or restricted access to a database.
a. Grant specific privileges to specific columns/rows in a table	*/

CREATE USER		'group6'@'umb.edu' 
IDENTIFIED BY 	'obscure';

CREATE VIEW		Group6View AS
	  SELECT 	ServiceProviderName AS Service_Provider_Name,
				ServiceCategoryID AS ServiceID,
                ServiceLocation AS Location,
                ServiceProviderRating AS Service_Provider_Rating
	  FROM 		SERVICE_LIST_PROVIDER;
      
 /* grants the employee only only view to the service provider name */
GRANT SELECT (Service_Provider_Name) ON gigsmart.Group6View TO 'group6'@'umb.edu' ;


/*b. Create separate tables entirely and block privileges to them	*/
## creating 3 tables in gigsmart
CREATE TABLE	ABC (
	ABC_ID			VarChar(4)		NOT NULL,
    ABC_FullName	Char(100)		NOT NULL,
    ABC_Phone		Numeric(10)		NOT NULL
);

CREATE TABLE	DEF (
	DEF_ID			VarChar(4)		NOT NULL,
    DEF_FullName	Char(100)		NOT NULL,
    DEF_Phone		Numeric(10)		NOT NULL
);

CREATE TABLE	GHI (
	GHI_ID			VarChar(4)		NOT NULL,
    GHI_FullName	Char(100)		NOT NULL,
    GHI_Phone		Numeric(10)		NOT NULL
);

##granting access to agent1@umb.edu 
CREATE USER 'agent1'@'umb.edu'; 
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP 
	ON gigsmart.ABC
	TO 'agent1'@'umb.edu'; 
   
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP 
	ON gigsmart.DEF
	TO 'agent1'@'umb.edu'; 

GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP 
	ON gigsmart.GHI
	TO 'agent1'@'umb.edu'; 

##revoking all privleges for agent1@umb.edu
REVOKE ALL ON gigsmart.ABC 
	FROM 'agent1'@'umb.edu'; 

REVOKE ALL ON gigsmart.DEF 
	FROM 'agent1'@'umb.edu'; 
    
REVOKE ALL ON gigsmart.GHI 
	FROM 'agent1'@'umb.edu'; 







        
        
        


   






















    
    
    