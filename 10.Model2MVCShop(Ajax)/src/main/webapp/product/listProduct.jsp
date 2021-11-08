<%@ page contentType="text/html; charset=euc-kr"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- /////////////////////// EL / JSTL 적용으로 주석 처리 ////////////////////////

<%@ page import="java.util.List"%>

<%@ page import="com.model2.mvc.service.domain.Product"%>
<%@ page import="com.model2.mvc.common.Search"%>
<%@ page import="com.model2.mvc.common.Page"%>
<%@page import="com.model2.mvc.common.util.CommonUtil"%>

<%
List<Product> list= (List<Product>)request.getAttribute("list");
Page resultPage=(Page)request.getAttribute("resultPage");

Search search = (Search)request.getAttribute("search");
//==> null 을 ""(nullString)으로 변경
String searchCondition = CommonUtil.null2str(search.getSearchCondition());
String searchKeyword = CommonUtil.null2str(search.getSearchKeyword());
	
String menu = (String)request.getAttribute("menu");
%>  /////////////////////// EL / JSTL 적용으로 주석 처리 //////////////////////// --%>

<html>
<head>
<title>상품 목록조회</title>

<link rel="stylesheet" href="/css/admin.css" type="text/css">

<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
<script type="text/javascript">

		
//검색 / page 두가지 경우 모두 Form 전송을 위해 JavaScrpt 이용 
	function fncGetList(currentPage) {
		//document.getElementById("currentPage").value = currentPage;
		
		$("#currentPage").val(currentPage);
	   	//document.detailForm.submit();
		$("form").attr("method" , "POST").attr("action" , "/product/listProduct?menu=${param.menu}").submit();
		
	}


$(function(){

	$("td.ct_btn01:contains('검색')").on("click",function(){
		fncGetList(1);
	});
	
	//==> DOM Object GET 3가지 방법 ==> 1. $(tagName) : 2.(#id) : 3.$(.className)
	//==> 3 과 1 방법 조합 : $(".className tagName:filter함수") 사용함.
	$( ".ct_list_pop td:nth-child(3)").on("click" , function() {
			//Debug..
			//alert(  $( this ).text().trim() );
			var prodNo=$(this).data("prodno");
			console.log(prodNo);
			//self.location ="/product/getProduct?prodNo="+prodNo+"&menu="+menu;
			if(${param.menu.equals("search")}){
			$.ajax(
					{
						url : "/product/json/getProduct/"+prodNo,
						method : "GET",
						dataType : "json",
						headers : {
							"Accept" : "application/json",
							"Content-Type" : "application/json"							
						},
						success : function(JSONData, status){
							console.log(JSONData);
							var displayValue="<h3>"
											+"상품번호 : "+JSONData.prodNo+"<br/>"
											+"상품명 : "+JSONData.prodName+"<br/>"
											+"상품상세정보 : "+JSONData.prodDetail+"<br/>"
											+"제조일자 : "+JSONData.manuDate+"<br/>"
											+"가격 : "+JSONData.price+"<br/>"
											+"등록일자 : "+JSONData.regDateString+"<br/>"
											+"</h3>";
											
							//alert(JSONData.regDateString);
							
							$("h3").remove();
							$("#"+prodNo+"").html(displayValue);
						}					
					});
			}else{
				self.location ="/product/getProduct?prodNo="+prodNo+"&menu=manage";
			}
	});
	
	//==> UI 수정 추가부분  :  userId LINK Event End User 에게 보일수 있도록 
	$( ".ct_list_pop td:nth-child(3)" ).css("color" , "blue");
	$("h7").css("color" , "red");
	
	$(".ct_list_pop:nth-child(4n+6)" ).css("background-color" , "whitesmoke");
});
 
</script>
</head>

<body id="body" bgcolor="#ffffff" text="#000000" data-menu="${param.menu}">

<div style="width:98%; margin-left:10px;">

<form name="detailForm">

<table width="100%" height="37" border="0" cellpadding="0"	cellspacing="0">
	<tr>
		<td width="15" height="37">
			<img src="/images/ct_ttl_img01.gif" width="15" height="37"/>
		</td>
		<td background="/images/ct_ttl_img02.gif" width="100%" style="padding-left:10px;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="93%" class="ct_ttl01">
					<%-- /////////////////////// EL / JSTL 적용으로 주석 처리 ////////////////////////
				   <% if(menu.equals("manage")) { %>	
					상품 관리
					<% }else{ %>
					상품 목록조회
					<% } %>   /////////////////////// EL / JSTL 적용으로 주석 처리 //////////////////////// --%>
					<c:choose>
					<c:when test="${param.menu=='manage'}">
					상품관리
					</c:when>
					<c:otherwise>
					상품 목록조회
					</c:otherwise></c:choose>
					</td>
				</tr>
			</table>
		</td>
		<td width="12" height="37">
			<img src="/images/ct_ttl_img03.gif" width="12" height="37"/>
		</td>
	</tr>
</table>


