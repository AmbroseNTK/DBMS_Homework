
CREATE OR ALTER PROC pro_01
AS
BEGIN
	DECLARE listPhong CURSOR FOR SELECT PHONGBAN.MaPhong FROM PHONGBAN
	OPEN listPhong
	DECLARE @maPhong nchar(10)
	FETCH NEXT FROM listPhong INTO @maPhong
	WHILE @@FETCH_STATUS =0
	BEGIN
		
		DECLARE @tenPhong nvarchar(50), @maTruongPhong nchar(10), @tenTruongPhong nvarchar(50)
		SELECT @tenPhong=PHONGBAN.TenPhong, @maTruongPhong = PHONGBAN.TruongPhong FROM PHONGBAN
			WHERE PHONGBAN.MaPhong = @maPhong

		PRINT N'Phòng: '+@tenPhong
		SELECT @tenTruongPhong = NHANVIEN.HoNV +' '+NHANVIEN.TenNV FROM NHANVIEN WHERE NHANVIEN.MaNV = @maTruongPhong
		PRINT N'Tên trưởng phòng: '+@tenTruongPhong
		PRINT N'Danh sách nhân viên:'
		DECLARE listNhanVien CURSOR FOR SELECT NHANVIEN.HoNV+' '+NHANVIEN.TenNV AS HoTenNV FROM NHANVIEN WHERE NHANVIEN.Phong = @maPhong
		OPEN listNhanVien
		DECLARE @tenNhanVien nvarchar(50), @nhanVienCount int
		SET @nhanVienCount = 1
		FETCH NEXT FROM listNhanVien INTO @tenNhanVien
		WHILE @@FETCH_STATUS = 0
		BEGIN
			PRINT '    '+STR(@nhanVienCount)+': '+@tenNhanVien
			SET  @nhanVienCount +=1
			FETCH NEXT FROM listNhanVien INTO @tenNhanVien
		END
		CLOSE listNhanVien
		DEALLOCATE listNhanVien
		FETCH NEXT FROM listPhong INTO @maPhong
		PRINT '-------------------------------------'
	END
	CLOSE listPhong
	DEALLOCATE listPhong
END
GO

EXEC pro_01
/*
Kết quả pro_01
Phòng: Ban dieu hanh
Tên trưởng phòng: Vuong Quyen
Danh sách nhân viên:
             1: Tran Quang
-------------------------------------
Phòng: Mang truyen thong
Tên trưởng phòng: Vuong Quyen
Danh sách nhân viên:
-------------------------------------
Phòng: Thiet ke - Dao tao
Tên trưởng phòng: Tran Quang
Danh sách nhân viên:
             1: Tong Tran
             2: Vuong Quyen
             3: Le Nhan
             4: Bui Vu
-------------------------------------
Phòng: Phan mem
Tên trưởng phòng: Nguyen Tung
Danh sách nhân viên:
             1: Dinh Tien
             2: Nguyen Tung
             3: Tran Tam
             4: Nguyen Hung
-------------------------------------
*/

CREATE OR ALTER PROC pro_02(@maNV nchar(10))
AS
BEGIN
	IF @maNV =''
	BEGIN
		PRINT N'Thiếu mã nhân viên'
		RETURN
	END
	ELSE
	BEGIN
		SELECT * FROM NHANVIEN WHERE NHANVIEN.MaNV = @maNV
		IF @@ROWCOUNT =0
			PRINT N'Không tìm thấy nhân viên có mã '+@maNV
	END
END
GO

EXEC pro_02 ''
/*
EXEC pro_02 '123'
MaNV       HoNV                 TenLot               TenNV                NS         DC                                                                     PHAI Luong       NQL        Phong      NgayVL
---------- -------------------- -------------------- -------------------- ---------- ---------------------------------------------------------------------- ---- ----------- ---------- ---------- ----------
123        Dinh                 Ba                   Tien                 1975-01-09 731 Tran Hung Dao, Q.1 TPHCM                                           Nam  30000       333        5          1975-06-01

EXEC pro_02 '1234'
Không tìm thấy nhân viên có mã 1230      
MaNV       HoNV                 TenLot               TenNV                NS         DC                                                                     PHAI Luong       NQL        Phong      NgayVL
---------- -------------------- -------------------- -------------------- ---------- ---------------------------------------------------------------------- ---- ----------- ---------- ---------- ----------

EXEC pro_02 ''
Thiếu mã nhân viên
*/

