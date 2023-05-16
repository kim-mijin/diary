<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>

<%
		/* 
			SELECT notice_no, notice_title, createdate 
			FROM notice 
			ORDER BY createdate desc
			LIMIT 0, 5
		*/ 
		
		// 1) 드라이버 로딩
		Class.forName("org.mariadb.jdbc.Driver"); // Class.forName는 static메소드
		// 2) MariaDB접속
		Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
		// 3) 쿼리생성 (최근공지 5개만 보여주기)
		String sql1 = "select notice_no noticeNo, notice_title noticeTitle, createdate from notice order by createdate desc limit 0, 5";
		PreparedStatement stmt1 = conn.prepareStatement(sql1); // 문자열을 실제 MariaDB가 실행 가능한 쿼리로 변환
		System.out.println(stmt1 + " <--home stmt1"); // 디버깅
		ResultSet rs1 = stmt1.executeQuery();		
		
		/* ResultSet -> ArrayList<Schedule> */
		ArrayList<Notice> noticeList = new ArrayList<Notice>();
		while(rs1.next()){
			Notice n = new Notice();
			n.noticeNo = rs1.getInt("noticeNo");
			n.noticeTitle = rs1.getString("noticeTitle");
			n.createdate = rs1.getString("createdate");
			noticeList.add(n);
		}
		
		// 오늘일정(날짜(오늘날짜), 시간, 메모의 10글자를 시간 오름차순으로 보여준다)
		/*
			SELECT schedule_no scheduleNo, schedule_date scheduleDate, schedule_time scheduleTime, substr(schedule_memo, 1, 10) memo ScheduleMemo
			FROM SCHEDULE
			WHERE schedule_date = CURDATE()
			ORDER BY schedule_time ASC;
			# 메모를 가져올때 자바에서 일부분을 자르지 않고, 처음 DB에서부터 일부분만 가져온다
			# AS(생략가능) -> 별명지어주기
		*/
		String sql2 = "select schedule_no scheduleNo, schedule_date scheduleDate, schedule_time scheduleTime, substr(schedule_memo, 1, 10) ScheduleMemo from schedule where schedule_date = curdate() order by schedule_time asc";
		PreparedStatement stmt2 = conn.prepareStatement(sql2);
		System.out.println(stmt2 + " <--stmt2"); // 디버깅: sql2 
		ResultSet rs2 = stmt2.executeQuery();
		System.out.println(rs2 + " <--home.jsp rs2: 쿼리실행결과"); // 디버깅: sql2 쿼리 실행결과 
		
		/*ResultSet -> ArrayList<Schedule>*/
		ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
		while(rs2.next()){
			Schedule s = new Schedule();
			s.scheduleNo = rs2.getInt("scheduleNo");
			s.scheduleDate = rs2.getString("scheduleDate");
			s.scheduleTime = rs2.getString("scheduleTime");
			s.scheduleMemo = rs2.getString("scheduleMemo");
			scheduleList.add(s);
		} // rs2.next()가 참인 동안 반복
		
		// 일정 상세페이지로 이동하기 위한 y, m, d변수 저장하기
		
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>home</title>
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
	
		
		<div><!-- 날짜순으로 최근 공지 5개 & 오늘 일정(모두)-->
			<!-- 공지사항 -->
			<h1>공지사항</h1>
			<table class="table table-bordered">
				<thead class="thead-light">
					<tr>
						<th class="text-center">notice_title</th>
						<th class="text-center">createdate</th>
					</tr>
				</thead>
				<%
					for(Notice n : noticeList){
				%>
					<tr><!-- 제목 클릭하면 상세 내용을 표시 -->
						<td>
							<a href="./noticeOne.jsp?noticeNo=<%=n.noticeNo%>"><!-- noticeNo값을 넘긴다 -->
								<%=n.noticeTitle%>
							</a>
						</td>
						<td><%=n.createdate%></td> <!-- 시간을 제외한 날짜만 보여준다 -->
					</tr>
				<%
					}
				%>
			</table>
		</div>
		<div>
			<!-- 오늘일정 -->
			<h1>오늘일정</h1>
			<table class="table table-bordered">
				<thead class="thead-light">
					<tr>
						<th class="text-center">schedule_date</th>
						<th class="text-center">schedule_time</th>
						<th class="text-center">schedule_memo</th>
					</tr>
				</thead>
				<%
					// scheduleList 사이즈만큼 반복
					for(Schedule s : scheduleList){ 
				%>
					<tr><!-- 제목 클릭하면 상세 내용을 표시 -->
						<td><%=s.scheduleDate%></td>
						<td><%=s.scheduleTime%></td>
						<td><a href="./scheduleListByDate.jsp?y="><%=s.scheduleMemo%></a></td><!-- scheduleNo 값을 넘긴다 -->
					</tr>
				<%
					}
				%>
			</table>
		</div>
		<div>
			<h1>다이어리 프로젝트</h1>
			<table class="table table-bordered">
				<tr>
					<td>
						개발환경 및 라이브러리: JDK 11, HTML, CSS, SQL, Bootstrap, Maria DB
					</td>
				</tr>
				<tr>
					<td>
						MariaDB에서 데이터 가져와 화면에 출력하기 (select)<br>
						리스트 페이지 만들기<br>
						데이터 추가, 수정, 삭제 폼<br>
						SQL 작성하여 데이터를 DB에 삽입, 수정, 삭제하기 (insert, update, delete)<br>
						Calendar API를 이용하여 달력 만들기<br>
					</td>
				</tr>
			</table>
		</div>
	</div>
</body>
</html>