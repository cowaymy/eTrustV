<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<script type="text/javaScript">
var myGridID;

$(function(){
	//doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'S' , 'f_multiCombo'); //Single COMBO => Choose One
	//doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'A' , 'f_multiCombo'); //Single COMBO => ALL
	//doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'M' , 'f_multiCombo'); //Multi COMBO
	// f_multiCombo 함수 호출이 되어야만 multi combo 화면이 안깨짐.
	doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'S' , 'fn_multiCombo');	

	// AUIGrid 그리드를 생성합니다.
    myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, null, {pageRowCount : 10});

    fn_getSampleListAjax();
    
});

//AUIGrid 칼럼 설정
// 데이터 형태는 다음과 같은 형태임,
//[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
var columnLayout = [ {
        dataField : "id",
        headerText : "id",
        width : 120
    }, {
        dataField : "name",
        headerText : "Name",
        width : 120
    }, {
        dataField : "description",
        headerText : "description",
        width : 120
    }, {
        dataField : "product",
        headerText : "Product",
        width : 120
    }, {
        dataField : "color",
        headerText : "Color",
        width : 120
    }, {
        dataField : "price",
        headerText : "Price",
        dataType : "numeric",
        style : "my-column",
        width : 120
    }, {
        dataField : "quantity",
        headerText : "Quantity",
        dataType : "numeric",
        width : 120
    }, {
        dataField : "date",
        headerText : "Date",
        width : 120
    }];

//ajax list 조회.
function fn_getSampleListAjax() {        
    Common.ajax("GET", "/sample/selectJsonSampleList", $("#searchForm").serialize(), function(result) {
        console.log("성공.");
        console.log("data : " + result);
        AUIGrid.setGridData(myGridID, result);

        // 공통 메세지 영역에 메세지 표시.
        Common.setMsg("<spring:message code='sys.msg.success'/>");
    });
}

function fn_multiCombo(){
	$('#cmbCategory').change(function() {
	    //console.log($(this).val());
	}).multipleSelect({
	    selectAll: true, // 전체선택 
	    width: '100%'
	});            
}



/*  
## 공통 버튼 jsp : /WEB-INF/jsp/common/contentButton.jsp 내용##
 
    각 화면에서 클릭함수를 구현해 주어야 함.
    
    - button_id : 차후에 권한 관련 처리를 위해 버튼 id를 DB에 등록할 예정입니다.
    
    1) onclick javascript 형식 
        : onclick="fn_{button_id}();"
        
    2) sys_i18n 다국어 메세지 테이블 id.
        : sys.btn.{button_id}
 */

//공통 버튼 함수

function fn_save(){
	// 공통 메세지 영역에 메세지 표시.
	 Common.setMsg("<spring:message code='sys.btn.save'/>");
}

function fn_update(){
	// 공통 메세지 영역에 메세지 표시.
	Common.setMsg("<spring:message code='sys.btn.update'/>");
}

function fn_delete(){
	// 공통 메세지 영역에 메세지 표시.
	Common.setMsg("<spring:message code='sys.btn.delete'/>");
}

// 페이징 당 갯수 변경.
function fn_changeCount(obj){
	//var allData = AUIGrid.getGridData(myGridID);
	AUIGrid.destroy(myGridID);
	myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, null, {pageRowCount : $(obj).val()});
	//AUIGrid.setGridData(myGridID, allData);
	fn_getSampleListAjax();
}


</script>


<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/image/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Commission Rule Book Management</h2>
<ul class="right_opt">
    <!-- 공통 버튼 구성. -->
    <%@ include file="/WEB-INF/jsp/common/contentButton.jsp" %>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="searchForm" action="#" method="post">

	<table class="type1"><!-- table start -->
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
	    <input type="text" title="기준년월" class="j_date2" />
	    </td>
	    <th scope="row">ORG Group</th>
	    <td>
	    <select class="w100p" id="cmbCategory" name="cmbCategory">
	    </select>
	    </td>
	    <th scope="row">COUNT PER PAGE</th>
	    <td>
	    <select id="countPerPage" class="w100p" onchange="javascript:fn_changeCount(this);">
	        <option value="10">10</option>
	        <option value="20">20</option>
	        <option value="30">30</option>
	    </select>
	    </td>
	</tr>
	</tbody>
	</table><!-- table end -->
	
	<ul class="right_btns">
	    <li><p class="btn_gray"><a href="javascript:void(0);" onclick="javascript:fn_getSampleListAjax();"><span class="search"></span><spring:message code='sys.btn.search' /></a></p></li>
	</ul>
</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->
<ul class="right_btns">
    <li><p class="btn_grid"><a href="#"><span class="search"></span><spring:message code='sys.btn.excel.up' /></a></p></li>
    <li><p class="btn_grid"><a href="#"><span class="search"></span><spring:message code='sys.btn.excel.dw' /></a></p></li>
    <li><p class="btn_grid"><a href="#"><span class="search"></span><spring:message code='sys.btn.del' /></a></p></li>
    <li><p class="btn_grid"><a href="#"><span class="search"></span><spring:message code='sys.btn.ins' /></a></p></li>
    <li><p class="btn_grid"><a href="#"><span class="search"></span><spring:message code='sys.btn.add' /></a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->

        
