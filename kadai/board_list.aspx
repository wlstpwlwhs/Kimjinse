<%@ Page Trace="true" %>
<%@ Register TagPrefix="INCLUDE" TagName="TOP" src="top.ascx" %>
<%@ Register TagPrefix="INCLUDE" TagName="BOTTOM" src="bottom.ascx" %>
<%@ Import Namespace = "Study" %>
<%@ Import Namespace = "System.Data" %>
<style>
    #container{
	height:1000px;
}
#content{
	
	height:1000px;
}

#container span{
	color:white;
}
#b{
	display:none;
}

</style>
<script type="text/javascript">
    


$(window).on("scroll", function() {
	var scrollHeight = $(document).height();
	var scrollPosition = $(window).height() + $(window).scrollTop();		

	$("#scrollHeight").text(scrollHeight);
	$("#scrollPosition").text(scrollPosition);
	$("#bottom").text(scrollHeight - scrollPosition);

	if (scrollPosition > scrollHeight - 500) {			
		//todo
		$("body").append('<div id="content"></div>');
	}
});


</script>

<script language="C#" runat="server">


string CATEGORY_ID;

int TOTAL_COUNT = 0;

// 검색관련변수
string STYPE, SVALUE;
// 검색중?
bool IsSearch = false;


	void Page_Load()
	{

		CATEGORY_ID = Request["c"];

		STYPE = Request["stype"];
		SVALUE = Request["svalue"];

		// --[검색추가]-- 검색어가 있는지 체크
		if (!String.IsNullOrEmpty(STYPE) && !String.IsNullOrEmpty(SVALUE))
			IsSearch = true;
		// --------------


		// 사용: Board.List(string category) 
		Board BOARD_LIB = new Board();

		// 리턴: DataTable	
		DataTable dtList = null;
		
		// --[검색추가]-- 검색중이라면 검색 결과 메서드 호출
		if (IsSearch)
		{
			dtList = BOARD_LIB.List(CATEGORY_ID, STYPE, SVALUE);

			// 검색취소 버튼 보여줌
			btnCancel.Visible = true;

			// 컨트롤 매치
			lstType.SelectedValue = STYPE;
			txtSearch.Text = SVALUE;
		}
		else
		{
			dtList = BOARD_LIB.List(CATEGORY_ID);
		}
		// -------------- [검색 추가 소스 끝]


		TOTAL_COUNT = dtList.Rows.Count;

		rptList.DataSource = dtList;
		rptList.DataBind();

	
	}



 
	string ToCustomTime(object datetime)
	{
		if (datetime != null)
		{
			// DateTime 으로 변환가능
			DateTime d = (DateTime)datetime;
			
			// DateTime.Subtract(DateTime 뺄시간)
			// 현재시간에서 작성일자를 빼줘서 TimeSpan 으로 받음
			TimeSpan ts = DateTime.Now.Subtract(d);

			// 뺀시간이 하루가 되지 않았다면(시간단위)
			if (ts.Days == 0)
			{
				// 하루이내에 1시간 이내라면(분단위)
				if (ts.Hours == 0)
					return String.Format("{0}分前", ts.Minutes);
				else
					return String.Format("{0}時間前", ts.Hours);
				
			}
			// 하루지나면 그냥 날짜로 출력
			else
				return ((DateTime)datetime).ToString("yyyy-MM-dd");

		}
		// null 이면 오류
		else
		{
			return "(Error)";
		}
	}


	// Repeater 이벤트
	void rptList_Bound(object sender, RepeaterItemEventArgs e)
	{
		int VIRTUAL_NUM = TOTAL_COUNT - e.Item.ItemIndex;		
		((Label)e.Item.FindControl("lblNum")).Text = VIRTUAL_NUM.ToString();
	}

	// 검색버튼
	void btnSearch_Click(object sender, EventArgs e)
	{
		bool IsChecked = true;
		
		// 검색어가 입력되었는지 체크하는 과정은 생략
		// 뭔가가 잘못되었다면 IsChecked 값을 false 로 변경
		if (IsChecked)
		{
			Response.Redirect(
				
				String.Format("board_list.aspx?c={0}&stype={1}&svalue={2}", 
								CATEGORY_ID, 
								lstType.SelectedValue, 
								txtSearch.Text.Trim()
							)
				);
		}
		// 오류출력
		else
		{
			// 생략
		}

		
	}


	// 검색취소버튼
	void btnCancel_Click(object sender, EventArgs e)
	{
		Response.Redirect("board_list.aspx?c=" + CATEGORY_ID);
	}

	
	string CheckSearch(string src)
	{
		// 검색모드이고, 검색 대상이 제목일 때
		if (IsSearch && STYPE.Equals("title"))
		{
			// 바꿔서 리턴
			return src.Replace(SVALUE, "<b>" + SVALUE + "</b>");
		}
		// 아니라면 그냥 원본을 리턴
		else
			return src;
	}


</script>


<INCLUDE:TOP
	runat="server" />



<!--------------------------- 여기서부터 내용 ------>
<div id="container">
	
</div>
<div id="content">


<br><br>

<center>

<h2>掲示板リスト</h2>
<hr width="650" color="green">


<table width="600">

<tr align="center" bgcolor="#abcdef">
	<td width="30">123</td>

	<td>タイトル</td>

	<td width="80">作成者</td>

	<td width="80">作成日時</td>

	<td width="35">照会</td>

	<td width="35">推薦</td>
	
</tr>


<ASP:Repeater id="rptList" runat="server" OnItemDataBound="rptList_Bound">
<ItemTemplate>

<tr align="center">
	<td width="30"><ASP:Label id="lblNum" runat="server" /></td>

	<td align="left">
		<a href="board_view.aspx?c=<%# CATEGORY_ID %>&n=<%# Eval("board_id") %>&stype=<%# STYPE %>&svalue=<%# SVALUE %>">
			<%# CheckSearch((string)Eval("title")) %>
		</a>
	</td>

	<td width="80"><%# Eval("user_name") %></td>

	<td width="80"><%# ToCustomTime(Eval("regdate")) %></td>

	<td width="35"><%# Eval("readnum") %></td>

	<td width="35"><%# Eval("recommend") %></td>
</tr>

</ItemTemplate>
</ASP:Repeater>


</table>


<br><br>

<center>

<form id="frm" runat="server">
	

<ASP:DropDownList id="lstType" runat="server">
	<ASP:ListItem value="title" text="タイトル" />
	<ASP:ListItem value="title" text="内容" />
</ASP:DropDownList>

<ASP:TextBox id="txtSearch" runat="server" />
<ASP:Button id="btnSearch" text="検索開始" runat="server" onclick="btnSearch_Click" />
<ASP:Button id="btnCancel" text="検索取り消し" visible="false" runat="server" onclick="btnCancel_Click" />

</form>

</center>


<br><br>

<a href="board_write.aspx?c=<%= CATEGORY_ID %>">掲示文作成</a>



</center>

</div>
<!-- 내용끝 ---------------------------------------->



<INCLUDE:BOTTOM
	runat="server" />