CREATE OR ALTER PROC pro_03
AS
BEGIN
	DECLARE listPhong CURSOR FOR SELECT PHONGBAN.MaPhong FROM PHONGBAN
	OPEN listPhong
	DECLARE @maPhong nchar(10)
	FETCH NEXT FROM listPhong INTO @maPhong
	WHILE @@FETCH_STATUS =0
	BEGIN
		
		DECLARE @tenPhong nvarchar(50), @maTruongPhong nchar(10), @tenTruongPhong nvarchar(50), @soLuongNV int
		SELECT @tenPhong=PHONGBAN.TenPhong, @maTruongPhong = PHONGBAN.TruongPhong FROM PHONGBAN
			WHERE PHONGBAN.MaPhong = @maPhong

		PRINT N'Phòng: '+@tenPhong
		SELECT @tenTruongPhong = NHANVIEN.HoNV +' '+NHANVIEN.TenNV FROM NHANVIEN WHERE NHANVIEN.MaNV = @maTruongPhong
		PRINT N'Tên trưởng phòng: '+@tenTruongPhong

		
		SET @soLuongNV =0
		SELECT @soLuongNV =COUNT(NHANVIEN.MaNV) FROM NHANVIEN WHERE NHANVIEN.Phong = @maPhong

		PRINT N'Số lượng nhân viên: '+STR(@soLuongNV)
		
		FETCH NEXT FROM listPhong INTO @maPhong
		PRINT '-------------------------------------'
	END
	CLOSE listPhong
	DEALLOCATE listPhong
END
GO

EXEC pro_03

/*
Kết quả pro_03
Phòng: Ban dieu hanh
Tên trưởng phòng: Vuong Quyen
Số lượng nhân viên:          1
-------------------------------------
Phòng: Mang truyen thong
Tên trưởng phòng: Vuong Quyen
Số lượng nhân viên:          0
-------------------------------------
Phòng: Thiet ke - Dao tao
Tên trưởng phòng: Tran Quang
Số lượng nhân viên:          4
-------------------------------------
Phòng: Phan mem
Tên trưởng phòng: Nguyen Tung
Số lượng nhân viên:          4
-------------------------------------
*/

ALTER TABLE PHONGBAN
ADD SLNV int
GO

DECLARE listPhong CURSOR FOR SELECT PHONGBAN.MaPhong FROM PHONGBAN
OPEN listPhong
DECLARE @maPhong nchar(10)
FETCH NEXT FROM listPhong INTO @maPhong
WHILE @@FETCH_STATUS =0
BEGIN
	DECLARE @soLuongNV int
	SET @soLuongNV = 0
	SELECT @soLuongNV = COUNT(NHANVIEN.MaNV) FROM NHANVIEN WHERE NHANVIEN.Phong = @maPhong
	UPDATE PHONGBAN SET SLNV = @soLuongNV WHERE PHONGBAN.MaPhong = @maPhong 
		
	FETCH NEXT FROM listPhong INTO @maPhong
END
CLOSE listPhong
DEALLOCATE listPhong
GO

SELECT * FROM PHONGBAN

/*
Kết  quả

MaPhong    TenPhong                                           TruongPhong NgayNhanChuc SLNV
---------- -------------------------------------------------- ----------- ------------ -----------
1          Ban dieu hanh                                      888         1971-06-19   1
3          Mang truyen thong                                  888         1971-06-19   0
4          Thiet ke - Dao tao                                 777         2005-02-01   4
5          Phan mem                                           333         1995-05-22   4

*/

CREATE OR ALTER PROC pro_04
AS
BEGIN
	DECLARE @maPhong nchar(10);
	DECLARE listPhong CURSOR FOR SELECT PHONGBAN.MaPhong FROM PHONGBAN
	OPEN listPhong
	FETCH NEXT FROM listPhong INTO @maPhong
	DECLARE @soLuongNV int;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @soLuongNV = 0;
		SELECT @soLuongNV = COUNT(NHANVIEN.MaNV) FROM NHANVIEN WHERE NHANVIEN.Phong = @maPhong
		UPDATE PHONGBAN SET SLNV = @soLuongNV WHERE PHONGBAN.MaPhong = @maPhong
		FETCH NEXT FROM listPhong INTO @maPhong
	END
	CLOSE listPhong
	DEALLOCATE listPhong
	SELECT * FROM PHONGBAN
