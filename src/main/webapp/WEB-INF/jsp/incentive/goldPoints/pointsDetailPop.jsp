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

        createExpiryAUIGrid();
        createTransactionAUIGrid();
    });

    $(function(){
        $('#btnPopClose').click(function() {
            $('#trxHistoryPop').remove();
        });
    });

    function createExpiryAUIGrid() {
    	var expiryDtlColumnLayout =
    	    [
    	        {
    	            dataField : "gpDesc",
    	            headerText : "Reference",
    	            width : "45%"
    	        }, {
    	            dataField : "gpUplPts",
    	            headerText : "Gold Points",
    	            width : "25%"
    	        }, {
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
    	            dataField : "trxDt",
    	            headerText : "Date",
    	            width : "8%"
    	        }, {
    	            dataField : "rdmNo",
    	            headerText : "Redemption Number",
    	            width : "11%"
    	        }, {
    	            dataField : "rdmDesc",
    	            headerText : "Items Description",
    	            width : "28%"
    	        }, {
    	            dataField : "earned",
    	            headerText : "Earned",
    	            width : "28%"
    	        }, {
    	            dataField : "trxType",
    	            headerText : "Redeemed / Expired",
    	            width : "15%"
    	        }, {
    	            dataField : "bal",
    	            headerText : "Balance",
    	            width : "15%"
    	        }
    	    ];

        var trxOptions = {
                usePaging : true,
                useGroupingPanel : false,
                showRowNumColumn : false
              };

        trxGridID = GridCommon.createAUIGrid("trxGrid", trxColumnLayout, "", trxOptions);
        //AUIGrid.setGridData(trxGridID, result);
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
          <td><span>${trxHistory.memCode}</span></td>
        </tr>
        <tr>
          <th scope="row">Member Name</th>
          <td><span>${trxHistory.memName}</span></td>
          </tr>
        <tr>
          <th scope="row">Status</th>
          <td><span>${trxHistory.status}</span></td>
        </tr>
        <tr>
          <th scope="row">Position Desc.</th>
          <td><span>${trxHistory.positionDesc}</span></td>
        </tr>
        <tr>
          <th scope="row">Gold Points Available</th>
          <td><span>${trxHistory.totBalPts}</span></td>
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