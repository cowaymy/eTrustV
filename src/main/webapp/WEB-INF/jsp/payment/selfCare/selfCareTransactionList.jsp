<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
	var selfCareGridID;
	var option = {
	    width : "1200px", // 창 가로 크기
	    height : "500px" // 창 세로 크기
	};

	$(document).ready(function() {
	    createAUIGrid();
		f_multiCombo();

	    AUIGrid.bind(selfCareGridID, "cellDoubleClick", function(event) {
	    	fn_viewSelfCareDetailPop(event.item.fileId);
	    });

	    //Search
	    $("#_listSearchBtn").click(function() {
	    	if(FormUtil.isNotEmpty($('#createDateTo').val()) || FormUtil.isNotEmpty($('#createDateFrom').val())){
	    		if((FormUtil.isNotEmpty($('#createDateTo').val()) && FormUtil.isNotEmpty($('#createDateFrom').val())) == false)
	    		{
	    			Common.alert("Please Fill in both From and To Date");
	    			return;
	    		}
	    	}

	      Common.ajax("GET", "/payment/selfCareHostToHost/getSelfCareTransactionList.do", $("#searchForm").serialize(), function(result) {
	          AUIGrid.setGridData(selfCareGridID, result);
	        });
	    });

	    $('#_viewDetailBtn').click(function(){
    		var selIdx = AUIGrid.getSelectedIndex(selfCareGridID)[0];
	      	if(selIdx > -1) {
      			var fileId=  AUIGrid.getCellValue(selfCareGridID, selIdx, "fileId")
				if(fileId != null && fileId > 0){
			    	fn_viewSelfCareDetailPop(fileId);
				}
	         }
	      	else{
	      		Common.alert("No record selected.");
	      	}
	    });

	    $("#_generateBtn").click(function() {
// 	    	var selIdx = AUIGrid.getSelectedIndex(selfCareGridID)[0];
// 	      	if(selIdx > -1) {
//       			var fileId=  AUIGrid.getCellValue(selfCareGridID, selIdx, "fileId")
// 				if(fileId != null && fileId > 0){
// 					fn_viewSelfCareReportDetailPop(fileId);
// 				}
// 	         }
// 	      	else{
// 	      		Common.alert("No record selected.");
// 	      	}
	    	fn_viewSelfCareReportDetailPop();
		});
	});

	function fn_viewSelfCareDetailPop(fileId){
		 var data = {
				 fileId : fileId
		    };
		    Common.popupDiv("/payment/selfCareHostToHost/selfCareDetailPop.do", data, null, true, "selfCareDetailPop");
	}

	function fn_viewSelfCareReportDetailPop(){
		    Common.popupDiv("/payment/selfCareHostToHost/selfCareReportDetailPop.do", null, null, true, "selfCareReportDetailPop");
	}

	function f_multiCombo() {
	    $('#status').change(function() {
	    }).multipleSelect({
	      selectAll : true,
	      width : '100%'
	    });
	  }

    function createAUIGrid() {
        var columnLayout = [
             {
 	              dataField : "prcssStusId",
 	              headerText : 'Process Status Id',
 	              visible: false,
 	              editable : false
           	 },
             {
	              dataField : "fileId",
	              headerText : 'File ID.',
	              editable : false
             },
             {
	              dataField : "fileName",
	              headerText : 'File Name',
	              editable : false
             },
             {
	              dataField : "total",
	              headerText : 'Total Record',
	              editable : false
             },
             {
	              dataField : "totalSuccess",
	              headerText : 'Total Success',
	              editable : false
             },
             {   dataField : "", headerText : 'Other Status',
                 renderer:{
                     type: "TemplateRenderer"
                 },
                 labelFunction: function( rowIndex, columnIndex, value, headerText, item, dataField){
                      var template = '<div style="margin-top:5px; margin-bottom:10pc">';
                      template += '<p> Total Incomplete: ' + item.totalIncomplete + '</p>';
                      template += '<p> Total Pending: ' + item.totalPending + '</p>';
                      template += '<p> Total Fail: ' + item.totalFail + '</p>';
                      template += '</div>';
                      return template;
                 }
           	 },
             {
	              dataField : "prcssStusDesc",
	              headerText : 'Status',
	              editable : false
            },
            {
	              dataField : "prcssStusRemark",
	              headerText : 'Remark',
	              editable : false
           },
           {
	              dataField : "crtDt",
	              headerText : 'Created Date',
	              editable : false
        	}
       ];

        var gridPros = {
        	      usePaging : true,
        	      pageRowCount : 20,
        	      fixedColumnCount : 3,
        	      showStateColumn : false,
        	      displayTreeOpen : true,
        	      headerHeight : 30,
        	      useGroupingPanel : false,
        	      skipReadonlyColumns : true,
        	      wrapSelectionMove : true,
        	      wordWrap : true
        	    };
        selfCareGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
    }

    function fn_clear() {
        $('#searchForm')[0].reset();
        f_multiCombo();
    }
