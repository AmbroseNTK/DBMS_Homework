DECLARE cur_nv CURSOR FOR
SELECT NHANVIEN.TenNV FROM NHANVIEN WHERE NHANVIEN.Phong = '4'

OPEN cur_nv;

DECLARE @tenNV NVARCHAR(50), @stt int;
SET @stt = 1;

FETCH NEXT FROM cur_nv INTO @tenNV

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT('Nhan vien thu '+str(@stt)+': '+@tenNV);
    SET @stt = @stt+1;

    FETCH NEXT FROM cur_nv INTO @tenNV;
END

CLOSE cur_nv;

