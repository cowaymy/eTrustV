<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
  //AUIGrid
  var myGridID, viewGridId, priceHistoryGrid;

  //Grid에서 선택된 RowID
  var selectedGridValue;

  // Empty Set
  var emptyData = [];

  var pricehiscolumn2=[
                       {dataField:    "rowNo"   ,headerText:    "SeqNo"     ,width:    "10%"    , visible : true},
                       {dataField:    "amt"   ,headerText:    "Price (RM)"        ,width:    "10%"    , visible : true},
                       {dataField:    "pricerpf"  ,headerText:    "<spring:message code='log.head.rentaldeposit'/>"        ,width:    "15%"    , visible : true},
                       {dataField:    "penalty"   ,headerText:    "<spring:message code='log.head.penaltycharges'/>"       ,width:    "15%"    , visible : true},
                       {dataField:    "tradeinpv" ,headerText:"<spring:message code='log.head.tradein(pv)value'/>"         ,width:    "18%"    , visible : true},
                       {dataField:    "pricecost",headerText :"<spring:message code='log.head.cost'/>"                   ,width:  "10%"    , visible : true},
                       {dataField:    "pricepv"   ,headerText:    "<spring:message code='log.head.pointofvalue(pv)'/>"     ,width:    "18%"    , visible : true},
                       {dataField:    "crtDt"   ,headerText:    "Create Date"     ,width:    "10%"    , visible : true},
                       {dataField:    "crtUserId"   ,headerText:    "Create User"     ,width:    "10%"    , visible : true}
                   ];

  var subgridpros2 = {
          // 페이지 설정
          usePaging : true,
          pageRowCount : 10,
          editable : false,
          noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
          enableSorting : true,
          softRemoveRowMode:false,
          reverseRowNum : true
          };

  $(document)
      .ready(
          function() {

        	  $("#appvRemark").keyup(function(){
                  $("#characterCount").text($(this).val().length + " of 100 max characters");
            });

            //Grid Properties
            var gridPros = {

                    usePaging : true,
                    pageRowCount : 20,
                    editable : true,
                    fixedColumnCount : 1,
                    showStateColumn : false,
                    displayTreeOpen : true,
                    selectionMode : "multipleCells",
                    headerHeight : 30,
                    useGroupingPanel : false,
                    skipReadonlyColumns : true,
                    wrapSelectionMove : true,
                    showRowNumColumn : false,
                    groupingMessage : "Here groupping"
            };

            myGridID = GridCommon.createAUIGrid("grid_wrap",
                columnLayout, null, gridPros);

            // Master Grid
            AUIGrid.bind(myGridID, "cellClick", function(event) {
              selectedGridValue = event.rowIndex;
            });

          });

  var columnLayout = [ {
      dataField : "stkCode",
      headerText : "Material Code",
      width : 110,
      editable : false,
      style: 'left_style'
  }, {
      dataField : "stkDesc",
      headerText : "Material Name",
      width : 110,
      editable : false,
      style: 'left_style'
  }, {
      dataField : "ctgry",
      headerText : "Category",
      width : 110,
      editable : false,
      style: 'left_style'
  },{
      dataField : "type",
      headerText : "Type",
      width : 110,
      editable : false,
      style: 'left_style'
  }, {
      dataField : "codeName",
      headerText : "Package",
      width : 110,
      editable : false,
      style: 'left_style'
  },{
      dataField : "appvStus",
      headerText : "Approval Status",
      width : 110,
      editable : false,
      style: 'left_style'
  }, {
      dataField : "approver",
      headerText : "Approver",
      width : 110,
      editable : false,
      style: 'left_style'
  }, {
      dataField : "remark",
      headerText : "Remark",
      width : 110,
      editable : false,
      style: 'left_style'
  },{
      dataField : "appvDt",
      headerText : "Approval Date",
      width : 110,
      dataType : "date",
      formatString : "dd/mm/yyyy" ,
      editable : false,
      style: 'left_style'
  }, {
      dataField : "creator",
      headerText : "Creator",
      width : 140,
      editable : false,
      style: 'left_style'
  },{
      dataField : "crtDt",
      headerText : "<spring:message code='sal.text.createDate' />",
      width : 110,
      dataType : "date",
      formatString : "dd/mm/yyyy" ,
      editable : false,
      style: 'left_style'
  }, {
      dataField : "prcReqstId",
      visible : false
  }, {
      dataField : "stkId",
      visible : false
  }, {
      dataField : "memPacId",
      visible : false
  },{
      dataField : "stkTypeId",
      visible : false
  }, {
      dataField : "appTypeId",
      visible : false
  }];


  function fn_getSearchList() {
    Common.ajax("GET", "/sales/productMgmt/selectPriceReqstList.do", $("#searchForm").serialize(), function(result) {
      AUIGrid.setGridData(myGridID, result);
    });
  }

  doGetCombo('/common/selectCodeList.do', '11', '', 'cmbCategory', 'M', 'f_multiCombo');
  doGetCombo('/common/selectCodeList.do', '15', '', 'cmbType', 'M','f_multiCombo');

  function f_multiCombo() {
      $(function() {
          $('#cmbCategory').change(function() {

          }).multipleSelect({
              selectAll : true, // 전체선택
              width : '80%'
          });
          $('#cmbType').change(function() {

          }).multipleSelect({
              selectAll : true,
              width : '80%'
          });
      });
  }

  function fn_close(){
      $("#editForm")[0].reset();
      $("#editPrice_popup").hide();
      AUIGrid.destroy(priceHistoryGrid);
  }

  function fn_clear() {
    $("#searchForm")[0].reset();
  }

  //View Claim Pop-UP
  function fn_openDivPop(val) {

   selectedItem = null;

          var selectedItem = AUIGrid.getSelectedIndex(myGridID);

          if (selectedItem[0] > -1) {

        	  if(AUIGrid.getCellValue(myGridID, selectedGridValue,
              "appvStus") != "In Progress"){
                  Common.alert("Only In Progress request are allowed to do approval");
        	  }

        	  else{

              AUIGrid.destroy(priceHistoryGrid);
              priceHistoryGrid = AUIGrid.create("#priceInfo_grid_wrap", pricehiscolumn2, subgridpros2);

              var priceReqstId = AUIGrid.getCellValue(myGridID, selectedGridValue,
                "prcReqstId");

              var typeId = AUIGrid.getCellValue(myGridID, selectedGridValue,
              "stkTypeId");

              var appTypeId = AUIGrid.getCellValue(myGridID, selectedGridValue,
              "appTypeId");

              var srvPacName = AUIGrid.getCellValue(myGridID, selectedGridValue,
              "codeName");

              var stkId = AUIGrid.getCellValue(myGridID, selectedGridValue,
              "stkId");

              var memPacId = AUIGrid.getCellValue(myGridID, selectedGridValue,
              "memPacId");

              Common.ajax("GET", "/sales/productMgmt/selectPriceReqstInfo.do", {
                  "reqstId" : priceReqstId,
                  "typeId" : typeId,
                  "appTypeId" : appTypeId,
                  "memPacId" : memPacId,
                  "stkId" : stkId
                }, function(result) {
                    console.log(result);
                  $("#editPrice_popup").show();
                  $("#srvPackage").val(srvPacName);
                  $("#exPrice").val(result.data.mrental);
                  $("#exPV").val(result.data.pricepv);
                  $("#exRentalDeposit").val(result.data.pricerpf);
                  $("#exPenalty").val(result.data.penalty);
                  $("#exCost").val(result.data.pricecost);
                  $("#exTradePv").val(result.data.tradeinpv);
                  $("#exNormalPrice").val(result.data.amt);

                  AUIGrid.setGridData(priceHistoryGrid, result.data2);
                  AUIGrid.resize(priceHistoryGrid,950, 280);
                });
        	  }

            } else {
              Common.alert("Please select a request");
            }

  }

  hideNewPopup = function(val) {

        $(val).hide();
   }

  function fn_save() {
        Common
            .confirm(
                "Do you want to proceed to save this request approval?",
                function() {
                var reqstId = AUIGrid.getCellValue(myGridID,
                      selectedGridValue, "prcReqstId");

                var typeId = AUIGrid.getCellValue(myGridID, selectedGridValue,
                "stkTypeId");

                var appTypeId = AUIGrid.getCellValue(myGridID, selectedGridValue,
                "appTypeId");

                var srvPacName = AUIGrid.getCellValue(myGridID, selectedGridValue,
                "codeName");

                var stkId = AUIGrid.getCellValue(myGridID, selectedGridValue,
                "stkId");

                var srvPacId = AUIGrid.getCellValue(myGridID, selectedGridValue,
                "memPacId");

                 var param = {
                		  reqstId : reqstId,
                		  appvStatus : $("#appvStatus").val(),
                		  appvRemark : $("#appvRemark").val(),
                          stockId : stkId,
                          srvPackageId: srvPacId,
                          appTypeId : appTypeId,
                          priceTypeid : typeId,
                          typeId : typeId,
                          dCost : $("#exCost").val(),
                          dPV : $("#exPV").val(),
                          dRentalDeposit : $("#exRentalDeposit").val(),
                          dTradeInPV : $("#exTradePv").val(),
                          dMonthlyRental : $("#exPrice").val(),
                          dNormalPrice : $("#exNormalPrice").val(),
                          dPenaltyCharge  : $("#exPenalty").val()
                  };

                 console.log("priceTypeId: " + typeId);
                 console.log(param);
                 Common.ajaxSync("POST", "/stock/confirmPriceInfo.do", param,
                    function(result) {
                   console.log(result);
                   Common.alert(result.msg)
                        $("#editForm")[0].reset();
                        hideNewPopup('#editPrice_popup');
                        fn_getSearchList();
                    });


                });
      }

