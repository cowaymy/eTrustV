<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
var myGridID;

//Grid에서 선택된 RowID
var selectedGridValue;

//페이징에 사용될 변수
var _totalRowCount;

$(document).ready(function(){
    $("#taskId").val("${taskId}");
    console.log("taskId2 : " + $("#taskId").val());
    myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
    
   fn_initData();
   
});

var gridPros = {
        showRowNumColumn : false,
        editable: false,
        showStateColumn: false,
        usePaging : false
};

var columnLayout=[
    {dataField:"rnum", headerText:"<spring:message code='pay.head.no'/>", width : 80},
    {dataField:"salesOrdNo", headerText:"<spring:message code='pay.head.orderNo'/>", width : 120},
    {dataField:"taskBillGrpId", headerText:"<spring:message code='pay.head.billGroup'/>", width : 120},
    {dataField:"name", headerText:"<spring:message code='pay.head.customerName'/>", width : 250},
    {dataField:"taskBillInstNo", headerText:"<spring:message code='pay.head.installment'/>", width : 100},
    {dataField:"taskBillAmt", headerText:"<spring:message code='pay.head.amount'/>", width : 100},
    {dataField:"taskRefDtTm", headerText:"<spring:message code='pay.head.issued'/>" , width : 160, dataType : "date", formatString : "yyyy-mm-dd HH:MM:ss"}
];

function fn_initData(){
    fn_getBillingList(1);
}

function fn_getBillingList(goPage){ 
    //페이징 변수 세팅
    $("#pageNo").val(goPage);   
    
    Common.ajax("GET", "/payment/selectBillingResultList.do", $("#searchForm").serialize(), function(result) {
        //AUIGrid.setGridData(myGridID, result);
        console.log(result);
        $("#t_taskId").text(result.master.taskId);
        $("#t_billingMNY").text(result.master.billingMonth + "/" + result.master.billingYear);
        $("#t_count").text(result.master.totCnt);
        
        //금액 천단위 콤마 + 소수 둘쨰자리 계산
        var tmpAmt = ""+result.master.totAmt.toFixed(2);
        var temp = tmpAmt.split(".");
        var amt = commaSeparateNumber(temp[0]);
        $("#t_amount").text("RM"+amt+"."+temp[1]);
        AUIGrid.setGridData(myGridID, result.detail);
        
        //전체건수 세팅
        _totalRowCount = result.totalRowCount;
        
        //페이징 처리를 위한 옵션 설정
        var pagingPros = {
                // 1페이지에서 보여줄 행의 수
                rowCount : $("#rowCount").val()
        };
        
        GridCommon.createPagingNavigator(goPage, _totalRowCount , pagingPros);
        
    });
}


//페이지 이동
function moveToPage(goPage){
    //페이징 변수 세팅
    $("#pageNo").val(goPage);
    
    Common.ajax("GET", "/payment/selectBillingResultListPaging.do", $("#searchForm").serialize(), function(result) {        
        AUIGrid.setGridData(myGridID, result.detail);
        
        //페이징 처리를 위한 옵션 설정
        var pagingPros = {
                // 1페이지에서 보여줄 행의 수
                rowCount : $("#rowCount").val()
        };
        
        GridCommon.createPagingNavigator(goPage, _totalRowCount , pagingPros);        
    });    
}

function fn_backPage(){
    //location.replace("/payment/initBillingMgmt.do");
    location.replace("/payment/initBillingMgmt.do");
}

function commaSeparateNumber(val){
    while (/(\d+)(\d{3})/.test(val.toString())){
      val = val.toString().replace(/(\d+)(\d{3})/, '$1'+','+'$2');
    }
    return val;
}

//크리스탈 레포트
function fn_billList(){    
    //report 호출
    var option = {
    	    isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
    };

    Common.report("reportPDFForm", option);    
}

</script>
<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Payment</li>
        <li>Billing</li>
        <li>Billing Result</li>
    </ul>

    <aside class="title_line"><!-- title_line start -->
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>Billing Result</h2>
        <ul class="right_opt">
            <li><p class="btn_blue"><a href="javascript:fn_getBillingList(1);"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
        </ul>
    </aside><!-- title_line end -->

    <section class="search_table"><!-- search_table start -->
        <form name="searchForm" id="searchForm"  method="post">
            <input type="hidden" name="taskId" id="taskId" value="${taskId }" />            
            <input type="hidden" name="rowCount" id="rowCount" value="10" />
            <input type="hidden" name="pageNo" id="pageNo" />

            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:140px" />
                    <col style="width:*" />
                    <col style="width:130px" />
                    <col style="width:*" />
                    <col style="width:160px" />
                    <col style="width:*" />
                    <col style="width:140px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Order No</th>
                        <td><input type="text" id="orderNo" name="orderNo" class="w100p"/></td>
                        <th scope="row">Bill No.</th>
                        <td><input type="text" id="billNo" name="billNo" class="w100p"/></td>
                        <th scope="row">Customer Name</th>
                        <td><input type="text" id="custName" name="custName" class="w100p"/></td>
                        <th scope="row">Bill Group</th>
                        <td><input type="text" id="group" name="group"  class="w100p"/></td>
                    </tr>
                </tbody>
            </table><!-- table end -->
        </form>
    </section><!-- search_table end -->

    <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
        <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
        <dl class="link_list">
            <dt>Link</dt>
            <dd>
                <ul class="btns">
                    <li><p class="link_btn"><a href="javascript:fn_billList()"><spring:message code='pay.btn.billList'/></a></p></li>
                </ul>
                <ul class="btns">
                    <li><p class="link_btn type2"><a href="javascript:fn_backPage()"><spring:message code='pay.btn.backtoListPage'/></a></p></li>
                </ul>
                <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
            </dd>
        </dl>
    </aside><!-- link_btns_wrap end -->

    <table class="type1 mt30"><!-- table start -->
        <caption>table</caption>
        <colgroup>
            <col style="width:140px" />
            <col style="width:*" />
            <col style="width:130px" />
            <col style="width:*" />
            <col style="width:160px" />
            <col style="width:*" />
            <col style="width:140px" />
            <col style="width:*" />
        </colgroup>
        <tbody>
            <tr>
                <th scope="row">Task ID</th>
                <td id="t_taskId"></td>
                <th scope="row">Billing Month/Year</th>
                <td id="t_billingMNY"></td>
                <th scope="row">Bill Count</th>
                <td id="t_count"></td>
                <th scope="row">Total Amount</th>
                <td id="t_amount"></td>
            </tr>
        </tbody>
    </table><!-- table end -->
    
    <!-- grid_wrap start -->
    <article id="grid_wrap" class="grid_wrap"></article>
    <div id="grid_paging" class="aui-grid-paging-panel my-grid-paging-panel"></div>
    <!-- grid_wrap end -->


</section><!-- content end -->

<form name="reportPDFForm" id="reportPDFForm"  method="post">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/bill/RentledgerMaster.rpt" />
    <input type="hidden" id="viewType" name="viewType" value="EXCEL" />    
    <input type="hidden" id="v_taskId" name="v_taskId" value="${taskId }" />
</form>
