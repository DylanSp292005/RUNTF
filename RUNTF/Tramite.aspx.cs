using System;
using System.Configuration;
using System.Data.SqlClient;

namespace RUNTF
{
    public partial class Tramite : System.Web.UI.Page
    {
        static object N(string s) { return string.IsNullOrWhiteSpace(s) ? (object)DBNull.Value : s.Trim(); }
        static object I(string s) { int v; return int.TryParse(s, out v) ? (object)v : DBNull.Value; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) txtFecha.Text = DateTime.Today.ToString("dd/MM/yyyy");
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;
            bool traspaso = rblTramite.SelectedValue == "2";
            if (ucProp.Vacio) { Msg("Los datos del propietario son obligatorios.", false); return; }
            if (traspaso && ucComp.Vacio) { Msg("En un traspaso debe diligenciar los datos del comprador.", false); return; }

            using (var cn = new SqlConnection(ConfigurationManager.ConnectionStrings["RuntCS"].ConnectionString))
            {
                cn.Open();
                var tx = cn.BeginTransaction();
                try
                {
                    int propId = ucProp.Guardar(cn, tx).Value;
                    int? compId = traspaso ? ucComp.Guardar(cn, tx) : null;
                    string placa = txtPlaca.Text.Trim().ToUpper();

                    // Vehículo: crear o actualizar
                    string sqlV = @"IF EXISTS(SELECT 1 FROM Vehiculo WHERE Placa=@placa)
                      UPDATE Vehiculo SET ClaseId=@clase,Marca=@marca,Linea=@linea,CombustibleId=@comb,Colores=@col,Modelo=@mod,
                       Cilindrada=@cil,Capacidad=@cap,Blindaje=@bl,ResolBlindaje=@rbl,DesmonteBlind=@dm,ResolDesmonte=@rdm,Potencia=@pot,
                       CarroceriaId=@carr,NumMotor=@mot,MotorRegrabado=@rm,NumChasis=@cha,ChasisRegrabado=@rc,NumSerie=@ser,SerieRegrabado=@rs,
                       NumVIN=@vin,ImportDoc=@imp,RemateEntidad=@rent,RemateCiudad=@rciu,DocImpRemate=@dimp,FechaImpRemate=@fimp,
                       TipoServicioId=@serv,EmpresaVinculadora=@emp,NitEmpresa=@nit,PropietarioId=@prop WHERE Placa=@placa
                     ELSE INSERT Vehiculo(Placa,ClaseId,Marca,Linea,CombustibleId,Colores,Modelo,Cilindrada,Capacidad,Blindaje,ResolBlindaje,
                       DesmonteBlind,ResolDesmonte,Potencia,CarroceriaId,NumMotor,MotorRegrabado,NumChasis,ChasisRegrabado,NumSerie,SerieRegrabado,
                       NumVIN,ImportDoc,RemateEntidad,RemateCiudad,DocImpRemate,FechaImpRemate,TipoServicioId,EmpresaVinculadora,NitEmpresa,PropietarioId)
                      VALUES(@placa,@clase,@marca,@linea,@comb,@col,@mod,@cil,@cap,@bl,@rbl,@dm,@rdm,@pot,@carr,@mot,@rm,@cha,@rc,@ser,@rs,
                       @vin,@imp,@rent,@rciu,@dimp,@fimp,@serv,@emp,@nit,@prop)";
                    using (var c = new SqlCommand(sqlV, cn, tx))
                    {
                        var p = c.Parameters;
                        p.AddWithValue("@placa", placa); p.AddWithValue("@clase", I(rblClase.SelectedValue));
                        p.AddWithValue("@marca", N(txtMarca.Text)); p.AddWithValue("@linea", N(txtLinea.Text));
                        p.AddWithValue("@comb", I(rblComb.SelectedValue)); p.AddWithValue("@col", N(txtColores.Text));
                        p.AddWithValue("@mod", I(txtModelo.Text)); p.AddWithValue("@cil", I(txtCil.Text));
                        p.AddWithValue("@cap", N(txtCap.Text));
                        p.AddWithValue("@bl", chkBlind.Checked); p.AddWithValue("@rbl", N(txtResBlind.Text));
                        p.AddWithValue("@dm", chkDesm.Checked); p.AddWithValue("@rdm", N(txtResDesm.Text));
                        p.AddWithValue("@pot", I(txtPot.Text)); p.AddWithValue("@carr", I(ddlCarr.SelectedValue));
                        p.AddWithValue("@mot", N(txtMotor.Text)); p.AddWithValue("@rm", chkMotor.Checked);
                        p.AddWithValue("@cha", N(txtChasis.Text)); p.AddWithValue("@rc", chkChasis.Checked);
                        p.AddWithValue("@ser", N(txtSerie.Text)); p.AddWithValue("@rs", chkSerie.Checked);
                        p.AddWithValue("@vin", N(txtVin.Text)); p.AddWithValue("@imp", I(rblImp.SelectedValue));
                        p.AddWithValue("@rent", N(txtRemEnt.Text)); p.AddWithValue("@rciu", N(txtRemCiu.Text));
                        p.AddWithValue("@dimp", N(txtDocImp.Text));
                        DateTime fi; p.AddWithValue("@fimp", DateTime.TryParse(txtFechaImp.Text, out fi) ? (object)fi : DBNull.Value);
                        p.AddWithValue("@serv", I(rblServ.SelectedValue));
                        p.AddWithValue("@emp", N(txtEmp.Text)); p.AddWithValue("@nit", N(txtNit.Text));
                        // En traspaso, el comprador pasa a ser el nuevo propietario
                        p.AddWithValue("@prop", traspaso && compId.HasValue ? compId.Value : propId);
                        c.ExecuteNonQuery();
                    }

                    // Registro del trámite
                    string sqlT = @"INSERT Tramite(Placa,TipoTramiteId,PropietarioId,CompradorId,AlertaHurto,AlertaLimPropiedad,AlertaEmbargo,AlertaOtro,AlertaAFavorDe,Observaciones)
                                    VALUES(@placa,@tt,@prop,@comp,@h,@l,@e,@o,@fav,@obs)";
                    using (var c = new SqlCommand(sqlT, cn, tx))
                    {
                        var p = c.Parameters;
                        p.AddWithValue("@placa", placa); p.AddWithValue("@tt", int.Parse(rblTramite.SelectedValue));
                        p.AddWithValue("@prop", propId); p.AddWithValue("@comp", compId.HasValue ? (object)compId.Value : DBNull.Value);
                        p.AddWithValue("@h", cblAlerta.Items[0].Selected); p.AddWithValue("@l", cblAlerta.Items[1].Selected);
                        p.AddWithValue("@e", cblAlerta.Items[2].Selected); p.AddWithValue("@o", cblAlerta.Items[3].Selected);
                        p.AddWithValue("@fav", N(txtFavor.Text)); p.AddWithValue("@obs", N(txtObs.Text));
                        c.ExecuteNonQuery();
                    }
                    tx.Commit();
                    Msg("Trámite registrado correctamente.", true);
                    gvTramites.DataBind();
                }
                catch (Exception ex) { tx.Rollback(); Msg("Error al guardar: " + ex.Message, false); }
            }
        }

        protected void btnLimpiar_Click(object sender, EventArgs e) { Response.Redirect("Tramite.aspx"); }

        protected void Siguiente_Click(object sender, EventArgs e)
        {
            Page.Validate();
            if (!Page.IsValid) return;          // no avanza si el paso tiene errores
            Ir(mv.ActiveViewIndex + 1);
        }

        protected void Anterior_Click(object sender, EventArgs e) { Ir(mv.ActiveViewIndex - 1); }

        void Ir(int i)
        {
            mv.ActiveViewIndex = i;
            lblPaso.Text = "Paso " + (i + 1) + " de " + mv.Views.Count;
        }

        void Msg(string t, bool ok) { lblMsg.Text = t; lblMsg.CssClass = ok ? "ok" : "err"; }
    }
}