<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

    var listGridID;
    var excelListGridID;
    var keyValueList = [];
    var MEM_TYPE = '${SESSION_INFO.userTypeId}';
    var CATE_ID  = "14";
    var appTypeData = [{"codeId": "66","codeName": "Rental"},{"codeId": "67","codeName": "Outright"},{"codeId": "68","codeName": "Instalment"},{"codeId": "5764","codeName": "Auxiliary"}];
    var actData= [{"codeId": "21","codeName": "Failed"},{"codeId": "10","codeName": "Cancel"},{"codeId": "133","codeName": "Non Coverage Area"}];
    var memTypeData = [{"codeId": "1","codeName": "HP"},{"codeId": "2","codeName": "Cody"},{"codeId": "4","codeName": "Staff"},{"codeId": "7","codeName": "HT"}];
    var myFileCaches = {};
    var recentGridItem = null;
    var selectRowIdx;
    var popupObj;
/*     var ProudctList = [];
    <c:forEach var="obj" items="${productList_1}">
    productList.push({codeId:"${obj.code}", codeName:"${obj.codeName}", code:"${obj.code}"});
    </c:forEach>
 */
    var brnchType = "${branchType}";
    var memTypeFiltered = false;
    if (brnchType == 45) {
        memTypeData = memTypeData.filter(d => d.codeId == "1")
        memTypeFiltered = true;
    } else if (brnchType == 42 || brnchType == 48) {
    	let data = memTypeData.filter(d => d.codeId == "2" || d.codeId == "7")
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
        //AUIGrid 그리드를 생성합니다.
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

        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(listGridID, "cellDoubleClick", function(event) {
            fn_setDetail(listGridID, selectRowIdx);
        });

        doDefCombo(appTypeData, '' ,'_appTypeId', 'M', 'fn_multiCombo');
        doDefCombo(actData, '' ,'_action', 'S', '');

        doGetComboData('/status/selectStatusCategoryCdList.do', {selCategoryId : CATE_ID, parmDisab : 0}, '', '_stusId', 'M', 'fn_multiCombo');
//         doDefCombo(branchCdList, '' ,'_brnchId', 'M', 'fn_multiCombo');
        doGetComboSepa('/common/selectBranchCodeList.do',  '10', ' - ', '', '_brnchId', 'M', 'fn_multiComboBranch'); //Branch Code
        doDefCombo(codeList_8, '' ,'_typeId', 'M', 'fn_multiCombo');
        if (memTypeFiltered) {
            doDefComboAndMandatory(memTypeData, '', 'memType', 'S', '');
        } else {
            doDefCombo(memTypeData, '', 'memType', 'S', '');
        }
       // doDefCombo(productList, '' ,'_ordProudctList', 'M', 'fn_multiCombo');
       //doGetComboAndGroup2('/common/selectProductCodeList.do', {selProdGubun: 'HC'}, '', '_ordProudctList', 'S', 'fn_multiCombo2');
       doDefCombo(productList, '' ,'_ordProudctList', 'M', 'fn_multiCombo2');
 //       doGetComboAndGroup2 ('/common/selectProductCodeList.do', {selProdGubun: 'HC'}, '', '_ordProudctList', 'S','fn_multiCombo2', 'fn_setOptGrpClass');
         doGetComboSepa('/homecare/selectHomecareDscBranchList.do',  '', ' - ', '',   'listDscBrnchId', 'M', 'fn_multiCombo2'); //Branch Code
//         doGetComboData('/status/selectStatusCategoryCdList.do', {selCategoryId : CATE_ID, parmDisab : 0}, '', '_stusId', 'M', 'fn_multiCombo');
//         doGetComboSepa('/common/selectBranchCodeList.do',  '1', ' - ', '', '_brnchId', 'M', 'fn_multiCombo'); //Branch Code
//         doGetComboOrder('/common/selectCodeList.do', '8', 'CODE_ID', '', '_typeId', 'M', 'fn_multiCombo'); //Common Code

        //excel Download
        $('#excelDown').click(function() {
            var excelProps = {
                fileName     : "eKey-in",
               exceptColumnFields : AUIGrid.getHiddenColumnDataFields(excelListGridID)
            };
            AUIGrid.exportToXlsx(excelListGridID, excelProps);
        });

    });

    function fn_multiCombo2(){
            $('#listDscBrnchId').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        });

            $('#_ordProudctList').change(function() {
            }).multipleSelect({
                selectAll: true, // 전체선택
                width: '100%'
            });

           $('#_ordProudctList').multipleSelect("checkAll");
         //  $('#listDscBrnchId').multipleSelect("checkAll"); --remove the select all checkbox in dropdown list to fix unable to search issue on 03052024
    }

    function fn_multiComboBranch(){
      if ($("#_brnchId option[value='${SESSION_INFO.userBranchId}']").val() === undefined) {
            $('#_brnchId').change(function() {
                //console.log($(this).val());
            }).multipleSelect({
                selectAll: true, // 전체선택
                width: '100%'
            }).multipleSelect("enable");
           //$('#_brnchId').multipleSelect("checkAll"); --remove the select all checkbox in dropdown list to fix unable to search issue on 03052024
       } else {
          if ("${PAGE_AUTH.funcUserDefine5}" == "Y") {
              $('#_brnchId').change(function() {
                  //console.log($(this).val());
              }).multipleSelect({
                  selectAll: true, // 전체선택
                  width: '100%'
              }).multipleSelect("enable");
           //  $('#_brnchId').multipleSelect("checkAll"); --remove the select all checkbox in dropdown list to fix unable to search issue on 03052024
          } else {
            $('#_brnchId').change(function() {
                //console.log($(this).val());
            }).multipleSelect({
                selectAll: true, // 전체선택
                width: '100%'
            }).multipleSelect("disable");
            $("#_brnchId").multipleSelect("setSelects", ['${SESSION_INFO.userBranchId}']);
          }
        }
    }


    function fn_statusCodeSearch(){
        Common.ajaxSync("GET", "/status/selectStatusCategoryCdList.do", {selCategoryId : CATE_ID, parmDisab : 0}, function(result) {
            keyValueList = result;
        });
    }

    function fn_setDetail(gridID, rowIdx){
        Common.popupDiv("/homecare/sales/order/hcPreOrderModifyPop.do", { preOrdId : AUIGrid.getCellValue(gridID, rowIdx, "preOrdId") }, null, true, "_divPreOrdModPop");
    }

    function fn_setOptGrpClass() {
        $("optgroup").attr("class" , "optgroup_text")
    }

    function fn_validStatus() {
        var isValid = true;
        if(selectRowIdx > -1) {
            var stusId    = AUIGrid.getCellValue(listGridID, selectRowIdx, "stusId");
            var preOrdId = AUIGrid.getCellValue(listGridID, selectRowIdx, "preOrdId");
            var sofNo     = AUIGrid.getCellValue(listGridID, selectRowIdx, "sofNo");
            var custNric  = AUIGrid.getCellValue(listGridID, selectRowIdx, "nric");
            var rcdTms = AUIGrid.getCellValue(listGridID, selectRowIdx, "updDt");

            $('#hiddenPreOrdId').val(preOrdId);
            $('#hiddenRcdTms').val(rcdTms);
            $('#hiddenSof').val(sofNo);
            $('#view_sofNo').text(sofNo);
            $('#view_custIc').text(custNric);

            if(stusId == 4 || stusId == 10 || stusId == 133){
                Common.alert("Completed eKey-in cannot be edited.");
                isValid = false;
            }

            var isBlackArea = AUIGrid.getCellValue(listGridID, selectRowIdx, "instStatus");
            if(isBlackArea == "Yes"){
               $('#_action').val("133").attr('selected','selected');
               $('#_action').attr('disabled','disabled').addClass("disabled");
             }
        } else {
           Common.alert("Pre-Order Missing" + DEFAULT_DELIMITER + "<b>No pre-order selected.</b>");
           isValid = false;
        }

        return isValid;
    }

    function fn_doFailStatus(){
        var action = $('#_action option:selected').val().trim();
        var name = $('#_action option:selected').text();
        var sof = $('#hiddenSof').val();

        var preOrdId = AUIGrid.getCellValue(listGridID, selectRowIdx, "preOrdId");
        var rcdTms = AUIGrid.getCellValue(listGridID, selectRowIdx, "updDt");

        if(action == "" ){
            Common.alert("Please select action");
            return;
        }

        if(action == 21 && ($('input[name=cmbFailCode]:checked').val() == null || $('#_rem_').val() == null) ){
            Common.alert("Please select Reason Code and key in Remark");
            return;
        }

        var failUpdOrd = {
                failCode  : $('input[name=cmbFailCode]:checked').val(),
                remark    : $('#_rem_').val(),
                sof         : sof,
                preOrdId : $('#hiddenPreOrdId').val(),
                stusId     : action
        };

        Common.confirm("Confirm to " + name + " SOF : " + sof  + " ? " , function(){

        	Common.ajaxSync("GET", "/sales/order/selRcdTms.do", $("#updFailForm").serialize(), function(result) {
                if(result.code == "99"){
                    Common.alert("Save Pre-Order Summary" + DEFAULT_DELIMITER + "<b>"+ result.message +"</b>", function(){
                        hideViewPopup('#updFail_wrap');
                        fn_getPreOrderList();
                    });
                }else{
                    Common.ajax("POST", "/homecare/sales/order/updateHcPreOrderStatus.do", failUpdOrd, function(result) {
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
        fn_getPreOrderList();
        $('#updFail_wrap').hide();
        $('#updFailForm').clearForm();
    }

    function createAUIGrid() {

        //AUIGrid 칼럼 설정
        var columnLayout = [
            {headerText : "BNDL No.",             dataField : "bndlNo",         editable : false, width : '7%'}
          , {headerText : "SOF No.",                dataField : "sofNo",           editable : false, width : '7%'}
          , {headerText : "eKey-in Date",          dataField : "requestDt",      editable : false, width : '8%'}
          , {headerText : "eKey-in Entry Point",  dataField : "channel",  editable : false, width : '10%' }
          , {headerText : "Application Type",        dataField : "appType",    editable : false, width : 80  }
          , {headerText : "eKey-in Time",          dataField : "requestTm",    editable : false, width : '8%'}
          , { headerText : "DT Branch",  dataField : "dtBranch",  editable : false, width : '10%' }
          , {headerText : "Product",                 dataField : "product",        editable : false, width : '12%'}
          , {headerText : "Customer Name",     dataField : "custNm",         editable : false, width : '15%'}
          , {headerText : "Creator",                  dataField : "crtName",       editable : false, width : '8%'}
          , {headerText : "Status",                   dataField : "stusName",      editable : false, width : '8%'}
          , {headerText : "Order Number",       dataField : "salesOrdNo",    editable : false, width : '10%'}
          , { headerText : "Cody User Branch",  dataField : "branchName",  editable : false, width:300}
          , { headerText : "Region", dataField : "regionName",   editable : false,width:200}
          , {headerText : "Fail Reason Code",    dataField : "rem1",            editable : false,  width : '10%'}
          , {headerText : "Fail Remark",            dataField : "rem2",            editable : false,  width : '15%'}
          , {headerText : "Last Update At (By)", dataField : "lastUpd",         editable : false,  width : '18%'}
          , {headerText : "Installation State",    dataField : "state",            editable : false,  width: '15%'}
          , {headerText : "StatusId",                 dataField : "stusId",           visible  : false}
          , {headerText : "preOrdId",               dataField : "preOrdId",       visible  : false}
          , {headerText : "updDt",                  dataField : "updDt",   visible : false}
          ,{ headerText : "Blacklisted Area", dataField: "instStatus", editable : false, width : '10%'}
        ];

        //그리드 속성 설정
        var gridPros = {
            usePaging                 : true,         //페이징 사용
            pageRowCount          : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
            editable                    : false,
            fixedColumnCount      : 1,
            showStateColumn       : false,
            displayTreeOpen        : false,
            headerHeight             : 30,
            useGroupingPanel       : false,        //그룹핑 패널 사용
            skipReadonlyColumns  : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove     : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn  : true,         //줄번호 칼럼 렌더러 출력
            noDataMessage          : "No order found.",
            wordWrap                  : true,
            groupingMessage       : "Here groupping"
        };

        listGridID = GridCommon.createAUIGrid("list_grid_wrap", columnLayout, "", gridPros);
    }

    function createExcelAUIGrid() {

        //AUIGrid 칼럼 설정
        var excelColumnLayout = [
           { headerText : "eKey-in Date",  dataField : "requestDt",  editable : false, width:100}
          , { headerText : "SOF No.",         dataField : "sofNo",      editable : false, width:100}
          , { headerText : "eKey-in Time",  dataField : "requestTm",  editable : false, width:100}
          , { headerText : "eKey-in Entry Point",  dataField : "channel",  editable : false, width:100}
          , { headerText : "Order Number", dataField : "salesOrdNo",       editable : false, width:100}
          , { headerText : "Status",          dataField : "stusName",     editable : false,width:150}
          , { headerText : "PV Month", dataField : "pvMonth",   editable : false,width:200}
          , { headerText : "PV Month", dataField : "pvYear",   editable : false,width:200}
          , { headerText : "Customer Name",   dataField : "custNm",     editable : false,width:300}
          , { headerText : "Area",             dataField : "area",     editable : false,width:450}
          , { headerText : "Posting Branch",             dataField : "soBrnchCode",     editable : false,width:100}
          , { headerText : "Doc Submit",             dataField : "docSubmit",     editable : false,width:100}
          , { headerText : "Submit Branch",             dataField : "submitBranch",     editable : false,width:100}
          , { headerText : "Branch Location",             dataField : "branchLocation",     editable : false,width:300}
          , { headerText : "Product",         dataField : "product",    editable : false,width:450}
          , { headerText : "Promo Code", dataField : "promoCode",   editable : false,width:200}
          , { headerText : "Promotion Description ", dataField : "promoDesc",   editable : false,width:400}
          , { headerText : "Fail Reason Code", dataField : "rem1",     editable : false,width:500}
          , { headerText : "Fail Remark",         dataField : "rem2",     editable : false,width:750}
          , { headerText : "Sales By", dataField : "salesUserId",   editable : false,width:100}
          , { headerText : "Creator",         dataField : "crtName",   editable : false,width:100}
          , { headerText : "Cody User Branch",  dataField : "branchName",  editable : false, width:300}
          , { headerText : "Region", dataField : "regionName",   editable : false,width:200}
          , { headerText : "HP Name", dataField : "hpName",   editable : false,width:400}
          , { headerText : "Organization Code", dataField : "orgCode",   editable : false,width:200}
          , { headerText : "Group Code", dataField : "grpCode",   editable : false,width:200}
          , { headerText : "Dept Code", dataField : "deptCode",   editable : false,width:200}
          , { headerText : "Last Update At (By)", dataField : "lastUpd",   editable : false,width:400}
          , { headerText : "Installation State", dataField : "state",  editable : false, width : 300}
          ,{ headerText : "Blacklisted Area", dataField: "instStatus", editable : false, width: 200}
        ];

        //그리드 속성 설정
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
                    popupObj = Common.popupWin("frmNew", "/homecare/sales/order/hcPreOrderRegisterPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "yes"});
                } else{
                    Common.popupDiv("/homecare/sales/order/hcPreOrderRegisterPop.do", null, null, true, '_divPreOrdRegPop');
                }

            });
        });
        $('#_btnClear').click(function() {
            $('#_frmPreOrdSrch').clearForm();
        });
        $('#_btnSearch').click(function() {
            if(fn_validSearchList()) fn_getPreOrderList();
        });
        $('#_btnConvOrder').click(function() {
            fn_convToOrderPop();
        });
        $('#_btnFail').click(function() {
            if(fn_validStatus()){
            	if(MEM_TYPE == "1" || MEM_TYPE == "2" || MEM_TYPE == "7" ){
                    $('#_action').val("10").attr('selected','selected');
                    $('#_action').attr('disabled','disabled').addClass("disabled");
                }
                $('#updFail_wrap').show();
            }
        });
        $('#_btnFailSave').click(function() {
            fn_doFailStatus();
        });
        $('#_memBtn').click(function() {
            //Common.searchpopupWin("searchForm", "/common/memberPop.do","");
            Common.popupDiv("/common/memberPop.do", $("#_frmPreOrdSrch").serializeJSON(), null, true);
        });
        $('#_memCode').change(function(event) {
            var memCd = $('#_memCode').val().trim();

            if(FormUtil.isNotEmpty(memCd)) {
                fn_loadOrderSalesman(memCd);
            }
        });
        $('#_memCode').keydown(function (event) {
            if (event.which === 13) {    //enter
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
    });

    function fn_validSearchList() {
        var isValid = true, msg = "";

        if(FormUtil.isEmpty($('#_memCode').val())
        	&& FormUtil.isEmpty($('#_appTypeId').val())
        	&& FormUtil.isEmpty($('#_stusId').val()) && FormUtil.isEmpty($('#_brnchId').val())
            && FormUtil.isEmpty($('#_typeId').val())
            && FormUtil.isEmpty($('#_nric').val())
            && FormUtil.isEmpty($('#_name').val()) && (FormUtil.isEmpty($('#_reqstStartDt').val())
            || FormUtil.isEmpty($('#_reqstEndDt').val()))) {

            if((!FormUtil.isEmpty($('#_reqstStartDt').val()) && FormUtil.isEmpty($('#_reqstEndDt').val()))
            	|| (FormUtil.isEmpty($('#_reqstStartDt').val()) && !FormUtil.isEmpty($('#_reqstEndDt').val()))) {
                isValid = false;
                msg += '<spring:message code="sal.alert.msg.selectOrdDate" /><br/>';
            }
            if(FormUtil.isEmpty($('#_sofNo').val())){
                isValid = false;
                msg += '<spring:message code="sal.alert.msg.selSofNo" /><br/>';
            }
        }

        if(!FormUtil.isEmpty($('#_reqstStartTime').val()) || !FormUtil.isEmpty($('#_reqstEndTime').val())) {
            if(FormUtil.isEmpty($('#_reqstStartDt').val()) || FormUtil.isEmpty($('#_reqstEndDt').val())) {
                isValid = false;
                msg += '* Please select Pre-Order Date first<br/>';
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

    // Click - Convert Order Button
    function fn_convToOrderPop() {
        var selIdx = AUIGrid.getSelectedIndex(listGridID)[0];

        if(selIdx > -1) {
            var stusId = AUIGrid.getCellValue(listGridID, selIdx, "stusId");
            var salesOrdNo = AUIGrid.getCellValue(listGridID, selIdx, "salesOrdNo");

            if(stusId == 10 || stusId == 4 || salesOrdNo != undefined ){
                Common.alert("Convert order is not allowed for this pre-order");
            } else {
                var memCode = AUIGrid.getCellValue(listGridID, selIdx, "crtName");

                Common.ajax("GET", "/sales/order/checkRC.do", {memCode : memCode}, function(memRc) {
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

                    var isBlackArea = AUIGrid.getCellValue(listGridID, selIdx, "instStatus");
                    if(isBlackArea == 'Yes'){
                        Common.alert("The area is not under coverage for the product categories. Convert Order is not allow.");
                        return false;
                    }

                    Common.popupDiv("/homecare/sales/order/convertToHcOrderPop.do", { preOrdId : AUIGrid.getCellValue(listGridID, selIdx, "preOrdId") }, null , true);

                });
            }
        }else {
                Common.alert("Pre-Order Missing" + DEFAULT_DELIMITER + "<b>No pre-order selected.</b>");
        }
    }

    function fn_getPreOrderList() {
        Common.ajax("GET", "/homecare/sales/order/selectHcPreOrderList.do", $("#_frmPreOrdSrch").serialize(), function(result) {
            AUIGrid.setGridData(listGridID, result);
            AUIGrid.setGridData(excelListGridID, result);
        });
    }

    function fn_PopClose() {
        if(popupObj!=null) popupObj.close();
    }

    function fn_calcGst(amt) {
        var gstAmt = 0;
        if(FormUtil.isNotEmpty(amt) || amt != 0) {
            gstAmt = Math.floor(amt*(1/1.06));
        }
        return gstAmt;
    }

    function fn_multiCombo(){
        $('#_appTypeId').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        });
        $('#_appTypeId').multipleSelect("checkAll");

        $('#_stusId').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        });
        $('#_stusId').multipleSelect("checkAll");

        var maxBranches = 25;

        /*$('#_brnchId').change(function() {
            var selectedBranches = $(this).multipleSelect('getSelects');

            if (selectedBranches.length > maxBranches) {
                // Alert the user if they select more than the allowed number of branches
                Common.alert('Please select only ' + maxBranches + ' branch(es) only.');
                window.location.reload();
            }
        }).multipleSelect({
            selectAll: false, // Disable the "Select All" option
            width: '100%'
        });*/

        $('#_typeId').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        });
        $('#_typeId').multipleSelect("checkAll");
/*
        $('#_ordProudctList').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        });
        $("#_ordProudctList").multipleSelect("checkAll"); */

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

</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<h2>eKey-in (HC)</h2>
<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
       <li><p class="btn_blue"><a id="_btnConvOrder" href="#">Convert Order</a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
        <li><p class="btn_blue"><a id="_btnFail" href="#">Update Status</a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
       <li><p class="btn_blue"><a id="_btnNew" href="#">NEW</a></p></li>
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
<input id="pdpaMonth" name="pdpaMonth" type="hidden" value='${PAGE_AUTH.pdpaMonth}'/>
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
        <p><input id="_memName" name="_memName" type="text" title="" placeholder="" style="width:90px;" class="readonly" readonly/></p>
    </td>
    <th scope="row">Application Type</th>
    <td><select id="_appTypeId" name="_appTypeId" class="multy_select w100p" multiple="multiple"></select></td>
    <th scope="row">Pre-Order date</th>
    <td>
       <div class="date_set w100p"><!-- date_set start -->
        <p><input id="_reqstStartDt" name="_reqstStartDt" type="text" <%-- value="${fromDay}" --%> title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
        <span>To</span>
        <p><input id="_reqstEndDt" name="_reqstEndDt" type="text" <%-- value="${toDay}" --%> title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
        </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row">Pre-Order Status</th>
    <td><select id="_stusId" name="_stusId" class="multy_select w100p" multiple="multiple"></td>
    <th scope="row">Posting Branch</th>
    <td><select id="_brnchId" name="_brnchId" class="multy_select w100p" multiple="multiple"></select></td>
    <th scope="row">NRIC/Company No</th>
    <td><input id="_nric" name="_nric" type="text" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">SOF No.</th>
    <td><input id="_sofNo" name="_sofNo" type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Customer Type</th>
    <td><select id="_typeId" name="_typeId" class="multy_select w100p" multiple="multiple"></select></td>
    <th scope="row">Customer Name</th>
    <td><input id="_name" name="_name" type="text" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Order No.</th>
    <td><input id="_ordNo" name="_ordNo" type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Time</th>
    <td>
       <div class="date_set w100p">
        <p><input id="_reqstStartTime" name="_reqstStartTime" type="text" value="" title="" placeholder="" class="w100p" maxlength = "4" min = "0000" max = "2300" pattern="\d{4}"  /></p>
        <span>To</span>
        <p><input id="_reqstEndTime" name="_reqstEndTime" type="text" value="" title="" placeholder="" class="w100p" maxlength = "4" min = "0000" max = "2300" pattern="\d{4}" /></p>
        </div>
    </td>
    <th scope="row"><spring:message code="sal.text.product" /></th>
    <td><select id="_ordProudctList" name="ProudctList" class="w100p"></select></select>
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
    <th scope="row">Bundle Number</th>
    <td><input type="text" title="bndlNo" id="bndlNo" name="bndlNo" placeholder="Bundle Number" class="w100p" /></td>
    <th scope="row"><spring:message code="sal.text.memtype" /></th>
    <td><select id="memType" name="memType" class="w100p" ></select>
    <th scope="row">DT Branch</th>
     <td><select id="listDscBrnchId" name="dscBrnchId" class="multy_select w100p" multiple="multiple"></select></td>
</tr>
<th scope="row">Entry Point</th>
    <td>
        <select id="entryPoint" name="entryPoint" class="w100p" >
            <option value="">Choose One</option>
            <option value="1">Web</option>
            <option value="0">Mobile Apps</option>
            <option value="2">Epapan</option>
        </select>
    </td>
    <th scope="row"><spring:message code='sales.promoCd'/></th>
    <td>
    <input id="promoCode" name="promoCode" type="text" title="Promotion Code" placeholder="<spring:message code='sales.promoCd'/>" class="w100p" />
    </td>
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
    <li><p class="btn_grid"><a href="#" id="excelDown">GENERATE</a></p></li>
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
                    <th scope="row">SOF NO</th>
                    <td id="view_sofNo"></td>
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
