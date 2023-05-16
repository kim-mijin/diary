<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %><!-- java.sql의 모든 클래스를 import -->
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>

<%
	// 값이 잘 넘어오는지 디버깅
	System.out.println(request.getParameter("y") + " <--넘어오는 값 확인");
	System.out.println(request.getParameter("m") + " <--넘어오는 값 확인");
	System.out.println(request.getParameter("d") + " <--넘어오는 값 확인");
	
	// 유효성검사: y, m, d가 null 이거나 공백이면 redirection(scheduleList.jsp) 후 코드진행 종료
	if(request.getParameter("y") == null || request.getParameter("m") == null || request.getParameter("d") == null
		|| request.getParameter("y").equals("") || request.getParameter("m").equals("") || request.getParameter("d").equals("")) {
		response.sendRedirect("./scheduleList.jsp");
		return;
	}
	
	// 요청값을 변수에 저장한다
	int y = Integer.parseInt(request.getParameter("y"));
	// 자바Calendar API에서는 12월은 11, 마리아DB에서는 12월은 12
	// insertScheduleAction.jsp에서 해당 값을 마리아DB에 저장하기 때문에 마리아DB형식에 맞추어 m파라미터값에 +1을 한 후 Action으로 보낸다
	int m = Integer.parseInt(request.getParameter("m")) + 1;
	int d = Integer.parseInt(request.getParameter("d"));

	System.out.println(y + " <--scheduleListByDate param y");
	System.out.println(m + " <--scheduleListByDate param m");
	System.out.println(d + " <--scheduleListByDate param d");
	
	// html에
	// 마리아DB의 날짜형식(yyyy-mm-dd)에 맞추기 위해서 m과 d가 10보다 작으면 앞에 0을 붙인다
	String strM = m+""; // 숫자에 공백을 붙여 String타입으로 만든다
	if(m<10) {
		strM = "0"+ strM;
	} 
	String strD = d+""; // 숫자에 공백을 붙여 String타입으로 만든다
	if(d<10){
		strD = "0"+ strD;
	}
	System.out.println(strM + " <--scheduleListByDate strM");
	System.out.println(strD + " <--scheduleListByDate strD");
	
	// 일별 스케줄 리스트 : 마리아DB에서 데이터 출력하기
	// 드라이버로딩한다
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("scheduleListByDate 드라이버로딩 성공"); // 드라이버로딩 확인완료
	// DB접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	System.out.println(conn + " <--scheduleListByDate DB접속확인"); // 확인완료
	/*
		select schedule_no scheduleNo, schedule_date scheduleDate, schedule_time scheduleTime, schedule_memo scheduleMemo, schedule_color scheduleColor, createdate, updatedate, schedule_pw schedulePw 
		from schedule where schedule_date = ? 
		order by schedule_time asc
	*/
	String sql = "select schedule_no scheduleNo, schedule_date scheduleDate, schedule_time scheduleTime, schedule_memo scheduleMemo, schedule_color scheduleColor, createdate, updatedate, schedule_pw schedulePw from schedule where schedule_date = ? order by schedule_time asc";
	PreparedStatement stmt = conn.prepareStatement(sql);
	// ? 채우기
	stmt.setString(1, y+"-"+strM+"-"+strD);
	System.out.println(stmt + " <--scheduleListByDate stmt 완성된 쿼리문");
	
	ResultSet rs = stmt.executeQuery(); // ★ResultSet은 꼭 ArrayList로 바꿔야한다
	System.out.println(rs + " <--scheduleListByDate rs 쿼리실행결과"); 	
	
	// ResultSet -> ArrayList
	ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
	while(rs.next()){
		Schedule s = new Schedule();
		s.scheduleNo = rs.getInt("scheduleNo");
		s.scheduleTime = rs.getString("scheduleTime");
		s.scheduleDate = rs.getString("scheduleDate");
		s.scheduleMemo = rs.getString("scheduleMemo");
		s.scheduleColor = rs.getString("scheduleColor");
		s.createdate = rs.getString("createdate");
		s.updatedate = rs.getString("updatedate");
		s.schedulePw = rs.getString("schedulePw");
		scheduleList.add(s);
	}
	
	
%>
<!DOCTYPE html>
<html>
	<head>
	<meta charset="UTF-8">
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
<title>scheduleListByDate.jsp</title>
</head>

<body>
	<div class="container pt-3">
		<div><!-- 메인메뉴 -->
				<a href="./home.jsp" class="badge badge-info">홈으로</a>
				<a href="./noticeList.jsp" class="badge badge-info">공지리스트</a>
				<a href="./scheduleList.jsp" class="badge badge-info">일정리스트</a>
		</div>
		
		<!-- 스케줄입력 -->
		<h1>스케줄 입력</h1>
		<form action="./insertScheduleAction.jsp" method="post">
			<table class="table">
				<tr><!-- 1행 -->
					<th>schedule_date</th>
					<td><input type="date" name="scheduleDate" value="<%=y%>-<%=strM%>-<%=strD%>" readonly="readonly"></td>
				</tr>
				<tr><!-- 2행 -->
					<th>schedule_time</th>
					<td><input type="time" name="scheduleTime"></td>
				</tr>
				<tr><!-- 3행 -->
					<th>schedule_color</th>
					<td><input type="color" name="scheduleColor" value="#000000"></td>
				</tr>
				<tr><!-- 4행 -->
					<th>schedule_memo</th>
					<td><textarea cols="80" rows="3" name="scheduleMemo"></textarea></td>
				</tr>
				<tr><!-- 5행 -->
					<th>schedule_pw</th>
					<td><input type="password" name="schedulePw"></td>
				</tr>
			</table>
			<button type="submit">입력</button>
		</form>
		<br>
		
		<!-- 스케줄리스트 -->
		<!-- 수정완료되면 메시지 -->
		<div class="bg-danger text-white">
		<%
			if(request.getParameter("msg") != null){ // msg로 받은 요청값이 null이 아니면 메시지를 표시한다
		%>
				<%=request.getParameter("msg")%>	
		<%
			}
		%>
		</div>
		
		<h1><%=y%>년 <%=m%>월 <%=d%>일 스케줄 목록</h1>
		<table class="table table-bordered">
			<thead class="thead-light">
				<tr>
					<th>schedule_time</th>
					<th>schedule_memo</th>
					<th>createdate</th>
					<th>updatedate</th>
					<th>edit</th>
					<th>delete</th>
				</tr>
			</thead>
			<%
				for(Schedule s : scheduleList){
			%>
				<tr>
					<td><%=s.scheduleTime%></td>
					<td><%=s.scheduleMemo%></td>
					<td><%=s.createdate%></td>
					<td><%=s.updatedate%></td>
					<td><a href="./updateScheduleForm.jsp?scheduleNo=<%=s.scheduleNo%>">edit</a></td>
					<td><a href="./deleteScheduleForm.jsp?scheduleNo=<%=s.scheduleNo%>">delete</a></td>
				</tr>
			<%
				}
			%>
		</table>
	</div>
</body>
</html>