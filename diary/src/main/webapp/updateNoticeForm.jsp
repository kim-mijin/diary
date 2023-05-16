<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>

<%
	/*1. 파라미터값 확인*/
	// (1) 요청값 인코딩
	request.setCharacterEncoding("utf-8");
	
	// (2) 유효성검사: 요청값이 null이나 공백이면 주소로 가라고 요청하고 코드진행을 종료한다
	if (request.getParameter("noticeNo") == null
			|| request.getParameter("noticeNo").equals("")) {
		response.sendRedirect("./noticeList.jsp");
		return;
	}
	// (3) 요청값이 null이나 공백이 아니면 변수에 저장
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	// 디버깅
	System.out.println(noticeNo + "<--updateNoticeFrom param noticeNo");
	
	/*2. DB에서 데이터 불러오기*/
	// (1) 드라이버로딩
	Class.forName("org.mariadb.jdbc.Driver"); 
	// 디버깅: 드라이버로딩 성공여부
	System.out.println("드라이버로딩 성공");
	// (2) DB접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	// 디버깅: DB접속여부
	System.out.println(conn + "<--updateNoticeForm conn");
	// (3) 쿼리 생성
	/*
		<notice테이블의 모든 열 정보를 가져온다>
		select notice_no noticeNo, notice_title noticeTitle, notice_content noticeContent, notice_writer noticeWriter, createdate, updatedate, notice_pw noticePw
		from notice 
		where notice_no = ?
	*/
	String sql = "select notice_no noticeNo, notice_title noticeTitle, notice_content noticeContent, notice_writer noticeWriter, createdate, updatedate, notice_pw noticePw from notice where notice_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	// stmt의 ?채워서 쿼리 완성하기
	stmt.setInt(1, noticeNo);
	// 디버깅: 완성된 쿼리문
	System.out.println(stmt + " <--updateNoticeFrom stmt");
	// 쿼리를 실행하고 받은 데이터를 rs에 저장하기
	ResultSet rs = stmt.executeQuery();
	System.out.println(rs + "<-- updateNoticeForm rs");
	// 데이터가 확실히 있다고 가정한 코드

	// 필요한 데이터는 한 행이므로 ArrayList를 만들 필요가 없다
	Notice notice = null; // 
	// Notice notice = new Notice();로 하면 Notice가 만들어지고 각 필드가 초기화 되기때문에 나중에 오류검사를 하면 값이 있는지 없는지로 if문에 들어왔는지를 구분할 수 없게된다. 
	if(rs.next()) { // rs.next()는 true이거나 false(데이터가 있거나 없다). true일때 상세내용 모두 표시
		notice = new Notice();
		notice.noticeNo = rs.getInt("noticeNo");
		notice.noticeTitle = rs.getString("noticeTitle");
		notice.noticeContent = rs.getString("noticeContent");
		notice.noticeWriter = rs.getString("noticeWriter");
		notice.createdate = rs.getString("createdate");
		notice.updatedate = rs.getString("updatedate");
	}
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>updateNoticeForm</title>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
</head>

<body>
	<div class="container pt-3">
		<div><!-- 메인메뉴 -->
			<a href="./home.jsp" class="badge badge-info">홈으로</a>
			<a href="./noticeList.jsp" class="badge badge-info">공지리스트</a>
			<a href="./scheduleList.jsp" class="badge badge-info">일정리스트</a>
		</div>
		
		<h1>공지 수정</h1>
		<div class="bg-danger text-white"><!-- 수정 성공, 실패 메시지 -->
			<%
				if(request.getParameter("msg") != null) {
			%>
					<%=request.getParameter("msg")%>
			<%
				}
			%>
		</div>
		<form action="./updateNoticeAction.jsp" method="post">
			<table class="table table-bordered">
				<tr><!-- 1행: 공지번호 -->
					<th>
						notice_no
					</th>
					<td>
						<input type="number" name="noticeNo" value="<%=notice.noticeNo%>" readonly="readonly">
					</td>
				</tr>
				<tr><!-- 2행: 비밀번호 -->
					<th>
						notice_pw
					</th>
					<td>
						<input type="password" name="noticePw">
					</td>
				</tr>
				<tr><!-- 3행: 공지제목 -->
					<th>
						notice_title
					</th>
					<td>
						<input type="text" name="noticeTitle" value="<%=notice.noticeTitle%>">
					</td>
				</tr>
				<tr><!-- 4행: 공지내용 -->
					<th>
						notice_content
					</th>
					<td>
						<textarea rows="5" cols="80" name="noticeContent"><%=notice.noticeContent%></textarea>
					</td>
				</tr>
				<tr><!-- 5행: 작성자 -->
					<th>
						notice_writer
					</th>
					<td>
						<%=notice.noticeWriter%>
					</td>
				</tr>
				<tr><!-- 6행: 작성일 -->
					<th>
						createdate
					</th>
					<td>
						<%=notice.createdate%>
					</td>
				</tr>
				<tr><!-- 7행: 수정일 -->
					<th>
						updatedate
					</th>
					<td>
						<%=notice.updatedate%>
					</td>
				</tr>
			</table>

			<!-- 수정버튼 -->
			<div>
				<button type="submit" class="btn btn-info">수정</button>
			</div>
		</form>
	</div>
</body>
</html>