package model.dbtest;

import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.NamingException;

import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import DB.connection.*;

public class dbtest {
	private static dbtest instance = new dbtest();

	public static dbtest getInstance() {
		return instance;
	}

	private dbtest() {
	}

	public boolean XLS(String table, String columns, String where) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "";
		boolean result = true;
		String[] col = { "이름", "문항", "답변" };
		System.out.println(table);
		System.out.println(columns);
		try {
			HSSFWorkbook wb = new HSSFWorkbook();
			HSSFSheet sheet = wb.createSheet(table);
			HSSFRow row = null;

			conn = DBConnection.getConnection();
			//미리 만들어 놓은 db connection
			if (where == null || where == "" || where.equals("")) {
				sql = "SELECT " + columns + " FROM " + table;
			} else {
				sql = "SELECT " + columns + " FROM " + table + " WHERE " + where;
			}
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();

			
			while (rs.next()) {
				// for (int i = 0; i < col.length; i++) {
				if (rs.isFirst()) {
					row = sheet.createRow(0);
					row.createCell(0).setCellValue(getFormname(rs.getInt(2)));
					row = sheet.createRow(1);
					for (int i = 0; i < col.length; i++) {
						row.createCell(i).setCellValue(col[i]);
					}
				}
				row = sheet.createRow(rs.getRow()+1);
				// row.createCell(i).setCellValue(col[i].toString());
				row.createCell(0).setCellValue(getUsername(rs.getInt(1)));
				row.createCell(1).setCellValue(getQuestion(rs.getInt(3)));
				row.createCell(2).setCellValue(getOption(rs.getInt(4)));
				// }
				/*
				 * for (int i = 0; i < col.length; i++) {
				 * row.createCell(i).setCellValue(rs.getString(col[i].toString()));
				 * row.createCell(i).setCellValue(rs.getString(getUsername(rs.getInt(1))));
				 * row.createCell(i).setCellValue(rs.getString(getQuestion(rs.getInt(3))));
				 * row.createCell(i).setCellValue(rs.getString(getOption(rs.getInt(4)))); }
				 */

			}
			FileOutputStream fileOut = new FileOutputStream("C:\\" + table + ".xls");
			wb.write(fileOut);
			fileOut.close();

		} catch (IOException ex) {
			result = false;
			ex.printStackTrace();
		} catch (Exception ex) {
			result = false;
			ex.printStackTrace();
		} finally {
			System.out.println("메소드 끝");
			if (rs != null)
				try {
					rs.close();
				} catch (SQLException ex) {
				}
			if (pstmt != null)
				try {
					pstmt.close();
				} catch (SQLException ex) {
				}
			if (conn != null)
				try {
					conn.close();
				} catch (SQLException ex) {
				}
		}
		return result;
	}
	//user_id로 username 가져오기
	public String getUsername(int user_id) throws SQLException, ClassNotFoundException, NamingException {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs1 = null;
		String sql = "";
		String name = null;

		try {
			conn = DBConnection.getConnection();
			sql = "SELECT name FROM user WHERE user_id=" + user_id;
			pstmt = conn.prepareStatement(sql);
			rs1 = pstmt.executeQuery();
			if (rs1.next()) {
				name = rs1.getString(1);
			}
		} catch (

		SQLException ex) {
			ex.printStackTrace();
		} finally {
			System.out.println("메소드 끝");
			if (rs1 != null)
				try {
					rs1.close();
				} catch (SQLException ex) {
				}
			if (pstmt != null)
				try {
					pstmt.close();
				} catch (SQLException ex) {
				}
			if (conn != null)
				try {
					conn.close();
				} catch (SQLException ex) {
				}
		}

		return name;
	}
	//form_id로 formname 가져오기
	public String getFormname(int form_id) throws SQLException, ClassNotFoundException, NamingException {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs2 = null;
		String sql = "";
		String name = null;

		try {
			conn = DBConnection.getConnection();
			sql = "SELECT title FROM form WHERE form_id=" + form_id;
			pstmt = conn.prepareStatement(sql);
			rs2 = pstmt.executeQuery();
			if (rs2.next()) {
				name = rs2.getString(1);
			}
		} catch (

		SQLException ex) {
			ex.printStackTrace();
		} finally {
			System.out.println("메소드 끝");
			if (rs2 != null)
				try {
					rs2.close();
				} catch (SQLException ex) {
				}
			if (pstmt != null)
				try {
					pstmt.close();
				} catch (SQLException ex) {
				}
			if (conn != null)
				try {
					conn.close();
				} catch (SQLException ex) {
				}
		}

		return name;
	}
	//question_id로 question 가져오기
	public String getQuestion(int question_id) throws SQLException, ClassNotFoundException, NamingException {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs3 = null;
		String sql = "";
		String name = null;

		try {
			conn = DBConnection.getConnection();
			sql = "SELECT number FROM include WHERE question_id=" + question_id;
			pstmt = conn.prepareStatement(sql);
			rs3 = pstmt.executeQuery();
			if (rs3.next()) {
				name = rs3.getString(1);
			}
		} catch (

		SQLException ex) {
			ex.printStackTrace();
		} finally {
			System.out.println("메소드 끝");
			if (rs3 != null)
				try {
					rs3.close();
				} catch (SQLException ex) {
				}
			if (pstmt != null)
				try {
					pstmt.close();
				} catch (SQLException ex) {
				}
			if (conn != null)
				try {
					conn.close();
				} catch (SQLException ex) {
				}
		}

		return name;
	}
	//option_id로 option 가져오기
	public String getOption(int option) throws SQLException, ClassNotFoundException, NamingException {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs4 = null;
		String sql = "";
		String name = null;

		try {
			conn = DBConnection.getConnection();
			sql = "SELECT option_num FROM option_grouping WHERE option_id=" + option;
			pstmt = conn.prepareStatement(sql);
			rs4 = pstmt.executeQuery();

			if (rs4.next()) {
				name = rs4.getString(1);
			}
		} catch (

		SQLException ex) {
			ex.printStackTrace();
		} finally {
			System.out.println("메소드 끝");
			if (rs4 != null)
				try {
					rs4.close();
				} catch (SQLException ex) {
				}
			if (pstmt != null)
				try {
					pstmt.close();
				} catch (SQLException ex) {
				}
			if (conn != null)
				try {
					conn.close();
				} catch (SQLException ex) {
				}
		}

		return name;
	}
}