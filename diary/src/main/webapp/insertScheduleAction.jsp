<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %><!-- java.sql의 모든 클래스를 import -->
<%
	// 요청값 인코딩
	request.setCharacterEncoding("utf-8");

	System.out.println(request.getParameter("scheduleDate") + " <--insertScheduleAction param scheduleDate");
	System.out.println(request.getParameter("scheduleTime") + " <--insertScheduleAction param scheduleTime");
	System.out.println(request.getParameter("scheduleColor") + " <--insertScheduleAction param scheduleColor");
	System.out.println(request.getParameter("scheduleMemo") + " <--insertScheduleAction param scheduleMemo");
	System.out.println(request.getParameter("schedulePw") + " <--insertScheduleAction param schedulePw");
	
	// 요청값이 null이거나 0이면 scheduleList로 돌아가기
	if(request.getParameter("scheduleDate") == null || request.getParameter("scheduleDate").equals("")
		|| request.getParameter("scheduleTime") == null || request.getParameter("scheduleTime").equals("")
		|| request.getParameter("scheduleColor") == null || request.getParameter("scheduleColor").equals("")
		|| request.getParameter("scheduleMemo") == null || request.getParameter("scheduleMemo").equals("")
		|| request.getParameter("schedulePw") == null || request.getParameter("schedulePw").equals("")){
		response.sendRedirect("./scheduleList.jsp");
		return;
	}
			
	// 요청값 받아오기
	String scheduleDate = request.getParameter("scheduleDate");
	String scheduleTime = request.getParameter("scheduleTime");
	String scheduleColor = request.getParameter("scheduleColor");
	String scheduleMemo = request.getParameter("scheduleMemo");
	String schedulePw = request.getParameter("schedulePw");
	
	//디버깅
	System.out.println(scheduleDate + " <--insertScheduleAction param scheduleDate");
	System.out.println(scheduleTime + " <--insertScheduleAction param scheduleTime");
	System.out.println(scheduleColor + " <--insertScheduleAction param scheduleColor");
	System.out.println(scheduleMemo + " <--insertScheduleAction param scheduleMemo");
	System.out.println(schedulePw + " <--insertScheduleAction param schedulePw");

	// 마리아DB에 데이터 추가하기
	// 드라이버로딩한다
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("insertScheduleAction 드라이버로딩 성공"); // 드라이버로딩 확인완료
	// DB접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	System.out.println(conn + " <--insertScheduleAction DB접속확인"); // 확인완료
	// 쿼리 작성하고 실행하여 마리아DB에 데이터 저장
	/*
	insert into schedule (schedule_date, schedule_time, schedule_memo, schedule_color, createdate, updatedate)
	values (?, ?, ?, ?, now(), now())
	*/
	String sql = "insert into schedule (schedule_date, schedule_time, schedule_memo, schedule_color, schedule_pw, createdate, updatedate) values (?, ?, ?, ?, ?, now(), now())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	// ? 채워서 쿼리문 완성하기(?는 총5개)
	stmt.setString(1, scheduleDate);
	stmt.setString(2, scheduleTime);
	stmt.setString(3, scheduleMemo);
	stmt.setString(4, scheduleColor);
	stmt.setString(5, schedulePw);
	System.out.println(stmt + " <--insertScheduleAction stmt:완성된 쿼리문"); // 확인완료
	// 쿼리 실행하고 영향받은 행 수로 성공여부확인(0: 실패, 1: 성공)
	int row = stmt.executeUpdate();
	if(row==1){
		System.out.println(row + " <--정상입력"); // 결과: 1(성공)
	} else {
		System.out.println(row + " <--비정상입력");
	}
	// 이 페이지에서는 결과를 출력하지 않기 때문에 ResultSet에 저장할 필요가 없다.
	
	// scheduleListByDate로 다시 값을 보내기 위해서 스케줄날짜(yyyy-mm-dd)에서 년도, 월, 날짜를 추출한다
	String y = scheduleDate.substring(0,4);
	int m = Integer.parseInt(scheduleDate.substring(5,7))-1 ; // 자바 Calendar API에서는 월 0~11(1월~12월) -> 값에서 +1 해준다.
	String d = scheduleDate.substring(8);
	
	// 디버깅
	System.out.println(y + " <--insertScheduleAction y");
	System.out.println(m + " <--insertScheduleAction m");
	System.out.println(d + " <--insertScheduleAction d");
	
	// y, m, d값이 null이거나 공백이어도 scheduleListByDate로 넘긴다
	response.sendRedirect("./scheduleListByDate.jsp?y="+y+"&m="+m+"&d="+d);
%>