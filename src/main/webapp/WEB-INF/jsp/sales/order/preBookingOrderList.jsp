<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">
	var listGridID;
	var excelListGridID;
	var keyValueList = [];
	var MEM_TYPE = '${SESSION_INFO.userTypeId}';
	var CATE_ID  = "14";
	var appTypeData = [
            	                   {"codeId": "66","codeName": "Rental"}
	                            ];

	var actData= [
	                        {"codeId": "21","codeName": "Failed"},
	                        {"codeId": "10","codeName": "Cancel"}
	                   ];

	var memTypeData = [
                	                   {"codeId": "2","codeName": "Cody"},
                	                   {"codeId": "4","codeName": "Staff"},
                	                   {"codeId": "7","codeName": "HT"}
	                              ];
	var discWaive = [
	                            {"codeId" : "4","codeName":"4 Month Earlier"},
	                            {"codeId" : "3","codeName":"3 Month Earlier"},
	                            {"codeId" : "2","codeName":"2 Month Earlier"},
	                            {"codeId" : "1","codeName":"1 Month Earlier"}
	                        ];

	var myFileCaches = {};
	var recentGridItem = null;
	var selectRowIdx;
	var popupObj;
	var brnchType = "${branchType}";
	var memTypeFiltered = false;

   if (brnchType == 45) {
        memTypeData = memTypeData.filter(function(d){
             return d.codeId == "1";
         });
        memTypeFiltered = true;
    } else if (brnchType == 42 || brnchType == 48) {
        let data = memTypeData.filter(function(d){
            return d.codeId == "2" || d.codeId == "7";
        });
        memTypeData = brnchType == 48 ? data.reverse() : data
        memTypeFiltered = true;
    }


    $(document).ready(function(){
    	fn_statusCodeSearch();
        //AUIGrid
        createAUIGrid();
        createExcelAUIGrid();

        if(MEM_TYPE == "1" || MEM_TYPE == "2" || MEM_TYPE == "7" ){
            if("${SESSION_INFO.memberLevel}" =="1"){
                $("#orgCode").val("${orgCode}");
                $("#orgCode").attr("class", "w100p readonly");
                $("#orgCode").attr("readonly", "readonly");
            }else if("${SESSION_INFO.memberLevel}" =="2"){
                $("#orgCode").val("${orgCode}");
                $("#orgCode").attr("class", "w100p readonly");
                $("#orgCode").attr("readonly", "readonly");

                $("#grpCode").val("${grpCode}");
                $("#grpCode").attr("class", "w100p readonly");
                $("#grpCode").attr("readonly", "readonly");
            }else if("${SESSION_INFO.memberLevel}" =="3"){
                $("#orgCode").val("${orgCode}");
                $("#orgCode").attr("class", "w100p readonly");
                $("#orgCode").attr("readonly", "readonly");

                $("#grpCode").val("${grpCode}");
                $("#grpCode").attr("class", "w100p readonly");
                $("#grpCode").attr("readonly", "readonly");

                $("#deptCode").val("${deptCode}");
                $("#deptCode").attr("class", "w100p readonly");
                $("#deptCode").attr("readonly", "readonly");
            }else if("${SESSION_INFO.memberLevel}" =="4"){
                $("#orgCode").val("${orgCode}");
                $("#orgCode").attr("class", "w100p readonly");
                $("#orgCode").attr("readonly", "readonly");

                $("#grpCode").val("${grpCode}");
                $("#grpCode").attr("class", "w100p readonly");
                $("#grpCode").attr("readonly", "readonly");

                $("#deptCode").val("${deptCode}");
                $("#deptCode").attr("class", "w100p readonly");
                $("#deptCode").attr("readonly", "readonly");

                $("#_memCode").val("${SESSION_INFO.userName}");
                $("#_memCode").attr("class", "w100p readonly");
                $("#_memCode").attr("readonly", "readonly");
                $("#_memBtn").hide();
            }
        }

        AUIGrid.bind(listGridID , "cellClick", function( event ){
        //	console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
        	selectRowIdx = event.rowIndex;
        });

        AUIGrid.bind(listGridID, "cellDoubleClick", function(event) {
            fn_setDetail(listGridID, selectRowIdx);
        });

        doDefCombo(appTypeData, '' ,'_appTypeId', 'M', 'fn_multiCombo');
        doDefCombo(discWaive, '' ,'discountWaive', 'M', 'fn_multiCombo');
        doGetComboData('/status/selectStatusCategoryCdList.do', {selCategoryId : CATE_ID, parmDisab : 0}, '', '_stusId', 'M', 'fn_multiCombo');
     //   doGetComboSepa('/common/selectBranchCodeList.do',  '10', ' - ', '', '_brnchId', 'M', 'fn_multiCombo'); //Branch Code
        doGetComboOrder('/common/selectCodeList.do', '8', 'CODE_ID', '', '_typeId', 'M', 'fn_multiCombo'); //Common Code
     //   doGetComboAndGroup2('/common/selectProductCodeList.do', {selProdGubun: 'EXHC'}, '', 'ordProdList', 'S', 'fn_setOptGrpClass');

        if (memTypeFiltered) {
        	doDefComboAndMandatory(memTypeData, '', 'memType', 'S', '');
        } else {
	        doDefCombo(memTypeData, '', 'memType', 'S', '');
        }

        //excel Download
        $('#excelDown').click(function() {
            var excelProps = {
                fileName     : "Pre-Booking Order List",
               exceptColumnFields : AUIGrid.getHiddenColumnDataFields(excelListGridID)
            };
            AUIGrid.exportToXlsx(excelListGridID, excelProps);
        });
    });

    function fn_setToDay() {
        var today = new Date();

        var dd = today.getDate();
        var mm = today.getMonth() + 1;
        var yyyy = today.getFullYear();

        if(dd < 10) {
            dd = "0" + dd;
        }
        if(mm < 10){
            mm = "0" + mm
        }

        today = dd + "/" + mm + "/" + yyyy;
        $("#_reqstEndDt").val(today);

        var today_s = "01/" + mm + "/" + yyyy;
        $("#_reqstStartDt").val(today_s);
    }

    function fn_statusCodeSearch(){
        Common.ajaxSync("GET", "/status/selectStatusCategoryCdList.do", {selCategoryId : CATE_ID, parmDisab : 0}, function(result) {
            keyValueList = result;
        });
    }

    function fn_setOptGrpClass() {
        $("optgroup").attr("class" , "optgroup_text")
    }

    function fn_validStatus() {
        var isValid = true;
        if(selectRowIdx > -1) {
            var stusId    = AUIGrid.getCellValue(listGridID, selectRowIdx, "stusId");
            var preOrdId = AUIGrid.getCellValue(listGridID, selectRowIdx, "preOrdId");
            var custNric  = AUIGrid.getCellValue(listGridID, selectRowIdx, "nric");
            var rcdTms = AUIGrid.getCellValue(listGridID, selectRowIdx, "updDt");

            $('#hiddenPreOrdId').val(preOrdId);
            $('#hiddenRcdTms').val(rcdTms);
            $('#view_custIc').text(custNric);

            if(stusId == 4 || stusId == 10){
                Common.alert("Completed pre-booking cannot be edited.");
                isValid = false;
            }
        }else {
           Common.alert("Pre-Booking Missing" + DEFAULT_DELIMITER + "<b>No pre-booking selected.</b>");
           isValid = false;
        }

        return isValid;
    }

    function fn_doFailStatus(){
        var preOrdId = AUIGrid.getCellValue(listGridID, selectRowIdx, "preOrdId");

    	if(action == "" ){
    		Common.alert("Please select action");
            return;
    	}
    	if(action == 21 && ($('input[name=cmbFailCode]:checked').val() == null || $('#_rem_').val() == null) ){
    		Common.alert("Please select Reason Code and key in Remark");
    		return;
    	}

    	var failUpdOrd = {
    			failCode : $('input[name=cmbFailCode]:checked').val(),
    		    remark : $('#_rem_').val(),
    		    sof : sof,
    		    preOrdId : preOrdId,
    		    stusId : action
    	};

        Common.confirm("Confirm to " + name +  " ? " , function(){
    		Common.ajaxSync("GET", "/sales/order/selRcdTms.do", $("#updFailForm").serialize(), function(result) {
    			if(result.code == "99"){
                    Common.alert("Save Pre-Booking Order Summary" + DEFAULT_DELIMITER + "<b>"+ result.message +"</b>", function(){
                        hideViewPopup('#updFail_wrap');
                        fn_getPreBookingOrderList();
                    });
                }else{
                	Common.ajax("POST", "/sales/order/updateFailPreOrderStatus.do", failUpdOrd, function(result) {
                        Common.alert("Order Failed" + DEFAULT_DELIMITER + "<b>"+result.message+"</b>", fn_closeFailedStusPop);
                    },
                    function(jqXHR, textStatus, errorThrown) {
                        try {
                            Common.alert("Failed To Save" + DEFAULT_DELIMITER + "<b>Failed to save order.</b>");
                        }
                        catch (e) {
                            console.log(e);
                        }
                    });
                }
            });
    	});
    }

    function fn_closeFailedStusPop() {
        fn_getPreBookingOrderList();
        $('#updFail_wrap').hide();
        $('#updFailForm').clearForm();
    }

    function createAUIGrid() {
    	//AUIGrid
        var columnLayout = [
            { headerText : "Pre-Booking Order No.", dataField : "preBookNo", editable : false, width : '10%' }
          , { headerText : "Status", dataField : "stusCode", editable : false, width : '10%' }
          , { headerText : "Pre-Booking Save Date", dataField : "preBookDt", editable : false, width : '13%' }
          , { headerText : "Customer Verification Status", dataField : "custVerifyStus", editable : false, width : '18%' }
          , { headerText : "Salesperson Code",  dataField : "memCode",editable : false, width : '10%' }
          , { headerText : "Customer Info",   dataField : "custName", editable : false, width : '10%' }
          , { headerText : "Previous Product Model", dataField : "prevStkDesc", editable : false, width : '15%'}
          , { headerText : "Previous Product Order No", dataField : "salesOrdNo", editable : false, width : '15%'}
          , { headerText : "Product Interested", dataField : "stkDesc", editable : false, width : '10%' }
          , { headerText : "preBookId", dataField : "preBookId", visible : false }
          , { headerText : "stusId",dataField : "stusId", visible  : false}
          , { headerText : "Update Date", dataField : "updDt", visible : false }
       ];

        var gridPros = {
            usePaging : true,
            pageRowCount : 20,
            editable : true,
            fixedColumnCount : 1,
            showStateColumn : false,
            displayTreeOpen : false,
            headerHeight : 30,
            useGroupingPanel : false,
            skipReadonlyColumns : true,
            wrapSelectionMove : true,
            showRowNumColumn : true,
            noDataMessage : "No order found.",
            wordWrap : true,
            groupingMessage : "Here groupping"
        };

        listGridID = GridCommon.createAUIGrid("list_grid_wrap", columnLayout, "", gridPros);
    }

    function createExcelAUIGrid() {
        //AUIGrid
        var excelColumnLayout = [
            { headerText : "Pre-booking order No",  dataField : "preBookNo",  editable : false, width:100}
           , { headerText : "Status", dataField : "stusCode", editable : false,width:150}
           , { headerText : "Pre-Booking Save Date", dataField : "preBookDt", editable : false, width : 200}
           , { headerText : "Customer Verfification Status", dataField : "custVerifyStus", editable : false, width : 200}
           , { headerText : "Sales Persom Code", dataField : "memCode", editable : false, width : 200}
           , { headerText : "Customer Info", dataField : "custName", editable : false, width : 300}
           , { headerText : "Previous Product Model", dataField : "", editable : false, width : 200}
           , { headerText : "Previous Product Order No", dataField : "", editable : false, width : 200}
           , { headerText : "Product Interested", dataField : "stkDesc", editable : false, width : 200}
       ];

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

        excelListGridID = GridCommon.createAUIGrid("excel_list_grid_wrap", excelColumnLayout, "", excelGridPros);
    }

    $(function(){
        $('#_btnNew').click(function() {
          Common.ajax("GET", "/sales/order/checkRC.do", "", function(memRc) {
                if(memRc != null) {
                    if(memRc.rookie == 1) {
                        if(memRc.rcPrct != null) {
                            if(memRc.rcPrct < 30) {
                                Common.alert(memRc.name + " (" + memRc.memCode + ") is not allowed to key in due to Individual SHI below 30%.");
                                return false;
                            }
                        }
                    } else {
                        Common.alert(memRc.name + " (" + memRc.memCode + ") is still a rookie, no key in is allowed.");
                        return false;
                    }
                }
                Common.popupDiv("/sales/order/preBooking/preBookingOrderRegisterPop.do", null, null, true, '_divPreBookingOrdRegPop');
            });
        });

        $('#_btnClear').click(function() {
        	$("#_frmPreBookingOrdSrch").clearForm();
        });

        $('#_btnSearch').click(function() {
        	if(fn_validSearchList())
        		fn_getPreBookingOrderList();
        });

        $('#_btnFailSave').click(function() {
            fn_doFailStatus();
        });

        $('#_memBtn').click(function() {
            Common.popupDiv("/common/memberPop.do", $("#_frmPreBookingOrdSrch").serializeJSON(), null, true);
        });

        $('#_memCode').change(function(event) {
            var memCd = $('#_memCode').val().trim();

            if(FormUtil.isNotEmpty(memCd)) {
                fn_loadOrderSalesman(memCd);
            }
        });

        $('#_memCode').keydown(function (event) {
            if (event.which === 13) {
            	//enter
                var memCd = $('#_memCode').val().trim();

                if(FormUtil.isNotEmpty(memCd)) {
                    fn_loadOrderSalesman(memCd);
                }
                return false;
            }
        });

        $('#_action').change(function(event) {
            var action = $('#_action').val().trim();

            if(action == 21){
            	$("#fail_reason").show();
            	$("#fail_rem").show();
            }else{
            	$("#fail_reason").hide();
                $("#fail_rem").hide();
            }
        });

        $('#_btnCancelPreBook').click(function() {
            fn_cancelPreBookOrderPop();
        });
    });

    function fn_validSearchList() {
    	var isValid = true, msg = "";

        if('${userRoleId}' == 51) {
        	// BLOCK CARE LINE AGENT WHEN CLICK SEARCH BUTTON
        	  isValid = false;
              msg += '* Unable to search due to no access right.<br/>';
        }

        if((!FormUtil.isEmpty($('#_reqstStartDt').val()) && FormUtil.isEmpty($('#_reqstEndDt').val())) ||
        	(FormUtil.isEmpty($('#_reqstStartDt').val()) && !FormUtil.isEmpty($('#_reqstEndDt').val())))
       {
              msg += '<spring:message code="sal.alert.msg.selectOrdDate" /><br/>';
              isValid = false
       }

    	if(FormUtil.isEmpty($('#_memCode').val())
  			&& FormUtil.isEmpty($('#_appTypeId').val())
  		    && FormUtil.isEmpty($('#_stusId').val())
  		    && FormUtil.isEmpty($('#_typeId').val())
  		    && FormUtil.isEmpty($('#_nric').val())
  		    && FormUtil.isEmpty($('#_name').val())
  		    && (FormUtil.isEmpty($('#_reqstStartDt').val()) || FormUtil.isEmpty($('#_reqstEndDt').val()))
        ){
    		isValid = false;
    		msg += '* Please fill in the related empty fields.<br/>';
    	 }

    	if(!FormUtil.isEmpty($('#_reqstStartTime').val()) || !FormUtil.isEmpty($('#_reqstEndTime').val())) {
    		if(FormUtil.isEmpty($('#_reqstStartDt').val()) || FormUtil.isEmpty($('#_reqstEndDt').val())) {
                isValid = false;
                msg += '* Please select Pre-Booking Order Date first<br/>';
            }
        }

    	if(FormUtil.isEmpty($('#_memCode').val())
  	        && FormUtil.isEmpty($('#_ordNo').val())
  	        && FormUtil.isEmpty($('#_reqstStartDt').val())
  	        && FormUtil.isEmpty($('#_reqstEndDt').val())
    	  )
    	{
        	    isValid = false;
        	    msg += '<spring:message code="sal.alert.msg.selectOrdDate" /><br/>';
    	} else {
    	    if(!FormUtil.isEmpty($('#_reqstStartDt').val()) && !FormUtil.isEmpty($('#_reqstEndDt').val()) ) {
                var sDate = $('#_reqstStartDt').val();
                var eDate = $('#_reqstEndDt').val();

                var dd = "";
                var mm = "";
                var yyyy = "";

                var dateArr;
                dateArr = sDate.split("/");
                var sDt = new Date(Number(dateArr[2]), Number(dateArr[1])-1, Number(dateArr[0]));

                dateArr = eDate.split("/");
                var eDt = new Date(Number(dateArr[2]), Number(dateArr[1])-1, Number(dateArr[0]));

                var dtDiff = new Date(eDt - sDt);
                var days = dtDiff/1000/60/60/24;
                console.log("dayDiff :: " + days);

                if(days > 30) {
                    Common.alert("Pre-Order date range cannot be greater than 30 days.");
                    return false;
                }
            }
    	}

        if(!isValid)
        	Common.alert('<spring:message code="sal.title.text.ordSrch" />' + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

         return isValid;
    }

  //Layer close
    hideViewPopup=function(val){
        $(val).hide();
    }

    function fn_loadOrderSalesman(memCode) {
        Common.ajax("GET", "/sales/order/selectMemberByMemberIDCode.do", {memCode : memCode}, function(memInfo) {
            if(memInfo == null) {
                Common.alert('<b>Member not found.</br>Your input member code : '+memCode+'</b>');
            }
            else {
                $('#_memCode').val(memInfo.memCode);
                $('#_memName').val(memInfo.name);
            }
        });
    }

    function fn_getPreBookingOrderList() {
        Common.ajax("GET", "/sales/order/preBooking/selectPreBookingOrderList.do", $("#_frmPreBookingOrdSrch").serialize(), function(result) {
            AUIGrid.setGridData(listGridID, result);
            AUIGrid.setGridData(excelListGridID, result);
        });
    }

    function fn_PopClose() {
        if(popupObj!=null)
        	popupObj.close();
    }

    function fn_multiCombo(){
        $('#_appTypeId').change(function() {
        }).multipleSelect({
            selectAll: true,
            width: '100%'
        });

        $('#_appTypeId').multipleSelect("checkAll");

        $('#_stusId').change(function() {
        }).multipleSelect({
           selectAll: true,
            width: '100%'
        });

       $('#_stusId').multipleSelect("checkAll");

        $('#_typeId').change(function() {
        }).multipleSelect({
            selectAll: true,
            width: '100%'
        });

        $('#_typeId').multipleSelect("checkAll");

        $('#discountWaive').change(function() {
        }).multipleSelect({
           selectAll: true,
            width: '100%'
        });

       $('#discountWaive').multipleSelect("checkAll");
    }

    $.fn.clearForm = function() {
        return this.each(function() {
            var type = this.type, tag = this.tagName.toLowerCase();

            if (tag === 'form'){
                return $(':input',this).clearForm();
            }

            if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
                this.value = '';
            }else if (type === 'checkbox' || type === 'radio'){
                this.checked = false;
            }else if (tag === 'select'){
                this.selectedIndex = 0;
            }

            if(MEM_TYPE == "1" || MEM_TYPE == "2" || MEM_TYPE == "7" ){
                if("${SESSION_INFO.memberLevel}" =="1"){
                    $("#orgCode").val("${orgCode}");
                    $("#orgCode").attr("class", "w100p readonly");
                    $("#orgCode").attr("readonly", "readonly");
                }else if("${SESSION_INFO.memberLevel}" =="2"){
                    $("#orgCode").val("${orgCode}");
                    $("#orgCode").attr("class", "w100p readonly");
                    $("#orgCode").attr("readonly", "readonly");

                    $("#grpCode").val("${grpCode}");
                    $("#grpCode").attr("class", "w100p readonly");
                    $("#grpCode").attr("readonly", "readonly");
                }else if("${SESSION_INFO.memberLevel}" =="3"){
                    $("#orgCode").val("${orgCode}");
                    $("#orgCode").attr("class", "w100p readonly");
                    $("#orgCode").attr("readonly", "readonly");

                    $("#grpCode").val("${grpCode}");
                    $("#grpCode").attr("class", "w100p readonly");
                    $("#grpCode").attr("readonly", "readonly");

                    $("#deptCode").val("${deptCode}");
                    $("#deptCode").attr("class", "w100p readonly");
                    $("#deptCode").attr("readonly", "readonly");
                }else if("${SESSION_INFO.memberLevel}" =="4"){
                    $("#orgCode").val("${orgCode}");
                    $("#orgCode").attr("class", "w100p readonly");
                    $("#orgCode").attr("readonly", "readonly");

                    $("#grpCode").val("${grpCode}");
                    $("#grpCode").attr("class", "w100p readonly");
                    $("#grpCode").attr("readonly", "readonly");

                    $("#deptCode").val("${deptCode}");
                    $("#deptCode").attr("class", "w100p readonly");
                    $("#deptCode").attr("readonly", "readonly");

                    $("#_memCode").val("${SESSION_INFO.userName}");
                    $("#_memCode").attr("class", "w100p readonly");
                    $("#_memCode").attr("readonly", "readonly");
                    $("#_memBtn").hide();
                }
            }
        });
    };

    function fn_setDetail(gridID, rowIdx){
        Common.popupDiv("/sales/order/preBooking/preBookOrderDetailPop.do", { preBookId : AUIGrid.getCellValue(gridID, rowIdx, "preBookId") }, null, true, "_divPreOrdModPop");
    }

    function fn_cancelPreBookOrderPop() {
        var rowIdx = AUIGrid.getSelectedIndex(listGridID)[0];
        var clickChk = AUIGrid.getSelectedItems(listGridID);
        if (rowIdx > -1) {
            if (clickChk[0].item.stusCode != "CAN") {
                Common.popupDiv("/sales/order/preBooking/preBookOrderReqCancelPop.do", {preBookId : AUIGrid.getCellValue(listGridID,rowIdx, "preBookId")}, null, true, "_divPreOrdModPop");
            } else {
                Common.alert("Pre-Booking Cancellation" + DEFAULT_DELIMITER + "<b>Pre-Booking Order No." + clickChk[0].item.preBookNo + " had been cancelled before.</b>");
            }
        } else {
            Common.alert("Pre-Booking Missing" + DEFAULT_DELIMITER + "<b>No pre-Booking selected.</b>");
        }
    }
