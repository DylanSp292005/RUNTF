<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Persona.ascx.cs" Inherits="Persona" %>
<table class="t">
 <tr><td>Primer apellido<br /><asp:TextBox ID="txtAp1" runat="server" /></td>
     <td>Segundo apellido<br /><asp:TextBox ID="txtAp2" runat="server" /></td>
     <td>Nombres<br /><asp:TextBox ID="txtNombres" runat="server" /></td></tr>
 <tr><td colspan="3">Tipo de documento<br />
     <asp:RadioButtonList ID="rblDoc" runat="server" RepeatDirection="Horizontal" DataSourceID="sdDoc"
        DataTextField="Nombre" DataValueField="Codigo" />
     <asp:SqlDataSource ID="sdDoc" runat="server" ConnectionString="<%$ ConnectionStrings:RuntCS %>"
        SelectCommand="SELECT Codigo, Nombre FROM TipoDocumento" /></td></tr>
 <tr><td>No. documento<br /><asp:TextBox ID="txtNumDoc" runat="server" /></td>
     <td>Dirección<br /><asp:TextBox ID="txtDir" runat="server" /></td>
     <td>Ciudad<br /><asp:TextBox ID="txtCiudad" runat="server" /></td></tr>
 <tr><td>Teléfono<br /><asp:TextBox ID="txtTel" runat="server" TextMode="Phone" /></td>
     <td colspan="2">Firma (nombre de quien firma)<br /><asp:TextBox ID="txtFirma" runat="server" Width="300" /></td></tr>
</table>