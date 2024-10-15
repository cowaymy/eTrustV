<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript" language="javascript">
  var popOrderGridID;
  var cmbOrdDtlResultGridID;

  var cmbOrdDtlLstGridPros = {
          usePaging : true,
          pageRowCount : 20,
          editable : false,
          fixedColumnCount : 1,
          showStateColumn : false,
          displayTreeOpen : false,
          headerHeight : 30,
          useGroupingPanel : false,
          skipReadonlyColumns : true,
          wrapSelectionMove : true,
          showRowNumColumn : true,
          noDataMessage : "No order found.",
          groupingMessage : "Here groupping"
    };

  var colLayout = [
               {
                   dataField : "ordNo",
                   headerText : "<spring:message code='sales.OrderNo'/>",
                   width : 80,
                   editable : false,
                   style : 'left_style'
               }, {
                   dataField : "comboGrp",
                   headerText : "<spring:message code='sal.title.text.group'/>",
                   width : 80,
                   editable : false,
                   style : 'left_style'
               }, {
                 dataField : "ordDt",
                 headerText : "<spring:message code='sales.ordDt'/>",
                 width : 100,
                 editable : false,
                 style : 'left_style'
               }, {
                 dataField : "appType",
                 headerText : "<spring:message code='sales.AppType'/>",
                 width : 80,
                 editable : false,
                 style : 'left_style'
               }, {
                 dataField : "prod",
                 headerText : "<spring:message code='sales.prod'/>",
                 width : 200,
                 editable : false,
                 style : 'left_style'
               }, {
                 dataField : "promoCde",
                 headerText : "<spring:message code='sales.promoCd'/>",
                 width : 180,
                 editable : false
               }/*,{
                   dataField : "orderStatus",
                   headerText : "<spring:message code='sal.text.orderStatus'/>",
                   width : 160,
                   editable : false
               }*/];

  $(document).ready(
    function() {
      createAUIGrid();

      AUIGrid.bind(popOrderGridID, "cellDoubleClick",
        function(event) {
    	  ordNo = AUIGrid.getCellValue(popOrderGridID, event.rowIndex, "ordNo");
          ordId =  AUIGrid.getCellValue(popOrderGridID, event.rowIndex, "ordId");

          Common.ajax("POST", "/homecare/sales/order/chkIsMaxCmbOrd.do", {promoNo : $('#promoNo').val(), prod : $('#prod').val(),
                                     custId : $('#custId').val(), ordId : ordId}, function(result) {

               if(result.code == "0"){
            	   fn_setData(AUIGrid.getCellValue(popOrderGridID, event.rowIndex, "ordNo"), AUIGrid.getCellValue(popOrderGridID, event.rowIndex, "ordId"));
            	   $('#custPopCloseBtn').click();
               }else{
            	   Common.alert('<spring:message code="sal.alert.msg.maxOrdGrp" />');
            	   return false;
               }
          });
      });

      fn_selectListAjaxPop();

    });

  function fn_setData(ordNo, ordId) {
    fn_setBindComboOrd(ordNo, ordId);
  }

  function createAUIGrid() {
    //AUIGrid 칼럼 설정
    var columnLayout = [
           {
                  	dataField : "",
                      headerText : "Combo Order List",
                      width : 120,
                      renderer : {
                          type : "ButtonRenderer",
                          labelText : "View",
                          onclick : function(rowIndex, columnIndex, value, item) {
                        	var ordNo = AUIGrid.getCellValue(popOrderGridID, rowIndex, "ordNo");
                            var ordId =  AUIGrid.getCellValue(popOrderGridID, rowIndex, "ordId");

                              Common.ajax("GET","/homecare/sales/order/selectHcAcCmbOrderDtlList",
                                                  { promoNo : $('#promoNo').val(), prod : $('#prod').val(), custId : $('#custId').val(), ordId : ordId },
                                                  function(result){
                                                      AUIGrid.clearGridData(cmbOrdDtlResultGridID);
                                                      AUIGrid.destroy(cmbOrdDtlResultGridID);
                                                      cmbOrdDtlResultGridID = GridCommon.createAUIGrid("cmbOrdDtlResult_grid_wrap", colLayout, "ordId", cmbOrdDtlLstGridPros);
                                                      AUIGrid.setGridData(cmbOrdDtlResultGridID, result);
                                                  },
                                                  function(jqXHR, textStatus, errorThrown) {
                                                      try {
                                                          console.log("status : " + jqXHR.status);
                                                          console.log("code : " + jqXHR.responseJSON.code);
                                                          console.log("message : " + jqXHR.responseJSON.message);
                                                          console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);

                                                          Common.alert("Fail : " + jqXHR.responseJSON.message);
                                                        } catch (e) {
                                                             console.log(e);
                                                        }
                                                    });
                          }
                      }
                    , editable : false

                }, {
                    dataField : "ordNo",
                    headerText : "<spring:message code='sales.OrderNo'/>",
                    width : 80,
                    editable : false,
                    style : 'left_style'
                }, {
                    dataField : "refNo",
                    headerText : "<spring:message code='sales.refNo2'/>",
                    width : 100,
                    editable : false,
                    style : 'left_style'
                }, {
                    dataField : "ordDt",
                    headerText : "<spring:message code='sales.ordDt'/>",
                    width : 100,
                    editable : false,
                    style : 'left_style'
                }, {
                    dataField : "appType",
                    headerText : "<spring:message code='sales.AppType'/>",
                    width : 80,
                    editable : false,
                    style : 'left_style'
                }, {
                  dataField : "prod",
                  headerText : "<spring:message code='sales.prod'/>",
                  width : 200,
                  editable : false,
                  style : 'left_style'
                }, {
                  dataField : "promoCde",
                  headerText : "<spring:message code='sales.promoCd'/>",
                  width : 200,
                  editable : false
                }, {
                  dataField : "custId",
                  headerText : "<spring:message code='sales.cusName'/>",
                  editable : false,
                  style : 'left_style'
                }, {
                  dataField : "ordId",
                  visible : false
                } ];

    var gridPros = {
      usePaging : true,
      pageRowCount : 20,
      editable : false,
      fixedColumnCount : 1,
      showStateColumn : false,
      displayTreeOpen : false,
      headerHeight : 30,
      useGroupingPanel : false,
      skipReadonlyColumns : true,
      wrapSelectionMove : true,
      showRowNumColumn : true,
      noDataMessage : "No order found.",
      groupingMessage : "Here groupping"
    };

    popOrderGridID = GridCommon.createAUIGrid("pop_ord_grid_wrap", columnLayout, "", gridPros);
  }

  function fn_selectListAjaxPop() {
    if ($('#ordIdPop_1').val() != null && $('#ordIdPop_1').val() != "") {
        Common.ajax("GET", "/homecare/sales/order/selectHcAcComboOrderJsonList_2", $("#popSearchComboForm").serialize(), function(result) {
        AUIGrid.setGridData(popOrderGridID, result);
      });
    } else {
        Common.ajax("GET", "/homecare/sales/order/selectHcAcComboOrderJsonList", $("#popSearchComboForm").serialize(), function(result) {
        AUIGrid.setGridData(popOrderGridID, result);
      });
    }
  }
