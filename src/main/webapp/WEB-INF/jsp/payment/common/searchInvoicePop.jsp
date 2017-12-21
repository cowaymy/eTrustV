<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
//AUIGrid 그리드 객체
var searchInvoicePopGridID;

//Default Combo Data
var invoiceTypeData = [{"codeId": "1","codeName": "Outright Invoice"},
                       {"codeId": "2","codeName": "Rental Invoice"},
                       {"codeId": "117","codeName": "HP Registration Invoice"},
                       {"codeId": "118","codeName": "AS Invoice"},
                       {"codeId": "119","codeName": "Service Membership Invoice"},
                       {"codeId": "121","codeName": "POS Invoice"},
                       {"codeId": "122","codeName": "Item Bank Invoice"},
                       {"codeId": "123","codeName": "WholeSales Invoice"},
                       {"codeId": "124","codeName": "Product Lost Invoice"},
                       {"codeId": "125","codeName": "Early Termination Invoice"},
                       ];

//AUIGrid 칼럼 설정
var searchInvoicePopLayout = [   
    { dataField:"taxInvcId" ,headerText:"<spring:message code='pay.head.taxInvoiceId'/>",width: 100 , editable : false ,visible : false},
    { dataField:"taxInvcType" ,headerText:"<spring:message code='pay.head.taxInvoiceType'/>",width: 100 , editable : false ,visible : false},
    { dataField:"month" ,headerText:"<spring:message code='pay.head.month'/>", editable : false ,visible : false},
    { dataField:"year" ,headerText:"<spring:message code='pay.head.year'/>", editable : false ,visible : false},
    { dataField:"taxInvcRefNo" ,headerText:"<spring:message code='pay.head.invoiceNo'/>",width: 150 , editable : false},
    { dataField:"taxInvcGrpNo" ,headerText:"<spring:message code='pay.head.orderNo'/>",width: 120 , editable : false},
    { dataField:"taxInvcSvcNo" ,headerText:"<spring:message code='pay.head.serviceNo'/>",width: 120 , editable : false },
    { dataField:"taxInvcCustName" ,headerText:"<spring:message code='pay.head.customerName'/>",width: 200 ,editable : false },
    { dataField:"taxInvcRefDt" ,headerText:"<spring:message code='pay.head.invoiceDate'/>",width: 100 , editable : false , dataType : "date", formatString : "dd-mm-yyyy"},
    { dataField:"taxInvcAmtDue" ,headerText:"<spring:message code='pay.head.invoiceAmount'/>",width: 100 , dataType : "numeric", formatString : "#,##0.00"},
    {
        dataField : "",
        headerText : "",
        renderer : {
            type : "ButtonRenderer",
            labelText : "Select",
            onclick : function(rowIndex, columnIndex, value, item) {
            	//alert(rowIndex);
            	_callBackInvoicePop(searchInvoicePopGridID,rowIndex, columnIndex, value, item);
            }
        }
      }
    
    ];
    
//화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){    
    //메인 페이지
    doDefCombo(invoiceTypeData, '' ,'invoiceType', 'S', '');        //Claim Type 생성
    
    //Grid Properties 설정 
    var gridPros = {            
            editable : false,                 // 편집 가능 여부 (기본값 : false)
            showStateColumn : false     // 상태 칼럼 사용
    };
    
    // Order 정보 (Master Grid) 그리드 생성
    searchInvoicePopGridID = GridCommon.createAUIGrid("grid_invoicePop_wrap", searchInvoicePopLayout,null,gridPros);
   
});

//리스트 조회.
function fn_getInvoiceListAjax() {   
	if(FormUtil.checkReqValue($("#invoiceType option:selected")) ){
		Common.alert('* Please select the Invoice Type. <br/>');
		return;
	}
	
	if(FormUtil.checkReqValue($("#_invoicePopForm #invoiceNo")) &&
			FormUtil.checkReqValue($("#_invoicePopForm #serviceNo")) &&
			FormUtil.checkReqValue($("#_invoicePopForm #orderNo"))){
        Common.alert('* Please key in either Invoice No or Order number or Service number. <br />');
        return;
    }
	
	Common.ajax("POST", "/payment/common/selectCommonSearchInvoicePop.do", $("#_invoicePopForm ").serializeJSON(), function(result) {
		AUIGrid.setGridData(searchInvoicePopGridID, result);
	});
}

</script>
<!-- popup_wrap start -->
<div id="popup_wrap" class="popup_wrap">
    <!-- pop_header start -->
    <header class="pop_header">
        <h1>INVOICE SEARCH</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" id="_close1"><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header>
    <!-- pop_header end -->
    <!-- getParams  -->
    <section class="pop_body">
        <!-- pop_body start -->
        <form id="_invoicePopForm"> <!-- Form Start  -->
            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:150px" />
                    <col style="width:*" />
                    <col style="width:150px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Invoice Type</th>
                        <td colspan="3">
                            <select class="w100p" id="invoiceType" name="invoiceType"></select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Invoice No.</th>
                        <td><input type="text" id="invoiceNo" name="invoiceNo" title="Invoice No" placeholder="Invoice No." class="w100p" /></td>
                        <th scope="row">Invoice Period</th>
                        <td><input type="text" id="invoicePeriod" name="invoicePeriod"  title="Invoice Period" placeholder="Invoice Period" class="j_date2 w100p" /></td>
                    </tr>
                    <tr>
                        <th scope="row">Service No.</th>
                        <td><input type="text" id="serviceNo" name="serviceNo" title="Service No" placeholder="Service No" class="w100p" /></td>
                        <th scope="row">Order No</th>
                        <td><input type="text" id="orderNo" name="orderNo" title="Order No" placeholder="Order No" class="w100p" /></td>
                    </tr>
                    <tr>
                        <th scope="row">Customer Name</th>
                        <td colspan="3"><input type="text" id="customerName" name="customerName" title="Customer Name" placeholder="Customer Name" class="w100p" /></td>                            
                    </tr>                 
                </tbody>
            </table>
            <!-- table end -->
        </form>
        <!--Form End  -->
        
        <!-- search_result start -->
        <section class="search_result">
            <!-- grid_wrap start -->
            <article id="grid_invoicePop_wrap" class="grid_wrap"></article>
            <!-- grid_wrap end -->
        </section>
        <!-- search_result end -->

        <ul class="center_btns">
            <li><p class="btn_blue2"><a href="javascript:fn_getInvoiceListAjax();" id="_saveBtn"><spring:message code='sys.btn.search'/></a></p></li>
        </ul>

    </section><!-- pop_body end -->
</div>