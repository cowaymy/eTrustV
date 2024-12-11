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
var excelGridID;
var selCodeCustId;
var paymode = [{"codeId":"130","codeName":"Regular"},{"codeId":"131","codeName":"Credit Card"},{"codeId":"132","codeName":"Direct Debit"},{"codeId":"135","codeName":"PNP RPS"}];
//var outStandMonth = [{"codeId":"0","codeName":"All"},{"codeId":"1","codeName":"1"},{"codeId":"2","codeName":"2"},{"codeId":"3","codeName":"3"},{"codeId":"4","codeName":"4"}];
//var outStandMonth = [{"codeId":"","codeName":"All"},{"codeId":"0","codeName":"0"},{"codeId":"1","codeName":"1"},{"codeId":"2","codeName":"2"},{"codeId":"3","codeName":"3"},{"codeId":"4","codeName":"4"}];
var outStandMonth = [{"codeId":"","codeName":"All"},{"codeId":"1","codeName":"1"},{"codeId":"2","codeName":"2"},{"codeId":"3","codeName":"3"},{"codeId":"4","codeName":"4"}];
var isPaid = [{"codeId":"1","codeName":"Full Paid"},{"codeId":"2","codeName":"Partial Paid"},{"codeId":"3","codeName":"No Paid"}];
//var bsMonth = [{"codeId":"0","codeName":"All"},{"codeId":"1","codeName":"Yes"},{"codeId":"2","codeName":"No"}];
var bsMonth = [{"codeId":"","codeName":"All"},{"codeId":"Yes","codeName":"Yes"},{"codeId":"No","codeName":"No"}];
var openingAging = [{"codeId":"0","codeName":"All"},{"codeId":"1","codeName":"1"},{"codeId":"2","codeName":"2"},{"codeId":"3","codeName":"3"},{"codeId":"4","codeName":"4"}];
var rentalPeriod = [{"codeId":"1","codeName":"Yes"},{"codeId":"2","codeName":"No"}];
var custTypeCom = [{"codeId":"","codeName":"All"}];
//Service type
var arrSrvTypeCode = [{"codeId": "SS"  ,"codeName": "Self Service"},{"codeId": "HS" ,"codeName": "Heart Service"}];

function loadMember(){
    if("${orgCode}"){

        if("${SESSION_INFO.memberLevel}" =="1"){

            $("#orgCode").val("${orgCode}");
            $("#orgCode").attr("class", "w100p readonly");
            $("#orgCode").attr("readonly", "readonly");

        }else if("${SESSION_INFO.memberLevel}" =="2"){

            $("#orgCode").val("${orgCode}");
            $("#orgCode").attr("class", "w100p readonly");
            $("#orgCode").attr("readonly", "readonly");

            $("#grpCode").val("${grpCode}");
            $("#grpCode").attr("class", "w100p readonly");
            $("#grpCode").attr("readonly", "readonly");

        }else if("${SESSION_INFO.memberLevel}" =="3"){

            $("#orgCode").val("${orgCode}");
            $("#orgCode").attr("class", "w100p readonly");
            $("#orgCode").attr("readonly", "readonly");

            $("#grpCode").val("${grpCode}");
            $("#grpCode").attr("class", "w100p readonly");
            $("#grpCode").attr("readonly", "readonly");

            $("#deptCode").val("${deptCode}");
            $("#deptCode").attr("class", "w100p readonly");
            $("#deptCode").attr("readonly", "readonly");

        }else if("${SESSION_INFO.memberLevel}" =="4"){

            $("#orgCode").val("${orgCode}");
            $("#orgCode").attr("class", "w100p readonly");
            $("#orgCode").attr("readonly", "readonly");

            $("#grpCode").val("${grpCode}");
            $("#grpCode").attr("class", "w100p readonly");
            $("#grpCode").attr("readonly", "readonly");

            $("#deptCode").val("${deptCode}");
            $("#deptCode").attr("class", "w100p readonly");
            $("#deptCode").attr("readonly", "readonly");

            $("#memCode").val("${SESSION_INFO.userName}");
            $("#memCode").attr("class", "w100p readonly");
            $("#memCode").attr("readonly", "readonly");
        }
    }
}

