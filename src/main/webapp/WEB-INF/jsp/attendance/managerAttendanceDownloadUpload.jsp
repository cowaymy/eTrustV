<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">

:root .event-text {
    --cal-event-text-width: attr(width);
}

.cal-result  {
    border-left: 1px solid #d3d9dd;
    border-right: 1px solid #d3d9dd;
}

.cal-header-month {
    font-size: 20px !important;
    background-color: #25527c !important;
    height: 40px !important;
    color: white !important;
}

.cal-header-year {
    font-size: 20px !important;
    background-color:white !important;
}

th.day-of-week {
    border: 1px solid #d3d9dd;
    padding-left: 8px !important;
}

td.cal-date, td.empty-cell {
    border: 1px solid #d3d9dd;
    height: 60px !important;
}

.cal-date-number {
    width: 100%;
    margin-bottom: 8px;
}

.cal-event-list {
    position: relative;
    width: 100%;
}

.event-text {
    height: 40px;
    white-space: nowrap;
    text-overflow: ellipsis;
    width: inherit;
    display: block;
    overflow: hidden;
    font-size: 12px;
    line-height: 1.6;
}

.cal-tooltip {
    visibility: hidden;
    border: 3px solid #25527c;
    border-radius: 5px;
    padding: 15px;
    background-color: #e9f0f4;
    position: absolute;
    z-index: 1;
    bottom: 100%;
    display: inline-block;
    width: var(--cal-event-text-width);
    line-height: 1.6;
    white-space: nowrap;
    box-shadow: 2px 2px 3px 1px #dddddd;
}

td:first-child .cal-tooltip, td:nth-child(2) .cal-tooltip {
    left: 0;
}

td:nth-child(6) .cal-tooltip, td:nth-child(7) .cal-tooltip {
    right: 0;
}

.cal-event-list:hover .cal-tooltip:not(:empty) {
    visibility: visible;
}
</style>

<script type="text/javaScript" language="javascript">

var myGridID;

var gridPros = {
	      //showRowCheckColumn : true,
	      usePaging : true,
	      pageRowCount : 20,
	      //showRowAllCheckBox : true,
	      editable : false,
	      selectionMode : "multipleCells"
	    };

$(document).ready(function(){

    // *** set initial values when Calendar first loaded - start
    var eventList = JSON.parse('${eventListJsonStr}');

    atdManagementGrid();
    searchAtdUploadList();

});

function atdManagementGrid() {
    var columnLayout = [
        {
          dataField : "batchId",
          headerText : "Upload Batch No",
          editable : false,
          width : 200
        },
        {
          dataField : "batchMthYear",
          headerText : "Month Year",
          editable : false,
          width : 200
        },
        {
          dataField : "memType",
          headerText : "Member Type",
          editable : false,
          width : 200
          },
        {
          dataField : "stus",
          headerText : "Approval Status",
          width : 200
        },
        {
          dataField : "crtDt",
          headerText : "Upload Date",
          dataType : "date",
          formatString : "dd/mm/yyyy",
          width : 200
        },
        {
            dataField : "userName",
            headerText : "Creator",
            width : 200
        }
    ];

    myGridID = AUIGrid.create("#grid_wrap_atdList", columnLayout, gridPros);

  }

 function searchAtdUploadList(){
	  Common.ajax("GET", "/attendance/searchAtdUploadList.do", $("#calSearchForm").serialize(), function(result) {
          AUIGrid.setGridData(myGridID, result);
      });
 }

function fn_eventUploadPopup() {
    Common.popupDiv("/attendance/attendanceFileUploadPop.do", null, '', true, '');
}

function fn_eventEditDeletePopup() {
    Common.popupDiv("/attendance/attendanceFileEditDeletePop.do", null, '', true, '');
}

function fn_eventDownloadPopup() {
    Common.popupDiv("/attendance/attendanceFileDownloadPop.do", null, '', true, '');
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
    });
};


$(function() {

    $("#btnApproval").click(function(e){
    	  var selIdx = AUIGrid.getSelectedIndex(myGridID)[0];
    	  var param;

    	     if(selIdx > -1) {

    	         var stus = AUIGrid.getCellValue(myGridID, selIdx, "stus");

    	         if( stus != "Active"){
    	        	 Common.alert('* Please check the status "ACT" status is only available.');
    	         }
    	         else{
    	             param = {batchId : AUIGrid.getCellValue(myGridID, selIdx, "batchId")};
    	             var confirmApprovalMsg = "Are you sure want to confirm this Upload Batch No : " + AUIGrid.getCellValue(myGridID, selIdx, "batchId") + "?";
                     Common.confirm(confirmApprovalMsg, x=function() { confirmApproval(param)});
    	         }
    	     }else{
    	         Common.alert('Attendance Upload Batch' + DEFAULT_DELIMITER + 'No Order Selected');
    	     }

    });
});

function confirmApproval(param){
    Common.ajax("POST", "/attendance/approveUploadBatch.do", param, function(result) {
    	Common.alert(result.message, searchAtdUploadList);
    });
}

</script>

<section id="content"><!-- content start -->
  <ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>MISC</li>
  </ul>

  <aside class="title_line"><!-- title_line start -->
    <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
    <h2>Attendance</h2>
    <ul class="right_btns">
     <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
        <li><p class="btn_blue"><a href="#" id="btnApproval">Approval</a></p></li>
     </c:if>
      <li><p class="btn_blue"><a href="#" onClick="searchAtdUploadList()"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
      <li><p class="btn_blue"><a id="btnClear" href="#" onclick="javascript:$('#calSearchForm').clearForm();"><span class="clear"></span><spring:message code='sales.Clear'/></a></p></li>
    </ul>
  </aside><!-- title_line end -->

  <section class="search_table"><!-- search_table start -->
    <form id="calSearchForm" name="calSearchForm" method="post" action="/logistics/calendar/selectCalendarEvents.do">
      <table class="type1"><!-- table start -->
        <caption>table</caption>
        <colgroup>
          <col style="width:150px" />
          <col style="width:*" />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row"><spring:message code='cal.search.month'/></th>
            <td colspan='3'><input type="text" id="calMonthYear" name="calMonthYear" title="Month" class="j_date2" placeholder="Choose one" /></td>
          </tr>
          <tr id = "rowMemType">
            <th scope="row"><spring:message code='cal.search.memType'/></th>
            <td colspan='3'>
              <select class="" id="calMemType" name="calMemType">
                <option value="">Choose One</option>
                <option value="4">Staff</option>
                <option value="6677">Manager</option>
              </select>
            </td>
          </tr>
        </tbody>
      </table><!-- table end -->
    </form>
  </section><!-- search_table end -->

  <aside class="link_btns_wrap">
      <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
      <dl class="link_list">
        <dt>Link</dt>
        <dd>
          <ul class="btns">
            <li><p class="link_btn"><a href="javascript:fn_eventUploadPopup();">Upload Attendance</a></p></li>
            <li><p class="link_btn"><a href="javascript:fn_eventEditDeletePopup();">Edit / Delete Attendance</a></p></li>
            <li><p class="link_btn"><a href="javascript:fn_eventDownloadPopup();">Download Attendance</a></p></li>
          </ul>
          <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
        </dd>
      </dl>
  </aside><!-- link_btns_wrap end -->
  <br>
  <section class="search_result"><!-- search_result start -->
   <article class="grid_wrap">
    <!-- grid_wrap start -->
    <div id="grid_wrap_atdList" style="width: 100%; height: 500px; margin: 0 auto;"></div>
   </article>
  </section><!-- search_result end -->
</section><!-- content end -->
