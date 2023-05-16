<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>insertNoticeForm</title>
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
		
		<h1>공지 입력</h1>
		<!-- 항목 입력 안하면 메시지 -->
		<div class="bg-danger text-white">
		<%
			if(request.getParameter("msg") != null){
		%>
				<%=request.getParameter("msg")%>
		<%
			}
		%>
		</div>
		<form action="./insertNoticeAction.jsp" method="post">
			<table class="table table-bordered">
				<tr>
					<th class="text-center">notice_title</th>
					<td>
						<input type="text" name="noticeTitle">
					</td>
				</tr>
				<tr>
					<th class="text-center">notice_content</th>
					<td>
						<textarea rows="5" cols="80" name="noticeContent"></textarea>
					</td>
				</tr>
				<tr>
					<th class="text-center">notice_writer</th>
					<td>
						<input type="text" name="noticeWriter">
					</td>
				</tr>
				<tr>
					<th class="text-center">notice_pw</th>
					<td>
						<input type="password" name="noticePw">
					</td>
				</tr>
				<tr>
					<th colspan="2">
						<button type="submit" class="btn btn-info">입력</button>
					</th>
					<!-- <td></td>-->
				</tr>
			</table>
		</form>
	</div>
</body>
</html>