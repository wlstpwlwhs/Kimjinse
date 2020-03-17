<%@ Register TagPrefix="INCLUDE" TagName="TOP" src="top.ascx" %>
<%@ Register TagPrefix="INCLUDE" TagName="BOTTOM" src="bottom.ascx" %>
<%@ Import Namespace = "Study" %>
<%@ Import Namespace = "System.Data" %>

<script language="C#" runat="server">
string CATEGORY_ID;
int BOARD_ID;

	void Page_Load()
	{
		// -------- 로그인 체크
		// 로그인이 안되어있으면 쓰기영역 없애기
		if (Session["login_id"] == null)
			tblCommentWrite.Visible = false;
		// 로그인 되었으면 작성자 Label 값 넣기
		else
			lblWriter.Text = (string)Session["login_nick"];



		CATEGORY_ID = Request["c"];
		// 게시물 번호는 int로
		BOARD_ID = Int32.Parse(Request["n"]);
		
		// 라이브러리 인스턴스 화
		Board BOARD_LIB = new Board();

		// 게시물 내용
		DataTable dtView = BOARD_LIB.Read(CATEGORY_ID, BOARD_ID);

		// 단순화 시키기 위해 첫번째 행을 DataRow 로 넣어줌(넘어온 자료도 1개)
		DataRow row = dtView.Rows[0];


		// ------------ 여기서부터 lblXXXX 컨트롤에 각각 넣어주기 (Text 속성)
		// 중요: row[".."] 는 object 형

		lblTitle.Text = (string)row["title"];
		lblName.Text = String.Format("{0} ({1})", row["user_name"], row["regdate"]);
		lblRead.Text = row["readnum"].ToString();
		lblRecommend.Text = row["recommend"].ToString();
		lblContent.Text = (string)row["content"];

		// 첨부파일은 없을수도 있으므로 조건문 if() 로..

		// 업로드된 파일이 있으면
		if ((string)row["file_attach"] != "")
			lblFile.Text = String.Format("<a href='upload/{0}'>{1}</a>", row["file_attach"], row["file_attach"]);
		// 없으면
		else
			lblFile.Text = "なし";

		// ------------ 게시물 끝



		// 처음 열었을 때. 
		if (!IsPostBack)
		{
			CommentList();
			BOARD_LIB.ReadUp(CATEGORY_ID, BOARD_ID);

			
			// 수정,삭제기능 활성화 체크
			if (!String.IsNullOrEmpty((string)Session["login_id"]))
			{
				if ((string)Session["login_id"] == (string)row["user_id"])
				{
					trModifyDelete.Visible = true;
				}
			}
		}



	}


	// 댓글쓰기버튼
	void btnCommentWrite_Click(object source, EventArgs e)
	{
		string MESSAGE = "";
		string comment = txtComment.Text.Trim();


		// 댓글내용 공백?
		if (comment.Length == 0)
		{
			// 오류
			MESSAGE = "[!] <font color=red>コメント内容を入力してください。</font>";
		}
		else
		{
			// 성공
			Board BOARD_LIB = new Board();
			BOARD_LIB.CommentWrite(BOARD_ID, (string)Session["login_id"], (string)Session["login_nick"], comment);

			MESSAGE = "[!] <font color=blue>コメントが登録されました。</font>";

			// 상태관리(ViewState) 로 인해 입력 내용이 남아있게 되므로 없애줌
			txtComment.Text = "";

			// 쓰기버튼을 누르면 Page_Load() 에서 댓글이 뿌려져있지 않으므로 여기서 뿌려줌
			CommentList();
									
		}

		// 결과메시지 출력
		tblCommentWrite.Rows[0].Cells[1].Controls.Add(new LiteralControl(MESSAGE));
	}

	void CommentList()
	{
		Board BOARD_LIB = new Board();

		// ------------ 댓글리스트 
		// 다음처럼 굳이 DataTable 을 따로 선언하지 않아도 된다.
		rptComment.DataSource = BOARD_LIB.CommentList(BOARD_ID);
		rptComment.DataBind();

		// 댓글 총 갯수(BOARD_LIB.CommentList 메서드가 리턴한 DataTable 의 Rows.Count)
		// => 따로 생성하지 않았으므로 다음처럼 형변환 후 가져옴.
		// ((DataTable)rptComment.DataSource).Rows.Count
		// Label (<span>) 태그에 style 속성의 값을 color:blue 로 줌.
		lblCommentCount.Attributes.Add("style", "color:blue");
		lblCommentCount.Text = "<b>前部 " + ((DataTable)rptComment.DataSource).Rows.Count + " のコメントがあります。</b>";

	}


	// 추천버튼
	void btnRecommend_Click(object sender, EventArgs e)
	{
		Board BOARD_LIB = new Board();
		BOARD_LIB.Recommend(CATEGORY_ID, BOARD_ID);

		btnRecommend.Enabled = false;
		btnRecommend.Text = "既に推薦しました。";


		// 중복추천기능은 생략.
	}


	// 수정버튼
	void btnModify_Click(object sender, EventArgs e)
	{
		Response.Redirect(String.Format("board_write.aspx?c={0}&n={1}", CATEGORY_ID, BOARD_ID));
	}

	// 삭제버튼
	void btnDelete_Click(object sender, EventArgs e)
	{
		Board BOARD_LIB = new Board();
		BOARD_LIB.Remove(CATEGORY_ID, BOARD_ID);
		
		Response.Redirect(String.Format("board_list.aspx?c={0}", CATEGORY_ID));

	}




