package model_user


type Pengguna struct{
	IdPengguna string `json:"idpengguna"`
    Email string `json:"email"`
    Username string `json:"username"`
    Nama string `json:"nama"`
    PhoneNumber string `json:"nomor_handphone"` 
    DetailRole []Roles `json:"role,omitempty"`
}

type Logoutsys struct{
    IdPengguna string `form:"idpengguna" json:"idpengguna" binding:"required"`
}

type Verify struct{
    Email string `form:"email" json:"email" binding:"required"`
    KodeToken string `form:"token_verify" json:"token_verify" binding:"required"`
}

type Roles struct{
    IdRole string `json:"id_role"`
    KodeRole string `json:"kode_role"`
    Keterangan string `json:"keterangan"`
}
type Login struct{
    Username string `form:"username" json:"username" binding:"required"`
    Password string `form:"password" json:"password" binding:"required"`
}

type Register struct{
    Namapengguna string `form:"nama_pengguna" json:"nama_pengguna" binding:"required"`
    Username string `form:"username" json:"username" binding:"required"` 
    Password string `form:"password" json:"password" binding:"required"` 
	Email string `form:"email" json:"email" binding:"required"`
	Handphone string `form:"nomor_handphone" json:"nomor_handphone"`
	Alamat string `form:"alamat" json:"alamat"`
}