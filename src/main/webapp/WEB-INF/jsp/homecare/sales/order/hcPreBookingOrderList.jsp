<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

    var listGridID;
    var excelListGridID;
    var keyValueList = [];
    var MEM_TYPE = '${SESSION_INFO.userTypeId}';
    var CATE_ID  = "14";
    var appTypeData = [{"codeId": "66","codeName": "Rental"},{"codeId": "67","codeName": "Outright"},{"codeId": "68","codeName": "Instalment"},{"codeId": "1412","codeName": "Outright Plus"},{"codeId": "5764","codeName": "Auxiliary"}];
    var actData= [{"codeId": "21","codeName": "Failed"},{"codeId": "10","codeName": "Cancel"}];
    var memTypeData = [{"codeId": "1","codeName": "HP"},{"codeId": "2","codeName": "Cody"},{"codeId": "4","codeName": "Staff"},{"codeId": "7","codeName": "HT"}];
    var preBookPeriod = [{"codeId": "4","codeName": "4M Earlier"},{"codeId": "3","codeName": "3M Earlier"},{"codeId": "2","codeName": "2M Earlier"},{"codeId": "1","codeName": "1M Earlier"}];
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

    var branchCdList = [];
    <c:forEach var="obj" items="${branchCdList}">
    branchCdList.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
    </c:forEach>

    var codeList_8 = [];
    <c:forEach var="obj" items="${codeList_8}">
    codeList_8.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
    </c:forEach>

    var productList = [];
    <c:forEach var="obj" items="${productList_1}">
    productList.push({codeId:"${obj.code}", codeName:"${obj.codeName}", code:"${obj.code}"});
    </c:forEach>

    $(document).ready(function(){
        fn_statusCodeSearch();
        //AUIGrid
        createAUIGrid();
        createExcelAUIGrid();

        if(MEM_TYPE == "1" || MEM_TYPE == "2" || MEM_TYPE == "7" ){
            if("${SESSION_INFO.memberLevel}" =="1") {
                $("#orgCode").val("${orgCode}");
                $("#orgCode").attr("class", "w100p readonly");
                $("#orgCode").attr("readonly", "readonly");
            } else if("${SESSION_INFO.memberLevel}" =="2") {
                $("#orgCode").val("${orgCode}");
                $("#orgCode").attr("class", "w100p readonly");
                $("#orgCode").attr("readonly", "readonly");

                $("#grpCode").val("${grpCode}");
                $("#grpCode").attr("class", "w100p readonly");
                $("#grpCode").attr("readonly", "readonly");
            } else if("${SESSION_INFO.memberLevel}" =="3") {
                $("#orgCode").val("${orgCode}");
                $("#orgCode").attr("class", "w100p readonly");
                $("#orgCode").attr("readonly", "readonly");

                $("#grpCode").val("${grpCode}");
                $("#grpCode").attr("class", "w100p readonly");
                $("#grpCode").attr("readonly", "readonly");

                $("#deptCode").val("${deptCode}");
                $("#deptCode").attr("class", "w100p readonly");
                $("#deptCode").attr("readonly", "readonly");
            } else if("${SESSION_INFO.memberLevel}" =="4") {
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
            // console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
            selectRowIdx = event.rowIndex;
        });

        AUIGrid.bind(listGridID, "cellDoubleClick", function(event) {
            fn_setDetail(listGridID, selectRowIdx);
        });

        doDefCombo(appTypeData, '' ,'_appTypeId', 'M', 'fn_multiCombo');
        doDefCombo(preBookPeriod, '' ,'_preBookPeriod', 'M', 'fn_multiCombo');
        //doDefCombo(actData, '' ,'_action', 'S', '');
        doGetComboData('/status/selectStatusCategoryCdList.do', {selCategoryId : CATE_ID, parmDisab : 0}, '', '_preStusId', 'M', 'fn_multiCombo');
        //doGetComboSepa('/common/selectBranchCodeList.do',  '10', ' - ', '', '_preBrnchId', 'M', 'fn_multiCombo'); //Branch Code
        //doDefCombo(codeList_8, '' ,'_preTypeId', 'M', 'fn_multiCombo');

       /*  if (memTypeFiltered) {
            doDefComboAndMandatory(memTypeData, '', 'memType', 'S', '');
        } else {
            doDefCombo(memTypeData, '', 'memType', 'S', '');
        } */

        //excel Download
        $('#excelDown').click(function() {
            var excelProps = {
                fileName     : "Pre-Booking Order List",
               exceptColumnFields : AUIGrid.getHiddenColumnDataFields(excelListGridID)
            };
            AUIGrid.exportToXlsx(excelListGridID, excelProps);
        });

    });

    function fn_multiCombo2(){

    }

    function fn_statusCodeSearch(){
        Common.ajaxSync("GET", "/status/selectStatusCategoryCdList.do", {selCategoryId : CATE_ID, parmDisab : 0}, function(result) {
            keyValueList = result;
        });
    }

    function fn_setOptGrpClass() {
        $("optgroup").attr("class" , "optgroup_text")
    }

    function createAUIGrid() {
        //AUIGrid
        var columnLayout = [
          { headerText : "Pre-Booking Order No.", dataField : "preBookNo", editable : false, width : '12%'}
          , { headerText : "Status", dataField : "stusCode", editable : false, width : '5%'}
          , { headerText : "Pre-Booking Save Date", dataField : "preBookDt", editable : false, width : '12%'}
          , { headerText : "Customer Verfification Status", dataField : "custVerifyStus", editable : false, width : '8%'}
          , { headerText : "Sales Persom Code", dataField : "memCode", editable : false, width : '12%'}
          , { headerText : "Customer Info", dataField : "custName", editable : false, width : '15%'}
          , { headerText : "Previous Product Model", dataField : "prevStkDesc", editable : false, width : '15%'}
          , { headerText : "Previous Product Order No", dataField : "salesOrdNo", editable : false, width : '15%'}
          , { headerText : "Product Interested", dataField : "stkDesc", editable : false, width : '15%'}
          , { headerText : "Pre-Booking Period", dataField : "discWaive", editable : false, width : '15%'}
          , { headerText : "preBookId",dataField : "preBookId", visible  : false}
          , { headerText : "stusId",dataField : "stusId", visible  : false}
        ];

        var gridPros = {
            usePaging : true,
            pageRowCount : 20,
            editable : false,
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
           { headerText : "Pre-Booking Order No.", dataField : "preBookNo", editable : false, width : 200}
          , { headerText : "Status", dataField : "stusCode", editable : false, width : 200}
          , { headerText : "Pre-Booking Save Date", dataField : "preBookDt", editable : false, width : 200}
          , { headerText : "Customer Verfification Status", dataField : "custVerifyStus", editable : false, width : 200}
          , { headerText : "Sales Persom Code", dataField : "memCode", editable : false, width : 200}
          , { headerText : "Customer Info", dataField : "custName", editable : false, width : 300}
          , { headerText : "Previous Product Model", dataField : "prevStkDesc", editable : false, width : 200}
          , { headerText : "Previous Product Order No", dataField : "salesOrdNo", editable : false, width : 200}
          , { headerText : "Product Interested", dataField : "stkDesc", editable : false, width : 200}
          , { headerText : "Pre-Booking Period", dataField : "discWaive", editable : false, width : 200}

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
            Common.ajax("GET", "/sales/order/checkRC.do", "", function(memRc){
                if(memRc != null) {
                    if(memRc.rookie == 1) {
                        if(memRc.rcPrct < 50) {
                            Common.alert(memRc.name + " (" + memRc.memCode + ") is not allowed to key in due to Individual SHI below 50%.");
                            return false;
                        }
                    } else {
                        Common.alert(memRc.name + " (" + memRc.memCode + ") is still a rookie, no key in is allowed.");
                        return false;
                    }
                }

                // 20190925 KR-OHK Moblie Popup Setting
                if(Common.checkPlatformType() == "mobile") {
                    popupObj = Common.popupWin("frmNew", "/homecare/sales/order/hcPreBookOrderRegisterPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "yes"});
                } else{
                    Common.popupDiv("/homecare/sales/order/hcPreBookOrderRegisterPop.do", null, null, true, '_divPreOrdRegPop');
                }

            });
        });
        $('#_btnClear').click(function() {
            $('#_frmPreOrdSrch').clearForm();
        });

        $('#_btnSearch').click(function() {
            if(fn_validSearchList()) fn_getPreBookOrderList();
        });

        $('#_btnCancelPreBook').click(function() {
            fn_cancelPreBookOrderPop();
        });

        $('#_memBtn').click(function() {
            Common.popupDiv("/common/memberPop.do", $("#_frmPreOrdSrch").serializeJSON(), null, true);
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


    });

    function fn_validSearchList() {
        var isValid = true, msg = "";

        if(FormUtil.isEmpty($('#_memCode').val())
        	&& FormUtil.isEmpty($('#_appTypeId').val())
        	&& FormUtil.isEmpty($('#_preStusId').val())
        	&& FormUtil.isEmpty($('#_preBookPeriod').val())
            && FormUtil.isEmpty($('#_nric').val())
            && FormUtil.isEmpty($('#_name').val()) && (FormUtil.isEmpty($('#_reqstStartDt').val())
            || FormUtil.isEmpty($('#_reqstEndDt').val()))) {

            if((!FormUtil.isEmpty($('#_reqstStartDt').val()) && FormUtil.isEmpty($('#_reqstEndDt').val()))
            	|| (FormUtil.isEmpty($('#_reqstStartDt').val()) && !FormUtil.isEmpty($('#_reqstEndDt').val()))) {
                isValid = false;
                msg += '<spring:message code="sal.alert.msg.selectOrdDate" /><br/>';
            }

        }

        if(!FormUtil.isEmpty($('#_reqstStartTime').val()) || !FormUtil.isEmpty($('#_reqstEndTime').val())) {
            if(FormUtil.isEmpty($('#_reqstStartDt').val()) || FormUtil.isEmpty($('#_reqstEndDt').val())) {
                isValid = false;
                msg += '* Please select Pre-Booking Order Date first<br/>';
            }
        }

        if(!isValid) Common.alert('<spring:message code="sal.title.text.ordSrch" />' + DEFAULT_DELIMITER + "<b>"+msg+"</b>");
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
            } else {
                $('#_memCode').val(memInfo.memCode);
                $('#_memName').val(memInfo.name);
            }
        });
    }



    function fn_getPreBookOrderList() {
        Common.ajax("GET", "/homecare/sales/order/selectHcPreBookOrderList.do", $("#_frmPreOrdSrch").serialize(), function(result) {
            AUIGrid.setGridData(listGridID, result);
            AUIGrid.setGridData(excelListGridID, result);
        });
    }

    function fn_PopClose() {
        if(popupObj!=null) popupObj.close();
    }

    function fn_multiCombo(){
        $('#_appTypeId').change(function() {
        }).multipleSelect({
            selectAll: true,
            width: '100%'
        });
        $('#_appTypeId').multipleSelect("checkAll");

        $('#_preBookPeriod').change(function() {
        }).multipleSelect({
            selectAll: true,
            width: '100%'
        });
        $('#_preBookPeriod').multipleSelect("checkAll");

        $('#_preStusId').change(function() {
        }).multipleSelect({
            selectAll: true,
            width: '100%'
        });
        $('#_preStusId').multipleSelect("checkAll");
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
                if("${SESSION_INFO.memberLevel}" =="1") {
                    $("#orgCode").val("${orgCode}");
                    $("#orgCode").attr("class", "w100p readonly");
                    $("#orgCode").attr("readonly", "readonly");

                } else if("${SESSION_INFO.memberLevel}" =="2") {
                    $("#orgCode").val("${orgCode}");
                    $("#orgCode").attr("class", "w100p readonly");
                    $("#orgCode").attr("readonly", "readonly");

                    $("#grpCode").val("${grpCode}");
                    $("#grpCode").attr("class", "w100p readonly");
                    $("#grpCode").attr("readonly", "readonly");

                } else if("${SESSION_INFO.memberLevel}" =="3") {
                    $("#orgCode").val("${orgCode}");
                    $("#orgCode").attr("class", "w100p readonly");
                    $("#orgCode").attr("readonly", "readonly");

                    $("#grpCode").val("${grpCode}");
                    $("#grpCode").attr("class", "w100p readonly");
                    $("#grpCode").attr("readonly", "readonly");

                    $("#deptCode").val("${deptCode}");
                    $("#deptCode").attr("class", "w100p readonly");
                    $("#deptCode").attr("readonly", "readonly");

                } else if("${SESSION_INFO.memberLevel}" =="4") {
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
        Common.popupDiv("/homecare/sales/order/hcPreBookOrderDetailPop.do", { preBookId : AUIGrid.getCellValue(gridID, rowIdx, "preBookId") }, null, true, "_divPreOrdModPop");
    }


	function fn_cancelPreBookOrderPop() {
		var rowIdx = AUIGrid.getSelectedIndex(listGridID)[0];
		var clickChk = AUIGrid.getSelectedItems(listGridID);
		if (rowIdx > -1) {
			if (clickChk[0].item.stusCode != "CAN") {
				Common.popupDiv("/homecare/sales/order/hcPreBookOrderReqCancelPop.do", {preBookId : AUIGrid.getCellValue(listGridID,rowIdx, "preBookId")}, null, true, "_divPreOrdModPop");
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
<h2>Pre-Booking (HC)</h2>
<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
       <li><p class="btn_blue"><a id="_btnCancelPreBook" href="#">Pre-Booking Cancel</a></p></li>
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
<form id="frmNew" name="frmNew" action="#" method="post">
</form>
<section class="search_table"><!-- search_table start -->
<form id="_frmPreOrdSrch" name="_frmPreOrdSrch" action="#" method="post" autocomplete=off>
<!-- <input id="callPrgm" name="callPrgm" value="PRE_ORD" type="hidden" /> -->
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
    <th scope="row">SalesMan Code</th>
    <td>
        <p><input id="_memCode" name="_memCode" type="text" title="" placeholder="" style="width:80px;" class="" /></p>
        <p><a id="_memBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></p>
        <p><input id="_memName" name="_memName" type="text" title="" placeholder="" style="width:120px;" class="readonly" readonly/></p>
    </td>
    <th scope="row">Application Type</th>
    <td><select id="_appTypeId" name="_appTypeId" class="multy_select w100p" multiple="multiple"></select></td>
    <th scope="row">Pre-Booking Order date</th>
    <td>
       <div class="date_set w100p"><!-- date_set start -->
        <p><input id="_reqstStartDt" name="_reqstStartDt" type="text" <%-- value="${fromDay}" --%> title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
        <span>To</span>
        <p><input id="_reqstEndDt" name="_reqstEndDt" type="text" <%-- value="${toDay}" --%> title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
        </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row">Pre-Booking Order Status</th>
    <td><select id="_preStusId" name="_preStusId" class="multy_select w100p" multiple="multiple"></select></td>
    <th scope="row">NRIC/Company No</th>
    <td><input id="_nric" name="_nric" type="text" title="" placeholder="" class="w100p" /></td>
        <th scope="row">Pre-Booking Time</th>
    <td>
       <div class="date_set w100p">
        <p><input id="_reqstStartTime" name="_reqstStartTime" type="text" value="" title="" placeholder="" class="w100p" maxlength = "4" min = "0000" max = "2300" pattern="\d{4}"  /></p>
        <span>To</span>
        <p><input id="_reqstEndTime" name="_reqstEndTime" type="text" value="" title="" placeholder="" class="w100p" maxlength = "4" min = "0000" max = "2300" pattern="\d{4}" /></p>
        </div>
    </td>
</tr>
<tr>
        <th scope="row">Pre-Booking Order No.</th>
    <td><input id="_ordNo" name="_ordNo" type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Customer Name</th>
    <td><input id="_name" name="_name" type="text" title="" placeholder="" class="w100p" /></td>
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
<th scope="row">Pre-Booking Period</th>
    <td><select id="_preBookPeriod" name="_preBookPeriod" class="multy_select w100p" multiple="multiple"></select></td>
</tr>

<tr>
    <%-- <th scope="row" colspan="6" ><span class="must"><spring:message code='sales.msg.ordlist.keyinsof'/></span></th> --%>
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

</section><!-- content end -->
