select *
From PortfolioProject.dbo.NashvilleHousing

-- Standardize Date format

--select SaleDate
--, CONVERT (Date, SaleDate)
--From PortfolioProject.dbo.NashvilleHousing

--Update NashvilleHousing
--Set Saledate = CONVERT (Date, SaleDate)

select SaleDateConverted, CONVERT (Date, SaleDate)
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted = CONVERT (Date, SaleDate)

-- Populate Property Address

select *
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is NULL
Order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL (a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
Where a.PropertyAddress is null

-- Below replaces null vales from a.PropertyAddress with corresponding values from b.PropertyAddress matching them using parcelID
UPDATE a
SET PropertyAddress = ISNULL (a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
Where a.PropertyAddress is null

-- Break address out into individual columns

select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is NULL
Order by ParcelID


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))  as City

From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity nvarchar(255);

Update NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))


-- Seperating Owner Address (Address, City, State)

Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress,',', '.') ,3)
,PARSENAME(REPLACE(OwnerAddress,',', '.') ,2)
,PARSENAME(REPLACE(OwnerAddress,',', '.') ,1)
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',', '.') ,3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',', '.') ,2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',', '.') ,1)

Select *
From PortfolioProject.dbo.NashvilleHousing

-- Change Y and N in "Sold as Vacant" Field

SELECT DISTINCT (SoldAsVacant), COUNT(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER by 2

Select SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject.dbo.NashvilleHousing

UPDATE NashvilleHousing
	Set SoldAsVacant = 
	   CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

SELECT * 
From PortfolioProject.dbo.NashvilleHousing

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

From PortfolioProject.dbo.NashvilleHousing
)

DELETE
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress

Select *  -- Use this to check if it works. 
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress

-- Delete Unused Columns

Select *
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN PropertyAddress, OwnerAddress, TaxDistrict, SaleDate

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate

