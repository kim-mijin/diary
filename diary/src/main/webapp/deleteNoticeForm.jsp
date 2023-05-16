<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 요청값 인코딩
	request.setCharacterEncoding("utf-8");
	
	// 요청값에 대한 유효성 검사 (request parameter validation)
	if(request.getParameter("noticeNo") == null) {
		response.sendRedirect("./noticeList.jsp");
		return; // 리다이렉션 후 코드진행종료
	}
	
	// 요청값 null이 아니면 받아서 변수에 저장
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	// 요청값 NoticeNo 디버깅
	System.out.println(noticeNo + " <-- deleteNoticeForm param noticeNo"); 
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>deleteNoticeForm</title>
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
		
	<h1>공지 삭제</h1>
		<!-- 비밀번호 틀려 리다이렉션 되면 메시지 출력 -->
		<div class="bg-danger text-white">
		<%
			if(request.getParameter("msg") != null){
		%>
				<%=request.getParameter("msg")%>
		<%
			}
		%>
		</div>
		<form action="./deleteNoticeAction.jsp" method="post">
			<table class="table-bordered">
				<tr><!-- 1행 -->
					<td>notice_no</td>
					<td>
						<input type="text" name="noticeNo" value="<%=noticeNo%>" readonly="readonly">
						<!-- 
						noticeNo가 안보이게 하는 방법
						<input type="hidden" name="noticeNo" value="<%=noticeNo%>">
						-->
					</td>
				</tr>
				<tr><!-- 2행 -->
					<td>notice_pw</td>
					<td>
						<input type="password" name="noticePw"> 
					</td>
				</tr>
				<tr><!-- 3행: 삭제버튼 -->
					<td colspan="2">
						<button type="submit" class="btn btn-info">삭제</button>
					</td>
					<!-- <td></td> -->
				</tr>
			</table>
		</form>
	</div>
</body>
</html>