</script>

<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	<li>Sales</li>
	<li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<h2>Pre-Booking</h2>
<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
      <!--<a id="_btnConvOrder" href="#">Manual Convert</a>  -->
	 <li><p class="btn_blue"><a id="_btnCancelPreBook" href="#">Order Cancel</a></p></li>
	</c:if>
    <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
	   <li><p class="btn_blue"><a id="_btnNew" href="#">New</a></p></li>
	</c:if>
	<c:if test="${PAGE_AUTH.funcView == 'Y'}">
	   <li><p class="btn_blue"><a id="_btnSearch" href="#"><span class="search"></span>Search</a></p></li>
	   <li><p class="btn_blue"><a id="_btnClear" href="#"><span class="clear"></span>Clear</a></p></li>
	</c:if>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="_frmPreBookingOrdSrch" name="_frmPreBookingOrdSrch" action="#" method="post">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:160px" />
	<col style="width:*" />
	<col style="width:160px" />
	<col style="width:*" />
	<col style="width:160px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Salesman Code</th>
	<td>
		<p><input id="_memCode" name="_memCode" type="text" title="" placeholder="" style="width:80px;" class="" /></p>
		<p><a id="_memBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></p>
		<p><input id="_memName" name="_memName" type="text" title="" placeholder="" style="width:90px;" class="readonly" readonly/></p>
	</td>
	<th scope="row">Application Type</th>
	<td><select id="_appTypeId" name="_appTypeId" class="multy_select w100p" multiple="multiple"></select></td>
	<th scope="row">Pre-Booking Order Date</th>
	<td>
	   <div class="date_set w100p"><!-- date_set start -->
        <p><input id="_reqstStartDt" name="_reqstStartDt" type="text" value="" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
        <span>To</span>
        <p><input id="_reqstEndDt" name="_reqstEndDt" type="text" value="" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
        </div><!-- date_set end -->
    </td>
