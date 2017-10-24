<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">

//AUIGrid 그리드 객체
var searchQuotationPopGridID;

//AUIGrid 칼럼 설정
var searchQuotationPopLayout = [
    
	{ dataField:"srvMemQuotId" ,headerText:"Quotation ID",editable : false ,visible : false},
	{ dataField:"srvMemQuotIdTxt" ,headerText:"Quotation ID (CHAR)",editable : false ,visible : false},
    { dataField:"salesOrdId" ,headerText:"Sales Order ID",editable : false ,visible : false},
    { dataField:"custId" ,headerText:"cust ID",editable : false ,visible : false},
    { dataField:"custName" ,headerText:"cust Name",editable : false ,visible : false},
    { dataField:"appTypeId" ,headerText:"appTypeId",editable : false ,visible : false},
    { dataField:"stkDesc" ,headerText:"stkDesc",editable : false ,visible : false},
    { dataField:"srvMemPacId" ,headerText:"Membership TypeId",editable : false ,visible : false},
    { dataField:"salesOrdNo" ,headerText:"Order No",width: 100 , editable : false },
    { dataField:"srvMemQuotNo" ,headerText:"Quotation No",width: 100 , editable : false },    
    { dataField:"srvMemDesc" ,headerText:"Membership Type",width: 160 ,editable : false},
    { dataField:"srvDur" ,headerText:"Duration",width: 70 , editable : false},
    { dataField:"srvFreq" ,headerText:"Frequent",width: 70 , editable : false },    
    { dataField:"srvQuotValId" ,headerText:"Expired Date",width: 100 , editable : false , dataType : "date", formatString : "dd-mm-yyyy"},    
    { dataField:"srvMemPacAmt" ,headerText:"Package Charges",width: 100, editable : false ,dataType : "numeric", formatString : "#,##0.00",style : "aui-grid-user-custom-right"},
    { dataField:"srvMemBsAmt" ,headerText:"Filter Charges",width: 100, editable : false ,dataType : "numeric", formatString : "#,##0.00",style : "aui-grid-user-custom-right"},
    { dataField:"totalAmt" ,headerText:"Total Charges",width: 100, editable : false ,dataType : "numeric", formatString : "#,##0.00",style : "aui-grid-user-custom-right"}
    ];
    
//화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){
	
    //Membership Type 생성
    doGetCombo('/sales/membership/getSrvMemCode', '', '', 'membershipType' , 'S', '');
    
    //Application Type 생성
    doGetCombo('/common/selectCodeList.do', '10' , ''   , 'appType' , 'S', '');
    
    //Grid Properties 설정 
    var gridPros = {            
            editable : false,                 // 편집 가능 여부 (기본값 : false)
            showStateColumn : false     // 상태 칼럼 사용
    };
    
    // Order 정보 (Master Grid) 그리드 생성
    searchQuotationPopGridID = GridCommon.createAUIGrid("grid_quotationPop_wrap", searchQuotationPopLayout,null,gridPros);
    
    // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(searchQuotationPopGridID, "cellDoubleClick", function(event) {
        var obj = AUIGrid.getItemByRowIndex(searchQuotationPopGridID,event.rowIndex);
        _callBackQuotationPop(obj);         
    });
   
});

//리스트 조회.
function fn_getQuotationListAjax() {
    
    Common.ajax("POST", "/sales/membership/selectSrchMembershipQuotationPop.do", $("#_quotationPopForm ").serializeJSON(), function(result) {
        AUIGrid.setGridData(searchQuotationPopGridID, result);
    });
}

</script>

<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
.aui-grid-user-custom-right {
    text-align:right;
}

/* 엑스트라 체크박스 사용자 선택 못하는 표시 스타일 */
.disable-check-style {
    color:#d3825c;
}

</style>
<!-- popup_wrap start -->
<div id="popup_wrap" class="popup_wrap">
    <!-- pop_header start -->
    <header class="pop_header">
        <h1>SEARCH MEMBERSHIP QUOTATION</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" id="_close1">CLOSE</a></p></li>
        </ul>
    </header>
    <!-- pop_header end -->
    <!-- getParams  -->
    <section class="pop_body">
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:fn_getQuotationListAjax();" id="_saveBtn">Search</a></p></li>
        </ul>
        <!-- pop_body start -->
        <form id="_quotationPopForm"> <!-- Form Start  -->
            <table class="type1 mt10"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:150px" />
                    <col style="width:*" />
                    <col style="width:150px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Order No</th>
                        <td>
                            <input type="text" id="orderNo" name="OrderNo" title="Order No" placeholder="Order No" class="w100p" />
                        </td>
                        <th scope="row">Membership Type</th>
                        <td>
                            <select class="w100p" id="membershipType" name="membershipType"></select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Quotation No.</th>
                        <td><input type="text" id="quotationNo" name="quotationNo" title="Quotation No" placeholder="Quotation No" class="w100p" /></td>
                        <th scope="row">Quatation Duration</th>
                        <td><input type="text" id="quotationDur" name="quotationDur" title="Quatation Duration" placeholder="Quatation Duration" class="w100p" /></td>
                    </tr>
                    <tr>
                        <th scope="row">Customer ID</th>
                        <td><input type="text" id="customerId" name="customerId" title="Customer ID" placeholder="Customer ID (Numeric)" class="w100p" /></td>
                        <th scope="row">Customer Name</th>
                        <td><input type="text" id="customerNm" name="customerNm" title="Customer Name" placeholder="Customer Name" class="w100p" /></td>
                    </tr>
                    <tr>
                        <th scope="row">NRIC/Company No</th>
                        <td><input type="text" id="nric" name="nric" title="NRIC/Company No" placeholder="NRIC/Company No" class="w100p" /></td>
                        <th scope="row">Application Type</th>
                        <td>
                            <select class="w100p" id="appType" name="appType"></select>
                        
                        </td>
                    </tr>
                                    
                </tbody>
            </table>
            <!-- table end -->
        </form>
        <!--Form End  -->  
        <!-- search_result start -->
        <section class="search_result">
            <!-- grid_wrap start -->
            <article id="grid_quotationPop_wrap" class="grid_wrap"></article>
            <!-- grid_wrap end -->
        </section>
        <!-- search_result end -->
    </section><!-- pop_body end -->
</div>