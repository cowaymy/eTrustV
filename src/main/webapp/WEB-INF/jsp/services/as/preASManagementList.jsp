<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javaScript">
  var option = {
    width : "1200px",
    height : "500px"
  };

  var myGridID;
  var gridPros = {
    usePaging : true,
    pageRowCount : 20,
    editable : true,
    fixedColumnCount : 1,
    showStateColumn : true,
    displayTreeOpen : true,
    selectionMode : "singleRow",
    headerHeight : 30,
    useGroupingPanel : true,
    skipReadonlyColumns : true,
    wrapSelectionMove : true,
    showRowNumColumn : false,
  };

  $(document).ready(
      function() {
        asManagementGrid();
        doGetCombo('/services/holiday/selectBranchWithNM', 43, '', 'cmbbranchId', 'M', 'f_multiCombo'); // DSC BRANCH

        AUIGrid.bind(myGridID, "cellDoubleClick", function(event) { // AS ENTRY VIEW DOUBLE CLICK

        	var index = AUIGrid.getSelectedIndex(myGridID)[0];
            var param;

            if(index > -1) {

                var stus = AUIGrid.getCellValue(myGridID, index, "stus");

                if( stus != "Approved"){
                    Common.alert("Only Approved Order Is Allowed to view.");
                }
                else{
                    var asid = AUIGrid.getCellValue(myGridID, event.rowIndex, "asId");
                    var asNo = AUIGrid.getCellValue(myGridID, event.rowIndex, "asNo");
                    var salesOrdNo = AUIGrid.getCellValue(myGridID, event.rowIndex, "salesOrdNo");
                    var salesOrdId = AUIGrid.getCellValue(myGridID, event.rowIndex, "salesOrdId");

                    var param =  "?salesOrderId=" + salesOrdId
                              + "&ord_Id=" + salesOrdId
                              + "&ord_No=" + salesOrdNo
                              + "&as_No=" + asNo
                              + "&as_Id=" + asid
                              + "&IND= 1";;

                    Common.popupDiv("/services/as/asResultViewPop.do" + param, null, null, true, '_newASResultDiv1');
                }
            }
            else{
                Common.alert('Pre Register AS Missing' + DEFAULT_DELIMITER + 'No Order Selected');
            }
        });
      });
  /* By KV - AS Mobile Failure Listing*/
  function fn_ASMobileFailureListing(){
      var date = new Date();
      var month = date.getMonth() + 1;
      var day = date.getDate();

      if (date.getDate() < 10) {
        day = "0" + date.getDate();
      }

      $("#reportFormASLst #reportFileName").val('/services/AS_Mobile_Fail_excel.rpt');
      $("#reportFormASLst #viewType").val("EXCEL");
      $("#reportFormASLst #V_TEMP").val("");
      $("#reportFormASLst #reportDownFileName").val(
          "ASMobileFailureListing_" + day + month + date.getFullYear());

      var option = {
                isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
              };

    Common.report("reportFormASLst", option);
  }

  function asManagementGrid() {
    var columnLayout = [
        {
          dataField : "salesOrderNo",
          headerText : "Order No",
          editable : false,
          width : 100
        },
        {
          dataField : "asNo",
          headerText : "AS No",
          editable : false,
          width : 150
          },
        {
          dataField : "brnchCode",
          headerText : "AS Branch",
          width : 80
        },
        {
          dataField : "product",
          headerText : "Product",
          width : 200
        },
        {
          dataField : "custName",
          headerText : "Customer Name",
          editable : false,
          width : 250
        },
        {
           dataField : "contactNo",
           headerText : "Conatct No",
           editable : false,
           width : 100
        },
        {
       	  dataField : "regDt",
          headerText : "Register Date",
          editable : false,
          width : 150,
          dataType : "date",
          formatString : "dd/mm/yyyy"
        },
        {
          dataField : "defectDesc",
          headerText : "AS Error Code",
          editable : false,
          width : 150
        },
        {
           dataField : "stus",
           headerText : "Status",
           editable : false,
           width : 150
        },
        {
            dataField : "appvRemark",
            headerText : "Remark",
            editable : false,
            width : 150
        },
        {
          dataField : "updDt",
          headerText : "Last Update Date",
          editable : false,
          width : 150,
          dataType : "date",
          formatString : "dd/mm/yyyy"
        },
        {
            dataField : "defectCode",
            headerText : "Defect Code",
            editable : false,
            width : 150,
            visible:false
         },
         {
              dataField : "asId",
              headerText : "AS Id",
              editable : false,
              width : 150,
              visible:false
          },
          {
                  dataField : "salesOrdId",
                  headerText : "Sales Order Id",
                  editable : false,
                  width : 150,
                  visible:false
          }

    ];

    var gridPros = {
      //showRowCheckColumn : true,
      usePaging : true,
      pageRowCount : 20,
      //showRowAllCheckBox : true,
      editable : false,
      selectionMode : "multipleCells"
    };

    myGridID = AUIGrid.create("#grid_wrap_asList", columnLayout, gridPros);
  }

  function fn_searchPreASManagement() { // SEARCH Pre-Register AS
	    console.log($("#ASForm").serialize());
        Common.ajax("GET", "/services/as/searchPreASManagementList.do", $("#ASForm").serialize(), function(result) {
        console.log(result);
          AUIGrid.setGridData(myGridID, result);
        });
  }


  function fn_excelDown() {
    // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
    GridCommon.exportTo("grid_wrap_asList", "xlsx", "Pre-AS Management");
  }


  /*KV*/
  function fn_aoAsDataListing() {
      Common.popupDiv("/services/as/report/aoAsDataListingPop.do", null, null, true, '');
      }

  function f_multiCombo() {
    $(function() {
        $('#cmbbranchId').change(function() {

        }).multipleSelect({
            selectAll : true, // 전체선택
            width : '80%'
        });
    });
}

  $.fn.clearForm = function() {
      return this.each(function() {
          var type = this.type, tag = this.tagName.toLowerCase();
          if (tag === 'form'){
              return $(':input',this).clearForm();
          }
          if (type === 'text' || type === 'password'  || tag === 'textarea'){
              if($("#"+this.id).hasClass("readonly")){

              }else{
                  this.value = '';
              }
          }else if (type === 'checkbox' || type === 'radio'){
              this.checked = false;

          }else if (tag === 'select'){
              if($("#memType").val() != "7"){ //check not HT level
                   this.selectedIndex = 0;
              }
          }

          $("#asStatus").multipleSelect("uncheckAll");
          $("#cmbbranchId").multipleSelect("uncheckAll");
          $("#asProduct").multipleSelect("uncheckAll");
      });
  };

  function fn_newASPop() { // CREATE AS

	  var selIdx = AUIGrid.getSelectedIndex(myGridID)[0];
	  var param;

	   if(selIdx > -1) {
		   param = {
		    preAsSalesOrderNo : AUIGrid.getCellValue(myGridID, selIdx, "salesOrderNo"),
		    preAsDefectCode : AUIGrid.getCellValue(myGridID, selIdx, "defectCode"),
		    preAsType : "PREAS",
		    in_ordNo : ""
		   }

		   Common.popupDiv("/services/as/ASReceiveEntryPop.do", param, null, true, '_NewEntryPopDiv1');

	   }else{
		   Common.alert('Pre Register AS Missing' + DEFAULT_DELIMITER + 'No Order Selected');
	   }
  }

  function fn_resultASPop(ordId, ordNo) {

	  var selIdx = AUIGrid.getSelectedIndex(myGridID)[0];
      var mafuncId = AUIGrid.getCellValue(myGridID, selIdx, "defectCode");
      var preAsType = "PREAS";

      var pram = "?salesOrderId=" + ordId + "&ordNo=" + ordNo + "&mafuncId=" + mafuncId + "&preAsType=" + preAsType +"&IND= 1";

      Common.popupDiv("/services/as/resultASReceiveEntryPop.do" + pram, null, null, true, '_resultNewEntryPopDiv1');
    }

   function fn_rejectPreASPop(){
		  var selIdx = AUIGrid.getSelectedIndex(myGridID)[0];
		  var param;

	      if(selIdx > -1) {

	          var stus = AUIGrid.getCellValue(myGridID, selIdx, "stus");

	          if( stus != "Active"){
	        	  Common.alert("Reject Approval only allow in Active Status");
	          }
	          else{
	        	  param = {
	                      preAsSalesOrderNo : AUIGrid.getCellValue(myGridID, selIdx, "salesOrderNo"),
	                      preAsBranch : AUIGrid.getCellValue(myGridID, selIdx, "brnchCode")
	               }

	        	  Common.popupDiv("/services/as/rejectPreASOrder.do", param, null  , true, 'rejectPreASOrderPop');
	          }
	      }
	      else{
	          Common.alert('Pre Register AS Missing' + DEFAULT_DELIMITER + 'No Order Selected');
	      }
    }

   function fn_asRawData(ind) {
	    Common.popupDiv("/services/as/preAsRawDataPop.do", {ind: ind}, null, true, '');
	  }





