<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript" language="javascript">
	var anotherContGridID;
	
	$(document).ready(function(){
	    
	    // AUIGrid 그리드를 생성합니다.
	    createEditAUIGrid();
	
	    //Call Ajax
	    fn_getContListAjax();
	    
//	    AUIGrid.setSelectionMode(anotherContGridID, "singleRow");
	    
	    // 셀 더블클릭 이벤트 바인딩 - 주소수정
	    AUIGrid.bind(anotherContGridID, "cellDoubleClick", function(event){
	        
	        $("#_editDealerId").val(event.item.dealerId);
	        $("#_editDealerCntId").val(event.item.dealerCntId);
	        updateAnotherCnt();
	    });
	//  doGetCombo('/sales/pst/getInchargeList', '', $("#editInchargeSelect").val(),'editIncharge', 'S' , ''); //Incharge Person
	});
	
	function createEditAUIGrid() {
	    // AUIGrid 칼럼 설정
	    
	    // 데이터 형태는 다음과 같은 형태임,
	    //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
	    var columnLayout = [{
	            dataField : "stusCode",
	            headerText : '<spring:message code="sal.title.status" />',
	            width : 80,
	            editable : false
	        }, {
	            dataField : "cntName",
	            headerText : '<spring:message code="sal.text.name" />',
	            editable : false
	        }, {
                dataField : "nric",
                headerText : '<spring:message code="sal.text.nric" />',
                width : 120,
                editable : false
            }, {
                dataField : "raceName",
                headerText : '<spring:message code="sal.text.race" />',
                width : 80,
                editable : false
            }, {
                dataField : "gender",
                headerText : '<spring:message code="sal.text.gender" />',
                width : 80,
                editable : false
            }, {
                dataField : "telM1",
                headerText : '<spring:message code="sal.text.telM" />',
                width : 120,
                editable : false
            }, {
                dataField : "telO",
                headerText : '<spring:message code="sal.text.telO" />',
                width : 120,
                editable : false
            }, {
                dataField : "telR",
                headerText : '<spring:message code="sal.text.telR" />',
                width : 120,
                editable : false
            }, {
                dataField : "telf",
                headerText : '<spring:message code="sal.text.telF" />',
                width : 120,
                editable : false
            }];
	   
	    // 그리드 속성 설정
	    var gridPros1 = {
	        // 페이징 사용       
	        usePaging : true,
	        // 한 화면에 출력되는 행 개수 20(기본값:20)
	        pageRowCount : 10,
	        editable : true,
	        fixedColumnCount : 1,
	        showStateColumn : false, 
	        displayTreeOpen : true,
	        selectionMode : "multipleCells",
	        headerHeight : 30,
	        // 그룹핑 패널 사용
	        useGroupingPanel : false,
	        // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
	        skipReadonlyColumns : true,
	        // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
	        wrapSelectionMove : true,
	        // 줄번호 칼럼 렌더러 출력
	        showRowNumColumn : true,
	        groupingMessage : "Here groupping"
	    };
	    
	    anotherContGridID = GridCommon.createAUIGrid("#searchC_grid_wrap", columnLayout, gridPros1);
	}
	
	function fn_getContListAjax(){
	    Common.ajax("GET", "/sales/pst/getContJsonListPop",$("#scForm").serialize(), function(result) {
	        AUIGrid.setGridData(anotherContGridID, result);
	    });
	}
	
	$("#_searchC").click(function() {
	    Common.ajax("GET", "/sales/pst/pstAnotherContJsonListPop",$("#scForm").serialize(), function(result) {
	        AUIGrid.setGridData(anotherContGridID, result);
	    });
	});
	
	function updateAnotherCnt(){
	    Common.ajax("GET", "/sales/pst/updateDealerContactSetMain.do", $("#editCForm").serialize(), function(result){
	        //result alert and reload
	        //Common.alert(result.message, fn_reloadPage); //차후변경가능
	        Common.alert(result.message);
	        $("#anotherClose").click();
	        $("#_close").click();
	        $("#autoClose").click();
	        fn_selectPstRequestDOListAjax();
	        fn_getContListAjax();
	    });
	}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.weBringWellnessCntc" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<ul class="right_btns mb10">
    <li><p class="btn_blue"><a href="#" id="_searchC"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
</ul>
<form id="editCForm" name="editCForm" method="GET">
    <input type="hidden" name="dealerId"  id="_editDealerId"/>  <!-- Cust Id  -->
    <input type="hidden" name="dealerCntId"   id="_editDealerCntId"/><!-- Address Id  -->
</form>
<form id="scForm" name="scForm" method="GET">
<input type="hidden" name="dealerId"  id="dealerId" value="${dealerId}"/>  <!-- Cust Id  -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.text.cntcKeyword" /></th>
    <td><input type="text" title="" id="searchCont" name="searchCont" placeholder="Keyword" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->
</form>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="searchC_grid_wrap" style="width:100%; height:250px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->