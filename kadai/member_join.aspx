<%@ Register TagPrefix="INCLUDE" TagName="TOP" src="top.ascx" %>
<%@ Register TagPrefix="INCLUDE" TagName="BOTTOM" src="bottom.ascx" %>
<%@ Import Namespace = "Study" %>

<script language="C#" runat="server">



	void btnCheck_Click(object sender, EventArgs e)
	{
		string id = txtID.Text;


		// 일단 사용할 수 있는 ID라고 가정
		bool bCheck = true;
		// 출력할 오류메시지 문자열
		string check_message = "";

		
		// 1. 빈ID : 문자열의 앞,뒤 공백을제거한 byte가 0이면
		if (id.Trim().Length == 0)
		{
			bCheck = false;
			check_message = "IDを入力してください。";
		}
		// 2. 영문자,숫자만 가능
		else if ( !CheckStep2(id) )
		{
			bCheck = false;
			check_message = "スペースなしで英文/数字のみ可能です。";

		}
		// 3. 4~12자리만
		else if ( id.Length < 4 || id.Length > 12  )
		{
			bCheck = false;
			check_message = "4~12文字で決めてください。";
		}

		
		// 모두 통과하였으면
		if (bCheck)
		{
			// 최종 DB체크
			Database DB = new Database();

			// member 테이블에 user_id가 "id"변수인 자료가 총 몇개인가?
			string query = "SELECT COUNT(*) FROM member WHERE user_id='" + id + "'";

			// 쿼리의 결과는 1개 뿐이고, int 형이다.
			int result_count = (int)DB.ExecuteQueryResult(query);

			// 자료가 존재함 (존재한다면 1개밖에 있을 수 밖에 없다) - 사용불가
			if (result_count == 1)
			{
				lblCheckResult.ForeColor = System.Drawing.Color.Red;
				check_message = "既に存在するIDです。";
				hdnCheckID.Value = "";
			}
			// 자료가 없음 - 사용가능
			else
			{
				lblCheckResult.ForeColor = System.Drawing.Color.Blue;
				check_message = "使用できるIDです。";
				hdnCheckID.Value = "1";
			}
		}
		// 통과하지 못헀다면
		else
		{
			lblCheckResult.ForeColor = System.Drawing.Color.Red;
			hdnCheckID.Value = "";
		}
			
		// 메시지를 뿌려준다.
		lblCheckResult.Text = check_message;
	}


	bool CheckStep2(string text)
	{
		int k = 0;

		for(int i=0;i<text.Length;i++)
		{		
			char c = text[i];

			//영어체크
			if( ( 0x61 <= c && c <= 0x7A ) || ( 0x41 <= c && c <= 0x5A ) )
				k++;
			//숫자체크
			else if( 0x30 <= c && c <= 0x39 )
                k++;
		}
		if (k != text.Length)
			return false;
		else
			return true;		
	}



	void btnJoin_Click(object sender, EventArgs e)
	{
		string passwd = txtPass.Text.Trim();
		string nickname = txtNick.Text.Trim();

		// 역시 통과했다고 미리 가정.
		bool bChecked = true;
		string check_message = "";

		// 메서드를 이용한 값비교. '==' 연산자와 동일한 기능이다.
		// ID중복체크 확인값이 없다면
		if (!hdnCheckID.Value.Equals("1"))
		{
			bChecked = false;
			check_message = "IDの重複確認をしてください。";
		}
		// 비밀번호 공백체크
		else if (passwd.Length == 0)
		{
			bChecked = false;
			check_message = "パスワードを入力してください。";
		}
		// 닉네임 공백체크
		else if (nickname.Length == 0)
		{
			bChecked = false;
			check_message = "ニックネームを入力してください。";
		}

		// 모두 통과됨
		if (bChecked)
		{

			// DB에 INSERT로 저장
			Database DB = new Database();
			string query = "INSERT INTO member(user_id, user_password, nickname) VALUES('" + txtID.Text + "', '" + passwd  + "', '" + nickname  + "')";
			DB.ExecuteQuery(query);

			// 로그인 완료 페이지로 이동 
			Response.Redirect("member_join_finish.aspx");
			

		}
		// 오류발생
		else
		{
			lblJoinResult.ForeColor = System.Drawing.Color.Red;
			lblJoinResult.Text = check_message;
		}
		

	}



</script>



<INCLUDE:TOP
	runat="server" />



<!--------------------------- 여기서부터 내용 ------>
<div id="content" runat="server">


<b>ホームページの会員登録ページです。</b>
<br>
<br>
個人情報保護のために入力される情報は最小限に制限されています。
<br> 
次の項目を正確に入力してください。
<br>
<br>

<form runat="server">
<ASP:HiddenField id="hdnCheckID" runat="server" />

	ID
	<ASP:TextBox id="txtID" runat="server" />
	<ASP:Button id="btnCheck" runat="server" text="重複チェック" OnClick="btnCheck_Click" /> 
	<ASP:Label id="lblCheckResult" runat="server" />
	
	<br>
	
	PW
	<ASP:TextBox id="txtPass" textmode="password" runat="server" />

	<br>
	
	ニックネーム
	<ASP:TextBox id="txtNick" runat="server" />

	<br>

	<ASP:Button id="btnJoin" runat="server" text="会員登録" OnClick="btnJoin_Click" />

	<br>
	<ASP:Label id="lblJoinResult" runat="server" />



</form>


</div>
<!-- 내용끝 ---------------------------------------->



<INCLUDE:BOTTOM
	runat="server" />
