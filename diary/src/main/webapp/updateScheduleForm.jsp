<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>

<%
	// 요청값 인코딩
	request.setCharacterEncoding("utf-8");

	// 요청값이 잘 넘어오는지 디버깅
	System.out.println(request.getParameter("scheduleNo") + " <--updateScheduleForm param scheduleNo");
	
	// 유효성 검사: 요청값이 null 이거나 공백이면 scheduleList로 리다이렉션 코드 진행 종료
	if(request.getParameter("scheduleNo") == null || request.getParameter("scheduleNo").equals("")) {
		response.sendRedirect("./scheduleList.jsp");
		return;
	}
	
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	
	// 드라이버로딩
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("updateScheduleForm 드라이버로딩 성공"); // 드라이버로딩 확인완료
	// DB접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	System.out.println(conn + " <--updateScheduleForm DB접속확인"); // 확인완료
	// 쿼리문 생성 및 실행
	/*
		select schedule_no scheduleNo, schedule_date scheduleDate, schedule_time scheduleTime, schedule_memo scheduleMemo, schedule_color scheduleColor, createdate, updatedate, schedule_pw schedulePw 
		from schedule 
		where schedule_no = ?
	*/
	String sql = "select schedule_no scheduleNo, schedule_date scheduleDate, schedule_time scheduleTime, schedule_memo scheduleMemo, schedule_color scheduleColor, createdate, updatedate, schedule_pw schedulePw from schedule where schedule_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	// ? 채우기
	stmt.setInt(1, scheduleNo); // stmt의 첫번째 ?는 int타입의 scheduleNo가 들어간다
	System.out.println(stmt + " <--updateScheduleForm stmt: 완성된 쿼리문");
	ResultSet rs = stmt.executeQuery();
	System.out.println(rs + " <--updateScheduleForm rs: 쿼리실행 결과");
	
	// ResultSet -> ArrayList<ScheduleList>
	Schedule schedule = null;
	// Schedule타입의 scheduleList이름을 가진 ArrayList를 만든다. -> ArrayList는 null이 아니고 값을 저장하기 전까지는 사이즈는 0
	// ArrayList의 사이즈는 채워진 행의 수를 의미한다
	while(rs.next()){
		schedule = new Schedule();
		schedule.scheduleNo = rs.getInt("scheduleNo");
		schedule.scheduleDate = rs.getString("scheduleDate");
		schedule.scheduleTime = rs.getString("scheduleTime");
		schedule.scheduleMemo = rs.getString("scheduleMemo");
		schedule.scheduleColor = rs.getString("scheduleColor");
		schedule.createdate = rs.getString("createdate");
		schedule.updatedate = rs.getString("updatedate");
		schedule.schedulePw = rs.getString("schedulePw");
	} // rs.next()가 참인 동안 Schedule타입에 DB에서 불러온 데이터를 넣고 schduleList에 추가

%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>updateScheduleForm</title>
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
		
		<h1>스케줄 수정</h1>
		
		<!-- 수정에 실패하면 (msg값이 있으면) 메시지 출력 -->
		<div class="bg-danger text-white">
		<%
			if(request.getParameter("msg") != null){
		%>
				<%=request.getParameter("msg")%>
		<%
			}
		%>
		</div>
				
		<form action="./updateScheduleAction.jsp?scheduleNo=<%=scheduleNo%>" method="post">
			<table class="table">
				<tr><!-- 1행 -->
					<th>schedule_date</th>
					<td><input type="date" name="scheduleDate" value="<%=schedule.scheduleDate%>"></td>
				</tr>
				<tr><!-- 2행 -->
					<th>schedule_time</th>
					<td><input type="time" name="scheduleTime" value="<%=schedule.scheduleTime%>"></td>
				</tr>
				<tr><!-- 3행 -->
					<th>schedule_color</th>
					<td><input type="color" name="scheduleColor" value="<%=schedule.scheduleColor%>"></td>
				</tr>
				<tr><!-- 4행 -->
					<th>schedule_memo</th>
					<td><textarea cols="80" rows="3" name="scheduleMemo"><%=schedule.scheduleMemo%></textarea></td>
				</tr>
				<tr><!-- 5행 -->
					<th>schedule_pw</th>
					<td><input type="password" name="schedulePw"></td>
				</tr>
			</table>

			<button type="submit">수정</button>
		</form>
	</div>
</body>
</html>