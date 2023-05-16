<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	//요청값 인코딩
	request.setCharacterEncoding("utf-8");

	// 요청값 받아오기
	String scheduleNo = request.getParameter("scheduleNo");
	String schedulePw = request.getParameter("schedulePw");
	
	// 유효성검사: 요청값이 null이거나 공백이면 scheduleList로 리다이렉션 후 코드진행종료
	if(request.getParameter("scheduleNo") == null || request.getParameter("scheduleNo").equals("")
		|| request.getParameter("schedulePw") == null || request.getParameter("schedulePw").equals(""))	{
		response.sendRedirect("./scheduleList.jsp");
		return;
	}
	
	//디버깅
	System.out.println(scheduleNo + " <--deleteScheduleAction param scheduleNo");
	System.out.println(schedulePw + " <--deleteScheduleAction param schedulePw");

	// mariaDB에서 데이터 삭제
	// 드라이버로딩한다
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("insertScheduleAction 드라이버로딩 성공"); // 드라이버로딩 확인완료
	// DB접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	System.out.println(conn + " <--insertScheduleAction DB접속확인"); // 확인완료
	// 쿼리 작성하고 실행하여 마리아DB에 데이터 저장
	/*
	delete from schedule
	where schedule_no = ? and schedule_pw=?
	*/
	String sql = "delete from schedule where schedule_no = ? and schedule_pw=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	// ?채우기
	stmt.setString(1, scheduleNo);
	stmt.setString(2, schedulePw);
	System.out.println(stmt + " <--deleteScheduleAction stmt:완성된 쿼리문"); // 확인완료
	// 쿼리 실행하고 영향받은 행 수로 성공여부확인(0: 실패, 1: 성공)
	int row = stmt.executeUpdate();    
	String msg = null;
	if(row==1){
		System.out.println(row + " <--deleteScheduleAction 삭제성공");
		msg = "The post has been deleted";
	} else { 
		System.out.println(row + " <--deleteScheduleAction 삭제실패"); // 쿼리실행 후 영향받은 행이 0이거나 2이상
		msg = "Check your password to delete the post";
	}

	// scheduleList로 리다이렉션
	response.sendRedirect("./scheduleList.jsp?msg="+msg);

%>