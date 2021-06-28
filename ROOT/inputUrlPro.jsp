
<!-- 					 	 				-->
<!--  파일이름 : inputUrlPro.jsp				-->
<!-- 					 	 				-->
<!--  목적 : 암호화된 form_id를 활용하여 Url 생성	-->
<!-- 		암호화 되었는지 확인용 페이지 	 		-->
<!-- 					 	 				-->

<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" import="model.encrypt.LocalEncrypter"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>UrlPro</title>
</head>
<body>
	<%
	//id값을 불러와서 암호화 후 form_id와 url 생성
	String id = session.getAttribute("sessionID").toString();	// 로그인된 id
	String f_id = request.getParameter("form_id");				// database의 실제 form_id
	
	String encryptcode = LocalEncrypter.returnEncryptCode(id);
	//out.println(encryptcode);
	
	//String decryptcode = LocalEncrypter.returnDecryptCode(encryptcode);
	//out.println(decryptcode);
	String url = f_id + "/" + encryptcode;	// 암호화된 form_id를 활용하여 url 생성
	out.println(url);
	//response.sendRedirect("url");
	%>
</body>
</html>