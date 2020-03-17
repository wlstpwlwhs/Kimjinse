<%@ Register TagPrefix="INCLUDE" TagName="TOP" src="top.ascx" %>
<%@ Register TagPrefix="INCLUDE" TagName="BOTTOM" src="bottom.ascx" %>
<%@ Import Namespace = "Study" %>

<script language="C#" runat="server">

// 수정기능? 처음에는 false.
bool IsEditMode = false;

// 기존의 파일은 없음
string AttachedFile = "";


	void Page_Load()
	{		
		// n 값이 넘어왔다면 
		if (!String.IsNullOrEmpty(Request["n"]))
		{
			// 수정기능 On.
			IsEditMode = true;
		

			if (!IsPostBack)
			{


				// 데이터 가져오기.
				string CATEGORY_ID = Request["c"];
				int BOARD_ID = Int32.Parse(Request["n"]);

				Board BOARD_LIB = new Board();			
				System.Data.DataTable dtModify = BOARD_LIB.Read(CATEGORY_ID, BOARD_ID);

				// 텍스트박스에 넣어주기
				txtTitle.Text = (string)dtModify.Rows[0]["title"];
				txtContent.Text = (string)dtModify.Rows[0]["content"];
			
				
				// 파일첨부체크. 첨부가 없으면 컬럼값은 공백("")이다.
				if ((string)dtModify.Rows[0]["file_attach"] != "")
				{
					// 파일이 있다면 
					// 기존 첨부파일내용을 표시.
					liUpload.Text = "添付ファイル : " + dtModify.Rows[0]["file_attach"];

					// 첨부된 파일의 파일명을 저장해줌
					AttachedFile = (string)dtModify.Rows[0]["file_attach"];
				}

		

				// 시각요소들 변경
				btnWrite.Text = "修正完了";

				// 기존 첨부 파일을 폼으로 전송되게 저장
				hdnFile.Value = AttachedFile;


			}


			
		}

	}


	void btnWrite_Click(object sender, EventArgs e)
	{

		string title = txtTitle.Text.Trim();
		string content = txtContent.Text.Trim();
		
		string message = "";		
		bool IsChecked = true;
				
		
		// 빈 값을 체크. || 는 OR 이다. ('~또는'라고 해석하자)
		// title이 빈 문자열이거나 content 가 빈 문자열이라면..
		if (title == "" || content.Equals(""))
		{
			IsChecked = false;
			message = "タイトルや内容は空欄にすることができません。";
		}


		// 앞에서 패스하였다면.. 이제 업로드 체크 후 저장
		if (IsChecked)
		{
			// 업로드 파일명
			string upload_file = "";

			// 파일업로드는 옵션이다. 있으면 처리, 없으면 그냥 패스.
			// 파일업로드 컨트롤 ID는 'upload'
			// 파일이 있으면 true
			if (upload.HasFile)
			{
				// 업로드 파일 경로
				string UPLOAD_PATH = Server.MapPath("/upload/");
				
				// 파일명을 변수에 저장(DB에 저장하기 위해)
				upload_file = upload.FileName;
				upload.SaveAs(UPLOAD_PATH + upload_file);
			}

			// --------- [수정모드 추가] ----------------------------
			// 첨부파일이 없다고 해도 기존에 파일이 있다면 기존 파일명으로 저장.
			else
			{
				/* ------------------------------------ 값 유지가 안됨
				if (AttachedFile != "")
					upload_file = AttachedFile;
				*/

				// ------------------------------------ 수정된 소스
				if (hdnFile.Value != "")
					upload_file = hdnFile.Value;


			}
			// --------- [수정모드 추가 끝] -------------------------

	
			// 실제 글쓴 자료 저장하기
			// board 테이블 : category, user_id, user_name, "title", "content", "file_attach"
			// ("" 필드는 사용자 입력값)

			string category = Request.QueryString["c"]; // 카테고리는 GET으로 유지되고 있다.
			string user_id = (string)Session["login_id"]; // 로그인 세션 변수 id 
			string user_name = (string)Session["login_nick"]; // 로그인 세션 변수 nick

			// 최종 게시판 라이브러리는 데이터 저장.
			Board BOARD_LIB = new Board();


			// --------- [수정모드 추가] ----------------------------
			if (IsEditMode)
			{
				// 수정기능
				BOARD_LIB.Modify(Int32.Parse(Request["n"]), title, content, upload_file);

				// 이후 글보기로 바로 이동
				Response.Redirect("board_view.aspx?c=" + Request["c"] + "&n=" + Request["n"]);				
			}
			else
			{
			
				// 새글쓰기
				BOARD_LIB.Write(category, user_id, user_name, title, content, upload_file);

				// 이후 리스트로 바로 이동 ('c' 값은 계속 유지)
				Response.Redirect("board_list.aspx?c=" + Request["c"]);
			}
			// --------- [수정모드 추가 끝] -------------------------



		}
		else
		{
			// IsChecked 가 false 이면 오류. 메시지만 뿌리자.
			lblError.Text = message;
		}

		

		
	}

</script>



<INCLUDE:TOP
	runat="server" />



<!--------------------------- 여기서부터 내용 ------>
<div id="content">

<form runat="server">
<input type="hidden" id="hdnFile" runat="server" />

<center>


<table width="600">

	<tr>
		<td width="100" align="center">
			タイトル
		</td>

		<td>
			<ASP:TextBox id="txtTitle" width="450" runat="server" />
		</td>

	</tr>	

	<tr>
		<td width="100" align="center">
			内容
		</td>

		<td>
			<ASP:TextBox 
				id="txtContent" 
				textmode="multiline"
				width="450" height="300" runat="server" />
		</td>

	</tr>	

	<tr>
		<td width="100" align="center">
			添付ファイル
		</td>

		<td>
			<ASP:Literal id="liUpload" runat="server" />
			<ASP:FileUpload id="upload" width="450" runat="server" />
		</td>

	</tr>	

	<tr height="60">
		<td colspan="2" align="center">

			<ASP:Button id="btnWrite" OnClick="btnWrite_Click" text="글쓰기" width="100" runat="server" />

		</td>

	</tr>	


</table>


	<ASP:Label id="lblError" runat="server" style="color:red;" />



</center>


</form>

</div>
<!-- 내용끝 ---------------------------------------->



<INCLUDE:BOTTOM
	runat="server" />
