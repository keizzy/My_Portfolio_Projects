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

UPDATE NashvilleHousing
SET sale_date = CONVERT(Date, SaleDate)

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------POPULATING PROPERTY ADDRESS FOR NULL-------------------------------------------------------------------------------------- 
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT * 
FROM PortfolioProject..NashvilleHousing
WHERE PropertyAddress IS NULL

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
  ON a.ParcelID = b.ParcelID
  AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
  ON a.ParcelID = b.ParcelID
  AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL