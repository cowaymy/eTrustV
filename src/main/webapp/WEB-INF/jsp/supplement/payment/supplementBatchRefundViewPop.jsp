<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">

.aui-grid-user-custom-left {
    text-align:left;
}

.aui-grid-user-custom-right {
    text-align:right;
}
</style>
<script type="text/javascript">
var viewGridID;
var viewColumnLayout = [
        {
            dataField : "validStusId",
            headerText : "<spring:message code='supplement.head.validStatus'/>"
        }, {
            dataField : "validRem",
            headerText : "<spring:message code='supplement.head.validRemark'/>",
            style : "aui-grid-user-custom-left"
        }, {
        	dataField : "salesOrdNo",
            headerText : "<spring:message code='supplement.head.orderNo'/>"
        }, {
        	dataField : "borNo",
            headerText : "<spring:message code='supplement.head.worNo'/>"
        }, {
        	dataField : "amt",
            headerText : "<spring:message code='supplement.head.amount'/>",
            style : "aui-grid-user-custom-right",
            dataType: "numeric",
            formatString : "#,##0.00"
        }, {
        	dataField : "bankAcc",
            headerText : "<spring:message code='supplement.head.bankAcc'/>",
            style : "aui-grid-user-custom-left"
        }, {
            dataField : "refNo",
            headerText : "<spring:message code='supplement.head.refNo'/>"
        }, {
            dataField : "chqNo",
            headerText : "<spring:message code='supplement.head.chqNo'/>"
        }, {
            dataField : "name",
            headerText : "<spring:message code='supplement.head.issueBank'/>"
        }, {
            dataField : "refDtMonth",
            headerText : "<spring:message code='supplement.head.refDateMonth'/>"
        }, {
            dataField : "refDtDay",
            headerText : "<spring:message code='supplement.head.refDateDay'/>"
        }, {
            dataField : "refDtYear",
            headerText : "<spring:message code='supplement.head.refDateYear'/>"
        }
];

var viewGridPros = {
    usePaging : true,
    pageRowCount : 20,
    headerHeight : 40,
    height : 300,
    enableFilter : true,
    selectionMode : "multipleCells"
};

$(document).ready(function () {
	viewGridID = AUIGrid.create("#bRefund_view_grid_wrap", viewColumnLayout, viewGridPros);

	$("#close_btn").click(fn_closePop);

	$("#allItem_btn").click(function() {
		setFilterByValues(0);
	});

	$("#validItem_btn").click(function() {
        setFilterByValues(4);
    });
	$("#invalidItem_btn").click(function() {
        setFilterByValues(21);
    });


	console.log('${bRefundInfo.totalValidAmt}');
	var str =""+ Number('${bRefundInfo.totalValidAmt}').toFixed(2);

    var str2 = str.split(".");

    if(str2.length == 1){
        str2[1] = "00";
    }

    str = str2[0].replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+"."+str2[1];
    console.log(str);

    $("#totAmt").text(str);

	console.log($.parseJSON('${bRefundItem}'));
	AUIGrid.setGridData(viewGridID, $.parseJSON('${bRefundItem}'));

	$("#refundInfo").trigger("click");
});

function fn_closePop() {
	$("#bRefundViewPop").remove();
}