</tr>
<tr>
	<th scope="row">Pre-Booking Order Status</th>
	<td><select id="_stusId" name="_stusId" class="multy_select w100p" multiple="multiple"></td>
	<th scope="row">NRIC/Company No</th>
	<td><input id="_nric" name="_nric" type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Customer Name</th>
    <td><input id="_name" name="_name" type="text" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
	<th scope="row">Customer Type</th>
	<td><select id="_typeId" name="_typeId" class="multy_select w100p" multiple="multiple"></select></td>
    <th scope="row">Pre-Booking Order No.</th>
    <td><input id="_ordNo" name="_ordNo" type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Time</th>
    <td>
       <div class="date_set w100p">
        <p><input id="_reqstStartTime" name="_reqstStartTime" type="text" value="" title="" placeholder="" class="w100p" maxlength = "4" min = "0000" max = "2300" pattern="\d{4}"  /></p>
        <span>To</span>
        <p><input id="_reqstEndTime" name="_reqstEndTime" type="text" value="" title="" placeholder="" class="w100p" maxlength = "4" min = "0000" max = "2300" pattern="\d{4}" /></p>
        </div>
    </td>
</tr>
<tr>
    <th scope="row">Org Code</th>
    <td><input type="text" title="orgCode" id="orgCode" name="orgCode" placeholder="Org Code" class="w100p" /></td>
    <th scope="row">Grp Code</th>
    <td><input type="text" title="grpCode" id="grpCode" name="grpCode"  placeholder="Grp Code" class="w100p"/></td>
    <th scope="row">Dept Code</th>
    <td><input type="text" title="deptCode" id="deptCode" name="deptCode"  placeholder="Dept Code" class="w100p"/></td>
