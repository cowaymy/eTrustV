<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<style type="text/css">
.my-custom-up div{
    color:#FF0000;
}
</style>
<script type="text/javaScript">
//AUIGrid 그리드 객체
var myGridID;
var selCodeCustId;
var paymode = [{"codeId":"130","codeName":"Regular"},{"codeId":"131","codeName":"Credit Card"},{"codeId":"132","codeName":"Direct Debit"}];
var outStandMonth = [{"codeId":"0","codeName":"All"},{"codeId":"1","codeName":"1"},{"codeId":"2","codeName":"2"},{"codeId":"3","codeName":"3"},{"codeId":"4","codeName":"4"}];
var isPaid = [{"codeId":"1","codeName":"Full Paid"},{"codeId":"2","codeName":"Partial Paid"},{"codeId":"3","codeName":"No Paid"}];
var bsMonth = [{"codeId":"0","codeName":"All"},{"codeId":"1","codeName":"Yes"},{"codeId":"2","codeName":"No"}];


$(document).ready(function(){

	if("${SESSION_INFO.userTypeId}" == "2"){
		$("#orgCode").attr("disabled", true);
		$("#grpCode").attr("disabled", true);
		$("#deptCode").attr("disabled", true);

		if("${SESSION_INFO.memberLevel}" <= "3"){
			$("#deptCode").attr("disabled", false);
		}
		if("${SESSION_INFO.memberLevel}" <= "2"){
            $("#grpCode").attr("disabled", false);
        }
		if("${SESSION_INFO.memberLevel}" <= "1"){
            $("#orgCode").attr("disabled", false);
        }
	}
	doGetCombo('/common/selectCodeList.do', '8', selCodeCustId ,'cmbCustTypeId', 'S', '');       // Customer Type Combo Box
	doDefCombo(paymode, '', 'cmbPaymode', 'S', '');
	doDefCombo(isPaid, '', 'cmbIsPaid', 'S', '');
	doDefCombo(outStandMonth, '0', 'cmbOutstandMonth', 'S', '');
	doDefCombo(bsMonth, '', 'cmbBsMonth', 'S', '');

    var gridPros = {
            // 편집 가능 여부 (기본값 : false)
            editable : false,

            // 상태 칼럼 사용
            showStateColumn : false
    };
	myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);

});

