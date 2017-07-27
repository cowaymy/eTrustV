<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

    <script type="text/javaScript" language="javascript">

 // AUIGrid 생성 후 반환 ID
    var myGridID;
    
    var gridValue;
    
    var option = {
        width : "1000px", // 창 가로 크기
        height : "600px" // 창 세로 크기
    };
    

// 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
    $(document).ready(function(){
        
	    // AUIGrid 그리드를 생성합니다.
	    createAUIGrid();
	    
	    AUIGrid.setSelectionMode(myGridID, "singleRow");
        
        // cellClick event.
        AUIGrid.bind(myGridID, "cellClick", function( event ) {
            console.log("rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
            fn_setDetail(myGridID, event.rowIndex);
        });
        
        
                // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
//            fn_setDetail(myGridID, event.rowIndex);
            Common.popupWin("searchForm", "/organization/getMemberEventDetailPop.do?isPop=true&promoId=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "promoId"), option);
        });
        

        
        //fn_getOrgEventListAjax();

    });


/*     // 컬럼 선택시 상세정보 세팅.
    function fn_setDetail(gridID, rowIdx){
        alert("aaaaaaaaaa");
        Common.popupWin("searchForm", "/organization/getMemberEventDetailPop.do?isPop=true&promoId=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "promoId"), option);
    } */



    function createAUIGrid(){
        // AUIGrid 칼럼 설정
	    var columnLayout = [ {
                    dataField : "promoId",
                    headerText : "promo ID.",
                    width : 120
                }, {
	                dataField : "reqstNo",
	                headerText : "Request No.",
	                width : 120
	            }, {
	                dataField : "typeDesc",
	                headerText : "Req Type",
	                width : 120
	            }, {
	                dataField : "code",
	                headerText : "Member Type",
	                width : 120
	            }, {
	                dataField : "memCode",
	                headerText : "Member Code.",
	                width : 120
	            }, {
	                dataField : "name",
	                headerText : "Member Name.",
	                width : 120
	            }, {
	                dataField : "c1",
	                headerText : "Level (From)",
	                width : 120
	            }, {
	                dataField : "c2",
	                headerText : "Level (To)",
	                width : 120
	            }, {
	                dataField : "name1",
	                headerText : "Status",
	                width : 120
	            }, {
	                dataField : "userName",
	                headerText : "ReqBy",
	                width : 120
	            }, {
	                dataField : "crtDt",
	                headerText : "ReqAt",
	                width : 120
		    
		    }];
		    // 그리드 속성 설정
		    var gridPros = {
		        
		        // 페이징 사용       
		        usePaging : true,
		        
		        // 한 화면에 출력되는 행 개수 20(기본값:20)
		        pageRowCount : 20,
		        
		        editable : true,
		        
		        showStateColumn : true, 
		        
		        displayTreeOpen : true,
		        
		        
		        headerHeight : 30,
		        
		        // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
		        skipReadonlyColumns : true,
		        
		        // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
		        wrapSelectionMove : true,
		        
		        // 줄번호 칼럼 렌더러 출력
		        showRowNumColumn : true,
		
		    };
		            //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
		        myGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
    }

    
// 리스트 조회.
function fn_getOrgEventListAjax() {        
    Common.ajax("GET", "/organization/selectMemberEventList", $("#searchForm").serialize(), function(result) {
        
        console.log("성공.");
        console.log("data : " + result);
        AUIGrid.setGridData(myGridID, result);
    });
}


// 그리드 초기화.
function resetUpdatedItems() {
     AUIGrid.resetUpdatedItems(myGridID, "a");
 }
 
 
function f_info(data , v){


}



    function f_multiCombo(){
        $(function() {
            $('#requestStatus').change(function() {
            
            }).multipleSelect({
                selectAll: true, // 전체선택 
                width: '80%'
            });
            $('#requestType').change(function() {
            
            }).multipleSelect({
                selectAll: true,
                width: '80%'
            });
            $('#memberType').change(function() {
            
            }).multipleSelect({
                selectAll: true,
                width: '80%'
            });                   
        });
    }

    doGetCombo('/common/selectCodeList.do', '165', '','requestStatus', 'M' , 'f_multiCombo'); // Request Status
//    doGetCombo('/common/selectCodeList.do', '18', '','requestPerson', 'M' , 'f_multiCombo'); //Request Person
    doGetCombo('/common/selectCodeList.do', '18', '','requestType', 'M' , 'f_multiCombo'); //Request Type
    doGetCombo('/common/selectCodeList.do', '18', '','memberType', 'M' , 'f_multiCombo'); //MemberType
    
</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="../images/common/path_home.gif" alt="Home" /></li>
    <li>Organization</li>
    <li>Member Event</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Member Event Search</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_getOrgEventListAjax();"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" id= "searchForm"' method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Request No(From)</th>
    <td>
    <input id ="requestNoF" name="requestNoF" type="text" title="Request No(From)" placeholder="" class="w100p" />
    </td>
    <th scope="row">Request No(To)</th>
    <td>
    <input  id ="requestNoT" name="requestNoT" type="text" title="Request No(To)" placeholder="" class="w100p" />
    </td>
    <th scope="row">Request Date(From)</th>
    <td>
    <input id ="requestDateF" name="requestDateF" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" />
    </td>
    <th scope="row">Request Date(To)</th>
    <td>
    <input id ="requestDateT" name="requestDateT" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" />
    </td>
</tr>
<tr>
    <th scope="row">Request Status</th>
    <td>
    <select id="requestStatus" name="requestStatus" class="multy_select w100p">
<%--         <c:forEach var="list" items="${ reqStatusComboList}" varStatus="status">
            <option value="${list.code}">${list.codeName } </option>
        </c:forEach> --%>
    </select>
    </td>
    <th scope="row">Request Type</th>
    <td>
    <select  id="requestType" name="requestType" class="multy_select w100p">    </select>
    </td>
    <th scope="row">Request Person</th>
    <td>
    <select  id="requestPerson" name="requestPerson" class="w100p">
            <c:forEach var="list" items="${ reqPersonComboList}" varStatus="status">
            <option value="${list.userId}">${list.userName } </option>
        </c:forEach>
    </select>
    </td>
    <th scope="row"></th>
    <td>
    </td>
</tr>
<tr>
    <th scope="row">Member Type</th>
    <td>
    <select id="memberType" name="memberType"  class="multy_select w100p">    </select>
    </td>
    <th scope="row">Member Code</th>
    <td>
    <input id ="memberCode" name="memberCode" type="text" title="Member Code" placeholder="" class="w100p" />
    </td>
    <th scope="row"></th>
    <td>
    </td>
    <th scope="row"></th>
    <td>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="../images/common/btn_link.gif" alt="link show" /></a></p>
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
    <p class="hide_btn"><a href="#"><img src="../images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역 
    <div id="grid_wrap" style="width:100%; height:500px; margin:0 auto;"></div>\
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->