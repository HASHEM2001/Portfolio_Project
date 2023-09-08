/*

Cleaning Data in SQL Queries

*/

select *
from housing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

select SaleDate, CONVERT(date,SaleDate)
from housing

-- chage the data type to date 
ALTER TABLE housing ALTER COLUMN SaleDate date;


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data
select PropertyAddress
from housing
--where PropertyAddress is null


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,  b.PropertyAddress)
from housing a
join housing b
 on a.ParcelID=b.ParcelID
 and a.[UniqueID ]<>b.[UniqueID ]
 where a.PropertyAddress is null 


 update a 
	set PropertyAddress=isnull(a.PropertyAddress,  b.PropertyAddress)
		from housing a
		join housing b
		 on a.ParcelID=b.ParcelID
		 and a.[UniqueID ]<>b.[UniqueID ]
		 where a.PropertyAddress is null 


--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

select SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1)as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress))as city
from housing





ALTER TABLE housing
Add PropertySplitAddress Nvarchar(255);

--Update housing
--SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE housing
Add PropertySplitCity Nvarchar(255);

--Update housing
--SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

--------------------------------------------------------------------------------------------------------------------------

select *
from housing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From housing



ALTER TABLE housing
Add OwnerSplitAddress Nvarchar(255);

--Update housing
--SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE housing
Add OwnerSplitCity Nvarchar(255);

--Update housing
--SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE housing
Add OwnerSplitState Nvarchar(255);

--Update housing
--SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


select count(SoldAsVacant),SoldAsVacant--,ParcelID,
from housing
group by SoldAsVacant
order by 1



Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From housing


update housing 
	set SoldAsVacant= CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END



-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From housing
--order by ParcelID
)

select *
from RowNumCTE
where row_num>1



---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns





ALTER TABLE housing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate




select *
from housing









--################################################################################################################## FINISH


