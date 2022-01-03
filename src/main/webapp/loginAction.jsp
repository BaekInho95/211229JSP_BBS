<%@page import="java.nio.channels.SeekableByteChannel"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>
<%@ page import="java.io.PrintWriter" %>
<!-- PrintWriter : 자바스크립트의 문장을 사용하기위해 -->
<% request.setCharacterEncoding("UTF-8"); %>
<!-- 건너오는 모든 데이터를 UTF-8로 만들어줌 -->
<jsp:useBean id="user" class="user.User" scope="page"/>
<!-- 자바 빈즈를 사용함 -->
<jsp:setProperty name="user" property="userID"/>
<jsp:setProperty name="user" property="userPassword"/>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html"; charset="UTF-8">
<title>JPS 게시판 웹사이트</title>
</head>
<body>

<!-- 로그인 액션 페이지 : 실질적인 사용자의 로그인 시도를 처리하는 페이지 -->
		<%
			String userID = null;
			if(session.getAttribute("userID") != null){
				userID = (String) session.getAttribute("userID");
			}
			/* 세션값을 비교해서 이미 로그인을 한 사람이 로그인 하는 것을 막는다 */
			if (userID != null){
				PrintWriter script  = response.getWriter();
				script.println("<script>");
				script.println("alert('이미 로그인이 되어있습니다.')");
				script.println("location.href = 'main.jsp'");
				script.println("</script>");
			}
			UserDAO userDAO = new UserDAO();
			int result = userDAO.login(user.getUserID(), user.getUserPassword());
			/* login 메서드를 사용하여 result에 값을 담는다 */
			if (result == 1){
				//세션 부여하기
				session.setAttribute("userID", user.getUserID());
				PrintWriter script  = response.getWriter();
				//스크립트 문장을 만들어줌
				script.println("<script>");
				script.println("location.href = 'main.jsp'");
				script.println("</script>");
			}else if (result == 0){
				PrintWriter script  = response.getWriter();
				script.println("<script>");
				script.println("alert('비밀번호가 틀립니다.')");
				script.println("history.back()");
				//이전 페이지로 돌아간다.
				script.println("</script>");
			}else if (result == -1){
				PrintWriter script  = response.getWriter();
				script.println("<script>");
				script.println("alert('존재하지 않는 아이디입니다.')");
				script.println("history.back()");
				script.println("</script>");
			}else if (result == -2){
				PrintWriter script  = response.getWriter();
				script.println("<script>");
				script.println("alert('데이터베이스 오류가 발생했습니다.')");
				script.println("history.back()");
				script.println("</script>");
			}
		%>
	
</body>
</html>