<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript" language="javascript">
     var anotherGridID;
     
	$(document).ready(function(){
		
	    // AUIGrid 그리드를 생성합니다.
	    createEditAUIGrid();
	
	    //Call Ajax
	    fn_getAddrListAjax();
	    
//	    AUIGrid.setSelectionMode(anotherGridID, "singleRow");
	    
	    // 셀 더블클릭 이벤트 바인딩 - 주소수정
	    AUIGrid.bind(anotherGridID, "cellDoubleClick", function(event){
	    	
	        $("#_editDealerId").val(event.item.dealerId);
	        $("#_editDealerAddId").val(event.item.dealerAddId);
	        updateAnotherAddr();
	    });
	//  doGetCombo('/sales/pst/getInchargeList', '', $("#editInchargeSelect").val(),'editIncharge', 'S' , ''); //Incharge Person
	});
	
	function createEditAUIGrid() {
        // AUIGrid 칼럼 설정
        
        // 데이터 형태는 다음과 같은 형태임,
        //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
        var columnLayout = [{
                dataField : "code",
                headerText : '<spring:message code="sal.title.status" />',
                width : 120,
                editable : false
            }, {
                dataField : "fullAddr",
                headerText : '<spring:message code="sal.text.address" />',
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
        
        anotherGridID = GridCommon.createAUIGrid("#search_grid_wrap", columnLayout, gridPros1);
    }
	
	function fn_getAddrListAjax(){
        Common.ajax("GET", "/sales/pst/getAddrJsonListPop",$("#sForm").serialize(), function(result) {
            AUIGrid.setGridData(anotherGridID, result);
        });
    }
	
	$("#_search").click(function() {
		Common.ajax("GET", "/sales/pst/pstAnotherAddrJsonListPop",$("#sForm").serialize(), function(result) {
            AUIGrid.setGridData(anotherGridID, result);
        });
    });
	
	function updateAnotherAddr(){
		Common.ajax("GET", "/sales/pst/updateDealerAddressSetMain.do", $("#editForm").serialize(), function(result){
            //result alert and reload
            //Common.alert(result.message, fn_reloadPage); //차후변경가능
            Common.alert(result.message);
            $("#anotherClose").click();
            $("#_close").click();
            $("#autoClose").click();
            fn_selectPstRequestDOListAjax();
            fn_getAddrListAjax();
        });
	}
	function updateAnotherAddr1(){
        return false;
    }
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.weBringWellnessAddr" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="anotherClose"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<ul class="right_btns mb10">
    <li><p class="btn_blue"><a href="#" id="_search"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
    <!-- <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li> -->
</ul>
<form id="editForm" name="editForm" method="GET">
    <input type="hidden" name="dealerId"  id="_editDealerId"/>  <!-- Cust Id  -->
    <input type="hidden" name="dealerAddId"   id="_editDealerAddId"/><!-- Address Id  -->
    <input type="hidden" name="custCntcId"   id="_custCntcId"> <!--Contact Id  -->
</form>
<form id="sForm" name="sForm" method="GET">
<input type="hidden" name="dealerId"  id="dealerId" value="${dealerId}"/>  <!-- Cust Id  -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.addrKeyword" /></th>
    <td><input type="text" title="" id="searchAddr" name="searchAddr" placeholder="Keyword" class="w100p" /></td>
</tr>
</tbody>
</table> 
</form>
<!-- table end
<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EDIT</a></p></li>
    <li><p class="btn_grid"><a href="#">NEW</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>
-->
<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="search_grid_wrap" style="width:100%; height:250px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->