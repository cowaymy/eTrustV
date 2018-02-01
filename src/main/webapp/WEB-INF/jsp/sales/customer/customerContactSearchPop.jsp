<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<head>
<script type="text/javaScript" language="javascript">

	//AUIGrid 생성 후 반환 ID
	var contactGridID;

	$(document).ready(function(){
	    //AUIGrid 그리드를 생성합니다.
	    if($('#callPrgm').val() == 'ORD_REGISTER_CNTC_OWN' 
	    || $('#callPrgm').val() == 'ORD_MODIFY_CNTC_OWN'
	    || $('#callPrgm').val() == 'ORD_MODIFY_INST_CNTC'
	    || $('#callPrgm').val() == 'fn_loadCntcPerson'
	    || $('#callPrgm').val() == 'fn_loadInstallationCntcPerson'
	    || $('#callPrgm').val() == 'PRE_ORD_CNTC') {
	        createAUIGrid();
	        fn_getCustomerContactAjax();

            // 셀 더블클릭 이벤트 바인딩
            AUIGrid.bind(contactGridID, "cellDoubleClick", function(event) {
                fn_setData(AUIGrid.getCellValue(contactGridID , event.rowIndex , "custCntcId"))
                $('#custPopCloseBtn').click();
            });
	    }
	    else if($('#callPrgm').val() == 'ORD_REGISTER_CNTC_ADD'
	         || $('#callPrgm').val() == 'ORD_REGISTER_BILL_PRF') {
	        createAUIGrid2();
	        fn_getCustomerCareAjax();
	        
            // 셀 더블클릭 이벤트 바인딩
            AUIGrid.bind(contactGridID, "cellDoubleClick", function(event) {
                fn_setData(AUIGrid.getCellValue(contactGridID , event.rowIndex , "custCareCntId"))
                $('#custPopCloseBtn').click();
            });
	    }

	});
	
	function fn_setData(cntcId) {
	    if($('#callPrgm').val() == 'ORD_REGISTER_CNTC_OWN' || $('#callPrgm').val() == 'ORD_MODIFY_CNTC_OWN' || $('#callPrgm').val() == 'PRE_ORD_CNTC') {
	        fn_loadCntcPerson(cntcId);
	    }
	    else if($('#callPrgm').val() == 'ORD_REGISTER_CNTC_ADD') {
	        fn_loadSrvCntcPerson(cntcId);
	    }
	    else if($('#callPrgm').val() == 'ORD_REGISTER_BILL_PRF') {
	        fn_loadBillingPreference(cntcId);
	    }
	    else if($('#callPrgm').val() == 'ORD_MODIFY_INST_CNTC') {
	        fn_loadInstallCntcInfo(cntcId);
	    }
	    else{
	    	eval(${callPrgm}(cntcId));
	    }
	}
	
    function createAUIGrid() {
        
        //AUIGrid 칼럼 설정
        var columnLayout = [
            { headerText : '<spring:message code="sal.title.status" />',          dataField : "name",       editable : false, width : 80  }
          , { headerText : '<spring:message code="sal.text.name" />',            dataField : "name1" }
          , { headerText : '<spring:message code="sal.text.nric" />',            dataField : "nric",       editable : false, width : 100 }
          , { headerText : '<spring:message code="sal.text.race" />',            dataField : "codeName",   editable : false, width : 80  }
          , { headerText : '<spring:message code="sal.text.gender" />',          dataField : "gender",     editable : false, width : 80  }
          , { headerText : '<spring:message code="sal.text.telM" />',    dataField : "telM1",      editable : false, width : 120 }
          , { headerText : '<spring:message code="sal.text.telO" />',    dataField : "telO",       editable : false, width : 120 }
          , { headerText : '<spring:message code="sal.text.telR" />', dataField : "telR",       editable : false, width : 120 }
          , { headerText : '<spring:message code="sal.text.telF" />',       dataField : "telf",       editable : false, width : 120 }
          , { headerText : "custCntcId",      dataField : "custCntcId", visible  : false  }
          ];

        //그리드 속성 설정
        var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            editable            : false,            
            fixedColumnCount    : 0,            
            showStateColumn     : false,             
            displayTreeOpen     : false,            
   //         selectionMode       : "singleRow",  //"multipleCells",            
            headerHeight        : 30,       
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
            noDataMessage       : "No order found.",
            groupingMessage     : "Here groupping"
        };
        
        contactGridID = GridCommon.createAUIGrid("grid_cntc_wrap", columnLayout, "", gridPros);
    }

    function createAUIGrid2() {
        
        //AUIGrid 칼럼 설정
        var columnLayout = [
            { headerText : '<spring:message code="sal.title.status" />',          dataField : "name",          width : 100 }
          , { headerText : '<spring:message code="sal.text.name" />',            dataField : "name1"}
          , { headerText : '<spring:message code="sal.text.nric" />',            dataField : "nric",          width : 120 }
          , { headerText : '<spring:message code="sal.text.telM" />',    dataField : "telM1",         width : 120 }
          , { headerText : '<spring:message code="sal.text.telO" />',    dataField : "telO",          width : 120 }
          , { headerText : '<spring:message code="sal.text.telR" />', dataField : "telR",          width : 120 }
          , { headerText : '<spring:message code="sal.text.telF" />',       dataField : "telf",          width : 120 }
          , { headerText : "custCareCntId",   dataField : "custCareCntId", visible : false }
          ];

        //그리드 속성 설정
        var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            editable            : false,            
            fixedColumnCount    : 0,            
            showStateColumn     : false,             
            displayTreeOpen     : false,            
  //          selectionMode       : "singleRow",  //"multipleCells",            
            headerHeight        : 30,       
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
            noDataMessage       : "No order found.",
            groupingMessage     : "Here groupping"
        };
        
        contactGridID = GridCommon.createAUIGrid("grid_cntc_wrap", columnLayout, "", gridPros);
    }

	$(function(){
	    $('#cntcSearchBtn').click(function() {
	        fn_getCustomerContactAjax();
	    });
        $('#searchWord').keydown(function (event) {  
            if (event.which === 13) {    //enter
        	    if($('#callPrgm').val() == 'ORD_REGISTER_CNTC_OWN' 
        	    || $('#callPrgm').val() == 'ORD_MODIFY_CNTC_OWN'
        	    || $('#callPrgm').val() == 'ORD_MODIFY_INST_CNTC') {
        	        fn_getCustomerContactAjax();
        	    }
        	    else if($('#callPrgm').val() == 'ORD_REGISTER_CNTC_ADD'
        	         || $('#callPrgm').val() == 'ORD_REGISTER_BILL_PRF') {
        	        fn_getCustomerCareAjax();
        	    }
                return false;
            }            
        });
	});
	
    //Get Contact by Ajax
    function fn_getCustomerContactAjax(){
        Common.ajax("GET", "/sales/customer/selectCustomerContactJsonList", $("#cnctSearchForm").serializeJSON(), function(result) {
            AUIGrid.setGridData(contactGridID, result);
        });
    }
    
    //Get Contact by Ajax
    function fn_getCustomerCareAjax(){
        Common.ajax("GET", "/sales/customer/selectCustCareContactList.do", $("#cnctSearchForm").serializeJSON(), function(result) {
            AUIGrid.setGridData(contactGridID, result);
        });
    }
    
</script>
</head>
<body>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.customerCntc" /></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a id="custPopCloseBtn" href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form id="cnctSearchForm" name="cnctSearchForm" action="#" method="post">
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
	<th scope="row"><spring:message code="sal.title.text.cntcKeyword" /></th>
	<td ><input id="searchWord" name="searchWord" type="text" title="" placeholder="Keyword" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a id="cntcSearchBtn" href="#""><spring:message code="sal.btn.search" /></a></p></li>
	<li><p class="btn_grid"><a href="#"><spring:message code="sal.btn.clear" /></a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_cntc_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- search_table end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
</body>
</html>