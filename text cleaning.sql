WITH words AS (
    SELECT id, REGEXP_EXTRACT_ALL(lower(text), "[a-z]{4,}") AS words 
    FROM `project.database.textdata`), 
cleaned_words AS (
    SELECT id, w
    FROM words, UNNEST(words.words) AS w
    LEFT JOIN `project.Stopwords` s ON w = s.STOPWORD
    WHERE s.STOPWORD IS NULL)

SELECT cleaned_words.id, ARRAY_TO_STRING(ARRAY_AGG(cleaned_words.w), " ") AS cleaned_text
FROM cleaned_words
GROUP BY cleaned_words.id
HAVING ARRAY_AGG(cleaned_words.w) is not null and
array_length(ARRAY_AGG(cleaned_words.w)) > 35