</script>




<INCLUDE:TOP
	runat="server" />



<!--------------------------- 여기서부터 내용 ------>
<div id="content">

<form runat="server">


<br><br>
<center>

<b><ASP:Label id="lblTitle" runat="server" /></b>

<br><br>


<!--------------- 게시물 -------------------->
<table width="600">

	<tr bgcolor="#abcdef">
		<td width="400">
			作成 : <ASP:Label id="lblName" runat="server" />
		</td>
		<td width="100">
			照会数 <ASP:Label id="lblRead" runat="server" />
		</td>
		<td width="100">
			推薦数 <ASP:Label id="lblRecommend" runat="server" />
		</td>
	</tr>

	<tr>
		<td colspan="3">

			<br>
				
				<ASP:Label id="lblContent" runat="server" />

			<br><br>

			<center>
				<ASP:Button id="btnRecommend" text="推薦する" onclick="btnRecommend_Click" runat="server" />
			</center>

		</td>
	</tr>

	<tr id="trModifyDelete" visible="false" runat="server">
		<td colspan="3" align="right">			
			<ASP:Button id="btnModify" text="修整" onclick="btnModify_Click" runat="server" />
			<ASP:Button id="btnDelete" text="削除" onclick="btnDelete_Click" runat="server" />
		</td>
	</tr>

	


	<tr bgcolor="#aabbcc">
		<td colspan="3">
			添付ファイル : <ASP:Label id="lblFile" runat="server" />
		</td>
	</tr>

</table>



<!--------------- 댓글쓰기 -------------------->
<table width="600" id="tblCommentWrite" runat="server">
	<tr>
		<td width="150">
			<ASP:Label id="lblWriter" runat="server" />
		</td>
		<td width="450">
			<ASP:TextBox id="txtComment" textmode="multiline" width="450" height="80" runat="server" />
			<ASP:Button
				id="btnCommentWrite"
				text="コメントを書く"
				onclick="btnCommentWrite_Click"
				runat="server" />			
			
		</td>
	</tr>

</table>


<!--------------- 댓글목록 -------------------->
<table width="600">

	<tr>
		<td colspan="2" align="center">
			<ASP:Label id="lblCommentCount" runat="server" />
		</td>
	</tr>


	<ASP:Repeater id="rptComment" runat="server">

	<ItemTemplate>

	<tr height="80">
		<td width="150" bgcolor="#eeeeee">
			<%# Eval("user_name") %>
			<br>
			<font size="1"><%# Eval("regdate") %></font>

		</td>

		<td width="450">			
			<%# Eval("content") %>
		</td>
	</tr>


	</ItemTemplate>


	</ASP:Repeater>

</table>


<br><br>

<a href="board_list.aspx?c=<%= CATEGORY_ID %>&stype=<%= Request["stype"] %>&svalue=<%= Request["svalue"] %>">リスト</a>


</center>


</form>


</div>
<!-- 내용끝 ---------------------------------------->



<INCLUDE:BOTTOM
	runat="server" />
