<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">
    var expGridID;
    var ptsExpiryList;
    var itemListData;

    $(document).ready(function() {

        if('${ptsExpiryList}' == '' || '${ptsExpiryList}' == null){
             // Do nothing
        }else{
            ptsExpiryList = JSON.parse('${ptsExpiryList}');
        }

        createExpiryAUIGrid();
        populateCategoryList();
        populateItemsList("");

        $("#categoryList").change(function() {
        	var selectedCat = $("#categoryList").val();
        	populateItemsList(selectedCat);
            $("#goldPtsPerUnit").val('');
        	recalculateTotAndBal();
        });

        $("#redemptionItemList").change(function() {
            var selectedItm = $("#redemptionItemList").val();
            populateGoldPtsPerUnit(selectedItm);
            recalculateTotAndBal();
        });

        $("#qtySelected").change(function() {
            recalculateTotAndBal();
        });

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

    function populateCategoryList() {
        Common.ajax("GET", "/incentive/goldPoints/searchItemCategoryList", "", function(result) {
            var catListData = [];
            for (var i=0; i < result.length; i++) {
                  catListData[i] = {"codeId" : result[i].itmCat, "codeName" : result[i].itmCat};
            }
           doDefCombo(catListData, '' ,'categoryList', 'A', '');
       });
    }

    function populateItemsList(selectedCat) {
        Common.ajax("GET", "/incentive/goldPoints/searchRedemptionItemList", {category:selectedCat}, function(result) {
        	itemListData = [];
            for (var i=0; i < result.length; i++) {
                  itemListData[i] = {"codeId" : result[i].riItmId, "codeName" : result[i].itmCode + " - " + result[i].itmDesc, "gpPerUnit" : result[i].gpPerUnit};
            }
           doDefCombo(itemListData, '' ,'redemptionItemList', 'S', '');
       });
    }

    function populateGoldPtsPerUnit(selectedItm) {
    	for (var i=0; i < itemListData.length; i++) {
    	    if (itemListData[i].codeId == selectedItm) {
    	        $("#goldPtsPerUnit").val(itemListData[i].gpPerUnit);
    	    }
    	}
    }

    function recalculateTotAndBal() {

    	if ($("#redemptionItemList").val() != ''
    		  && $("#qtySelected").val() != ''
    			  && $("#qtySelected").val() != '0') {
    		var qty = $("#qtySelected").val();
    		var ptsPerUnit = $("#goldPtsPerUnit").val();
    		var tot = (parseInt(qty) || 0) * (parseInt(ptsPerUnit) || 0);
    		var balAfterRedeem = (parseInt("${rBasicInfo.totBalPts}") || 0) - tot;

    		if (balAfterRedeem < 0) {
    		    Common.alert("Insufficient points! Please reselect Quantity or Item.");
    		    $("#qtySelected").val('');
    		    $("#totGoldPtsReq").val('');
    		    $("#balGoldPts").val('');
    		} else {
    		    $("#totGoldPtsReq").val(tot);
    		    $("#balGoldPts").val(balAfterRedeem);
    		}
    	}
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
    <form action="#" method="post" name="myForm" id="myForm">
    <table class="type1"><!-- table start -->
      <caption>table</caption>
      <colgroup>
        <col style="width:160px" />
        <col style="width:*" />
      </colgroup>
      <tbody>
        <tr>
          <th scope="row">Category</th>
          <td><select id="categoryList" name="categoryList"></select></td>
        </tr>
        <tr>
          <th scope="row">Item</th>
          <td><select id="redemptionItemList" name="redemptionItemList"></select></td>
          </tr>
        <tr>
          <th scope="row">Gold Points Per Unit</th>
          <td><input type="text" id="goldPtsPerUnit" name="goldPtsPerUnit" readonly disabled /></td>
        </tr>
        <tr>
          <th scope="row">Quantity</th>
          <td>
            <select id="qtySelected" name="qtySelected">
              <option value="0" selected></option>
              <option value="1">1</option>
              <option value="2">2</option>
              <option value="3">3</option>
              <option value="4">4</option>
              <option value="5">5</option>
            </select>
          </td>
        </tr>
        <tr>
          <th scope="row">Total Gold Points Required</th>
          <td><input type="text" id="totGoldPtsReq" name="totGoldPtsReq" readonly disabled /></span></td>
        </tr>
        <tr>
          <th scope="row">Balance Gold Points</th>
          <td><input type="text" id="balGoldPts" name="balGoldPts" readonly disabled /></span></td>
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
    </form>

  </section><!-- pop_body end -->

</div><!-- popup_wrap end -->