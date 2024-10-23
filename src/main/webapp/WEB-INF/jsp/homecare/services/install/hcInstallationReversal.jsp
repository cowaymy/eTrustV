<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

$(document).ready(function() {
	// AUIGrid 그리드를 생성합니다.
    createAUIGrid();

    AUIGrid.setSelectionMode(myGridID, "singleRow");

    AUIGrid.bind(myGridID, "cellClick", function(event) {
        //alert(event.rowIndex+ " -cellClick : " + event.value + " - rowValue : " + AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid"));

        //code =  AUIGrid.getCellValue(myGridID, event.rowIndex, "code");
        var installEntryNo = AUIGrid.getCellValue(myGridID, event.rowIndex, "installEntryNo");
        var salesOrdNo = AUIGrid.getCellValue(myGridID, event.rowIndex, "salesOrdNo");
        //salesDt = AUIGrid.getCellValue(myGridID, event.rowIndex, "salesDt");
        //stkDesc = AUIGrid.getCellValue(myGridID, event.rowIndex, "stkDesc");
        //name = AUIGrid.getCellValue(myGridID, event.rowIndex, "name");
        //code1 = AUIGrid.getCellValue(myGridID, event.rowIndex, "code1");
        var installEntryId = AUIGrid.getCellValue(myGridID, event.rowIndex, "installEntryId");
        var salesOrdId = AUIGrid.getCellValue(myGridID, event.rowIndex, "salesOrdId");
        //Common.popupDiv("/organization/requestTerminateResign.do?isPop=true&MemberID=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid")+"&MemberType=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "membertype"), "");

        selectrow(installEntryNo, salesOrdNo, installEntryId, salesOrdId);
    });

	if('${SESSION_INFO.isAC}' == 1){
    	if("${SESSION_INFO.memberLevel}" =="1"){
            $("#orgCode").val('${SESSION_INFO.orgCode}');
        }else if("${SESSION_INFO.memberLevel}" =="2"){
            $("#orgCode").val('${SESSION_INFO.orgCode}');
            $("#grpCode").val('${SESSION_INFO.groupCode}');
        }else if("${SESSION_INFO.memberLevel}" =="3"){
            $("#orgCode").val('${SESSION_INFO.orgCode}');
            $("#grpCode").val('${SESSION_INFO.groupCode}');
            $("#deptCode").val('${SESSION_INFO.deptCode}');
        }else if("${SESSION_INFO.memberLevel}" =="4"){
            $("#orgCode").val('${SESSION_INFO.orgCode}');
            $("#grpCode").val('${SESSION_INFO.groupCode}');
            $("#deptCode").val('${SESSION_INFO.deptCode}');
        }
    }
});

function selectrow(installEntryNo, salesOrdNo, installEntryId, salesOrdId){
	$("#installEntryNo").val(installEntryNo);
	$("#salesOrdNo").val(salesOrdNo);
	$("#installEntryId").val(installEntryId);
	$("#salesOrdId").val(salesOrdId);
	$("#einstallEntryNo").val(installEntryNo);

	Common.ajax("POST", "/homecare/services/installationReversalSearchDetail.do", $("#searchForm").serializeJSON() , function(result) {
	     //console.log(result);

	     $("#instalStrlDate").val("");
	     $("#reverseReason").val("");
	     $("#failReason").val("");
	     $("#nextCallStrlDate").val("");
	     $("#reverseReasonText").val("");
	     fn_setdetail(result);

	  }, function(jqXHR, textStatus, errorThrown) {
	      console.log("실패하였습니다.");
	      console.log("error : " + jqXHR + " \n " + textStatus + "\n" + errorThrown);
	      console.log("jqXHR.responseJSON.message" + jqXHR.responseJSON.message);
	  });
}

