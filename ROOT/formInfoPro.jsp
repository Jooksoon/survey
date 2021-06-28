
<!-- 					 								-->
<!--  파일이름 : formInfoPro.jsp							-->
<!-- 					 	 							-->
<!--  목적 : formDAO를 이용하여 설문지를 database에 저장     	 	-->
<!-- 					 	 							-->


<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" import="model.form.* , model.encrypt.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>form-info</title>
</head>
<body>
	<%
	request.setCharacterEncoding("utf-8");

	FormDAO dao = FormDAO.getInstance();
	Form form = null;						
	String title = null;					// 설문지 제목
	String description = null;				// 설문지 설명
	int form_id = 0;						
	String encryptform_id=null;				// 암호화 된 form_id
	
	title = request.getParameter("title");
	description = request.getParameter("description");
	
	form = new Form(title, description);
	form_id = dao.insertForm(form);
	
	encryptform_id = LocalEncrypter.returnEncryptCode(Integer.toString(form_id));	// form_id 암호화
	%>
	
	<script>
	var parent = window.opener;
	parent.location.href = "makeForm.jsp?f=" + "<%=encryptform_id%>";
	window.close();
	</script>
	
</body>
</html>