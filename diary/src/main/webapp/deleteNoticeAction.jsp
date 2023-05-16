<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.Connection" %>
<%@ page import = "java.sql.DriverManager" %>
<%@ page import = "java.sql.PreparedStatement" %>

<%
	// 요청값 인코딩
	request.setCharacterEncoding("utf-8");
	
	// 요청값에 대한 유효성 검사 (request parameter validation)
	// NoticeNo과 NoticePw가 null이거나 공백이면 리다이렉션 후 종료
	if(request.getParameter("noticeNo") == null
			|| request.getParameter("noticePw") == null
			|| request.getParameter("noticeNo").equals("")
			|| request.getParameter("noticePw").equals("")) {
		
		response.sendRedirect("./noticeOne.jsp");
		return; 
	}	
			
	// 요청값 받으면 변수에 저장
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	String noticePw =  request.getParameter("noticePw");
	// 요청값 디버깅
	System.out.println(noticeNo + "<--deleteNoticeAction param noticeNo");
	System.out.println(noticePw + "<--deleteNoticeAction param noticePw");
	
	// DB에 저장
	//delete from notice where notice_no = ? and notice_pw = ?
	// 드라이버로딩
	Class.forName("org.mariadb.jdbc.Driver"); 
	// DB접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	// 쿼리 생성
	String sql = "delete from notice where notice_no = ? and notice_pw = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, noticeNo);
	stmt.setString(2, noticePw);
	// stmt 완성되었는지 디버깅
	System.out.println(stmt + "<-- deleteNoticeAction sql");
	
	int row = stmt.executeUpdate();
	// 삭제되었는지 디버깅
	System.out.println(row + "<--deleteNoticeAction row");
	
	// 비밀번호 틀리면 리다이렉션
	String msg = null;
	if (row == 0) { // 비밀번호 틀려서 삭제된 행이 0행
		msg = "Check your password"; 
		response.sendRedirect("./deleteNoticeForm.jsp?noticeNo="+noticeNo+"&msg="+msg);
		// response.sendRedirect("./noticeOne.jsp?noticeNo="+noticeNo);
	} else {
		msg = "The post has been deleted";
		response.sendRedirect("./noticeList.jsp?msg="+msg);
	}
%>