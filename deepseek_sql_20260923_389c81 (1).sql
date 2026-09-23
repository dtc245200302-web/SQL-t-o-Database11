-- =============================================
-- Tạo Database QuanLyBanHang
-- =============================================
CREATE DATABASE QuanLyBanHang;
GO

USE QuanLyBanHang;
GO

-- =============================================
-- Bảng Customer: Danh sách khách hàng
-- =============================================
CREATE TABLE Customer (
    cID     INT             IDENTITY(1,1) PRIMARY KEY,   -- Mã khách hàng (PK, tự tăng)
    cName   NVARCHAR(100)   NOT NULL,                    -- Tên khách hàng
    cAddress NVARCHAR(200),                              -- Địa chỉ
    cPhone  VARCHAR(15)     UNIQUE                       -- Số điện thoại (duy nhất)
);
GO

-- =============================================
-- Bảng Product: Danh sách sản phẩm
-- =============================================
CREATE TABLE Product (
    pID     INT             IDENTITY(1,1) PRIMARY KEY,   -- Mã sản phẩm (PK, tự tăng)
    pName   NVARCHAR(150)   NOT NULL,                    -- Tên sản phẩm
    pPrice  DECIMAL(18,2)   NOT NULL CHECK (pPrice >= 0),-- Đơn giá (>= 0)
    pQuantity INT           DEFAULT 0 CHECK (pQuantity >= 0) -- Số lượng tồn kho
);
GO

-- =============================================
-- Bảng Order: Hóa đơn mua hàng
-- =============================================
CREATE TABLE [Order] (
    oID     INT             IDENTITY(1,1) PRIMARY KEY,   -- Số hóa đơn (PK, tự tăng)
    cID     INT             NOT NULL,                    -- Mã khách hàng (FK)
    oDate   DATE            NOT NULL DEFAULT GETDATE(),  -- Ngày mua
    oTotal  DECIMAL(18,2)   DEFAULT 0 CHECK (oTotal >= 0),-- Tổng tiền hóa đơn

    CONSTRAINT FK_Order_Customer
        FOREIGN KEY (cID) REFERENCES Customer(cID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
GO

-- =============================================
-- Bảng OrderDetail: Chi tiết hóa đơn
-- =============================================
CREATE TABLE OrderDetail (
    oID     INT             NOT NULL,                    -- Mã hóa đơn (FK)
    pID     INT             NOT NULL,                    -- Mã sản phẩm (FK)
    odQuantity INT          NOT NULL CHECK (odQuantity > 0), -- Số lượng mua (> 0)
    odPrice DECIMAL(18,2)   NOT NULL CHECK (odPrice >= 0),   -- Giá tại thời điểm mua

    -- Khóa chính phức hợp: 1 hóa đơn không trùng 1 sản phẩm
    CONSTRAINT PK_OrderDetail PRIMARY KEY (oID, pID),

    CONSTRAINT FK_OrderDetail_Order
        FOREIGN KEY (oID) REFERENCES [Order](oID)
        ON DELETE CASCADE,

    CONSTRAINT FK_OrderDetail_Product
        FOREIGN KEY (pID) REFERENCES Product(pID)
);
GO