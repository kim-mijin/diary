<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %><!-- java.util안에 있는 모든 클래스를 import -->
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>

<%
	/*요청값 확인하고 변수에 저장하기*/
	// 요청값이 잘 넘어오는지 확인하기
	System.out.println(request.getParameter("targetYear") + " <-- scheduleList param targetYear확인");
	System.out.println(request.getParameter("targetMonth") + " <-- scheduleList param targetMonth확인");
	
	// 변수선언
	int targetYear = 0; 
	int targetMonth = 0;
	
	// 년도 or 월이 null이거나 공백이면 오늘 날짜의 년도/월 값으로, 요청값이 넘어오면 요청값으로 설정
	if(request.getParameter("targetYear") == null || request.getParameter("targetMonth") == null
		|| request.getParameter("targetYear").equals("") || request.getParameter("targetMonth").equals("")) {
		Calendar c = Calendar.getInstance(); // Calendar클래스는 특수한 형태로 사용(new연산자를 사용하지 않는다)
		targetYear = c.get(Calendar.YEAR);
		targetMonth = c.get(Calendar.MONTH);// MONTH는 0~11값 반환(1월~12월)
	} else {
		targetYear = Integer.parseInt(request.getParameter("targetYear"));
		targetMonth = Integer.parseInt(request.getParameter("targetMonth"));
	}
	// 요청값이 null인경우 확인하기
	System.out.println(targetYear + " <--scheduleList targetYear"); // 입력: null인경우 -> 결과: 2023
	System.out.println(targetMonth + " <--scheduleList targetMonth"); // 입력: null인경우 -> 결과: 3
	
	/* 달력 출력하기 */
	// 오늘 날짜
	Calendar today = Calendar.getInstance();
	int todayDate = today.get(Calendar.DATE);
	System.out.println(todayDate + " <--scheduleList todayDate");
	
	// targetMonth 1일의 요일
	Calendar firstDay = Calendar.getInstance();
	firstDay.set(Calendar.YEAR, targetYear); // firstday의 년도를 targetYear로 설정
	firstDay.set(Calendar.MONTH, targetMonth); // firstday의 월을 targetMonth로 설
	firstDay.set(Calendar.DATE, 1); // firstday의 날짜를 1일로 설정
	
	// API적용된 최종적으로 만들어진 targetYear와 targetMonth -> Calendar API는 month가 -1보다 작거나 12보다 크면 년도를 자동으로 바꾼다
	targetYear = firstDay.get(Calendar.YEAR);
	targetMonth = firstDay.get(Calendar.MONTH);
	System.out.println(targetYear + " <--scheduleList api적용 후 최종targetYear"); // 입력:년23월0 ->결과:년22월12
	System.out.println(targetMonth + " <--scheduleList api적용 후 최종targetMonth"); // 결과:년23월12 ->결과:년24월1
	
	int firstYoil = firstDay.get(Calendar.DAY_OF_WEEK); // targetYear-targetMonth-1일이 몇번째 요일인지 (1~7/일~토)
	System.out.println(firstYoil + " <--scheduleList firstYoil: targetMonth의 1일은 몇번째요일");
	
	// 1일 앞의 공백 수
	int startBlank = firstYoil - 1; 
	
	// targetMonth 마지막일
	int lastDate = firstDay.getActualMaximum(Calendar.DATE); // targetMonth의 날짜 중 가장 큰 수
	System.out.println(lastDate + " <--scheduleList lastDate: targetMonth의 마지막날짜");
	
	// lastDate 날짜 뒤 공백 수
	// 전체 td를 7로 나눈 나머지는 0
	int endBlank = 0;
	if ((startBlank + lastDate) % 7 != 0) { // 1일앞의 공백과 날짜수를 더한 값이 7로 나누어지지 않으면 endBlank는 7에서 그 나머지를 뺀 수
		endBlank = 7 - (startBlank + lastDate)%7; 
	}
	System.out.println(endBlank + " <--scheduleList endBlank");
	
	// 전체 td의 개수
	int totalTD = startBlank + lastDate + endBlank; 
	System.out.println(totalTD + " <--scheduleList totalTD");
	
	/*DB data를 가져오는 알고리즘*/
	Class.forName("org.mariadb.jdbc.Driver"); // Class.forName는 static메소드
	// 2) MariaDB접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	// 3) 쿼리생성
		/*
			select schedule_no scheduleNo, day(schedule_date) scheduleDate, substr(schedule_memo, 1, 5) scheduleMemo, schedule_color scheduleColor,
			from schedule
			where year(schedule_date) = ? and month(schedule_date) = ?
			order by month(schedule_date) asc;
		*/
	PreparedStatement stmt = conn.prepareStatement("select schedule_no scheduleNo, day(schedule_date) scheduleDate, substr(schedule_memo, 1, 5) scheduleMemo, schedule_color scheduleColor from schedule where year(schedule_date) = ? and month(schedule_date) = ? order by month(schedule_date) asc");
	stmt.setInt(1, targetYear);
	stmt.setInt(2, targetMonth + 1); // mariaDB의 월은 1~12, targetMonth는 0~11이기 때문에 + 1을 한다
	System.out.println(stmt + " <--scheduleList stmt"); // 디버깅
	ResultSet rs = stmt.executeQuery();
	
	// ResultSet -> ArrayList<Schedule>
	ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
	while(rs.next()) {
		Schedule s = new Schedule();
		s.scheduleNo = rs.getInt("scheduleNo");
		s.scheduleDate = rs.getString("scheduleDate"); // 전체날짜가 아닌 월 값만 들어가있다
		s.scheduleMemo = rs.getString("scheduleMemo"); // 전체메모가 아닌 앞 5자만 들어가있다
		s.scheduleColor = rs.getString("scheduleColor");
		scheduleList.add(s);
	}
	// rs의 개수만큼 Schedule이 만들어지고 scheduleList에 저장하는 것이 반복된다
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
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
		
		<h1>
		<%=targetYear%>년 <%=targetMonth + 1%>월
		</h1>
		
		<div>
			<a href="./scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth-1%>">이전달</a>
			<a href="./scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth+1%>">다음달</a>
		</div>
		
		<!-- 삭제 성공 후 돌아오면 성공메시지를 보여준다 -->
		<div class="bg-danger text-white">
		<%
			if(request.getParameter("msg") != null){
		%>
				<%=request.getParameter("msg")%>
		<%
			}
		%>
		</div>
		<table class="table table-bordered">
			<thead class="thead-light">
				<tr>
					<th>일</th>
					<th>월</th>
					<th>화</th>
					<th>수</th>
					<th>목</th>
					<th>금</th>
					<th>토</th>
				</tr>
			</thead>
			<tr>
				<%
					// totalTD만큼 <td></td>반복된다
					for (int i=0; i<totalTD; i+=1){
						// 출력해야하는 날짜
						int num = i-startBlank+1;
						
						// i가 0일때를 제외하고 i가 7로 나누어 떨어지면 </tr><tr>을 추가하여 줄바꿈
						if(i!=0 && i%7==0) {
				%>
							</tr><tr>
				<%
						}
						String tdClass = "";
						// num이 1~마지막날짜 사이일때만 출력한다
						if(num>0 && num<=lastDate){
							// 오늘 날짜에 노란색 표시 (오늘 년도와targetYear, 월과 targetMonth, 날짜가 num과 같다)
							if (today.get(Calendar.YEAR) == targetYear 
								&& today.get(Calendar.MONTH) == targetMonth 
								&& today.get(Calendar.DATE) == num) {
								tdClass = "table-primary";	
							} 

				%>
								<td class="<%=tdClass%>">
									<div><!-- 날짜 숫자 -->
										<!-- 날짜를 클릭하면 해당 날짜 일정리스트로 넘어감 -->
										<a href="./scheduleListByDate.jsp?y=<%=targetYear%>&m=<%=targetMonth%>&d=<%=num%>"><%=num%></a>
									</div>
									<div><!-- 일정 메모 일부분 -->
										<%
											for(Schedule s : scheduleList){ // scheduleList안에 있는 Schedule타입 출력
												if(num == Integer.parseInt(s.scheduleDate)){ // 날짜와 일치하는 스케줄 출력
										%>
												<!-- 일정을 클릭하면 수정페이지로 넘어감 -->
												<div><a href="updateScheduleForm.jsp?scheduleNo=<%=s.scheduleNo%>" style="color:<%=s.scheduleColor%>"><%=s.scheduleMemo%></a></div>
										<%
												}
											}
										%>
									</div>
								</td>
				<%
						} else {
				%>
						<td>&nbsp;<br>&nbsp;<br>&nbsp;</td>
				<%
						}
					}
				%>
			
			</tr>
		</table>
	</div>
</body>
</html>