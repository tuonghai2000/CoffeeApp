Create database CAFE
GO
Use CAFE
GO
create table taiKhoan
( 
	username varchar(100) Primary key  ,	
    showname nvarchar(100) not null,
	password varchar(100) not null,
	Type INT NOT NULL DEFAULT 0    --1:manager--0 : staff
)

GO
create table loaisanpham(
    	id int identity primary key,
		name nvarchar(100) not null default N'Chưa đặt tên'
)
GO
create table sanpham (
    id int identity primary key,
	name nvarchar(100) not null default N'Chưa đặt tên',
	idloaisanpham int not null,
  	gia Float not null,
	FOREIGN KEY (idloaisanpham) references dbo.loaisanpham(id)
)
create table bill(
	id int identity primary key,
	ngaydat date not null,
	tongtien float not null,
	tennhanvien nvarchar(50)
)

create table thongtinmon(
 	id int identity primary key,
	idbill int not null,
	idsanpham int not null,
	count int not null DEFAULT 0
	FOREIGN key (idbill) references dbo.bill(id),
	FOREIGN key (idsanpham) references dbo.sanpham(id)
)

GO
CREATE TABLE nhanvien(
     id int identity primary key,
	 hoten nvarchar(50),
	 gioitinh nvarchar(10),
	 ngaysinh NVARCHAR(20),
	 sdt NVARCHAR(20)
)

GO
create table billnguyenlieu(
	id int identity primary key,
	tennguyenlieu nvarchar(50),
	soluong int,
	donvi nvarchar(10),
	ngaynhap DATE,
	tongtien float
)

--thêm thức ăn
INSERT dbo.loaisanpham (name) values (N'Drink')
INSERT dbo.loaisanpham (name) values (N'Food')
-- Thêm món
INSERT dbo.sanpham (name,idloaisanpham,gia) values (N'Cà Phê Sữa',1,20000)
INSERT dbo.sanpham (name,idloaisanpham,gia) values (N'Cà Phê Đá',1,18000)
INSERT dbo.sanpham (name,idloaisanpham,gia) values (N'Capuchino',1,30000)
INSERT dbo.sanpham (name,idloaisanpham,gia) values (N'Sinh Tố Dừa',1,25000)
INSERT dbo.sanpham (name,idloaisanpham,gia) values (N'Sinh Tố Dâu',1,25000)
INSERT dbo.sanpham (name,idloaisanpham,gia) values (N'Trà Đào',1,25000)
INSERT dbo.sanpham (name,idloaisanpham,gia) values (N'Bạc Xỉu',1,22000)
INSERT dbo.sanpham (name,idloaisanpham,gia) values (N'Nước Cam',1,20000)


INSERT dbo.sanpham (name,idloaisanpham,gia) values (N'Dĩa trái cây mini',2,20000)
INSERT dbo.sanpham (name,idloaisanpham,gia) values (N'Kem dâu',2,10000)
INSERT dbo.sanpham (name,idloaisanpham,gia) values (N'Kem chuối',2,10000)
INSERT dbo.sanpham (name,idloaisanpham,gia) values (N'Coktail',2,10000)


GO
-- thêm tài khoản
INSERT dbo.taikhoan (username,showname,password,Type) VALUES ('admin01',N'Tường Hải','01',1)


-- thêm nhân viên

--INSERT dbo.nhanvien (hoten ,gioitinh,ngaysinh,sdt ) values( N'Tên Nhân Viên',null,null,null)

GO
CREATE PROC insertbill
@ngaydat date , @tongtien float ,@tennhanvien nvarchar(50)
AS
BEGIN
     INSERT dbo.bill(ngaydat,tongtien,tennhanvien) VALUES(@ngaydat,@tongtien,@tennhanvien)
END
GO
GO
create proc insertthongtinbill
@idmon int, @Count int
as
BEGIN
			DECLARE @max int
			SELECT @max= (SELECT MAX(id) FROM dbo.bill)
          insert dbo.thongtinmon(idbill,idsanpham,count) values (@max,@idmon,@Count)
end

GO
--Hàm thêm sản phẩm
CREATE PROC themsanpham
@name NVARCHAR(50), @idLoaiSanPham INT , @Gia float
as
begin
        INSERT dbo.sanpham(name,idloaisanpham,gia) values (@name,@idLoaiSanPham,@Gia)
end
GO
GO
--Hàm sửa sản phẩm
CREATE PROC suasanpham
@MaSP int,@TenSP NVARCHAR(100) ,@idLoaiSP INT,@Gia float
AS
BEGIN
		UPDATE sanpham SET name =@TenSP WHERE id= @MaSP
		UPDATE sanpham SET idloaisanpham =@idLoaiSP WHERE id= @MaSP
		UPDATE sanpham SET gia =@Gia WHERE id= @MaSP		
end
GO
--Viết hàm lấy thức ăn mã lớn nhấtas
CREATE PROC getfoodwithidmax
AS
BEGIN
		DECLARE @i INT
		SELECT @i = MAX(id) FROM dbo.sanpham
		SELECT * FROM sanpham WHERE id= @i;
END

GO
--Viết hàm thêm nv
CREATE PROC themnv
@tennv NVARCHAR(100), @gioitinh NVARCHAR(20), @ngaysinh NVARCHAR(30),@sdt NVARCHAR(15)
AS
BEGIN
       INSERT dbo.nhanvien (hoten,gioitinh,ngaysinh,sdt) VALUES( @tennv,@gioitinh,@ngaysinh,@sdt)
