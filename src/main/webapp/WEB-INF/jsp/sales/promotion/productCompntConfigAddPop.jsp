<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style type="text/css">

/* 커스텀 스타일 정의 */
.auto_file2 {
  width: 100% !important;
}

.auto_file2>label {
  width: 100% !important;
}

.auto_file2 label input[type=text] {
  width: 40% !important;
  float: left
}
</style>
<script type="text/javaScript">
var productCompntItemGridID;

$(document).ready(function(){
	doGetComboOrder('/common/selectCodeList.do', '320', 'CODE_ID', '', 'prodCompntConfigAppType', 'S', '');  //Application Type
	doGetComboAndGroup2('/common/selectProductCodeList.do', '', '1427', 'prodCompntConfigProduct', 'S', 'fn_setOptGrpClass'); //product
	doGetComboData('/sales/promotion/selectProductCompnt.do', '', '', 'compntId', 'S', '');

	createProductCompntItemGrid();

});

 function createProductCompntItemGrid() {
    var productCompntItemColumnLayout = [ { dataField : "compntId",
                                                           headerText : '<spring:message code="log.head.componentno" />',
                                                           width : '10%',
                                                           editable : false,
                                                           visible : false
                                                         }, {
                                                           dataField : "prdCompnt",
                                                           headerText : '<spring:message code="sal.text.AddCmpt" />',
                                                           width : '50%',
                                                           editable : false
                                                         }, {
                                                           dataField : "effectDt",
                                                           headerText : '<spring:message code="sales.EffectDate" />',
                                                           width : '20%',
                                                           editable : true
                                                         }, {
                                                           dataField : "expireDt",
                                                           headerText : '<spring:message code="sales.ExpireDate" />',
                                                           width : '20%',
                                                           editable : true
                                                         }];

    var itmGridPros = {
      showFooter : true,
      usePaging : true,
      pageRowCount : 10,
      fixedColumnCount : 1,
      showStateColumn : true,
      displayTreeOpen : false,
      headerHeight : 30,
      useGroupingPanel : false,
      skipReadonlyColumns : true,
      wrapSelectionMove : true,
      showRowNumColumn : true
    };

    productCompntItemGridID = GridCommon.createAUIGrid("#productCompntItem_grid_wrap", productCompntItemColumnLayout, '', itmGridPros);
    //AUIGrid.resize(productCompntItemGridID, 960, 300);

  }

$(function() {
	  $('#prodCompntConfigAppType').change(function() {
		  if(!FormUtil.isEmpty($('#prodCompntConfigAppType').val())){
		  doGetComboData('/sales/promotion/selectProductCompntPromotionList.do', {appType: $('#prodCompntConfigAppType').val() , stkId : $('#prodCompntConfigProduct').val() , effectStartDt : $('#prodCompntEffectStartDt').val() , effectEndDt : $('#prodCompntEffectEndDt').val() , config : 0 }, '' , 'prodCompntConfigPromo', 'S' , '');
		  }
	  });

	  $("#_addBtn").click(function() {
	        addItemToGrid();
	    });

	  $("#_delBtn").click(function() {
	        deleteSelectedRows();
	    });

	  $("#_saveBtn").click(function() {
		  if (fn_validSaveInfo())
			  if(validateGridDates())
			  fn_saveProductCompntConfigItem();
	    });
});

function validateGridDates() {
    // Regular expression for validating the date format DD/MM/YYYY
    var dateRegex = /^(0[1-9]|[12][0-9]|3[01])\/(0[1-9]|1[0-2])\/\d{4}$/;

    // Get all rows in the grid
    var rows = AUIGrid.getGridData(productCompntItemGridID);

    for (var i = 0; i < rows.length; i++) {
        var row = rows[i];

        // Validate effectDt
        if (row.effectDt && !dateRegex.test(row.effectDt)) {
            alert("Invalid date format for Effect Date (row " + (i + 1) + "). Use DD/MM/YYYY.");
            return false; // Stop validation and return an error
        }

        // Validate expireDt
        if (row.expireDt && !dateRegex.test(row.expireDt)) {
            alert("Invalid date format for Expire Date (row " + (i + 1) + "). Use DD/MM/YYYY.");
            return false; // Stop validation and return an error
        }

        // Ensure effectDt is before expireDt (if both are present)
        if (row.effectDt && row.expireDt) {
            var effectDateParts = row.effectDt.split("/");
            var expireDateParts = row.expireDt.split("/");

            var effectDate = new Date(effectDateParts[2], effectDateParts[1] - 1, effectDateParts[0]);
            var expireDate = new Date(expireDateParts[2], expireDateParts[1] - 1, expireDateParts[0]);

            if (effectDate > expireDate) {
                alert("Effect Date cannot be later than Expire Date (row " + (i + 1) + ").");
                return false;
            }
        }
    }
    return true; // All validations passed
}