</script>
<div id="popup_wrap" class="popup_wrap">
 <!-- popup_wrap start -->
 <header class="pop_header">
  <!-- pop_header start -->
  <h1>
   <spring:message code='sales.title.searchOrder' />
  </h1>
  <ul class="right_opt">
   <li><p class="btn_blue2">
     <a id="custPopCloseBtn" href="#"><spring:message code='sys.btn.close' /></a>
    </p></li>
  </ul>
 </header>
 <!-- pop_header end -->
 <section class="pop_body">
  <!-- pop_body start -->
  <form id="popSearchComboForm" name="popSearchComboForm" action="#" method="post">
     <input id="promoNo" name="promoNo" value="${promoNo}" type="hidden" />
     <input id="prod" name="prod" value="${prod}" type="hidden" />
     <input id="custId" name="custId" value="${custId}" type="hidden" />
     <input id="ordIdPop_1" name="ordIdPop_1" value="${ordId}" type="hidden" />
  </form>

  <article class="grid_wrap">
      <div id="pop_ord_grid_wrap" style="width: 100%; height: 300px; margin: 0 auto;"></div>
  </article>

   <article class="grid_wrap" >
       <div id="cmbOrdDtlResult_grid_wrap" style="width: 100%; height: 200px; margin: 0 auto;"></div>
   </article>

 </section>
 <!-- pop_body end -->
</div>
<!-- popup_wrap end -->