<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>
		<td align="right">
			<select name="searchCondition" class="ct_input_g" style="width:80px">
			<%-- /////////////////////// EL / JSTL 적용으로 주석 처리 ////////////////////////
				<option value="0" <%= (searchCondition.equals("0") ? "selected" : "")%>>상품번호</option>
				<option value="1" <%= (searchCondition.equals("1") ? "selected" : "")%>>상품명</option>
				<option value="2" <%= (searchCondition.equals("2") ? "selected" : "")%>>가격</option>
				/////////////////////////// EL / JSTL 적용으로 주석 처리 //////////////////////// --%>
			<option value="0" ${ ! empty search.searchCondition && search.searchCondition==0 ? "selected" : "" }>
			상품번호</option>
			<option value="1" ${ ! empty search.searchCondition && search.searchCondition==1 ? "selected" : "" }>
			상품명</option>
			<option value="2" ${ ! empty search.searchCondition && search.searchCondition==2 ? "selected" : "" }>
			가격</option>
		
			</select>
		<input type="text" name="searchKeyword" 
						value="${! empty search.searchKeyword ? search.searchKeyword : ""}"  
						class="ct_input_g" style="width:200px; height:20px" > 

		</td>
	
		
		<td align="right" width="70">
			<table border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="17" height="23">
						<img src="/images/ct_btnbg01.gif" width="17" height="23">
					</td>
					<td background="/images/ct_btnbg02.gif" class="ct_btn01" style="padding-top:3px;">
						<!-- ////////////////// jQuery Event 처리로 변경됨 /////////////////////////
						<a href="javascript:fncGetProductList('1');">검색</a>
						////////////////////////////////////////////////////////////////// -->
					검색</td>
					<td width="14" height="23">
						<img src="/images/ct_btnbg03.gif" width="14" height="23">
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>


<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>
		<td colspan="11" >전체 ${resultPage.totalCount} 건수, 현재 ${resultPage.currentPage}페이지</td>
	</tr>
	<tr>
		<td class="ct_list_b" width="100">No</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">상품명<br>
		<h7>(상품명 click:상세정보)</h7>
		</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">가격</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">등록일</td>	
		<td class="ct_line02"></td>
		<td class="ct_list_b">현재상태</td>	
	</tr>
	<tr>
		<td colspan="11" bgcolor="808285" height="1"></td>
	</tr>
		<%-- /////////////////////// EL / JSTL 적용으로 주석 처리 ////////////////////////
	<%
	for(int i=0; i<list.size(); i++) {
		Product vo = (Product)list.get(i);
	%>
	<tr class="ct_list_pop">
		<td align="center"><%=i+1%></td> 
		<td></td>
		<td align="left">
		<%if(menu.equals("manage")) {%>
				<a href="/getProduct.do?prodNo=<%=vo.getProdNo()%>&menu=manage"><%= vo.getProdName() %>	
				<% }else{%>
				<a href="/getProduct.do?prodNo=<%=vo.getProdNo()%>&menu=search"><%= vo.getProdName() %>
				<%} %>
		</td>
		<td></td>
		<td align="left"><%= vo.getPrice() %></td>
		<td></td>
		<td align="left"><%= vo.getManuDate() %></td>
		<td></td>
		<td align="left">
		
			재고 없음
		
		</td>	
	</tr>
	<% } %>/////////////////////// EL / JSTL 적용으로 주석 처리 //////////////////////// --%>

	<c:set var="i" value="0"/>
	<c:forEach var="product" items="${list}">
		
		<c:set var="i" value="${ i+1 }" />
		<tr class="ct_list_pop">
		<td align="center">${ i }</td>
		<td></td>
		<td id ="menu" data-prodNo="${product.prodNo}" data-menu="${param.menu}">
		<c:choose>
		<c:when test="${param.menu=='manage'}">
		${product.prodName}	
		</c:when>
		<c:otherwise>
		${product.prodName}	
		</c:otherwise>
		</c:choose></td>
		<td></td>
		<td align="left">${product.price}</td>
		<td></td>
		<td align="left">${product.regDate}</td>
		<td></td>
		<td align="left">재고 없음</td>	
		<td></td>
	</tr>
	<tr>
	<td id="${product.prodNo}" colspan="11" bgcolor="D6D7D6" height="1"></td>
	</tr>

</c:forEach>

</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>
		<td align="center">
		<input type="hidden" id="currentPage" name="currentPage" value=""/>
		
	<%-- /////////////////////// EL / JSTL 적용으로 주석 처리 //////////////////////// 	
			<% if( resultPage.getCurrentPage() <= resultPage.getPageUnit() ){ %>
					◀ 이전
			<% }else{ %>
					<a href="javascript:fncGetUserList('<%=resultPage.getCurrentPage()-1%>')">◀ 이전</a>
			<% } %>

			<%	for(int i=resultPage.getBeginUnitPage();i<= resultPage.getEndUnitPage() ;i++){	%>
					<a href="javascript:fncGetUserList('<%=i %>');"><%=i %></a>
			<% 	}  %>
	
			<% if( resultPage.getEndUnitPage() >= resultPage.getMaxPage() ){ %>
					이후 ▶
			<% }else{ %>
					<a href="javascript:fncGetUserList('<%=resultPage.getEndUnitPage()+1%>')">이후 ▶</a>
			<% } %>
		/////////////////////// EL / JSTL 적용으로 주석 처리 //////////////////////// --%>	
			
	<jsp:include page="../common/pageNavigator.jsp"/>
    	
    	</td>
	</tr>
		
</table>
<!--  
<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>
		<td align="center">
		
			<a href="/listProduct.do?page=1&menu=search">1</a>
		
			<a href="/listProduct.do?page=2&menu=search">2</a>
		
			<a href="/listProduct.do?page=3&menu=search">3</a>
		
			<a href="/listProduct.do?page=4&menu=search">4</a>
		
			<a href="/listProduct.do?page=5&menu=search">5</a>
		
			<a href="/listProduct.do?page=6&menu=search">6</a>
		
    	</td>
	</tr>
</table>
-->
<!--  페이지 Navigator 끝 -->

</form>

</div>
</body>
</html>