function fn_setdetail(result){

	$("#spanOrdNo").text(result.list1.salesOrdNo);
	$("#spanAppType").text(result.list1.codeName);
	$("#spanCustomerId").text(result.list1.custId);
	$("#spanCustomerName").text(result.list1.name);
	$("#spanNric").text(result.list1.nric);
	$("#spanInstallationNo").text(result.list1.installEntryNo);
	$("#spanInstallationType").text(result.list1.codename1);
	$("#spanInstallationStatus").text(result.list1.name1);
	$("#spanActInsDate").html(result.list1.c1);
	$("#spanInCharedCt").text(result.list1.name2);
	$("#spanInstallProduct").text(result.list1.stkDesc);
	$("#spanDoWarehouse").text(result.list1.brnchId);
	$("#spanDoDate").text(result.list1.InstallDt);
	$("#spanSirimNo").text(result.list1.sirimNo);
	$("#spanSerialNo").text(result.list1.serialNo);
	$("#spanRefNo1").text(result.list1.docRefNo1);
	$("#spanRefNo2").text(result.list1.docRefNo2);
	$("#spanRemark").text(result.list1.rem);
	$("#spanResultKeyBy").text(result.list1.memCode);
	$("#spanResultKeyAt").text(result.list1.c3);

	$("#lblCT").text("("+result.list1.memCode+")"+result.list1.name2 );

	if(result.list1.allowComm==1){
		$("#allowCom").prop("checked",true);
	}

	if(result.list1.isTradeIn==1){
        $("#isTrade").prop("checked",true);
    }

	if(result.list1.requireSms==1){
        $("#reqSms").prop("checked",true);
    }

	$("#ectid").val(result.list1.c6);
	$("#applicationTypeID").val(result.list1.codeId);
	if(result.list5!=null){
		if(result.list5.whLocId!=null){
			   $("#inChargeCTWHID").val(result.list5.whLocId);
		}else{
		   $("#inChargeCTWHID").val(0);
		}
	}else{
		$("#inChargeCTWHID").val(0);
	}

	if(result.list1.installStkId!=null){
        $("#eProductID").val(result.list1.installStkId);
    }

	//$("#retWarehouseID").text(result.list1.brnchId);
	String.prototype.zf = function(len){return "0".string(len - this.length) + this;};
    var errorM = "";
	var date = new Date();

    var year = date.getFullYear();
    var month = date.getMonth()+1;
    var day = date.getDate();
    if(date.getDate() < 10){
        day = "0"+date.getDate();
    }
    if(month < 10){
        month = "0"+month;
    }

    if(month.length>2){
    	month = month.replace('0','');
    }

	if (result.list1.stusCodeId == 4) {
		if (result.list1.c3 == null) {
			$("#btnReverse").hide();
			$("#lblErrorMessage").show();
			$("#lblErrorMessage").text("* No installation record found for this order.");
			$("#divResultReversal").hide();
		}

		// or 조건은 ??  무조건 통과 ;;;
	    if (result.list1.insMonYr == (month.toString() + year.toString())) {
			console.log(result.list1.c3);
			errorM = "";
			$("#lblErrorMessage").text(errorM);
			$("#lblErrorMessage").hide();
			$("#btnReverse").show();
			$("#divResultReversal").show();
		} else {
		    console.log(result.list1.c3);
			errorM ="* This installation is past month. Reversal is disallowed.";
			$("#lblErrorMessage").show();
			$("#lblErrorMessage").text(errorM);
			$("#btnReverse").hide();
            $("#divResultReversal").hide();
		}

		// master_id = 10, 67:Outright
		if (result.list1.codeId == '67') {
			errorM =   errorM + " OutRight Type is disallowed." ;
			$("#lblErrorMessage").show();
			$("#lblErrorMessage").text(errorM);
			$("#btnReverse").hide();
			$("#divResultReversal").hide();
		}

	} else {
        $("#lblErrorMessage").show();
		$("#lblErrorMessage").text("* Only installation complete result can be reverse.");
		$("#btnReverse").hide();
        $("#divResultReversal").hide();
	}

	$("#callTypeId").val(result.list1.codeid1);
	$("#esalesDt").val(result.list1.salesDt);
	$("#eCustomerName").text(result.list1.name);

	$("#hidSerialRequireChkYn").val(result.list1.serialRequireChkYn);
	$("#hidInstallEntryNo").val(result.list1.installEntryNo);
	$("#hidSerialNo").val(result.list1.serialNo);
	$("#hidSalesOrderId").val(result.list1.salesOrdId);
	$("#bndlId").val(result.list1.bndlId);
	$("#bndlCount").val(result.list1.bndlCount);
}

