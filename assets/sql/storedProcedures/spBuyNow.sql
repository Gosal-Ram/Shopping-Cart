DELIMITER //

CREATE PROCEDURE IF NOT EXISTS spOrderBuyNow(
	IN orderId VARCHAR(64),
    IN userId INT,
    IN addressId INT,
    IN totalPrice  DECIMAL(10,2),
    IN totalTax  DECIMAL(10,2),
    IN productId INT ,
    IN productQuantity INT 
)
BEGIN
	-- Order Tbl insertion
    INSERT INTO 
        tblOrder(
            fldOrder_Id,
            fldUserId,
            fldAddressId,
            fldTotalPrice,
            fldTotalTax
        )
    VALUES(
        orderId,
        userId,
        addressId,
        totalPrice,
        totalTax
    );

    -- Insertion of order items from cart
    
    INSERT INTO 
        tblorderitems(
            fldOrderId,
            fldProductId,
            fldQuantity,
            fldUnitPrice,
            fldUnitTax)
    SELECT 
        orderId,
        productId,
        productQuantity,
        fldPrice,
        fldTax
    FROM 
        tblProduct
    WHERE 
        fldProduct_Id = productId;
        
	-- Delete cartitems from tbl cart 
	DELETE FROM
		tblCart
	WHERE
        fldProductId = productId
		AND fldUserId = userId;

END //

DELIMITER ;

