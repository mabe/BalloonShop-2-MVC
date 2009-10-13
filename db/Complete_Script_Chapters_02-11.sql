CREATE DATABASE BalloonShop

GO

USE BalloonShop

GO

CREATE TABLE Department(
	DepartmentID INT IDENTITY(1,1) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	Description VARCHAR(1000) NULL,
 CONSTRAINT PK_Department PRIMARY KEY CLUSTERED (DepartmentID ASC)
)

GO

CREATE PROCEDURE GetDepartments AS
SELECT DepartmentID, Name, Description
FROM Department

GO

INSERT INTO Department(Name, Description)		
VALUES ('Anniversary Balloons', 'These sweet balloons are the perfect gift for someone you love.')
GO

INSERT INTO Department(Name, Description )		
VALUES ('Balloons for Children', 'The colorful and funny balloons will make any child smile!')
GO

CREATE TABLE Category(
	CategoryID INT IDENTITY(1,1) NOT NULL,
	DepartmentID INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	Description VARCHAR(1000) NULL,
 CONSTRAINT PK_Category_1 PRIMARY KEY CLUSTERED(CategoryID ASC)
)

GO

ALTER TABLE Category ADD CONSTRAINT FK_Category_Department FOREIGN KEY(DepartmentID)
REFERENCES Department (DepartmentID)

GO

CREATE TABLE Product(
	ProductID INT IDENTITY(1,1) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	Description VARCHAR(5000) NOT NULL,
	Price MONEY NOT NULL,
	Image1FileName VARCHAR(50) NULL,
	Image2FileName VARCHAR(50) NULL,
	OnCatalogPromotion BIT NOT NULL,
	OnDepartmentPromotion BIT NOT NULL,
 CONSTRAINT PK_Product PRIMARY KEY CLUSTERED (ProductID ASC)
) 

GO

CREATE TABLE ProductCategory(
	ProductID INT NOT NULL,
	CategoryID INT NOT NULL,
 CONSTRAINT PK_ProductCategory PRIMARY KEY CLUSTERED (ProductID ASC, CategoryID ASC)
) 

GO

ALTER TABLE ProductCategory  WITH CHECK ADD CONSTRAINT FK_ProductCategory_Category FOREIGN KEY(CategoryID)
REFERENCES Category (CategoryID)

GO

ALTER TABLE ProductCategory  WITH CHECK ADD  CONSTRAINT FK_ProductCategory_Product FOREIGN KEY(ProductID)
REFERENCES Product (ProductID)

GO

CREATE PROCEDURE GetCategoriesInDepartment
(@DepartmentID INT)
AS
SELECT CategoryID, Name, Description
FROM Category
WHERE DepartmentID = @DepartmentID

GO

CREATE PROCEDURE GetDepartmentDetails
(@DepartmentID INT)
AS
SELECT Name, Description
FROM Department
WHERE DepartmentID = @DepartmentID

GO

CREATE PROCEDURE GetCategoryDetails 
(@CategoryID INT)
AS
SELECT DepartmentID, Name, Description
FROM Category
WHERE CategoryID = @CategoryID

GO

CREATE PROCEDURE GetProductsOnDepartmentPromotion
(@DepartmentID INT,
@DescriptionLength INT,
@PageNumber INT,
@ProductsPerPage INT,
@HowManyProducts INT OUTPUT)
AS

-- declare a new TABLE variable
DECLARE @Products TABLE
(RowNumber INT,
 ProductID INT,
 Name VARCHAR(50),
 Description VARCHAR(5000),
 Price MONEY,
 Image1FileName VARCHAR(50),
 Image2FileName VARCHAR(50),
 OnDepartmentPromotion BIT,
 OnCatalogPromotion BIT)

-- populate the table variable with the complete list of products
INSERT INTO @Products    
SELECT ROW_NUMBER() OVER (ORDER BY ProductID) AS Row, 
       ProductID, Name, SUBSTRING(Description, 1, @DescriptionLength) + '...' AS Description,
       Price, Image1FileName, Image2FileName, OnDepartmentPromotion, OnCatalogPromotion
FROM 
(SELECT DISTINCT Product.ProductID, Product.Name, 
  SUBSTRING(Product.Description, 1, @DescriptionLength) + '...' AS Description,
  Price, Image1FileName, Image2FileName, OnDepartmentPromotion, OnCatalogPromotion
  FROM Product INNER JOIN ProductCategory
                      ON Product.ProductID = ProductCategory.ProductID
              INNER JOIN Category
                      ON ProductCategory.CategoryID = Category.CategoryID
  WHERE Product.OnDepartmentPromotion = 1 
   AND Category.DepartmentID = @DepartmentID
) AS ProductOnDepPr

-- return the total number of products using an OUTPUT variable
SELECT @HowManyProducts = COUNT(ProductID) FROM @Products

-- extract the requested page of products
SELECT ProductID, Name, Description, Price, Image1FileName,
       Image2FileName, OnDepartmentPromotion, OnCatalogPromotion
FROM @Products
WHERE RowNumber > (@PageNumber - 1) * @ProductsPerPage
  AND RowNumber <= @PageNumber * @ProductsPerPage

GO

CREATE PROCEDURE GetProductsOnCatalogPromotion
(@DescriptionLength INT,
@PageNumber INT,
@ProductsPerPage INT,
@HowManyProducts INT OUTPUT)
AS

-- declare a new TABLE variable
DECLARE @Products TABLE
(RowNumber INT,
 ProductID INT,
 Name VARCHAR(50),
 Description VARCHAR(5000),
 Price MONEY,
 Image1FileName VARCHAR(50),
 Image2FileName VARCHAR(50),
 OnDepartmentPromotion BIT,
 OnCatalogPromotion BIT)

-- populate the table variable with the complete list of products
INSERT INTO @Products
SELECT ROW_NUMBER() OVER (ORDER BY Product.ProductID),
       ProductID, Name, 
       SUBSTRING(Description, 1, @DescriptionLength) + '...' AS Description,
       Price, Image1FileName, Image2FileName, OnDepartmentPromotion, OnCatalogPromotion
FROM Product
WHERE OnCatalogPromotion = 1

-- return the total number of products using an OUTPUT variable
SELECT @HowManyProducts = COUNT(ProductID) FROM @Products

-- extract the requested page of products
SELECT ProductID, Name, Description, Price, Image1FileName,
       Image2FileName, OnDepartmentPromotion, OnCatalogPromotion
FROM @Products
WHERE RowNumber > (@PageNumber - 1) * @ProductsPerPage
  AND RowNumber <= @PageNumber * @ProductsPerPage

GO

CREATE PROCEDURE GetProductsInCategory
(@CategoryID INT,
@DescriptionLength INT,
@PageNumber INT,
@ProductsPerPage INT,
@HowManyProducts INT OUTPUT)
AS

-- declare a new TABLE variable
DECLARE @Products TABLE
(RowNumber INT,
 ProductID INT,
 Name VARCHAR(50),
 Description VARCHAR(5000),
 Price MONEY,
 Image1FileName VARCHAR(50),
 Image2FileName VARCHAR(50),
 OnDepartmentPromotion BIT,
 OnCatalogPromotion BIT)

-- populate the table variable with the complete list of products
INSERT INTO @Products
SELECT ROW_NUMBER() OVER (ORDER BY Product.ProductID),
       Product.ProductID, Name, 
       SUBSTRING(Description, 1, @DescriptionLength) + '...' AS Description,
       Price, Image1FileName, Image2FileName, OnDepartmentPromotion, OnCatalogPromotion
FROM Product INNER JOIN ProductCategory
  ON Product.ProductID = ProductCategory.ProductID
WHERE ProductCategory.CategoryID = @CategoryID

-- return the total number of products using an OUTPUT variable
SELECT @HowManyProducts = COUNT(ProductID) FROM @Products

-- extract the requested page of products
SELECT ProductID, Name, Description, Price, Image1FileName,
       Image2FileName, OnDepartmentPromotion, OnCatalogPromotion
FROM @Products
WHERE RowNumber > (@PageNumber - 1) * @ProductsPerPage
  AND RowNumber <= @PageNumber * @ProductsPerPage

GO

CREATE PROCEDURE GetProductDetails 
(@ProductID INT)
AS
SELECT Name, Description, Price, Image1FileName, Image2FileName, OnDepartmentPromotion, OnCatalogPromotion
FROM Product
WHERE ProductID = @ProductID
RETURN

GO



INSERT INTO Category (DepartmentID, Name, Description )		
VALUES (1, 'Love & Romance', 'Here''s our collection of balloons with romantic messages.')
GO

INSERT INTO Category (DepartmentID, Name, Description )		
VALUES (1, 'Birthdays', 'Tell someone "Happy Birthday" with one of these wonderful balloons!')
GO

INSERT INTO Category (DepartmentID, Name, Description )		
VALUES (1, 'Weddings', 'Going to a wedding? Here''s a collection of balloons for that special event!')
GO

INSERT INTO Category (DepartmentID, Name, Description )		
VALUES (2, 'Message Balloons', 'Why write on paper, when you can deliver your message on a balloon?')
GO

INSERT INTO Category (DepartmentID, Name, Description )		
VALUES (2, 'Cartoons', 'Buy a balloon with your child''s favorite cartoon character!')
GO

INSERT INTO Category (DepartmentID, Name, Description )		
VALUES (2, 'Miscellaneous', 'Various baloons that your kid will most certainly love!')
GO



INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('I Love You (Simon Elvin)', 'An adorable romantic balloon by Simon Elvin. You''ll fall in love with the cute bear bearing a bouquet of roses, a heart with I Love You, and a card.', 121.9900, 't0326801.jpg', '0326801.jpg', 0, 1)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Elvis Hunka Burning Love', 'A heart shaped balloon with the great Elvis on it and the words "You''re My Hunka Hunka Burnin'' Love!". Also a copy of the Kings Signature.', 12.9900, 't16110p.jpg', '16110p.jpg', 0, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Funny Love', 'A red heart-shaped balloon with "I love you" written on a white heart surrounded by cute little hearts and flowers.', 12.9900, 't16162p.jpg', '16162p.jpg', 0, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Today, Tomorrow & Forever', 'White heart-shaped balloon with the words "Today, Tomorrow and Forever" surrounded with red hearts of varying shapes. "I Love You" appears at the bottom in a red heart.', 12.9900, 't16363p.jpg', '16363p.jpg', 0, 1)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Smiley Heart Red Balloon', 'Red heart-shaped balloon with a smiley face. Perfect for saying I Love You!', 12.9900, 't16744p.jpg', '16744p.jpg', 0, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Love 24 Karat', 'A red heart-shaped balloon with "I Love You" in script writing. Gold heart outlines adorn the background.', 12.9900, 't16756p.jpg', '16756p.jpg', 0, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Smiley Kiss Red Balloon', 'Red heart-shaped balloon with a smiley face and three kisses. A perfect gift for Valentine''s Day!', 12.9900, 't16864p.jpg', '16864p.jpg', 0, 1)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Love You Hearts', 'A balloon with a simple message of love. What can be more romantic?', 12.9900, 't16967p.jpg', '16967p.jpg', 0, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Love Me Tender', 'A heart-shaped balloon with a picture of the King himself–Elvis Presley. This must-have for any Elvis fan has "Love Me Tender" written on it with a copy of Elvis''s signature.', 12.9900, 't16973p.jpg', '16973p.jpg', 0, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('I Can''t Get Enough of You Baby', 'When you just can''t get enough of someone, this Austin Powers style balloon says it all.', 12.9900, 't16974p.jpg', '16974p.jpg', 0, 1)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Picture Perfect Love Swing', 'A red heart-shaped balloon with a cute picture of two children kissing on a swing.', 12.9900, 't16980p.jpg', '16980p.jpg', 0, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('I Love You Roses', 'A white heart-shaped balloon has "I Love You" written on it and is beautifully decorated with two flowers, a small red heart in the middle, and miniature hearts all around.', 12.9900, 't214006p.jpg', '214006p.jpg', 0, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('I Love You Script', 'A romantic red heart-shaped balloon with "I Love You" in white. What more can you say?', 12.9900, 't214041p.jpg', '214041p.jpg', 0, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Love Rose', 'A white heart-shaped balloon with a rose and the words "I Love You." Romantic and irresistible.', 12.9900, 't214168p.jpg', '214168p.jpg', 0, 1)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('You''re So Special', 'Tell someone how special he or she is with this lovely heart-shaped balloon with a cute bear holding a flower.', 12.9900, 't215302p.jpg', '215302p.jpg', 0, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('I Love You Red Flourishes', 'A simple but romantic red heart-shaped balloon with "I Love You" in large script writing.', 12.9900, 't22849b.jpg', '22849b.jpg', 0, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('I Love You Script', 'A simple, romantic red heart-shaped balloon with "I Love You" in small script writing.', 12.9900, 't45093.jpg', '45093.jpg', 0, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Love Cascade Hearts', 'A romantic red heart-shaped balloon with hearts and I "Love You."', 12.9900, 't68841b.jpg', '68841b.jpg', 0, 1)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('You''re So Special', 'Someone special in your life? Let them know by sending this "You''re So Special" balloon!', 12.9900, 't7004801.jpg', '7004801.jpg', 0, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Love Script', 'Romance is in the air with this red heart-shaped balloon. Perfect for the love of your life.', 12.9900, 't7008501.jpg', '7008501.jpg', 0, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Baby Hi Little Angel', 'Baby Hi Little Angel', 12.9900, 't115343p.jpg', '115343p.jpg', 0, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('I''m Younger Than You', 'Roses are red, violets are blue, but this balloon isn''t a romantic balloon at all. Have a laugh, and tease someone older.', 12.9900, 't16118p.jpg', '16118p.jpg', 1, 1)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Birthday Balloon', 'Great Birthday Balloons. Available in pink or blue. One side says "Happy Birthday To You" and the other side says  "Birthday Girl" on the Pink Balloon and "Birthday Boy" on the Blue Balloon. Especially great for children''s parties.', 12.9900, 't26013.jpg', '26013.jpg', 0, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Birthday Star Balloon', 'Send a birthday message with this delightful star-shaped balloon and make someone''s day!', 12.9900, 't35732.jpg', '35732.jpg', 0, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Tweety Stars', 'A cute Tweety bird on a blue heart-shaped balloon with stars. Sylvester is in the background, plotting away as usual.', 12.9900, 't0276001.jpg', '0276001.jpg', 0, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('You''re Special', 'An unusual heart-shaped balloon with the words "You''re special.".', 12.9900, 't0704901.jpg', '0704901.jpg', 1, 1)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('I''m Sorry (Simon Elvin) Balloon', 'The perfect way to say you''re sorry. Send a thought with this cute bear  balloon.', 12.9900, 't0707401.jpg', '0707401.jpg', 0, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('World''s Greatest Mom', 'A lovely way to tell your Mom that she''s special. Surprise her with this lovely balloon on her doorstep.', 12.9900, 't114103p.jpg', '114103p.jpg', 0, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Good Luck', 'Big day ahead? Wish someone "Good Luck" with this colorful balloon!', 12.9900, 't114118p.jpg', '114118p.jpg', 0, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Big Congratulations Balloon', 'Does someone deserve a special pat on the back? This balloon is a perfect way to pass on the message', 12.9900, 't114208p.jpg', '114208p.jpg', 1, 1)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('You''re So Special', 'A purple balloon with the simple words "You''re so Special!" on it. Go on, let them know they are special.', 12.9900, 't16148p.jpg', '16148p.jpg', 0, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Thinking of You', 'A round balloon just screaming out "Thinking of You!"; especially great if you are far away from someone you care for.', 12.9900, 't16151p.jpg', '16151p.jpg', 0, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Welcome Back', 'A great way to say Welcome Back!', 12.9900, 't16558p.jpg', '16558p.jpg', 1, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Words of Thanks', 'A round balloon with lots and lots of Thank You''s written on it. You''re sure to get the message through with this grateful balloon.', 12.9900, 't16772p.jpg', '16772p.jpg', 0, 1)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Missed You''ll Be', 'If someone special is Going away, let this cute puppy balloon tell them they''ll be missed.', 12.9900, 't16809p.jpg', '16809p.jpg', 0, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('You''re Appreciated', 'A spotty balloon with the words "You''re Appreciated". I bet they''ll appreciate it too!', 12.9900, 't16988p.jpg', '16988p.jpg', 0, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Thinking of You', 'Thinking of someone? Let them know with this thoughtful heart-shaped balloon with flowers in the background.', 12.9900, 't214046p.jpg', '214046p.jpg', 0, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Get Well–Daisy Smiles', 'We all get sick sometimes and need something to cheer us up. Make the world brighter for someone with this Get Well Soon balloon.', 12.9900, 't21825b.jpg', '21825b.jpg', 0, 1)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Toy Story', 'Woody and Buzz from Toy Story, on a round balloon.', 12.9900, 't0366101.jpg', '0366101.jpg', 1, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Rugrats Tommy & Chucky', 'If you are a Rugrats fan, you''ll be nuts about this purple Rugrats balloon featuring Chucky and Tommy. A definite Nickelodeon Toon favorite.', 12.9900, 't03944l.jpg', '03944l.jpg', 0, 1)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Rugrats & Reptar Character', 'Rugrats balloon featuring Angelica, Chucky, Tommy, and Reptar.', 12.9900, 't03945L.jpg', '03945L.jpg', 0, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Tweety & Sylvester', 'A blue round balloon with the great cartoon pair: Tweety & Sylvester.', 12.9900, 't0510801.jpg', '0510801.jpg', 0, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Mickey Close-up', 'A close-up of Mickey Mouse on a blue heart-shaped balloon. Check out our close-up matching Minnie balloon.', 12.9900, 't0521201.jpg', '0521201.jpg', 1, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Minnie Close-up', 'A close-up of Minnie Mouse on a pink heart-shaped balloon. Check out our close-up matching Mickey balloon.', 12.9900, 't0522101.jpg', '0522101.jpg', 0, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Teletubbies Time', 'Time for Teletubbies balloon. Great gift for any kid.', 12.9900, 't0611401.jpg', '0611401.jpg', 0, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Barbie My Special Things', 'Barbie and her friends on a round balloon.', 12.9900, 't0661701.jpg', '0661701.jpg', 0, 1)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Paddington Bear', 'Remember Paddington? A must-have for any Paddington Bear lover.', 12.9900, 't215017p.jpg', '215017p.jpg', 0, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('I Love You Snoopy', 'The one and only Snoopy hugging Charlie Brown to say "I Love You."', 12.9900, 't215402p.jpg', '215402p.jpg', 0, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Pooh Adult', 'An adorable Winnie the Pooh balloon.', 12.9900, 't81947pl.jpg', '81947pl.jpg', 0, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Pokemon Character', 'A Pokemon balloon with a lot of mini pictures of the rest of the cast. Pokemon, Gotta catch ''em all!', 12.9900, 't83947.jpg', '83947.jpg', 0, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Pokemon Ash & Pikachu', 'A Pokemon balloon with Ash and Pikachu. Gotta catch ''em all!', 12.9900, 't83951.jpg', '83951.jpg', 0, 1)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Smiley Kiss Yellow', 'The ever-famous Smiley Face balloon on the classic yellow background with three smooch kisses.', 12.9900, 't16862p.jpg', '16862p.jpg', 0, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Smiley Face', 'A red heart-shaped balloon with a cartoon smiley face.', 12.9900, 't214154p.jpg', '214154p.jpg', 0, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Soccer Shape', 'A soccer-shaped balloon great for any soccer fan.', 12.9900, 't28734.jpg', '28734.jpg', 0, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Goal Ball', 'A round soccer balloon. Ideal for any sports fan, or an original way to celebrate an important Goal in that "oh so important" game.', 12.9900, 'ta1180401.jpg', 'a1180401.jpg', 0, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Wedding Doves', 'A white heart-shaped balloon with wedding wishes and intricate designs of doves in silver.', 12.9900, 't1368601.jpg', '1368601.jpg', 0, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Crystal Rose Silver', 'A transparent heart-shaped balloon with silver roses. Perfect for a silver anniversary or a wedding with a silver theme.', 12.9900, 't38196.jpg', '38196.jpg', 0, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Crystal Rose Gold', 'A transparent heart-shaped balloon with Gold roses. Perfect for a Golden anniversary or a wedding with a Gold theme.', 12.9900, 't38199.jpg', '38199.jpg', 0, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Crystal Rose Red', 'A transparent heart-shaped balloon with red roses. Perfect for an anniversary or a wedding with a red theme.', 12.9900, 't38202.jpg', '38202.jpg', 0, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Crystal Etched Hearts', 'A transparent heart-shaped balloon with silver hearts. Perfect for a silver anniversary or a wedding with a silver theme.', 12.9900, 't42014.jpg', '42014.jpg', 0, 1)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Crystal Love Doves Silver', 'A transparent heart-shaped balloon with two love doves in silver.', 12.9900, 't42080.jpg', '42080.jpg', 0, 0)
GO

INSERT INTO Product(Name, Description, Price, Image1FileName, Image2FileName, OnCatalogPromotion, ondepartmentpromotion )		
VALUES ('Crystal Etched Hearts', 'A transparent heart-shaped balloon with red hearts.', 12.9900, 't42139.jpg', '42139.jpg', 0, 0)
GO



INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(1, 1)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(1, 2)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(2, 1)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(2, 4)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(2, 6)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(3, 1)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(3, 3)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(3, 4)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(4, 1)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(4, 2)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(4, 4)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(4, 6)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(5, 1)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(6, 1)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(6, 3)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(6, 4)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(7, 1)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(8, 1)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(9, 1)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(10, 1)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(11, 1)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(12, 1)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(12, 4)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(13, 1)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(13, 4)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(14, 1)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(14, 4)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(15, 1)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(16, 1)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(16, 4)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(17, 1)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(17, 4)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(18, 1)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(18, 4)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(19, 1)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(19, 4)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(19, 6)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(20, 1)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(20, 4)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(21, 4)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(21, 5)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(21, 6)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(22, 2)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(22, 4)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(23, 2)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(23, 4)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(24, 2)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(25, 5)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(26, 1)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(26, 4)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(28, 2)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(28, 4)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(28, 6)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(29, 4)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(30, 4)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(30, 6)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(31, 4)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(32, 4)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(33, 4)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(34, 4)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(35, 4)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(36, 4)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(37, 4)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(37, 6)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(38, 4)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(38, 6)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(39, 5)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(40, 5)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(41, 5)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(42, 5)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(43, 5)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(44, 5)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(45, 5)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(46, 5)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(47, 5)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(48, 5)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(49, 5)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(50, 5)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(51, 5)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(52, 6)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(53, 5)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(53, 6)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(54, 5)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(54, 6)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(55, 5)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(55, 6)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(56, 3)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(57, 1)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(57, 2)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(57, 3)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(58, 1)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(58, 2)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(58, 3)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(59, 1)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(59, 2)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(59, 3)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(60, 1)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(60, 2)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(60, 3)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(61, 1)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(61, 3)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(62, 1)
GO

INSERT INTO ProductCategory(ProductID, CategoryID)		
VALUES(62, 3)
GO
CREATE FUNCTION dbo.WordCount
(@Word VARCHAR(15), 
@Phrase VARCHAR(1000))
RETURNS SMALLINT
AS
BEGIN

/* If @Word or @Phrase is NULL the function returns 0 */
IF @Word IS NULL OR @Phrase IS NULL RETURN 0

/* @BiggerWord is a string one character longer than @Word */
DECLARE @BiggerWord VARCHAR(21)
SELECT @BiggerWord = @Word + 'x'

/* Replace @Word with @BiggerWord in @Phrase */
DECLARE @BiggerPhrase VARCHAR(2000)
SELECT @BiggerPhrase = REPLACE (@Phrase, @Word, @BiggerWord)

/* The length difference between @BiggerPhrase and @phrase
   is the number we''re looking for */
RETURN LEN(@BiggerPhrase) - LEN(@Phrase)
END

GO

CREATE PROCEDURE SearchCatalog 
(@DescriptionLength INT,
 @PageNumber TINYINT,
 @ProductsPerPage TINYINT,
 @HowManyResults SMALLINT OUTPUT,
 @AllWords BIT,
 @Word1 VARCHAR(15) = NULL,
 @Word2 VARCHAR(15) = NULL,
 @Word3 VARCHAR(15) = NULL,
 @Word4 VARCHAR(15) = NULL,
 @Word5 VARCHAR(15) = NULL)
AS

/* Create the table variable that will contain the search results */
DECLARE @Products TABLE
(RowNumber SMALLINT IDENTITY (1,1) NOT NULL,
 ProductID INT,
 Name VARCHAR(50),
 Description VARCHAR(1000),
 Price MONEY,
 Image1FileName VARCHAR(50),
 Image2FileName VARCHAR(50),
 Rank INT)

/* Populate @Products for an any-words search */
IF @AllWords = 0 
   INSERT INTO @Products           
   SELECT ProductID, Name, 
          SUBSTRING(Description, 1, @DescriptionLength) + '...' AS Description, 
          Price, Image1FileName, Image2FileName,
          3 * dbo.WordCount(@Word1, Name) + dbo.WordCount(@Word1, Description) +
          3 * dbo.WordCount(@Word2, Name) + dbo.WordCount(@Word2, Description) +
          3 * dbo.WordCount(@Word3, Name) + dbo.WordCount(@Word3, Description) +
          3 * dbo.WordCount(@Word4, Name) + dbo.WordCount(@Word4, Description) +
          3 * dbo.WordCount(@Word5, Name) + dbo.WordCount(@Word5, Description) 
          AS Rank
   FROM Product
   ORDER BY Rank DESC
   
/* Populate @Products for an all-words search */
IF @AllWords = 1 
   INSERT INTO @Products           
   SELECT ProductID, Name, 
          SUBSTRING(Description, 1, @DescriptionLength) + '...' AS Description, 
          Price, Image1FileName, Image2FileName,
          (3 * dbo.WordCount(@Word1, Name) + dbo.WordCount(@Word1, Description)) *
          CASE 
            WHEN @Word2 IS NULL THEN 1 
            ELSE 3 * dbo.WordCount(@Word2, Name) + dbo.WordCount(@Word2, Description)
          END *
          CASE 
            WHEN @Word3 IS NULL THEN 1 
            ELSE 3 * dbo.WordCount(@Word3, Name) + dbo.WordCount(@Word3, Description)
          END *
          CASE 
            WHEN @Word4 IS NULL THEN 1 
            ELSE 3 * dbo.WordCount(@Word4, Name) + dbo.WordCount(@Word4, Description)
          END *
          CASE 
            WHEN @Word5 IS NULL THEN 1 
            ELSE 3 * dbo.WordCount(@Word5, Name) + dbo.WordCount(@Word5, Description)
          END
          AS Rank
   FROM Product
   ORDER BY Rank DESC

/* Save the number of searched products in an output variable */
SELECT @HowManyResults = COUNT(*) 
FROM @Products 
WHERE Rank > 0

/* Send back the requested products */
SELECT ProductID, Name, Description, Price, Image1FileName, Image2FileName, Rank
FROM @Products
WHERE Rank > 0
  AND RowNumber BETWEEN (@PageNumber-1) * @ProductsPerPage + 1 
                    AND @PageNumber * @ProductsPerPage
ORDER BY Rank DESC

GO

CREATE PROCEDURE AddDepartment
(@DepartmentName VARCHAR(50),
@DepartmentDescription VARCHAR(1000))
AS
INSERT INTO Department (Name, Description)
VALUES (@DepartmentName, @DepartmentDescription)

GO

CREATE PROCEDURE UpdateDepartment
(@DepartmentID INT,
@DepartmentName VARCHAR(50),
@DepartmentDescription VARCHAR(1000))
AS
UPDATE Department
SET Name = @DepartmentName, Description = @DepartmentDescription
WHERE DepartmentID = @DepartmentID

GO

CREATE PROCEDURE DeleteDepartment
(@DepartmentID INT)
AS
DELETE FROM Department
WHERE DepartmentID = @DepartmentID

GO

CREATE PROCEDURE CreateCategory
(@DepartmentID INT,
@CategoryName VARCHAR(50),
@CategoryDescription VARCHAR(50))
AS
INSERT INTO Category (DepartmentID, Name, Description)
VALUES (@DepartmentID, @CategoryName, @CategoryDescription)

GO

CREATE PROCEDURE UpdateCategory
(@CategoryID INT,
@CategoryName VARCHAR(50),
@CategoryDescription VARCHAR(1000))
AS
UPDATE Category
SET Name = @CategoryName, Description = @CategoryDescription
WHERE CategoryID = @CategoryID

GO

CREATE PROCEDURE DeleteCategory
(@CategoryID INT)
AS
DELETE FROM Category
WHERE CategoryID = @CategoryID

GO

CREATE PROCEDURE GetAllProductsInCategory
(@CategoryID INT)
AS
SELECT Product.ProductID, Name, Description, Price, Image1FileName, 
       Image2FileName, OnDepartmentPromotion, OnCatalogPromotion
FROM Product INNER JOIN ProductCategory
  ON Product.ProductID = ProductCategory.ProductID
WHERE ProductCategory.CategoryID = @CategoryID

GO

CREATE PROCEDURE CreateProduct
(@CategoryID INT,
 @ProductName VARCHAR(50),
 @ProductDescription VARCHAR(1000),
 @ProductPrice MONEY,
 @Image1FileName VARCHAR(50),
 @Image2FileName VARCHAR(50),
 @OnDepartmentPromotion BIT,
 @OnCatalogPromotion BIT)
AS
-- Declare a variable to hold the generated product ID
DECLARE @ProductID INT
-- Create the new product entry
INSERT INTO Product 
    (Name, 
     Description, 
     Price, 
     Image1FileName, 
     Image2FileName,
     OnDepartmentPromotion, 
     OnCatalogPromotion )
VALUES 
    (@ProductName, 
     @ProductDescription, 
     @ProductPrice, 
     @Image1FileName, 
     @Image2FileName,
     @OnDepartmentPromotion, 
     @OnCatalogPromotion)
-- Save the generated product ID to a variable
SELECT @ProductID = @@Identity
-- Associate the product with a category
INSERT INTO ProductCategory (ProductID, CategoryID)
VALUES (@ProductID, @CategoryID)

GO

CREATE PROCEDURE UpdateProduct
(@ProductID INT,
 @ProductName VARCHAR(50),
 @ProductDescription VARCHAR(5000),
 @ProductPrice MONEY,
 @Image1FileName VARCHAR(50),
 @Image2FileName VARCHAR(50),
 @OnDepartmentPromotion BIT,
 @OnCatalogPromotion BIT)
AS
UPDATE Product
SET Name = @ProductName,
    Description = @ProductDescription,
    Price = @ProductPrice,
    Image1FileName = @Image1FileName,
    Image2FileName = @Image2FileName,
    OnDepartmentPromotion = @OnDepartmentPromotion,
    OnCatalogPromotion = @OnCatalogPromotion
WHERE ProductID = @ProductID

GO

CREATE PROCEDURE MoveProductToCategory
(@ProductID INT, @OldCategoryID INT, @NewCategoryID INT)
AS
UPDATE ProductCategory
SET CategoryID = @NewCategoryID
WHERE CategoryID = @OldCategoryID
  AND ProductID = @ProductID

GO

CREATE PROCEDURE AssignProductToCategory
(@ProductID INT, @CategoryID INT)
AS
INSERT INTO ProductCategory (ProductID, CategoryID)
VALUES (@ProductID, @CategoryID)

GO

CREATE PROCEDURE RemoveProductFromCategory
(@ProductID INT, @CategoryID INT)
AS
DELETE FROM ProductCategory
WHERE CategoryID = @CategoryID AND ProductID = @ProductID

GO

CREATE PROCEDURE DeleteProduct
(@ProductID INT)
AS
DELETE FROM ProductCategory WHERE ProductID=@ProductID
DELETE FROM Product where ProductID=@ProductID

GO

CREATE PROCEDURE GetCategoriesWithProduct
(@ProductID INT)
AS
SELECT Category.CategoryID, Name
FROM Category INNER JOIN ProductCategory
ON Category.CategoryID = ProductCategory.CategoryID
WHERE ProductCategory.ProductID = @ProductID

GO

CREATE PROCEDURE GetCategoriesWithoutProduct
(@ProductID INT)
AS
SELECT CategoryID, Name
FROM Category
WHERE CategoryID NOT IN
   (SELECT Category.CategoryID
    FROM Category INNER JOIN ProductCategory
    ON Category.CategoryID = ProductCategory.CategoryID
    WHERE ProductCategory.ProductID = @ProductID)

GO
CREATE TABLE ShoppingCart(
	CartID char(36) NOT NULL,
	ProductID INT NOT NULL,
	Quantity INT NOT NULL,
	DateAdded SMALLDATETIME NOT NULL,
 CONSTRAINT PK_ShoppingCart PRIMARY KEY CLUSTERED (CartID ASC, ProductID ASC)
)

GO

ALTER TABLE ShoppingCart WITH CHECK ADD CONSTRAINT FK_ShoppingCart_Product FOREIGN KEY(ProductID)
REFERENCES Product (ProductID)

GO

CREATE PROCEDURE ShoppingCartAddItem
(@CartID char(36),
 @ProductID INT)
AS
IF EXISTS 
        (SELECT CartID 
         FROM ShoppingCart 
         WHERE ProductID = @ProductID AND CartID = @CartID)
    UPDATE ShoppingCart
    SET Quantity = Quantity + 1
    WHERE ProductID = @ProductID AND CartID = @CartID
ELSE
    IF EXISTS (SELECT Name FROM Product WHERE ProductID=@ProductID)
        INSERT INTO ShoppingCart (CartID, ProductID, Quantity, DateAdded)
        VALUES (@CartID, @ProductID, 1, GETDATE())

GO

CREATE PROCEDURE ShoppingCartGetItems
(@CartID char(36))
AS
SELECT Product.ProductID, Product.Name, Product.Price, ShoppingCart.Quantity, 
       Product.Price * ShoppingCart.Quantity AS Subtotal
FROM ShoppingCart INNER JOIN Product
ON ShoppingCart.ProductID = Product.ProductID
WHERE ShoppingCart.CartID = @CartID

GO

CREATE PROCEDURE ShoppingCartGetTotalAmount
(@CartID char(36))
AS
SELECT ISNULL(SUM(Product.Price * ShoppingCart.Quantity), 0)
FROM ShoppingCart INNER JOIN Product
ON ShoppingCart.ProductID = Product.ProductID
WHERE ShoppingCart.CartID = @CartID

GO

CREATE PROCEDURE ShoppingCartRemoveItem
(@CartID char(36),
 @ProductID INT)
AS
DELETE FROM ShoppingCart
WHERE CartID = @CartID and ProductID = @ProductID

GO

CREATE Procedure ShoppingCartUpdateItem
(@CartID char(36),
 @ProductID INT,
 @Quantity INT)
As
IF @Quantity <= 0 
  EXEC ShoppingCartRemoveItem @CartID, @ProductID
ELSE
  UPDATE ShoppingCart
  SET Quantity = @Quantity, DateAdded = GETDATE()
  WHERE ProductID = @ProductID AND CartID = @CartID

GO

ALTER PROCEDURE DeleteProduct
(@ProductID INT)
AS
DELETE FROM ShoppingCart WHERE ProductID=@ProductID
DELETE FROM ProductCategory WHERE ProductID=@ProductID
DELETE FROM Product where ProductID=@ProductID

GO

CREATE PROCEDURE ShoppingCartDeleteOldCarts
(@Days smallINT)
AS
DELETE FROM ShoppingCart
WHERE CartID IN
  (SELECT CartID
   FROM ShoppingCart
   GROUP BY CartID
   HAVING MIN(DATEDIFF(dd,DateAdded,GETDATE())) >= @Days)

GO

CREATE PROCEDURE ShoppingCartCountOldCarts
(@Days smallINT)
AS
SELECT COUNT(CartID) 
FROM ShoppingCart
WHERE CartID IN
  (SELECT CartID
   FROM ShoppingCart
   GROUP BY CartID
   HAVING MIN(DATEDIFF(dd,DateAdded,GETDATE())) >= @Days)

GO
CREATE TABLE Orders(
	OrderID INT IDENTITY(1,1) NOT NULL,
	DateCreated SMALLDATETIME NOT NULL CONSTRAINT DF_Orders_DateCreated  DEFAULT (getdate()),
	DateShipped SMALLDATETIME NULL,
	Verified BIT NOT NULL CONSTRAINT DF_Orders_Verified DEFAULT ((0)),
	Completed BIT NOT NULL CONSTRAINT DF_Orders_Completed DEFAULT ((0)),
	Canceled BIT NOT NULL CONSTRAINT DF_Orders_Canceled DEFAULT ((0)),
	Comments VARCHAR(1000) NULL,
	CustomerName VARCHAR(50) NULL,
	CustomerEmail VARCHAR(50) NULL,
	ShippingAddress VARCHAR(500) NULL,
 CONSTRAINT PK_Orders PRIMARY KEY CLUSTERED(OrderID ASC)
)

GO

CREATE TABLE OrderDetail(
	OrderID INT NOT NULL,
	ProductID INT NOT NULL,
	ProductName VARCHAR(50) NOT NULL,
	Quantity INT NOT NULL,
	UnitCost MONEY NOT NULL,
	Subtotal  AS (Quantity*UnitCost),
 CONSTRAINT PK_OrderDetail PRIMARY KEY CLUSTERED(OrderID ASC, ProductID ASC)
)
  
GO

ALTER TABLE OrderDetail WITH CHECK ADD CONSTRAINT FK_OrderDetail_Orders FOREIGN KEY(OrderID)
REFERENCES Orders (OrderID)

GO

CREATE PROCEDURE CreateOrder 
(@CartID char(36))
AS
/* Insert a new record INTo Orders */
DECLARE @OrderID INT
INSERT INTO Orders DEFAULT VALUES
/* Save the new Order ID */
SET @OrderID = @@IDENTITY
/* Add the order details to OrderDetail */
INSERT INTO OrderDetail 
     (OrderID, ProductID, ProductName, Quantity, UnitCost)
SELECT 
     @OrderID, Product.ProductID, Product.Name, 
     ShoppingCart.Quantity, Product.Price
FROM Product JOIN ShoppingCart
ON Product.ProductID = ShoppingCart.ProductID
WHERE ShoppingCart.CartID = @CartID
/* Clear the shopping cart */
DELETE FROM ShoppingCart
WHERE CartID = @CartID
/* Return the Order ID */
SELECT @OrderID

GO

CREATE PROCEDURE OrderGetDetails
(@OrderID INT)
AS
SELECT Orders.OrderID, 
       ProductID, 
       ProductName, 
       Quantity, 
       UnitCost, 
       Subtotal
FROM OrderDetail JOIN Orders
ON Orders.OrderID = OrderDetail.OrderID
WHERE Orders.OrderID = @OrderID

GO

CREATE PROCEDURE OrdersGetByRecent 
(@Count smallINT)
AS
-- Set the number of rows to be returned
SET ROWCOUNT @Count
-- Get list of orders
SELECT OrderID, DateCreated, DateShipped, 
       Verified, Completed, Canceled, CustomerName
FROM Orders
ORDER BY DateCreated DESC
-- Reset rowcount value
SET ROWCOUNT 0

GO

CREATE PROCEDURE OrdersGetByDate 
(@StartDate SMALLDATETIME,
 @EndDate SMALLDATETIME)
AS
SELECT OrderID, DateCreated, DateShipped, 
       Verified, Completed, Canceled, CustomerName
FROM Orders
WHERE DateCreated BETWEEN @StartDate AND @EndDate
ORDER BY DateCreated DESC

GO

CREATE PROCEDURE OrdersGetUnverifiedUncanceled
AS
SELECT OrderID, DateCreated, DateShipped, 
       Verified, Completed, Canceled, CustomerName
FROM Orders
WHERE Verified=0 AND Canceled=0
ORDER BY DateCreated DESC

GO

CREATE PROCEDURE OrdersGetVerifiedUncompleted
AS
SELECT OrderID, DateCreated, DateShipped, 
       Verified, Completed, Canceled, CustomerName
FROM Orders
WHERE Verified=1 AND Completed=0
ORDER BY DateCreated DESC

GO

CREATE PROCEDURE OrderGetInfo
(@OrderID INT)
AS
SELECT OrderID, 
      (SELECT ISNULL(SUM(Subtotal), 0) FROM OrderDetail WHERE OrderID = @OrderID) 
       AS TotalAmount, 
       DateCreated, 
       DateShipped, 
       Verified, 
       Completed, 
       Canceled, 
       Comments, 
       CustomerName, 
       ShippingAddress, 
       CustomerEmail
FROM Orders
WHERE OrderID = @OrderID

GO

CREATE PROCEDURE OrderUpdate
(@OrderID INT,
 @DateCreated SMALLDATETIME,
 @DateShipped SMALLDATETIME = NULL,
 @Verified BIT,
 @Completed BIT,
 @Canceled BIT,
 @Comments VARCHAR(200),
 @CustomerName VARCHAR(50),
 @ShippingAddress VARCHAR(200),
 @CustomerEmail VARCHAR(50))
AS
UPDATE Orders
SET DateCreated=@DateCreated,
    DateShipped=@DateShipped,
    Verified=@Verified,
    Completed=@Completed,
    Canceled=@Canceled,
    Comments=@Comments,
    CustomerName=@CustomerName,
    ShippingAddress=@ShippingAddress,
    CustomerEmail=@CustomerEmail
WHERE OrderID = @OrderID

GO

CREATE PROCEDURE OrderMarkVerified
(@OrderID INT)
AS
UPDATE Orders
SET Verified = 1
WHERE OrderID = @OrderID

GO

CREATE PROCEDURE OrderMarkCompleted
(@OrderID INT)
AS
UPDATE Orders
SET Completed = 1,
    DateShipped = GETDATE()
WHERE OrderID = @OrderID

GO

CREATE PROCEDURE OrderMarkCanceled
(@OrderID INT)
AS
UPDATE Orders
SET Canceled = 1
WHERE OrderID = @OrderID

GO
CREATE PROCEDURE GetProductRecommendations
(@ProductID INT,
 @DescriptionLength INT)
AS
SELECT ProductID, 
       Name, 
       SUBSTRING(Description, 1, @DescriptionLength) + '...' AS Description
FROM Product
WHERE ProductID IN
    (
    SELECT TOP 5 od2.ProductID
    FROM OrderDetail od1
    JOIN OrderDetail od2 ON od1.OrderID = od2.OrderID
    WHERE od1.ProductID = @ProductID AND od2.ProductID != @ProductID
    GROUP BY od2.ProductID
    ORDER BY COUNT(od2.ProductID) DESC
    )

GO

CREATE PROCEDURE GetProductRecommendations2
(@ProductID INT,
 @DescriptionLength INT)
AS
--- Returns the product recommendations
SELECT ProductID,
       Name,
       SUBSTRING(Description, 1, @DescriptionLength) + '...' AS Description
FROM Product
WHERE ProductID IN
   (
   -- Returns the products that were ordered together with @ProductID
   SELECT TOP 5 ProductID
   FROM OrderDetail
   WHERE OrderID IN
      (
      -- Returns the orders that contain @ProductID
      SELECT DISTINCT OrderID
      FROM OrderDetail
      WHERE ProductID = @ProductID
      )
   -- Must not include products that already exist in the visitor''s cart
   AND ProductID <> @ProductID
   -- Group the ProductID so we can calculate the rank
   GROUP BY ProductID
   -- Order descending by rank
   ORDER BY COUNT(ProductID) DESC
   )

GO

CREATE PROCEDURE GetShoppingCartRecommendations
(@CartID CHAR(36),
 @DescriptionLength INT)
AS
--- Returns the product recommendations
SELECT ProductID,
       Name,
       SUBSTRING(Description, 1, @DescriptionLength) + '...' AS Description
FROM Product
WHERE ProductID IN
   (
   -- Returns the products that exist in a list of orders
   SELECT TOP 5 od1.ProductID AS Rank
   FROM OrderDetail od1 
     JOIN OrderDetail od2
       ON od1.OrderID=od2.OrderID
     JOIN ShoppingCart sp
       ON od2.ProductID = sp.ProductID
   WHERE sp.CartID = @CartID
        -- Must not include products that already exist in the visitor''s cart
      AND od1.ProductID NOT IN
      (
      -- Returns the products in the specified shopping cart
      SELECT ProductID 
      FROM ShoppingCart
      WHERE CartID = @CartID
      )
   -- Group the ProductID so we can calculate the rank
   GROUP BY od1.ProductID
   -- Order descending by rank
   ORDER BY COUNT(od1.ProductID) DESC
   )

GO

CREATE PROCEDURE GetShoppingCartRecommendations2
(@CartID CHAR(36),
 @DescriptionLength INT)
AS
--- Returns the product recommendations
SELECT ProductID,
       Name,
       SUBSTRING(Description, 1, @DescriptionLength) + '...' AS Description
FROM Product
WHERE ProductID IN
   (
   -- Returns the products that exist in a list of orders
   SELECT TOP 5 ProductID
   FROM OrderDetail
   WHERE OrderID IN
      (
      -- Returns the orders that contain certain products
      SELECT DISTINCT OrderID 
      FROM OrderDetail 
      WHERE ProductID IN
         (
         -- Returns the products in the specified shopping cart
         SELECT ProductID 
         FROM ShoppingCart
         WHERE CartID = @CartID
         )
      )
   -- Must not include products that already exist in the visitor''s cart
   AND ProductID NOT IN
      (
      -- Returns the products in the specified shopping cart
      SELECT ProductID 
      FROM ShoppingCart
      WHERE CartID = @CartID
      )
   -- Group the ProductID so we can calculate the rank
   GROUP BY ProductID
   -- Order descending by rank
   ORDER BY COUNT(ProductID) DESC
   )

GO
