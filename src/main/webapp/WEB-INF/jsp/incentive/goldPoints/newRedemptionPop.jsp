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
        populateCollectionBranchList();

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
                  itemListData[i] = {"codeId" : result[i].riItmId, "codeName" : result[i].itmDisplayName, "gpPerUnit" : result[i].gpPerUnit};
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

    function populateCollectionBranchList() {
    	doGetComboSepa('/common/selectBranchCodeList.do', '45', ' - ', '', 'collectionBranchList', 'S', '');
    }

    function recalculateTotAndBal() {
    	if ($("#redemptionItemList").val() != ''
    		  && $("#qtySelected").val() != ''
    			  && $("#qtySelected").val() != '0')
    	{
    		var qty = $("#qtySelected").val();
    		var ptsPerUnit = $("#goldPtsPerUnit").val();
    		var tot = (parseInt(qty) || 0) * (parseInt(ptsPerUnit) || 0);
    		var balAfterRedeem = (parseInt("${rBasicInfo.totBalPts}") || 0) - tot;

    		if (balAfterRedeem < 0) {
    		    Common.alert("Insufficient points! Please reselect Quantity or Item.");
    		    $("#qtySelected").val('');
    		    $("#totGoldPts").val('');
    		    $("#balGoldPts").val('');
    		} else {
    		    $("#totGoldPts").val(tot);
    		    $("#balGoldPts").val(balAfterRedeem);
    		}
    	}
    }

    function validateForm() {
    	if ($("#redemptionItemList").val() == '') {
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='Item' htmlEscape='false'/>");
            return false;
        }

    	if ($("#qtySelected").val() == '' || $("#qtySelected").val() == '0') {
    		Common.alert("<spring:message code='sys.common.alert.validation' arguments='Quantity' htmlEscape='false'/>");
    		return false;
    	}

        if ($("#collectionBranchList").val() == '') {
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='Collection Branch' htmlEscape='false'/>");
            return false;
        }

        return true;
    }

    function submitRedemption() {
    	if (validateForm()) {
    		var confirmPrompt = "${rBasicInfo.memName} <br /> ${rBasicInfo.memCode} <br />" +
            $("#redemptionItemList option:selected").text() + "<br />Quantity : " + $("#qtySelected").val() + "<br />Total Gold Points : " +
            $("#totGoldPts").val() + "<br />Balance Gold Points : " + $("#balGoldPts").val() + "<br /><br />" +
            "Do you want to proceed with this redemption request?";

    		Common.confirm(confirmPrompt, proceedRedemption, '');
    	};
    }

    function proceedRedemption() {

    	var redeemInfo = {
    			rdmItm : $("#redemptionItemList").val(),
    			rdmQty : $("#qtySelected").val(),
    			rdmColBrnch : $("#collectionBranchList").val(),
    			rdmMemCode : "${rBasicInfo.memCode}"
    	};

    	Common.ajax("POST", "/incentive/goldPoints/createNewRedemption.do", redeemInfo, function(result) {

            if(result.p1 == 1) {     //successful redemption processing

            	Common.alert("Your Gold Points Redemption Request is successful. <br />Redemption No. : " + result.redemptionNo);

                Common.ajax("GET", "/incentive/goldPoints/sendNotification.do", {redemptionNo:result.redemptionNo}, function(result) {
                	console.log("notification.");
                    console.log(result);
                });

            } else if (result.p1 == 99) {
                Common.alert("Insufficient points for redemption.");
            }
    	});
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
    <form action="#" method="post" name="redeemForm" id="redeemForm">
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
            <th scope="row">Total Gold Points</th>
            <td><input type="text" id="totGoldPts" name="totGoldPts" readonly disabled /></span></td>
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
            <td><select id="collectionBranchList" name="collectionBranchList"></select></td>
          </tr>
        </tbody>
      </table><!-- table end -->

      <ul class="center_btns">
        <li><p class="btn_blue2 big"><a href="#" id="submitBtn" onclick="javascript:submitRedemption()">Redeem</a></p></li>
      </ul>

    </form>

  </section><!-- pop_body end -->

</div><!-- popup_wrap end -->