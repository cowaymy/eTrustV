<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<style type="text/css">
.my-custom-up div{
    color:#FF0000;
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

.my-row-style {
    background:#9FC93C;
    font-weight:bold;
    color:#22741C;
}

.aui-grid-link-renderer1 {
     text-decoration:underline;
     color: #4374D9 !important;
     cursor: pointer;
     text-align: right;
</style>
<script type="text/javaScript">
	//AUIGrid 그리드 객체
	var confirmRefundGridID;

	//Grid에서 선택된 RowID
	var selectedGridValue;

	//Grid Properties 설정
	var gridPros = {
	        rowIdField : "rnum",
	        editable : true,
	        headerHeight : 35,
	        //fixedColumnCount : 6,
	        //groupingFields : ["delyno"],
	        displayTreeOpen : false,
	        showRowCheckColumn : true ,
	        showStateColumn : false,
	        showBranchOnGrouping : false,
	        showRowAllCheckBox : false,

/* 	        rowCheckDisabledFunction : function(rowIndex, isChecked, item) {
	            if(item.refStusId == "A") {
	                return false;
	            }
	            return true;
	        } */
	};

	//Default Combo Data
	/* var statusData = [
	    {"codeId": "R","codeName": "Approve In-Progress"},
		{"codeId": "A","codeName": "Approved"},
		{"codeId": "J","codeName": "Rejected"}]; */

	var statusData = [
	                  {"codeId": "1","codeName": "Active"},
	                  {"codeId": "5","codeName": "Approved"},
	                  {"codeId": "6","codeName": "Rejected"}];

	// AUIGrid 칼럼 설정
	var columnLayout = [
        {
        	dataField : "rnum",
        	headerText : "<spring:message code='log.head.rownum'/>",
        	visible:false
        },{
        	dataField : "refReqId",
        	headerText : "<spring:message code='pay.head.refundRequestNo'/>",
        	width : 200 ,
        	editable : false
        },{
        	dataField : "grpSeq",
        	headerText : "<spring:message code='pay.head.paymentGroupSeq'/>",
        	width : 165 ,
        	editable : false
        },{
        	dataField : "salesOrdNo",
        	headerText : "Sales Order",
        	width : 160 ,
        	editable : false
        },{
        	dataField : "refResnNm",
        	headerText : "<spring:message code='pay.head.reason'/>",
        	width : 300 ,
        	editable : false
        },{
        	dataField : "refCrtUserNm",
        	headerText : "<spring:message code='pay.head.requestor'/>",
        	width : 150 ,
        	editable : false
        },{
        	dataField : "reqstBrnch",
        	headerText : "Branch Code<br/>(Requestor)",
        	width : 250 ,
        	editable : false
        },{
        	dataField : "refCrtDt",
        	headerText : "<spring:message code='pay.head.requestDate'/>",
        	width : 160 ,
        	editable : false,
        	dataType:"date",
        	formatString:"dd/mm/yyyy"
        },{
        	dataField : "refStusId",
        	headerText : "<spring:message code='pay.head.statusId'/>",
        	width : 100 ,
        	editable : false,
        	visible : false
        },{
        	dataField : "refStusNm",
        	headerText : "<spring:message code='pay.head.status'/>",
        	width : 140 ,
        	editable : false
        },{
        	dataField : "refAppvUserNm",
        	headerText : "Approval",
        	width : 160 ,
        	editable : false
       },{
    	   dataField: "appvStus",
    	   visible : false
       }];

	$(document).ready(function(){
		//doGetCombo('/common/selectCodeList.do', '7277' , ''   , 'reason' , 'S', '');
		doGetComboCodeId('/common/selectReasonCodeId.do', {typeId : 7277}, ''   , 'reason' , 'S', '');
		doDefCombo(statusData, '' ,'status', 'S', '');
		doGetComboSepa('/common/selectBranchCodeList.do', '1' , ' - ' , '','branchId', 'S' , '');

		$('#branchId').change(function (){
	        doGetCombo('/common/getUsersByBranch.do', $(this).val() , ''   , 'userId' , 'S', '');
	    });

		//그리드 생성
	    confirmRefundGridID = AUIGrid.create("#grid_wrap", columnLayout,gridPros);

		// Master Grid 셀 클릭시 이벤트
	    AUIGrid.bind(confirmRefundGridID, "cellClick", function( event ){
		    selectedGridValue = event.rowIndex;
		    var selRefReqId = AUIGrid.getCellValue(confirmRefundGridID, event.rowIndex, "refReqId");
		    AUIGrid.setCheckedRowsByValue(confirmRefundGridID, "refReqId", selRefReqId);

	    });

	    AUIGrid.bind(confirmRefundGridID, "rowCheckClick", function( event ) {

	       /*  var refReqId = AUIGrid.getCellValue(confirmRefundGridID, event.rowIndex, "refReqId");

	        if (AUIGrid.isCheckedRowById(confirmRefundGridID, event.item.rnum)){
	            AUIGrid.addCheckedRowsByValue(confirmRefundGridID, "refReqId" , refReqId);
	        }else{
	            var rown = AUIGrid.getRowIndexesByValue(confirmRefundGridID, "refReqId" , refReqId);

	            for (var i = 0 ; i < rown.length ; i++){
	                AUIGrid.addUncheckedRowsByIds(confirmRefundGridID, AUIGrid.getCellValue(confirmRefundGridID, rown[i], "rnum"));
	            }
	        } */

	        var selRefReqId = AUIGrid.getCellValue(confirmRefundGridID, event.rowIndex, "refReqId");
            AUIGrid.setCheckedRowsByValue(confirmRefundGridID, "refReqId", selRefReqId);
	    });

	    AUIGrid.bind(confirmRefundGridID, "refReqId", function (event){
	        if (event.dataField != "refReqId"){
	            return false;
	        }else{
	            if (AUIGrid.getCellValue(confirmRefundGridID, event.rowIndex, "refReqId") != null && AUIGrid.getCellValue(confirmRefundGridID, event.rowIndex, "refReqId") != ""){
	                Common.alert('You can not perform approval action for the selected item.');
	                return false;
	            }
	        }
	    });

	    AUIGrid.bind(confirmRefundGridID, "cellEditEnd", function (event){

            var del = AUIGrid.getCellValue(confirmRefundGridID, event.rowIndex, "refReqId");
            if (del > 0){
                    AUIGrid.addCheckedRowsByIds(confirmRefundGridID, event.item.rnum);
            }else{
            	AUIGrid.restoreEditedRows(confirmRefundGridID, "selectedIndex");
                AUIGrid.addUncheckedRowsByIds(confirmRefundGridID, event.item.rnum);
            }
	    });

	    /* AUIGrid.bind(confirmRefundGridID, "rowAllCheckClick", function( checked ) {
	        alert("Select all checked : " + checked);
	   }); */

	    AUIGrid.bind(confirmRefundGridID, "ready", function(event) {
	    });
	});

    // Search button
    function searchList(){

		/* if(FormUtil.checkReqValue($("#reqNo"))){
			if(FormUtil.checkReqValue($("#salesOrdNo")) && (FormUtil.checkReqValue($("#reqDateFr")) || FormUtil.checkReqValue($("#reqDateTo")))){
	            Common.alert("<spring:message code='pay.alert.reqDate'/>");
		        return;
			}
		} */

    	Common.ajax("POST","/payment/selectRequestRefundList.do",$("#searchForm").serializeJSON(), function(result){
    		AUIGrid.setGridData(confirmRefundGridID, result);
    	});
    }

    // Approval Refund button
    function fn_confirmRefundPop(){
        var selectedItem = AUIGrid.getCheckedRowItemsAll(confirmRefundGridID);
        var refGroupSeq = [];
        var refReqId = [];
        var refStusId = [];
        var refSalesOrdNo = [];
        var appvStus = selectedItem[0].appvStus;

        console.log("fn_confirmRefundPop " + selectedItem);
        if (selectedItem.length> 0){
        	for(var i = 0; i< selectedItem.length; i++){
        		refGroupSeq.push(selectedItem[i].grpSeq);
        		refReqId.push(selectedItem[i].refReqId);
        		refStusId.push(selectedItem[i].refStusId);
        		refSalesOrdNo.push(selectedItem[i].salesOrdNo);
        	}

        	var selectedData = {
                    "groupSeq" : JSON.stringify(refGroupSeq.join()),
                    "reqId" : selectedItem[0].refReqId,
                    "refStusId" : JSON.stringify(refStusId.join()),
                    "salesOrdNo" : JSON.stringify(refSalesOrdNo.join()),
                    "appvStus" : appvStus,
                    "reqNo" : $("#reqNo").val()
            };
        	console.log(selectedData);
            Common.popupDiv('/payment/initConfirmRefundPop.do', selectedData, null , true ,'_confirmRefundPop');

        }else{
             Common.alert("<spring:message code='pay.alert.noRefund'/>");
        }
    }

    // 화면 초기화
    function clear(){
    	//화면내 모든 form 객체 초기화
    	$("#searchForm")[0].reset();

    	//그리드 초기화
    	//AUIGrid.clearGridData(myGridID);
    }

	function fn_genRefundRawPop() {
		doGetComboCodeId('/common/selectReasonCodeId.do', {typeId : 7277}, ''   , 'cmbReason' , 'S', '');
		//doGetCombo('/common/selectCodeList.do', '392' , ''   , 'cmbReason' , 'S', '');
	    doDefCombo(statusData, '' ,'cmbStatus', 'S', '');
	    doGetComboSepa('/common/selectBranchCodeList.do', '1' , ' - ' , '','cmbBranch', 'S' , '');

	    $('#popup_wrap').show();
	}

	function fn_generateReport(){

	    var d1Array = $("#requestDateFr").val().split("/");
	    var d1 = new Date(d1Array[2] + "-" + d1Array[1] + "-" + d1Array[0]);
	    var d2Array = $("#requestDateTo").val().split("/");
	    var d2 = new Date(d2Array[2] + "-" + d2Array[1] + "-" + d2Array[0]);

	    var whereSQL = '';

	    if(dayDiffs(d1,d2) <= 30) {
	        if($("#requestDateFr").val() != "") {
	            whereSQL += " AND Extent1.CRT_DT >= TO_DATE('" + $("#requestDateFr").val() + "', 'DD/MM/YYYY') ";
	        } else {
	            Common.alert("Please fill in request from date.");
	            return;
	        }

	        if($("#requestDateTo").val() != "") {
	            whereSQL += " AND Extent1.CRT_DT < TO_DATE('" + $("#requestDateTo").val() + "', 'DD/MM/YYYY') + 1";
	        } else {
	            Common.alert("Please fill in request to date.");
	            return;
	        }

	        if($("#cmbReason").val() != "")
	            whereSQL += " AND Extent1.REASON_ID = " + $("#cmbReason").val() ;

	        if($("#cmbStatus").val() != "")
	            whereSQL += " AND Extent1.DCF_STUS_ID = " + $("#cmbStatus").val() ;

	        if($("#cmbBranch").val() != "")
	            whereSQL += " AND B.STUS_CODE_ID = " + $("#cmbBranch").val() ;

	        if($("#approvalDateFr").val() != "")
	            whereSQL += " AND DT.APPV_DT >= TO_DATE('" + $("#approvalDateFr").val() + "', 'DD/MM/YYYY') ";

	        if($("#approvalDateFr").val() != "")
	            whereSQL += " AND DT.APPV_DT < TO_DATE('" + $("#approvalDateFr").val() + "', 'DD/MM/YYYY') + 1";

	        var date = new Date().getDate();
	        if(date.toString().length == 1){
	            date = "0" + date;
	        }

	        $("#reportForm #reportDownFileName").val("Refund_AdjustmentRaw_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
	        $("#reportForm #v_WhereSQL").val(whereSQL);
	        $("#reportForm #viewType").val("EXCEL");
	        $("#reportForm #reportFileName").val("/payment/PaymentRefundAdjustRaw.rpt");

	        var option = {
	                isProcedure : true
	        };

	        Common.report("reportForm", option);
	    } else {
	        Common.alert("Date range must be or equal to 30 days.");
	    }
	}


	function dayDiffs(dayFr, dayTo){
	    return Math.floor((dayTo.getTime() - dayFr.getTime())  /(1000 * 60 * 60 * 24));
	}

	function fn_close(){
		$("#reportForm")[0].reset();
		$("#popup_wrap").hide();
	}

</script>
<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on"><spring:message code='pay.text.myMenu'/></a></p>
        <h2>Confirm Refund</h2>
        <ul class="right_btns">
           <c:if test="${PAGE_AUTH.funcView == 'Y'}">
            <li><p class="btn_blue"><a href="javascript:searchList();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
           </c:if>
            <li><p class="btn_blue"><a href="javascript:clear();"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
        </ul>
    </aside>
    <!-- title_line end -->

    <!-- search_table start -->
    <section class="search_table">
        <!-- search_table start -->
        <form id="searchForm" action="#" method="post">
            <input type="hidden" name="ordId" id="ordId" />
            <input type="hidden" id="pageAuthFuncUserDefine4" name="pageAuthFuncUserDefine4" value="${PAGE_AUTH.funcUserDefine4}">
            <table class="type1">
                <caption>table</caption>
                <colgroup>
                    <col style="width:180px" />
                    <col style="width:*" />
                    <col style="width:180px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
						<th scope="row">Refund Request No</th>
                        <td>
                            <input type="text" id="reqNo" name="reqNo" value="${reqNo}" class="w100p" />
                        </td>

					    <th scope="row">Request Date</th>
                        <td>
                            <!-- date_set start -->
                            <div class="date_set w100p">
                            <p><input type="text" id="reqDateFr" name="reqDateFr" title="Request Start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                            <span>To</span>
                            <p><input type="text" id="reqDateTo" name="reqDateTo" title="Request End Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                            </div>
                            <!-- date_set end -->
                        </td>
                    </tr>
					<tr>
						<th scope="row">Reason</th>
                        <td>
							<select id="reason" name="reason" class="w100p"></select>
                        </td>

					    <th scope="row">Status</th>
                        <td>
							<select id="status" name="status" class="w100p"></select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row"><spring:message code='sales.OrderNo'/></th>
                        <td>
                            <input id="salesOrdNo" name="salesOrdNo" type="text" title="Order No" placeholder="<spring:message code='sales.OrderNo'/>" class="w100p" />
                        </td>
                        <th scope="row">Branch Code</th>
                        <td>
                               <select id="branchId" name="branchId" class="w100p"></select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Requestor</th>
                        <td>
                           <select id="userId" name="userId" class="w100p">
                           </select>
                        </td>
                    </tr>
                </tbody>
            </table>
            <!-- table end -->
        </form>
    </section>
    <!-- search_table end -->

	<!-- link_btns_wrap start -->
	<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
	<aside class="link_btns_wrap">
		<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
		<dl class="link_list">
			<dt>Link</dt>
			<dd>

				<ul class="btns">
					<c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
					<li><p class="link_btn"><a href="javascript:fn_confirmRefundPop();">Approval Refund</a></p></li>
					</c:if>

					<c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
					<li><p class="link_btn"><a href="javascript:fn_genRefundRawPop();">Generate Refund Adjustment Raw</a></p></li>
					</c:if>
				</ul>

				<p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
			</dd>
		</dl>
	</aside>
	</c:if>
	<!-- link_btns_wrap end -->

    <!-- search_result start -->
    <section class="search_result">
        <!-- grid_wrap start -->
        <!-- <article id="grid_wrap" class="mt10" style="height:450px"></article> -->
        <div id="grid_wrap" class="mt10" style="height:780px"></div>
        <!-- grid_wrap end -->
    </section>
    <!-- search_result end -->

</section>
<!-- content end -->

<div id="popup_wrap" class="popup_wrap" style="display:none"><!-- popup_wrap start -->
<section id="content"><!-- content start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Refund Adjustment Report</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" onclick="javascript:fn_close();" >CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form name="reportForm" id="reportForm" action="#" method="post">
<input type="hidden" id="reportFileName" name="reportFileName" value="" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />
<input type="hidden" id="viewType" name="viewType" value="" />
<input type="hidden" id="v_WhereSQL" name="v_WhereSQL" value="" />

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th><spring:message code='pay.head.requestDate'/></th>
    <td>
        <div class="date_set w100p">
            <p><input type="text" class="j_date" readonly id="requestDateFr" name="requestDateFr" placeholder="DD/MM/YYYY"/></p>
            <span>To</span>
            <p><input type="text" class="j_date" readonly id="requestDateTo" name="requestDateTo" placeholder="DD/MM/YYYY"/></p>
        </div>
    </td>
    <th scope="row">Branch Code</th>
    <td><select class="w100p" id="cmbBranch" name="cmbBranch"></select></td>
</tr>
<tr>
    <th scope="row">Reason</th>
    <td><select class="w100p" id="cmbReason" name="cmbReason"></select></td>
    <th scope="row">Status</th>
    <td><select class="w100p" id="cmbStatus" name="cmbStatus"></select></td>
</tr>
<tr>
    <th scope="row">Approval Date</th>
    <td>
        <div class="date_set w100p">
            <p><input type="text" id="approvalDateFr" name="approvalDateFr" placeholder="DD/MM/YYYY" class="j_date" readonly/></p>
            <span>To</span>
            <p><input type="text" id="approvalDateTo" name="approvalDateTo" placeholder="DD/MM/YYYY" class="j_date" readonly/></p>
        </div>
    </td>
    <th scope="row"></th>
    <td></td>
</tr>

</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#" onclick="javascript:fn_generateReport();">Generate Report</a></p></li>
</ul>

</form>
</section><!-- search_table end -->


</section><!-- content end -->
</section><!-- pop_body end -->
</div><!-- popup_wrap end -->
