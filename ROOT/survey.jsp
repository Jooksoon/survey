
<!-- 					 		-->
<!--  파일이름 : survey.jsp		-->
<!-- 					 		-->
<!--  목적 : 설문지 페이지			-->
<!-- 					 		-->


<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="java.sql.*, DB.connection.DBConnection, java.util.ArrayList"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>폴인사이트</title>
<link rel="stylesheet" href="css/survey.css">
</head>
<body>
	<header>
		<h1>폴인사이트</h1>
	</header>
	<form id="form" method="get" action="#">
		<div class="surveypaper-header">
			<div class="progress">
				<div id="progress-text">
					<div style="float: left;">진행률</div>
					<div style="float: right;">60%</div>
				</div>
				<div id="progress-behind">
					<div id="progress-front"></div>
				</div>
			</div>
		</div>
		<div class='questions' id='questions'></div>
		<div class="surveypaper-footer">
			<button id="prev-btn" type="submit" value="submit">이전</button>
			<button id="next-btn" type="submit" value="submit">다음</button>
		</div>
	</form>

	<script>
	
	/*											*/
	/*	질문을 저장할 table을 생성					*/
	/*											*/
	/*	Parameters								*/
	/*	question_id : 현재 질문의 question_id		*/
	/*											*/
	/*	question_id는 database에 저장된 실제 id		*/
	/*											*/
	function addQuestion(question_id) {
		
		let questions = document.getElementById('questions');
		
		let question = document.createElement('div');
		
		question.className = "question";

		question.innerHTML = "<table class='question_table' id='question_table" + question_id + "'></table>"
		
		questions.appendChild(question);
	}

	
	/*											*/
	/*	질문 table에 title 부분 넣기					*/
	/*											*/
	/*	Parameters								*/
	/*	question_id : 현재 질문의 question_id		*/
	/*	title : title 내용						*/
	/*											*/
	function addTitle(question_id, title){
		let table = document.getElementById("question_table" + question_id);
			
		let rowlen = table.rows.length + 1;
			
		// var row = table.insertRow(); // IE와 Chrome 동작을 달리함.
		let row = table.insertRow(rowlen - 1); // HTML에서의 권장 표준 문법
			
		let newcell = row.insertCell(0);
		newcell.innerHTML = title;
		newcell.className = "title";
	}
	

	/*											*/
	/*	질문 table에 option 부분 넣기				*/
	/*											*/
	/*	Parameters								*/
	/*	question_id : 현재 질문의 question_id		*/
	/*	contents : 옵션의 내용						*/
	/*	value : 옵션의 option_id					*/
	/*	order : 옵션의 나열 순서, ex) 5지선다라면 3번 등	*/
	/*											*/
	function addOption(question_id, contents, value, order){
		let table = document.getElementById("question_table" + question_id);
			
		let rowlen = table.rows.length + 1;
			
		// var row = table.insertRow(); // IE와 Chrome 동작을 달리함.
		let row = table.insertRow(rowlen - 1); // HTML에서의 권장 표준 문법
			
		let newcell = row.insertCell(0);
		newcell.innerHTML = "<input type='radio' id='option" + question_id + "_" + order + "' name='option" + question_id + "' value = " + value + "></input>" 
		+ "<label for='option" + question_id + "_" + order + "'>" + contents + "</label>";
		newcell.className = "options";
	}
	
	
	/*											*/
	/*	질문 table에 testarea넣기(주관식)				*/
	/*											*/
	/*	Parameters								*/
	/*	question_id : 현재 질문의 question_id		*/
	/*											*/
	function addTextArea(question_id){
		let table = document.getElementById("question_table" + question_id);
		
		let rowlen = table.rows.length + 1;
			
		// var row = table.insertRow(); // IE와 Chrome 동작을 달리함.
		let row = table.insertRow(rowlen - 1); // HTML에서의 권장 표준 문법
			
		let newcell = row.insertCell(0);
		newcell.innerHTML = "<textarea class='textarea' id='answer" + question_id + "'></textarea>";
		newcell.className = "textarea";
	}
	
	
	/*											*/
	/*	질문 table에 옵션 넣기(행렬형)					*/
	/*											*/
	/*	Parameters								*/
	/*	question_id : 현재 질문의 question_id		*/
	/*	contents : 옵션의 내용						*/
	/*											*/
	function addMatrixOption(question_id, contents){
		
		let table = document.getElementById("question_table" + question_id);
		
		let rowlen = table.rows.length + 1;
			
		let row;	// 이 행은 제목 아래있는 2번째 행이어야 한다
		
		if(rowlen < 3){	// 아직 아무런 옵션이 생성되지 않은 경우

			// var row = table.insertRow(); // IE와 Chrome 동작을 달리함.
			row = table.insertRow(rowlen - 1); // HTML에서의 권장 표준 문법
			
			let newcell = row.insertCell(0);	// 첫 칸을 blank로 만듦(내용 X)
			newcell.className = "blank";
		
		} else {		// 아래 질문이 있을 경우
			
			row = table.rows[1];	// 옵션이 있는 행을 가리켜야 하기 때문에 table.rows[1]로 지정
		}
			
		let newcell = row.insertCell(1);	// 새로운 열을 만들고
		newcell.innerHTML = contents;		// 내용을 넣어줌
		newcell.className = "option_title";
	}
	
	
	/*											*/
	/*	질문 table에 질문 넣기(행렬형)					*/
	/*											*/
	/*	Parameters								*/
	/*	question_id : 현재 질문의 question_id		*/
	/*	title : subquestion의 title				*/
	/*	num_of_option : 옵션 수					*/
	/*	order : subquestion의 나열 순서				*/
	/*											*/
	function addMatrixQuestion(question_id, title, num_of_option, order){
		
		let table = document.getElementById("question_table" + question_id);
		
		let rowlen = table.rows.length + 1;
			
		// var row = table.insertRow(); // IE와 Chrome 동작을 달리함.
		let row = table.insertRow(rowlen - 1); // HTML에서의 권장 표준 문법
			
		// 0번 열에는 질문의 title
		let newcell = row.insertCell(0);
		newcell.innerHTML = title;
		newcell.className = "inner_title";
		
		// 뒤에는 옵션 수만큼 라디오 버튼이 필요
		for(let i = 1; i <= num_of_option; i++){
			newcell = row.insertCell(i);
			newcell.innerHTML = "<input type='radio' id='option' name='option" + question_id + "_" + order +"' value=''>";
			newcell.className = "matrix_options";
		}
	}
	
	/*											*/
	/*	질문 table에 있는 옵션의 value 넣기(행렬형)		*/
	/*											*/
	/*	Parameters								*/
	/*	question_id : 현재 질문의 question_id		*/
	/*	row : 라디오 버튼의 행						*/
	/*	cell : 라디오 버튼의 열						*/
	/*	value : option의 option_id				*/
	/*											*/
	function setValue(question_id, row, cell ,value){
		
		let table = document.getElementById("question_table" + question_id);
		
		let opt = table.rows[row].cells[cell].querySelector("input");
		
		opt.value = value;
	}
	</script>

