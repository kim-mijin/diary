<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	//요청값 인코딩
	request.setCharacterEncoding("utf-8");

	// noticeNo 유효성 검사
	if(request.getParameter("scheduleNo") == null) {
		response.sendRedirect("./scheduleList.jsp");
		return;
	}

	// scheduleNo가 null이 아닌경우에는 해당 값을 변수에 저장한다
	String scheduleNo = request.getParameter("scheduleNo");
	// 유효성 검사: noticeNo를 제외한 요청값이 null이거나 공백이면 메시지와 함께 updateScheduleForm으로 돌아가고 코드진행 종료
	String msg = null;
	if(request.getParameter("scheduleDate") == null || request.getParameter("scheduleDate").equals("")
		|| request.getParameter("scheduleTime") == null || request.getParameter("scheduleTime").equals("")
		|| request.getParameter("scheduleColor") == null || request.getParameter("scheduleColor").equals("")
		|| request.getParameter("scheduleMemo") == null || request.getParameter("scheduleMemo").equals("")
		|| request.getParameter("schedulePw") == null || request.getParameter("schedulePw").equals("")){	
		
		msg = "Fill out the form";
		response.sendRedirect("./updateScheduleForm.jsp?scheduleNo="+scheduleNo+"&msg="+msg);
		return;
	} // 자꾸 에러가 난 부분;;; 
	
	// 나머지 요청값을 변수에 저장
	String scheduleDate = request.getParameter("scheduleDate");
	String scheduleTime = request.getParameter("scheduleTime");
	String scheduleColor = request.getParameter("scheduleColor");
	String scheduleMemo = request.getParameter("scheduleMemo");
	String schedulePw = request.getParameter("schedulePw");
	
	//디버깅
	System.out.println(scheduleNo + " <--updateScheduleAction param scheduleNo");
	System.out.println(scheduleDate + " <--updateScheduleAction param scheduleDate");
	System.out.println(scheduleTime + " <--updateScheduleAction param scheduleTime");
	System.out.println(scheduleColor + " <--updateScheduleAction param scheduleColor");
	System.out.println(scheduleMemo + " <--updateScheduleAction param scheduleMemo");
	System.out.println(schedulePw + " <--updateScheduleAction param schedulePw");

	// mariaDB에 데이터 업데이트
	// 드라이버로딩한다
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("insertScheduleAction 드라이버로딩 성공"); // 드라이버로딩 확인완료
	// DB접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	System.out.println(conn + " <--insertScheduleAction DB접속확인"); // 확인완료
	// 쿼리 작성하고 실행하여 마리아DB에 데이터 저장
	/*
		update schedule
		set schedule_date=?, schedule_time=?, schedule_memo=?, schedule_color=?, updatedate = now() where notice_no = ? and notice_pw=?
	*/
	String sql = "update schedule set schedule_date=?, schedule_time=?, schedule_memo=?, schedule_color=?, updatedate = now() where schedule_no = ? and schedule_pw=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	// ? 채워서 쿼리문 완성하기(?는 총6개)
	stmt.setString(1, scheduleDate); // stmt의 첫번째 ?에 String타입인 scheduleDate를 넣는다
	stmt.setString(2, scheduleTime);
	stmt.setString(3, scheduleMemo);
	stmt.setString(4, scheduleColor);
	stmt.setString(5, scheduleNo);
	stmt.setString(6, schedulePw);
	System.out.println(stmt + " <--insertScheduleAction stmt:완성된 쿼리문"); // 확인완료
	// 쿼리 실행하고 영향받은 행 수로 성공여부를 확인 할 수 있다.(0: 실패, 1: 성공)
	int row = stmt.executeUpdate();
	if(row==1){ // 
		msg = "The post has been edited";
		System.out.println(row + " <--updateScheduleAction 수정성공"); // 결과: 1(성공)
	} else {
		msg = "Check your password to edit the post";
		System.out.println(row + " <--updateScheduleAction 수정실패"); // 결과가 0이거나(실패) 2이상(데이터에 입력보다 더 많은 영향이 간 것이므로 추후에 rollback을 해야한다)
	}
	
	// scheduleListByDate로 다시 값을 보내기 위해서 스케줄날짜(yyyy-mm-dd)에서 년도, 월, 날짜를 추출한다
	String y = scheduleDate.substring(0,4);
	int m = Integer.parseInt(scheduleDate.substring(5,7))-1 ; // 자바 Calendar API에서는 월 0~11(1월~12월) -> 값에서 +1 해준다.
	String d = scheduleDate.substring(8);
	
	// 디버깅
	System.out.println(y + " <--insertScheduleAction y");
	System.out.println(m + " <--insertScheduleAction m");
	System.out.println(d + " <--insertScheduleAction d");
	
	// y, m, d값이 null이거나 공백이어도 scheduleListByDate로 넘긴다
	response.sendRedirect("./scheduleListByDate.jsp?y="+y+"&m="+m+"&d="+d+"&msg="+msg);

%>