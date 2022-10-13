<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/moment.min.js"></script>

<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-right {
    text-align:right;
}
/* 첨부파일 버튼 스타일 재정의*/
.aui-grid-button-renderer {
     width:100%;
     padding: 4px;
 }

 .color-green-col {
 	background-color: lightgreen;
 }
</style>
<script type="text/javascript">
    var clickType = "";
    var allowancePlanId = 0;
    var crditCardSeq = 0;
    var checkRemoved = false;

    var allowanceMasterPlanGridID;
    var allowanceMasterDetailPlanGridID;

    var allowanceMasterPlanColLayout = [
        {
            dataField : "crditCardSeq",
            visible : false
        }, {
            dataField : "crditCardUserName",
            headerText : "Cardholder Name",
            width : 150
        }, {
            dataField : "crditCardNo",
            headerText : "Card No.",
            width : 150
        }, {
            dataField : "costCentr",
            headerText : "Cost Center Code",
            width : 130
        }, {
            dataField : "costCentrName",
            headerText : "Cost Center Name",
            width : 130
        }, {
            dataField : "appvCrditLimit",
            headerText : "Approve Credit Limit",
            width : 150,
            labelFunction : function( rowIndex, columnIndex, item, dataField ) {
            	if(item != null && item != ""){
                	var data = parseFloat(item).toFixed(2);
                	var creditLimitText = "RM " + data.toString().replace(/(?<!\..*)(\d)(?=(?:\d{3})+(?:\.|$))/g, '$1,');
                    return creditLimitText;
            	}
            	else{
            		return "";
            	}
            }
        }, {
            dataField : "personInChargeName",
            headerText : "Person-In-Charge Name",
            width : 150
        }, {
            dataField : "crditCardStus",
            headerText : "Card Status",
            width : 110
        },{
            dataField : "planLimitAmt",
            headerText : "Active Limit Plan",
            width : 85
        }
    ];

    var allowanceMasterPlanGridPros = {
            usePaging : true,
            showStateColumn : false
    };

    var allowanceMasterDetailPlanColLayout = [
                                        {
                                            dataField : "allowancePlanId",
                                            visible : false
                                        },{
                                            dataField : "creditCardSeq",
                                            visible : false
                                        }, {
                                            dataField : "planLimitAmt",
                                            headerText : "Limit Plan Amount",
                                            width : 150,
                                    		styleFunction : cellStyleFunction,
                                            editable:false,
                                            labelFunction : function( rowIndex, columnIndex, item, dataField) {
                                            	if(item != null && item != ""){
                                                	var data = parseFloat(item).toFixed(2);
                                                	var creditLimitText = "RM " + data.toString().replace(/(?<!\..*)(\d)(?=(?:\d{3})+(?:\.|$))/g, '$1,');
                                                    return creditLimitText;
                                            	}
                                            	else{
                                            		return "";
                                            	}
                                            }
                                        }, {
                                            dataField : "startDate",
                                            headerText : "Card Start Date",
                                            width : 200,
                                    		styleFunction : cellStyleFunction,
                                            editable:false,
                                            labelFunction : function( rowIndex, columnIndex, item, dataField ) {
                                            	if(item != null && item != ""){
                                                	var date = new Date(item);
                                                	return moment(date).format('DD/MM/YYYY HH:mm:ss');
                                            	}
                                            	else{
                                            		return "";
                                            	}
                                            }
                                        }, {
                                            dataField : "endDate",
                                            headerText : "Card End Date",
                                            width : 200,
                                    		styleFunction : cellStyleFunction,
                                            editable:false,
                                            labelFunction : function( rowIndex, columnIndex, item, dataField ) {
                                            	if(item != null && item != ""){
                                                	var date = new Date(item);
                                                	return moment(date).format('DD/MM/YYYY HH:mm:ss');
                                            	}
                                            	else{
                                            		return "";
                                            	}
                                            }
                                        }, {
                                            dataField : "status",
                                            headerText : "Status",
                                            width : 100,
                                    		styleFunction : cellStyleFunction,
                                            editable:false
                                        }, {
                                            dataField : "remarks",
                                            headerText : "Remarks",
                                            width : 250,
                                    		styleFunction : cellStyleFunction,
                                            editable:true
                                        },{
                                            dataField : "",
                                            headerText : "",
                                            width : 80,
                                            editable:false,
                                            renderer : {
                                                    type : "ButtonRenderer",
                                                    labelText : "Edit",
                                                    onclick : function(rowIndex, columnIndex, value, item) {
                                                    	fn_editAllowance(item.allowancePlanId);
                                                    }
                                             }
                                        },{
                                            dataField : "",
                                            headerText : "",
                                            width : 100,
                                            editable:false,
                                            renderer : {
                                                    type : "ButtonRenderer",
                                                    labelText : "Remove",
                                                    onclick : function(rowIndex, columnIndex, value, item) {
                                                    	var confirmSaveMsg = "Are you sure want to Delete? Please fill in remarks message if you have not do it.";
                                                        Common.confirm(confirmSaveMsg, x=function() {
                                                        	if(undefinedCheck(item.remarks) == ""){
                                                        		Common.alert("Please fill in remarks before remove");
                                                        		return false;
                                                        	}
                                                        	fn_removeAllowancePlanLimitDetail(item.allowancePlanId, item.remarks);
                                                        });
                                                    }
                                             }
                                        }
                                    ];

    var allowanceMasterDetailPlanGridPros = {
            usePaging : true,
            showStateColumn : false,
            editable:true
    };

    $(document).ready(function () {
        console.log("crcAllowanceMasterPlan.jsp");
        allowanceMasterPlanGridID = AUIGrid.create("#allowanceMasterPlan_grid_wrap", allowanceMasterPlanColLayout, allowanceMasterPlanGridPros);
        allowanceMasterPlanDetailGridID = AUIGrid.create("#allowanceMasterDetailPlan_grid_wrap", allowanceMasterDetailPlanColLayout, allowanceMasterDetailPlanGridPros);

        multiCombo();

        AUIGrid.bind(allowanceMasterPlanGridID, "cellDoubleClick", function(event) {
            $('#creditCardHolderSelected').text('');
            $('#creditCardHolderCardNumberSelected').text('');
            var colIndex = event.columnIndex;
            crditCardSeq = event.item.crditCardSeq;

            $('#creditCardHolderSelected').text(event.item.crditCardUserName);
            $('#creditCardHolderCardNumberSelected').text(event.item.crditCardNo);
            fn_getAllowancePlanLimitDetailList();
        });
        AUIGrid.bind(allowanceMasterDetailPlanGridID, "cellDoubleClick", function(event) {
            var colIndex = event.columnIndex;
            allowancePlanId = event.item.allowancePlanId;
            Common.popupDiv("/eAccounting/creditCardAllowancePlan/crcAllowanceMasterPlanEditPop.do", {allowancePlanId : allowancePlanId}, null, true, "crcAllowanceMasterPlanAddPop");
        });
    });

    function cellStyleFunction(rowIndex, columnIndex, value, headerText, item, dataField){
        var dateToday = new Date();
        if(new Date(item.startDate) <= dateToday && dateToday <= new Date(item.endDate) ){
            return "color-green-col";
        }
        return "";
    }

    function fn_getCreditCardHolderList() {
        Common.ajax("GET", "/eAccounting/creditCardAllowancePlan/getCreditCardHolderList.do", $("#allowanceForm").serialize(), function(result) {
            console.log(result);
            AUIGrid.setGridData(allowanceMasterPlanGridID, result);
        });
    }

    function fn_getAllowancePlanLimitDetailList(){
    	 Common.ajax("GET", "/eAccounting/creditCardAllowancePlan/getAllowanceLimitDetailPlanList.do", {creditCardSeq: crditCardSeq}, function(result) {
             console.log(result);
             AUIGrid.setGridData(allowanceMasterPlanDetailGridID, result);
         });
    }

    function fn_removeAllowancePlanLimitDetail(id, remarks){
   	 Common.ajax("POST", "/eAccounting/creditCardAllowancePlan/removeAllowanceLimitDetailPlan.do", {allowancePlanId: id, remarks: remarks, creditCardSeq: crditCardSeq}, function(result) {
   		 if(result.code == "00"){
    			fn_getAllowancePlanLimitDetailList();
   		 }
   		 else{
   			 Common.alert(result.message);
   		 }
     });
   }

    function fn_addAllowance(){
    	if(crditCardSeq > 0){
    		Common.popupDiv("/eAccounting/creditCardAllowancePlan/crcAllowanceMasterPlanAddPop.do", {creditCardSeq : crditCardSeq}, null, true, "crcAllowanceMasterPlanAddPop");
    	}
    	else{
            Common.alert("Please select a card holder");
            return false;
    	}
    }

    function fn_editAllowance(id){
    	if(crditCardSeq > 0){
    		Common.popupDiv("/eAccounting/creditCardAllowancePlan/crcAllowanceMasterPlanEditPop.do", {allowancePlanId : id, creditCardSeq: crditCardSeq}, null, true, "crcAllowanceMasterPlanEditPop");
    	}
    	else{
            Common.alert("Please select a limit plan");
            return false;
    	}
    }

    function fn_setGridData(gridId, data) {
        console.log(data);
        AUIGrid.setGridData(gridId, data);
    }

    function fn_excelDown() {
        console.log("fn_excelDown");
        GridCommon.exportTo("allowanceMasterPlan_grid_wrap", "xlsx", "AllowanceMasterPlan");
    }

    function fn_excelDownDetail() {
        console.log("fn_excelDown");
        GridCommon.exportTo("allowanceMasterDetailPlan_grid_wrap", "xlsx", "AllowanceMasterPlanDetail");
    }

    function multiCombo() {
        $(function() {
            $('#crditCardStus').change(function() {
            }).multipleSelect({
                selectAll : true, // 전체선택
                width : '80%'
            }).multipleSelect("checkAll");
        });
    }

    function undefinedCheck(value, type){
    	var retVal;

    	if (value == undefined || value == "undefined" || value == null || value == "null" || $.trim(value).length == 0) {
    		if (type && type == "number") {
    			retVal = 0;
    		} else {
    			retVal = "";
    		}
    	} else {
    		if (type && type == "number") {
    			retVal = Number(value);
    		}else{
    			retVal = value;
    		}
    	}

    	return retVal;
    }
