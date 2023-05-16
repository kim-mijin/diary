<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	//요청값 인코딩
	request.setCharacterEncoding("utf-8");

	// 요청값이 잘 넘어오는지 확인(확인완료)
	System.out.println(request.getParameter("scheduleNo") + " <--deleteScheduleForm param scheduleNo");
	
	// 유효성 검사: 요청값이 null이거나 공백이면 scheduleList로 리다이렉션 후 코드진행종료
	if(request.getParameter("scheduleNo") == null || request.getParameter("scheduleNo").equals("")) {
		response.sendRedirect("./scheduleList.jsp");
		return;
	}
	
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));

%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<!-- Latest compiled and minified CSS -->
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div class="container pt-3">
	<div><!-- 메인메뉴 -->
			<a href="./home.jsp" class="badge badge-info">홈으로</a>
			<a href="./noticeList.jsp" class="badge badge-info">공지리스트</a>
			<a href="./scheduleList.jsp" class="badge badge-info">일정리스트</a>
	</div>
	
	<h1>스케줄 삭제</h1>
		<form action="./deleteScheduleAction.jsp?scheduleNo=<%=scheduleNo%>" method="post">
			<table class="table table-bordered">
				<tr><!-- 1행 -->
					<th>schedule_no</th>
					<td><input type="text" name="scheduleNo" value="<%=scheduleNo%>" readonly="readonly"></td>
				</tr>
				<tr><!-- 2행 -->
					<th>schedule_pw</th>
					<td><input type="password" name="schedulePw"></td>
				</tr>
			</table>
			<button type="submit">삭제</button>
		</form>
	</div>
</body>
</html>