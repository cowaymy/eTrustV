<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
    
<script type="text/javaScript">

var myGridID;

//Grid Properties 설정 
var gridPros = {            
        editable : false,                 // 편집 가능 여부 (기본값 : false)
        showStateColumn : false     // 상태 칼럼 사용
};

// 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){
	myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);

	Common.ajax("GET", "/payment/selectNewAdjList.do", {"refNo":"${refNo}"}, function(result) {
        if(result != 'undefined'){

            $("#reselect").attr("disabled", true);
            $("#invoiceNo").attr("readonly", "readonly");
            
            //hidden값 셋팅
        	$("#hiddenSalesOrderId").val(result.master.ordId);
        	$("#hiddenInvoiceType").val(result.master.txinvoicetypeid);
        	$("#hiddenAccountConversion").val(result.master.accountconversion);

          //Master데이터 출력
            $("#tInvoiceNo").text(result.master.brNo);
            $("#tInvoiceDt").text(result.master.taxInvcDt);
            $("#tInvoiceType").text(result.master.invoicetype);
            $("#tGroupNo").text(result.master.txinvoicetypeid);
            $("#tOrderNo").text(result.master.ordNo);
            $("#tServiceNo").text(result.master.serviceno);
            $("#CustName").text(result.master.custName);
            $("#tContactPerson").text(result.master.cntcPerson);
            $("#tAddress").text(result.master.address);
            $("#tRemark").text(result.master.rem);
            $("#tOverdue").text(result.master.overdue);
            $("#tTaxes").text(result.master.taxes);
            $("#tDue").text(result.master.amountdue);
            
          //Detail데이터 출력
            AUIGrid.setGridData(myGridID, result.detail);
        }
		
		
    });

});


var columnLayout=[
	{ dataField:"txinvoiceitemid" ,headerText:"invoiceItemId" ,editable : false, visible:false },
	{ dataField:"billitemamount" ,headerText:"invoiceItemCharges" ,editable : false, visible:false},
    { dataField:"billitemtype" ,headerText:"Bill Type" ,editable : false },
    { dataField:"billitemrefno" ,headerText:"Order No." ,editable : false },
    { dataField:"billitemunitprice" ,headerText:"Unit Price" ,editable : false, dataType : "numeric",formatString : "#,##0.00"},
    { dataField:"billitemqty" ,headerText:"Quantity" ,editable : false},
    { dataField:"billitemtaxrate" ,headerText:"GST Rate" ,editable : false },
    { dataField:"billitemcharges" ,headerText:"Amount" ,editable : false },
    { dataField:"billitemtaxes" ,headerText:"GST" ,editable : false},
    { dataField:"billitemamount" ,headerText:"Total" ,editable : false },
    { dataField:"totamount", 
        headerText:"Total Adjustment Amount" , 
        editable : false ,
        renderer : { type : "TemplateRenderer"},
        labelFunction : function(rowIndex, columnIndex, value, headerText, item){
        	var template = '<span class="input_style">0.0</span>';
        	return template;
        }
    }
    ];
</script>

<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Payment</li>
        <li>Invoice/Statement</li>
        <li>Adjustment (CN/DN)</li>
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>Adjustment Management - New CN/DN Request</h2>
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:fn_getAdjustmentListAjax();"><span class="search"></span>Search</a></p></li>
        </ul>
    </aside>
    <!-- title_line end -->

    <!-- search_table start -->
    <section class="search_table">
        <span>Select Invoice For Adjustment</span>
        <form name="searchForm" id="searchForm"  method="post">
        <input type="hidden" id="hiddenSalesOrderId" name="hiddenSalesOrderId" />
        <input type="hidden" id="hiddenInvoiceType" name="hiddenInvoiceType" />
        <input type="hidden" id="hiddenAccountConversion" name="hiddenAccountConversion" />
            <table class="type1"><!-- table start -->
                <caption>table</caption>
				<colgroup>
				    <col style="width:180px" />
				    <col style="width:180px" />
				    <col style="width:*" />
				</colgroup>
				<tbody>
				    <tr>
                        <th scope="row">Invoice No</th>
                        <td>
                           <input id="invoiceNo" name="invoiceNo" type="text" placeholder="Order No." class="w100p" />
                        </td>
                        <td>
                             <input type="button" name="reselect" id="reselect" value="Reselect" /> 
                        </td>
                    </tr>
                </tbody>
            </table>
            </form>
            Invoice Information
            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:180px" />
                    <col style="width:*" />
                    <col style="width:180px" />
                    <col style="width:*" />
                    <col style="width:180px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Invoice No</th>
                        <td id="tInvoiceNo"></td>
                        <th scope="row">Invoice Date</th>
                        <td id="tInvoiceDt"></td>
                        <th scope="row">Invoice Type</th>
                        <td id="tInvoiceType"></td>
                    </tr>
                    <tr>
                        <th scope="row">Group No.</th>
                        <td id="tGroupNo"></td>
                        <th scope="row">Order No.</th>
                        <td id="tOrderNo"></td>
                        <th scope="row">Service No.</th>
                        <td id="tServiceNo"></td>
                    </tr>
                    <tr>
                        <th scope="row">Customer Name</th>
                        <td id="CustName" colspan="5"></td>
                    </tr>
                    <tr>
                        <th scope="row">Contact Person</th>
                        <td id="tContactPerson" colspan="5"></td>
                    </tr>
                    <tr>
                        <th scope="row">Address</th>
                        <td id="tAddress" colspan="5"></td>
                    </tr>
                    <tr>
                        <th scope="row">Remark</th>
                        <td id="tRemark" colspan="5"></td>
                    </tr>
                     <tr>
                        <th scope="row">Overdue Amount(RM)</th>
                        <td id="tOverdue"></td>
                        <th scope="row">Taxes Amount(RM)</th>
                        <td id="tTaxes"></td>
                        <th scope="row">Amount Due(RM)</th>
                        <td id="tDue"></td>
                    </tr>
                </tbody>
            </table>
            Adjustment Information
            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:180px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Adjustment Type</th>
                        <td>
                           <select id="adjType" name="adjType">
                                <option value="1293">Credit Note</option>
                                <option value="1294">Dedit Note</option>
                           </select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Reason</th>
                        <td>
                           <select id="reason" name="reason" disabled></select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Remark</th>
                        <td>
                           <textarea id="reason" name="reason" disabled></textarea>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Total Adjustment(RM)</th>
                        <td id="totAdjustment">0.00</td>
                    </tr>
                </tbody>
            </table>
            Item(s) Information
            <!-- table end -->
            

    <!-- search_result start -->
    <section class="search_result">	
        <!-- grid_wrap start -->
        <article id="grid_wrap" class="grid_wrap"></article>
        <!-- grid_wrap end -->
    </section>
    <!-- search_result end -->
</section>
</section>