</script>
<section>
  <ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
  </ul>
    <aside class="title_line">
    <p class="fav"><a href="#" class="click_add_on"><spring:message code='pay.text.myMenu' /></a></p>
    <h2>Selfcare</h2>
    <ul class="right_btns">
      <c:if test="${PAGE_AUTH.funcView == 'Y'}">
        <li><p class="btn_blue"><a id="_listSearchBtn" href="#"><span class="search"></span>
            <spring:message code='sys.btn.search' /></a></p></li>
      </c:if>
      <li><p class="btn_blue"><a href="#" onclick="fn_clear();"><span class="clear"></span>
          <spring:message code='sys.btn.clear' /></a></p></li>
    </ul>
  </aside>
  <section class="search_table">
	   <form id="searchForm" action="#" method="post">
		   	<table class="type1">
        		<caption>table</caption>
		        <colgroup>
		          <col style="width: 170px" />
		          <col style="width: *" />
		          <col style="width: 230px" />
		          <col style="width: *" />
		          <col style="width: 160px" />
		          <col style="width: *" />
		        </colgroup>
		        <tbody>
		        	<tr>
		        		<th>File ID</th>
		        		<td>
		        			<input type="text" title="File ID" id="fileId" name="fileId" placeholder="File ID" class="w100p" />
		        		</td>
		        		<th>Create Date</th>
		        		<td>
							<div class="date_set w100p">
								<p><input id="createDateFrom" name="createDateFrom" type="text" title="Create Date From" placeholder="DD/MM/YYYY" class="j_date" autocomplete="off" /></p> <span>~</span>
								<p><input id="createDateTo" name="createDateTo" type="text" title="Create Date To" placeholder="DD/MM/YYYY" class="j_date" autocomplete="off" /></p>
							</div>
		        		</td>
		        		<th>Status</th>
						<td>
							<select id="status" name="status" class="w100p multy_select" multiple="multiple">
							    <option value="102">Ready</option>
							    <option value="4">Completed</option>
							    <option value="21">Failed</option>
							</select>
						</td>
		        	</tr>
		        </tbody>
		   	</table>
	   </form>

	   <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
	    <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
	    <dl class="link_list">
	        <dt>Link</dt>
	        <dd>
	        <ul class="btns">
	            <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
	            	<li><p class="link_btn"><a href="#" id="_viewDetailBtn">View Details</a></p></li>
	            </c:if>
	            <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
	            	<li><p class="link_btn"><a href="#" id="_generateBtn">Generate Report</a></p></li>
	            </c:if>
	        </ul>
	        <ul class="btns">
	        </ul>
	        <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
	        </dd>
	    </dl>
	    </aside><!-- link_btns_wrap end -->
  </section>
  <section class="search_result">
    <!-- grid_wrap start -->
    <article class="grid_wrap">
      <!-- grid_wrap start -->
      <div id="grid_wrap"></div>
    </article>
    <!-- grid_wrap end -->
    <!-- grid_wrap end -->
  </section>
</section>