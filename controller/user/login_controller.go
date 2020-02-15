package controller_user

import(
    "../../config" 
    "../../model/user"
    "log" 
    "database/sql" 
    "net/http" 
    "github.com/gin-gonic/gin"   
)

func Verivy(c *gin.Context){
    var json model_user.Verify //ini ngambile struct login
    var status int
    if err := c.ShouldBindJSON(&json);err != nil{ //Cek requestnya sesuai atau tidak
        c.JSON(http.StatusBadRequest, gin.H{ 
            "message" : "Bad Request",  
            "error_code" : "000001", 
        }) 
    }else{
        DB := config.Connect() //config ke db
        defer DB.Close() //pastikan sedang non aktif
        err := DB.QueryRow("SELECT `verify_email_pengguna`(?,?) as Status",
			json.Email,
			json.KodeToken, 
			).Scan(&status)
		if err != nil {
			log.Print(err)
        }
        
        if status==1 {
			c.JSON(http.StatusOK, gin.H{ 
				"message" : "Email atau Token salah",  
				"error_code" : "000005", 
			})
		}else{
			//Send Email disini
			c.JSON(http.StatusOK, gin.H{ 
				"message" : "Akun anda sekarang sudah aktif",  
				"error_code" : "000000", 
			})
		}
        
    }
}

func Logout(c *gin.Context){
    var json model_user.Logoutsys //ini ngambile struct login  
    if err := c.ShouldBindJSON(&json);err != nil{ //Cek requestnya sesuai atau tidak
        c.JSON(http.StatusBadRequest, gin.H{ 
            "message" : "Bad Request",  
            "error_code" : "000001", 
        }) 
    }else{ //jika sesuai 
        DB := config.Connect() //config ke db
        defer DB.Close() //pastikan sedang non aktif 
        err := DB.QueryRow("CALL `logout_pengguna`(?,?)", //panggil query pake Query row untuk validasi jumlahnya
                json.IdPengguna, 
                c.MustGet("TOKEN"),
        )
        if err != nil {
            log.Print(err)
        } 
        c.JSON(http.StatusOK, gin.H{ 
            "message" : "Logout Berhasil",
            "error_code" : "000000",   
        })
        
    }
}

func Login(c *gin.Context){
    var json model_user.Login //ini ngambile struct login
    var status int
    if err := c.ShouldBindJSON(&json);err != nil{ //Cek requestnya sesuai atau tidak
        c.JSON(http.StatusBadRequest, gin.H{ 
            "message" : "Bad Request",  
            "error_code" : "000001", 
        }) 
    }else{ //jika sesuai
        var user model_user.Pengguna //ambil struct pengguna
        var role model_user.Roles   //ambil struct rule
        var arr_role []model_user.Roles  //buat array untuk nampung struct
        DB := config.Connect() //config ke db
        defer DB.Close() //pastikan sedang non aktif
        
        err := DB.QueryRow("CALL `login_pengguna`(?,?)", //panggil query pake Query row untuk validasi jumlahnya
                json.Username, //parsing data
                json.Password,  
        ).Scan(&user.IdPengguna, //scan data yang didapatkan
            &user.PhoneNumber,
            &user.Nama,
            &user.Email, 
            &user.Username,
            &status) 
    
        if err != nil {
            log.Print(err)
        }
        switch {
            case err == sql.ErrNoRows:
                c.JSON(http.StatusUnauthorized, gin.H{ 
                    "message" : "Unauthorized",
                    "error_code" : "000002", 
                })           
            default: 
                if status==1 {
                    rows, err := DB.Query("CALL `view_role_pengguna`(?)",user.IdPengguna)
                    if err != nil {
                        log.Print(err)
                    } 
                    for rows.Next() {
                        if err := rows.Scan(&role.KodeRole, &role.Keterangan, &role.IdRole); err != nil {
                            log.Fatal(err.Error()) 
                        } else {
                            arr_role = append(arr_role, role)
                        }
                    }
                    user.DetailRole = arr_role

                    if err != nil {
                        log.Print(err)
                    }
                    Token := createToken(&user)
                    c.JSON(http.StatusOK, gin.H{ 
                        "message" : "Autentikasi Berhasil",
                        "error_code" : "000000",  
                        "token" : Token,
                        "detail" : user,
                    })  
                }else{
                    c.JSON(http.StatusOK, gin.H{ 
                        "message" : "User belum diaktifkan, silakan verifikasi email anda !",
                        "error_code" : "000003",
                    }) 
                }
                
        } 
    }
}


func createToken(pengguna *model_user.Pengguna) string{
    var tokenstring string
        DB := config.Connect() //config ke db
        defer DB.Close() //pastikan sedang non aktif
        err := DB.QueryRow("SELECT `create_token`(?)",
            pengguna.IdPengguna, 
            ).Scan(&tokenstring)
        if err != nil {
            log.Print(err)
        }
    return tokenstring
}



 