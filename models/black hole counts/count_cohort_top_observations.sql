WITH cohort_observations AS (
  SELECT
    o.observation_concept_id,
    COUNT(*) AS observation_count
  FROM
    {{ source('omop', 'observation') }} AS o
  INNER JOIN
    {{ ref('cohort') }} AS c
    ON
      o.person_id = c.person_id
  GROUP BY
    o.observation_concept_id
),

top_observations AS (
  SELECT TOP 10
    observation_concept_id,
    observation_count
  FROM
    cohort_observations
  ORDER BY
    observation_count DESC
)

SELECT
  t.observation_concept_id,
  t.observation_count,
  c.concept_name
FROM
  top_observations AS t
LEFT JOIN
  {{ source('vocab','concept') }} AS c
  ON
    t.observation_concept_id = c.concept_id