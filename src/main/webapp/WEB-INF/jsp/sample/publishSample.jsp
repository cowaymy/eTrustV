<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<script type="text/javaScript">

$(function(){
	//doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'S' , 'f_multiCombo'); //Single COMBO => Choose One
	//doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'A' , 'f_multiCombo'); //Single COMBO => ALL
	//doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'M' , 'f_multiCombo'); //Multi COMBO
	// f_multiCombo 함수 호출이 되어야만 multi combo 화면이 안깨짐.
	doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'S' , 'fn_multiCombo');	
});

function fn_multiCombo(){
	$('#cmbCategory').change(function() {
	    //console.log($(this).val());
	}).multipleSelect({
	    selectAll: true, // 전체선택 
	    width: '100%'
	});            
}

</script>

<div id="content"><!-- content start -->
	<ul class="path">
	    <li><img src="${pageContext.request.contextPath}/resources/image/path_home.gif" alt="Home" /></li>
	    <li>Sales</li>
	    <li>Order list</li>
	</ul>

	<div class="title_line"><!-- title_line start -->
		<p class="fav"><img src="${pageContext.request.contextPath}/resources/image/icon_star.gif" alt="즐겨찾기" /></p>
		<h2>Commission Rule Book Management</h2>
		<ul class="right_opt">
		    <%@ include file="/WEB-INF/jsp/common/contentButton.jsp" %>
		</ul>
	</div><!-- title_line end -->
	
	<div class="search_table"><!-- search_table start -->
	<form action="#" method="post">
	
	<table summary="search table" class="type1"><!-- table start -->
		<caption>search table</caption>
		<colgroup>
		    <col style="width:80px" />
		    <col style="width:*" />
		    <col style="width:110px" />
		    <col style="width:*" />
		    <col style="width:100px" />
		    <col style="width:*" />
		</colgroup>
		<tbody>
			<tr>
			    <th scope="row">기준년월</th>
			    <td>
			    <select class="w100p">
			        <option value="">Active</option>
			    </select>
			    </td>
			    <th scope="row">ORG Group</th>
			    <td>
			    <select class="w100p" id="cmbCategory">
			    </select>
			    </td>
			    <th scope="row">ORG Code</th>
			    <td>
			    <select class="w100p">
			        <option value="">--Payment Key-in</option>
			    </select>
			    </td>
			</tr>
		</tbody>
	</table><!-- table end -->
	
	<ul class="right_btns">
	    <li><p class="btn_gray"><a href="#"><span class="search"></span>Search</a></p></li>
	</ul>
	</form>
	
	</div><!-- search_table end -->
	
	<div class="search_result"><!-- search_result start -->
		<ul class="right_btns">
		    <li><p class="btn_grid"><a href="#"><span class="search"></span>EXCEL UP</a></p></li>
		    <li><p class="btn_grid"><a href="#"><span class="search"></span>EXCEL DW</a></p></li>
		    <li><p class="btn_grid"><a href="#"><span class="search"></span>DEL</a></p></li>
		    <li><p class="btn_grid"><a href="#"><span class="search"></span>INS</a></p></li>
		    <li><p class="btn_grid"><a href="#"><span class="search"></span>ADD</a></p></li>
		</ul>
		
		<div class="grid_wrap"><!-- grid_wrap start -->
		그리드 영역
		</div><!-- grid_wrap end -->
	
	</div><!-- search_result end -->

</div><!-- content end -->
        
