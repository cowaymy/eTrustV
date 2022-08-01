<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
  var gridID;
  var gridIDExcel;
  var counselingId;

  var MEM_TYPE = '${SESSION_INFO.userTypeId}';
  var brnch = '${SESSION_INFO.userBranchId}';

  var userName = '${SESSION_INFO.userName}';

  function hiCareGrid() {

    var columnLayout = [ {
        dataField : "transitNo",
        headerText : "Transit No.",
        width : "13%"
    },{
        dataField : "status",
        headerText : "Status",
        width : "13%"
    },{
      dataField : "fromLocation",
      headerText : "From",
      width : "20%"
    }, {
      dataField : "toLocation",
      headerText : "To",
      width : "20%"
    }, {
      dataField : "crtDt",
      headerText : "Create Date",
      width : "8%"
    }, {
      dataField : "creator",
      headerText : "Creator",
      width : "8%"
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

      hiCareGrid();

      console.log('branch ' +brnch);

      //$("#cmbToBranch option:eq(1)", '#hiCareDeliveryForm').attr("selected", true);
      if(brnch == "42" || roleId == '180' || roleId == '179' || roleId == '250'){
          doGetCombo('/services/hiCare/getBch.do', '', brnch, 'cmbToBranch', 'S', '');
          $("#cmbToBranch option[value='"+ brnch +"']", '#hiCareDeliveryForm').attr("selected", true);
      }else{
          doGetCombo('/services/hiCare/getBch.do', brnch, brnch, 'cmbToBranch', 'S', '');
      }

      $("#crtsdt").val('${searchVal.crtsdt}');
      $("#crtedt").val('${searchVal.crtedt}');
      /* if(MEM_TYPE != "5"){
    	  if("${SESSION_INFO.memberLevel}" =="4"){ */
    		  //$('#cmdBranchCode', '#hiCareForm').attr("readonly", true);
    		  //$('#cmdBranchCode', '#hiCareForm').attr('class','w100p readonly ');
    	  /* }
      } */

      //excel Download
      $('#printNote').click(
        function() {
        	var selectedItem = AUIGrid.getSelectedItems(gridID);

        	if(selectedItem.length <= 0){
                Common.alert('No data selected.');
                return false;
            }
        	var tmpno = selectedItem[0].item.transitNo;
        	$("#V_DELVRYNO").val(tmpno);
            Common.report("printForm");
      });

      $("#search").click(
    	function() {
    		fn_search();
      });

      $("#updGR").click(
    	        function() {
    	        	var selectedItem = AUIGrid.getSelectedItems(gridID);
    	        	if(selectedItem.length <= 0){
    	                Common.alert('<spring:message code="sal.alert.msg.noResultSelected" />');
    	                return;
    	            }

    	            var transitNo = selectedItem[0].item.transitNo;
    	            var status = selectedItem[0].item.status;
    	            console.log('status' + status);
    	            if(status == 'Active'){
    	            	  Common.popupDiv("/services/hiCare/hiCareDeliveryReceivePop.do", {transitNo : transitNo}, null, true, 'receivePop');
    	            }else{
    	            	Common.alert('Cannot update the result. Transit No. already completed. ');
    	            }
    	      });

      AUIGrid.bind(gridID, "cellDoubleClick", function(event){
          var transitNo = event.item.transitNo;
          Common.popupDiv("/services/hiCare/hiCareDeliveryDetailPop.do", {transitNo : transitNo}, null, true, 'delvryPop');
      });
  });

  function f_multiComboType() {
	    $(function() {
	        $('#cmdMemberCode').change(function() {
	        }).multipleSelect({
	            selectAll : true
	        });

	    });
	}

  function fn_search() {
    Common.ajax("GET", "/services/hiCare/selectHiCareDeliveryList", $("#hiCareDeliveryForm").serializeJSON(),function(result) {
        AUIGrid.setGridData(gridID, result);
      });
  }

  function fn_Clear() {
	  $("#transitNo").val('');
	  $("#serialNo").val('');
  }
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
  <h2><spring:message code='service.title.hiCareDelivery'/></h2>
  <ul class="right_btns">
  <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    <li><p class="btn_blue">
      <a href="#" id="updGR"><span class="updGR"></span>Update Receive</a>
     </p></li>
   </c:if>
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
    <form id="hiCareDeliveryForm" name="hiCareDeliveryForm" method="post">
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
		<tr>
            <th scope="row">Transit No.</th>
                <td><input type="text" id="transitNo" name="transitNo" placeholder="Transit No." class="w100p" /></td>
            <th scope="row">Transit Status</th>
            <td>
                <select class="w100p" id="status" name="status">
	                <option value="0" selected>Choose One</option>
	                <option value="1"><spring:message code="sal.combo.text.active" /></option>
                    <option value="4"><spring:message code="sal.combo.text.compl" /></option>
                </select>
            </td>
		</tr>
		<tr>
            <th scope="row"><spring:message code='service.title.SerialNo'/></th>
                <td><input type="text" id="serialNo" name="serialNo" placeholder="<spring:message code='service.title.SerialNo'/>" class="w100p" /></td>
            <th scope="row">Create Date</th>
            <td>
		       <div class="date_set w100p">
		        <!-- date_set start -->
		        <p>
		         <input id="crtsdt" name="crtsdt" type="text"
		          title="Create start Date" placeholder="DD/MM/YYYY"
		          class="j_date">
		        </p>
		        <span> To </span>
		        <p>
		         <input id="crtedt" name="crtedt" type="text"
		          title="Create End Date" placeholder="DD/MM/YYYY"
		          class="j_date">
		        </p>
		       </div>
	       <!-- date_set end -->
	      </td>
        </tr>
        <tr>
            <th scope="row"><spring:message code='log.head.fromlocation'/></th>
                <td>
                    <select id="cmbFromBranch" name="cmbFromBranch" class="w100p readOnly ">
                        <option value="">Choose One</option>
                            <c:forEach var="list" items="${fromBranchList}" varStatus="status">
                                <option value="${list.codeId}">${list.codeName}</option>
                            </c:forEach>
                    </select>
                </td>
            <th scope="row"><spring:message code='log.head.tolocation'/></th>
                <td>
                    <select id="cmbToBranch" name="cmbToBranch" class="w100p"></select>
                    <%-- <select id="cmbToBranch" name="cmbToBranch" class="w100p readOnly ">
                        <option value="">Choose One</option>
                            <c:forEach var="list" items="${toBranchList}" varStatus="status">
                                <option value="${list.codeId}">${list.codeName}</option>
                            </c:forEach>
                    </select> --%>
                </td>
        </tr>
    </tbody>
    </table>
    <!-- table end -->
    </form>
    </section>
    <!-- search_table end -->
    <section class="search_result">
    <!-- search_result start -->
        <ul class="right_btns">
        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
            <li><p class="btn_grid">
                <a href="#" id="printNote">PRINT</a>
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
    <form id="printForm" name="printForm">
       <input type="hidden" id="viewType" name="viewType" value="PDF" />
       <input type="hidden" id="V_DELVRYNO" name="V_DELVRYNO" value="" />
       <input type="hidden" id="reportFileName" name="reportFileName" value="/logistics/HiCare_Delivery_Note.rpt" /><br />
    </form>
</section>
<!-- content end -->
