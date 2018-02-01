<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<head>
<script type="text/javaScript" language="javascript">

	//AUIGrid 생성 후 반환 ID
	var accGridID;

	$(document).ready(function(){
	    //AUIGrid 그리드를 생성합니다.
        createAUIGrid();

        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(accGridID, "cellDoubleClick", function(event) {
            fn_setData(AUIGrid.getCellValue(accGridID , event.rowIndex , "custAccId"));
        });
	    
        fn_getBankAccAjax();
	});
	
	function fn_setData(custAccId) {
	    if($('#callPrgm').val() == 'ORD_REGISTER_BANK_ACC' || $('#callPrgm').val() == 'ORD_REQUEST_PAY' || $('#callPrgm').val() == 'PRE_ORD') {
	        fn_loadBankAccountPop(custAccId);
	    }
	    else if($('#callPrgm').val() == 'ORD_MODIFY_BANK_ACC') {
	        fn_loadBankAccountPop(custAccId);
	    }
        
        $('#custPopCloseBtn').click();
	}
	
    function createAUIGrid() {
        
        //AUIGrid 칼럼 설정
        var columnLayout = [
            { headerText : '<spring:message code="sal.text.accNo" />',     dataField : "custAccNo",    width : 150 }
          , { headerText : '<spring:message code="sal.title.accountHolder" />', dataField : "custAccOwner", width : 240 }
          , { headerText : '<spring:message code="sal.text.type" />',           dataField : "codeName",     width : 150 }
          , { headerText : '<spring:message code="sal.text.issueBank" />',     dataField : "bankCodeName"}
          , { headerText : "custAccId",      dataField : "custAccId",  visible : false}];

        //그리드 속성 설정
        var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            editable            : false,            
            fixedColumnCount    : 0,            
            showStateColumn     : false,             
            displayTreeOpen     : false,            
       //     selectionMode       : "singleRow",  //"multipleCells",            
            headerHeight        : 30,       
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true
        };
        
        accGridID = GridCommon.createAUIGrid("grid_acc_wrap", columnLayout, "", gridPros);
    }

	$(function(){
	    $('#btnBankAcc').click(function() {
	        fn_getBankAccAjax();
	    });
	    $('#btnBankAccClear').click(function() {
	        $('#formBankAcc').clearForm();
	    });
	});
	
    //Get Contact by Ajax
    function fn_getBankAccAjax(){
        Common.ajax("GET", "/sales/customer/selectCustomerBankAccJsonList", $("#formBankAcc").serializeJSON(), function(result) {
            AUIGrid.setGridData(accGridID, result);
        });
    }
  
</script>
</head>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.page.title.custBankAcc" /></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a id="custPopCloseBtn" href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form id="formBankAcc" name="formBankAcc" action="#" method="post">
<input id="callPrgm" name="callPrgm" value="${callPrgm}" type="hidden" />
<input id="custId" name="custId" value="${custId}" type="hidden" />

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:160px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="sal.text.addrKeyword" /></th>
	<td ><input id="searchWord" name="searchWord" type="text" title="" placeholder="Keyword" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a id="btnBankAcc" ><spring:message code="sal.btn.search" /></a></p></li>
	<li><p class="btn_grid"><a id="btnBankAccClear" ><spring:message code="sal.btn.clear" /></a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_acc_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- search_table end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->