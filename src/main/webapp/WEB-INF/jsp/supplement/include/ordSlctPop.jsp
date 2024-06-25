<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

var orderGridID;
var supItmDetailGridID;

$(document).ready(function() {
  createAUIGrid();
  createSupplementItmGrid();

   $("#_orderSearchBtn").click(function() {
       fn_getSearchResultJsonListAjax();
   });

   $("#_orderSelectBtn").click(function() {
     var rowIdx = AUIGrid.getSelectedIndex(orderGridID)[0];

     if(rowIdx > -1) {
       var ordNo = AUIGrid.getCellValue(orderGridID, rowIdx, "supRefNo");

       $("#_closeOrdPop").click();
       $("#_salesOrderNo").val(ordNo);
       $("#_confirm").click();

       fn_callbackOrdSearchFunciton(ordNo);
     }
   });

  var pickerOpts = {
    changeMonth:true,
    changeYear:true,
    dateFormat: "dd/mm/yy"
  };

  $(".j_date").datepicker(pickerOpts);

  var monthOptions = {
    pattern: 'mm/yyyy',
    selectedYear: 2017,
    startYear: 2007,
    finalYear: 2027
  };

  $(".j_date2").monthpicker(monthOptions);

   /*AUIGrid.bind(orderGridID, "cellDoubleClick", function(event) {
     $("#_closeOrdPop").click();
     $("#_salesOrderNo").val(event.item.ordNo);
     $("#_confirm").click();

     try  {
       fn_callbackOrdSearchFunciton(event.item);
     }catch(e){

     }
    });*/

   AUIGrid.bind(orderGridID, "cellClick", function(event) {
     AUIGrid.clearGridData(supItmDetailGridID);

     var detailParam = {
       supRefId : event.item.supRefId
     };

     Common.ajax("GET", "/supplement/getSupplementDetailList", detailParam, function(result) {
       AUIGrid.setGridData(supItmDetailGridID, result);
       //AUIGrid.setGridData(excelListGridID, result);
     });
  });

  function createAUIGrid(){
    var orderColumnLayout = [ {dataField : "supRefId",headerText : '<spring:message code="supplement.text.supplementReferenceNo" />', width : '20%'},
                                          {dataField : "supRefNo",headerText : '<spring:message code="supplement.text.supplementReferenceNo" />', width : '20%'},
                                          {dataField : "ordDt", headerText : '<spring:message code="sal.text.ordDate" />', width : '15%'},
                                          {dataField : "supRefStus", headerText : '<spring:message code="sal.title.status" />', width : '15%'},
                                          {dataField : "custName", headerText : '<spring:message code="sal.text.custName" />',width : '40%'},
                                          {dataField : "custNric", headerText : '<spring:message code="sal.title.text.nricCompNo" />', width : '15%'}
    ];

    var gridPros = { usePaging : true,
                            pageRowCount : 20,
                            editable : false,
                            fixedColumnCount : 1,
                            showStateColumn : true,
                            displayTreeOpen : false,
                            headerHeight : 30,
                            useGroupingPanel : false,
                            skipReadonlyColumns : true,
                            wrapSelectionMove : true,
                            showRowNumColumn : true
    };

    orderGridID = GridCommon.createAUIGrid("#order_grid_wrap", orderColumnLayout, '', gridPros);
  }

  function createSupplementItmGrid(){
    var supplementItmColumnLayout =  [
                                {dataField : "itemCode", headerText : '<spring:message code="sal.title.itemCode" />', width : '10%' , editable : false},
                                {dataField : "itemDesc", headerText : '<spring:message code="sal.title.itemDesc" />', width : '75%' , editable : false},
                                {dataField : "quantity", headerText : '<spring:message code="sal.title.qty" />', width : '10%' , editable : false},
                                {dataField : "supSubmItmId", visible : false},
                                {dataField : "supSubmId", visible : false}
                           ];

    var itmGridPros = { showFooter : true,
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

    supItmDetailGridID = GridCommon.createAUIGrid("#supplement_itm_grid_wrap_1", supplementItmColumnLayout,'', itmGridPros);  // address list
    AUIGrid.resize(supItmDetailGridID, 960, 300);
    var footerLayout = [ {
      labelText : "Total",
      positionField : "#base"
    }, {
      dataField : "quantity",
      positionField : "quantity",
      operation : "SUM",
      formatString : "#,##0",
      style : "aui-grid-my-footer-sum-total2"
    } ];

    AUIGrid.setFooter(supItmDetailGridID, footerLayout);
  }

  function fn_getSearchResultJsonListAjax(){
    Common.ajax("GET", "/supplement/searchOrderNo.do",$("#_searchOrdForm").serialize(), function(result) {
      AUIGrid.setGridData(orderGridID, result);
    });
  }

  $.fn.clearForm = function() {
    return this.each(function() {
      var type = this.type, tag = this.tagName.toLowerCase();
      if (tag === 'form'){
        return $(':input',this).clearForm();

        if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
          this.value = '';
        } else if (type === 'checkbox' || type === 'radio'){
          this.checked = false;
        } else if (tag === 'select'){
          this.selectedIndex = -1;
        }
      }
    });
  };
});
</script>

