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
        
    2) SYS0052M 다국어 메세지 테이블 id.
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

function callback(b){
	alert(b);
}

// 페이징 당 갯수 변경.
function fn_changeCount(obj){
    
	Common.alert("페이지당 갯수가 " + $(obj).val() + "로 변경됩니다.", function(){
        //var allData = AUIGrid.getGridData(myGridID);
        AUIGrid.destroy(myGridID);
        myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, null, {
            pageRowCount : $(obj).val()
        });
        //AUIGrid.setGridData(myGridID, allData);
        fn_getSampleListAjax();
    });
}
</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Training</li>
    <li>Course</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Course</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="javascript:void(0);" onclick="javascript:fn_getSampleListAjax();"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="searchForm" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Course Code</th>
    <td>
    <input type="text" title="Course Code" placeholder="" class="w100p" />
    </td>
    <th scope="row">Course Status</th>
    <td>
    <select class="w100p" id="cmbCategory" name="cmbCategory">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">332</option>
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
<tr>
    <th scope="row">Course Name</th>
    <td>
    <input type="text" title="Course Name" placeholder="" class="w100p" />
    </td>
    <th scope="row">Location</th>
    <td>
    <input type="text" title="Location" placeholder="" class="w100p" />
    </td>
    <th scope="row">Training Period</th>
    <td>

    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
    </div><!-- date_set end -->

    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
        <li><p class="link_btn"><a href="#">menu1</a></p></li>
        <li><p class="link_btn"><a href="#">menu2</a></p></li>
        <li><p class="link_btn"><a href="#">menu3</a></p></li>
        <li><p class="link_btn"><a href="#">menu4</a></p></li>
        <li><p class="link_btn"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn"><a href="#">menu6</a></p></li>
        <li><p class="link_btn"><a href="#">menu7</a></p></li>
        <li><p class="link_btn"><a href="#">menu8</a></p></li>
    </ul>
    <ul class="btns">
        <li><p class="link_btn type2"><a href="#">menu1</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu3</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu4</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu6</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu7</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu8</a></p></li>
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">

<!--
    PAGE_AUTH.funcView               : view 권한
    PAGE_AUTH.funcChange          : 등록, 수정, 삭제 권한
    PAGE_AUTH.funcPrint               : 프린트 권한
    PAGE_AUTH.funcUserDefine1   : 사용자정의 권한1
    PAGE_AUTH.funcUserDefine2   : 사용자정의 권한2
    PAGE_AUTH.funcUserDefine3   : 사용자정의 권한3
    PAGE_AUTH.funcUserDefine4   : 사용자정의 권한4
    PAGE_AUTH.funcUserDefine5   : 사용자정의 권한5
-->
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
        <li><p class="btn_grid"><a href="#">view</a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    <li><p class="btn_grid"><a href="#"><spring:message code='sys.btn.excel.up' /></a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
    <li><p class="btn_grid"><a href="#"><spring:message code='sys.btn.excel.dw' /></a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcUserDefine5 == 'Y'}">
    <li><p class="btn_grid"><a href="#"><spring:message code='sys.btn.del' /></a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    <li><p class="btn_grid"><a href="#"><spring:message code='sys.btn.ins' /></a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    <li><p class="btn_grid"><a href="#"><spring:message code='sys.btn.add' /></a></p></li>
    </c:if>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->

        
