<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script type="text/javaScript">

var myGridID,subGridID;

//Grid Properties 설정 
var gridPros = {            
        editable : false,                 // 편집 가능 여부 (기본값 : false)
        showStateColumn : false     // 상태 칼럼 사용
};

// 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){
	myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
});

var columnLayout=[
    { dataField:"code" ,headerText:"<spring:message code='pay.head.type'/>" ,editable : false },
    { dataField:"invcItmOrdNo" ,headerText:"<spring:message code='pay.head.orderNo'/>" ,editable : false},
    { dataField:"memoAdjRefNo" ,headerText:"<spring:message code='pay.head.adjustmentNo'/>" ,editable : false},
    { dataField:"memoAdjInvcNo" ,headerText:"<spring:message code='pay.head.invoiceNo'/>" ,editable : false},
    { dataField:"resnDesc" ,headerText:"<spring:message code='pay.head.reason'/>" ,editable : false },
    { dataField:"memoItmAmt" ,headerText:"<spring:message code='pay.head.adjAmount'/>" ,editable : false },
    { dataField:"userName" ,headerText:"<spring:message code='pay.head.requestor'/>" ,editable : false},
    { dataField:"deptName" ,headerText:"<spring:message code='pay.head.department'/>" ,editable : false },
    { dataField:"memoAdjCrtDt" ,headerText:"<spring:message code='pay.head.creationDate'/>" ,editable : false },
    { dataField:"updUserName" ,headerText:"<spring:message code='pay.head.finalApproval'/>" ,editable : false },
    { dataField:"memoAdjUpdDt" ,headerText:"<spring:message code='pay.head.approvalDateFin'/>" ,editable : false }
    ];

// 리스트 조회.
function fn_getAdjustmentListAjax() {
    var valid = ValidRequiredField();
    if(!valid){
    	Common.alert("<spring:message code='pay.alert.createDate'/>");
    }
    else{
		AUIGrid.destroy(subGridID);//subGrid 초기화
	    Common.ajax("GET", "/payment/selectAdjustmentList.do", $("#searchForm").serialize(), function(result) {
	        AUIGrid.setGridData(myGridID, result);
	    });
    }
}

function ValidRequiredField(){
	var valid = true;
	
	if($("#date1").val() == "" || $("#date2").val() == "")
		valid = false;
	
	return valid;
}
function fn_cmmSearchInvoicePop(){
    Common.popupDiv('/payment/common/initCommonSearchInvoicePop.do', null, null , true ,'_searchInvoice');
}

function _callBackInvoicePop(searchInvoicePopGridID,rowIndex, columnIndex, value, item){
    location.href="/payment/initNewAdj.do?refNo=" + AUIGrid.getCellValue(searchInvoicePopGridID, rowIndex, "taxInvcRefNo");    
    $('#_searchInvoice').hide();
    
}

function fn_excelDown(){
	
	var valid = ValidRequiredField();
     if(!valid){
    	 Common.alert("<spring:message code='pay.alert.createDate'/>");
    }
    else{
		var date1 = $("#date1").val();
		var date2 = $("#date2").val();
		
		Common.ajax("GET", "/payment/countAdjustmentExcelList.do", $("#searchForm").serialize(), function(result) {
	       var cnt = result;
	       if(cnt > 0){

				Common.showLoader();
		        $.fileDownload("/payment/selectAdjustmentExcelList.do?date1=" + date1 + "&date2="+date2+"&status=4")
				.done(function () {
			        Common.alert("<spring:message code='pay.alert.fileDownSuceess'/>");                
					Common.removeLoader();            
		        })
			    .fail(function () {
					Common.alert("<spring:message code='pay.alert.fileDownFailed'/>");                
		            Common.removeLoader();            
				});
		   }else{
	    	   Common.alert("<spring:message code='sys.info.grid.noDataMessage'/>"); 
	       }
       });
   }
}
</script>

<div id="popup_wrap" class="popup_wrap pop_win"><!-- popup_wrap start -->
	<header class="pop_header"><!-- pop_header start -->
		<h1>Generate Summary List</h1>
		<ul class="right_opt">
			<li><p class="btn_blue"><a href="javascript:fn_excelDown();"><spring:message code='pay.btn.generateExcel'/></a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_getAdjustmentListAjax();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
		</ul>
	</header><!-- pop_header end -->

	<section class="pop_body"><!-- pop_body start -->
		<form name="searchForm" id="searchForm"  method="post">
        <input type="hidden" id="status" name="status" value="4" />
            <table class="type1"><!-- table start -->
                <caption>table</caption>
				<colgroup>
				    <col style="width:180px" />
				    <col style="width:300px" />	
				    <col style="width:*" /> 		    
				</colgroup>
				<tbody>
				    <tr>
				        <th scope="row">Create Date</th>
					    <td>
					       <div class="date_set w100p">
					       <p><input name="date1" id="date1" type="text" placeholder="DD/MM/YYYY" class="j_date" /></p> 
					       <span>~</span>
					       <p><input name="date2" id="date2" type="text"placeholder="DD/MM/YYYY" class="j_date" /></p>
					       </div>
					    </td>
					    <td></td>
                    </tr>
                </tbody>
            </table>
            <!-- table end -->
        </form>			
		
        <!-- grid_wrap start -->
        <article id="grid_wrap" class="grid_wrap"></article>
        <!-- grid_wrap end -->
    </section>
    <!-- search_result end -->

</div><!-- popup_wrap end -->