function createAUIGrid() {
    //AUIGrid 칼럼 설정
    var columnLayout = [ {
        dataField : "rnum",
        //headerText : "No.",
        headerText : '<spring:message code="service.grid.No" />',
        editable : true,
        width : 50
    }, {
        dataField : "code",
        headerText : "Type",
        headerText : '<spring:message code="service.grid.Type" />',
        editable : false,
        width : 120
    }, {
        dataField : "installEntryNo",
        //headerText : "install No",
        headerText : '<spring:message code="service.grid.InstallNo" />',
        editable : false,
        width : 130
    }, {
        dataField : "salesOrdNo",
        //headerText : "Order No",
        headerText : '<spring:message code="service.grid.OrderNo" />',
        editable : false,
        width : 130
    }, {
        dataField : "salesDt",
        //headerText : "App Date",
        headerText : '<spring:message code="service.grid.AppDate" />',
        editable : false,
        style : "my-column",
        width : 130
    }, {
        dataField : "stkDesc",
        //headerText : "Product",
        headerText : '<spring:message code="service.grid.Product" />',
        editable : false,
        style:"aui-grid-user-custom-left",
        width : 370
    }, {
        dataField : "name",
        //headerText : "Custermer",
        headerText : '<spring:message code="service.grid.Custermer" />',
        editable : false,
        style:"aui-grid-user-custom-left",
        width : 180

    },
    {
        dataField : "codeName",
        //headerText : "App Type",
        headerText : '<spring:message code="service.grid.AppType" />',
        editable : false,
        width : 120

    },
    {
        dataField : "code1",
        //headerText : "Status",
        headerText : '<spring:message code="service.grid.Status" />',
        width : 120
    },
    {
        dataField : "installEntryId",
        //headerText : "installentryid",
        headerText : '<spring:message code="service.grid.Installentryid" />',
        width : 0
    },
    {
        dataField : "salesOrdId",
        //headerText : "salesOrdId",
        headerText : '<spring:message code="service.grid.SalesOrdId" />',
        width : 0
    }];


     // 그리드 속성 설정
    var gridPros = {

             usePaging           : false,         //페이징 사용
             pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
             editable            : false,
             fixedColumnCount    : 1,
             showStateColumn     : false,
             displayTreeOpen     : false,
             selectionMode       : "singleRow",  //"multipleCells",
             headerHeight        : 20,
             useGroupingPanel    : false,        //그룹핑 패널 사용
             skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
             wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
             showRowNumColumn    : false       //줄번호 칼럼 렌더러 출력
    };

    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myGridID = AUIGrid.create("#grid_wrap_memList", columnLayout, gridPros);
}

var gridPros = {

    // 페이징 사용
    usePaging : true,

    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,

    editable : true,

    fixedColumnCount : 1,

    showStateColumn : true,

    displayTreeOpen : true,

    selectionMode : "singleRow",

    headerHeight : 30,

    // 그룹핑 패널 사용
    useGroupingPanel : true,

    // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
    skipReadonlyColumns : true,

    // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
    wrapSelectionMove : true,

    // 줄번호 칼럼 렌더러 출력
    showRowNumColumn : false

};

function fn_orderSearch(){

    Common.ajax("GET", "/homecare/services/installationReversalSearch.do", $("#searchForm").serialize(), function(orderList) {
        AUIGrid.setGridData(myGridID, orderList);
    });
}

function save_confirm(){

	if(FormUtil.checkReqValue($("#installEntryNo"))){
		Common.alert("<spring:message code='budget.msg.noData'/>");
        return false;
	}
    Common.confirm("Related Billing & Payment Data should be adjusted manually"  , fn_save );
}


