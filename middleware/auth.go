package middleware

import (  
    "net/http"
    "../config" 
    "log"
    "github.com/gin-gonic/gin" 
)


func IsAuth() gin.HandlerFunc {
    return func(c *gin.Context) { 
        authHeader := c.Request.Header.Get("X-API-SESSION")  
        if (authHeader != "" ){ 
            var status int
            DB := config.Connect() //config ke db
            defer DB.Close() //pastikan sedang non aktif
            err := DB.QueryRow("SELECT `verify_token`(?)",
			authHeader, 
			).Scan(&status) 
            if err != nil {
                log.Print(err)
            }  
            if status==1 {
                c.JSON(http.StatusUnauthorized, gin.H{"message": "Invalid token"})
                c.Abort()
                return
            }else{
                c.Set("TOKEN",authHeader)
            }
        }else{
            c.JSON(http.StatusUnauthorized, gin.H{"message": "Invalid token"})
            c.Abort()
            return
        }        
    }
}