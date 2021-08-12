<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script type="text/javaScript">
var myGridID, bulkInvcGrid;

//Grid에서 선택된 RowID
var selectedGridValue;

$(document).ready(function(){
    myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
    AUIGrid.setSelectionMode(myGridID, "singleRow");

    // Master Grid 셀 클릭시 이벤트
    AUIGrid.bind(myGridID, "cellClick", function( event ){
        selectedGridValue = event.rowIndex;
    });

    var curDate = new Date();

    fn_setYearList(curDate.getFullYear()-10, curDate.getFullYear());
    fn_setMonthList();

});

var gridPros = {
        editable: false,
        showStateColumn: false,
        pageRowCount : 20
};

var columnLayout=[
    {dataField:"invcId", headerText:"<spring:message code='pay.head.taskId'/>", width : 80},
    {dataField:"custName", headerText:"<spring:message code='pay.head.custName'/>", width : 150},
    {dataField:"custEmail", headerText:"<spring:message code='pay.head.email'/>" , width : 150},
    {dataField:"invcDate", headerText:"<spring:message code='pay.head.invoiceDate'/>" , width : 100},
    {dataField:"currCharg", headerText:"<spring:message code='pay.head.currcharges'/>", width : 150},
    {dataField:"prevBal", headerText:"<spring:message code='pay.head.prevBal'/>", width : 150},
    {dataField:"totOut", headerText:"<spring:message code='pay.head.totOut'/>", width : 150},
    {dataField:"virtualAcc", headerText:"<spring:message code='pay.head.virtualacc'/>",width : 150},
    {dataField:"invcNo", headerText:"<spring:message code='pay.head.invoiceNo'/>",width : 150},
    {dataField:"billCode", headerText:"<spring:message code='pay.head.billCode'/>",width : 80},
    {dataField:"refNo1", headerText:"<spring:message code='pay.head.ref1'/>",width : 80},
    {dataField:"refNo2", headerText:"<spring:message code='pay.head.ref2'/>",width : 150},
    {dataField:"cowayEmail", headerText:"<spring:message code='pay.head.cowayemail'/>",width : 150}
];

var uploadItemLayout = [
    {dataField : "batchSeq", headerText : "Doc No", width : "10%"},
    {dataField : "invcNo", headerText : "Invoice No", width : "20%", visible : true}
    ];

