<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript" language="javascript">
    var expGridID, trxGridID;
    var ptsExpiryList;

    $(document).ready(function() {

    	if('${ptsExpiryList}' == '' || '${ptsExpiryList}' == null){
    	     // Do nothing
    	}else{
    	 	ptsExpiryList = JSON.parse('${ptsExpiryList}');
    	}

        if('${trxHistoryList}' == '' || '${trxHistoryList}' == null){
            // Do nothing
       }else{
    	   trxHistoryList = JSON.parse('${trxHistoryList}');
       }

        createExpiryAUIGrid();
        createTransactionAUIGrid();
    });

    function createExpiryAUIGrid() {
    	var expiryDtlColumnLayout =
    	    [
    	        {
    	            dataField : "gpDesc",
    	            headerText : "Reference",
    	            width : "40%"
    	        }, {
    	            dataField : "gpUplPts",
    	            headerText : "Points Earned",
    	            width : "15%"
    	        },
    	         {
                    dataField : "gpBalPts",
                    headerText : "Points Balance",
                    width : "15%"
                },{
    	            dataField : "gpEndDt",
    	            headerText : "Expiry Date",
    	            width : "30%"
    	        }
    	    ];

        var expOptions = {
                usePaging : true,
                useGroupingPanel : false,
                showRowNumColumn : false
              };

        expGridID = GridCommon.createAUIGrid("expGrid", expiryDtlColumnLayout, "", expOptions);
        AUIGrid.setGridData(expGridID, ptsExpiryList);
    }

    function createTransactionAUIGrid() {

    	var trxColumnLayout =
    	    [
    	        {
    	            dataField : "trxDtDisplay",
    	            headerText : "Date",
    	            width : "10%",
    	            sortable : false
    	        }, {
    	            dataField : "redemptionNo",
    	            headerText : "Redemption Number",
    	            width : "20%",
    	            sortable : false
    	        }, {
    	            dataField : "itemsDesc",
    	            headerText : "Items Description",
    	            width : "30%",
    	            sortable : false
    	        }, {
    	            dataField : "earnedDisplay",
    	            headerText : "Earned",
    	            width : "10%",
    	            sortable : false
    	        }, {
    	            dataField : "rdmOrExpDisplay",
    	            headerText : "Redeemed / Expired",
    	            width : "20%",
    	            sortable : false
    	        }, {
    	            dataField : "runningBal",
    	            headerText : "Balance",
    	            width : "10%",
    	            sortable : false
    	        }
    	    ];

        var trxOptions = {
                usePaging : true,
                useGroupingPanel : false,
                showRowNumColumn : false
              };

        trxGridID = GridCommon.createAUIGrid("trxGrid", trxColumnLayout, "", trxOptions);
        AUIGrid.setGridData(trxGridID, trxHistoryList);
    }

</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
  <header class="pop_header"><!-- pop_header start -->
    <h1><spring:message code="incentive.title.goldPtsTrxHistoryView" /></h1>
    <ul class="right_opt">
      <li><p class="btn_blue2"><a id="btnPopClose" href="#"><spring:message code="sal.btn.close" /></a></p></li>
    </ul>
  </header><!-- pop_header end -->

  <section class="pop_body"><!-- pop_body start -->
    <table class="type1"><!-- table start -->
      <caption>table</caption>
      <colgroup>
        <col style="width:160px" />
        <col style="width:*" />
      </colgroup>
      <tbody>
        <tr>
          <th scope="row">HP Code</th>
          <td><span>${memInfo.memCode}</span></td>
        </tr>
        <tr>
          <th scope="row">Member Name</th>
          <td><span>${memInfo.memName}</span></td>
          </tr>
        <tr>
          <th scope="row">Status</th>
          <td><span>${memInfo.status}</span></td>
        </tr>
        <tr>
          <th scope="row">Position Desc.</th>
          <td><span>${memInfo.positionDesc}</span></td>
        </tr>
        <tr>
          <th scope="row">Gold Points Available</th>
          <td><span>${memInfo.totBalPts}</span></td>
        </tr>
      </tbody>
    </table><!-- table end -->

    <div class="autoFixArea">
      <aside class="title_line"><!-- title_line start -->
        <h3>Gold Points Expiry Details:</h3>
      </aside><!-- title_line end -->
      <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="expGrid" style="height:200px;"></div>
      </article><!-- grid_wrap end -->
    </div>

    <div class="autoFixArea">
      <aside class="title_line"><!-- title_line start -->
        <h3>Transaction History:</h3>
      </aside><!-- title_line end -->
      <article class="grid_wrap" ><!-- grid_wrap start -->
        <div id="trxGrid" style="height:200px;"></div>
      </article><!-- grid_wrap end -->
    </div>
  </section><!-- pop_body end -->

</div><!-- popup_wrap end -->