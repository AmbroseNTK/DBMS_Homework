CREATE OR ALTER TRIGGER trg_password ON NHANVIEN
FOR INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @pass NVARCHAR(8);
    SET @pass = (SELECT inserted.pass FROM inserted);
    IF (LEN(@pass)<0 AND LEN(@pass)>8)
        RAISERROR('Invailid password',16,1);
END;

UPDATE NHANVIEN SET pass = '' WHERE MaNV='123'

DROP TRIGGER trg_NVMK