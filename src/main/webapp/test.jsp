<%@page import="com.myweb.board.commons.PageVO"%>
<%@page import="com.myweb.board.model.BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

	<%--
		for(int i=1; i<=300; i++){
			String writer = "김테스트" + i;
			String title = "테스트 입니다." + i;
			String content = "테스트 중이니까 조용히 하세요!" + i;
			BoardDAO.getInstance().regist(writer, title, content);
		}
	
	--%>
	
	<%--
	 *** 페이징 알고리즘 만들기 ***

# 1. 사용자가 보게 될 페이지 화면
- 한 화면에 페이지 버튼을 10개씩 끊어서 보여 준다면?
ex) 1 2 3 4 ... 9 10 [다음]  [이전] 31 32 33 .... 39 40 [다음]

- 만약에 총 게시물의 수가 67개라면?
1 2 3 4 5 6 7

- 총 게시물의 수가 142개이고, 현재 사용자가 12페이지를 클릭했다면?
[이전] 11 12 13 14 15  

#. 2. 우선 총 게시물의 개수를 조회해야 합니다.
- 총 게시물 수는 DB로부터 수를 조회하는 SQL문을 작성합니다.

# 3. 사용자가 현재 위치하는 페이지를 기준으로
 끝 페이지 번호를 계산하는 로직을 작성.

- 만약 현재 사용자가 보고 있는 페이지가 3페이지고,
 한 화면에 보여줄 페이지 버튼이 10개라면?
-> 끝 페이지 번호: 10번
- 만약 현재 페이지가 36페이지이고, 한 화면에 보여줄 페이지 수가
 20개라면?
-> 끝 페이지 번호: 40번

공식: Math.ceil(현재 위치한 페이지 번호 / 한 화면에 보여줄 페이지 버튼 수)
		* 한 화면에 보여줄 페이지 버튼 수

# 4. 시작 페이지 번호 계산하기
- 현재 위치한 페이지가 15번이고, 한 화면에 보여줄 페이지 버튼이 10개라면?
-> 시작 페이지 번호: 11번

- 현재 위치한 페이지가 73페이지고, 한 화면에 버튼 20개씩 배치한다면?
-> 시작 페이지 번호: 61번

공식: (끝 페이지 번호 - 한 화면에 보여줄 페이지 버튼 수) + 1

# 5. 끝 페이지 보정 및 이전/다음 버튼 배치 여부 파악

- 총 게시물 수가 324개이고, 한 페이지당 10개의 게시물을 보여준다.
- 그리고 이 사람은 현재 31페이지를 보고 있다.
- 그리고 한 화면에 페이지 버튼은 10개씩 배치된다.
- 그렇다면, 위 공식에 의한 끝 페이지 번호는 몇 번으로 계산되는가? -> 40번
- 하지만, 실제 끝 페이지 번호는 몇 번에서 끝나야 하는가? -> 33번

# 5-1. 이전 버튼 활성화 여부 파악
공식: 시작 페이지 번호가 1로 구해진 시점에서는 비활성, 나머지는 활성 처리.

# 5-2. 다음 버튼 활성화 여부 파악
공식: 보정 전 끝 페이지 번호 x 한 페이지에 들어갈 게시물 수 >= 총 게시물 수
      -> 비활성, 나머지는 활성.

# 5-3. 끝 페이지 보정
- 다음 버튼이 비활성화 되었다면 총 게시물 수에 맞춰 끝 페이지 번호를
재 보정합니다.
공식: Math.ceil(총 게시물 개수 / 한 페이지에 보여줄 게시물 수)
	 
	 --%>

	<%
		int countArticles = BoardDAO.getInstance().countArticles();
		out.print("#총 게시물 수: " + countArticles + "개 <br>");
		out.print("------------------------------------<br>");
	    
		//끝 페이지 번호 계산 테스트
		PageVO paging = new PageVO();
		paging.setPage(12);
		paging.setCpp(20);
		int displayBtn = 6;
		
		int endPage = (int)Math.ceil(paging.getPage() / (double)displayBtn) * displayBtn;
		out.print("끝 페이지 번호: " + endPage + "번 <br>");
		
		//시작 페이지 번호 계산 테스트
		int beginPage = (endPage - displayBtn) + 1;
		out.print("시작 페이지 번호: " + beginPage + "번 <br>");
		
		//이전 버튼 활성, 비활성
		
		boolean isPrev = (beginPage == 1) ? false : true;
		out.print("이전 버튼 활성화 여부: " + isPrev + "<br>");
		
		//다음 버튼 활성, 비활성
		
		boolean isNext = (countArticles <= (endPage * paging.getCpp())) ? false : true;
		out.print("다음 버튼 활성화 여부: " + isNext + "<br>");
		
		//끝 페이지 보정
		if(!isNext) { //isNext == false
			endPage = (int)Math.ceil(countArticles / (double)paging.getCpp());
		}
		
		out.print("보정 후 끝 페이지 번호: " + endPage + "번");
	%>

</body>
</html>