</tr>
<tr>
     <th scope="row"><spring:message code="sal.text.memtype" /></th>
    <td><select id="memType" name="memType" class="w100p" ></select></td>
    <th scope="row">Entry Point</th>
    <td>
        <select id="entryPoint" name="entryPoint" class="w100p" >
            <option value="">Choose One</option>
            <option value="0">Web</option>
            <option value="1">Mobile Apps</option>
        </select>
    </td>
    <th scope="row">Verification Status</th>
    <td><select id="verifyStatus" name="verifyStatus" class="w100p" >
            <option value="">Choose One</option>
            <option value="ACT">ACT</option>
            <option value="Y">Y</option>
            <option value="N">N</option>
        </select>
     </td>
</tr>
<tr>
    <th scope="row">Pre-Booking Period</th>
    <td><select id="discountWaive" name="discountWaive" class="multy_select w100p" multiple="multiple"></td>
    <th scope="row"></th>
    <td></td>
    <th scope="row"></th>
    <td></td>
</tr>
<tr>
    <th scope="row" colspan="6" ><span class="must"><spring:message code='sales.msg.ordlist.keyinsof'/></span></th>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->
<c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}">
<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" id="excelDown">Generate</a></p></li>
</ul>
</c:if>
</section><!-- search_result end -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="list_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
    <div id="excel_list_grid_wrap" style="display: none;"></div>
