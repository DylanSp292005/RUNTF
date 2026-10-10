<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Tramite.aspx.cs" Inherits="RUNTF.Tramite" %>
<%@ Register Src="Persona.ascx" TagName="Persona" TagPrefix="uc" %>
<!DOCTYPE html>
<html><head runat="server"><title>RUNT - Solicitud de trámites</title>
<style>
 body{font-family:Segoe UI,Arial;background:#eef1f5;margin:0}
 #wrap{max-width:1000px;margin:auto;padding:16px}
 h1{text-align:center;color:#1b3a6b;font-size:20px}
 fieldset{background:#fff;border:1px solid #1b3a6b;border-radius:6px;margin-bottom:12px}
 legend{background:#1b3a6b;color:#fff;padding:2px 10px;border-radius:4px;font-weight:bold}
 .t{width:100%}.t td{padding:4px;vertical-align:top}
 input[type=text],input[type=date],select,textarea{width:95%}
 .btn{background:#1b3a6b;color:#fff;border:0;padding:8px 22px;border-radius:4px;cursor:pointer}
 .ok{color:green;font-weight:bold}.err{color:#b00}
</style></head>
<body><form id="form1" runat="server"><div id="wrap">
<h1>MINISTERIO DE TRANSPORTE — FORMULARIO DE SOLICITUD DE TRÁMITES DEL REGISTRO NACIONAL AUTOMOTOR</h1>
<asp:ValidationSummary runat="server" CssClass="err" />

<h3><asp:Label ID="lblPaso" runat="server" Text="Paso 1 de 6" /></h3>
<asp:MultiView ID="mv" runat="server" ActiveViewIndex="0">
<asp:View ID="v1" runat="server">
<fieldset><legend>1. Organismo de tránsito / 2. Placa</legend>
 <table class="t"><tr>
  <td>Organismo<br /><asp:TextBox ID="txtOrg" runat="server" Text="Servicios Integrales para la Movilidad - SIM" ReadOnly="true" /></td>
  <td>Ciudad<br /><asp:TextBox ID="txtCiu" runat="server" Text="Bogotá" ReadOnly="true" /></td>
  <td>Código<br /><asp:TextBox ID="txtCod" runat="server" Text="11001" ReadOnly="true" /></td>
  <td>Fecha de trámite<br /><asp:TextBox ID="txtFecha" runat="server" ReadOnly="true" /></td>
  <td>Placa (letras y números)<br /><asp:TextBox ID="txtPlaca" runat="server" MaxLength="6" />
   <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPlaca" ErrorMessage="La placa es obligatoria." Text="*" />
   <asp:RegularExpressionValidator runat="server" ControlToValidate="txtPlaca" ValidationExpression="^[A-Za-z]{3}\d{2}[A-Za-z0-9]$" ErrorMessage="Placa inválida (ej. ABC123 o ABC12D)." Text="*" /></td>
 </tr></table></fieldset>

<fieldset><legend>3. Trámite solicitado</legend>
 <asp:RadioButtonList ID="rblTramite" runat="server" RepeatColumns="6" DataSourceID="sdTramite" DataTextField="Nombre" DataValueField="Id" />
 <asp:RequiredFieldValidator runat="server" ControlToValidate="rblTramite" ErrorMessage="Seleccione el trámite." Text="*" />
 <asp:SqlDataSource ID="sdTramite" runat="server" ConnectionString="<%$ ConnectionStrings:RuntCS %>" SelectCommand="SELECT Id,Nombre FROM TipoTramite" /></fieldset>

<fieldset><legend>4. Clase de vehículo</legend>
 <asp:RadioButtonList ID="rblClase" runat="server" RepeatColumns="7" DataSourceID="sdClase" DataTextField="Nombre" DataValueField="Id" />
 <asp:RequiredFieldValidator runat="server" ControlToValidate="rblClase" ErrorMessage="Seleccione la clase de vehículo." Text="*" />
 <asp:SqlDataSource ID="sdClase" runat="server" ConnectionString="<%$ ConnectionStrings:RuntCS %>" SelectCommand="SELECT Id,Nombre FROM ClaseVehiculo" /></fieldset>

<p style="text-align:center"><asp:Button runat="server" Text="Siguiente &raquo;" CssClass="btn" OnClick="Siguiente_Click" /></p>
</asp:View>
<asp:View ID="v2" runat="server">
<fieldset><legend>5-14. Características del vehículo</legend>
 <table class="t">
 <tr><td>5. Marca<br /><asp:TextBox ID="txtMarca" runat="server" /></td>
     <td>6. Línea<br /><asp:TextBox ID="txtLinea" runat="server" /></td>
     <td>9. Modelo (año)<br /><asp:TextBox ID="txtModelo" runat="server" />
       <asp:RangeValidator runat="server" ControlToValidate="txtModelo" Type="Integer" MinimumValue="1900" MaximumValue="2100" ErrorMessage="Modelo inválido." Text="*" /></td></tr>
 <tr><td colspan="3">7. Combustible<br /><asp:RadioButtonList ID="rblComb" runat="server" RepeatDirection="Horizontal" DataSourceID="sdComb" DataTextField="Nombre" DataValueField="Id" />
   <asp:SqlDataSource ID="sdComb" runat="server" ConnectionString="<%$ ConnectionStrings:RuntCS %>" SelectCommand="SELECT Id,Nombre FROM Combustible" /></td></tr>
 <tr><td>8. Colores (máx. 3)<br /><asp:TextBox ID="txtColores" runat="server" /></td>
     <td>10. Cilindrada (cc)<br /><asp:TextBox ID="txtCil" runat="server" />
       <asp:CompareValidator runat="server" ControlToValidate="txtCil" Operator="DataTypeCheck" Type="Integer" ErrorMessage="Cilindrada numérica." Text="*" /></td>
     <td>11. Capacidad (Kg / Psj.)<br /><asp:TextBox ID="txtCap" runat="server" /></td></tr>
 <tr><td>12. Blindaje <asp:CheckBox ID="chkBlind" runat="server" /><br />Resolución<br /><asp:TextBox ID="txtResBlind" runat="server" /></td>
     <td>13. Desmonte blindaje <asp:CheckBox ID="chkDesm" runat="server" /><br />Resolución<br /><asp:TextBox ID="txtResDesm" runat="server" /></td>
     <td>14. Potencia (HP)<br /><asp:TextBox ID="txtPot" runat="server" />
       <asp:CompareValidator runat="server" ControlToValidate="txtPot" Operator="DataTypeCheck" Type="Integer" ErrorMessage="Potencia numérica." Text="*" /></td></tr>
 </table></fieldset>

<p style="text-align:center"><asp:Button runat="server" Text="&laquo; Anterior" CssClass="btn" CausesValidation="false" OnClick="Anterior_Click" /> <asp:Button runat="server" Text="Siguiente &raquo;" CssClass="btn" OnClick="Siguiente_Click" /></p>
</asp:View>
<asp:View ID="v3" runat="server">
<fieldset><legend>15. Carrocería / 16. Identificación interna</legend>
 <table class="t">
 <tr><td colspan="3">Tipo de carrocería<br /><asp:DropDownList ID="ddlCarr" runat="server" DataSourceID="sdCarr" DataTextField="Nombre" DataValueField="Id" AppendDataBoundItems="true"><asp:ListItem Value="">-- Seleccione --</asp:ListItem></asp:DropDownList>
   <asp:SqlDataSource ID="sdCarr" runat="server" ConnectionString="<%$ ConnectionStrings:RuntCS %>" SelectCommand="SELECT Id,Nombre FROM Carroceria" /></td></tr>
 <tr><td>No. de motor<br /><asp:TextBox ID="txtMotor" runat="server" /><br /><asp:CheckBox ID="chkMotor" runat="server" Text="Regrabado" /></td>
     <td>No. de chasis<br /><asp:TextBox ID="txtChasis" runat="server" /><br /><asp:CheckBox ID="chkChasis" runat="server" Text="Regrabado" /></td>
     <td>No. de serie<br /><asp:TextBox ID="txtSerie" runat="server" /><br /><asp:CheckBox ID="chkSerie" runat="server" Text="Regrabado" /></td></tr>
 <tr><td colspan="3">No. de VIN (vehículos automotores)<br /><asp:TextBox ID="txtVin" runat="server" /></td></tr>
 </table></fieldset>

<fieldset><legend>17. Importación o remate</legend>
 <table class="t">
 <tr><td colspan="4">Importación:
   <asp:RadioButtonList ID="rblImp" runat="server" RepeatDirection="Horizontal">
     <asp:ListItem Value="1">1. Manifiesto o acta</asp:ListItem><asp:ListItem Value="2">2. Dec. de importación</asp:ListItem><asp:ListItem Value="3">3. Acta</asp:ListItem></asp:RadioButtonList></td></tr>
 <tr><td>Remate - Entidad<br /><asp:TextBox ID="txtRemEnt" runat="server" /></td>
     <td>Lugar (ciudad)<br /><asp:TextBox ID="txtRemCiu" runat="server" /></td>
     <td>No. documento<br /><asp:TextBox ID="txtDocImp" runat="server" /></td>
     <td>Fecha<br /><asp:TextBox ID="txtFechaImp" runat="server" TextMode="Date" /></td></tr>
 </table></fieldset>

<p style="text-align:center"><asp:Button runat="server" Text="&laquo; Anterior" CssClass="btn" CausesValidation="false" OnClick="Anterior_Click" /> <asp:Button runat="server" Text="Siguiente &raquo;" CssClass="btn" OnClick="Siguiente_Click" /></p>
</asp:View>
<asp:View ID="v4" runat="server">
<fieldset><legend>18. Tipo de servicio / 19. Empresa vinculadora</legend>
 <asp:RadioButtonList ID="rblServ" runat="server" RepeatDirection="Horizontal" DataSourceID="sdServ" DataTextField="Nombre" DataValueField="Id" />
 <asp:SqlDataSource ID="sdServ" runat="server" ConnectionString="<%$ ConnectionStrings:RuntCS %>" SelectCommand="SELECT Id,Nombre FROM TipoServicio" />
 <table class="t"><tr><td>Nombre empresa<br /><asp:TextBox ID="txtEmp" runat="server" /></td><td>NIT<br /><asp:TextBox ID="txtNit" runat="server" /></td></tr></table></fieldset>

<fieldset><legend>20. Datos de alerta</legend>
 <asp:CheckBoxList ID="cblAlerta" runat="server" RepeatDirection="Horizontal">
  <asp:ListItem Value="H">1. Hurto</asp:ListItem><asp:ListItem Value="L">2. Lim. propiedad</asp:ListItem>
  <asp:ListItem Value="E">3. Embargo</asp:ListItem><asp:ListItem Value="O">4. Otro</asp:ListItem></asp:CheckBoxList>
 5. A favor de: <asp:TextBox ID="txtFavor" runat="server" Width="300" /></fieldset>

<p style="text-align:center"><asp:Button runat="server" Text="&laquo; Anterior" CssClass="btn" CausesValidation="false" OnClick="Anterior_Click" /> <asp:Button runat="server" Text="Siguiente &raquo;" CssClass="btn" OnClick="Siguiente_Click" /></p>
</asp:View>
<asp:View ID="v5" runat="server">
<fieldset><legend>21. Datos del propietario</legend><uc:Persona ID="ucProp" runat="server" /></fieldset>
<fieldset><legend>22. Datos del comprador (solo traspaso)</legend><uc:Persona ID="ucComp" runat="server" /></fieldset>

<p style="text-align:center"><asp:Button runat="server" Text="&laquo; Anterior" CssClass="btn" CausesValidation="false" OnClick="Anterior_Click" /> <asp:Button runat="server" Text="Siguiente &raquo;" CssClass="btn" OnClick="Siguiente_Click" /></p>
</asp:View>
<asp:View ID="v6" runat="server">
<fieldset><legend>23. Observaciones</legend>
 <asp:TextBox ID="txtObs" runat="server" TextMode="MultiLine" Rows="4" MaxLength="500" />
 <p style="font-size:12px">Si el vehículo fue matriculado antes del RUNT, transcriba el tipo de carrocería y la clase registrada en su licencia de tránsito.</p></fieldset>

<p style="text-align:center"><asp:Button runat="server" Text="&laquo; Anterior" CssClass="btn" CausesValidation="false" OnClick="Anterior_Click" /> <asp:Button ID="btnGuardar" runat="server" Text="Guardar trámite" CssClass="btn" OnClick="btnGuardar_Click" />
 <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CssClass="btn" CausesValidation="false" OnClick="btnLimpiar_Click" /><br />
 <asp:Label ID="lblMsg" runat="server" /></p>
</asp:View>
</asp:MultiView>

<fieldset><legend>Trámites registrados</legend>
 <asp:GridView ID="gvTramites" runat="server" DataSourceID="sdGrid" AutoGenerateColumns="false" AllowPaging="true" PageSize="10" Width="100%">
  <Columns>
   <asp:BoundField DataField="Id" HeaderText="No." /><asp:BoundField DataField="Placa" HeaderText="Placa" />
   <asp:BoundField DataField="Tramite" HeaderText="Trámite" /><asp:BoundField DataField="Propietario" HeaderText="Propietario" />
   <asp:BoundField DataField="Comprador" HeaderText="Comprador" />
   <asp:BoundField DataField="FechaTramite" HeaderText="Fecha" DataFormatString="{0:dd/MM/yyyy}" />
  </Columns></asp:GridView>
 <asp:SqlDataSource ID="sdGrid" runat="server" ConnectionString="<%$ ConnectionStrings:RuntCS %>"
  SelectCommand="SELECT t.Id,t.Placa,tt.Nombre AS Tramite,p.Nombres+' '+ISNULL(p.PrimerApellido,'') AS Propietario,
   ISNULL(c.Nombres+' '+ISNULL(c.PrimerApellido,''),'') AS Comprador,t.FechaTramite
   FROM Tramite t JOIN TipoTramite tt ON tt.Id=t.TipoTramiteId JOIN Persona p ON p.Id=t.PropietarioId
   LEFT JOIN Persona c ON c.Id=t.CompradorId ORDER BY t.Id DESC" /></fieldset>
</div></form></body></html>

