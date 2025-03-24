DELIMITER //

CREATE PROCEDURE IF NOT EXISTS spPlaceOrder(
    IN orderId VARCHAR(64),
    IN userId INT,
    IN addressId INT,
    IN productId INT 
)
BEGIN
	DECLARE totalPrice DECIMAL(10,2) DEFAULT 0.00;
    DECLARE totalTax DECIMAL(10,2) DEFAULT 0.00;
	SELECT 
        --totalPrice = total actual price + total tax
        SUM(p.fldPrice * c.fldQuantity) + SUM(p.fldPrice *p.fldTax /100 * c.fldQuantity),
        SUM(p.fldPrice *p.fldTax /100 * c.fldQuantity)
    INTO 
        totalPrice, totalTax
    FROM 
        tblCart c
    INNER JOIN 
        tblProduct p ON c.fldProductId = p.fldProduct_Id
    WHERE 
        c.fldUserId = userId
        AND (productId IS NULL OR c.fldProductId = productId)
    GROUP BY 
        c.fldUserId;
        
    -- Order Table insertion
    INSERT INTO 
        tblOrder (
            fldOrder_Id,
            fldUserId,
            fldAddressId,
            fldTotalPrice,
            fldTotalTax
        ) 
    VALUES (
        orderId,
        userId,
        addressId,
        totalPrice,
        totalTax
    );

    -- Insertion of order items from cart
    INSERT INTO 
        tblorderitems (
            fldOrderId,
            fldProductId,
            fldQuantity,
            fldUnitPrice,
            fldUnitTax
        )
    SELECT 
        orderId,
        c.fldProductId,
        c.fldQuantity,
        p.fldPrice,
        p.fldTax
    FROM 
        tblCart c
    INNER JOIN 
        tblProduct p ON c.fldProductId = p.fldProduct_Id
    WHERE 
        c.fldUserId = userId
        AND (productId IS NULL OR c.fldProductId = productId);

    -- Delete processed cart items
    DELETE FROM 
        tblCart
    WHERE 
        fldUserId = userId
        AND (productId IS NULL OR fldProductId = productId);
END //

DELIMITER ;