function fn_save(){

	/*if(fn_saveValidation()){
		var result = false;
		var callTypeId = $("#callTypeId").val();

		var data = GridCommon.getGridData(myGridID);
	    data.form = $("#editForm").serializeJSON();

		Common.ajax("POST", "/services/saveResaval",  data, function(result) {
		console.log("message : " + result.message );
        Common.alert(result.message,fn_close);
        });
		}

	*/

	// KR-OHK Serial Check add
    var url = "";

    //if ($("#hidSerialRequireChkYn").val() == 'Y') {
    //    url = "/services/saveResavalSerial.do";
    //} else {
    //    url = "/services/saveResaval.do";
    //}
    url = "/homecare/services/saveResavalSerial.do";

	$("#einstallEntryNo").val($("#installEntryNo").val());
    $("#esalesOrdNo").val($("#salesOrdNo").val());
    $("#einstallEntryId").val($("#installEntryId").val());
    $("#esalesOrdId").val($("#salesOrdId").val());
	Common.ajax("POST", url,  $("#editForm").serializeJSON(), function(result) {
        console.log("message : " + result.message );
        Common.alert(result.message,fn_close);
        location.reload(true);
    });
}

function fn_saveValidation(){
	var valid = true;
	var message = "";
	var d = new Date();
	var installDate = new Date();
	var callDate = new Date();

	//instalStrlDate
    if ($("#instalStrlDate").val() == ""){
        valid = false;
        message += "* Please select the install date. \n";
    }else{
    	installDate = new Date($("#instalStrlDate").val());
        //DateTime installDate = dpInstallDate.SelectedDate.Value;
        if (installDate >= d){
            valid = false;
            message += "* Install date cannot be future date.<br />";
        }else{
            //DateTime nowDate = DateTime.Now.Date;
            if (installDate.getMonth() != d.getMonth() || installDate.getFullYear() != d.getFullYear()){
                valid = false;
                message += "* Install date must within current month.<br />";
            }
        }
    }

    if($("#failReason").val()==""){
        valid=false;
        message += "* Please select the fail reason.<br />";
    }
    if ($("#nextCallStrlDate").val() == "")
    {
        valid = false;
        message += "* Please select the next call date.<br />";
    }
    else
    {
    	installDate = new Date($("#nextCallStrlDate").val());
    	if(installDate<=d)
        //if(!CommonFunction.IsFutureOrToday(dpNextCallDate.SelectedDate.Value))
        {
            valid=false;
            message += "* Next call date must be today or future date.<br />";
        }
    }

    if (!valid)
    	Common.alert(message);

	return valid;
}

function fn_close(){
    $("#popup_wrap").remove();
}


</script>

<section id="content"><!-- content start -->
<ul class="path">
    <!-- <li><img src="../images/common/path_home.gif" alt="Home" /></li> -->
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#none" class="click_add_on">My menu</a></p>
<h2><spring:message code='service.title.InstallationResultReversalList'/></h2>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="searchForm" id="searchForm" method="post">
	    <input type="hidden"  id="installEntryNo" name="installEntryNo"/>
	    <input type="hidden"  id="salesOrdNo" name="salesOrdNo"/>
	    <input type="hidden"  id="installEntryId" name="installEntryId"/>
	    <input type="hidden"  id="salesOrdId" name="salesOrdId"/>
	    <input type="hidden" id="orgCode" name="orgCode" value="" />
		<input type="hidden" id="grpCode" name="grpCode" value="" />
		<input type="hidden" id="deptCode" name="deptCode" value="" />

    <aside class="link_btns_wrap">
	    <div id="divErrorMessage" style="width: 100%; height: 20px; margin: 0 auto;">
	        <span style="color: #CC0000" ID="lblErrorMessage"></span>
	    </div>
    </aside><!-- grid_wrap end -->

	<table class="type1"><!-- table start -->
		<caption>table</caption>
		<colgroup>
		    <col style="width:100px" />
		    <col style="width:*" />
		</colgroup>
		<tbody>

		<tr>
		    <th scope="row"><spring:message code='service.title.OrderNo'/></th>
		    <td><input type="text" title="" id="orderNo" name="orderNo" placeholder="" class="" />
		        <p class="btn_grid"><a href="javascript:fn_orderSearch();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p>
		    </td>
		</tr>
		</tbody>
	</table><!-- table end -->

	<aside class="link_btns_wrap"><!-- link_btns_wrap start -->

	<article class="grid_wrap"><!-- grid_wrap start -->
	    <div id="grid_wrap_memList" style="width: 100%; height: 210px; margin: 0 auto;"></div>
	</article><!-- grid_wrap end -->
	<aside class="title_line"><!-- title_line start -->
	    <span></span>
	</aside><!-- title_line end -->
