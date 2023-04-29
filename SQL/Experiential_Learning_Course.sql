/*
PURPOSE: List previously offered courses for Experiental Learning(EL) credit for colleges and the necessary attributes for each course.

Why: so students can view EL courses and which semesters they may be offered in the future.
	Criteria: 
		 Only applies to courses within the past 4 academic years that are (A)ctive courses with greater than 0 enrolled students.
		 Course attribute starts with X, FS, or the course description starts with Study Abroad.
	Tables used:
		[Banner_Student_ODS].[ref].[ODS_STVCOLL]
		[Banner_Student_ODS].[sds].[COURSE_ATTRIBUTE]
		[Banner_Student_ODS].[sds].[COURSE_SECTION_DETAIL]
		[Common].[dbo].[Date]
		#EL_Course

	Note: Data is entered into a temp table as required to concatenate the College descriptions for each course ID into one cell.
		This is because the data needs to be filtered on an external application using the application's
		filtering methods to meet the end-user needs
		If another application is used to filter the data, another output format may be appropriate.
*/

	-- the @Requested_Term_Code parameter is optional in the event a different term code needs to be used to filter data in the where clause of the first sub-select.
	DECLARE @EL_Attribute VARCHAR(100) = 'X%'
			,@FS_Attribute VARCHAR(100) = 'FS%'
			,@SA_Attribute VARCHAR(100) = 'Study Abroad%'
			,@Requested_Term_Code VARCHAR(6)
			,@Current_Term_Code VARCHAR(6)
			,@Date_Key INT = CONVERT(INT, FORMAT(GETDATE(), 'yyyyMMdd'))

	SET @Current_Term_Code = CASE	WHEN (@Requested_Term_Code) IS NULL OR (@Requested_Term_Code = '')
									THEN (SELECT cd2.[Term_Code]
											FROM [Common].[dbo].[Date] AS cd2
											WHERE cd2.[DateKey] = @Date_Key
											)
									ELSE (SELECT DISTINCT
												cd2.[Term_Code]
											FROM [Common].[dbo].[Date] AS cd2
											WHERE cd2.[Term_Code] = @Requested_Term_Code
											)
									END
	SELECT DISTINCT
			[Term_Code]
			,[Term_Desc]
			,[Course_ID]
			,[Course_Title_Short]
			,[College_Code]	=				el_inner.[College_Code]
			,[College_Desc] = CASE	WHEN [College_Desc] IS NULL
									THEN '#NA'
									ELSE [College_Desc]
								END
			,[Course_Type]
			,[Experiential_Learning_Code]
			,[Field_Study_or_Study_Abroad]

	-- subselect gets the initial dataset with a unique record per course, crn, college, term code

	FROM (SELECT [Term_Code] =				ca.[Term_Code]
				,[Term_Desc] =				ca.[Term_Desc]
				,[Course_ID] =				ca.[Course_ID]
				,[Course_Title_Short] =		csd.[Course_Title_Short]
				,[Subject_Code] =			ca.[Subject_Code]
				,[Course_Number] =			ca.[Course_Number]
				,[CRN] =					ca.[CRN]
				,[Course_Attribute_Code] =	ca.[Course_Attribute_Code]
				,[Course_Attribute_Desc] =	ca.[Course_Attribute_Desc]
				,[College_Code] = 
						CASE WHEN ca.[Course_Attribute_Code] LIKE @EL_Attribute
							THEN SUBSTRING([Course_Attribute_Code],2,2)
							ELSE '#NA'
						END
				,[Experiential_Learning_Code] = 
						CASE WHEN ca.[Course_Attribute_Code] LIKE @EL_Attribute + 'C'
							THEN 'Creative'
							WHEN ca.[Course_Attribute_Code] LIKE @EL_Attribute + 'G'
								OR ca.[Course_Attribute_Code] LIKE @FS_Attribute
								OR ca.[Course_Attribute_Desc] LIKE @SA_Attribute
							THEN 'Global'
							WHEN ca.[Course_Attribute_Code] LIKE @EL_Attribute + 'I'
							THEN 'Internship'
							WHEN ca.[Course_Attribute_Code] LIKE @EL_Attribute + 'L'
							THEN 'Leadership'
							WHEN ca.[Course_Attribute_Code] LIKE @EL_Attribute + 'R'
								OR ca.[Course_Number] LIKE '%R'
							THEN 'Research'
							WHEN ca.[Course_Attribute_Code] LIKE @EL_Attribute + 'S'
								OR ca.[Course_ID] LIKE '%S'
							THEN 'Service Learning'
							ELSE '#NA'
						END
				,[Course_Type] = 'Course'
				,[Field_Study_or_Study_Abroad] = 
						CASE WHEN ca.[Course_Attribute_Desc] LIKE @SA_Attribute
							THEN 'Study Abroad'
							WHEN ca.[Course_Attribute_Code] LIKE @FS_Attribute
							THEN 'Field Study'
							ELSE '#NA'
						END

			FROM [Banner_Student_ODS].[sds].[COURSE_ATTRIBUTE] AS ca

			INNER JOIN [Banner_Student_ODS].[sds].[COURSE_SECTION_DETAIL] AS csd
			ON (ca.[CRN] = csd.[CRN]
				AND ca.[Term_Code] = csd.[Term_Code]
				)

			INNER JOIN (SELECT DISTINCT 
								[Calendar_Yr]
								,[Academic_Year_Code]
								,[Term_Code]
								,[Term_Desc]
					FROM [Common].[dbo].[Date])	AS cd
			ON ca.[Term_Code] = cd.[Term_Code] 

	/*
	The CASE statement below: the query would take an input for the parameter @Requested_Term_Code upon request to alter the results.
	if there is no proper input, then the case statement in this where clause just takes the year from today and determines the Term_Code from the [Common].[dbo].[Date] table
	*/			
			WHERE (
				ca.[Course_Attribute_Code] LIKE @EL_Attribute
				OR ca.[Course_Attribute_Code] LIKE @FS_Attribute
				OR ca.[Course_Attribute_Desc] LIKE @SA_Attribute
				)
				AND (
				csd.[Status_Code] = 'A'
				AND csd.[Enrollment] > 0
				AND ca.[Term_Code] >= @Current_Term_Code
				)
	) AS el_inner

	LEFT JOIN (
				SELECT DISTINCT 
						[College_Code]
						,[College_Desc]
				FROM [Banner_Student_ODS].[ref].[ODS_STVCOLL]
				) AS col
	ON el_inner.[College_Code] = col.[College_Code]

	GROUP BY [Term_Code], [Term_Desc], [Course_ID], el_inner.[College_Code], [College_Desc], [Course_Title_Short], [Course_Type], [Experiential_Learning_Code], [Field_Study_or_Study_Abroad]	
