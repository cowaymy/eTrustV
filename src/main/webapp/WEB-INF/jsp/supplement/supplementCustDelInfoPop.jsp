<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

var orderGridID;

$(document).ready(function() {
  createAUIGrid();
  fn_getCustDelInfoListAjax();

  /*$("#_orderSearchBtn").click(function() {
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
  });*/

  /* var pickerOpts = {
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

   AUIGrid.bind(orderGridID, "cellClick", function(event) {
     AUIGrid.clearGridData(supItmDetailGridID);

     var detailParam = {
       supRefId : event.item.supRefId
     };

     Common.ajax("GET", "/supplement/getSupplementDetailList", detailParam, function(result) {
       AUIGrid.setGridData(supItmDetailGridID, result);
       //AUIGrid.setGridData(excelListGridID, result);
     });*/
  });

  function createAUIGrid(){
    var orderColumnLayout = [ { dataField : "supRefId",
                                             headerText : '<spring:message code="supplement.text.supplementReferenceNo" />',
                                             visible : false
                                           }, {
                                             dataField : "supRefNo",
                                             headerText : '<spring:message code="supplement.text.supplementReferenceNo" />',
                                             width : '20%'
                                           }, {
                                             dataField : "supRefDt",
                                             headerText : '<spring:message code="service.title.OrderDate" />',
                                             width : '15%'
                                           }, {
                                             dataField : "supRefPclTrkno",
                                             headerText : '<spring:message code="supplement.text.parcelTrackingNo" />',
                                             width : '18%'
                                           }, {
                                             dataField : "salPersCde",
                                             headerText : '<spring:message code="sal.text.salManCode" />',
                                             width : '15%'
                                          }, {
                                             dataField : "salPersNm",
                                             headerText : '<spring:message code="sal.text.salManName" />',
                                             width : '15%'
                                          }, {
                                             dataField : "postBr",
                                             headerText : '<spring:message code="sal.title.text.postBrnch" />',
                                             width : '15%'
                                          }, {
                                             dataField : "custNm",
                                             headerText : '<spring:message code="sal.text.custName" />',
                                             width : '15%'
                                          }, {
                                              dataField : "cntcNm",
                                              headerText : '<spring:message code="sal.title.text.contactName" />',
                                              width : '15%'
                                          }, {
                                              dataField : "cntcMb",
                                              headerText : '<spring:message code="pay.head.mobile" />',
                                              width : '15%'
                                          }, {
                                              dataField : "cntcHm",
                                              headerText : '<spring:message code="sal.text.telR" />',
                                              width : '15%'
                                          }, {
                                              dataField : "cntcOff",
                                              headerText : '<spring:message code="sal.text.telO" />',
                                              width : '15%'
                                          }, {
                                              dataField : "cntcEmail",
                                              headerText : '<spring:message code="sal.text.email" />',
                                              width : '15%'
                                          }, {
                                              dataField : "delAddr1",
                                              headerText : '<spring:message code="sal.text.addressDetail" />',
                                              width : '25%'
                                          }, {
                                              dataField : "delAddr2",
                                              headerText : '<spring:message code="sal.text.street" />',
                                              width : '25%'
                                          }, {
                                              dataField : "delPostcde",
                                              headerText : '<spring:message code="sys.title.post.code" />',
                                              width : '15%'
                                          }, {
                                              dataField : "delCity",
                                              headerText : '<spring:message code="sal.text.city" />',
                                              width : '15%'
                                          }, {
                                              dataField : "delState",
                                              headerText : '<spring:message code="sys.title.state" />',
                                              width : '15%'
                                          }, {
                                              dataField : "delCnty",
                                              headerText : '<spring:message code="sal.text.country" />',
                                              width : '15%'
                                          }, {
                                              dataField : "billAddr1",
                                              headerText : '<spring:message code="sal.text.billingAddress" /> 1',
                                              width : '25%'
                                          }, {
                                              dataField : "billAddr2",
                                              headerText : '<spring:message code="sal.text.billingAddress" /> 2',
                                              width : '25%'
                                          }, {
                                              dataField : "billPostcde",
                                              headerText : '<spring:message code="sys.title.post.code" />',
                                              width : '15%'
                                          }, {
                                              dataField : "billCity",
                                              headerText : '<spring:message code="sal.text.city" />',
                                              width : '15%'
                                          }, {
                                              dataField : "billState",
                                              headerText : '<spring:message code="sys.title.state" />',
                                              width : '15%'
                                          }, {
                                              dataField : "billCnty",
                                              headerText : '<spring:message code="sal.text.country" />',
                                              width : '15%'
                                          }
    ];

    var gridPros = { usePaging : true,
                            pageRowCount : 20,
                            editable : false,
                            fixedColumnCount : 2,
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

  function fn_getCustDelInfoListAjax(){
    Common.ajax("GET", "/supplement/getCustOrdDelInfo.do",null, function(result) {
      AUIGrid.setGridData(orderGridID, result);
    });
  }

  function fn_excelDown() {
    const today = new Date();
    const day = String(today.getDate()).padStart(2, '0');
    const month = String(today.getMonth() + 1).padStart(2, '0');
    const year = today.getFullYear();

    const date = year + month + day;
    GridCommon.exportTo("order_grid_wrap", "xlsx", "[Supplement] Customer Delivery Information-" + date);
  }

  /*$.fn.clearForm = function() {
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
});*/
</script>

<div id="popup_wrap" class="popup_wrap">
  <header class="pop_header">
    <h1><spring:message code="supplement.btn.custDelInfo" /></h1>
    <ul class="right_opt">
      <li><p class="btn_blue2"><a href="#none" id="_closeOrdPop"><spring:message code="sal.btn.close" /></a></p></li>
    </ul>
  </header>
  <section class="pop_body">
  <!--<ul class="right_btns mb10">
    <li><p class="btn_blue"><span class="search"></span><a href="#none" id="_orderSelectBtn"><spring:message code="sys.info.select" /></a></p></li>
    <li><p class="btn_blue"><span class="search"></span><a href="#none" id="_orderSearchBtn"><spring:message code="sal.btn.search" /></a></p></li>
    <li><p class="btn_blue"><span class="clear" ></span><a href="#none" onclick="javascript:$('#_searchOrdForm').clearForm();"><spring:message code="sal.btn.clear" /></a></p></li>
  </ul>
   <form id="_searchOrdForm" method="get">
    <table class="type1">
      <caption>table</caption>
      <colgroup>
        <col style="width:140px" />
        <col style="width:*" />
        <col style="width:100px" />
        <col style="width:*" />
      </colgroup>
      <tbody>
        <tr>
          <th scope="row"><spring:message code="supplement.text.supplementReferenceNo" /></th>
          <td><input type="text" title="" placeholder="Order No" class="w100p" name="searchOrdNo" /></td>
          <th scope="row"><spring:message code="sal.text.ordDate" /></th>
          <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_dateHc w100p"  name="searchOrdDate"/></td>
        </tr>
      </tbody>
    </table>
  </form> -->
  <section class="search_result">
    <ul class="right_btns">
      <li>
        <p class="btn_grid">
          <a href="#" onClick="fn_excelDown()"><spring:message code='service.btn.Generate'/></a>
        </p>
      </li>
    </ul>
    <article class="grid_wrap"><!-- grid_wrap start -->
      <div id="order_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
    </article>
  </section>
</div>
