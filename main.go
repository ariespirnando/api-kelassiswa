package main
import(
    "./controller/user"  
    "./controller/kelas"  
    "./middleware"
    "github.com/gin-gonic/gin" 
    "github.com/subosito/gotenv" 
    "log"
    "os" 
)
func init()  {
	err := gotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file")
    } 
    if(os.Getenv("GIN_MODE")=="release"){
        gin.SetMode(gin.ReleaseMode)
    }
}
func main(){   
    router := gin.Default()  
    v1 := router.Group("/api/user/")
    { 
        v1.POST("/auth", controller_user.Login) 
        v1.POST("/logout",middleware.IsAuth(),controller_user.Logout) 
        v1.POST("/register", controller_user.Register) 
        v1.POST("/verify", controller_user.Verivy)  
    } 
    v2 := router.Group("/api/kelas/")
    { 
        v2.POST("/list",middleware.IsAuth(),controller_kelas.ListKelas) 
        v2.POST("/list_bypengguna",middleware.IsAuth(),controller_kelas.ListKelas_pengguna) 
        v2.POST("/add_kelas",middleware.IsAuth(),controller_kelas.Addkelas) 
        v2.POST("/materi_kelas",middleware.IsAuth(),controller_kelas.Materi_kelas)  
    } 
    router.Run(os.Getenv("PORT"))
}