</script>
<!-- content start -->
<section id="content">
 <ul class="path">
  <li><img
   src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
   alt="Home" /></li>
 </ul>
 <!-- title_line start -->
 <aside class="title_line">
  <p class="fav">
   <a href="#" class="click_add_on"><spring:message
     code='pay.text.myMenu' /></a>
  </p>
  <h2>Price & Value Approval</h2>
  <ul class="right_btns">
<%--   <li><p class="btn_blue"><a href="#" onClick="javascript:fn_openDivPop('NEW');"><spring:message code="sal.btn.new" /></a></p></li>
 --%>  <li><p class="btn_blue"><a href="javascript:fn_getSearchList();"><span class="search"></span> <spring:message code='sys.btn.search' /></a></p></li>
  <li><p class="btn_blue"><a href="javascript:fn_clear();"><span class="clear"></span> <spring:message code='sys.btn.clear' /></a></p></li>
  </ul>
 </aside>
 <!-- title_line end -->
 <!-- search_table start -->
 <section class="search_table">
  <form name="searchForm" id="searchForm" method="post">
   <table class="type1">
    <!-- table start -->
    <caption>table</caption>
    <colgroup>
     <col style="width: 240px" />
     <col style="width: *" />
     <col style="width: 120px" />
     <col style="width: *" />
    </colgroup>
    <tbody>
                     <tr>
                    <th scope="row">Category</th>
                    <td>
                        <select class="w100p" id="cmbCategory" name="cmbCategory"></select>
                    </td>
                    <th scope="row">Type</th>
                    <td>
                        <select class="w100p" id="cmbType" name="cmbType"></select>
                    </td>
                    <th scope="row">Approval Status</th>
                    <td>
                    <select class="w100p" id="status" name="status">
                    <option value="" selected>Choose One</option>
                    <option value="5">Approve</option>
                    <option value="60">In Progress</option>
                    <option value="6">Reject</option>
                    </select>

                    </td>
                </tr>
                <tr>
                    <th scope="row">Material Code</th>
                    <td>
                        <input type=text name="stkCd" id="stkCd" class="w100p" value=""/>
                    </td>
                    <th scope="row">Material Name</th>
                    <td>
                        <input type=text name="stkNm" id="stkNm" class="w100p" value=""/>
                    </td>
                    <th scope="row"><spring:message code='pay.text.crtDt' /></th>
                    <td>
                     <!-- date_set start -->
                     <div class="date_set w100p">
                     <p><input id="createDt1" name="createDt1" type="text" title="Create Date From" placeholder="DD/MM/YYYY" class="j_date" readonly /></p>
                     <span>To</span>
                     <p><input id="createDt2" name="createDt2" type="text" title="Create Date To" placeholder="DD/MM/YYYY" class="j_date" readonly /></p>
                     </div> <!-- date_set end -->
                     </td>
                </tr>
    </tbody>
   </table>
      <!-- link_btns_wrap start -->
   <aside class="link_btns_wrap">
     <p class="show_btn">
      <a href="#"><img
       src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif"
       alt="link show" /></a>
     </p>
     <dl class="link_list">
      <dt>Link</dt>
      <dd>
       <ul class="btns">
        <li><p class="link_btn">
          <a href="javascript:fn_openDivPop('APPV');">Approval</a>
         </p></li>
       </ul>
       <p class="hide_btn">
        <a href="#"><img
         src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif"
         alt="hide" /></a>
       </p>
      </dd>
     </dl>
   </aside>
   <!-- link_btns_wrap end -->
  </form>
 </section>
 <!-- search_table end -->
 <!-- search_result start -->
 <section class="search_result">
  <!-- grid_wrap start -->
  <article class="grid_wrap" id="grid_wrap_id">
  <div id="grid_wrap" style="width: 100%; height: 500px; margin: 0 auto;">
