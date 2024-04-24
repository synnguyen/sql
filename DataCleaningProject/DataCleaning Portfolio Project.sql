/*

Cleaning Data in SQL Queries

*/


Select *
From PorfolioProject.dbo.NashvilleHousing;

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format (change the SaleDate column format)

ALTER TABLE NashvilleHousing --adding SaleDateConverted column to the database
Add SaleDateConverted Date;

Update NashvilleHousing			-- update SaleDateConverted column with value
SET SaleDateConverted = CONVERT(Date,SaleDate);

Select SaleDateConverted, CONVERT(Date,SaleDate)
From PorfolioProject.dbo.NashvilleHousing;


 --------------------------------------------------------------------------------------------------------------------------

 -- Populate Property Address data

 Select *
From PorfolioProject.dbo.NashvilleHousing
-- Where PropertyAddress is null
Order by ParcelID;

-- if the PropertyAddress is null and their ParceID matching with the one with PropertyAddress. By using join table to table itself
-- Then update them.

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PorfolioProject.dbo.NashvilleHousing a
JOIN PorfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null;


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PorfolioProject.dbo.NashvilleHousing a
JOIN PorfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null;
  --------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)
Select PropertyAddress
From PorfolioProject.dbo.NashvilleHousing;

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address --starting from index 1 to index before the coma
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address -- from index of coma to the end
From PorfolioProject.dbo.NashvilleHousing;

ALTER TABLE NashvilleHousing		-- add column PropertySplitAddress to the table
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 );


ALTER TABLE NashvilleHousing		-- -- add column PropertySplitCity to the table
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress));

			--------------------------------------------
Select OwnerAddress
From PorfolioProject.dbo.NashvilleHousing;
-- using PARSENAME useful to objects (such as a table name, column name, or database name,) that have multiple parts separated by a delimiter, such as a period.
-- Syntax: PARSENAME ('object_name' , object_piece ); 
-- The object_piece argument must be an int between 1 and 4. The value specifies which part of the object name is returned.

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PorfolioProject.dbo.NashvilleHousing;

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3);


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2);


ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1);

Select *
From PorfolioProject.dbo.NashvilleHousing;

--------------------------------------------------------------------------------------------------------------------------
-- Change Y and N to Yes and No in "Sold as Vacant" field
Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PorfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2;

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PorfolioProject.dbo.NashvilleHousing;


Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

--------------------------------------------------------------------------------------------------------------------------
-- Remove Duplicates
select *,		-- Using partition by to identify the duplicate on columns ParceID, PropertyAddress, SalePrice, SaleDate, LegalReference.
	Row_NUMBER() OVER (
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
					UniqueID
					) row_num
from PorfolioProject.dbo.NashvilleHousing
order by ParcelID;
		---------------------------------------------------
		-- create CTE table with the information of query above
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PorfolioProject.dbo.NashvilleHousing
)

Select *		-- replace Select with Delete to delete all the duplicate.
From RowNumCTE
Where row_num > 1
Order by PropertyAddress;
--------------------------------------------------------------------------------------------------------------------------
-- Delete Unused Columns

Select *
From PorfolioProject.dbo.NashvilleHousing;

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate;