function fn_validSaveInfo() {
    var isValid = true, msg = "";

    if (null == $("#prodCompntConfigAppType").val() || '' == $("#prodCompntConfigAppType").val()) {
        isValid = false;
        msg += '<spring:message code="sal.alert.msg.salAppType" /><br>';
      }

    if (null == $("#prodCompntConfigProduct").val() || '' == $("#prodCompntConfigProduct").val()) {
        isValid = false;
        msg += '<spring:message code="sales.promo.alert.msg.selectProduct" /><br>';
      }

    if (null == $("#prodCompntConfigPromo").val() || '' == $("#prodCompntConfigPromo").val()) {
        isValid = false;
        msg += '<spring:message code="sales.promo.alert.msg.selectPromotion" /><br>';
      }

    var gridData = AUIGrid.getGridData(productCompntItemGridID); // Fetch grid data
    if (!gridData || gridData.length === 0) {
        isValid = false;
        msg += '<spring:message code="sales.promo.alert.msg.productCompntEmpty" /><br>';
    }

    if (!isValid)
      Common.alert('<spring:message code="sales.promo.text.productCompntConfigSave" />'
                         + DEFAULT_DELIMITER + "<b>" + msg + "</b>");
    return isValid;
  }


function addItemToGrid() {
    // Retrieve input values
    var compntId = $("#compntId").val();
    var prdCompnt = '';

    switch (compntId) {
    case '1':
        prdCompnt = 'DEFAULT';
        break;
    case '2':
        prdCompnt = 'FAUCET';
        break;
    case '3':
        prdCompnt = 'MINERAL FILTER';
        break;
    case '4':
        prdCompnt = 'FAUCET + MINERAL FILTER';
        break;
    default:
        prdCompnt = '';
}

    var effectDt = $("#effectDt").val();
    var expireDt = $("#expireDt").val();

    // Validate input
    if (!compntId) {
        alert("Please select a component.");
        return;
    }
    if (!effectDt) {
        alert("Please enter a valid Effective Date.");
        return;
    }
    if (!expireDt) {
        alert("Please enter a valid Expire Date.");
        return;
    }

    // Check if compntId already exists in the grid
    var existingRows = AUIGrid.getGridData(productCompntItemGridID);
    for (var i = 0; i < existingRows.length; i++) {
        if (existingRows[i].compntId === compntId) {
            alert("The selected component already exists in the grid.");
            return;
        }
    }

    // Prepare new row data
    var newRow = {
        compntId: compntId,
        prdCompnt: prdCompnt,
        effectDt: effectDt,
        expireDt: expireDt
    };

    // Add the row to the grid
    AUIGrid.addRow(productCompntItemGridID, newRow, "last");
}

//Function to delete selected rows
function deleteSelectedRows() {
    // Get selected rows
    var selectedRows = AUIGrid.getSelectedItems(productCompntItemGridID);

    if (selectedRows.length === 0) {
        alert("Please select a row to delete.");
        return;
    }

    // Loop through selected rows and delete them
    for (var i = 0; i < selectedRows.length; i++) {
        AUIGrid.removeRow(productCompntItemGridID, selectedRows[i].rowIndex);
    }
}