<div id="popup_wrap" class="popup_wrap">
  <header class="pop_header">
    <h1><spring:message code="sal.title.text.ordSrch" /></h1>
    <ul class="right_opt">
      <li><p class="btn_blue2"><a href="#none" id="_closeOrdPop"><spring:message code="sal.btn.close" /></a></p></li>
    </ul>
  </header>
  <section class="pop_body">
  <ul class="right_btns mb10">
    <li><p class="btn_blue"><span class="search"></span><a href="#none" id="_orderSelectBtn"><spring:message code="sys.info.select" /></a></p></li>
    <li><p class="btn_blue"><span class="search"></span><a href="#none" id="_orderSearchBtn"><spring:message code="sal.btn.search" /></a></p></li>
    <li><p class="btn_blue"><span class="clear" ></span><a href="#none" onclick="javascript:$('#_searchOrdForm').clearForm();"><spring:message code="sal.btn.clear" /></a></p></li>
  </ul>
  <form id="_searchOrdForm" method="get">
    <table class="type1"><!-- table start -->
      <caption>table</caption>
      <colgroup>
        <col style="width:140px" />
        <col style="width:*" />
        <col style="width:100px" />
        <col style="width:*" />
        <col style="width:140px" />
        <col style="width:*" />
      </colgroup>
      <tbody>
        <tr>
          <th scope="row"><spring:message code="supplement.text.supplementReferenceNo" /></th>
          <td><input type="text" title="" placeholder="Order No" class="w100p" name="searchOrdNo" /></td>
          <th scope="row"><spring:message code="sal.text.ordDate" /></th>
          <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_dateHc w100p"  name="searchOrdDate"/></td>
          <th scope="row"></th>
          <td></td>
        </tr>
        <tr>
          <th scope="row"><spring:message code="sal.text.custName" /></th>
          <td colspan="3"><input type="text" title="" placeholder="Customer Name" class="w100p"  name="searchOrdCustName"/></td>
          <th scope="row"><spring:message code="sal.title.text.nricCompNo" /></th>
          <td><input type="text" title="" placeholder="NRIC/Company No" class="w100p"  name="searchOrdCustNric"/></td>
        </tr>
      </tbody>
    </table>
  </form>
  <section class="search_result">
    <article class="grid_wrap"><!-- grid_wrap start -->
      <div id="order_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>
    </article>
  </section>

  <section class="search_result">
    <div id="_itmDetailGridDiv">
      <aside class="title_line">
        <h3><spring:message code="sal.title.itmList" /></h3>
      </aside>
      <article class="grid_wrap">
      <div id="supplement_itm_grid_wrap_1" style="width:100%; height:300px; margin:0 auto;"></div>
      </article>
    </div>
  </section>
</section>
</div>