</article><!-- grid_wrap end -->

<!---------------------------------------------------------------
    POP-UP (NEW CLAIM)
---------------------------------------------------------------->
<!-- popup_wrap start -->
<div class="popup_wrap" id="updFail_wrap" style="display:none;">
    <!-- pop_header start -->
    <header class="pop_header" id="updFail_pop_header">
        <h1>Update Status</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="hideViewPopup('#updFail_wrap')">CLOSE</a></p></li>
        </ul>
    </header>
    <!-- pop_header end -->

    <!-- pop_body start -->
    <form name="updFailForm" id="updFailForm"  method="post">
    <input id="hiddenPreOrdId" name="preOrdId"   type="hidden"/>
    <input id="hiddenRcdTms" name="rcdTms"   type="hidden"/>
    <input id="hiddenSof" name="sofNo"   type="hidden"/>
    <section class="pop_body">
        <!-- search_table start -->
        <section class="search_table">
            <!-- table start -->
            <table class="type1">
                <caption>table</caption>
                 <colgroup>
                    <col style="width:250px" />
                    <col style="width:*" />
                    <col style="width:250px" />
                    <col style="width:*" />
                </colgroup>

                <tbody>
                <tr>
                    <th scope="row">Customer NRIC</th>
                    <td id="view_custIc"></td>
                </tr>
                <tr>
                     <th scope="row">Action<span class="must">*</span></th>
                     <td colspan="3" ><select ass="mr5" id="_action" name="_action"></select></td>
                 </tr>

                 <tr id="fail_reason" style="display: none;">
                     <th scope="row">Please select fail reason code<span class="must">*</span></th>
                         <td colspan="3" >
                             <label><input type="radio" name="cmbFailCode" value="Incomplete document" /><span>Incomplete document</span></label>
                             <label><input type="radio" name="cmbFailCode" value="Incorrect key-in" /><span>Incorrect key-in</span></label>
                         </td>
                 </tr>
                 <tr id="fail_rem" style="display: none;">
                     <th scope="row"><spring:message code="sal.title.remark" /></th>
                         <td colspan="3" >
                             <textarea cols="20" rows="2" id="_rem_" name="rem" placeholder="Remark"></textarea>
                         </td>
                 </tr>
                </tbody>
            </table>
        </section>

        <ul class="center_btns" >
            <li><p class="btn_blue2"><a id="_btnFailSave" href="#">Save</a></p></li>
        </ul>
    </section>
    </form>
    <!-- pop_body end -->
</div>

</section><!-- content end -->