</form>
</section><!-- search_table end -->


<aside class="title_line"><!-- title_line start -->
<h3><spring:message code='service.title.Details'/></h3>

    <aside class="link_btns_wrap">
	    <div  style="width: 100%; height: 20px;text-align:right;color:darkblue;">
	        Only the latest installation result will display.
	    </div>
    </aside>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
    <col style="width:190px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code='service.title.OrderNo'/></th>
    <td><span id="spanOrdNo"></span></td>
    <th scope="row"><spring:message code='service.title.AppType'/></th>
    <td><span id="spanAppType"></span></td>
    <th scope="row"><spring:message code='service.title.CustomerID'/></th>
    <td><span id="spanCustomerId"></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code='service.title.CustomerName'/></th>
    <td><span id="spanCustomerName"></span></td>
    <th scope="row"><spring:message code='service.title.NRIC_CompanyNo'/></th>
    <td><span id="spanNric"></span></td>
    <th scope="row"><spring:message code='service.title.InstallationNo'/></th>
    <td><span id="spanInstallationNo"></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code='service.title.InstallationType'/></th>
    <td><span id="spanInstallationType"></span></td>
    <th scope="row"><spring:message code='service.title.InstallationStatus'/></th>
    <td><span id="spanInstallationStatus"></span></td>
    <th scope="row"><spring:message code='service.title.ActualInstalledDate'/></th>
    <td><span id="spanActInsDate"></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code='service.title.In-ChargedCT'/></th>
    <td><span id="spanInCharedCt"></span></td>
    <th scope="row"><spring:message code='service.title.InstallProduct'/></th>
    <td><span id="spanInstallProduct"></span></td>
    <th scope="row"><spring:message code='service.title.DOWarehouse'/></th>
    <td><span id="spanDoWarehouse"></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code='service.title.DODate'/></th>
    <td><span id="spanDoDate"></span></td>
    <th scope="row"><spring:message code='service.title.SIRIMNo'/></th>
    <td><span id="spanSirimNo"></span></td>
    <th scope="row"><spring:message code='service.title.SerialNo'/></th>
    <td><span id="spanSerialNo"></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code='service.title.RefNo'/>(1)</th>
    <td><span id="spanRefNo1"></span></td>
    <th scope="row"><spring:message code='service.title.RefNo'/>(2)</th>
    <td colspan="3"><span id="spanRefNo2"></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code='service.title.Remark'/></th>
    <td colspan="5" ><span id="spanRemark"></span></td>
</tr>
<tr>
    <td colspan="6">
    <label><input type="checkbox" id="allowComm"/><span><spring:message code='service.btn.AllowCommission'/> ?</span></label>
    <label><input type="checkbox" id="isTrade"/><span><spring:message code='service.btn.IsTradeIn'/> ?</span></label>
    <label><input type="checkbox" id="reqSms"/><span><spring:message code='service.btn.RequireSMS'/> ?</span></label>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='service.title.ResultKeyBy'/></th>
    <td><span id="spanResultKeyBy"></span></td>
    <th scope="row"><spring:message code='service.title.ResultKeyAt'/></th>
    <td colspan="3"><span id="spanResultKeyAt"></span></td>
</tr>
</tbody>
</table><!-- table end -->

<div id="divResultReversal">
<aside class="title_line"><!-- title_line start -->
    <h3><spring:message code='service.title.InstallationResultReversal'/></h3>