var gridoptions = {
    showStateColumn : false,
    editable : false,
    pageRowCount : 10,
    usePaging : true,
    showPageRowSelect : true,
    showRowNumColumn : false,
    setColumnSizeList : true
};


	function fn_setYearList(startYear, endYear) {
		$("#year").append("<option value='' disabled selected hidden>issueYear</option>");
		for (var i = startYear; i <= endYear + 1; i++) {
			$("#year").append("<option value="+i +">" + i + "</option>");
		}
	}

	function fn_setMonthList() {
		$("#month").append("<option value='' disabled selected hidden>issueMonth</option>");
		for (var i = 1; i < 13; i++) {
			$("#month").append("<option value="+i +">" + i + "</option>");
		}
	}

	function validRequiredField() {

		var valid = true;
		var message = "";

		if ($("#year").val() == null || $("#year").val().length == 0) {
			valid = false;
			message += 'Please select the issue Year.|!|';
		}

		if ($("#month").val() == null || $("#month").val().length == 0) {
			valid = false;
			message += 'Please select the issue Month.|!|';
		}

		if (valid == false) {
			Common.alert('<spring:message code="sal.alert.title.warning" />' + DEFAULT_DELIMITER + message);

		}

		return valid;
	}

	function fn_geteStatementList() {
		if (validRequiredField() == true) {
			Common.ajax("GET", "/payment/selecteStatementRawList.do", $("#searchForm").serialize(), function(result) {
				AUIGrid.setGridData(myGridID, result);
				selectedGridValue = undefined;
			});
		} else {
			return false;
		}
	}


	function fn_generateCSVFormat() {
		var date = new Date().getDate();
        if (date.toString().length == 1) {
            date = "0" + date;
        }

        var reportDownFileName = "EStatement_Invoice_" + date + (new Date().getMonth() + 1) + new Date().getFullYear();

        GridCommon.exportTo("grid_wrap", 'csv', reportDownFileName);
	}

	function fn_UploadBatchPop() {
		$("#new_wrap").show();
		$("#bulkFilesUploadRow").show();
        $("#uploadContent").hide();
        $("#submitBtn").hide();
        $("#bulkGenDtls").hide();
	}

	function fn_resultFileUp() {
        var formData = new FormData();
        formData.append("csvFile", $("input[name=fileSelector]")[0].files[0]);
        formData.append("currSeq", $("#batchInvcSeq").val());

        if ($("#fileSelector").val() == null || $("#fileSelector").val().length == 0) {
        	Common.alert('<spring:message code="sal.alert.title.warning" />' + " Please select a csv file.");
        } else {
        	//Ajax 호출
            Common.ajaxFile("/payment/processBulkBatch.do", formData, function(
                    result) {
                var message = "";

                if (result.code == 99) {
                    Common.alert(result.message);

                } else {

                    Common.confirm(result.message, function(result2) {
                        $("#batchInvcSeq").val(result.data);

                        // Retrieve uploaded content results
                        Common.ajax("GET", "/payment/uploadResultList", {
                            seq : $("#batchInvcSeq").val()
                        }, function(result2) {
                            console.log(result2);

                            if (bulkInvcGrid == null) {
                                bulkInvcGrid = GridCommon.createAUIGrid(
                                        "#bulkInvcUp_grid_wrap", uploadItemLayout,
                                        null, gridoptions);
                            }

                            AUIGrid.setGridData(bulkInvcGrid, result2.resultList);
                            AUIGrid.resize(bulkInvcGrid, 1140, 350);

                            // Display content result
                            $("#uploadContent").show();
                            $("#bulkInvcUp_grid_wrap").show();
                            $("#submitBtn").show();
                            $("#uploadBtn").hide();
                            $("#batchID").text($("#batchInvcSeq").val());

                            console.log("uploadResultList :: batchInvcSeq :: "+ $("#batchInvcSeq").val());
                        });
                    });
                }
            }, function(jqXHR, textStatus, errorThrown) {
                try {
                    console.log("status : " + jqXHR.status);
                    console.log("code : " + jqXHR.responseJSON.code);
                    console.log("message : " + jqXHR.responseJSON.message);
                    console.log("detailMessage : "
                            + jqXHR.responseJSON.detailMessage);
                } catch (e) {
                    console.log(e);
                }
                alert("Fail : " + jqXHR.responseJSON.message);
            });
        }
    }

	function fn_Submit() {

		console.log("fn_submit");

		Common.confirm("Do you wish to proceed with the uploads??", function() {

			Common.ajax("GET", "/payment/selecteStatementRawListbyBatch.do", $("#form_newBulkInvoice").serialize(), function(result) {
				console.log(result);

				 fn_closeUpload();

                AUIGrid.setGridData(myGridID, result);
                selectedGridValue = undefined;
            });
		});
	}

	function fn_closeUpload() {
        console.log("close");
        AUIGrid.destroy("#bulkInvcUp_grid_wrap");
        bulkInvcGrid = null;

        $('#new_wrap').hide();
    }

</script>

