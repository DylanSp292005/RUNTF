using System;
using System.Data.SqlClient;

public partial class Persona : System.Web.UI.UserControl
{
    public bool Vacio { get { return txtNumDoc.Text.Trim() == ""; } }

    static object N(string s) { return string.IsNullOrWhiteSpace(s) ? (object)DBNull.Value : s.Trim(); }

    // Inserta o actualiza la persona (por No. de documento) y devuelve su Id
    public int? Guardar(SqlConnection cn, SqlTransaction tx)
    {
        if (Vacio) return null;
        string sql = @"IF EXISTS(SELECT 1 FROM Persona WHERE NumeroDoc=@n)
            UPDATE Persona SET TipoDoc=@t,PrimerApellido=@a1,SegundoApellido=@a2,Nombres=@nom,Direccion=@d,Ciudad=@c,Telefono=@tel WHERE NumeroDoc=@n
          ELSE INSERT Persona(TipoDoc,NumeroDoc,PrimerApellido,SegundoApellido,Nombres,Direccion,Ciudad,Telefono)
            VALUES(@t,@n,@a1,@a2,@nom,@d,@c,@tel);
          SELECT Id FROM Persona WHERE NumeroDoc=@n";
        using (var cmd = new SqlCommand(sql, cn, tx))
        {
            cmd.Parameters.AddWithValue("@t", N(rblDoc.SelectedValue));
            cmd.Parameters.AddWithValue("@n", txtNumDoc.Text.Trim());
            cmd.Parameters.AddWithValue("@a1", N(txtAp1.Text));
            cmd.Parameters.AddWithValue("@a2", N(txtAp2.Text));
            cmd.Parameters.AddWithValue("@nom", txtNombres.Text.Trim());
            cmd.Parameters.AddWithValue("@d", N(txtDir.Text));
            cmd.Parameters.AddWithValue("@c", N(txtCiudad.Text));
            cmd.Parameters.AddWithValue("@tel", N(txtTel.Text));
            return (int)cmd.ExecuteScalar();
        }
    }
}