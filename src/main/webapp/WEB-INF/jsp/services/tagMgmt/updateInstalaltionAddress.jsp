<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
  var gridID;
  var gridIDExcel;
  var counselingId;

  function tagMgmtGrid() {

    var columnLayout = [{
      dataField : "regDt",
      headerText : "Date",
      width : "10%"
    }, {
      dataField : "name",
      headerText : "Full Name",
      width : "20%"
    }, {
      dataField : "orderNo",
      headerText : "Order No",
      width : "10%"
    }, {
      dataField : "address",
      headerText : "Req Address",
      width : "30%"
    }, {
      dataField : "source",
      headerText : "Source",
      width : "10%"
    }, {
        dataField : "status",
        headerText : "Status",
        width : "10%"
    }, {
        dataField : "remark",
        headerText : "Remark",
        width : "20%"
    }, {
        dataField : "custId",
        headerText : "Customer ID",
        width : "10%",
        visible: false
    }, {
        dataField : "salesOrdId",
        headerText : "Sales Order ID",
        width : "10%",
        visible: false
    }, {
        dataField : "requestId",
        headerText : "Request ID",
        width : "10%",
        visible: false
    }, {
        dataField : "updator",
        headerText : "Approver",
        width : "10%",
        visible: true
    }, {
        dataField : "updDt",
        headerText : "Updated Date",
        width : "10%",
        visible: true
    }];

    var excelLayout = [{
        dataField : "regDt",
        headerText : "Date",
        width : 150
      }, {
        dataField : "name",
        headerText : "Full Name",
        width :300
      }, {
        dataField : "orderNo",
        headerText : "Order No",
        width : 150
      }, {
        dataField : "address",
        headerText : "Req Address",
        width : 600
      }, {
        dataField : "source",
        headerText : "Source",
        width : 150
      }, {
          dataField : "status",
          headerText : "Status",
          width : 150
      }, {
          dataField : "remark",
          headerText : "Remark",
          width : 300
      }, {
          dataField : "updator",
          headerText : "Approver",
          width : 150,
          visible: true
      }, {
          dataField : "updDt",
          headerText : "Updated Date",
          width : 150,
          visible: true
      }];

    var gridPros = {
	      usePaging : true,
	      pageRowCount : 20,
	      showStateColumn : false,
	      displayTreeOpen : false,
	      //selectionMode : "singleRow",
	      skipReadonlyColumns : true,
	      wrapSelectionMove : true,
	      showRowNumColumn : true,
	      editable : false,
	      showRowCheckColumn : true

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

    gridID = GridCommon.createAUIGrid("updInstallAddr_grid_wap", columnLayout, "", gridPros);
    gridIDExcelHide = GridCommon.createAUIGrid("grid_wrap_hide", excelLayout, "", excelGridPros);
  }

  function confirmApproval(param){
	  console.log("sdfsdf")
	  console.log(param);
	    Common.ajax("POST", "/services/tagMgmt/approveInstallationAddressRequest.do", {param}, function(result) {
	        Common.alert(result.message, fn_search);
	    }, function(jqXHR, textStatus, errorThrown) {
	        try {
	            Common.alert("Fail : Unable to approve");
	        }
	        catch (e) {
	            console.log(e);
	            Common.alert("Fail : " + e);
	        }
	    });
	}

  $(document).ready(function() {

      tagMgmtGrid();

      $("#search").click(function() {
            fn_search();
      });

      $("#btnApproval").click(function() {

    	    let checkedItems = AUIGrid.getCheckedRowItemsAll(gridID);

    	    if (checkedItems.length > 0) {
    	    	for (let i = 0; i < checkedItems.length; i++) {
    	    		if( checkedItems[i].status == "Active" || checkedItems[i].status =="Pending"){
    	    			confirmApproval(checkedItems);
    	    		}
    	    		else{
    	    		    Common.alert('* Please check the status "ACT"/ "PENDING" status is only available.');
    	    		    return;
    	    		}
    	    	}
    	    }else{
    	    	   Common.alert('Update Installation Address' + DEFAULT_DELIMITER + 'No Order Selected');
             }
      });

       //excel Download
       $('#excelDown').click(function() {
           var excelProps = {
             fileName : "Update Installation Address",
             exceptColumnFields : AUIGrid.getHiddenColumnDataFields(gridIDExcelHide)
           };
           AUIGrid.exportToXlsx(gridIDExcelHide, excelProps);
       });
  });

  function fn_search() {
          Common.ajax("GET", "/services/tagMgmt/selectUpdateInstallationAddressRequest", $("#updateInstallationForm").serialize(),
          function(result) {
	          AUIGrid.setGridData(gridID, result);
	          AUIGrid.setGridData(gridIDExcelHide, result);
          });
  }




</script>

<section id="content">
 <!-- content start -->
 <ul class="path">
	  <li><img src="${pageContext.request.contextPath}/images/common/path_home.gif" alt="Home" /></li>
	  <li><spring:message code='service.title.service'/></li>
	  <li><spring:message code='service.title.tagMgmt'/></li>
 </ul>

 <aside class="title_line">
	  <!-- title_line start -->
	  <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
	  <h2>Update Installation Address</h2>
	  <ul class="right_btns">
	          <li><p class="btn_blue"><a href="#" id="btnApproval">Approval</a></p></li>
		   <c:if test="${PAGE_AUTH.funcView == 'Y'}">
		    <li><p class="btn_blue"><a href="#" id="search"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
		   </c:if>
	  </ul>
 </aside>
 <!-- title_line end -->
 <section class="search_table">
  <form id="updateInstallationForm" name="updateInstallationForm" method="post">
   <table class="type1">
    <!-- table start -->
        <caption>table</caption>
	    <colgroup>
	     <col style="width: 180px" />
	     <col style="width: *" />
	     <col style="width: 180px" />
	     <col style="width: *" />
	     <col style="width: 160px" />
	     <col style="width: *" />
	    </colgroup>

    <tbody>
     <tr>
	      <th scope="row">Order Number</th>
	      <td><input type="text" id="orderNo" name="orderNo" " class="w100p" /></td>


	      <th scope="row"><spring:message code='service.grid.registerDt'/></th>
	      <td>
		      <div class="date_set w100p">
		        <p><input type="text" title="Create start Date" value="${bfDay}" placeholder="DD/MM/YYYY" class="j_date w100p" id="regStartDt" name="regStartDt" /></p>
		        <span>To</span>
		        <p><input type="text" title="Create end Date" value="${toDay}" placeholder="DD/MM/YYYY" class="j_date w100p" id="regEndDt" name="regEndDt" /></p>
		       </div>
	      </td>

          <th scope="row"><spring:message code='service.grid.Status'/></th>
          <td><select class="multy_select w100p" multiple="multiple" id="statusList" name="statusList">
          <c:forEach var="list" items="${tMgntStat}" varStatus="status">
              <option value="${list.code}" selected>${list.codeName}</option>
           </c:forEach>


          </select></td>
     </tr>


    </tbody>
   </table>
   <!-- table end -->
  </form>
 </section>
 <!-- search_table end -->
 <section class="search_result">
  <!-- search_result start -->
  <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
   <ul class="right_btns">
    <li><p class="btn_grid">
      <a href="#" id="excelDown"><spring:message code='service.btn.Generate'/></a>
     </p></li>
   </ul>
  </c:if>
  <article class="grid_wrap">
   <!-- grid_wrap start  그리드 영역-->
   <div id="updInstallAddr_grid_wap"
    style="width: 100%; height: 500px; margin: 0 auto;"></div>
   <div id="grid_wrap_hide" style="display: none;"></div>
  </article>
  <!-- grid_wrap end -->
 </section>
 <!-- search_result end -->
</section>
<!-- content end -->
