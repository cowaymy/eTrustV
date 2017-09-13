<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javaScript">
var myGridID;

//Grid에서 선택된 RowID
var selectedGridValue;

$(document).ready(function(){
	$("#taskId").val("${taskId}");
	console.log("taskId2 : " + $("#taskId").val());
    myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
    
   fn_initData();
   
});

var gridPros = {
        editable: false,
        showStateColumn: false,
        pageRowCount : 10
};

var columnLayout=[
    {dataField:"salesOrdNo", headerText:"Order No"},
    {dataField:"taskBillGrpId", headerText:"Bill Group"},
    {dataField:"name", headerText:"Customer Name"},
    {dataField:"taskBillInstNo", headerText:"Installment"},
    {dataField:"taskBillAmt", headerText:"Amount"},
    {dataField:"taskRefDtTm", headerText:"Issued" , dataType : "date", formatString : "yyyy-mm-dd hh:MM:ss"}
];

function fn_initData(){
	fn_getBillingList();
}

function fn_getBillingList(){
	Common.ajax("GET", "/payment/selectBillingResultList.do", $("#searchForm").serialize(), function(result) {
        //AUIGrid.setGridData(myGridID, result);
        console.log(result);
        $("#t_taskId").text(result.master.taskId);
        $("#t_billingMNY").text(result.master.billingMonth + "/" + result.master.billingYear);
        $("#t_count").text(result.master.totCnt);
        $("#t_amount").text(result.master.totAmt);
        
        AUIGrid.setGridData(myGridID, result.detail);
    });
}

function fn_backPage(){
	//location.replace("/payment/initBillingMgnt.do");
	location.replace("/payment/initBillingMgnt.do");
}

</script>

<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Payment</li>
        <li>Billing</li>
        <li>Billing Result</li>
    </ul>
    
    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="javascript:;" class="click_add_on">My menu</a></p>
        <h2>Billing Result</h2>   
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:fn_getBillingList();"><span class="search"></span>Search</a></p></li>
        </ul>    
    </aside>
    <!-- title_line end -->


 <!-- search_table start -->
    <section class="search_table">
        <form name="searchForm" id="searchForm"  method="post">
        <input type="hidden" name="taskId" id="taskId" value="${taskId }" />
             <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:110px" />
                    <col style="width:110px" />
                    <col style="width:110px" />
                    <col style="width:110px" />
                    <col style="width:140px" />
                    <col style="width:*" />
                    <col style="width:140px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Order No.</th>
                        <td>
                            <input type="text" id="orderNo" name="orderNo" class="w100p"/>
                        </td>
                        <th scope="row">Bill No.</th>
                        <td>
                           <input type="text" id="billNo" name="billNo" class="w100p"/>
                        </td>
                        <th scope="row">Customer Name</th>
                        <td>
                           <input type="text" id="custName" name="custName" class="w100p"/>
                        </td>
                        <th scope="row">Bill Group</th>
                        <td>
                           <input type="text" id="group" name="group"  class="w100p"/>
                        </td>
                    </tr>
                 </tbody>
              </table>
        </form>
        </section>

 <!-- search_result start -->
<section class="search_result">     

    <!-- link_btns_wrap start -->
        <aside class="link_btns_wrap">
            <p class="show_btn"><a href="#"><img src="/resources/images/common/btn_link.gif" alt="link show" /></a></p>
            <dl class="link_list">
                <dt>Link</dt>
                <dd>
                    <ul class="btns">
                        <li><p class="link_btn type2"><a href="javascript:fn_backPage()">Back to List Page</a></p></li>
                    </ul>
                    <p class="hide_btn"><a href="#"><img src="/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
                </dd>
            </dl>
        </aside>
        <!-- link_btns_wrap end -->
        
        <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:110px" />
                    <col style="width:110px" />
                    <col style="width:150px" />
                    <col style="width:150px" />
                    <col style="width:150px" />
                    <col style="width:50px" />
                    <col style="width:*" />
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
              </table>
              
    <!-- grid_wrap start -->
    <article id="grid_wrap" class="grid_wrap"></article>
    <!-- grid_wrap end -->
</section>
</section>

<!-- popup_wrap end -->