<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    </ul>

	<!-- title_line start -->
	<aside class="title_line">
	    <p class="fav"><a href="javascript:;" class="click_add_on"><spring:message code='pay.text.myMenu'/></a></p>
	    <h2>Monthly E-Statement Raw Data</h2>
	    <ul class="right_btns">
	        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
	        <li><p class="btn_blue"><a href="javascript:fn_generateCSVFormat()"><spring:message code='pay.btn.downloadCsvFormat'/></a></p></li>
	        </c:if>
	        <c:if test="${PAGE_AUTH.funcView == 'Y'}">
	        <li><p class="btn_blue"><a href="javascript:fn_geteStatementList();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
	        <li><p class="btn_blue"><a href="#" onclick="javascript:fn_UploadBatchPop()">Upload Batch File</a></p></li>
	        </c:if>
	    </ul>
	</aside>
	<!-- title_line end -->


	<!-- search_table start -->
	<section class="search_table">
	    <form name="searchForm" id="searchForm"  method="post" action="#">
	    <input type="hidden" id="reportFileName" name="reportFileName" />
	    <input type="hidden" id="viewType" name="viewType" />
	    <input type="hidden" id="V_YEAR" name="V_YEAR" />
	    <input type="hidden" id="V_MONTH" name="V_MONTH" />
	    <input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL" />
	    <input type="hidden" id="V_WHERESQL" name="V_WHERESQL" />
	    <input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" />
	    <input type="hidden" id="V_FULLSQL" name="V_FULLSQL" />
	    <input type="hidden" id="reportDownFileName" name="reportDownFileName" />

	        <table class="type1"><!-- table start -->
				<caption>table</caption>
				<colgroup>
					<col style="width:144px" />
					<col style="width:200px" />
					<col style="width:144px" />
					<col style="width:200px" />
					<col style="width:*" />
				</colgroup>
		        <tbody>
		            <tr>
		                <th scope="row">Year</th>
		                <td>
		                    <select id="year" name="year" class="w100p"></select>
		                </td>
		                <th scope="row">Month</th>
		                <td>
		                   <select id="month" name="month" class="w100p"></select>
		                </td>
		                <td></td>
		            </tr>
		         </tbody>
	       </table>
	   </form>
    </section>

	<!-- search_result start -->
	<section class="search_result">
        <!-- grid_wrap start -->
		<article id="grid_wrap" style="height:500px" class="grid_wrap"></article>
		<!-- grid_wrap end -->
	</section>
</section>

<!-- popup_wrap end -->

<!-------------------------------------------------------------------------------------
    POP-UP (BULK INVOICES UPLOAD)
-------------------------------------------------------------------------------------->
<!-- popup_wrap start -->
<div class="popup_wrap size_big" id="new_wrap" style="display: none;">
    <!-- pop_header start -->
    <header class="pop_header" id="pop_header">
        <h1 id="new_pop_header">Bulk Invoices No Upload</h1>
        <ul class="right_opt">
            <li>
                <p class="btn_blue2">
                    <a href="#" onclick="javascript:fn_closeUpload()"><spring:message code="sys.btn.close" /></a>
                </p>
            </li>
        </ul>
    </header>
    <!-- pop_header end -->

    <!-- pop_body start -->
    <section class="pop_body">
        <section class="search_table">
            <!-- table start -->
            <form action="#" method="post" enctype="multipart/form-data" id="form_newBulkInvoice">
            <input type="hidden" id="batchInvcSeq" name="batchInvcSeq" value="" />
                <table class="type1">
                    <caption>table</caption>
                    <colgroup>
                        <col style="width: 200" />
                        <col style="width: *" />
                    </colgroup>
                    <tbody>
                        <tr id="bulkFilesUploadRow">
                            <th scope="row" id="invcFile">Batch File</th>
                            <td>
                                <!-- auto_file start -->
                                <div class="auto_file w100p" id="batchFileSelector">
                                    <input type="file" id="fileSelector" name="fileSelector" title="file add" accept=".csv" />
                                </div>
                                <!-- auto_file end -->
                            </td>
                        </tr>
                    </tbody>
                </table>
            </form>
            <!-- table end -->
        </section>

        <!-- table start -->
        <!-- grid_wrap start -->
        <div id="uploadContent">
            <aside class="title_line"><!-- title_line start -->
                <header class="pop_header" id="pop_header">
                    <h1>Bulk Invoices No Upload Content</h1>
                </header>
            </aside><!-- title_line end -->
            <aside class="title_line"><!-- title_line start -->
                <h2 class="total_text">Batch ID: <span id="batchID"></span></h2>
            </aside><!-- title_line end -->
            <table class="type1">
                <caption>table</caption>
                <tbody>
                    <tr>
                        <td colspan='5'>
                            <div id="bulkInvcUp_grid_wrap" style="width: 100%; height: 350px; margin: 0 auto; display: none"></div>
                        </td>
                    </tr>
                </tbody>
             </table>
         <!-- table end -->
         <!-- grid_wrap end -->
        </div>
    <!-- pop_body end -->

        <ul class="center_btns" id="newBulkBtns">
            <li><p class="btn_blue2"><a href="javascript:fn_resultFileUp();" id="uploadBtn">Upload</a></p></li>
            <li><p class="btn_blue2"><a href="javascript:fn_Submit();" id="submitBtn">Submit</a></p></li>
        </ul>
    </section>
</div>
<!-- popup_wrap end -->
