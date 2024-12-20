# Investor Management System <br>
## Overview<br>
- This project focuses on developing a database system for EcoVenture Investments, supporting efficient portfolio management, automated updates, real-time synchronization, and insightful analytics.
- Additionally, we have implemented certain database functionalities using a simple website interface for ease of demonstration.

## Functionalities Implemented
### Portfolio Management System Design
We designed the system to represent the relationships between investors, their portfolios, and assets (stocks, bonds, and cryptocurrencies). The database ensures:
- Multiple portfolios per investor.
- Unique asset attributes, including real-time market values.<br>
### Database Setup
We created the database schema in MySQL and populated it with sample data:
- Investors: Basic details of five investors.
- Portfolios: Sample portfolios tied to investors.
- Assets: Examples of stocks, bonds, and cryptocurrencies.
- Transactions: Simulated buy/sell records.
### Synchronization Across Servers
Using the Federated Storage Engine:
- Demonstrated deleting an inactive portfolio from the client database.
- Verified the deletion was reflected in the server database.
- Ensures real-time synchronization between distributed servers.
### Portfolio Value Calculation
A stored procedure calculates the total value of a portfolio:
- Accepts a Portfolio ID and returns the sum of all asset values.
- Demonstrated the functionality using a sample portfolio.
### Automatic Updates via Triggers with a Website Interface
To showcase automation, we built a simple website to demonstrate the functionality of database triggers:<br>
#### Trigger Functionality:
- Automatically updates the units_owned in the Portfolio_Asset table whenever a transaction (buy/sell) is recorded in the Transactions table.
- Adjusts the total number of units held for an asset based on transaction type.
#### Website Interface Implementation
1. Frontend: Created a frontend using react and typescript:
- Fields: Portfolio ID, Asset ID, Transaction Type (Buy/Sell), and Units.
- Submit button triggers the transaction insertion.
2. Backend:
- Used a Flask (Python) application to interact with the database.
- Upon transaction submission, the database trigger automatically updates the portfolio’s asset holdings.
3. Demonstration:
- Added transactions using the website form.
- Verified the automatic updates in the Portfolio_Asset table.
### Asset Contribution Analytics
Created a user-defined function to calculate an asset’s contribution to a portfolio:
- Inputs: asset_value, portfolio_total_value.
- Returns the percentage contribution using the formula: (Asset Value / Portfolio Total Value) * 100.
- Used the function to analyze asset contributions for a sample portfolio.
### Data Integrity for Concurrent Updates
Used the Serializable transaction isolation level to simulate simultaneous updates:
- Two users attempted to modify the initial_investment of the same portfolio.
- Ensured consistent updates without lost changes.
