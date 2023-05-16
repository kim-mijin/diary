<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>

<%
	// 요청 분석(currentPage, lastPage,...)
	// 현재페이지
	int currentPage = 1; // currentPage의 초기값 1
	if(request.getParameter("currentPage") != null) { // currnetPage의 값이 null이 아니면 해당 page값을 currentPage에 저장
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	System.out.println(currentPage + "<--currentPage"); // 디버깅
	
	// 페이지당 출력할 행의 수
	int rowPerPage = 10;
	
	// 시작 행 번호
	int startRow = (currentPage-1)*rowPerPage;
	/*
		currentPage		startRow(rowPerPage가 10일때)
		1				0 <-- (currentPage-1)*rowPerPage
		2				10
		3				20
		4				30
	*/
	
	// DB연결설정 추가
	// select notice_no noticeNo, notice_title noticeTitle, createdate from notice 
	// order by createdate desc -> 디폴트값
	// limit ?, ?
	
	// 1) 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver"); // Class.forName는 static메소드
	// 2) MariaDB접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	// 3) 쿼리생성
	
	// 컬럼별 오름차순, 내림차순 만들기 -> 정렬의 기준이 되는 컬럼과 오름/내림차순을 변수로 만들어 값을 받아온다
	String col = "createdate";
	String ascDesc = "DESC"; 
	// col과 ascDesc의 요청값이 둘다 null이 아닌 경우에는 요청값이 들어가고, 하나라도 null이면 디폴트값이 들어간다
	if(request.getParameter("col") != null && request.getParameter("ascDesc") !=null){
		col = request.getParameter("col");
		ascDesc = request.getParameter("ascDesc");
	}

	PreparedStatement stmt = conn.prepareStatement("select notice_no noticeNo, notice_title noticeTitle, notice_title, createdate from notice order by "+col+" "+ascDesc+" limit ?, ?"); // 문자열을 실제 MariaDB가 실행 가능한 쿼리로 변환
	stmt.setInt(1, startRow);
	stmt.setInt(2, rowPerPage);
	System.out.println(stmt + " <--stmt"); // 디버깅
	// 출력할 공지 데이터
	ResultSet rs = stmt.executeQuery();	
	// ★★★자료구조 ResultSet타입을 일반적인 자료구조타입(자바 배열 or 기본API 자료구조타입(List, Set, Map))으로 바꿔야한다
	// Set은 순서가 없기 때문에 for문, foreach문을 사용할 수 없다 -> List로 바꿔준다
	// 한 행을 저장할 수 있는 클래스를 만들어 ArrayList로 만든다: ResultSet -> ArrayList<Notice>
	ArrayList<Notice> noticeList = new ArrayList<Notice>();
	while(rs.next()) { // rs.next()가 true인 동안 반복
		Notice n = new Notice();
		n.noticeNo = rs.getInt("noticeNo");
		n.noticeTitle = rs.getString("noticeTitle");
		n.createdate = rs.getString("createdate");
		noticeList.add(n); // 반복된 값들을 noticeList에 저장한다
	}
	
	// 마지막 페이지
	// select count(*) from notice;
	PreparedStatement stmt2 = conn.prepareStatement("select count(*) from notice");
	ResultSet rs2 = stmt2.executeQuery();
	
	int totalRow = 0; 
	if(rs2.next()) {
		totalRow = rs2.getInt("count(*)");
	}	
	int lastPage = totalRow / rowPerPage;
	// totalRow를 rowPerPage로 나누어 떨어지지 않으면 lastPage+1
	if(totalRow % rowPerPage != 0) {
		lastPage = lastPage + 1;
	}
	
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
		
		<!-- 날짜순으로 최근 공지 5개 -->
		<h1>공지사항 리스트</h1>
		
		<!-- 공지사항 입력하기 -->
		<a href="./insertNoticeForm.jsp" class="badge badge-info">공지입력</a>
		
		<!-- 리다이렉션되어 왔을때 메시지 표시 -->
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
					<th class="text-center">
						notice_title
						<a class="badge badge-info" href="./noticeList.jsp?col=notice_title&ascDesc=ASC">asc</a><!-- 클릭하면 현재페이지로 오면서 col, ascDesc값을 보낸다 -->
						<a class="badge badge-info" href="./noticeList.jsp?col=notice_title&ascDesc=DESC">desc</a><!-- 클릭하면 현재페이지로 오면서 col, ascDesc값을 보낸다 -->
					</th>
					<th class="text-center">
						createdate
						<a class="badge badge-info" href="./noticeList.jsp?col=notice_title&ascDesc=ASC">asc</a>
						<a class="badge badge-info" href="./noticeList.jsp?col=notice_title&ascDesc=DESC">desc</a>
					</th>
				</tr>
			</thead>
			<%
				for(Notice n : noticeList) { // noticeList안에 있는 Notice타입 출력(noticeList의 사이즈만큼)
			%>
				<tr><!-- 제목 클릭하면 상세 내용을 표시 -->
					<td>
						<a href="./noticeOne.jsp?noticeNo=<%=n.noticeNo%>"><!-- noticeNo값을 넘긴다 -->
							<%=n.noticeTitle%>
						</a>
					</td>
					<td>
						<%=n.createdate.substring(0, 10)%>
					</td> <!-- 시간을 제외한 날짜만 보여준다 -->
				</tr>
			<%
				}
			%>
		</table>
		
		<!-- 페이지번호 -->
		<div class="text-center">
		<%
			// 1페이지에서는 <이전> 표시 안함
			if(currentPage > 1) {
		%>
				<a href="./noticeList.jsp?currentPage=<%=currentPage-1%>" class="badge badge-info">이전</a>
		<%
			}
		%>
				<%=currentPage%>
		<%
			// 마지막페이지에서는 <다음> 표시 안함
			if(currentPage < lastPage) {
		%>
				<a href="./noticeList.jsp?currentPage=<%=currentPage+1%>" class="badge badge-info">다음</a>
		<%	
			}
		%>
		</div>
	</div>
</body>
</html>