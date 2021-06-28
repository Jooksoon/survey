package model.form;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.NamingException;

import DB.connection.DBConnection;
import model.form.Form;

public class FormDAO {
	private static FormDAO instance;

	// 싱글톤 패턴
	private FormDAO() {
	}

	public static FormDAO getInstance() {
		if (instance == null)
			instance = new FormDAO();
	return instance;
	}
	
	
	/*								*/
	/*	설문지를 database에 저장하는 함수	*/
	/*								*/
	/*	Parameters					*/
	/*	form : 정보가 저장된 Form 객체	*/
	/*								*/
	/*	return	form_id				*/
	/*								*/
	public int insertForm(Form form) throws SQLException {
		Connection conn = null;
		PreparedStatement pstmt = null;

		try {
			// 커넥션을 가져온다.
			conn = DBConnection.getConnection();

			// 자동 커밋을 false로 한다.
			conn.setAutoCommit(false);
			
			StringBuffer sql = new StringBuffer();
			sql.append("insert into form(title, description) values");
			sql.append("(?, ?)");
			
			// insert이후 form_id를 리턴하기 위해 Column지정
			String generatedColumns[] = { "form_id" };
			
			pstmt = conn.prepareStatement(sql.toString(), generatedColumns);
			pstmt.setString(1, form.getTitle());
			pstmt.setString(2, form.getDescription());
			
				
			pstmt.executeUpdate();
			
			conn.commit();
			
			// form_id를 리턴받음
			try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
	            if (generatedKeys.next()) {
	                return generatedKeys.getInt(1);
	            }
	            else {
	                throw new SQLException("Creating user failed, no ID obtained.");
	            }
	        }
		} catch (ClassNotFoundException | NamingException | SQLException sqle) {
			// 오류시 롤백
			conn.rollback();

			throw new RuntimeException(sqle.getMessage());
		} finally {
			// Connection, PreparedStatement를 닫는다.
			try {
				if (pstmt != null) {
					pstmt.close();
					pstmt = null;
				}
				if (conn != null) {
					conn.close();
					conn = null;
				}
			} catch (Exception e) {
				throw new RuntimeException(e.getMessage());
			}
		} // end try~catch
	} // end insertForm()
	
	
	/*								*/
	/*	include에 저장				*/
	/*								*/
	/*	Parameters					*/
	/*	form_id : form_id			*/
	/*	question_id : question_id	*/
	/*	number : 문항 번호				*/
	/*								*/
	public void include(int form_id, int question_id, int number) throws SQLException {
		Connection conn = null;
		PreparedStatement pstmt = null;

		try {
			// 커넥션을 가져온다.
			conn = DBConnection.getConnection();

			// 자동 커밋을 false로 한다.
			conn.setAutoCommit(false);
			
			StringBuffer sql = new StringBuffer();
			sql.append("insert into include values");
			sql.append("(?, ?, ?)");
			
			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setInt(1, form_id);
			pstmt.setInt(2, question_id);
			pstmt.setInt(3, number);
				
			pstmt.executeUpdate();
			
			conn.commit();
		} catch (ClassNotFoundException | NamingException | SQLException sqle) {
			// 오류시 롤백
			conn.rollback();

			throw new RuntimeException(sqle.getMessage());
		} finally {
			// Connection, PreparedStatement를 닫는다.
			try {
				if (pstmt != null) {
					pstmt.close();
					pstmt = null;
				}
				if (conn != null) {
					conn.close();
					conn = null;
				}
			} catch (Exception e) {
				throw new RuntimeException(e.getMessage());
			}
		} // end try~catch
	} // end include()
	
	
	/*											*/
	/*	이미 저장된 form의 num_of_question 값을 변경	*/
	/*											*/
	/*	Parameters								*/
	/*	form_id : form_id						*/
	/*	num_question_id : 설문에 포함된 질문 수		*/
	/*											*/
	public void alterNumber(int form_id, int num_of_question) throws SQLException {
		Connection conn = null;
		PreparedStatement pstmt = null;

		try {
			// 커넥션을 가져온다.
			conn = DBConnection.getConnection();

			// 자동 커밋을 false로 한다.
			conn.setAutoCommit(false);
			//UPDATE 테이블명 SET 필드명='변경할값' WHERE 필드명=해당값;
			StringBuffer sql = new StringBuffer();
			sql.append("update form set num_of_question=? where form.form_id = ?");
			
			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setInt(1, num_of_question);
			pstmt.setInt(2, form_id);
				
			pstmt.executeUpdate();
			
			conn.commit();
		} catch (ClassNotFoundException | NamingException | SQLException sqle) {
			// 오류시 롤백
			conn.rollback();

			throw new RuntimeException(sqle.getMessage());
		} finally {
			// Connection, PreparedStatement를 닫는다.
			try {
				if (pstmt != null) {
					pstmt.close();
					pstmt = null;
				}
				if (conn != null) {
					conn.close();
					conn = null;
				}
			} catch (Exception e) {
				throw new RuntimeException(e.getMessage());
			}
		} // end try~catch
	} // end include()
}