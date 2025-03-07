<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}

/* 커스컴 disable 스타일*/
.mycustom-disable-color {
    color : #cccccc;
}

/* 그리드 오버 시 행 선택자 만들기 */
.aui-grid-body-panel table tr:hover {
    background:#D9E5FF;
    color:#000;
}
.aui-grid-main-panel .aui-grid-body-panel table tr td:hover {
    background:#D9E5FF;
    color:#000;
}

</style>

<script type="text/javaScript">
	//화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
	today = "${today}";
	var rawFileGrid2;

	$(document).ready(function() {

		doGetCombo('/commission/report/checkDirectory.do', 'FN', '','cbfinance', 'S' , ''); //File Type 리스트 조회

		$("#grid_wrap2").hide();
		var columnLayout2 = [
		                     {dataField: "orignlfilenm",headerText :"<spring:message code='log.head.filename'/>" ,width: "30%"   ,visible:true },
		                     {dataField: "updDt",headerText :"<spring:message code='log.head.writetime'/>"   ,width: "30%"   , dataType :     "date"     ,formatString :     "yyyy. mm. dd hh:MM TT"    ,visible:true },
		                     {dataField: "filesize",headerText :"<spring:message code='log.head.filesize'/>" ,width: "30%"   ,postfix :  "bytes"   ,dataType :     "numeric" ,visible:true},
		                     {
		                         dataField : "",
		                         headerText : "",
		                         renderer : {
		                             type : "ButtonRenderer",
		                             labelText : "Download",
		                             onclick : function(rowIndex, columnIndex, value, item) {
		                               fileDown(rowIndex,"FN");
		                             }
		                         }
		                     , editable : false
		                     },
		                     {dataField: "subpath",headerText :"<spring:message code='log.head.subpath'/>",width:120    ,height:30 , visible:false},
		                     {dataField: "filename",headerText :"<spring:message code='log.head.filename'/>",width:120    ,height:30 , visible:false},
		                     {dataField: "fileEt",headerText :"<spring:message code='log.head.fileet'/>",width:120    ,height:30 , visible:false}
		                     ];

		var gridoptions = {
		        showStateColumn : false ,
		        editable : false,
		        pageRowCount : 10,
		        usePaging : true,
		        useGroupingPanel : false,
		        noDataMessage :  "<spring:message code='sys.info.grid.noDataMessage' />"
		        };

		rawFileGrid2 = AUIGrid.create("#grid_wrap2", columnLayout2, gridoptions);


		//form clear
		$("#clear").click(function() {
			$("#searchForm")[0].reset();
			$("#reportType").trigger("change");
		});

		//change report type box
		$("#reportType").change(function() {
			val = $(this).val();
			var $reportForm = $("#reportForm")[0];
			$($reportForm).empty(); //remove children
		});

		// search member code
		$('#generate').click(function() {
			var $reportForm = $("#reportForm")[0];

			$($reportForm).empty(); //remove children
			var type = $("#reportType").val(); //report type
			var cmmDt = $("#searchForm #cmmDt").val(); //commission date

			if (type == "") {
				//Common.alert("Please select Report Type ");
				Common.alert("<spring:message code='commission.alert.report.selectType'/>");
				return;
			} else if (cmmDt == "") {
				//Common.alert("Please select Commission Period ");
				Common.alert("<spring:message code='commission.alert.report.selectPeriod'/>");
				return;
		  }

			var reportDownFileName = ""; //download report name
			var reportFileName = ""; //reportFileName
			var reportViewType = ""; //viewType

			//default input setting
			$($reportForm).append('<input type="hidden" id="reportFileName" name="reportFileName"  /> ');//report file name
			$($reportForm).append('<input type="hidden" id="reportDownFileName" name="reportDownFileName" /> '); // download report name
			$($reportForm).append('<input type="hidden" id="viewType" name="viewType" /> '); // download report  type
			var month = Number(cmmDt.substring(0, 2));
			var year = Number(cmmDt.substring(3));
			var taskID = month + (year * 12) - 24157; //taskId

			if (type == "4") {
				reportFileName = "/commission/AllCommissionRawDate_Excel.rpt"; //reportFileName
				reportDownFileName = "AllCommissionRawDate_Excel_" + today; //report name
				reportViewType = "EXCEL"; //viewType

				//set parameters
				$($reportForm).append('<input type="hidden" id="TaskID" name="TaskID" value="" /> ');
				$("#reportForm #TaskID").val(taskID);
			} else if (type == "10") {

				reportFileName = "/commission/SalesPVReport_Excel.rpt"; //reportFileName
				reportDownFileName = "SalesPV_Excel_" + today; //report name
				reportViewType = "EXCEL"; //viewType

				//set parameters
				$($reportForm).append('<input type="hidden" id="PvMth" name="PvMth" value="" /> ');
				$($reportForm).append('<input type="hidden" id="PvYear" name="PvYear" value="" /> ');
				$("#reportForm #PvMth").val(month);
				$("#reportForm #PvYear").val(year);

			} else if (type == "12") {

				reportFileName = "/commission/AdvPayRawData_Excel.rpt"; //reportFileName
				reportDownFileName = "AdvPayment_Excel_" + today; //report name
				reportViewType = "EXCEL"; //viewType

				//set parameters
		    $($reportForm).append('<input type="hidden" id="TaskID" name="TaskID" value="" /> ');

	      $("#reportForm #TaskID").val(taskID);

			}

			//report info
			if (reportFileName == "" || reportDownFileName == "" || reportViewType == "") {
				Common.alert("<spring:message code='sys.common.alert.validation' arguments='Report Info' htmlEscape='false'/>");
				return;
			}

			//default setting
			$("#reportForm #reportFileName").val(reportFileName);
			$("#reportForm #reportDownFileName").val(reportDownFileName);
			$("#reportForm #viewType").val(reportViewType);

			//  report 호출
			var option = {
				isProcedure : false, // procedure 로 구성된 리포트 인경우 필수.
			};
			Common.report("reportForm", option);

		});

	});

	$(function(){
		$('#cbfinance').change(function() {
			var div= $('#cbfinance').val();
			$("#grid_wrap2").show();
			SearchListAjax2(div);
		});
	});

	function SearchListAjax2(str) {
	    var url = "/commission/report/rawdataList.do";
	    var param = {type :"Finance/"+str};
	    Common.ajax("GET" , url , param , function(data){
	        console.log(data);
	        AUIGrid.clearGridData(rawFileGrid2);
	        AUIGrid.setGridData(rawFileGrid2, data);
	        var sortingInfo = [];
	        // 차례로 Country, Name, Price 에 대하여 각각 오름차순, 내림차순, 오름차순 지정.
	        sortingInfo[0] = { dataField : "updDt", sortType : -1 };
	        AUIGrid.setSorting(rawFileGrid2, sortingInfo);

	        AUIGrid.resize(rawFileGrid2);
	    });
	}

	function fileDown(rowIndex,str){
        var subPath;
        var fileName;
        var orignlFileNm;
    if("FN"==str){
        subPath = "/resources/WebShare/RawData/Finance/"+$('#cbfinance').val();
        orignlFileNm = AUIGrid.getCellValue(rawFileGrid2,  rowIndex, "orignlfilenm");
    }
  window.open("${pageContext.request.contextPath}"+subPath + "/" + orignlFileNm);
}
</script>


