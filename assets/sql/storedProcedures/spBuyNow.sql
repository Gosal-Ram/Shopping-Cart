DELIMITER //

CREATE PROCEDURE IF NOT EXISTS spOrderBuyNow(
	IN orderId VARCHAR(64),
    IN userId INT,
    IN addressId INT,
    IN totalPrice  DECIMAL(10,2),
    IN totalTax  DECIMAL(10,2),
    IN productId INT 
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
        c.fldQuantity,
        p.fldPrice,
        p.fldTax
        
    FROM 
		tblCart c
		INNER JOIN tblProduct p ON c.fldProductId = p.fldProduct_Id
    WHERE 
        c.fldProductId = productId
        AND c.fldUserId = userId;
        
	-- Delete cartitems from tbl cart 
	DELETE FROM
		tblCart
	WHERE
        fldProductId = productId
		AND fldUserId = userId;

END //

DELIMITER ;
