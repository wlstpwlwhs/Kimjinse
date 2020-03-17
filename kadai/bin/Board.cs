using System;
using System.Web;
using System.Data;

// Database ���̺귯�� �̿��� ���� ����
using Study;

namespace Study
{
	public class Board
	{
		Database DB;

		public Board()
		{
			DB = new Database();
		}


        // �Խñ� �ۼ�
        public void Write(	string category, string user_id, string user_name, 
							string title, string content, string upload_file)
		{
			string query = String.Format("INSERT INTO board (category, user_id, user_name, title, content, file_attach) VALUES('{0}', '{1}', '{2}', '{3}', '{4}', '{5}')",  
											category, user_id, user_name, title, content, upload_file);
			
			DB.ExecuteQuery(query);

		}

        // �Խ��� ����Ʈ
        public DataTable List(string category)
		{
			 return DB.ExecuteQueryDataTable("SELECT * FROM board WHERE category='" + category + "' ORDER BY board_id DESC");
		}

        // �Խ��� ����Ʈ(�˻�)
        public DataTable List(string category, string search_target, string search_word)
		{
			 return DB.ExecuteQueryDataTable(
				"SELECT * FROM board WHERE category='" + category + "' AND " + search_target + " LIKE '%" + search_word + "%' ORDER BY board_id DESC"
			 );
		}

        // �Խ��� ����Ʈ(�˻� �׽�Ʈ��)
        public void ListTest(string category, string search_target, string search_word)
		{
			 HttpContext.Current.Response.Write("SELECT * FROM board WHERE category='" + category + "' AND " + search_target + " LIKE '%" + search_word + "%' ORDER BY board_id DESC");
			 HttpContext.Current.Response.End();
		}



        // �Խñ� ��ȸ
        public DataTable Read(string category, int number)
		{
			string query = String.Format("SELECT * FROM board WHERE category='{0}' AND board_id={1}", category, number);
			return DB.ExecuteQueryDataTable(query);			
						
		}

        // ��� �ۼ�
        public void CommentWrite(int board_id, string user_id, string user_name, string content)
		{
			string query = String.Format("INSERT INTO board_comment(board_id, user_id, user_name, content) VALUES({0}, '{1}', '{2}', '{3}')",
								board_id, user_id, user_name, content);

			DB.ExecuteQuery(query);
		}

        // �ڸ�Ʈ ���
        public DataTable CommentList(int board_id)
		{
			string query = "SELECT * FROM board_comment WHERE board_id=" + board_id + " ORDER BY comment_id";
			return DB.ExecuteQueryDataTable(query);			
		}


        // �Խù��� ��ȸ
        public void ReadUp(string category, int number)
		{
			string query = String.Format("UPDATE board SET readnum=readnum+1 WHERE category='{0}' AND board_id={1}", category, number);
			DB.ExecuteQuery(query);			
		}

        // �Խù� ��õ
        public void Recommend(string category, int number)
		{
			string query = String.Format("UPDATE board SET recommend=recommend+1 WHERE category='{0}' AND board_id={1}", category, number);
			DB.ExecuteQuery(query);			
		}

        // �Խù� ����
        public void Modify(int number, string title, string content, string upload_file)
		{
			string query = String.Format("UPDATE board SET title='{0}', content='{1}', file_attach='{2}' WHERE board_id={3}", 
										title, content, upload_file, number);
			DB.ExecuteQuery(query);
		}

        // �Խù� ����
        public void Remove(string category, int number)
		{
            // 1. �ڸ�Ʈ ����
            string query = String.Format("DELETE FROM board_comment WHERE board_id={0}", number);
			DB.ExecuteQuery(query);

            // 2. �� ����
            query = String.Format("DELETE FROM board WHERE category='{0}' AND board_id={1}", category, number);
			DB.ExecuteQuery(query);

		}


	}
	
}