<section id="content">
	<!-- content start -->
	<ul class="path">
		<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
		<li><spring:message code='commission.text.head.commission'/></li>
		<li><spring:message code='commission.text.head.report'/></li>
	</ul>

	<aside class="title_line">
		<!-- title_line start -->
		<p class="fav">
			<a href="#" class="click_add_on">My menu</a>
		</p>
		<h2><spring:message code='commission.title.finance'/></h2>
	</aside>
	<!-- title_line end -->


	<section class="search_table">
		<!-- search_table start -->
		<form name="searchForm" id="searchForm" method="post">
			<table class="type1">
				<!-- table start -->
				<caption>table</caption>
				<colgroup>
					<col style="width: 140px" />
					<col style="width: *" />
					<col style="width: 170px" />
					<col style="width: *" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row"><spring:message code='commission.text.search.reportType'/></th>
						<td colspan="3"><select id="reportType" name="reportType">
								<option value="">Report/Raw Data Type</option>
								<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}"><option value="4">Finance Commisision</option></c:if>
								<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}"><option value="10">Sales PV Report</option></c:if>
								<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}"><option value="12">Advanced Payment Report</option></c:if>
						</select></td>
					</tr>
					<tr>
						<th scope="row"><spring:message code='commission.text.search.period'/></th>
						<td colspan="3"><input type="text" id="cmmDt" name="cmmDt" title="Date" class="j_date2" value="${cmmDt }" /></td>
					</tr>
				</tbody>
			</table>
			<!-- table end -->

			<ul class="center_btns">
				<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
				    <li><p class="btn_blue2 big">
						<a href="#" id="generate" id="generate"><spring:message code='commission.button.generate'/></a>
					</p></li>
                </c:if>
				<li><p class="btn_blue2 big">
						<a href="#" id="clear" name="clear"><spring:message code='sys.btn.clear'/></a>
					</p></li>
			</ul>
<!-- Self Bill file section start -->
		<aside class="title_line">
		<h3>SelfBill Raw File(s)</h3>
		</aside><!-- title_line end -->

		<table class="type1"><!-- table start -->
		<caption>table</caption>
		<colgroup>
		    <col style="width:130px" />
		    <col style="width:*" />
		</colgroup>
		<tbody>
		<tr>
		    <th scope="row">Raw Type</th>
		    <td>
		    <select class="w100p" id="cbfinance" name="cbfinance">
		    </select>
		    </td>
		</tr>
		</tbody>
		</table>
		<article class="grid_wrap"><!-- grid_wrap start -->
		<div id="grid_wrap2" style="width:100%; height:290px; margin:0 auto;"></div>
		</article>
<!-- Self Bill file section end -->
		</form>
	</section>
</section>
<!-- search_table end -->
<!-- content end -->
<form name="reportForm" id="reportForm" method="post"></form>