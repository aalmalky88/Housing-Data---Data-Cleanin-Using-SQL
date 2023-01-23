Select * 
From dbo.NH




-- Standardize Date Format


--Convert
Select SaleDate, CONVERT(Date,SaleDate)
From dbo.NH

--Update
Update NH
SET SaleDate = CONVERT(Date,SaleDate)
--Didnt work , other way 


ALTER TABLE NH
Add SaleDateUp Date;

Update NH
SET SaleDateUp = CONVERT(Date,SaleDate)


Select SaleDateUp, CONVERT(Date,SaleDate)
From dbo.NH







-- Populate Property Address data

Select *
From dbo.NH
--Where PropertyAddress is null
order by ParcelID





--Join itself 
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From .dbo.NH a
JOIN .dbo.NH b
	on a.ParcelID = b.ParcelID 
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

--Update to make changes in the data 
Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From .dbo.NH a
JOIN .dbo.NH b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null







-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From dbo.NH
--Where PropertyAddress is null
--order by ParcelID



--Change the delimeter to comma fro spltting the addreas to property and city
SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
From .dbo.NH


ALTER TABLE NH
Add PropertySplitAddress Nvarchar(255);

Update NH
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE NH
Add PropertySplitCity Nvarchar(255);

Update NH
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

Select *
From dbo.NH







Select OwnerAddress
From dbo.NH


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From dbo.NH



ALTER TABLE dbo.NH
Add OwnerSplitAddress Nvarchar(255);

Update dbo.NH
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE dbo.NH
Add OwnerSplitCity Nvarchar(255);

Update dbo.NH
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE dbo.NH
Add OwnerSplitState Nvarchar(255);

Update dbo.NH
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From dbo.NH




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From dbo.NH
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From dbo.NH



Update NH
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

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

From dbo.NH
--order by ParcelID
)
--DELETE 
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From dbo.NH




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns "Just Practicing :)"



Select *
From dbo.NH


--ALTER TABLE PortfolioProject.dbo.NashvilleHousing
--DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
