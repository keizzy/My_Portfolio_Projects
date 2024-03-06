----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------DATA CLEANING(CHECKING DATA)-------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT * 
FROM PortfolioProject..NashvilleHousing

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------FORMATTING DATE TO STANDARD-----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE Nashvillehousing
ADD Sale_date Date
----------
UPDATE NashvilleHousing
SET sale_date = CONVERT(Date, SaleDate)

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------POPULATING PROPERTY ADDRESS WHERE THERE IS NULL---------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
  ON a.ParcelID = b.ParcelID
  AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL
---------
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
  ON a.ParcelID = b.ParcelID
  AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------BREAKING OUT PROPERTY ADDRESS INTO INDIVIDUAL COLUMNS(ADRESS, CITY, STATE)-------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE NashvilleHousing
ADD PropertyAddressNew Nvarchar(255)
------------
UPDATE NashvilleHousing
SET PropertyAddressNew =  SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)
-------------
ALTER TABLE NashvilleHousing
ADD PropertyAddressNewCity Nvarchar(255)
------------
UPDATE NashvilleHousing
SET PropertyAddressNewCity =  SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------BREAKING OUT OWNER ADDRESS INTO INDIVIDUAL COLUMNS(ADRESS, CITY, STATE)----------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 

ALTER TABLE NashvilleHousing
ADD OwnerAddressNew Nvarchar(255)

UPDATE NashvilleHousing
SET OwnerAddressNew =  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
-------------
ALTER TABLE NashvilleHousing
ADD OwnerAddressNewCity Nvarchar(255)

UPDATE NashvilleHousing
SET OwnerAddressNewCity =  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
-------------
ALTER TABLE NashvilleHousing
ADD OwnerAddressNewState Nvarchar(255)

UPDATE NashvilleHousing
SET OwnerAddressNewState =  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------CHANGING Y AND N TO YES AND NO IN "SOLD AS VACANT" FIELD---------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 

UPDATE NashvilleHousing
SET SoldAsVacant = 
  CASE
	WHEN soldAsVacant = 'Y' THEN 'Yes'
	WHEN soldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
  END

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------REMOVING DUPLICATES--------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 

WITH RowNumCTE AS 
(
SELECT *,
  ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, SalePrice, Saledate, LegalReference ORDER BY UniqueID) Row_Num
FROM NashvilleHousing
)
DELETE 
FROM RowNumCTE
WHERE Row_Num > 1

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------REMOVING UNUSED COLUMNS----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 

ALTER TABLE NashvilleHousing
DROP COLUMN  saledate, OwnerAddress, TaxDistrict, PropertyAddress