<%
int form_id = Integer.parseInt(request.getParameter("form_id"));

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

ArrayList<Integer> questions = new ArrayList<>();	// 질문들의 question_id가 저장된 리스트
ArrayList<Integer> options = new ArrayList<>();		// 행렬형의 옵션들이 저장된 리스트

int group = 0;	// option_group_id가 저장될 변수

try {
	// 커넥션을 가져온다.
	conn = DBConnection.getConnection();

	// 자동 커밋을 false로 한다.
	conn.setAutoCommit(false);

	StringBuffer sql = new StringBuffer();
	sql.append("SELECT i.question_id FROM include i WHERE i.form_id = ?;");	// form_id를 가지고 설문지에 있는 질문들의 question_id를 가져옴

	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setInt(1, form_id);

	rs = pstmt.executeQuery();

	while (rs.next()) {
		questions.add(Integer.valueOf(rs.getInt(1))); // question_id를 questions에 넣음
	}

	for (int i = 0; i < questions.size(); i++) {	//질문의 수만큼
		
		%>
			<script>addQuestion(<%=questions.get(i)%>);</script>
		<%
		sql = new StringBuffer();
		sql.append("SELECT * FROM question q WHERE q.question_id = ?");	// question의 내용을 가져옴

		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setInt(1, questions.get(i));

		rs = pstmt.executeQuery();

		while (rs.next()) {
			String title = rs.getString("title");
			String type = rs.getString("type");

			%>
				<script>addTitle(<%=questions.get(i)%>, '<%=title%>');</script>
			<%
			
			int order = 1;	// 옵션의 order(순서)
			
			switch (type) {
			
			case "multiple" :	// 객관식
				
				group = rs.getInt("option_group_id");
		
				sql = new StringBuffer();
				
				// option_group_id로 옵션 그룹에 속해있는 option들을 읽어옴
				sql.append("SELECT o.* FROM option o, option_grouping og WHERE og.option_group_id = ? AND og.option_id = o.option_id;");

				pstmt = conn.prepareStatement(sql.toString());
				pstmt.setInt(1, group);
	
				rs = pstmt.executeQuery();
				
				order = 1;
				
				while (rs.next()) {
					
					int value = rs.getInt(1);	// option_id
					String contents = rs.getString("contents");
					
					%>
					<script>addOption(<%=questions.get(i)%>, '<%=contents%>', <%=value%> , <%=order++%>);</script>
					<%
				}
				break;
			
			case "shortanswer" :	// 주관식
			
				%>
				<script>addTextArea(<%=questions.get(i)%>);</script>
				<%
				break;
			
			case "matrix" :		// 행렬형
				group = rs.getInt("option_group_id");
				
				sql = new StringBuffer();
				
				// addMatrixOption에서 항상 첫 번째 셀에 추가하기 때문에 옵션을 order의 역순으로 읽어와야 웹에서 제대로 표시
				// 이를 위해서 ORDER BY og.option_num DESC를 사용
				sql.append("SELECT o.* FROM option o, option_grouping og WHERE og.option_group_id = ? AND og.option_id = o.option_id ORDER BY og.option_num DESC;");
	
				pstmt = conn.prepareStatement(sql.toString());
				pstmt.setInt(1, group);
	
				rs = pstmt.executeQuery();
				
				// 옵션을 불러와서 options에 저장
				while (rs.next()) {
					
					int value = rs.getInt(1);	// option_id 
					String contents = rs.getString("contents");
					
					options.add(Integer.valueOf(value));
					
					%>
					<script>addMatrixOption(<%=questions.get(i)%>, '<%=contents%>');</script>
					<%
				}
				
				sql = new StringBuffer();
				
				// matrix_rel에서 행렬형 질문의 subquestion들을 읽어옴
				sql.append("SELECT q.title FROM question q, matrix_rel m WHERE m.main_question = ? AND m.sub_question = q.question_id;");
	
				pstmt = conn.prepareStatement(sql.toString());
				pstmt.setInt(1, questions.get(i));
	
				rs = pstmt.executeQuery();
				
				order = 1;	// 질문 order(순서)
				
				// 질문 불러오기
				while (rs.next()) {
					String inner_title = rs.getString("title");
					%>
					<script>addMatrixQuestion(<%=questions.get(i)%>, '<%=inner_title%>', <%=options.size()%>,<%=order++%>);</script>
					<%
				}
				
				// 아래는 라디오 버튼의 value에 option_id를 설정해주는 코드
				// j는 행 번호, 라디오 버튼은 2행부터 시작
				// k는 열 번호, 라디오 버튼은 각 행의 1열부터 시작
				for(int j = 2; j < order + 1; j++){
					for(int k = 1; k <= options.size(); k++){
						%>
						<!-- get(options.size() - k)인 이유는 위에서 설명하였듯이 역순으로 읽어왔기 때문 -->
						<script>setValue(<%=questions.get(i)%>, <%=j%>, <%=k%>, <%=options.get(options.size() - k)%>);</script>
						<%
					}
				}
				
				
				options.clear();	// 다음 행렬형 질문을 위해 options를 초기화
				break;
				}
			}
		}
	}
	 finally {
	// Connection, PreparedStatement를 닫는다.
	try {
		if (rs != null) {
	rs.close();
	rs = null;
		}
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
%>
</body>
</html>