function setFilterByValues(validStusId) {
    // 4 : valid, 21 : invalid
    console.log("setFilterByValues");
    console.log(validStusId);
    if(validStusId == 4) {
    	AUIGrid.setFilterByValues(viewGridID, "validStusId", [4]);
    } else if(validStusId == 21) {
    	AUIGrid.setFilterByValues(viewGridID, "validStusId", [21]);
    } else {
    	AUIGrid.clearFilterAll(viewGridID);
    }
}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
   <header class="pop_header"><!-- pop_header start -->
       <h1><spring:message code='supplement.title.batchRefundView'/></h1>
       <ul class="right_opt">
        	<li><p class="btn_blue2"><a href="#" id="close_btn"><spring:message code='sys.btn.close'/></a></p></li>
       </ul>
   </header><!-- pop_header end -->
   <section class="pop_body"><!-- pop_body start -->
     <section class="tap_wrap">
          <ul class="tap_type1">
            <li><a href="#" class="on" id="refundInfo"><spring:message code='supplement.text.generalInfo' /></a></li>
            <li><a href="#"><spring:message code='supplement.text.batRfndDtlLst' /></a></li>
          </ul>
          <article class="tap_area"><!-- search_table start -->
                <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                	<col style="width:140px" />
                	<col style="width:*" />
                	<col style="width:130px" />
                	<col style="width:*" />
                	<col style="width:170px" />
                	<col style="width:*" />
                </colgroup>
                <tbody>
                <tr>
                	<th scope="row"><spring:message code='supplement.head.batchId'/></th>
                	<td>${bRefundInfo.batchId}</td>
                	<th scope="row"><spring:message code='supplement.head.batchStatus'/></th>
                	<td>${bRefundInfo.name}</td>
                	<th scope="row"><spring:message code='supplement.head.confirmStatus'/></th>
                    <td>${bRefundInfo.name1}</td>
                </tr>
                <tr>
                	<th scope="row"><spring:message code='supplement.head.paymode'/></th>
                	<td>${bRefundInfo.codeName}</td>
                	<th scope="row"><spring:message code='supplement.head.uploadBy'/></th>
                	<td>${bRefundInfo.username1}</td>
                	<th scope="row"><spring:message code='supplement.head.uploadAt'/></th>
                    <td>${bRefundInfo.updDt}</td>
                </tr>
                <tr>
                	<th scope="row"><spring:message code='supplement.head.confirmBy'/></th>
                	<td>${bRefundInfo.c1}</td>
                	<th scope="row"><spring:message code='supplement.head.confirmAt'/></th>
                	<td>${bRefundInfo.cnfmDt}</td>
                	<th scope="row"></th>
                    <td></td>
                </tr>
                <tr>
                	<th scope="row"><spring:message code='supplement.head.convertBy'/></th>
                	<td>${bRefundInfo.c2}</td>
                	<th scope="row"><spring:message code='supplement.head.convertAt'/></th>
                	<td>${bRefundInfo.cnvrDt}</td>
                	<th scope="row"><spring:message code='supplement.head.totAmtValid'/></th>
                    <td id="totAmt"></td>
                </tr>
                <tr>
                	<th scope="row"><spring:message code='supplement.head.totItm'/></th>
                	<td>${bRefundInfo.totalItem}</td>
                	<th scope="row"><spring:message code='supplement.head.totValid'/></th>
                	<td>${bRefundInfo.totalValid}</td>
                	<th scope="row"><spring:message code='supplement.head.totInvalid'/></th>
                    <td>${bRefundInfo.totalInvalid}</td>
                </tr>
                </tbody>
             </table><!-- table end -->
         </article><!-- search_table end -->
         <article class="tap_area"><!-- search_result start -->
           <aside class="title_line"><!-- title_line start -->
              <ul class="right_btns">
              	<li><p class="btn_grid"><a href="#" id="allItem_btn"><spring:message code='supplement.btn.allItems'/></a></p></li>
              	<li><p class="btn_grid"><a href="#" id="validItem_btn"><spring:message code='supplement.btn.validItems'/></a></p></li>
              	<li><p class="btn_grid"><a href="#" id="invalidItem_btn"><spring:message code='supplement.btn.invalidItems'/></a></p></li>
              </ul>
           </aside><!-- title_line end -->
           <section class="search_result">
               <article class="grid_wrap"><!-- grid_wrap start -->
                  <div id="bRefund_view_grid_wrap" style="width:100%; margin:0 auto;"></div>
               </article>
          </section>
        </article><!-- search_result end -->
     </section>
  </section><!-- pop_body end -->
</div><!-- popup_wrap end -->