function fn_saveProductCompntConfigItem(){
	var prodCompnt = AUIGrid.getGridData(productCompntItemGridID);
	var productCompntConfigVO = {
			prodCompntList : prodCompnt ,
			appType : $('#prodCompntConfigAppType').val() ,
			stkId : $('#prodCompntConfigProduct').val(),
			promoId : $('#prodCompntConfigPromo').val()
	};

	Common.ajax("POST", "/sales/promotion/registerProductCompntConfig.do", productCompntConfigVO, function(result) {
        Common.alert("<spring:message code='sales.promo.text.productCompntConfigSummary'/>" + DEFAULT_DELIMITER + "<b>"+result.message+"</b>",fn_closeProdCompntConfigPop());

    },  function(jqXHR, textStatus, errorThrown) {
        try {
            Common.alert('<spring:message code="sales.promo.text.productCompntConfigSummary" />'
                    + DEFAULT_DELIMITER
                    + "<b><spring:message code='sales.fail.msg'/></b>"
                    + jqXHR.responseJSON.message
                    + "</b>");
  Common.removeLoader();
        }
        catch (e) {
            console.log(e);
        }
    });

}

function fn_closeProdCompntConfigPop() {
    $('#btnClose').click();
    fn_getProductCompntConfigList();
  }
</script>

<div id="popup_wrap" class="popup_wrap">
  <input type="hidden" id="prodCompntEffectStartDt" value="${bfDay}">
  <input type="hidden" id="prodCompntEffectEndDt" value="${toDay}">
  <header class="pop_header">
     <h1 id="productCompntConfigHeader"><spring:message code="sales.promo.text.productCompntConfigNew" /></h1>
    <ul class="right_opt">
      <li>
        <p class="btn_blue2">
          <a id="btnClose" href="#"><spring:message code="sal.btn.close" /></a>
        </p>
      </li>
    </ul>
  </header>

  <section class="pop_body">

    <!------------------------------------------------------------------------------
      Product Component Configuration Content START
    ------------------------------------------------------------------------------->
<aside class="title_line"><!-- title_line start -->
<h2><spring:message code='sales.title.sub.promo.promoInfo'/></h2>
</aside><!-- title_line end -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
<col style="width: 150px" />
<col style="width: *" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code='sal.text.appType'/><span class="must">*</span></th>
    <td colspan="3">
    <select id="prodCompntConfigAppType" name="prodCompntConfigAppType" class="w100p"></select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='sal.text.product'/><span class="must">*</span></th>
    <td colspan="3">
    <select id="prodCompntConfigProduct" name="prodCompntConfigProduct" class="w100p"></select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='sal.title.text.promo'/><span class="must">*</span></th>
    <td colspan="3">
    <select id="prodCompntConfigPromo" name="prodCompntConfigPromo" class="w100p"></select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code='sales.promo.text.productCompnt'/></h2>
</aside><!-- title_line end -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
<col style="width: 150px" />
<col style="width: *" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code='sal.text.AddCmpt'/><span class="must">*</span></th>
    <td colspan="3">
    <select id="compntId" name="compntId" class="w100p"></select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='sales.EffectDate'/><span class="must">*</span></th>
    <td colspan="3">
      <div class="date_set w100p">
        <p><input id="effectDt" name="effectDt" type="text" value="" title="Effective Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
      </div>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='sales.ExpireDate'/><span class="must">*</span></th>
    <td colspan="3">
    <div class="date_set w100p">
        <p><input id="expireDt" name="expireDt" type="text" value="" title="Expire Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
      </div>
    </td>
</tr>
</tbody>
</table><!-- table end -->
 <ul class="right_btns">
              <li><p class="btn_grid">
                  <a id="_addBtn"><spring:message code="sal.btn.add" /></a>
                </p></li>
              <li><p class="btn_grid">
                  <a id="_delBtn"><spring:message code="sal.btn.del" /></a>
                </p></li>
            </ul>
<article class="grid_wrap">
      <div id="productCompntItem_grid_wrap" style="width: 100%; height: 300px; margin: 0 auto;"></div>
</article>

<ul class="center_btns">
    <li><p class="btn_blue"><a id="_saveBtn" href="#"><spring:message code='sys.btn.save'/></a></p></li>
</ul>
    <!------------------------------------------------------------------------------
      Supplement Submission Content END
    ------------------------------------------------------------------------------->
  </section>
</div>
