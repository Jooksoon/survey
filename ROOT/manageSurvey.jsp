
<!-- 					 		-->
<!--  파일이름 : manageSurvey.jsp	-->
<!-- 					 		-->
<!--  목적 : 설문 목록 페이지			-->
<!-- 					 		-->

<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
<%@page import="DB.connection.DBConnection" %><!--mysql 데이터 참조 라이브러리-->
<%!

	/*	값을 받아서 정수로 바꿔주는 함수 			*/
	/*	parameter								*/
	/*	str: 문자열 변수						*/
	/*	num: 문자열을 정수로 변환한 변수		*/
	/*	return num							*/
    public int nullIntconvert(String str) {
        int num = 0;
        if (str == null) {
            str = "0";
        } else if ((str.trim()).equals("null")) {	// trim: 문자열 공백 제거
        											// 공백 제거한 결과가 null이라면
            str = "0";	// 문자열의 값을 0으로 하고
        } else if (str.equals("")) {	// 빈 문자열이면
            str = "0";	// 그때도 0으로 처리한다.
        }
        try {
            num = Integer.parseInt(str); // 문자열을 정수로 변환해서 num에 저장
        } catch (Exception e) {
        }
        return num; // num 리턴
    }
%>
<%
	/*mysql 연동*/
    Connection conn = DBConnection.getConnection();
	
	conn.setAutoCommit(false);
	
    ResultSet rs1 = null;
    ResultSet rs2 = null;
    PreparedStatement ps1 = null;
    PreparedStatement ps2 = null;

	/* 페이지네이션 구현 */
    int showRows = 10;
    int totalRecords = 5;

	// 현재 변수값들을 가져옴
	// totalRows: 한 페이지에 출력할 최대 튜플 수
    int totalRows = nullIntconvert(request.getParameter("totalRows"));
	// totalPages: 전체 페이지 수
    int totalPages = nullIntconvert(request.getParameter("totalPages"));
	// iPageNo: 현재 페이지 번호
    int iPageNo = nullIntconvert(request.getParameter("iPageNo"));
	// cPageNo: totalRecords 만큼 페이지를 나눴을 때의 번호
    int cPageNo = nullIntconvert(request.getParameter("cPageNo"));

    int startResult = 0; // 현재 페이지에서 표시하는 첫 회원 데이터 튜플
    int endResult = 0; // 마지막 데이터 튜플
    int ques = 1;
    int no = 1;
    if (iPageNo == 0) {
        iPageNo = 0;
    } else {
        iPageNo = Math.abs((iPageNo - 1) * showRows);
    }
    String tablename = "form";
    String query1 = "SELECT SQL_CALC_FOUND_ROWS * FROM " + tablename + " limit " + iPageNo + "," + showRows + "";
    ps1 = conn.prepareStatement(query1);
    rs1 = ps1.executeQuery();

    String query2 = "SELECT FOUND_ROWS() as cnt";
    ps2 = conn.prepareStatement(query2);
    rs2 = ps2.executeQuery();
    if (rs2.next()) {
        totalRows = rs2.getInt("cnt");
    }
%>
<!DOCTYPE html>
<html>
<head>
	<title>폴인사이트_관리자</title>
	<link href="/css/mnms.css" rel="stylesheet" type="text/css">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
	<style>
		#mnm:hover{
		    background-color: #333;
		    color: #fff;
		}
		#mns{
		    background-color: tomato;
		    color: #fff;
		}
		#mkf:hover{
		background-color: #333;
		    color: #fff;
		}
	</style>
	<script type="text/javascript">
function makeForm(){
	window.name="parentForm";
	window.open("formInfo.jsp", "chkForm",
	"width=500 height=300 resizableno, scrollbars=no");
}
/*
function toXLS(){
	var address = "downloadExcel.jsp?title=타이틀&file_name=리스트.xls";
	location.href = address;
}
*/

