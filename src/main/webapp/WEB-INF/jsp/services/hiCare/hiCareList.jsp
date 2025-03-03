<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
  var gridID;
  var gridIDExcel;
  var counselingId;

  var MEM_TYPE = '${SESSION_INFO.userTypeId}';

  function hiCareGrid() {

    var columnLayout = [ {
      dataField : "serialNo",
      headerText : "<spring:message code='service.title.SerialNo'/>",
      width : "13%"
    }, {
      dataField : "model",
      headerText : "<spring:message code='service.grid.model'/>",
      width : "8%"
    }, {
      dataField : "status",
      headerText : "<spring:message code='service.grid.Status'/>",
      width : "8%"
    }, {
      dataField : "condition",
      headerText : "<spring:message code='service.grid.condition'/>",
      width : "8%"
    }, {
      dataField : "branchLoc",
      headerText : "<spring:message code='service.grid.BranchCode'/>",
      width : "18%"
    }, {
        dataField : "holderLoc",
        headerText : "<spring:message code='service.grid.memberCode'/>",
        width : "13%"
    }, {
      dataField : "updDt",
      headerText : "<spring:message code='service.grid.lastUpdated'/>",
      width : "10%"
    }, {
      dataField : "creator",
      headerText : "<spring:message code='service.title.Creator'/>",
      width : "10%"
    },{
    	dataField : "transType", visible : false
    },{
        dataField : "delvStatus", visible : false
    }
    ];

    var excelLayout = [ {
        dataField : "serialNo",
        headerText : "<spring:message code='service.title.SerialNo'/>",
        width : "13%"
      }, {
        dataField : "model",
        headerText : "<spring:message code='service.grid.model'/>",
        width : "8%"
      }, {
        dataField : "status",
        headerText : "<spring:message code='service.grid.Status'/>",
        width : "8%"
      }, {
        dataField : "condition",
        headerText : "<spring:message code='service.grid.condition'/>",
        width : "8%"
      }, {
        dataField : "branchLoc",
        headerText : "<spring:message code='service.grid.BranchCode'/>",
        width : "18%"
      }, {
          dataField : "holderLoc",
          headerText : "<spring:message code='service.grid.memberCode'/>",
          width : "13%"
      }, {
        dataField : "updDt",
        headerText : "<spring:message code='service.grid.lastUpdated'/>",
        width : "10%"
      }, {
        dataField : "creator",
        headerText : "<spring:message code='service.title.Creator'/>",
        width : "10%"
      }
      ];

    var gridPros = {
      usePaging : true,
      pageRowCount : 20,
      showStateColumn : false,
      displayTreeOpen : false,
      //selectionMode : "singleRow",
      skipReadonlyColumns : true,
      wrapSelectionMove : true,
      showRowNumColumn : true,
      editable : false
    };

    var excelGridPros = {
      enterKeyColumnBase : true,
      useContextMenu : true,
      enableFilter : true,
      showStateColumn : true,
      displayTreeOpen : true,
      wordWrap : true,
      noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
      groupingMessage : "<spring:message code='sys.info.grid.groupingMessage' />",
      exportURL : "/common/exportGrid.do"
    };

    gridID = GridCommon.createAUIGrid("hiCare_grid_wap", columnLayout, "", gridPros);
    gridIDExcelHide = GridCommon.createAUIGrid("grid_wrap_hide", excelLayout, "", excelGridPros);
  }

  $(document).ready(
    function() {

    var brnch = '${SESSION_INFO.userBranchId}';
    var roleId = '${SESSION_INFO.roleId}';
    var userName = '${SESSION_INFO.userName}';


      hiCareGrid();

      $("#temp").hide();

      $("#cmdBranchCode").click(

              function() {
                  $("#cmdMemberCode").find('option').each(function() {
                      $(this).remove();
                      });
                  /* if ($(this).val().trim() == "") {
                      return;
                  } */
                  var param = {searchlocgb:'04' ,
                          searchBranch: ($('#cmdBranchCode').val()!="" ? $('#cmdBranchCode').val() : "00" )}
                  doGetComboData('/common/selectStockLocationList2.do', param , '', 'cmdMemberCode', 'M','f_multiComboType');
        });

      /* if(MEM_TYPE != "5"){
    	  if("${SESSION_INFO.memberLevel}" =="4"){ */

    		  //$('#cmdBranchCode').val(brnch);
    	  if(brnch == "42" || roleId == '180' || roleId == '179' || roleId == '250'){
    		  //doGetCombo('/services/hiCare/getBch.do', '', brnch, 'cmdBranchCode', 'M', 'f_multiComboType');
    		  doGetCombo('/services/hiCare/getBch.do', '', brnch, 'cmdBranchCode', 'S', '');
    		  $("#cmdBranchCode option[value='"+ brnch +"']", '#hiCareForm').attr("selected", true);
    		  $('#cmdBranchCode').trigger('click');
    	  }else{
    		  //$('#cmdBranchCode').prop("disabled", true);
    		  doGetCombo('/services/hiCare/getBch.do', brnch, brnch, 'cmdBranchCode', 'S', '');
    		  //$("#cmdBranchCode option[value='"+ brnch +"']", '#hiCareForm').attr("selected", true);
              $('#cmdBranchCode').trigger('click');
    	  }

    		  //$('#cmdBranchCode', '#hiCareForm').attr("readonly", true);
    		  //$('#cmdBranchCode', '#hiCareForm').attr('class','w100p readonly ');
    	  /* }
      } */

      //excel Download
      $('#excelDown').click(
        function() {
          var excelProps = {
            fileName : "Hi Care SPS Inventory Control",
            exceptColumnFields : AUIGrid.getHiddenColumnDataFields(gridIDExcelHide)
          };
          AUIGrid.exportToXlsx(gridIDExcelHide, excelProps);
      });

      $("#search").click(
    	function() {
    		fn_search();
      });

      AUIGrid.bind(gridID, "cellDoubleClick", function(event){
          var serialNo = event.item.serialNo;

          Common.popupDiv("/services/hiCare/hiCareDetailPop.do", {serialNo : serialNo}, null, true, 'detailPop');
      });
  });

  function f_multiComboType() {
	    $(function() {
	        $('#cmdMemberCode').change(function() {
	        }).multipleSelect({
	            selectAll : true
	        });

	        /* $('#cmdBranchCode').change(function() {
	          }).multipleSelect({
	              selectAll : true, // 전체선택
	              width : '80%'
	          }).multipleSelect("checkAll"); */
	        /* $('#cmdBranchCode').change(function() {
            }).multipleSelect({
                selectAll : true
            }); */

	    });
	}

  function fn_search() {
    Common.ajax("GET", "/services/hiCare/selectHiCareList", $("#hiCareForm").serialize(),function(result) {
        AUIGrid.setGridData(gridID, result);
        AUIGrid.setGridData(gridIDExcelHide, result);
      });
  }

  function fn_Clear() {
	  $("#serialNo").val('');
  }

  function fn_new() {
	  Common.popupDiv("/services/hiCare/hiCareNewPop.do", $("#hiCareForm").serializeJSON(), null, true, 'newPop');
  }

  function fn_modelUpdate() {
      Common.popupDiv("/services/hiCare/hiCareModelUpdatePop.do", $("#hiCareForm").serializeJSON(), null, true, 'modelUpdatePop');
  }

  function fn_edit(item) {
	  var selectedItem = AUIGrid.getSelectedItems(gridID);
	  if(selectedItem.length <= 0){
          Common.alert('<spring:message code="sal.alert.msg.noResultSelected" />');
          return;
      }

	  var isAssignMem = selectedItem[0].item.holderLoc;
	  var status = selectedItem[0].item.status;
	  var delvStatus = selectedItem[0].item.delvStatus;
	  console.log("delvStatus " + delvStatus);
	  if(item == '1'){ //consign
		  if(status != 'Active'){
              Common.alert("Only ACTIVE record able to assign to Cody");
              return;
          }
		  if(!(isAssignMem == " "|| isAssignMem == "-")){
	          Common.alert("This record has been assign to Cody");
	          return;
	      }
		  if(delvStatus == "N"){
			  Common.alert("This record is under transfer.");
              return;
		  }

	  }
	  if(item == '2'){ //return
		  if(status != 'Active'){
              Common.alert("Only ACTIVE record able to update");
              return;
          }
          /* if(isAssignMem == " " || isAssignMem == "-"){
              Common.alert("This record haven't assign to Cody");
              return;
          } */
		  if(delvStatus == "N"){
              Common.alert("This record is under transfer.");
              return;
          }
      }
	  if(item == '3'){ //deactivate
		  if(status != 'Active'){
              Common.alert("Only ACTIVE record able to deactivate");
              return;
          }
		  if(!(isAssignMem == " "|| isAssignMem == "-")){
              Common.alert("This record is under Cody, Kindly return to warehouse before deactivate");
              return;
          }
		  if(delvStatus == "N"){
              Common.alert("This record is under transfer.");
              return;
          }
      }

	  $("#_movementType").val('');
	  $("#_serialNo").val('');
      $("#_status").val('');
      $("#_condition").val('');

      $("#_movementType").val(item);
      $("#_serialNo").val(selectedItem[0].item.serialNo);
      $("#_status").val(selectedItem[0].item.status);
      $("#_condition").val(selectedItem[0].item.condition);

      var itemDs={
    		  "movementType" : item
    		  , "serialNo" : selectedItem[0].item.serialNo
    		  , "status" : selectedItem[0].item.status
    		  , "condition" : selectedItem[0].item.condition
      };

      Common.popupDiv("/services/hiCare/hiCareEditPop.do", itemDs, null, true, 'editPop');
  }

  function fn_transfer() {
      Common.popupDiv("/services/hiCare/hiCareTransferPop.do", null, null, true, 'transferPop');
  }

  function fn_exchange() {
	  var selectedItem = AUIGrid.getSelectedItems(gridID);
      if(selectedItem.length <= 0){
          Common.alert('<spring:message code="sal.alert.msg.noResultSelected" />');
          return;
      }

      var isAssignMem = selectedItem[0].item.holderLoc;
      var status = selectedItem[0].item.status;
      if(status != 'Active'){
          Common.alert("Only ACTIVE record able to assign to Cody");
          return;
      }
      if(isAssignMem == " "|| isAssignMem == "-"){
    	  Common.alert("This record haven't assign to Cody");
          return;
      }

      var itemDs={
              "serialNo" : selectedItem[0].item.serialNo
              , "status" : selectedItem[0].item.status
              , "condition" : selectedItem[0].item.condition
      };

      Common.popupDiv("/services/hiCare/hiCareFilterPop.do", itemDs, null, true, 'filterPop');
  }

  $(function(){
	  $('#btnStockListing').click(function() {
          Common.popupDiv("/services/hiCare/hiCareStockListingPop.do", null, null, true);
      });

	  $('#btnFilterListing').click(function() {
          Common.popupDiv("/services/hiCare/hiCareFilterListingPop.do", null, null, true);
      });

	   $('#btnFilterForecastListing').click(function() {
	          Common.popupDiv("/services/hiCare/hiCareFilterForecastListPop.do", null, null, true);
	      });

      $('#btnRawData').click(function() {
          Common.popupDiv("/services/hiCare/hiCareRawDataPop.do", null, null, true);
      });
  });