// AUIGrid 칼럼 설정
var columnLayout = [
      {dataField : "isBoolean", headerText : "<spring:message code='sal.title.bsMonth'/>", editable : false}
    , {dataField : "accDebtOrdNo", headerText : "<spring:message code='pay.head.orderNO'/>", editable : false}
    , {dataField : "memberName", headerText : "<spring:message code='pay.head.memberName'/>", editable : false,width : 150}
    , {dataField : "customerName", headerText : "<spring:message code='pay.head.custName'/>", editable : false,width : 150 }
    , {dataField : "telM1", headerText : "<spring:message code='pay.head.mobile'/>", editable : false,width : 120}
    , {dataField : "telR", headerText : "<spring:message code='pay.head.telR'/>", editable : false,width : 120}
    , {dataField : "telO", headerText : "<spring:message code='pay.head.telO'/>", editable : false,width : 120}
    , {dataField : "telF", headerText : "<spring:message code='pay.head.fax'/>", editable : false}
    , {dataField : "payMode", headerText : "<spring:message code='pay.head.payMode'/>", editable : false}
    , {dataField : "deductStus", headerText : "<spring:message code='pay.head.deductStus'/>", editable : false}
    , {dataField : "accDebtSubOpngColctTrget", headerText : "<spring:message code='pay.head.targetAmt'/>", editable : false, width : 150,dataType:"numeric", formatString:"###0.#"}
    , {dataField : "accDebtSubCurrColct", headerText : "<spring:message code='commissiom.text.excel.collectionAmt'/>", editable : false, width : 150, dataType:"numeric"}
    , {dataField : "accDebtSubCurrAdj", headerText : "<spring:message code='commissiom.text.excel.adjAmt'/>", editable : false, width : 150, dataType : "numeric", formatString : "#,##0.##"}
    , {dataField : "accDebtSubTotOtstnd", headerText : "<spring:message code='pay.head.balance'/>", editable : false, width : 120, dataType : "numeric", formatString : "#,##0.##"}
    ];

    // ajax list 조회.
    function searchList(){
    	   Common.ajax("GET","/payment/selectRCByBSAgingMonthList.do",$("#searchForm").serialize(), function(result){
    		AUIGrid.setGridData(myGridID, result);
    	});
    }

    function viewRentalLedger(){
    	var gridObj = AUIGrid.getSelectedItems(myGridID);
console.log(gridObj);
        if(gridObj.length > 0 ){
        	var orderid = gridObj[0].item.accDebtOrdId;
            $("#ledgerForm #ordId").val(orderid);
            Common.popupWin("ledgerForm", "/sales/order/orderLedgerViewPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "no"});
        }else{
            Common.alert("<spring:message code='pay.alert.selectTheOrderFirst'/>");
            return;
        }

    }

    function fn_clear(){
        $("#searchForm")[0].reset();
    }

    function fn_excelDown(){
        // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
        GridCommon.exportTo("grid_wrap", "xlsx", "RC by BS (Aging Month)");
    }
</script>

<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on"><spring:message code='pay.text.myMenu'/></a></p>
        <h2>RC by BS (Aging Month)</h2>
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="#" onClick="viewRentalLedger()"><span class="search"></span><spring:message code='pay.btn.viewLedger'/></a></p></li>
            <li><p class="btn_blue"><a href="#" onClick="searchList()"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_clear();"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
        </ul>
    </aside>
    <!-- title_line end -->

    <!-- search_table start -->
    <section class="search_table">
        <form name="searchForm" id="searchForm">
            <!-- table start -->
            <table class="type1">
                <caption>search table</caption>
                <colgroup>
                    <col style="width:144px" />
                    <col style="width:*" />
                    <col style="width:144px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Outstanding Month</th>
                        <td><select id="cmbOutstandMonth" name="cmbOutstandMonth" class="w100p"></select></td>
                        <th scope="row">Customer Type</th>
                        <td><select name="cmbCustTypeId" id="cmbCustTypeId" class="w100p" ></select></td>
                        </tr>
                    <tr>
                    <tr>
                        <th scope="row">Is Paid</th>
                        <td><select id="cmbIsPaid" name="cmbIsPaid" class="w100p"></select></td>
                        <th scope="row">Payment Mode</th>
                        <td><select id="cmbPaymode" name="cmbPaymode" class="w100p"></select></td>
                        </tr>
                    <tr>
                        <th scope="row">Org Code</th>
                        <td><input type="text" title="orgCode" id="orgCode" name="orgCode" placeholder="Org Code" class="w100p" /></td>
                        <th scope="row">Grp Code</th>
                        <td><input type="text" title="grpCode" id="grpCode" name="grpCode"  placeholder="Grp Code" class="w100p"/></td>
                    </tr>
                    <tr>
                        <th scope="row">Dept Code</th>
                        <td><input type="text" title="deptCode" id="deptCode" name="deptCode"  placeholder="Dept Code" class="w100p"/></td>
                        <th scope="row">Member Code</th>
                        <td><input type="text" title="memCode" id="memCode" name="memCode"  placeholder="Member Code" class="w100p" /></td>
                    </tr>
                    <tr>
                        <th scope="row">BS Month</th>
                        <td><select id="cmbBsMonth" name="cmbBsMonth" class="w100p"></select></td>
                        <th scope="row" colspan="2"></th>
                    </tr>
                </tbody>
            </table>
            <!-- table end -->
        </form>
    </section>
    <!-- search_table end -->

    <ul class="right_btns">
        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
            <li><p class="btn_grid"><a href="#" onClick="fn_excelDown()"><spring:message code='service.btn.Generate'/></a></p></li>
        </c:if>
    </ul>

    <form id="ledgerForm" action="#" method="post">
        <input type="hidden" id="ordId" name="ordId" />
    </form>
    <!-- search_result start -->
    <section class="search_result">
        <!-- grid_wrap start -->
        <article id="grid_wrap" class="grid_wrap"></article>
        <!-- grid_wrap end -->

    </section>
    <!-- search_result end -->

</section>
<!-- content end -->