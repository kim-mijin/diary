<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.Connection" %>
<%@ page import = "java.sql.DriverManager" %>
<%@ page import = "java.sql.PreparedStatement" %>

<%
	// 요청값 인코딩
	request.setCharacterEncoding("utf-8"); 
	
	// validation (요청 파라미터값 유효성 검사) // 요청값이 null이거나 공백이면 입력폼으로 리다이렉션
	String msg = null;
	if(request.getParameter("noticeTitle") == null
			|| request.getParameter("noticeContent") == null 
			|| request.getParameter("noticeWriter") == null
			|| request.getParameter("noticePw") == null
			|| request.getParameter("noticeTitle").equals("")
			|| request.getParameter("noticeContent").equals("") 
			|| request.getParameter("noticeWriter").equals("")
			|| request.getParameter("noticePw").equals("")) {
		msg = "Fill out the form";
		response.sendRedirect("./insertNoticeForm.jsp?msg="+msg);
		return; // 코드진행종료
	}
	// 파라미터값이 null이나 공백이 아닌 경우 변수 저장
	String noticeTitle = request.getParameter("noticeTitle");
	String noticeContent = request.getParameter("noticeContent");
	String noticeWriter = request.getParameter("noticeWriter");
	String noticePw = request.getParameter("noticePw");
	
	// 요청값 확인용 디버깅 코드
	System.out.println(noticeTitle + "<--insertNoticeAction param noticeTitle");
	System.out.println(noticeContent + "<--insertNoticeAction param noticeContent");
	System.out.println(noticeWriter + "<--insertNoticeAction param noticeWriter");
	System.out.println(noticePw + "<--insertNoticeAction param noticePw");
	
	// 값들을 DB 테이블 입력
	/*
		insert into notice (notice_title, notice_content, notice_writer, notice_pw, createdate, updatedate)
		values (?, ?, ?, ?, now(), now())
	*/
	// 1) 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver"); // Class.forName는 static메소드
	// 2) MariaDB접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	// 3) 쿼리생성
	String sql = "insert into notice (notice_title, notice_content, notice_writer, notice_pw, createdate, updatedate) values (?, ?, ?, ?, now(), now())";
	PreparedStatement stmt = conn.prepareStatement(sql); // 문자열을 실제 MariaDB가 실행 가능한 쿼리로 변환
	// ? 채워서 쿼리문 완성: 4개(1~4)
	stmt.setString(1, noticeTitle);
	stmt.setString(2, noticeContent);
	stmt.setString(3, noticeWriter);
	stmt.setString(4, noticePw);
	// stmt 디버깅
	System.out.println(stmt + " <--insertNoticeAction stmt: 완성된 쿼리문");
	int row = stmt.executeUpdate(); // 디버깅: 값이 1행 이상이면 입력성공, 0이면 입력된 행이 없다
	// conn.setAutoCommit(true); default값이 true이므로 executeUpdate혹은 executeQuery하면 자동커밋됨 ->커밋생략가능
	// conn.commit(); // 자동커밋이 false일 경우 commit필요
	// row값을 이용한 디버깅
	if(row == 1){
		System.out.println(row + " <--insertNoticeAction param row: 입력성공");
	} else {
		System.out.println(row + " <--insertNoticeAction param row: 입력실패");
	}
	
	// 입력실패, 성공 상관없이 입력 마치고 noticeList로 리다이렉션
	response.sendRedirect("./noticeList.jsp");
%>
