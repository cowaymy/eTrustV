<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">


	var orderGridID;
	var excelListGridID;

	$(document).ready(function() {
		createAUIGrid();
		createExcelAUIGrid();

	});

	$(function() {
		$('#btnExcelDown').click(
				function() {
					var excelProps = {
						fileName : "Daily Order Report",
						exceptColumnFields : AUIGrid
								.getHiddenColumnDataFields(excelListGridID)
					};
					AUIGrid.exportToXlsx(excelListGridID, excelProps);
				});

		$('#_btnDailyOrderReportSearch').click(function() {
		        fn_getSupplementDailyOrderReportList();
		    });
	});

	function createAUIGrid() {

		var orderColumnLayout = [ {
			dataField : "supRefNo",
			headerText : 'Supplement Reference No',
			width : '20%'
		}, {
			dataField : "supRefStus",
			headerText : 'Supplement Status',
			width : '20%'
		}, {
			dataField : "supRefStg",
			headerText : 'Reference Stage',
			width : '15%'
		}, {
			dataField : "custName",
			headerText : 'Customer Name',
			width : '15%'
		}, {
			dataField : "supRefDt",
			headerText : 'Order Create Date(Supplement Order)',
			width : '18%'
		}, {
			dataField : "payDt",
			headerText : 'Payment Date',
			width : '15%'
		}, {
			dataField : "orNo",
			headerText : 'Offical Receipt No',
			width : '15%'
		}, {
			dataField : "stkDesc",
			headerText : 'Item(s)',
			width : '15%'
		}, {
			dataField : "supItmQty",
			headerText : 'Quantity',
			width : '15%'
		}, {
			dataField : "addrDtl",
			headerText : 'Customer Address 1',
			width : '15%'
		}, {
			dataField : "street",
			headerText : 'Customer Address 2',
			width : '15%'
		}, {
			dataField : "city",
			headerText : 'City',
			width : '15%'
		}, {
			dataField : "state",
			headerText : 'State',
			width : '15%'
		}, {
			dataField : "postcode",
			headerText : 'PostCode',
			width : '15%'
		} ];

		var gridPros = {
			usePaging : true,
			pageRowCount : 20,
			editable : false,
			fixedColumnCount : 2,
			showStateColumn : true,
			displayTreeOpen : false,
			headerHeight : 30,
			useGroupingPanel : false,
			skipReadonlyColumns : true,
			wrapSelectionMove : true,
			showRowNumColumn : false
		};

		orderGridID = GridCommon.createAUIGrid("#dailyOrderReport_wrap",
				orderColumnLayout, '', gridPros);
	}

	function createExcelAUIGrid() {
		var excelColumnLayout = [ {
			dataField : "supRefNo",
			headerText : 'Supplement Reference No'
		}, {
			dataField : "supRefStus",
			headerText : 'Supplement Status'
		}, {
			dataField : "supRefStg",
			headerText : 'Reference Stage'
		}, {
			dataField : "custName",
			headerText : 'Customer Name'
		}, {
			dataField : "supRefDt",
			headerText : 'Order Create Date(Supplement Order)'
		}, {
			dataField : "payDt",
			headerText : 'Payment Date'
		}, {
			dataField : "orNo",
			headerText : 'Offical Receipt No'
		}, {
			dataField : "stkDesc",
			headerText : 'Item(s)'
		}, {
			dataField : "supItmQty",
			headerText : 'Quantity'
		}, {
			dataField : "addrDtl",
			headerText : 'Customer Address 1'
		}, {
			dataField : "street",
			headerText : 'Customer Address 2'
		}, {
			dataField : "city",
			headerText : 'City'
		}, {
			dataField : "state",
			headerText : 'State'
		}, {
			dataField : "postcode",
			headerText : 'PostCode'
		} ];

		var excelGridPros = {
			enterKeyColumnBase : true,
			useContextMenu : true,
			enableFilter : true,
			showStateColumn : true,
			displayTreeOpen : true,
			noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
			groupingMessage : "<spring:message code='sys.info.grid.groupingMessage' />",
			exportURL : "/common/exportGrid.do"
		};

		excelListGridID = GridCommon.createAUIGrid("excel_list_wrap",
				excelColumnLayout, "", excelGridPros);
	}

	function fn_getSupplementDailyOrderReportList() {
	    Common.ajax("GET", "/supplement/selectSupplementDailyOrderReportList.do",
	        $("#_dailyOrderReportForm").serialize(), function(result) {
	          AUIGrid.setGridData(orderGridID, result);
	          AUIGrid.setGridData(excelListGridID, result);
	        });
	  }
</script>

<div id="popup_wrap" class="popup_wrap">
  <header class="pop_header">
    <h1><spring:message code="supplement.btn.dailyReportOrder" /></h1>
    <ul class="right_opt">
      <li><p class="btn_blue2"><a href="#none" id="_closeOrdPop"><spring:message code="sal.btn.close" /></a></p></li>
    </ul>
  </header>
  <section class="pop_body">
 <ul class="right_btns mb10">
    <li><p class="btn_blue"><span class="search"></span><a href="#none" id="_btnDailyOrderReportSearch"><spring:message code="sal.btn.search" /></a></p></li>
    <li><p class="btn_blue"><span class="clear" ></span><a href="#none" onclick="javascript:$('#_dailyOrderReportForm').clearForm();"><spring:message code="sal.btn.clear" /></a></p></li>
  </ul>
   <form id="_dailyOrderReportForm" method="get">
   <input id="ind" name="ind" type="hidden" value="${ind}"/>
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
           <th scope="row"><spring:message code="sal.title.payDate" /><span class="must">*</span></th>
            <td>
              <div class="date_set w100p">
                <p>
                  <input id="paymentStartDt" name="paymentStartDt" type="text" value="${bfDay}" title="Create Start Date" placeholder="DD/MM/YYYY" class="j_date" />
                </p>
                <span>To</span>
                <p>
                  <input id="paymentEndDt" name="paymentEndDt" type="text" value="${toDay}" title="Create End Date" placeholder="DD/MM/YYYY" class="j_date" />
                </p>
              </div>      </tr>
      </tbody>
    </table>
      <section class="search_result">
    <ul class="right_btns">
      <li>
        <p class="btn_grid">
          <a href="#" id="btnExcelDown"><spring:message code='service.btn.Generate'/></a>
        </p>
      </li>
    </ul>
    <article class="grid_wrap"><!-- grid_wrap start -->
      <div id="dailyOrderReport_wrap" style="width:100%; height:580px; margin:0 auto;"></div>
      <div id="excel_list_wrap" style="display: none;"></div>
    </article>
  </section>
  </form>
  </section>

</div>