</aside><!-- title_line end -->
<form action="" id="editForm" method="post">
	<input type="hidden" id="callTypeId" name = "callTypeId">
	<input type="hidden"  id="einstallEntryNo" name="einstallEntryNo"/>
	<input type="hidden"  id="esalesOrdNo" name="esalesOrdNo"/>
	<input type="hidden"  id="einstallEntryId" name="einstallEntryId"/>
	<input type="hidden"  id="esalesOrdId" name="esalesOrdId"/>
	<input type="hidden"  id="ectid" name="ectid" />
	<input type="hidden"  id="applicationTypeID" name="applicationTypeID" />
	<input type="hidden"  id="inChargeCTWHID" name="inChargeCTWHID" />
	<input type="hidden"  id="retWarehouseID" name="retWarehouseID" />
	<input type="hidden"  id="esalesDt" name="esalesDt"/>
	<input type="hidden"  id="eCustomerName" name="eCustomerName"/>
	<input type="hidden"  id="eProductID" name="eProductID"/>
	<input type="hidden"  id="hidSerialRequireChkYn" name="hidSerialRequireChkYn"/>
	<input type="hidden"  id="hidInstallEntryNo" name="hidInstallEntryNo"/>
	<input type="hidden"  id="hidSalesOrderId" name="hidSalesOrderId"/>
	<input type="hidden"  id="hidSerialNo" name="hidSerialNo"/>
	<input type="hidden"  id="bndlId" name="bndlId"/>
	<input type="hidden"  id="bndlCount" name="bndlCount"/>
	<table class="type1"><!-- table start -->
	<caption>table</caption>
	<colgroup>
	    <col style="width:160px" />
	    <col style="width:*" />
	    <col style="width:170px" />
	    <col style="width:*" />
	    <col style="width:190px" />
	    <col style="width:*" />
	</colgroup>
	<tbody>
	<tr>
	    <th scope="row"><spring:message code='service.title.ReversalStatus'/></th>
	    <td><span id="lblShowRevInstallStatus1" style="font-weight:bold;">From</span>
	    <span id="lblShowRevInstallStatus2" style="text-decoration: underline; font-weight:bold; color:brown; font-Style:italic">Completed</span>
	    <span id="lblShowRevInstallStatus3" style="font-weight:bold;">To</span>
	    <span id="lblShowRevInstallStatus4" style="text-decoration: underline; font-weight:bold; color:brown; font-Style:italic">Fail</span>
	    </td>
	    <th scope="row"><spring:message code='service.title.InchargeCT'/></th>
	    <td><span id="lblCT"></span></td>
	    <th scope="row"><spring:message code='service.title.InstallDate'/></th>
	    <td>
	        <div class="date_set w100p"><!-- date_set start -->
	        <p><input type="text" title="Install Date" placeholder="DD/MM/YYYY" class="j_dateHc" id="instalStrlDate" name="instalStrlDate"/></p>
	        </div>
	    </td>

	</tr>
	<tr>
	    <th scope="row"><spring:message code='service.title.ReverseReason'/></th>
	    <td>
	        <select class="w100p" id="reverseReason" name="reverseReason">
	        <option value="" selected>Reverse Reason</option>
	         <c:forEach var="list" items="${selectReverseReason }" varStatus="status">
	           <option value="${list.resnId}">${list.code} - ${list.resnDesc}</option>
	        </c:forEach>
	        </select>
	    </td>
	    <th scope="row"><spring:message code='service.title.FailedReason'/></th>
	    <td>
	        <select class="w100p" id="failReason" name="failReason">
	        <option value="" selected>Fail Reason</option>
	         <c:forEach var="list" items="${selectFailReason }" varStatus="status">
	           <option value="${list.resnId}">${list.code} - ${list.resnDesc}</option>
	        </c:forEach>
	        </select>
	    </td>
	    <th scope="row"><spring:message code='service.title.NextCallDate'/></th>
	    <td>
	        <div class="date_set w100p"><!-- date_set start -->
	        <p><input type="text" title="Next Call Date" placeholder="DD/MM/YYYY" class="j_dateHc" id="nextCallStrlDate" name="nextCallStrlDate"/></p>
	        </div>
	    </td>
	</tr>
	<tr>
	    <th scope="row"><spring:message code='service.title.ReverseReason'/></th>
	    <td colspan="5">
	        <textarea cols="20" rows="5" id="reverseReasonText" name="reverseReasonText"></textarea>
	    </span></td>
	</tr>
	</tbody>
	</table>
	<ul class="center_btns">
	    <li><p class="btn_blue2 big" id="btnReverse"><a href="#none" onclick="javascript:save_confirm()"><spring:message code='service.btn.ConfirmToReverse'/></a></p></li>
	</ul>
</form>
</div>

</section><!-- content end -->