</script>

<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    </ul>

    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on"><spring:message code="webInvoice.fav" /></a></p>
        <h2>Allowance Limit Master Plan</h2>
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="#" onclick="javascript:fn_getCreditCardHolderList()"><span class="search"></span><spring:message code="webInvoice.btn.search" /></a></p></li>
        </ul>
    </aside>

    <section class="search_table">
        <form action="#" method="post" id="allowanceForm">
            <input type="hidden" id="crditCardUserId" name="crditCardUserId">
            <input type="hidden" id="chrgUserId" name="chrgUserId">
            <input type="hidden" id="costCenterText" name="costCentrName">

            <table class="type1">
                <caption><spring:message code="webInvoice.table" /></caption>
                <colgroup>
                    <col style="width:170px" />
                    <col style="width:*" />
                    <col style="width:210px" />
                    <col style="width:*" />
                </colgroup>

                <tbody>
                    <tr>
                        <th scope="row">Credit Cardholder Name</th>
                        <td>
                            <p class=""><input type="text" id="crditCardUserName" name="crditCardUserName" title="" placeholder="" class="w100p" value="" /></p>
                        </td>
                        <th scope="row">Credit Card Number</th>
                        <td>
                            <p class=""><input type="text" id="crditCardNumber" name="crditCardNumber" title="" placeholder="" class="w100p" value="" /></p>
                        </td>
                    </tr>
                    <tr>
                    	<th scope="row">Credit Cardholder User Name</th>
                        <td>
                            <p class=""><input type="text" id="crditCardMemCode" name="crditCardMemCode" title="" placeholder="" class="w100p" value="" /></p>
                        </td>
                        <th scope="row">Person-In-Charge Name</th>
                        <td>
                            <p class=""><input type="text" id="picMemCode" name="picMemCode" title="" placeholder="" class="w100p" value="" /></p>
                        </td>
                    </tr>
                    <tr>
                    	<th scope="row"><spring:message code="webInvoice.status" /></th>
						<td>
							<select class="multy_select" multiple="multiple" id="crditCardStus" name="crditCardStus">
								<option value="A"> <spring:message code="crditCardMgmt.active" /></option>
								<option value="R"> <spring:message code="crditCardMgmt.removed" /></option>
							</select>
						</td>
						<th scope="row"></th>
						<td></td>
                    </tr>
                </tbody>
            </table>
        </form>
    </section>

    <ul class="right_btns">
        <li><p class="btn_grid"><a href="javascript:fn_excelDown();">GENERATE</a></p></li>
    </ul>

    <section class="search_result">
        <article class="grid_wrap" id="allowanceMasterPlan_grid_wrap"></article>
        <div>
			<ul class="right_btns">
	            <li><p class="btn_blue"><a href="#" onclick="javascript:fn_addAllowance()">New Limit Plan</a></p></li>
        		<li><p class="btn_grid"><a href="javascript:fn_excelDownDetail();">GENERATE</a></p></li>
	         </ul>
        	<div style="color:darkgreen;">Current selected credit card holder : <span id="creditCardHolderSelected"></span></div>
        	<div style="color:darkgreen; margin-bottom:5px;">Current selected credit card number : <span id="creditCardHolderCardNumberSelected"></span></div>
        	<div style="color:green;">*Highlighted Green indicates currently active limit plan</div>
        </div>

        <article class="grid_wrap" id="allowanceMasterDetailPlan_grid_wrap"></article>
    </section>

</section>