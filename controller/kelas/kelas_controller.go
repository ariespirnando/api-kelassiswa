package controller_kelas

import(
    "../../config" 
    "../../model/kelas"
	"log"  
    "net/http" 
    "github.com/gin-gonic/gin"   
)
func Addkelas(c *gin.Context){ 
	var json model_kelas.Kelas //ini ngambile struct login
	var status int
	DB := config.Connect() //config ke db
    defer DB.Close() //pastikan sedang non aktif
    if err := c.ShouldBindJSON(&json);err != nil{ //Cek requestnya sesuai atau tidak
        c.JSON(http.StatusBadRequest, gin.H{ 
            "message" : "Bad Request",  
            "error_code" : "000001", 
        }) 
    } else{
		err := DB.QueryRow("SELECT `add_kelas_siswa`(?, ?)",
			json.IdKelas,
			json.IdPengguna, 
			).Scan(&status)

		if err != nil {
			log.Print(err)
		} 

		if status==1 {
			c.JSON(http.StatusOK, gin.H{ 
				"message" : "Anda sudah terdaftar di kelas",  
				"error_code" : "000007", 
			})
		}else{
			//Send Email disini
			c.JSON(http.StatusOK, gin.H{ 
				"message" : "Berhasil register kelas, silahkan cek email anda !",  
				"error_code" : "000000", 
			})
		}
		
	}
}
func ListKelas_pengguna(c *gin.Context){
	var json model_kelas.GetKelas //ini ngambile struct login
	var kelas model_kelas.DaftarKelas  
	var arr_kelas []model_kelas.DaftarKelas
    if err := c.ShouldBindJSON(&json);err != nil{ //Cek requestnya sesuai atau tidak
        c.JSON(http.StatusBadRequest, gin.H{ 
            "message" : "Bad Request",  
            "error_code" : "000001", 
        }) 
    }else{
        DB := config.Connect() //config ke db
        defer DB.Close() //pastikan sedang non aktif
        rows, err := DB.Query("CALL `view_kelas_pengguna`(?)",json.IdPengguna)
		if err != nil {
			log.Print(err)
		}  
		for rows.Next() { 
			var pengajar model_kelas.Pengajars
			var arr_pengajar []model_kelas.Pengajars

			if err := rows.Scan(&kelas.IdKelas, &kelas.KodeKelas, 
				&kelas.NamaKelas,&kelas.Keterangan,&kelas.TipeKelas,&kelas.StatusKelas); err != nil {
				log.Fatal(err.Error()) 
			} else { 
				defer DB.Close()
				rows2, err2 := DB.Query("CALL `view_kelas_pengajar`(?)",kelas.IdKelas)
				if err2 != nil {
					log.Print(err2)
				} 
				for rows2.Next() { 
					if err2 := rows2.Scan(&pengajar.IdPengajar, &pengajar.NamaPengajar, 
						&pengajar.EmailPengajar); err != nil {
						log.Fatal(err2.Error()) 
					} else { 
						arr_pengajar = append(arr_pengajar,pengajar)
					}
				} 
				kelas.Pengajar = arr_pengajar
				arr_kelas = append(arr_kelas, kelas)
			}
		} 

		if err != nil {
			log.Print(err)
		} 
		if arr_kelas == nil{
			c.JSON(http.StatusOK, gin.H{  
				"error_code" : "000006",   
				"message" : "Data tidak ditemukan",
			})  
		}else{
			c.JSON(http.StatusOK, gin.H{  
				"error_code" : "000000",   
				"detail_kelas" : arr_kelas,
			})  
		}  
    }
}
func Materi_kelas(c *gin.Context){
	var json model_kelas.Kelas //ini ngambile struct login
	var materi model_kelas.Materi   
	var arr_materi []model_kelas.Materi 
    if err := c.ShouldBindJSON(&json);err != nil{ //Cek requestnya sesuai atau tidak
        c.JSON(http.StatusBadRequest, gin.H{ 
            "message" : "Bad Request",  
            "error_code" : "000001", 
        }) 
    }else{ 
        DB := config.Connect() //config ke db
        defer DB.Close() //pastikan sedang non aktif
        rows, err := DB.Query("CALL `view_materi`(?,?)",json.IdKelas,json.IdPengguna)
		if err != nil {
			log.Print(err)
		}  
		for rows.Next() {  
			if err := rows.Scan(&materi.Preview, &materi.Video,&materi.Keterangan); err != nil {
				log.Fatal(err.Error()) 
			} else {  
				arr_materi = append(arr_materi, materi)
			}
		} 
		if err != nil {
			log.Print(err)
		} 
		if arr_materi == nil{
			c.JSON(http.StatusOK, gin.H{  
				"error_code" : "000006",   
				"message" : "Data tidak ditemukan",
			})  
		}else{
			c.JSON(http.StatusOK, gin.H{  
				"error_code" : "000000",   
				"materi_kelas" : arr_materi,
			})  
		}  
    }
}
func ListKelas(c *gin.Context){
	var json model_kelas.GetKelas //ini ngambile struct login
	var kelas model_kelas.DaftarKelas  
	var arr_kelas []model_kelas.DaftarKelas
    if err := c.ShouldBindJSON(&json);err != nil{ //Cek requestnya sesuai atau tidak
        c.JSON(http.StatusBadRequest, gin.H{ 
            "message" : "Bad Request",  
            "error_code" : "000001", 
        }) 
    }else{
        DB := config.Connect() //config ke db
        defer DB.Close() //pastikan sedang non aktif
        rows, err := DB.Query("CALL `view_kelas`(?)",json.IdPengguna)
		if err != nil {
			log.Print(err)
		} 
		for rows.Next() { 
			var pengajar model_kelas.Pengajars
			var arr_pengajar []model_kelas.Pengajars

			if err := rows.Scan(&kelas.IdKelas, &kelas.KodeKelas, 
				&kelas.NamaKelas,&kelas.Keterangan,&kelas.TipeKelas,&kelas.StatusKelas); err != nil {
				log.Fatal(err.Error()) 
			} else { 
				defer DB.Close()
				rows2, err2 := DB.Query("CALL `view_kelas_pengajar`(?)",kelas.IdKelas)
				if err2 != nil {
					log.Print(err2)
				} 
				for rows2.Next() { 
					if err2 := rows2.Scan(&pengajar.IdPengajar, &pengajar.NamaPengajar, 
						&pengajar.EmailPengajar); err != nil {
						log.Fatal(err2.Error()) 
					} else { 
						arr_pengajar = append(arr_pengajar,pengajar)
					}
				} 
				kelas.Pengajar = arr_pengajar
				arr_kelas = append(arr_kelas, kelas)
			}
		} 

		if err != nil {
			log.Print(err)
		} 
		if arr_kelas == nil{
			c.JSON(http.StatusOK, gin.H{  
				"error_code" : "000006",   
				"message" : "Data tidak ditemukan",
			})  
		}else{
			c.JSON(http.StatusOK, gin.H{  
				"error_code" : "000000",   
				"detail_kelas" : arr_kelas,
			})  
		}  
        
    }
}
