DELIMITER //

CREATE PROCEDURE IF NOT EXISTS spOrderCartCheckout(
    IN orderId VARCHAR(64),
    IN userId INT,
    IN addressId INT,
    IN totalPrice  DECIMAL(10,2),
    IN totalTax  DECIMAL(10,2)
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
        c.fldProductId,
        c.fldQuantity,
        p.fldPrice,
        p.fldTax
    FROM 
        tblCart c
        INNER JOIN
            tblProduct p ON c.fldProductId = p.fldProduct_Id
    WHERE 
        c.fldUserId = userId;
        
    -- Delete cartitems from tbl cart 
    DELETE FROM
        tblCart
    WHERE
        fldUserId = userId;

END //

DELIMITER ;