END

EXEC pro_04

/*
Ket qua
MaPhong    TenPhong                                           TruongPhong NgayNhanChuc SLNV
---------- -------------------------------------------------- ----------- ------------ -----------
1          Ban dieu hanh                                      888         1971-06-19   1
3          Mang truyen thong                                  888         1971-06-19   0
4          Thiet ke - Dao tao                                 777         2005-02-01   4
5          Phan mem                                           333         1995-05-22   4

*/

CREATE OR ALTER PROC pro_05
AS
BEGIN
	PRINT N'Danh sách nhân viên có số giờ làm > 40h một tuần'
	DECLARE listNhanVien CURSOR FOR SELECT NHANVIEN.MaNV, NHANVIEN.HoNV +' '+NHANVIEN.TenLot+' '+NHANVIEN.TenNV FROM NHANVIEN
	DECLARE @maNV nchar(10), @thoiGian float, @thuTu int, @hoTenNV nvarchar(50)
	SET @thuTu = 1
	OPEN listNhanVien
	FETCH NEXT FROM listNhanVien INTO @maNV, @hoTenNV
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @thoiGian = 0;
		SELECT @thoiGian = SUM(PHANCONG.ThoiGian) FROM PHANCONG WHERE PHANCONG.MaNV = @maNV GROUP BY PHANCONG.MaNV
		IF @thoiGian > 40
		BEGIN
			PRINT STR(@thuTu)+'. ID: '+@maNV+'- Name: '+@hoTenNV+': '+STR(@thoiGian)
			SET @thuTu +=1;
		END
		FETCH NEXT FROM listNhanVien INTO @maNV, @hoTenNV
	END
	CLOSE listNhanVien
	DEALLOCATE listNhanVien
END

EXEC pro_05

/*
Kết quả
Danh sách nhân viên có số giờ làm > 40h một tuần
         1. ID: 123       - Name: Dinh Ba Tien:         60
*/

ALTER TABLE NHANVIEN
ALTER COLUMN pass nvarchar(10)

CREATE OR ALTER TRIGGER trg_NVMK ON NHANVIEN
FOR UPDATE
AS
BEGIN
	DECLARE @passLength int
	SET @passLength = 0 
	DECLARE listPassLength  CURSOR FOR SELECT LEN(INSERTED.pass) FROM INSERTED
	OPEN listPassLength
	FETCH NEXT FROM listPassLength INTO @passLength
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @passLength = 0 OR @passLength >8
		BEGIN
			RAISERROR(N'Độ dài mật khẩu không cho phép.',11,1);
		END
		FETCH NEXT FROM listPassLength INTO @passLength
	END
	CLOSE listPassLength
	DEALLOCATE listPassLength
END


CREATE OR ALTER TRIGGER trg_PC ON PHANCONG
FOR INSERT
AS
BEGIN
	DECLARE @maNV nchar(10), @thoiGian float
	DECLARE listNV CURSOR FOR SELECT inserted.MaNV FROM inserted
	OPEN listNV
	FETCH NEXT FROM listNV INTO @maNV
	WHILE @@FETCH_STATUS =0
	BEGIN
		SELECT @thoiGian = SUM(PHANCONG.ThoiGian) FROM PHANCONG WHERE PHANCONG.MaNV = @maNV
		IF @thoiGian >40
		BEGIN
			RAISERROR(N'Nhân viên %s đã làm việc quá 40h',11,1,@maNV)
		END
	END
	CLOSE listNV
	DEALLOCATE listNV
END

CREATE OR ALTER TRIGGER trg_NVPB1 ON NHANVIEN
FOR INSERT
AS
BEGIN
	DECLARE @maPhong nchar(10)
	DECLARE listNV CURSOR FOR SELECT inserted.Phong FROM inserted
	OPEN listNV
	FETCH NEXT FROM listNV INTO @maPhong
	WHILE @@FETCH_STATUS =0
	BEGIN
		UPDATE PHONGBAN SET SLNV +=1 WHERE PHONGBAN.MaPhong = @maPhong
	END
	CLOSE listNV
	DEALLOCATE listNV
	
END

