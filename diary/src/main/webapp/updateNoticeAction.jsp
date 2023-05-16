<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %><!-- java.sql에 들어있는 모든 클래스 -->
<%
	// 1. request 인코딩 설정
	request.setCharacterEncoding("utf-8");	
	
	// 2. 4개의 값을 확인(디버깅)
	System.out.println(request.getParameter("noticeNo") + " <--updateNoticeAction.jsp param noticeNo"); // 디버깅 결과: 
	System.out.println(request.getParameter("noticeTitle") + " <--updateNoticeAction.jsp param noticeTitle");
	System.out.println(request.getParameter("noticeContent") + " <--updateNoticeAction.jsp param noticeContent");
	System.out.println(request.getParameter("noticePw") + " <--updateNoticeAction.jsp param noticePw");

	// 3. 2번에서 받은 값에 대한 유효성검정 -> 잘못된 결과 -> 분기 -> 리다이렉션(updateNoticeForm.jsp?noticeNo=&msg=) ->코드진행종료(return)
	// 리다이렉션: 액션을 요청한 웹브라우저에게 다른 곳을 요청하라고 말하는 것
	// ||(or)연산은 앞의 조건이 참이면 뒤의 조건을 실행하지 않는다 -> null 조건이 앞에 온다
	// noticeNo가 null이면 리스트로 다이렉션한다
	if(request.getParameter("noticeNo") == null) {
		response.sendRedirect("./noticeList.jsp");
		return;
	}
	
	String msg = null;
	// request.getParameter("noticeNo")가 null이거나 공백일 가능성이 없으므로 유효성 검사에서 제외한다.
	if(request.getParameter("noticeTitle")==null
			|| request.getParameter("noticeTitle").equals("")) {
		msg = "noticeTitle is required";
	} else if (request.getParameter("noticeContent")==null
			|| request.getParameter("noticeContent").equals("")) {
		msg = "noticeContent is required";
	} else if (request.getParameter("noticePw")==null
			|| request.getParameter("noticePw").equals("")) {
		msg = "noticePw is required";
	}
	// 위의 유효성 검사에서 msg가 있어 (ifelse문에 하나라도 해당)이 되는 경우 본래 메시지와 함께 본래 수정폼으로 리다이렉션
	if(msg != null) {
		response.sendRedirect("./updateNoticeForm.jsp?noticeNo="
								+request.getParameter("noticeNo")
								+"&msg="+msg);
		return;
	}
	
	// 4. 요청값들을 변수에 할당
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	String noticeTitle = request.getParameter("noticeTitle");
	String noticeContent = request.getParameter("noticeContent");
	String noticePw = request.getParameter("noticePw");
	System.out.println(noticeNo + " <--updateNoticeAction noticeNo");
	System.out.println(noticeTitle + " <--updateNoticeAction noticeTitle");
	System.out.println(noticeContent + " <--updateNoticeAction noticeContent");
	System.out.println(noticePw + " <--updateNoticeAction noticePw");
	
	// 5. MariaDB RDBMS에 update문을 전송한다
	//(1) 드라이버로딩
	Class.forName("org.mariadb.jdbc.Driver");
	// 디버깅: 드라이버로딩이 되었는지 확인
	System.out.println("드라이버로딩성공");	
	//(2) DB에 접속하기
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	// 디버깅
	System.out.println(conn + " <-- updateNoticeAction conn: DB접속확인");
	//(3) 쿼리생성
	/*
		UPDATE notice
		SET notice_title = ?, notice_content = ?, updatedate=now()
		WHERE notice_no = ? AND notice_pw = ?
	*/
	String sql = "UPDATE notice SET notice_title = ?, notice_content = ?, updatedate=now() WHERE notice_no = ? AND notice_pw = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	// ?채워서 쿼리문 완성하기: ?는 4개(1~4)
	stmt.setString(1, noticeTitle);
	stmt.setString(2, noticeContent);
	stmt.setInt(3, noticeNo);
	stmt.setString(4, noticePw);
	// 디버깅: 완성된 쿼리문 확인
	System.out.println(stmt + " <--updateNoticeAction stmt: 완성된 update문");
	// 쿼리를 실행하고 영향받은 행의 수를 row변수에 저장한다
	int row = stmt.executeUpdate(); //쿼리문이 적용된 행의 수
	// 디버깅: 쿼리문이 잘 적용되었는지 확인
	System.out.println(row + " <--updateNoticeAction rs: 영향받은 행의 수");
	
	// 6. 5번의 결과에 따라 페이지(view)를 분기한다
	if(row == 0) {
		response.sendRedirect("./updateNoticeForm.jsp?noticeNo="
				+noticeNo
				+"&msg=Check your password");
	} else if (row == 1) {
		response.sendRedirect("./noticeOne.jsp?noticeNo="+noticeNo+"&msg=The post has been edited");
	} else {
		// update문 실행을 취소(rollback)해야한다
		System.out.println("error row값 : "+row);
	}
	
%>