</script>
</head>
<body>
    <div class="sidebar">
		<div>
			<a id="mnm" href="managePanel.jsp">회원관리</a>
		</div>
		<div>
			<a id="mns" href="manageSurvey.jsp">설문관리</a>
		</div>
		<div>
			<a  id="mkf" onclick="makeForm()">설문제작</a>
		</div>
	</div>
    <div class="main">
       <h2>설문 관리</h2>
       <hr>
       <div class="searchbar"">
           <form class="searchbar-form"> 
               <fieldset>
                      <legend>검색</legend>
                      <select name="searchbar-select">
                          <option value="name">설문조사 이름</option>
                      </select>
                      <input type="search" id="query" name="q" placeholder="설문조사조회" autocomplete="off" spellcheck="false" style="margin:auto; max-width:400px"><button type="submit"><i class="fa fa-search" style="display: inline-block"></i></button>
                  </fieldset>
           </form>
        </div>	
        <div class="surveylist">
		<table class="surveylist-table">
			<colgroup>
				<col width="20%">
				<col width="20%">
				<col width="20%">
				<col width="10%">
				<col width="20%">
				<col width="10%">
			</colgroup>
			<thead class="thead-light">
				<tr>
					<th scope="col">NO</th>
					<th scope="col">설문조사 이름</th>
					<th scope="col">응답률</th>
					<th scope="col">결과다운</th>
				</tr>
			</thead>
			<tbody>
            <%
                while (rs1.next()) { //다음 회원 데이터 튜플로 이동
            %>	
            <tr>
            	<td><%=iPageNo+no%></td> <!--회원번호(현재 페이지네이션 번호를 불러와서 계산)-->
                <td><%=rs1.getString("title")%></td> <!--설문지 이름 불러움-->
                <td>%</td>
				<td><input type="button" value="결과다운(excel)" onclick="location.href='downloadEx.jsp?survey_id=1';"></td>
            </tr>
            <%
                    ques++;
    				no++;
                }
            %>
            </tbody>
          </table>
        </div><br>
        <div class="surveynav">
	        <form class="surveynav-form">
	           <input type="hidden" name="iPageNo" value="<%=iPageNo%>">
	           <input type="hidden" name="cPageNo" value="<%=cPageNo%>">
	           <input type="hidden" name="showRows" value="<%=showRows%>">
	           <%
	               try {
	                   if (totalRows < (iPageNo + showRows)) {
	                       endResult = totalRows;
	                   } else {
	                       endResult = (iPageNo + showRows);
	                   }
	                   startResult = (iPageNo + 1);
	                   totalPages = ((int) (Math.ceil((double) totalRows / showRows)));
	               } catch (Exception e) {
	                   e.printStackTrace();
	               }
	               int i = 0;
	               int cPage = 0;
	               if (totalRows != 0) {
	                   cPage = ((int) (Math.ceil((double) endResult / (totalRecords * showRows)))); //현재 페이지 번호
	
	                   int prePageNo = (cPage * totalRecords) - ((totalRecords - 1) + totalRecords);
	                   if ((cPage * totalRecords) - (totalRecords) > 0) {	//현재 페이지 * 한 화면에 보일 최대 페이지 수 - 한 화면에 보일 최대 페이지 수
	           %>
	           <span id="prev"><a href="manageSurvey.jsp?iPageNo=<%=prePageNo%>&cPageNo=<%=prePageNo%>" class="prev-span" style="text-decoration:none;">&lt;</a></span>
	           <%
	               }
	               for (i = ((cPage * totalRecords) - (totalRecords - 1)); i <= (cPage * totalRecords); i++) { //i: 페이지네이션에 표시되는 페이지 번호
	                   if (i == ((iPageNo / showRows) + 1)) {%> // i가 페이지네이션에 표시되는 첫번째 페이지(totalRows가 5라면 1,6,7...)일 때
	           <span class="numbers"><a href="manageSurvey.jsp?iPageNo=<%=i%>" class="number-span1" style="text-decoration:none;"><%=i%></a></span>
	               <%
	               } else if (i <= totalPages) { // i가 전체 페이지 수를 벗어나지 않는 경우
	               %>
	           <span class="numbers"><a href="manageSurvey.jsp?iPageNo=<%=i%>" class="number-span2" style="text-decoration:none;"><%=i%></a></span>
	               <%
	                       }
	                   }
	                   if (totalPages > totalRecords && i < totalPages) { // 한 화면에 표시되는 페이지 개수가 전체 페이지보다 작고 i가 전체 페이지 수보다 작을 경우
	               %>
	           <span id="next"><a href="manageSurvey.jsp?iPageNo=<%=i%>&cPageNo=<%=i%>" class="next-span" style="text-decoration:none;">&gt;</a></span>
	           <%
	                   }
	               }
	               conn.close();
	
	               conn = null;
	               rs1 = null;
	               rs2 = null;
	               ps1 = null;
	               ps2 = null;
	               query1 = null;
	               query2 = null;
	           %>
	        </form><br>
		</div>
	</div>
</body>
</html>