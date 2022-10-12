<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<div id="popup_wrap" class="popup_wrap">
    <header class="pop_header">
        <h1>
            <c:choose>
                <c:when test="${type == 0}">
                    <spring:message code="sal.title.text.summaryDailyCollectionReport" />
                </c:when>
                <c:otherwise>
                    <spring:message code="sal.title.text.dailyCollectionOrderReport" />
                </c:otherwise>
            </c:choose>
        </h1>
        <ul class="right_opt">
            <li>
                <p class="btn_blue2">
                    <a href="#" id="_AddPopclose">
                        <spring:message code="sal.btn.close" />
                    </a>
                </p>
            </li>
        </ul>
    </header>
    <section class="pop_body">
        <form id="summaryForm">
	        <table class="type1">
	            <colgroup>
	                <col style="width: 20%" />
	                <col style="width: *" />
	                <col style="width: 20%" />
	                <col style="width: *" />
	            </colgroup>
	            <tbody>
	                <tr>
	                    <th scope="row">Agent Type</th>
	                    <td>
		    			    <select id="agentType" name="agentType" class="multy_select" multiple="multiple"></select>
	                    </td>
	                    <th scope="row">Assign Status</th>
	                    <td>
						    <select id="assignStatus" name="assignStatus" class="multy_select" multiple="multiple"></select>
	                    </td>
	                </tr>
	                <tr>
	                    <th scope="row">ROS Caller</th>
	                    <td>
						    <select id="caller" name="caller" class="multy_select" multiple="multiple"></select>
	                    </td>
	                    <th scope="row">Product Category</th>
	                    <td>
						    <select id="productCat" name="productCat" class="multy_select" multiple="multiple"></select>
	                    </td>
	                </tr>
	                <tr>
	                    <th scope="row">Trx Date</th>
	                    <td>
	                        <div class="date_set w100p">
	                            <p><input id="startDt" name="startDt" type="text" placeholder="DD/MM/YYYY" class="j_date" autocomplete="off" /></p>
	                            <span>To</span>
	                            <p><input id="endDt" name="endDt" type="text" placeholder="DD/MM/YYYY" class="j_date" autocomplete="off" /></p>
	                        </div>
	                    </td>
	                    <th scope="row">Cust Type</th>
	                    <td>
						    <select id="custType" name="custType" class="multy_select" multiple="multiple"></select>
	                    </td>
	                </tr>
	            </tbody>
	        </table>
        </form>
        <form id="report_form">
            <input type="hidden" id="reportFileName" name="reportFileName" />
			<input type="hidden" id="viewType" name="viewType" value="EXCEL" />
			<input type="hidden" id="reportDownFileName" name="reportDownFileName"  />
            <input type="hidden" id="V_CALLER" name="V_CALLER" />
            <input type="hidden" id="V_STATUS" name="V_STATUS" />
            <input type="hidden" id="V_CUST_TYPE" name="V_CUST_TYPE" />
            <input type="hidden" id="V_PROD_CAT" name="V_PROD_CAT" />
            <input type="hidden" id="V_SDATE" name="V_SDATE" />
            <input type="hidden" id="V_EDATE" name="V_EDATE" />
        </form>
        <ul class="center_btns">
		    <li><p class="btn_blue2 big"><a onclick="javascript: fn_genReport()">Generate</a></p></li>
		</ul>
    </section>
</div>

