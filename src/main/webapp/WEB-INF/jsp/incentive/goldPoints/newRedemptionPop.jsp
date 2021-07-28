<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript" language="javascript">
    var expGridID;
    var ptsExpiryList;

    $(document).ready(function() {

        if('${ptsExpiryList}' == '' || '${ptsExpiryList}' == null){
             // Do nothing
        }else{
            ptsExpiryList = JSON.parse('${ptsExpiryList}');
        }

        createExpiryAUIGrid();
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

</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
  <header class="pop_header"><!-- pop_header start -->
    <h1><spring:message code="incentive.title.goldPtsNewRedemption" /></h1>
    <ul class="right_opt">
      <li><p class="btn_blue2"><a id="btnPopClose" href="#"><spring:message code="sal.btn.close" /></a></p></li>
    </ul>
  </header><!-- pop_header end -->

  <section class="pop_body"><!-- pop_body start -->

    <aside class="title_line"><!-- title_line start -->
      <h3>Basic Information:</h3>
    </aside><!-- title_line end -->
    <table class="type1"><!-- table start -->
      <caption>table</caption>
      <colgroup>
        <col style="width:170px" />
        <col style="width:*" />
      </colgroup>
      <tbody>
        <tr>
          <th scope="row">Salesman Code / Name </th>
          <td><span>${rBasicInfo.memCode} - ${rBasicInfo.memName}</span></td>
        </tr>
        <tr>
          <th scope="row">Mobile No.</th>
          <td><span>${rBasicInfo.telMobile}</span></td>
          </tr>
        <tr>
          <th scope="row">Email</th>
          <td><span>${rBasicInfo.email}</span></td>
        </tr>
        <tr>
          <th scope="row">Gold Points Available</th>
          <td><span>${rBasicInfo.totBalPts}</span></td>
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

    <aside class="title_line"><!-- title_line start -->
      <h3>Redeem Information:</h3>
    </aside><!-- title_line end -->
    <table class="type1"><!-- table start -->
      <caption>table</caption>
      <colgroup>
        <col style="width:160px" />
        <col style="width:*" />
      </colgroup>
      <tbody>
        <tr>
          <th scope="row">Category</th>
          <td><span>${trxHistory.memCode}</span></td>
        </tr>
        <tr>
          <th scope="row">Items</th>
          <td><span>${trxHistory.memName}</span></td>
          </tr>
        <tr>
          <th scope="row">Gold Points Per Unit</th>
          <td><span>${trxHistory.status}</span></td>
        </tr>
        <tr>
          <th scope="row">Quantity</th>
          <td><span>${trxHistory.totBalPts}</span></td>
        </tr>
        <tr>
          <th scope="row">Total Gold Points Required</th>
          <td><span>${trxHistory.totBalPts}</span></td>
        </tr>
        <tr>
          <th scope="row">Balance Gold Points</th>
          <td><span>${trxHistory.totBalPts}</span></td>
        </tr>
      </tbody>
    </table><!-- table end -->

    <aside class="title_line"><!-- title_line start -->
      <h3>Collection Information:</h3>
    </aside><!-- title_line end -->
    <table class="type1"><!-- table start -->
      <caption>table</caption>
      <colgroup>
        <col style="width:160px" />
        <col style="width:*" />
      </colgroup>
      <tbody>
        <tr>
          <th scope="row">Collection Branch</th>
          <td><span>${trxHistory.memCode}</span></td>
        </tr>
      </tbody>
    </table><!-- table end -->

  </section><!-- pop_body end -->

</div><!-- popup_wrap end -->