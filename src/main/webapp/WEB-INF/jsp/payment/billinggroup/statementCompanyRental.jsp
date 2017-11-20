<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
    
<script type="text/javaScript">

//AUIGrid 그리드 객체
var myGridID;

//Grid에서 선택된 RowID
var selectedGridValue;

// 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){    
        
    //Grid Properties 설정 
    var gridPros = {            
            editable : false,                 // 편집 가능 여부 (기본값 : false)
            showStateColumn : false     // 상태 칼럼 사용
    };
    
    // Order 정보 (Master Grid) 그리드 생성
    myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
    
    // Master Grid 셀 클릭시 이벤트
    AUIGrid.bind(myGridID, "cellClick", function( event ){ 
        selectedGridValue = event.rowIndex;
    });  
});


// AUIGrid 칼럼 설정
var columnLayout = [
    { dataField:"stateId" ,headerText:"StatementId",width: 100 , editable : false ,visible : false},
    { dataField:"year" ,headerText:"Year",width: 100 , editable : false },
    { dataField:"month" ,headerText:"Month",width: 80  , editable : false },
    { dataField:"stateItmRefNo" ,headerText:"Bill No.",width: 200  , editable : false },
    { dataField:"stateItmOrdNo" ,headerText:"Order No.",width: 200  , editable : false },
    { dataField:"stateCustName" ,headerText:"Customer Name" , editable : false }
    ];
                
// 리스트 조회.
function fn_getTaxInvoiceListAjax() {   
	
	   if(FormUtil.checkReqValue($("#billingNo"))){
        Common.alert('* Please key-In Billing No. <br />');
        return;
    }
	
    Common.ajax("POST", "/payment/selectStatementCompanyRental.do", $("#searchForm").serializeJSON(), function(result) {
        AUIGrid.setGridData(myGridID, result);
    });
}

//크리스탈 레포트
function fn_generateInvoice(){
	var selectedItem = AUIGrid.getSelectedIndex(myGridID);
	
	if (selectedItem[0] > -1){
		//report form에 parameter 세팅
		$("#reportPDFForm #V_STATEMENTID").val(AUIGrid.getCellValue(myGridID, selectedGridValue, "stateId"));
		
		//report 호출
		var option = {
			    isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
	    };

        Common.report("reportPDFForm", option);
         
    }else{
        Common.alert('<b>No print type selected.</b>');
    }
}

function fn_Clear(){
    $("#searchForm")[0].reset();
}
</script>

<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Billing</li>
        <li>Billing Group</li>
        <li>Statement Company Rental</li>
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>Statement Company Rental</h2>
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:fn_generateInvoice();">Statement Generate</a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_getTaxInvoiceListAjax();"><span class="search"></span>Search</a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_Clear();"><span class="clear"></span>Clear</a></p></li>
        </ul>
    </aside>
    <!-- title_line end -->

    <!-- search_table start -->
    <section class="search_table">
        <form name="searchForm" id="searchForm"  method="post">

            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:140px" />
                    <col style="width:*" />
                    <col style="width:180px" />
                    <col style="width:*" />                    
                </colgroup>
                <tbody>
                    <tr>
                       <th scope="row">Billing No.</th>
                       <td>
                            <input type="text" id="billingNo" name="billingNo" title="Billing No." placeholder="Billing No. (Eg: BR No. / AOR No. / ACN No. / WOR No.)" class="w100p" />
                       </td>                       
                       <th scope="row">Statement Period</th>
                       <td>
                            <input type="text" id="statementPeriod" name="statementPeriod"  title="Statement Period" placeholder="Statement Period" class="j_date2 w100p" placeholder="MM/YYYY"/>
                       </td>                                       
                    </tr>
                    <tr>
                       <th scope="row">Order No.</th>
                       <td colspan="3">
                            <input type="text" id="orderNo" name="orderNo" title="Order No." placeholder="Order No." class="w100p" />
                       </td>        
                    </tr>
                    <tr>
                        <th scope="row">Customer Name</th>
                        <td colspan="3">
                            <input type="text" id="custName" name="custName" title="Customer Name" placeholder="Customer Name." class="w100p" />
                        </td>
                    </tr>
                </tbody>
            </table>
            <!-- table end -->
        </form>
    </section>
    <!-- search_table end -->

    <!-- search_result start -->
    <section class="search_result">
        <!-- grid_wrap start -->
        <article id="grid_wrap" class="grid_wrap"></article>
        <!-- grid_wrap end -->
    </section>
    <!-- search_result end -->
</section>
<!-- content end --> 
<form name="reportPDFForm" id="reportPDFForm"  method="post">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/statement/Official_StatementofAccount_Company_PDF_New.rpt" />
    <input type="hidden" id="viewType" name="viewType" value="PDF" />
    <input type="hidden" id="V_STATEMENTID" name="V_STATEMENTID" />
</form>