CREATE OR ALTER TRIGGER trg_password ON NHANVIEN
FOR INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @pass NVARCHAR(50);
    SET @pass = (SELECT inserted.pass FROM inserted);
    IF (LEN(@pass)<1 OR LEN(@pass)>8)
        RAISERROR('Invailid password',11,1);
END;

UPDATE NHANVIEN SET pass = '123456789' WHERE MaNV='123'

SELECT * FROM NHANVIEN WHERE NHANVIEN.MaNV = '123'

ALTER TABLE NHANVIEN ALTER COLUMN pass NVARCHAR(50)

DROP TRIGGER trg_password

ALTER TABLE NHANVIEN WITH NOCHECK ADD CONSTRAINT chk_pass CHECK(LEN(NHANVIEN.pass)>0 AND LEN(NHANVIEN.pass)<9)

