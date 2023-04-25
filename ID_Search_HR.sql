/**
DESCRIPTION
Enter a partial name, full name, ID, badge_no, email address, or alternate email address

RETURN
contact info -- office location, phone, email, name

**/
DECLARE @identityLookup VARCHAR(100) = 'START HERE search by name, myid, badge, emails'

SELECT TOP (10)
      [FN_LN] = 
		IIF (
			[Name_Suffix] = '#NA'
			,CONCAT([First_Name], ' ', [Last_Name])
			,CONCAT([First_Name], ' ', [Last_Name], [Name_Suffix])
		)
      ,[Emplid]
      ,[First_Name]
      ,[Last_Name]
      ,[Name_Suffix]
      ,[Badge_No]
      ,[CompanyName_MYID]
      ,[CompanyName_Email]
      ,[Alternate_Email]
      ,[Business_Phone]
      ,[Building_Code]
      ,[Room_No]
  FROM [PS_HCM_ODS].[sds].[PERSON_ATTRIBUTES]

  WHERE [CompanyName_Email] LIKE @identityLookup
		OR [Alternate_Email] LIKE @identityLookup
		OR CONCAT([First_Name],' ',[Last_Name]) LIKE @identityLookup
		OR [First_Name] LIKE @identityLookup
		OR [Last_Name] LIKE @identityLookup
		OR [Badge_No] LIKE @identityLookup
		OR [CompanyName_MYID] LIKE @identityLookup