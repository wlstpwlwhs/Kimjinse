<script language="C#" runat="server">


	void Page_Load()
	{
		Session["login_id"] = "test";
		Session["login_nick"] = "테스터";
		


		if (Session["login_id"] != null)
		{
			login_start.Visible = false;
			login_done.Visible = true; 
			lblNickName.Text = (string)Session["login_nick"];
		}

	}

</script>




<html>
<head>
<title>掲示板作成</title>

<link rel="stylesheet" type="text/css" href="/default.css">


</head>
<body>


<!-- 윗쪽항목 시작 -->
<div id="top">
	
	歓迎します!

</div>
<!-- 윗쪽항목 끝 -->





<!-- 주메뉴 시작 -->
<div id="main_menu">


	<a href="/">メイン画面</a>
	|
	<a href="member_join.aspx">会員登録</a>
	| 
	<a href="board_list.aspx?c=test">掲示板</a>
	|

	|


	<hr color="slategray">

</div>
<!-- 주메뉴 끝 -->





<!-- 로그인 폼 시작 -->
<div id="login_start" runat="server" style="background-color:#eeddff">



<form action="login_proc.aspx" method="post" style="display:inline; margin:0">

	<font color="blue">[ログイン]</font>
	ID : <input type="text" id="user_id" name="user_id" size="10">
	PW : <input type="password" id="user_pw" name="user_pw" size="10">
	<input type="submit" value="ログイン">


</form>



</div>
<!-- 로그인 끝 -->


<!-- 로그인 된 화면 -->
<div id="login_done" runat="server" style="background-color:#eeddff" visible="false">

<form action="logout.aspx" style="display:inline; margin:0">

	いらっしゃい！ <ASP:Label id="lblNickName" runat="server" /> 様、お会いできて嬉しいです。
	<input type="submit" value="ログアウト">

</form>

</div>
<!-- 로그인 된 화면 끝 -->


