create database investor;
use investor;

-- 1. Investor Table
CREATE TABLE Investor (
    investor_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    phone_number VARCHAR(20) UNIQUE NOT NULL,
    address TEXT,
    risk_tolerance ENUM('Low', 'Medium', 'High') DEFAULT 'Medium',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Portfolio Table
CREATE TABLE Portfolio (
    portfolio_id INT AUTO_INCREMENT PRIMARY KEY,
    investor_id INT NOT NULL,
    portfolio_name VARCHAR(100) NOT NULL,
    initial_investment DECIMAL(15, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Active', 'Inactive') DEFAULT 'Active',
    FOREIGN KEY (investor_id) REFERENCES Investor(investor_id) ON DELETE CASCADE
);

-- 3. Asset Table
CREATE TABLE Asset (
    asset_id INT AUTO_INCREMENT PRIMARY KEY,
    asset_name VARCHAR(100) NOT NULL,
    asset_type ENUM('Stock', 'Bond', 'ETF', 'Real Estate', 'Cryptocurrency') NOT NULL,
    market_value DECIMAL(15, 2) NOT NULL,
    risk_level ENUM('Low', 'Medium', 'High') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Portfolio_Asset Table
CREATE TABLE Portfolio_Asset (
    portfolio_id INT NOT NULL,
    asset_id INT NOT NULL,
    units_owned DECIMAL(12, 4) NOT NULL,
    purchase_price DECIMAL(15, 2) NOT NULL,
    current_value DECIMAL(15, 2) NOT NULL,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (portfolio_id, asset_id),
    FOREIGN KEY (portfolio_id) REFERENCES Portfolio(portfolio_id) ON DELETE CASCADE,
    FOREIGN KEY (asset_id) REFERENCES Asset(asset_id) ON DELETE CASCADE
);

-- 5. Transaction Table
CREATE TABLE Transaction (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    portfolio_id INT NOT NULL,
    asset_id INT NOT NULL,
    transaction_type ENUM('Buy', 'Sell') NOT NULL,
    transaction_date DATE NOT NULL,
    units DECIMAL(12, 4) NOT NULL,
    price_per_unit DECIMAL(15, 2) NOT NULL,
    total_value DECIMAL(15, 2) NOT NULL,
    FOREIGN KEY (portfolio_id) REFERENCES Portfolio(portfolio_id) ON DELETE CASCADE,
    FOREIGN KEY (asset_id) REFERENCES Asset(asset_id) ON DELETE CASCADE
);

-- 6. Market_History Table
CREATE TABLE Market_History (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    asset_id INT NOT NULL,
    date DATE NOT NULL,
    market_value DECIMAL(15, 2) NOT NULL,
    FOREIGN KEY (asset_id) REFERENCES Asset(asset_id) ON DELETE CASCADE
);

-- 1. Inserting sample Investors
INSERT INTO Investor (full_name, email, phone_number, address, risk_tolerance) VALUES
('John Smith', 'john.smith@email.com', '+1-555-0101', '123 Main St, New York, NY 10001', 'High'),
('Sarah Johnson', 'sarah.j@email.com', '+1-555-0102', '456 Park Ave, Boston, MA 02108', 'Medium'),
('Michael Chen', 'mchen@email.com', '+1-555-0103', '789 Oak Rd, San Francisco, CA 94102', 'Low'),
('Emma Wilson', 'emma.w@email.com', '+1-555-0104', '321 Pine St, Seattle, WA 98101', 'High'),
('Robert Brown', 'rbrown@email.com', '+1-555-0105', '654 Elm St, Chicago, IL 60601', 'Medium');

-- 2. Inserting sample Portfolios
INSERT INTO Portfolio (investor_id, portfolio_name, initial_investment) VALUES
(1, 'Growth Portfolio', 100000.00),
(1, 'Retirement Fund', 250000.00),
(2, 'Conservative Mix', 75000.00),
(3, 'Safe Haven', 50000.00),
(4, 'Tech Heavy', 150000.00);

-- 3. Inserting sample Assets
INSERT INTO Asset (asset_name, asset_type, market_value, risk_level) VALUES
('Apple Inc.', 'Stock', 150.75, 'Medium'),
('US Treasury Bond 2025', 'Bond', 1000.00, 'Low'),
('Vanguard S&P 500 ETF', 'ETF', 380.25, 'Medium'),
('Manhattan Real Estate Fund', 'Real Estate', 250000.00, 'High'),
('Bitcoin', 'Cryptocurrency', 35000.00, 'High');

-- 4. Inserting sample Portfolio_Asset records
INSERT INTO Portfolio_Asset (portfolio_id, asset_id, units_owned, purchase_price, current_value) VALUES
(1, 1, 100.0000, 145.50, 15075.00),
(1, 3, 50.0000, 375.00, 19012.50),
(2, 2, 25.0000, 990.00, 25000.00),
(3, 2, 15.0000, 995.00, 15000.00),
(4, 5, 0.5000, 32000.00, 17500.00);

-- 5. Inserting sample Transactions
INSERT INTO Transaction (portfolio_id, asset_id, transaction_type, transaction_date, units, price_per_unit, total_value) VALUES
(1, 1, 'Buy', '2024-01-15', 100.0000, 145.50, 14550.00),
(1, 3, 'Buy', '2024-01-20', 50.0000, 375.00, 18750.00),
(2, 2, 'Buy', '2024-02-01', 25.0000, 990.00, 24750.00),
(3, 2, 'Buy', '2024-02-10', 15.0000, 995.00, 14925.00),
(4, 5, 'Buy', '2024-02-15', 0.5000, 32000.00, 16000.00);

-- 6. Inserting sample Market_History records
INSERT INTO Market_History (asset_id, date, market_value) VALUES
(1, '2024-01-15', 145.50),
(1, '2024-02-15', 150.75),
(2, '2024-01-15', 990.00),
(2, '2024-02-15', 1000.00),
(3, '2024-02-15', 380.25);

-- stored procedure that calculates the total value of a portfolio based on the Portfolio_Asset table

DELIMITER $$

CREATE PROCEDURE GetPortfolioValue(
    IN p_portfolio_id INT,
    OUT total_value DECIMAL(15, 2)
)
BEGIN
    SELECT 
        SUM(current_value) 
    INTO 
        total_value
    FROM 
        Portfolio_Asset
    WHERE 
        portfolio_id = p_portfolio_id;
END $$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER UpdateUnitsOwned
AFTER INSERT ON Transaction
FOR EACH ROW
BEGIN
    IF NEW.transaction_type = 'Buy' THEN
        -- Add the purchased units to the existing units in Portfolio_Asset
        UPDATE Portfolio_Asset
        SET units_owned = units_owned + NEW.units
        WHERE portfolio_id = NEW.portfolio_id AND asset_id = NEW.asset_id;
    ELSEIF NEW.transaction_type = 'Sell' THEN
        -- Subtract the sold units from the existing units in Portfolio_Asset
        UPDATE Portfolio_Asset
        SET units_owned = units_owned - NEW.units
        WHERE portfolio_id = NEW.portfolio_id AND asset_id = NEW.asset_id;
    END IF;
END$$

DELIMITER ;

-- First, create the function to calculate percentage contribution
DELIMITER //

CREATE FUNCTION CalculateAssetPercentage(
    asset_value DECIMAL(15, 2),
    portfolio_total_value DECIMAL(15, 2)
) 
RETURNS DECIMAL(5, 2)
DETERMINISTIC
BEGIN
    DECLARE percentage DECIMAL(5, 2);
    
    -- Handle division by zero
    IF portfolio_total_value = 0 THEN
        RETURN 0;
    END IF;
    
    -- Calculate percentage and round to 2 decimal places
    SET percentage = (asset_value / portfolio_total_value * 100);
    
    RETURN ROUND(percentage, 2);
END //

DELIMITER ;

-- Now let's create a view or query to show the portfolio distribution
-- This query will show the distribution of assets in each portfolio
SELECT 
    pa.portfolio_id,
    p.portfolio_name,
    a.asset_name,
    a.asset_type,
    pa.current_value AS asset_value,
    (SELECT SUM(current_value) 
     FROM Portfolio_Asset 
     WHERE portfolio_id = pa.portfolio_id) AS portfolio_total_value,
    CalculateAssetPercentage(
        pa.current_value,
        (SELECT SUM(current_value) 
         FROM Portfolio_Asset 
         WHERE portfolio_id = pa.portfolio_id)
    ) AS percentage_of_portfolio
FROM 
    Portfolio_Asset pa
    JOIN Asset a ON pa.asset_id = a.asset_id
    JOIN Portfolio p ON pa.portfolio_id = p.portfolio_id
ORDER BY 
    pa.portfolio_id, percentage_of_portfolio DESC;

-- Create a stored procedure to analyze a specific portfolio
DELIMITER //

CREATE PROCEDURE AnalyzePortfolioDistribution(
    IN p_portfolio_id INT
)
BEGIN
    SELECT 
        p.portfolio_name,
        a.asset_name,
        a.asset_type,
        pa.current_value AS asset_value,
        (SELECT SUM(current_value) 
         FROM Portfolio_Asset 
         WHERE portfolio_id = p_portfolio_id) AS portfolio_total_value,
        CalculateAssetPercentage(
            pa.current_value,
            (SELECT SUM(current_value) 
             FROM Portfolio_Asset 
             WHERE portfolio_id = p_portfolio_id)
        ) AS percentage_of_portfolio
    FROM 
        Portfolio_Asset pa
        JOIN Asset a ON pa.asset_id = a.asset_id
        JOIN Portfolio p ON pa.portfolio_id = p.portfolio_id
    WHERE 
        pa.portfolio_id = p_portfolio_id
    ORDER BY 
        percentage_of_portfolio DESC;
END //

DELIMITER ;

-- Example usage:
-- 1. Calculate percentage for specific values
SELECT CalculateAssetPercentage(15075.00, 34087.50) AS percentage;

-- 2. Analyze a specific portfolio
CALL AnalyzePortfolioDistribution(1);

-- 3. Show distribution across all portfolios
SELECT 
    portfolio_id,
    asset_type,
    SUM(current_value) as type_value,
    CalculateAssetPercentage(
        SUM(current_value),
        (SELECT SUM(current_value) FROM Portfolio_Asset)
    ) AS percentage_of_total
FROM 
    Portfolio_Asset pa
    JOIN Asset a ON pa.asset_id = a.asset_id
GROUP BY 
    portfolio_id, asset_type
ORDER BY 
    portfolio_id, percentage_of_total DESC;
    
    
    
    -- First, let's create a procedure to simulate the updates
DELIMITER //

CREATE PROCEDURE SimulatePortfolioUpdate(
    IN p_portfolio_id INT,
    IN p_new_investment DECIMAL(15, 2),
    IN p_user VARCHAR(50),
    OUT p_result VARCHAR(100)
)
BEGIN
    DECLARE current_investment DECIMAL(15, 2);
    DECLARE exit_handler BOOLEAN DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET exit_handler = TRUE;
    
    -- Set transaction isolation level to SERIALIZABLE
    SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    
    -- Start transaction
    START TRANSACTION;
    
    -- Add a small delay to simulate concurrent access
    DO SLEEP(2);
    
    -- Get current investment amount
    SELECT initial_investment INTO current_investment
    FROM Portfolio
    WHERE portfolio_id = p_portfolio_id;
    
    -- Simulate some processing time
    DO SLEEP(2);
    
    -- Update the investment amount
    UPDATE Portfolio
    SET initial_investment = p_new_investment
    WHERE portfolio_id = p_portfolio_id;
    
    IF exit_handler THEN
        ROLLBACK;
        SET p_result = CONCAT('Error: Transaction for user ', p_user, ' rolled back');
    ELSE
        COMMIT;
        SET p_result = CONCAT('Success: User ', p_user, ' updated investment from ', 
                            current_investment, ' to ', p_new_investment);
    END IF;
END //

DELIMITER ;

-- Create a procedure to demonstrate the concurrent updates
DELIMITER //

CREATE PROCEDURE DemonstrateConcurrentUpdates(
    IN p_portfolio_id INT
)
BEGIN
    DECLARE v_result1 VARCHAR(100);
    DECLARE v_result2 VARCHAR(100);
    
    -- Show initial value
    SELECT CONCAT('Initial investment value: ', initial_investment) AS 'Initial State'
    FROM Portfolio
    WHERE portfolio_id = p_portfolio_id;
    
    -- Start first connection
    SELECT 'Starting User 1 Transaction' AS 'Action';
    CALL SimulatePortfolioUpdate(p_portfolio_id, 120000.00, 'User 1', @result1);
    
    -- Start second connection
    SELECT 'Starting User 2 Transaction' AS 'Action';
    CALL SimulatePortfolioUpdate(p_portfolio_id, 150000.00, 'User 2', @result2);
    
    -- Show results
    SELECT @result1 AS 'User 1 Result';
    SELECT @result2 AS 'User 2 Result';
    
    -- Show final value
    SELECT CONCAT('Final investment value: ', initial_investment) AS 'Final State'
    FROM Portfolio
    WHERE portfolio_id = p_portfolio_id;
END //

DELIMITER ;

-- To test the concurrent updates, open two MySQL connections and run:

-- In Connection 1:
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;
UPDATE Portfolio SET initial_investment = 120000.00 WHERE portfolio_id = 1;
-- Wait 5 seconds before committing
DO SLEEP(5);
COMMIT;

-- In Connection 2 (run this immediately after Connection 1):
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;
UPDATE Portfolio SET initial_investment = 150000.00 WHERE portfolio_id = 1;
COMMIT;

-- Check the final result:
SELECT portfolio_id, initial_investment 
FROM Portfolio  
WHERE portfolio_id = 1;

-- Make sure we have a test portfolio
UPDATE Portfolio SET initial_investment = 100000.00 WHERE portfolio_id = 1;


DROP PROCEDURE IF EXISTS SimulatePortfolioUpdate;
DROP PROCEDURE IF EXISTS LogTransactionEvent;
DROP PROCEDURE IF EXISTS DemonstrateConcurrentUpdates;



DELIMITER //

-- Helper procedure to log transaction events
CREATE PROCEDURE LogTransactionEvent(
    IN p_portfolio_id INT,
    IN p_user VARCHAR(50),
    IN p_action VARCHAR(100),
    IN p_value DECIMAL(15,2)
)
BEGIN
    INSERT INTO TransactionLog (
        portfolio_id,
        user_name,
        action,
        value,
        timestamp
    ) VALUES (
        p_portfolio_id,
        p_user,
        p_action,
        p_value,
        NOW()
    );
END //

-- Main procedure for portfolio updates with better error handling and logging
CREATE PROCEDURE SimulatePortfolioUpdate(
    IN p_portfolio_id INT,
    IN p_new_value DECIMAL(15,2),
    IN p_user VARCHAR(50),
    OUT p_result VARCHAR(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Log the error
        CALL LogTransactionEvent(p_portfolio_id, p_user, 'ERROR', p_new_value);
        SET p_result = CONCAT('Error occurred for ', p_user);
        ROLLBACK;
    END;

    START TRANSACTION;
    
    -- Log the start of transaction
    CALL LogTransactionEvent(p_portfolio_id, p_user, 'START', p_new_value);
    
    -- Add a small delay to simulate processing time
    DO SLEEP(2);
    
    -- Try to update the portfolio
    UPDATE Portfolio 
    SET initial_investment = p_new_value,
        last_updated = NOW(),
        updated_by = p_user
    WHERE portfolio_id = p_portfolio_id;
    
    -- Check if update was successful
    IF ROW_COUNT() > 0 THEN
        CALL LogTransactionEvent(p_portfolio_id, p_user, 'SUCCESS', p_new_value);
        SET p_result = CONCAT('Success: ', p_user, ' updated to ', p_new_value);
        COMMIT;
    ELSE
        CALL LogTransactionEvent(p_portfolio_id, p_user, 'FAILED', p_new_value);
        SET p_result = CONCAT('Failed: ', p_user, ' - no rows updated');
        ROLLBACK;
    END IF;
END //

-- Main demonstration procedure
CREATE PROCEDURE DemonstrateConcurrentUpdates(
    IN p_portfolio_id INT
)
BEGIN
    DECLARE v_initial_value DECIMAL(15,2);
    
    -- Create temporary table to store results
    CREATE TEMPORARY TABLE IF NOT EXISTS UpdateResults (
        step_number INT AUTO_INCREMENT PRIMARY KEY,
        description VARCHAR(200),
        value DECIMAL(15,2),
        timestamp TIMESTAMP
    );
    
    -- Capture initial state
    SELECT initial_investment INTO v_initial_value
    FROM Portfolio
    WHERE portfolio_id = p_portfolio_id;
    
    INSERT INTO UpdateResults (description, value, timestamp)
    VALUES ('Initial State', v_initial_value, NOW());
    
    -- Set isolation level
    SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    
    -- Attempt concurrent updates
    CALL SimulatePortfolioUpdate(p_portfolio_id, 120000.00, 'User 1', @result1);
    CALL SimulatePortfolioUpdate(p_portfolio_id, 150000.00, 'User 2', @result2);
    
    -- Record results
    INSERT INTO UpdateResults (description, value, timestamp)
    SELECT 'User 1 Result', initial_investment, NOW()
    FROM Portfolio
    WHERE portfolio_id = p_portfolio_id;
    
    INSERT INTO UpdateResults (description, value, timestamp)
    SELECT 'User 2 Result', initial_investment, NOW()
    FROM Portfolio
    WHERE portfolio_id = p_portfolio_id;
    
    -- Display results
    SELECT 
        step_number,
        description,
        value,
        timestamp,
        TIMESTAMPDIFF(MICROSECOND, 
            LAG(timestamp) OVER (ORDER BY step_number), 
            timestamp) as time_diff_microseconds
    FROM UpdateResults
    ORDER BY step_number;
    
    -- Clean up
    DROP TEMPORARY TABLE IF EXISTS UpdateResults;
END //

-- Create required table for logging
CREATE TABLE IF NOT EXISTS TransactionLog (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    portfolio_id INT,
    user_name VARCHAR(50),
    action VARCHAR(100),
    value DECIMAL(15,2),
    timestamp TIMESTAMP,
    INDEX idx_portfolio (portfolio_id),
    INDEX idx_timestamp (timestamp)
) //

DELIMITER ;

-- to automatically update the Portfolio_Asset table whenever a new row is inserted into the Transaction table

DELIMITER //

CREATE TRIGGER after_transaction_insert
AFTER INSERT ON Transaction
FOR EACH ROW
BEGIN
    DECLARE current_units DECIMAL(12, 4);
    DECLARE current_value DECIMAL(15, 2);
    
    -- Get current units and value or set to 0 if not exists
    SELECT COALESCE(units_owned, 0), COALESCE(current_value, 0)
    INTO current_units, current_value
    FROM Portfolio_Asset
    WHERE portfolio_id = NEW.portfolio_id 
    AND asset_id = NEW.asset_id;
    
    IF current_units IS NULL THEN
        SET current_units = 0;
        SET current_value = 0;
    END IF;
    
    -- Calculate new units and value based on transaction type
    IF NEW.transaction_type = 'Buy' THEN
        INSERT INTO Portfolio_Asset (
            portfolio_id, 
            asset_id, 
            units_owned, 
            purchase_price,
            current_value,
            last_updated
        )
        VALUES (
            NEW.portfolio_id,
            NEW.asset_id,
            NEW.units,
            NEW.price_per_unit,
            NEW.total_value,
            NOW()
        )
        ON DUPLICATE KEY UPDATE
            units_owned = units_owned + NEW.units,
            current_value = current_value + NEW.total_value,
            last_updated = NOW();
    ELSE
        UPDATE Portfolio_Asset
        SET 
            units_owned = units_owned - NEW.units,
            current_value = current_value - NEW.total_value,
            last_updated = NOW()
        WHERE portfolio_id = NEW.portfolio_id 
        AND asset_id = NEW.asset_id;
    END IF;
END //

DELIMITER ;