</script>
<section id="content">
 <!-- content start -->
 <ul class="path">
  <!-- <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
  <li>Sales</li>
  <li>Order list</li> -->
 </ul>
 <aside class="title_line">
  <!-- title_line start -->
  <p class="fav">
   <a href="#" class="click_add_on">My menu</a>
  </p>
  <h2>Pre-Register</h2>
  <form action="#" id="inHOForm">
   <div style="display: none">
    <input type="text" id="in_asId" name="in_asId" />
    <input type="text" id="in_asNo" name="in_asNo" />
    <input type="text" id="in_ordId" name="in_ordId" />
    <input type="text" id="in_asResultId" name="in_asResultId" />
    <input type="text" id="in_asResultNo" name="in_asResultNo" />
    <input type="text" id="dt_range" name="dt_range" value="${DT_RANGE}" />
   </div>
  </form>
  <ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
     <li><p class="btn_blue">
      <a href="#" onclick="fn_rejectPreASPop()">Reject</a>
     </p></li>
    <li><p class="btn_blue">
      <a href="#" onclick="fn_newASPop()">Approve</a>
     </p></li>
   </c:if>
   <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue">
      <a href="#" onClick="fn_searchPreASManagement()"><span class="search"></span><spring:message code='sys.btn.search'/></a>
     </p></li>
   </c:if>
   <li><p class="btn_blue">
     <a href="#" onclick="javascript:$('#ASForm').clearForm();"><span class="clear"></span><spring:message code='service.btn.Clear'/></a>
    </p></li>
  </ul>
 </aside>
 <!-- title_line end -->
 <section class="search_table">
  <!-- search_table start -->
  <form action="#" method="post" id="ASForm">
   <table class="type1">
    <!-- table start -->
    <caption>table</caption>
    <colgroup>
     <col style="width: 150px" />
     <col style="width: *" />
     <col style="width: 140px" />
     <col style="width: *" />
     <col style="width: 170px" />
     <col style="width: *" />
    </colgroup>
    <tbody>
     <tr>
     <th scope="row"><spring:message code='service.title.OrderNumber'/></th>
      <td><input type="text" title="" placeholder="<spring:message code='service.title.OrderNumber'/>"
       class="w100p" id="orderNum" name="orderNum" /></td>

      <th scope="row"><spring:message code='service.title.Status'/></th>
      <td><select class="multy_select w100p" multiple="multiple" id="asStatus" name="asStatus">
        <c:forEach var="list" items="${asStat}" varStatus="status">
         <c:choose>
           <c:when test="${list.codeId=='1'}">
             <option value="${list.codeId}" selected>${list.codeName}</option>
           </c:when>
           <c:otherwise>
             <option value="${list.codeId}" selected>${list.codeName}</option>
           </c:otherwise>
         </c:choose>
        </c:forEach>
      </select></td>
           <th scope="row"><spring:message code='service.title.ASBrch'/></th>
      <td><select class="multy_select w100p" multiple="multiple" id="cmbbranchId" name="cmbbranchId"></select></td>

     </tr>
     <tr>
         <th scope="row"><spring:message code='service.grid.CustomerName'/></th>
      <td><input type="text" title="" placeholder="<spring:message code='service.grid.CustomerName'/>" class="w100p" id="custName" name="custName" /></td>
     <th scope="row"><spring:message code='service.grid.registerDt'/></th>
      <td>
       <div class="date_set w100p">
        <p>
         <input type="text" title="Create start Date"
          placeholder="DD/MM/YYYY" class="j_date" id="registerDtFrm"
          name="registerDtFrm" />
        </p>
        <span><spring:message code='pay.text.to'/></span>
        <p>
         <input type="text" title="Create end Date"
          placeholder="DD/MM/YYYY" class="j_date" id="registerDtTo"
          name="registerDtTo" />
        </p>
       </div>
      </td>
            <th scope="row"><spring:message code='service.grid.Product'/></th>
      <td><select class="multy_select w100p" multiple="multiple" id="asProduct" name="asProduct">
        <c:forEach var="list" items="${asProduct}" varStatus="status">
          <option value="${list.stkId}">${list.stkDesc}</option>
        </c:forEach>
      </select></td>
     </tr>


    </tbody>
   </table>
   <!-- table end -->
   <aside class="link_btns_wrap">
    <!-- link_btns_wrap start -->
    <p class="show_btn">
     <a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a>
    </p>
    <dl class="link_list">
     <dt><spring:message code='sales.Link'/></dt>
     <dd>
      <ul class="btns">
      </ul>
      <ul class="btns">
        <c:if test="${PAGE_AUTH.funcUserDefine11 == 'Y'}">
         <li>
          <p class="link_btn type2">
           <a href="#" onclick="fn_asRawData(1)">Pre-AS Register Raw</a>
          </p>
         </li>
        </c:if>
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
   <ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcUserDefine10 == 'Y'}">
     <li><p class="btn_grid">
       <a href="#" onClick="fn_excelDown()"><spring:message code='service.btn.Generate'/></a>
      </p></li>
    </c:if>
   </ul>
   <article class="grid_wrap">
    <!-- grid_wrap start -->
    <div id="grid_wrap_asList"
     style="width: 100%; height: 500px; margin: 0 auto;"></div>
   </article>
   <!-- grid_wrap end -->
  </form>
  <form action="#" id="reportForm" method="post">
   <!--  <input type="hidden" id="V_RESULTID" name="V_RESULTID" /> -->
   <input type="hidden" id="v_serviceNo" name="v_serviceNo" />
   <input type="hidden" id="v_invoiceType" name="v_invoiceType" />
   <input type="hidden" id="reportFileName" name="reportFileName" />
   <input type="hidden" id="viewType" name="viewType" />
   <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="DOWN_FILE_NAME" />
  </form>
  <form id='reportFormASLst' method="post" name='reportFormASLst' action="#">
    <input type='hidden' id='reportFileName' name='reportFileName'/>
    <input type='hidden' id='viewType' name='viewType'/>
    <input type='hidden' id='reportDownFileName' name='reportDownFileName'/>
    <input type='hidden' id='V_TEMP' name='V_TEMP'/>
  </form>
 </section>
 <!-- search_table end -->
</section>
<!-- content end -->
