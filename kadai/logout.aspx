<%@ Register TagPrefix="INCLUDE" TagName="TOP" src="top.ascx" %>
<%@ Register TagPrefix="INCLUDE" TagName="BOTTOM" src="bottom.ascx" %>


<script language="C#" runat="server">

	void Page_Load()
	{
		if (Session["login_id"] != null)
		{
			Session.Abandon();
			Response.Redirect("logout.aspx");
		}

	}

</script>


<INCLUDE:TOP
	runat="server" />



<!--------------------------- ���⼭���� ���� ------>
<div id="content">


<center>

�����ܪ˫������Ȫ���ު���!

</center>



</div>
<!-- ���볡 ---------------------------------------->



<INCLUDE:BOTTOM
	runat="server" />