$(document).ready(function(){

	loadMember();
	doGetCombo('/common/selectCodeList.do', '8', selCodeCustId ,'cmbCustTypeId', 'S', '');       // Customer Type Combo Box
	doDefCombo(paymode, '', 'cmbPaymode', 'S', '');
	doDefCombo(isPaid, '', 'cmbIsPaid', 'S', '');
	doDefCombo(outStandMonth, '0', 'cmbOutstandMonth', 'S', '');
	doDefCombo(bsMonth, '', 'cmbBsMonth', 'S', '');
	doDefCombo(openingAging, '', 'cmbOpeningAging', 'S', '');
	doDefCombo(rentalPeriod, '', 'renPrd', 'S', '');
	doDefCombo(custTypeCom, '', 'custComType', 'S', '');
	doDefCombo(arrSrvTypeCode, '', 'cmbSrvType', 'S', '');

    var gridPros = {
            // 편집 가능 여부 (기본값 : false)
            editable : false,

            // 상태 칼럼 사용
            showStateColumn : false
    };
	myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
    excelGridID = GridCommon.createAUIGrid("excel_grid_wrap", excelColumnLayout,null,gridPros);

    $("#btnRmdLtr").click(function(){

        var gridObj = AUIGrid.getSelectedItems(myGridID);
        var selIdx = AUIGrid.getSelectedIndex(myGridID)[0];
        var test = AUIGrid.getCellValue(myGridID,selIdx,"aging");

        if(gridObj == null || gridObj.length <= 0) {
            Common.alert('* <spring:message code="sal.alert.msg.noOrdSel" />');
        }else{
            if(test < 3 ){
                Common.alert('* Allowed for Outstanding Month 3 & 4 only.');
            }else{
                $("#dataForm").show();
                var ordNo = gridObj[0].item.salesOrdNo;

                $("#dataForm #_ordNo").val(ordNo);
                $("#dataForm #downFileName").val("Reminder Letter - " + ordNo);

                fn_report();
            }
        }
    });

    AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
    	  var gridObj = AUIGrid.getSelectedItems(myGridID);
    	  var orderid = gridObj[0].item.salesOrdId;
          $("#ledgerForm #ordId").val(orderid);
          Common.popupWin("ledgerForm", "/sales/order/orderLedgerViewPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "no"});
    });

});

// AUIGrid 칼럼 설정
var columnLayout = [
      {dataField : "salesOrdId", editable : false, visible : false}
    , {dataField : "bsMonth", headerText : "<spring:message code='sal.title.bsMonth'/>", editable : false}
    , {dataField : "srvtype", headerText : "<spring:message code='sales.srvType'/>", editable : false, width : 100}
    , {dataField : "salesOrdNo", headerText : "<spring:message code='pay.head.orderNO'/>", editable : false, width : 100}
    , {dataField : "jompay", headerText : "Jompay No", editable: false, width: 100}
    , {dataField : "codyCode", headerText : "Cody Code", editable : false,width : 100}
    , {dataField : "codyName", headerText : "<spring:message code='pay.head.memberName'/>", editable : false,width : 150}
    , {dataField : "custName", headerText : "<spring:message code='pay.head.custName'/>", editable : false,width : 150 }
    , {dataField : "telMobile", headerText : "<spring:message code='pay.head.mobile'/>", editable : false,width : 100}
    , {dataField : "telHome", headerText : "<spring:message code='pay.head.telR'/>", editable : false,width : 100}
    , {dataField : "telOffice", headerText : "<spring:message code='pay.head.telO'/>", editable : false,width : 100}
    , {dataField : "target", headerText : "Target", editable : false, width : 100, dataType : "numeric", formatString : "#,##0.##"}
    , {dataField : "collection", headerText : "Collection", editable : false, width : 100, dataType : "numeric", formatString : "#,##0.##"}
    , {dataField : "aging",  headerText : "Current Aging", editable : false,width : 100}
    , {dataField : "payMode", headerText : "<spring:message code='pay.head.payMode'/>", editable : false}
    , {dataField : "crc", headerText : "CRC(last 4-digit)", editable : false, width : 100}
    , {dataField : "crcExpr", headerText : "CRC Exp Date", editable : false, width : 100}
    , {dataField : "monthType", headerText :"M2 Status", editable : false , width : 100}
    , {dataField : "thisMonth", headerText : "This Mth", editable : false, width : 150}
    , {dataField : "previousMonth", headerText : "Prev Mth", editable : false, width : 150}
    ];

