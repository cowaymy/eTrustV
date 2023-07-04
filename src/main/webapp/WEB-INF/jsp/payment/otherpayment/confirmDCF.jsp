<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<style type="text/css">
.my-custom-up div{
    color:#FF0000;
}
</style>
<script type="text/javaScript">
	//AUIGrid 그리드 객체
	var confirmDCFGridID;

	//Grid에서 선택된 RowID
	var selectedGridValue;

	//Grid Properties 설정
	var gridPros = {
	        // 편집 가능 여부 (기본값 : false)
	        editable : false,
	        // 상태 칼럼 사용
	        showStateColumn : false,
	        // 기본 헤더 높이 지정
	        headerHeight : 35,

	        softRemoveRowMode:false,

	        showRowCheckColumn: true,
	        showRowAllCheckBox : false,

	};

	//Default Combo Data
	var statusData = [{"codeId": "1","codeName": "Active"},
					{"codeId": "5","codeName": "Approved"},
					{"codeId": "6","codeName": "Rejected"}];

	// AUIGrid 칼럼 설정
	var columnLayout = [
        {dataField : "dcfReqId",headerText : "<spring:message code='pay.head.dcfRequestNo'/>",width : 135 , editable : false},
        {dataField : "reqType",headerText : "Request Type",width : 135 , editable : false, visible : false},
        {dataField : "dcfReqIdType",headerText : "Request ID and Type",width : 135 , editable : false, visible : false},
        {dataField : "grpSeq",headerText : "<spring:message code='pay.head.paymentGroupSeq'/>",width : 165 , editable : false},
        {dataField : "salesOrdNo",headerText : "Sales<br/>Order",width : 110 , editable : false},
        {dataField : "dcfResnNm",headerText : "<spring:message code='pay.head.reason'/>",width : 250 , editable : false},
        {dataField : "dcfCrtUserNm",headerText : "<spring:message code='pay.head.requestor'/>",width : 110 , editable : false},
        {dataField : "reqstBrnch",headerText : "Branch Code<br/>(Requestor)",width : 200 , editable : false},
        {dataField : "dcfCrtDt",headerText : "<spring:message code='pay.head.requestDate'/>",width : 110 , editable : false, dataType:"date",formatString:"dd/mm/yyyy"},
        {dataField : "dcfStusId",headerText : "<spring:message code='pay.head.statusId'/>",width : 100 , editable : false, visible : false},
        {dataField : "dcfStusNm",headerText : "<spring:message code='pay.head.status'/>",width : 110 , editable : false},
        {dataField : "dcfAppvUserNm",headerText : "Approval",width : 110 , editable : false},
        {dataField : "appvStus",headerText : "Approval Status",width : 110 , editable : false, visible:false}
	];


	$(document).ready(function(){
		doGetCombo('/common/selectCodeList.do', '392' , ''   , 'reason' , 'S', '');
		doDefCombo(statusData, '' ,'status', 'S', '');
		doGetComboSepa('/common/selectBranchCodeList.do', '1' , ' - ' , '','branchId', 'S' , '');

		$('#branchId').change(function (){
	        doGetCombo('/common/getUsersByBranch.do', $(this).val() , ''   , 'userId' , 'S', '');
	    });

		//그리드 생성
	    confirmDCFGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);

		// Master Grid 셀 클릭시 이벤트
	    AUIGrid.bind(confirmDCFGridID, "cellClick", function( event ){
		    var dcfReqIdType = AUIGrid.getCellValue(confirmDCFGridID, event.rowIndex, "dcfReqIdType");

            AUIGrid.setCheckedRowsByValue(confirmDCFGridID, "dcfReqIdType", dcfReqIdType);
	    });

	    AUIGrid.bind(confirmDCFGridID, "rowCheckClick", function( event ) {
	        var dcfReqIdType = AUIGrid.getCellValue(confirmDCFGridID, event.rowIndex, "dcfReqIdType");

           	AUIGrid.setCheckedRowsByValue(confirmDCFGridID, "dcfReqIdType", dcfReqIdType);
	    });

	});

    // ajax list 조회.
    function searchList(){

		if(FormUtil.checkReqValue($("#reqNo"))){
			if(FormUtil.checkReqValue($("#salesOrdNo")) && (FormUtil.checkReqValue($("#reqDateFr")) || FormUtil.checkReqValue($("#reqDateTo")))){
	            Common.alert("<spring:message code='pay.alert.reqDate'/>");
		        return;
			}
		}

    	Common.ajax("POST","/payment/selectRequestDCFList.do",$("#searchForm").serializeJSON(), function(result){
    		AUIGrid.setGridData(confirmDCFGridID, result);
    	});
    }

    // 화면 초기화
    function clear(){
    	//화면내 모든 form 객체 초기화
    	$("#searchForm")[0].reset();

    	//그리드 초기화
    	//AUIGrid.clearGridData(myGridID);
    }


    //Request DCF 팝업
    function fn_confirmDCFPop(){
        var selectedItem = AUIGrid.getCheckedRowItemsAll(confirmDCFGridID);
        console.log(selectedItem);

        if (selectedItem.length > 0){
            var groupSeqList = [];
            var dcfStusIdList = null;
            var dcfReqIdList = null;
            var dcfReqTypeList = null;

            for(var i = 0 ; i < selectedItem.length ; i++){
                groupSeqList.push(selectedItem[i].grpSeq);

                if (selectedItem[0].dcfReqId != selectedItem[i].dcfReqId){
                	Common.alert("Please select same DCF request no");
	                 break;
                }

                if (selectedItem[0].reqType != selectedItem[i].reqType){
                	Common.alert("Please select same DCF request type");
	                 break;
                }

                if (selectedItem[0].appvStus != selectedItem[i].appvStus){
                	Common.alert("These dcf contain approved or rejected DCF");
	                 break;
                }
            }
            dcfReqIdList = selectedItem[0].dcfReqId;
            dcfReqTypeList = selectedItem[0].reqType;
            dcfStusIdList = selectedItem[0].appvStus;

            var selectedDCF = {
               "groupSeqList" : JSON.stringify(groupSeqList.join()),
               "dcfReqIdList" : JSON.stringify(dcfReqIdList),
               "dcfStusIdList" : JSON.stringify(dcfStusIdList),
               "dcfReqTypeList" : JSON.stringify(dcfReqTypeList),
            };

            if(dcfReqTypeList == '-'){
                Common.popupDiv('/payment/initConfirmDCFPop.do', selectedDCF, null , true ,'_confirmDCFPop');
            }else {
            	Common.popupDiv('/payment/initConfirmNewDCFPop.do', selectedDCF, null , true ,'_confirmNewDCFPop');
            }

        }else{
             Common.alert("<spring:message code='pay.alert.noDcf'/>");
        }
    }

	function fn_genDCFRawPop() {
	    doGetCombo('/common/selectCodeList.do', '392' , ''   , 'cmbReason' , 'S', '');
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
	            whereSQL += " AND Extent1.DCF_CRT_DT >= TO_DATE('" + $("#requestDateFr").val() + "', 'DD/MM/YYYY') ";
	        } else {
	            Common.alert("Please fill in request from date.");
	            return;
	        }

	        if($("#requestDateTo").val() != "") {
	            whereSQL += " AND Extent1.DCF_CRT_DT < TO_DATE('" + $("#requestDateTo").val() + "', 'DD/MM/YYYY') + 1";
	        } else {
	            Common.alert("Please fill in request to date.");
	            return;
	        }

	        if($("#cmbReason").val() != "")
	            whereSQL += " AND Extent1.DCF_RESN = " + $("#cmbReason").val() ;

	        if($("#cmbStatus").val() != "")
	            whereSQL += " AND Extent1.DCF_STUS_ID = " + $("#cmbStatus").val() ;

	        if($("#cmbBranch").val() != "")
	            whereSQL += " AND CRTU.USER_BRNCH_ID = " + $("#cmbBranch").val() ;

	        if($("#approvalDateFr").val() != "")
	            whereSQL += " AND Extent1.DCF_APPV_DT >= TO_DATE('" + $("#approvalDateFr").val() + "', 'DD/MM/YYYY') ";

	        if($("#approvalDateFr").val() != "")
	            whereSQL += " AND Extent1.DCF_APPV_DT < TO_DATE('" + $("#approvalDateFr").val() + "', 'DD/MM/YYYY') + 1";

	        var date = new Date().getDate();
	        if(date.toString().length == 1){
	            date = "0" + date;
	        }

	        $("#reportForm #reportDownFileName").val("DCF_AdjustmentRaw_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
	        $("#reportForm #v_WhereSQL").val(whereSQL);
	        $("#reportForm #viewType").val("EXCEL");
	        $("#reportForm #reportFileName").val("/payment/PaymentDCFAdjustRaw.rpt");

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
        <h2>Confirm DCF</h2>
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
						<th scope="row">DCF Request No</th>
                        <td>
                            <input type="text" id="reqNo" name="reqNo" class="w100p" value="${reqNo}"/>
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
	<aside class="link_btns_wrap">
		<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
		<dl class="link_list">
			<dt>Link</dt>
			<dd>
			 <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
				<ul class="btns">
					<li><p class="link_btn"><a href="javascript:fn_confirmDCFPop();"><spring:message code='pay.btn.link.approvalDCF'/></a></p></li>
					<li><p class="link_btn"><a href="javascript:fn_genDCFRawPop();">Generate DCF Adjustment Raw</a></p></li>
				</ul>
			</c:if>
				<p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
			</dd>
		</dl>
	</aside>
	<!-- link_btns_wrap end -->

    <!-- search_result start -->
    <section class="search_result">
        <!-- grid_wrap start -->
        <article id="grid_wrap" class="grid_wrap"></article>
        <!-- grid_wrap end -->
    </section>
    <!-- search_result end -->

</section>
<!-- content end -->

<div id="popup_wrap" class="popup_wrap" style="display:none"><!-- popup_wrap start -->
<section id="content"><!-- content start -->

<header class="pop_header"><!-- pop_header start -->
<h1>DCF Adjustment Report</h1>
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