</article>
  <!-- grid_wrap end -->
 </section>
 <!-- search_result end -->
</section>
<!-- content end -->

<!-------------------------------------------------------------------------------------
    POP-UP (APPROVAL )
-------------------------------------------------------------------------------------->
<!-- popup_wrap start -->
<div id="editPrice_popup" class="popup_wrap" style="display:none"><!-- popup_wrap start -->
    <header class="pop_header"><!-- pop_header start -->
        <h1>Price & Value Information</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a id = "fclose" onclick="javascript:fn_close();"><spring:message code="expense.CLOSE" /></a></p></li>
        </ul>
    </header><!-- pop_header end -->

    <section class="pop_body" style="min-height: auto"><!-- pop_body start -->
    <aside class="title_line"><!-- title_line start -->
        <h4>Price & Value Configuration</h3>
        </aside><!-- title_line end -->
        <section class="search_table"><!-- search_table start -->
            <form action="#" method="post" id="editForm" name="editForm">
                <input type="hidden" name="srvPackageId" id="srvPackageId" value=""/>
                <input type="hidden" name="appTypeId" id="appTypeId"/>
                <table class="type1"><!-- table start -->
                    <caption>table</caption>
                    <colgroup>
                        <col style="width:180px" />
                        <col style="width:*" />
                        <col style="width:180px" />
                        <col style="width:*" />
                    </colgroup>

                    <tbody>
                        <tr>
                            <th scope="row">Package</th>
                            <td>
                               <input type="text" id = "srvPackage" name="srvPackage" disabled = "disabled"/>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Monthly Rental</th>
                            <td>
                               <input type="text" id = "exPrice" name="exPrice" disabled = "disabled"/>
                            </td>
                             <th scope="row">Cost (RM)</th>
                            <td>
                                <input type="text" id = "exCost" name="exCost" disabled = "disabled"/>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Point of Value (PV)</th>
                            <td>
                                <input type="text" id = "exPV" name="exPV" disabled = "disabled"/>
                            </td>
                              <th scope="row">Trade In PV</th>
                            <td>
                                <input type="text" id = "exTradePv" name="exTradePv" disabled = "disabled"/>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Rental Deposit (RM)</th>
                            <td>
                                <input type="text" id = "exRentalDeposit" name="exRentalDeposit" disabled = "disabled"/>
                            </td>
                            <th scope="row">Penalty Charges (RM)</th>
                            <td>
                                <input type="text" id = "exPenalty" name="exPenalty" disabled = "disabled"/>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Normal Price (RM)</th>
                            <td>
                                <input type="text" id = "exNormalPrice" name="exNormalPrice" disabled = "disabled"/>
                            </td>
                            <th scope="row">Approval Status<span style="color:red">*</span></th>
                                <td ><select id="appvStatus" name="appvStatus" class="w100p">
                                <option value="" selected>Choose One</option>
                                <option value=5>Approve</option>
                                <option value=6>Reject</option>
                                </select></td>
                        </tr>
                       <tr>
    <th scope="row"><spring:message code="newWebInvoice.remark" /><span style="color:red">*</span></th>
    <td colspan="3">
        <textarea type="text" title="" placeholder="" class="w100p" id="appvRemark" name="appvRemark" maxlength="100"></textarea>
        <span id="characterCount">0 of 100 max characters</span>
    </td>
</tr>
                    </tbody>
                </table><!-- table end -->
            </form>
        </section><!-- search_table end -->
        <section class="search_result"><!-- search_result start -->
    <aside class="title_line"><!-- title_line start -->
            <h4>Price & Value History</h3>
        </aside><!-- title_line end -->
        <article class="grid_wrap" id="priceInfo_grid_wrap"><!-- grid_wrap start -->
        </article><!-- grid_wrap end -->

        </section><!-- search_result end -->
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
      <ul class="center_btns">
        <li><p class="btn_blue2 big">
            <a href="#" onclick="javascript:fn_save();"><spring:message code="expense.SAVE" /></a>
          </p></li>
        <li><p class="btn_blue2 big">
            <a href="#" onclick="javascript:fn_cancel();">CANCEL</a>
          </p></li>
      </ul>
    </c:if>
  </section><!-- pop_body end -->

</div>