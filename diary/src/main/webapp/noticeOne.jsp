<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>

<%
	// 유효성 검사: 요청값noticeNo가 null일 경우 리다이렉션 후 코드진행종료
	if(request.getParameter("noticeNo") == null) {
		response.sendRedirect("./noticeList.jsp"); // 웹브라우저에게 noticeNo가 null이면 home.jsp로 다시 가라고 응답한다
		return; // 1. 코드진행종료 2. 반환값을 남길 때
	} 
	
	// noticeNo가 null이 아닌경우 받아서 noticeNo에 int타입으로 저장
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	
	// MariaDB에서 데이터를 받아오기
	Class.forName("org.mariadb.jdbc.Driver"); 
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	/*
		select notice_no noticeNo, notice_title noticeTitle, notice_content noticeContent, notice_writer noticeWriter, createdate, updatedate 
		from notice 
		where notice_no = ?
	*/
	String sql = "select notice_no noticeNo, notice_title noticeTitle, notice_content noticeContent, notice_writer noticeWriter, createdate, updatedate from notice where notice_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, noticeNo); // stmt의 1번째 ?를 int타입인 noticeNo로 바꿈
	System.out.println(stmt + " <--noticeOne stmt"); // ?자리를 채운 완성된 stmt를 출력
	ResultSet rs = stmt.executeQuery();
	
	// 보여주는 데이터가 한 행이므로 ArrayList를 만들 필요가 없다 -> 필요한 값의 형태에 따라 int, totalCnt, ArrayList, list등 맞게 사용
	// ArrayList를 사용하는 이유: 인덱스가 있어 순서가 있고 foreach문을 사용할 수 있다
	// 모델데이터
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
	<title>diaryOne</title>
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
		
		<h1>공지 상세</h1>
		<%	
			// 글수정이 성공하면 updateStoreAction으로부터 메시지를 받아 보여준다
			if(request.getParameter("msg") != null) {
		%>
				<span class="bg-danger text-white"><%=request.getParameter("msg")%></span>
		<%
			}
		%>
			<table class="table table-bordered">
				<tr>
					<th>notice_no</th>
					<td><%=notice.noticeNo%></td>
				</tr>
				<tr>
					<th>notice_title</th>
					<td><%=notice.noticeTitle%></td>
				</tr>
				<tr>
					<th>notice_content</th>
					<td><%=notice.noticeContent%></td>
				</tr>
				<tr>
					<th>notice_writer</th>
					<td><%=notice.noticeWriter%></td>
				</tr>
				<tr>
					<th>createdate</th>
					<td><%=notice.createdate%></td>
				</tr>
				<tr>
					<th>updatedate</th>
					<td><%=notice.updatedate%></td>
				</tr>
			</table>
		
		<!-- 수정, 상세 링크 -->
		<div>
			<a href="./updateNoticeForm.jsp?noticeNo=<%=notice.noticeNo%>" class="badge badge-info">수정</a><!-- noticeNo값을 넘긴다 -->
			<a href="./deleteNoticeForm.jsp?noticeNo=<%=notice.noticeNo%>" class="badge badge-info">삭제</a><!-- noticeNo값을 넘긴다 -->
		</div>
	</div>
</body>
</html>