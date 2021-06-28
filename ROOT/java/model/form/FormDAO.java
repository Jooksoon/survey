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

	// �̱��� ����
	private FormDAO() {
	}

	public static FormDAO getInstance() {
		if (instance == null)
			instance = new FormDAO();
	return instance;
	}
	
	
	/*								*/
	/*	�������� database�� �����ϴ� �Լ�	*/
	/*								*/
	/*	Parameters					*/
	/*	form : ������ ����� Form ��ü	*/
	/*								*/
	/*	return	form_id				*/
	/*								*/
	public int insertForm(Form form) throws SQLException {
		Connection conn = null;
		PreparedStatement pstmt = null;

		try {
			// Ŀ�ؼ��� �����´�.
			conn = DBConnection.getConnection();

			// �ڵ� Ŀ���� false�� �Ѵ�.
			conn.setAutoCommit(false);
			
			StringBuffer sql = new StringBuffer();
			sql.append("insert into form(title, description) values");
			sql.append("(?, ?)");
			
			// insert���� form_id�� �����ϱ� ���� Column����
			String generatedColumns[] = { "form_id" };
			
			pstmt = conn.prepareStatement(sql.toString(), generatedColumns);
			pstmt.setString(1, form.getTitle());
			pstmt.setString(2, form.getDescription());
			
				
			pstmt.executeUpdate();
			
			conn.commit();
			
			// form_id�� ���Ϲ���
			try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
	            if (generatedKeys.next()) {
	                return generatedKeys.getInt(1);
	            }
	            else {
	                throw new SQLException("Creating user failed, no ID obtained.");
	            }
	        }
		} catch (ClassNotFoundException | NamingException | SQLException sqle) {
			// ������ �ѹ�
			conn.rollback();

			throw new RuntimeException(sqle.getMessage());
		} finally {
			// Connection, PreparedStatement�� �ݴ´�.
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
	/*	include�� ����				*/
	/*								*/
	/*	Parameters					*/
	/*	form_id : form_id			*/
	/*	question_id : question_id	*/
	/*	number : ���� ��ȣ				*/
	/*								*/
	public void include(int form_id, int question_id, int number) throws SQLException {
		Connection conn = null;
		PreparedStatement pstmt = null;

		try {
			// Ŀ�ؼ��� �����´�.
			conn = DBConnection.getConnection();

			// �ڵ� Ŀ���� false�� �Ѵ�.
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
			// ������ �ѹ�
			conn.rollback();

			throw new RuntimeException(sqle.getMessage());
		} finally {
			// Connection, PreparedStatement�� �ݴ´�.
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
	/*	�̹� ����� form�� num_of_question ���� ����	*/
	/*											*/
	/*	Parameters								*/
	/*	form_id : form_id						*/
	/*	num_question_id : ������ ���Ե� ���� ��		*/
	/*											*/
	public void alterNumber(int form_id, int num_of_question) throws SQLException {
		Connection conn = null;
		PreparedStatement pstmt = null;

		try {
			// Ŀ�ؼ��� �����´�.
			conn = DBConnection.getConnection();

			// �ڵ� Ŀ���� false�� �Ѵ�.
			conn.setAutoCommit(false);
			//UPDATE ���̺�� SET �ʵ��='�����Ұ�' WHERE �ʵ��=�ش簪;
			StringBuffer sql = new StringBuffer();
			sql.append("update form set num_of_question=? where form.form_id = ?");
			
			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setInt(1, num_of_question);
			pstmt.setInt(2, form_id);
				
			pstmt.executeUpdate();
			
			conn.commit();
		} catch (ClassNotFoundException | NamingException | SQLException sqle) {
			// ������ �ѹ�
			conn.rollback();

			throw new RuntimeException(sqle.getMessage());
		} finally {
			// Connection, PreparedStatement�� �ݴ´�.
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