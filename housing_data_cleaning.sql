-- Standardizing date format, defaults to YYYY-MM-DD as usual ----------------------------------------------------------------------------------------------------------------
Select SaleDate, str_to_date(SaleDate, '%m/%d/%Y')
FROM housing_data;

UPDATE housing_data
SET SaleDate = str_to_date(SaleDate, '%m/%d/%Y');

-- Populating the missing addresses, the explanation is a mouthful, so please the check the readme -------------------------------------------------------------------------
SELECT t1.ParcelID, t1.PropertyAddress, t2.ParcelID, t2.PropertyAddress, IFNULL(t1.PropertyAddress, t2.PropertyAddress)
FROM housing_data t1
JOIN housing_data t2
ON t1.ParcelID = t2.ParcelID AND t1.UniqueID <> t2.UniqueID
WHERE t1.PropertyAddress IS NULL;

UPDATE housing_data t1
JOIN housing_data t2
ON t1.ParcelID = t2.ParcelID AND t1.UniqueID <> t2.UniqueID
SET t1.PropertyAddress = IFNULL(t1.PropertyAddress, t2.PropertyAddress)
WHERE t1.PropertyAddress IS NULL;


-- Breaking the address into 3 columns: Address, City, State-------------------------------------------------------------------------------------------------------------------------
-- Extracting the property address
SELECT substring_index(PropertyAddress, ",", 1)
FROM housing_data;

-- Adding the new property address column
ALTER TABLE housing_data
ADD SplitPropertyAddressA VARCHAR(255);

-- Populating the new property address column
UPDATE housing_data
SET SplitPropertyAddressA = substring_index(PropertyAddress, ",", 1);

-- Extracting the property city
-- We used the previous function, modify it to include the city, then extract it from the string
SELECT substring_index(substring_index(PropertyAddress, ",", 2), ",", -1)
FROM housing_data;

-- Adding the new property city column
ALTER TABLE housing_data
ADD SplitPropertyAddressCity VARCHAR(255);

-- Populating the new property city column
UPDATE housing_data
SET SplitPropertyAddressCity = substring_index(substring_index(PropertyAddress, ",", 2), ",", -1);

-- Splitting the Owner Address ----------------------------------------------
-- Extracting the Owner address
SELECT substring_index(OwnerAddress, ",", 1)
FROM housing_data;

-- Adding the new Owner address column
ALTER TABLE housing_data
ADD SplitOwnerAddressA VARCHAR(255);

-- Populating the new Owner address column
UPDATE housing_data
SET SplitOwnerAddressA = substring_index(OwnerAddress, ",", 1);

-- Extracting the Owner city
-- We used the previous function, modify it to include the city, then extract it from the string
SELECT substring_index(substring_index(OwnerAddress, ",", 2), ",", -1)
FROM housing_data;

-- Adding the new Owner city column
ALTER TABLE housing_data
ADD SplitOwnerAddressCity VARCHAR(255);

-- Populating the new Owner city column
UPDATE housing_data
SET SplitOwnerAddressCity = substring_index(substring_index(OwnerAddress, ",", 2), ",", -1);

-- Extracting the Owner state
SELECT substring_index(OwnerAddress, ",", -1)
FROM housing_data;

-- Adding the new Owner state column
ALTER TABLE housing_data
ADD SplitOwnerAddressState VARCHAR(255);

-- Populating the new Owner state column
UPDATE housing_data
SET SplitOwnerAddressState = substring_index(OwnerAddress, ",", -1);

-- Standardizing the SoldAsVacant column -----------------------------------------------------------------------------------------------------------------------
SELECT
	CASE 
		WHEN SoldAsVacant = "N" THEN "No"
        WHEN SoldAsVacant = "Y" THEN "Yes"
        ELSE SoldAsVacant
	END
FROM housing_data;

UPDATE housing_data
SET SoldAsVacant = CASE 
		WHEN SoldAsVacant = "N" THEN "No"
        WHEN SoldAsVacant = "Y" THEN "Yes"
        ELSE SoldAsVacant
	END;


-- Deleting duplicate records -------------------------------------------------------------------------------------------------------------------------------------
-- this is a fail, but hey it's a an attempt
WITH row_rankCTE as(
	SELECT rank() OVER(PARTITION BY ParcelID,
					PropertyAddress,
                                	SalePrice,
                                	SaleDate,
                                 	LegalReference
                                 	ORDER BY 
						UniqueID)
					
FROM housing_data)
DELETE
FROM row_rankCTE
WHERE row_rank > 1 ;


-- Deleting unneeded columns --------------------------------------------------------------------------------------------------------------------------------------
-- Simply deleting the address columns that were split and some others that feel useless heh

ALTER TABLE housing_data
DROP COLUMN PropertyAddress;

ALTER TABLE housing_data
DROP COLUMN OwnerAddress;

ALTER TABLE housing_data
DROP COLUMN TaxDistrict;

SELECT *
FROM housing_data;
	