END
GO
--Viết hàm lấy nv id lớn nhất

CREATE PROC getnvwithidmax
AS
BEGIN 
DECLARE @i INT
SELECT @i = MAX(id) FROM dbo.nhanvien
SELECT * FROM dbo.nhanvien WHERE id=@i
END

--Thêm Hoa đơn nhập hàng 
GO
CREATE PROC thembillnguyenlieu
@tennguyenlieu NVARCHAR(50),@soluong INT,@donvi NVARCHAR(10),@ngaynhap date,@tongtien FLOAT
AS
BEGIN
		INSERT dbo.billnguyenlieu(tennguyenlieu,soluong,donvi,ngaynhap,tongtien) VALUES(@tennguyenlieu,@soluong,@donvi,@ngaynhap,@tongtien)
END
GO
-- hàm lấy bill mới nhất
CREATE PROC getbillnguyenlieuwithmaxid
AS
BEGIN
		DECLARE @max INT
        SELECT @max = MAX(id) FROM dbo.billnguyenlieu 
		SELECT * FROM dbo.billnguyenlieu WHERE id= @max
END
-- hàm sữa nhân viên
GO
CREATE PROC SuaNV
@id int ,@hoten NVARCHAR(50) , @gioitinh NVARCHAR(10) , @ngaysinh NVARCHAR(20),@sdt NVARCHAR(20)
AS
BEGIN
			UPDATE dbo.nhanvien SET hoten= @hoten WHERE id= @id
			UPDATE dbo.nhanvien SET gioitinh= @gioitinh WHERE id= @id
			UPDATE dbo.nhanvien SET ngaysinh= @ngaysinh WHERE id= @id
			UPDATE dbo.nhanvien SET sdt= @sdt WHERE id= @id
END

GO
----------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------
--Hàm Sữa phiếu nhập
GO
CREATE PROC SuaPN
@MaPN int , @tennguyenlieu nvarchar(50) ,@soluong int,@donvi nvarchar(10),@ngaynhap DATE,@tongtien float
AS
BEGIN
		UPDATE dbo.billnguyenlieu SET tennguyenlieu=@tennguyenlieu WHERE id=@MaPN
		UPDATE dbo.billnguyenlieu SET soluong=@soluong WHERE id=@MaPN
		UPDATE dbo.billnguyenlieu SET donvi=@donvi WHERE id=@MaPN
		UPDATE dbo.billnguyenlieu SET ngaynhap=@ngaynhap WHERE id=@MaPN
		UPDATE dbo.billnguyenlieu SET tongtien=@tongtien WHERE id=@MaPN
		
END
-- hàm lấy danh sách bill trong khoảng ngay
GO
CREATE PROC laydanhsachbilltrongngay
@ngay1 DATE , @ngay2 DATE
AS
BEGIN
		SELECT * FROM bill WHERE ngaydat >= @ngay1 AND ngaydat <= @ngay2
END
------------------------------------------------------------------------------------
-- Hàm lấy danh sách phiếu nhập trong khoảng ngày
GO
CREATE PROC laydanhsachphieunhaptrongkhoangngay
@ngay1 DATE , @ngay2 DATE
AS
BEGIN
		SELECT * FROM billnguyenlieu WHERE ngaynhap >= @ngay1 AND ngaynhap <= @ngay2
END

--hàm lấy bill trong tháng
GO
Create PROC laydanhsachbilltrongthang
@thang INT,@nam int
AS
BEGIN		
		SELECT * FROM dbo.bill WHERE MONTH(ngaydat) = @thang AND YEAR(ngaydat) = @nam
END
--Hàm lấy phieu nhap trong thang
GO
Create PROC laydanhsachphieunhaptrongthang
@thang INT,@nam int
AS
BEGIN
		SELECT * FROM dbo.billnguyenlieu WHERE MONTH(ngaynhap) = @thang AND YEAR(ngaynhap) = @nam
end

-- ----------------------------------------------

--hàm lấy bill trong năm
GO
Create PROC laydanhsachbilltrongnam
@nam int
AS
BEGIN		
		SELECT * FROM dbo.bill WHERE YEAR(ngaydat) = @nam
END
--Hàm lấy phieu nhap trong năm
GO
Create PROC laydanhsachphieunhaptrongnam
@nam int
AS
BEGIN
		SELECT * FROM dbo.billnguyenlieu WHERE YEAR(ngaynhap) = @nam
END
GO
-- Hàm sửa tài khoản
CREATE PROC SuaTK
@username NVARCHAR(50) , @password NVARCHAR(50) , @showname NVARCHAR(50) , @type INT
AS
BEGIN
     UPDATE dbo.taikhoan SET password = @password WHERE username = @username
	 UPDATE dbo.taikhoan SET showname = @showname WHERE username = @username
	 UPDATE dbo.taikhoan SET type = @type WHERE username = @username	
END
--Hàm thêm tài khoản
GO
CREATE PROC ThemTK
@username NVARCHAR(50) , @password NVARCHAR(50) , @showname NVARCHAR(50) , @type INT
AS
BEGIN
			INSERT dbo.taikhoan (username,password,showname,Type) VALUES (@username,@password,@showname,@type)
END
-- hàm xóa bill
GO
CREATE PROC XoaBill
@idBill INT
AS
BEGIN
		DELETE dbo.thongtinmon WHERE idbill = @idBill
		DELETE dbo.bill WHERE id = @idBill
END