/*
Trước khi thêm nhân viên mới
MaPhong    TenPhong                                           TruongPhong NgayNhanChuc SLNV
---------- -------------------------------------------------- ----------- ------------ -----------
1          Ban dieu hanh                                      888         1971-06-19   1
3          Mang truyen thong                                  888         1971-06-19   0
4          Thiet ke - Dao tao                                 777         2005-02-01   4
5          Phan mem                                           333         1995-05-22   4

Sau khi thêm một nhân viên vào phòng Mạng truyền thông
MaPhong    TenPhong                                           TruongPhong NgayNhanChuc SLNV
---------- -------------------------------------------------- ----------- ------------ -----------
1          Ban dieu hanh                                      888         1971-06-19   1
3          Mang truyen thong                                  888         1971-06-19   1
4          Thiet ke - Dao tao                                 777         2005-02-01   4
5          Phan mem                                           333         1995-05-22   4
*/

CREATE OR ALTER TRIGGER trg_NVPB2 ON NHANVIEN
FOR DELETE
AS
BEGIN
	DECLARE @maPhong nchar(10)
	DECLARE listNV CURSOR FOR SELECT deleted.Phong FROM deleted
	OPEN listNV
	FETCH NEXT FROM listNV INTO @maPhong
	WHILE @@FETCH_STATUS =0
	BEGIN
		UPDATE PHONGBAN SET SLNV -=1 WHERE PHONGBAN.MaPhong = @maPhong
	END
	CLOSE listNV
	DEALLOCATE listNV
	
END
/*
Trước khi xóa nhân viên mới
MaPhong    TenPhong                                           TruongPhong NgayNhanChuc SLNV
---------- -------------------------------------------------- ----------- ------------ -----------
1          Ban dieu hanh                                      888         1971-06-19   1
3          Mang truyen thong                                  888         1971-06-19   1
4          Thiet ke - Dao tao                                 777         2005-02-01   4
5          Phan mem                                           333         1995-05-22   4

Sau khi xóa một nhân viên vào phòng Mạng truyền thông
MaPhong    TenPhong                                           TruongPhong NgayNhanChuc SLNV
---------- -------------------------------------------------- ----------- ------------ -----------
1          Ban dieu hanh                                      888         1971-06-19   1
3          Mang truyen thong                                  888         1971-06-19   0
4          Thiet ke - Dao tao                                 777         2005-02-01   4
5          Phan mem                                           333         1995-05-22   4
*/

CREATE OR ALTER TRIGGER trg_NVPB3 ON NHANVIEN
FOR UPDATE
AS
BEGIN
	DECLARE @maPhong nchar(10)
	DECLARE listNV CURSOR FOR SELECT inserted.Phong FROM inserted
	OPEN listNV
	FETCH NEXT FROM listNV INTO @maPhong
	WHILE @@FETCH_STATUS =0
	BEGIN
		UPDATE PHONGBAN SET SLNV +=1 WHERE PHONGBAN.MaPhong = @maPhong
	END
	CLOSE listNV
	DEALLOCATE listNV

	DECLARE listNV CURSOR FOR SELECT deleted.Phong FROM deleted
	OPEN listNV
	FETCH NEXT FROM listNV INTO @maPhong
	WHILE @@FETCH_STATUS =0
	BEGIN
		UPDATE PHONGBAN SET SLNV -=1 WHERE PHONGBAN.MaPhong = @maPhong
	END
	CLOSE listNV
	DEALLOCATE listNV
	
END
/*
Trước khi chuyển
MaPhong    TenPhong                                           TruongPhong NgayNhanChuc SLNV
---------- -------------------------------------------------- ----------- ------------ -----------
1          Ban dieu hanh                                      888         1971-06-19   1
3          Mang truyen thong                                  888         1971-06-19   0
4          Thiet ke - Dao tao                                 777         2005-02-01   4
5          Phan mem                                           333         1995-05-22   4

Sau khi chuyển một nhân viên ở phòng Thiết kế qua phòng Phần Mềm
MaPhong    TenPhong                                           TruongPhong NgayNhanChuc SLNV
---------- -------------------------------------------------- ----------- ------------ -----------
1          Ban dieu hanh                                      888         1971-06-19   1
3          Mang truyen thong                                  888         1971-06-19   1
4          Thiet ke - Dao tao                                 777         2005-02-01   3
5          Phan mem                                           333         1995-05-22   5
*/