<script>
    const type = ${type}
    const date = new Date
    let fileName
    if (type == 0) {
	    $("#reportFileName").val("/sales/summaryDailyCollect.rpt")
	    fileName = "summaryDailyCollect"
    } else {
	    $("#reportFileName").val("/sales/collectionOrderList.rpt")
	    fileName = "collectionOrderList"
    }
    $("#reportDownFileName").val(fileName + '_' + date.getFullYear() + (date.getMonth() + 1 + "").padStart(2, "0") + (date.getDate() + "").padStart(2, "0"))

	const getCaller = () => {
	    $('#caller').multipleSelect("disable")
	    CommonCombo.make("caller", "/sales/rcms/selectAgentGrpList", $('#summaryForm').serialize(), '',  {id: "agentGrpId", name: "agentGrpName",isShowChoose: false, type: "M"}, () => {
	        $('#caller').multipleSelect("enable")
	    })
	}

	$('#agentType').multipleSelect({
        onClick: getCaller,
        onCheckAll: getCaller
    })

    $('#agentType').multipleSelect("disable")
    CommonCombo.make("agentType", "/sales/rcms/selectAgentTypeList", {codeMasterId : '329'}, '',  {id: "codeId", name: "codeName",isShowChoose: false, type: "M"}, () => {
    	 $('#agentType').multipleSelect("enable")
    	 getCaller()
    })

    const setVal = (elemId, id) => {
    	$(id).val($(elemId).multipleSelect("getSelects").map(v => id == "#V_STATUS" ? "'" + v + "'" : v).join(","))
    }

    CommonCombo.make('assignStatus', "/status/selectStatusCategoryCdList.do", {selCategoryId : 26} , '', {id: "code", name: "codeName", isShowChoose: false,isCheckAll : true,type : 'M'})

    CommonCombo.make('productCat', "/common/selectCodeGroup.do", {ind : "ROS_AP_TYP"} , '', {id: "code", name: "codeName", isShowChoose: false,isCheckAll : true,type : 'M'})

    CommonCombo.make('custType', "/common/selectCodeGroup.do", {ind : "ROS_C_TYPE"} , '', {id: "code", name: "codeName", isShowChoose: false,isCheckAll : true,type : 'M'})

    $("#startDt,#endDt").change((e) => {
    	if (e.target.id == "startDt") {
    		$("#V_SDATE").val(e.target.value)
    	} else {
    		$("#V_EDATE").val(e.target.value)
    	}
    })

    $('#caller').multipleSelect({
        onClick: () => setVal("#caller", "#V_CALLER"),
        onCheckAll: () => setVal("#caller", "#V_CALLER")
    })

    $('#assignStatus').multipleSelect({
        onClick: () => setVal("#assignStatus", "#V_STATUS"),
        onCheckAll: () => setVal("#assignStatus", "#V_STATUS")
    })

    $('#productCat').multipleSelect({
        onClick: () => setVal("#productCat", "#V_PROD_CAT"),
        onCheckAll: () => setVal("#productCat", "#V_PROD_CAT")
    })

    $('#custType').multipleSelect({
         onClick: () => setVal("#custType", "#V_CUST_TYPE"),
         onCheckAll: () => setVal("#custType", "#V_CUST_TYPE")
     })

    const checkFields = () => {
    	let err = []
    	if (!$('#caller').multipleSelect("getSelects").length) err.push("Please select Callers")
    	if (!$('#assignStatus').multipleSelect("getSelects").length) err.push("Please select Assigned Status")
    	if (!$('#productCat').multipleSelect("getSelects").length) err.push("Please select Product Category")
    	if (!$('#custType').multipleSelect("getSelects").length) err.push("Please select Cust Type")
    	if (!$('#startDt').val() || !$('#endDt').val()) {
    		err.push("Please key in dates")
    	} else {
    		const startDtSplit = $('#startDt').val().split('/')
    		const endDtSplit = $('#endDt').val().split('/')
    		if (Date.UTC(startDtSplit[2], startDtSplit[1], startDtSplit[0]) > Date.UTC(endDtSplit[2], endDtSplit[1], endDtSplit[0])) {
    			err.push("Start date can't be larger than End date")
    		}
    	}
    	if (err.length) {
	    	Common.alert(err.join('<br />'))
	    	return false
    	}
    	return true
    }

    function fn_genReport() {
        if (checkFields()) {
        	Common.report("report_form", {isProcedure: true})
        }
    }
</script>