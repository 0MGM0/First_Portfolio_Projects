CREATE Database Games_Sales;

Select Top(10) *
FROM Games_Sales.dbo.[Video Games Sales];

/* Trimming Year Values */

--Select RTRIM(Year, .0) as YearNew
--FROM Games_Sales.dbo.[Video Games Sales]

Update Games_Sales.dbo.[Video Games Sales]
Set Year = RTRIM(Year,.0);

/* Fixing Missing 0 Values */

Update Games_Sales.dbo.[Video Games Sales]
Set Year = 2000
Where Year = 2;
Update Games_Sales.dbo.[Video Games Sales]
Set Year = 2010
Where Year = 201;
Update Games_Sales.dbo.[Video Games Sales]
Set Year = 1990
Where Year = 199;

/* Checking what Genre and Publisher are represented */

Select DISTINCT Genre
FROM Games_Sales.dbo.[Video Games Sales]
Select DISTINCT Publisher
FROM Games_Sales.dbo.[Video Games Sales];

/* Descriptive Statistics */

Select Count(Platform) as Platforms, Platform, Publisher
FROM Games_Sales.dbo.[Video Games Sales]
Group by Publisher, Platform
Order by 3;

Select Count(Game_title) as Selled_Game_Titles, Publisher
FROM Games_Sales.dbo.[Video Games Sales]
Group by Publisher
Order by 2;

Select Count(Game_title) as Selled_Game_Titles, Year
FROM Games_Sales.dbo.[Video Games Sales]
Group by Year
Order by 2;

Select Count(Genre) as Genre_over_Year, Genre, Year
FROM Games_Sales.dbo.[Video Games Sales]
Group by Genre, Year
Order by 2;

Select Publisher, AVG(Convert(float, Global)) as Sold_Global, AVG(Convert(float, Europe)) as Sold_Europe, AVG(Convert(float, North_America)) as Sold_North_America, AVG(Cast(Japan as float)) as Sold_Japan, AVG(Cast(Rest_of_World as float)) as Sold_Rest
FROM Games_Sales.dbo.[Video Games Sales]
Group by Publisher;

Select Review, Rank, Game_Title, Platform, Year, Genre, Publisher, Global
FROM Games_Sales.dbo.[Video Games Sales]
Where Cast(Review as float) >= 90
Order by 1 DESC;

/* Creating relevant Views */

Create view Rank_over_90 as
Select Review, Rank, Game_Title, Platform, Year, Genre, Publisher, Global
FROM Games_Sales.dbo.[Video Games Sales]
Where Cast(Review as float) >= 90;

Create view Regions_Selling as
Select Publisher, AVG(Convert(float, Global)) as Sold_Global, AVG(Convert(float, Europe)) as Sold_Europe, AVG(Convert(float, North_America)) as Sold_North_America, AVG(Cast(Japan as float)) as Sold_Japan, AVG(Cast(Rest_of_World as float)) as Sold_Rest
FROM Games_Sales.dbo.[Video Games Sales]
Group by Publisher;

