package model_kelas
type GetKelas struct{
	IdPengguna string `form:"idpengguna" json:"idpengguna" binding:"required"`
}
type DaftarKelas struct{
	IdKelas string `json:"id_kelas"`
	KodeKelas string `json:"kode_kelas"`
	NamaKelas string `json:"nama_kelas"`
	Keterangan string `json:"keterangan"`
	StatusKelas string `json:"status"`
	TipeKelas string `json:"tipe_kelas"`
	Pengajar []Pengajars `json:"pengajar,omitempty"`
}
type Kelas struct{
	IdKelas string `json:"id_kelas"`
	IdPengguna string `json:"idpengguna"`
}
type Materi struct{
	Preview string `json:"preview"`
	Video string `json:"link_video"`
	Keterangan string `json:"keterangan"`
}
type Pengajars struct{
	IdPengajar string `json:"id_pengajar"`
	NamaPengajar string `json:"nama_pengajar"`
	EmailPengajar string `json:"email"`
}
