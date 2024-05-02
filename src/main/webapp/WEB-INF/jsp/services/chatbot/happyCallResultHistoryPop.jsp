<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

	var happyCallResulthHistGridId;
	var myHappyCallData = ${happyCallResultHistoryList};
	var userDefine1 = "${userDefine1}";
	var userPrint = "${userPrint}";

	var happyCallResultHistColumnLayout = [{
		dataField : "transactionId",
        headerText : "Transaction ID",
        visible: false
	}, {
		dataField : "salesOrdNo",
	    headerText : "Order No."
	}, {
        dataField : "refNo",
        headerText : "Ref No."
	}, {
        dataField : "custName",
        headerText : "Customer Name"
	}, {
        dataField : "hcTypeDesc",
        headerText : "HC Type"
	}, {
        dataField : "custTypeDesc",
        headerText : "Customer Type"
	}, {
        dataField : "stockDesc",
        headerText : "Product & Category"
	}, {
        dataField : "appTypeDesc",
        headerText : "Application Type"
	}, {
        dataField : "memCode",
        headerText : "Member Code"
	}, {
        dataField : "memName",
        headerText : "Member"
	}, {
		dataField : "orgCode",
        headerText : "Organization Code"
	},{
		dataField : "grpCode",
        headerText : "Group Code"
	}, {
		dataField : "deptCode",
        headerText : "Department"
	}, {
		dataField : "statSendDt",
        headerText : "Date"
    }, {
	    dataField : "satisfaction",
	    headerText : "Satisfaction (%)"
	}, {
        dataField : "ratings",
        headerText : "Ratings",
        visible : false
    }, {
        dataField : "comm",
        headerText : "Comment"
    }];

	var happyCallResultHistGridPros = {
	    usePaging : true,
	    pageRowCount : 40,
	    selectionMode : "singleCell",
	    showRowCheckColumn : false,
	    showRowAllCheckBox : false
	};


	$(document).ready(function () {
		console.log("hi");
		happyCallResulthHistGridId = AUIGrid.create("#grid_wrap_happyCallHist", happyCallResultHistColumnLayout, happyCallResultHistGridPros);
		AUIGrid.setGridData(happyCallResulthHistGridId, myHappyCallData);

		// Show / Hide Rating Column[s]
		if(userDefine1 == "Y"){
			AUIGrid.showColumnByDataField(happyCallResulthHistGridId, "ratings");
		}else {
            AUIGrid.hideColumnByDataField(happyCallResulthHistGridId, "ratings");
        }

		// Show / Hide Rating Column[e]

		$('#excelDown').click(function() {
		       GridCommon.exportTo("grid_wrap_happyCallHist", 'xlsx', "Survey Listing History");
		    });

		$('#closeBtn').click(function() {
			$("#selectedMemCode").val("");
			$("#selectedDeptCode").val("");
			$("#selectedGrpCode").val("");
			$("#selectedOrgCode").val("");
		});
	});

	function fn_excelDown(){

	    AUIGrid.exportToXlsx(grid_wrap_happyCallHist);
	}

	/* function fn_selectHappyCallResultHistList() {
        Common.ajax("GET", "/services/chatbot/selectHappyCallResultHistList.do", $("#searchForm").serialize(), function(result) {
            console.log(result);
            AUIGrid.setGridData(happyCallResulthHistGridId, result);
        });
    } */

	/* function fn_clear() {
	    $("#agentCode").val("");

	} */

</script>


<div id="popup_wrap_selectOrgToRejoin" class="popup_wrap size_big"><!-- popup_wrap start -->
    <header class="pop_header"><!-- pop_header start -->
    <h1>SURVEY LISTING - HISTORY</h1>
    <ul class="right_opt">
            <c:if test="${userPrint == 'Y'}">
	            <li>
	                <p class="btn_blue2"><a href="#" id="excelDown">Generate</a></p>
	            </li>
            </c:if>
            <li><p class="btn_blue2"><a href="#" id="closeBtn">CLOSE</a></p></li>
    </ul>
    </header><!-- pop_header end -->

    <section class="pop_body"><!-- pop_body start -->
        <article class="grid_wrap">
        <div id="grid_wrap_happyCallHist" style="width: 100%; height: 90%; margin: 0 auto;"></div>
    </article>
    </section><!-- pop_body end -->

</div><!-- popup_wrap end -->