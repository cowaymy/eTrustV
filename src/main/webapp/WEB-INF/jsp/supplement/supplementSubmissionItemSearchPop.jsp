<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">

/* gride 동적 버튼 */
.edit-column {
  visibility:hidden;
}

</style>
<script type="text/javascript">

var basketGridID;
var ItmOption = { type: "M",
                           isCheckAll: false
                        };

$(document).ready(function() {
    fn_createBasketGrid();
    fn_initField();

    var itmType = {itemType : 7617};
    CommonCombo.make('_purcItems', "/supplement/selectSupplementItmList", itmType , '', ItmOption);

    $("#_basketAdd").click(function() {
      if($("#_purcItems").val() == null || $("#_purcItems").val() == ''){
        Common.alert("No Selected Items.");
        return;
      }

      var basketCodeArray = AUIGrid.getColumnValues(basketGridID, 'stkId');
      var values = $("#_purcItems").val();
      var msg = '';
      for (var idx = 0; idx < basketCodeArray.length; idx++) {
        for (var i = 0; i < values.length; i++) {
          if(basketCodeArray[idx] == values[i]){
            msg += $("#_purcItems").find("option[value='"+values[i]+"']").text();
            Common.alert("* " + msg +'<spring:message code="sal.alert.msg.isExistInList" />');
            return;
          }
        }
      }

      Common.ajax('GET', '/supplement/chkSupplementStockList', $("#_itemSrcForm").serialize(), function(result) {
        for (var i = 0; i < result.length; i++) {
          var calResult = fn_calculateAmt(result[i].amt, 1);
          result[i].subTotal  = calResult.subTotal;
          result[i].subChanges = calResult.subChanges;
          result[i].taxes  = calResult.taxes;
          result[i].inputQty = 1;
        }
        AUIGrid.addRow(basketGridID, result, 'last');
      });
    });

    $("#_chkDelBtn").click(function() {
      AUIGrid.removeCheckedRows(basketGridID);
    });

    $("#_itemSrchSaveBtn").click(function() {
      var valChk = true;
      var nullChkNo = AUIGrid.getRowCount(basketGridID);
      if(nullChkNo == null || nullChkNo < 1){
          Common.alert('<spring:message code="sal.alert.msg.selectItm" />');
          return;
      }

      var ivenChkArr = AUIGrid.getColumnValues(basketGridID, 'qty');
      $(ivenChkArr).each(function(idx, el) {
          if(ivenChkArr[idx] == 0){
            valChk = false;
            return false;
          }
      });

      if( valChk == false){
        Common.alert('<spring:message code="sal.alert.msg.listNoInvItm" />');
        return;
     }

     var qtyChkArr = AUIGrid.getColumnValues(basketGridID, 'inputQty');
     $(qtyChkArr).each(function(idx, el) {
        if(qtyChkArr[idx] == 0){
          valChk = false;
          return false;
        }
      });

      if(valChk == false){
        Common.alert('<spring:message code="sal.alert.msg.keyInQty" />');
        return;
      }

      if(ivenChkArr.length == qtyChkArr.length){
        $(ivenChkArr).each(function(idx , el) {
          if(ivenChkArr[idx] < qtyChkArr[idx]){
           valChk = false;
           return false;
         }
       });

       if(valChk == false){
         Common.alert('<spring:message code="sal.alert.msg.shortOfVol" />');
         return;
       }
    }else{
      Common.alert('<spring:message code="sal.alert.msg.failedToNewItm" />');
      return;
    }

    var typeArr = AUIGrid.getColumnValues(basketGridID, 'stkTypeId'); //Type Chk
    var filterChkFlag = false;

    $(typeArr).each(function(idx, el) {
      if(typeArr[idx] == 62){ //filter
        filterChkFlag = true;
        return false;
      }
    });

    var finalPurchGridData = AUIGrid.getGridData(basketGridID);
      getItemListFromSrchPop(finalPurchGridData);
      $("#_itmSrchPopClose").click();
    });
  });

  function fn_createBasketGrid(){
    var basketColumnLayout =  [ { dataField : "stkCode",
                                                 headerText : '<spring:message code="sal.title.itemCode" />',
                                                 width : '15%' ,
                                                 editable : false
                                              }, {
                                                dataField : "stkDesc",
                                                headerText : '<spring:message code="sal.title.itemDesc" />',
                                                width : '30%',
                                                editable : false
                                              }, {
                                                dataField : "qty",
                                                headerText : '<spring:message code="sal.title.inventory" />',
                                                width : '10%',
                                                editable : false ,
                                                visible :false
                                              }, {
                                               dataField : "inputQty",
                                               headerText : '<spring:message code="sal.title.qty" />',
                                               width : '10%',
                                               editable : true,
                                               dataType : "numeric"
                                             }, {
                                               dataField : "amt",
                                               headerText :'<spring:message code="sal.title.unitPrice" />',
                                               width : '10%',
                                               editable : false ,
                                               dataType : "numeric",
                                               formatString : "#,##0.00",
                                               editRenderer : { type : "InputEditRenderer",
                                                                      onlyNumeric : true,
                                                                      allowPoint : true
                                               }
                                             }, {
                                               dataField : "subChanges",
                                               headerText : '<spring:message code="sal.text.totAmt" />',
                                               width : '15%',
                                               editable : false ,
                                               dataType : "numeric",
                                               formatString : "#,##0.00",
                                               expFunction : function( rowIndex, columnIndex, item, dataField ) {
                                                // VALIDATE QUANTITY IN NUMBER ONLY
                                                if (!/^\d+$/.test(item.inputQty)) {
                                                  item.inputQty = 0;
                                                  var label = "<spring:message code='sal.text.quantity' />";
                                                  Common.alert("<spring:message code='sys.msg.invalid' arguments='"+ label + "'/>");
                                                  return false;
                                                }

                                                 var subObj = fn_calculateAmt(item.amt , item.inputQty);
                                                 return Number(subObj.subChanges);
                                               }
                                             },{
                                                dataField : "taxes",
                                                headerText : 'GST(0%)',
                                                width : '15%',
                                                editable : false ,
                                                visible :false ,
                                                dataType : "numeric",
                                                formatString : "#,##0.00",
                                                expFunction : function( rowIndex, columnIndex, item, dataField ) {
                                                  var subObj = fn_calculateAmt(item.amt , item.inputQty);
                                                  return Number(subObj.taxes);
                                                }
                                              }, {
                                                dataField : "stkTypeId" ,
                                                visible :false
                                              }, {
                                                dataField : "serialChk" ,
                                                visible :false
                                              }, {
                                                dataField : "stkId" ,
                                                visible :false
    }];

    var gridPros = { usePaging : true,
                            pageRowCount : 10,
                            fixedColumnCount : 1,
                            showStateColumn : false,
                            displayTreeOpen : false,
                            headerHeight : 30,
                            useGroupingPanel  : false,
                            skipReadonlyColumns : true,
                            wrapSelectionMove : true,
                            showRowNumColumn : true,
                            softRemoveRowMode : false,
                            showRowCheckColumn : true
    };

    basketGridID = GridCommon.createAUIGrid("#basket_grid_wrap", basketColumnLayout,'', gridPros);
      AUIGrid.resize(basketGridID , 960, 300);
  }

  function fn_initField(){
  }

  function f_multiCombo(){
    $(function() {
      $('#_purcItems').change(function() {
      }).multipleSelect({
          selectAll: false, // 전체선택
          width: '80%'
      });
    });
  }
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header">
  <h1><spring:message code="supplement.text.itemSelection" /></h1>
  <ul class="right_opt">
    <li><p class="btn_blue2"><a id="_itmSrchPopClose"><spring:message code="sal.btn.close" /></a></p></li>
  </ul>
  </header>
  <section class="pop_body">
    <form id="_itemSrcForm">
      <input type="hidden" id="_locId" name="locId" value="${whBrnchId}"/>
      <table class="type1 mt10"><!-- table start -->
      <caption>table</caption>
      <colgroup>
        <col style="width:150px" />
        <col style="width:*" />
        <col style="width:150px" />
        <col style="width:*" />
      </colgroup>
      <tbody>
        <tr>
          <th scope="row"><spring:message code="sal.title.item" /></th>
          <td colspan="4">
            <select class="w100p" id="_purcItems" name="itmLists"></select>
          </td>
        </tr>
      </tbody>
    </table>
  </form>

  <aside class="title_line">
    <h2><spring:message code="sal.title.text.purchItems" /></h2>
  </aside>

  <ul class="right_btns">
    <li><p class="btn_grid"><a id="_basketAdd"><spring:message code="sal.btn.add" /></a></p></li>
    <li><p class="btn_grid"><a id="_chkDelBtn"><spring:message code="sal.btn.del" /></a></p></li>
  </ul>

  <article class="grid_wrap">
    <div id="basket_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>
   </article>
    <div id="_gridArea"></div>
    <ul class="center_btns">
      <li><p class="btn_blue2 big"><a id="_itemSrchSaveBtn"><spring:message code="sal.btn.save2" /></a></p></li>
    </ul>
  </section>
</div>