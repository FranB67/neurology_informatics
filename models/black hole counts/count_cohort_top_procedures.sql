WITH cohort_procedures AS (
  SELECT
    p.procedure_concept_id,
    COUNT(*) AS procedure_count
  FROM
    {{ source('omop', 'procedure_occurrence') }} AS p
  INNER JOIN
    {{ ref('cohort') }} AS c
    ON
      p.person_id = c.person_id
  WHERE
    p.procedure_date >= {{ var('clinic_visit_start_date') }}
    AND p.procedure_date <= {{ var('clinic_visit_end_date') }}
  GROUP BY
    p.procedure_concept_id
),

top_procedures AS (
  SELECT TOP 10
    procedure_concept_id,
    procedure_count
  FROM
    cohort_procedures
  ORDER BY
    procedure_count DESC
)

SELECT
  t.procedure_concept_id,
  t.procedure_count,
  c.concept_name
FROM
  top_procedures AS t
LEFT JOIN
  {{ source('vocab','concept') }} AS c
  ON
    t.procedure_concept_id = c.concept_id