var excelColumnLayout = [
                    {dataField : "salesOrdId", editable : false}
                  , {dataField : "bsMonth", headerText : "<spring:message code='sal.title.bsMonth'/>", editable : false}
                  , {dataField : "srvtype", headerText : "<spring:message code='sales.srvType'/>", editable : false, width : 100}
                  , {dataField : "salesOrdNo", headerText : "<spring:message code='pay.head.orderNO'/>", editable : false, width : 100}
                  , {dataField : "jompay", headerText : "Jompay No", editable: false, width: 100}
                  , {dataField : "scmcode", headerText : "SCM Code", editable : false,width : 100}
                  , {dataField : "cmCode", headerText : "CM Code", editable : false,width : 100}
                  , {dataField : "codyCode", headerText : "Cody Code", editable : false,width : 100}
                  , {dataField : "codyName", headerText : "<spring:message code='pay.head.memberName'/>", editable : false,width : 150}
                  , {dataField : "custName", headerText : "<spring:message code='pay.head.custName'/>", editable : false,width : 150 }
                  , {dataField : "telMobile", headerText : "<spring:message code='pay.head.mobile'/>", editable : false,width : 100}
                  , {dataField : "telHome", headerText : "<spring:message code='pay.head.telR'/>", editable : false,width : 100}
                  , {dataField : "telOffice", headerText : "<spring:message code='pay.head.telO'/>", editable : false,width : 100}
                  , {dataField : "target", headerText : "Target", editable : false, width : 100, dataType : "numeric", formatString : "#,##0.##"}
                  , {dataField : "collection", headerText : "Collection", editable : false, width : 100, dataType : "numeric", formatString : "#,##0.##"}
                  , {dataField : "aging",  headerText : "Current Aging", editable : false,width : 100}
                  , {dataField : "opngAging",  headerText : "Opening Aging", editable : false,width : 100}
                  , {dataField : "payMode", headerText : "<spring:message code='pay.head.payMode'/>", editable : false}
                  , {dataField : "crc", headerText : "CRC(last 4-digit)", editable : false, width : 100}
                  , {dataField : "crcExpr", headerText : "CRC Exp Date", editable : false, width : 100}
                  , {dataField : "monthType", headerText :"M2 Status", editable : false , width : 100}
                  , {dataField : "thisMonth", headerText : "This Mth", editable : false, width : 150}
                  , {dataField : "previousMonth", headerText : "Prev Mth", editable : false, width : 150}
                  ];

    // ajax list 조회.
    function searchList(){
    	   Common.ajax("GET","/payment/selectRCByBSAgingMonthNewList.do",$("#searchForm").serialize(), function(result){
    		console.log("result :: " + result);
    		AUIGrid.setGridData(myGridID, result);
    		AUIGrid.setGridData(excelGridID, result);
    	});
    }

    function viewRentalLedger(){
        var gridObj = AUIGrid.getSelectedItems(myGridID);

        if(gridObj.length > 0 ){
            var orderid = gridObj[0].item.salesOrdId;
            $("#ledgerForm #ordId").val(orderid);
            Common.popupWin("ledgerForm", "/sales/order/orderLedgerViewPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "no"});
        }else{
            Common.alert("<spring:message code='pay.alert.selectTheOrderFirst'/>");
            return;
        }
    }

    function fn_clear(){
        $("#searchForm")[0].reset();
        loadMember();
    }

    function fn_excelDown(){
        // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
        GridCommon.exportTo("excel_grid_wrap", "xlsx", "RC by HS (Aging Month)");
    }

    function fn_report(){
        var option = {
                isProcedure : false
        };
        Common.report("dataForm",option);
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
        <h2>RC by HS (Aging Month)</h2>
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
            <input type="hidden" id="memType" name="memType" value="2">

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
                        <th scope="row">HS Month</th>
                        <td><select id="cmbBsMonth" name="cmbBsMonth" class="w100p"></select></td>
                        <th scope="row">Opening Aging</th>
                        <td><select id="cmbOpeningAging" name="cmbOpeningAging" class="w100p"></select></td>
                    </tr>
                    <tr>
                        <th scope="row">Rental Membership</th>
                        <td><input type="text" title="renMem" id="renMem" name="renMem" placeholder="Rental Membership" class="w100p" /></td>
                        <th scope="row">Rental Period</th>
                        <td> <select id="renPrd" name="renPrd" class="w100p" ></select></td>
                    </tr>
                    <tr>
                        <th scope="row"><spring:message code='sales.srvType'/></th>
                        <td><select class="w100p" id="cmbSrvType" name="cmbSrvType"></td>
                        <th scope="row">Cust Type Company</th>
                        <td> <select id="custComType" name="custComType" class="w100p" ></select></td>
                    </tr>
                </tbody>
            </table>
            <!-- table end -->

      <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
    <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
    <dl class="link_list">
        <dt>Link</dt>
        <dd>
        <ul class="btns">

            <li><p class="link_btn"><a href="#" id="btnRmdLtr">Reminder Letter</a></p></li>

        </ul>
        <ul class="btns">
        </ul>
        <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
        </dd>
    </dl>
    </aside><!-- link_btns_wrap end -->

     </form>

     <form id="dataForm">
     <input type = "hidden" id ="fileName" name ="reportFileName" value="/sales/CodyRemindLetter.rpt" />
     <input type = "hidden" id ="viewType" name ="viewType" value="PDF" />
     <input type = "hidden" id ="downFileName" name ="reportDownFileName" value="" />

     <input type = "hidden" id ="_ordNo" name="@ordNo" />
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
        <article id="excel_grid_wrap" class="grid_wrap" style="display: none;"></article>

        <!-- grid_wrap end -->

    </section>
    <!-- search_result end -->

</section>
<!-- content end -->