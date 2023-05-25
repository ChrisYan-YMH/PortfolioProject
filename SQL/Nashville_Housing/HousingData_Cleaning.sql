-----------------------------------------------------------Exploration------------------------------------------------------------------------------

Select *
From Portfolio_Project..housing_data

--Explore the data
Select *
From Portfolio_Project..housing_data
Order by ParcelID
--where  is null;
--Similar address similar ParcelID and same address same ParcelID






----------------------------------------------------------Cleaning Process----------------------------------------------------------------------------

--Fixing the SaleDate from datetime to date
Alter table Portfolio_Project..housing_data
Alter column SaleDate date
Alter Table Portfolio_Project..housing_data
Alter column UniqueID nvarchar(20)

-----------------------------------------------------------------------------------------------

--Fill in those value in Property Address (it should be same as the one with the same ParcelID)
Select 
	a.UniqueID, a.ParcelID, a.PropertyAddress, b.PropertyAddress
From Portfolio_Project..housing_data a
Inner join Portfolio_Project..housing_data b
	on a.ParcelID = b.ParcelID and a.UniqueID <>b.UniqueID
where a.PropertyAddress is null
--Order by ParcelID

Update a
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
From Portfolio_Project..housing_data a
Inner join Portfolio_Project..housing_data b
	on a.ParcelID = b.ParcelID and a.UniqueID <>b.UniqueID
where a.PropertyAddress is null
--Order by ParcelID

---------------------------------------------------------------------------------------------------------------------

--Break the Property address (address, city, state )
Select 
	PropertyAddress, 
	TRIM(SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)) as Address,
	TRIM(SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1 ,len(PropertyAddress))) as City
From Portfolio_Project..housing_data

--Add new columns into the original table
Alter Table Portfolio_Project..housing_data
Add Property_Splitted_Address nvarchar(255);
Update Portfolio_Project..housing_data
Set Property_Splitted_Address = TRIM(SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1))

Alter Table Portfolio_Project..housing_data
Add Property_Splitted_City nvarchar(255);
Update Portfolio_Project..housing_data
Set Property_Splitted_City = TRIM(SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1 ,len(PropertyAddress)))

---------------------------------------------------------------------------------------------------------------------

--Break the Owner address (address, city, state )
Select 
	OwnerAddress, 
	PARSENAME(REPLACE(OwnerAddress,',','.'),3) as Address,
	PARSENAME(REPLACE(OwnerAddress,',','.'),2) as City,
	PARSENAME(REPLACE(OwnerAddress,',','.'),1) as State
From Portfolio_Project..housing_data

Alter Table Portfolio_Project..housing_data
Add Owner_Splitted_Address nvarchar(255);
Update Portfolio_Project..housing_data
Set Owner_Splitted_Address  = PARSENAME(REPLACE(OwnerAddress,',','.'),3) 
Alter Table Portfolio_Project..housing_data
Add Owner_Splitted_City nvarchar(255);
Update Portfolio_Project..housing_data
Set Owner_Splitted_City  = PARSENAME(REPLACE(OwnerAddress,',','.'),2) 
Alter Table Portfolio_Project..housing_data
Add Owner_Splitted_State nvarchar(255);
Update Portfolio_Project..housing_data
Set Owner_Splitted_State  = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

---------------------------------------------------------------------------------------------------------------------

--Change those Y N into Yes No

Select distinct(SoldAsVacant), count(SoldAsVacant)
From Portfolio_Project..housing_data
Group by SoldAsVacant

Select 
	SoldAsVacant,
Case 
	When TRIM(SoldAsVacant)='N' Then 'No'
	When TRIM(SoldAsVacant)='Y' Then 'Yes'
	Else SoldAsVacant
End As Cleaned_SoldAsVacant
From Portfolio_Project..housing_data

Alter table Portfolio_Project..housing_data
Add Cleaned_SoldAsVacant nvarchar(3)
Update Portfolio_Project..housing_data
set Cleaned_SoldAsVacant= 
Case 
	When TRIM(SoldAsVacant)='N' Then 'No'
	When TRIM(SoldAsVacant)='Y' Then 'Yes'
	Else SoldAsVacant
END


---------------------------------------------------------------------------------------------------------------------

--Remove the duplicate data 

Select 
	ROW_NUMBER() OVER(partition by ParcelID,
									PropertyAddress,
									SaleDate,
									LegalReference,
									OwnerAddress
									order by UniqueID) as row_num, *
From Portfolio_Project..housing_data

With TempCTE as (
Select 
	ROW_NUMBER() OVER(partition by ParcelID,
									PropertyAddress,
									SaleDate,
									LegalReference,
									OwnerAddress
									order by UniqueID) as row_num, *
From Portfolio_Project..housing_data
)
Select *
--Delete 
From TempCTE
where row_num>1


---------------------------------------------------------------------------------------------------------------------

--Delete unuseful attributes 

Alter Table Portfolio_Project..housing_data
Drop Column TaxDistrict, PropertyAddress, OwnerAddress

Select *
From Portfolio_Project..housing_data
--Where Cleaned_SoldAsVacant = 'N' or  Cleaned_SoldAsVacant = 'Y'