</script>
<section id="content">
 <!-- content start -->
 <ul class="path">
  <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
  <li><spring:message code='service.title.service'/></li>
  <li><spring:message code='service.title.hiCare'/></li>
 </ul>
 <aside class="title_line">
  <!-- title_line start -->
  <p class="fav">
   <a href="#" class="click_add_on">My menu</a>
  </p>
  <h2><spring:message code='service.title.hiCare'/></h2>
  <ul class="right_btns">
   <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue">
      <a href="#" id="search"><span class="search"></span><spring:message code='sys.btn.search'/></a>
     </p></li>
   </c:if>
   <li><p class="btn_blue"><a href="#" onclick="javascript:fn_Clear()"><span class="clear"></span>Clear</a></p></li>
  </ul>
 </aside>
 <!-- title_line end -->
 <section class="search_table">
  <!-- search_table start -->
    <form id="hiCareForm" name="hiCareForm" method="post">
    <table class="type1">
    <!-- table start -->
    <caption>table</caption>
    <colgroup>
    <col style="width: 150px" />
    <col style="width: *" />
    <col style="width: 150px" />
    <col style="width: *" />
    </colgroup>
    <tbody>
    <input type="text" id="temp" name="temp" placeholder="" class="w100p" />
		<tr>
            <th scope="row"><spring:message code='service.title.SerialNo'/></th>
                <td><input type="text" id="serialNo" name="serialNo" placeholder="<spring:message code='service.title.SerialNo'/>" class="w100p" /></td>
            <th scope="row"><spring:message code='service.grid.model'/></th>
                <td>
                    <select class="multy_select w100p" multiple="multiple" id="cmbModel" name="cmbModel">
			            <c:forEach var="list" items="${modelList}" varStatus="status">
			              <option value="${list.codeId}" selected>${list.codeDesc}</option>
			            </c:forEach>
                    </select>
                </td>
		</tr>
		<tr>
            <th scope="row"><spring:message code='service.grid.Status'/></th>
            <td>
                <select class="multy_select w100p" multiple="multiple" name="cmbStatus">
                    <option value="1" selected="selected"><spring:message code="sal.combo.text.active" /></option>
                    <option value="36" selected="selected"><spring:message code="sal.combo.text.closed" /></option>
                </select>
            </td>
            <th scope="row"><spring:message code='service.grid.condition'/></th>
            <td>
                <select class="multy_select w100p" multiple="multiple" name="cmbCondition">
                    <option value="33" selected="selected"><spring:message code="sal.combo.text.new" /></option>
                    <option value="111" selected="selected"><spring:message code="sal.combo.text.used" /></option>
                    <option value="112" selected="selected"><spring:message code="sal.combo.text.defect" /></option>
                    <option value="122" selected="selected"><spring:message code="sal.combo.text.repair" /></option>
                    <option value="7" selected="selected">Obsolete</option>
                </select>
            </td>
        </tr>
        <tr>
            <th scope="row"><spring:message code='service.grid.memberCode'/></th>
                <td>
                    <select id="cmdMemberCode" name="cmdMemberCode" class="w100p"></select>
                </td>
            <th scope="row"><spring:message code='service.grid.BranchCode'/></th>
                <td>
                <!-- <select class="multy_select w100p" multiple="multiple" name="cmdBranchCode" id="cmdBranchCode"></select> -->
                <select id="cmdBranchCode" name="cmdBranchCode" class="w100p"></select>
                   <%--  <select id="cmdBranchCode" name="cmdBranchCode" class="w100p readOnly ">
                        <option value="">Choose One</option>
                            <c:forEach var="list" items="${branchList}" varStatus="status">
                                <option value="${list.codeId}">${list.codeName}</option>
                            </c:forEach>
                    </select> --%>
                </td>
        </tr>
        <tr>
            <th scope="row"><spring:message code='service.grid.holderType'/></th>
            <td>
                <select class="multy_select w100p" multiple="multiple" name="cmbHolder">
                    <option value="277" selected="selected">Branch</option>
                    <option value="278" selected="selected">Member</option>
                </select>
            </td>
            <th scope="row">Filter Serial No</th>
                <td><input type="text" id="filterSN" name="filterSN" placeholder="Filter Serial No" class="w100p" /></td>

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
            <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
		        <li><p class="link_btn type2">
		            <a href="#" id="btnStockListing">Hi-Care Stock Listing</a>
                </p></li>
                <li><p class="link_btn type2">
                    <a href="#" id="btnFilterListing">Sediment Filter List</a>
                </p></li>
                 <li><p class="link_btn type2">
                    <a href="#" id="btnFilterForecastListing">Sediment Forecast Filter List</a>
                </p></li>
                 <li><p class="link_btn type2">
                    <a href="#" id="btnRawData">Hi-Care Raw Data</a>
                </p></li>
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
    </form>
    <form id="_editForm" method="post">
        <input type="hidden" id="_movementType" />
        <input type="hidden" id="_serialNo" />
        <input type="hidden" id="_status" />
        <input type="hidden" id="_condition" />
    </form>
    </section>
    <!-- search_table end -->
    <section class="search_result">
    <!-- search_result start -->
        <ul class="right_btns">
        <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
            <li><p class="btn_grid">
                <a href="#" onclick="javascript:fn_modelUpdate();">Model Update</a>
            </p></li>
        </c:if>
        <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
            <li><p class="btn_grid">
                <a href="#" onclick="javascript:fn_new();">New Entry</a>
            </p></li>
            <li><p class="btn_grid">
                <a href="#" onclick="javascript:fn_edit(1);">Consign</a>
            </p></li>
            <li><p class="btn_grid">
                <a href="#" onclick="javascript:fn_edit(2);"><spring:message code='sys.btn.update'/></a>
            </p></li>
            <li><p class="btn_grid">
                <a href="#" onclick="javascript:fn_transfer();">Transfer</a>
            </p></li>
            <li><p class="btn_grid">
                <a href="#" onclick="javascript:fn_exchange();">Filter Exchange</a>
            </p></li>
         </c:if>
        <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
            <li><p class="btn_grid">
                <a href="#" onclick="javascript:fn_edit(3);"><spring:message code='sys.btn.deactivate'/></a>
            </p></li>
        </c:if>

        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
            <li><p class="btn_grid">
                <a href="#" id="excelDown"><spring:message code='service.btn.Generate'/></a>
            </p></li>
        </c:if>
        </ul>
    <article class="grid_wrap">
    <!-- grid_wrap start  그리드 영역-->
	    <div id="hiCare_grid_wap" style="width: 100%; height: 500px; margin: 0 auto;"></div>
	    <div id="grid_wrap_hide" style="display: none;"></div>
    </article>
    <!-- grid_wrap end -->
    </section>
    <!-- search_result end -->
</section>
<!-- content end -->
