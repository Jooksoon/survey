
<!-- 					 	 				-->
<!--  파일이름 : downloadEx.jsp				-->
<!-- 					 	 				-->
<!--  목적 : survey결과를 excel파일로 다운로드     	-->
<!-- 					 	 				-->

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.*"%>
<%@ page import="model.dbtest.*, DB.connection.*, java.sql.*"%>
<%
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");

// query 1 : get방식으로 넘어온 survey_id를 기반으로 form_id를 찾는다.
// sql문을 사용하기위해 미리 table, column등을 지정
String table = "contain";
String columns = "form_id";
String where = "survey_id=" + request.getParameter("survey_id");

DBConnection db = new DBConnection();
Connection conn = db.getConnection();

PreparedStatement pstmt = null;
ResultSet rs = null;

String sql = "SELECT " + columns + " FROM " + table + " WHERE " + where;
pstmt = conn.prepareStatement(sql);
rs = pstmt.executeQuery();

// query 2 : 위에서 찾은 form_id를 기반으로 'answer' table에서 유저의 답변을 가져옴
String where2 = null;

if (rs.next()) {

	// user_id, question_id 순으로 정렬 => 유저, 문항 번호 순으로 정렬
	where2 = "form_id=" + rs.getInt(1) + " ORDER BY user_id, question_id";
}

String table2 = "answer";
String columns2 = "user_id,form_id,question_id,option,essay"; // option은 객관식 답변, essay는 주관식 답변

if (where2 != null) {

	dbtest dbt = dbtest.getInstance();

	boolean result = dbt.XLS(table2, columns2, where2);

	//실제 파일을 생성해 줄 메소드 호출
	if (result == true) {

		//경로 및 파일명 설정
		String path = "C:\\";
		String name = table2 + ".xls";

		//다운로드 컨트롤 실행
		response.setContentType("application/x-msdownload");

		//헤더에 파일이름 세팅
		response.setHeader("Content-Disposition", "attachment;filename=" + name + ";");

		// 파일 생성
		File file = new File(path + name);

		byte b[] = new byte[(int) file.length()];

		if (file.length() > 0 && file.isFile()) { // 0byte이상이고, 해당 파일이 존재할 경우
	BufferedInputStream fin = new BufferedInputStream(new FileInputStream(file)); // 인풋객체생성
	BufferedOutputStream outs = new BufferedOutputStream(response.getOutputStream()); // 응답객체생성
	int read = 0;

	try {
		out.clear();
		out = pageContext.pushBody();

		while ((read = fin.read(b)) > 0) {
			outs.write(b, 0, read);
		}
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		if (outs != null)
			try {
				outs.close();
			} catch (Exception e) {
			}
		if (fin != null)
			try {
				fin.close();
			} catch (Exception e) {
			}
		new File(path + name).delete();
	}
		} else {
	System.out.println("File Not Found!!!");
		}
	} else {
		System.out.println("False");
	}
}
%>

