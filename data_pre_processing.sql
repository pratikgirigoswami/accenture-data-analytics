-- Check all the tables if they are imported correctly
SELECT * FROM content;
SELECT * FROM reactions;
SELECT * FROM reactiontypes;

-- Dropping unnecessary columns first, renaming some columns
ALTER TABLE content DROP MyUnknownColumn;
ALTER TABLE content DROP URL;
ALTER TABLE content RENAME COLUMN type TO ContentType;

ALTER TABLE reactions DROP MyUnknownColumn;
ALTER TABLE reactions RENAME COLUMN Type TO ReactionType;

ALTER TABLE reactiontypes DROP MyUnknownColumn;
ALTER TABLE reactiontypes RENAME COLUMN Type TO ReactionType;

-- Joining Tables
CREATE TABLE joined_dataset
SELECT content.*,reactions.ReactionType,reactions.Datetime,reactiontypes.Sentiment,reactiontypes.Score
FROM reactions
LEFT JOIN content
ON reactions.ContentID=content.ContentID
LEFT JOIN reactiontypes
ON reactions.ReactionType=reactiontypes.ReactionType;

-- Check the joined table
SELECT * FROM joined_dataset;

-- Data Cleaning--
-- Removing " from Category & converting into lower case
select distinct(Category) from joined_dataset;
UPDATE joined_dataset SET Category = TRIM(BOTH '"' FROM Category);
UPDATE joined_dataset SET Category = lower(Category);
-- Check for null values
SELECT count(*) FROM joined_dataset 
WHERE 
ContentID IS NULL OR
UserID IS NULL OR
ContentType IS NULL OR
Category IS NULL OR
ReactionType IS NULL OR
Datetime IS NULL OR
Sentiment IS NULL OR
Score IS NULL;
-- Removing null values
delete from joined_dataset 
where
ContentID IS NULL OR
UserID IS NULL OR
ContentType IS NULL OR
Category IS NULL OR
ReactionType IS NULL OR
Datetime IS NULL OR
Sentiment IS NULL OR
Score IS NULL;

