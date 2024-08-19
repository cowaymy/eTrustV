<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ include file="/WEB-INF/jsp/homecare/sales/order/convertToHcOrderInc.jsp" %>
<%@ include file="/WEB-INF/jsp/homecare/sales/order/copyChangeHcOrderInc.jsp" %>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/homecare-js-1.0.js"></script>

<script type="text/javaScript" language="javascript">

    var TODAY_DD      = "${toDay}";
    var BEFORE_DD = "${bfDay}";
    var blockDtFrom = "${hsBlockDtFrom}";
    var blockDtTo = "${hsBlockDtTo}";

    var convToOrdYn  = "${CONV_TO_ORD_YN}";
    var copyChangeYn = "${COPY_CHANGE_YN}";
    var bulkOrderYn  = "${BULK_ORDER_YN}";
    var preOrdId = '${matPreOrdId}';
    var rcdTms  = "${preOrderInfo.updDt}";
    var stockIdVal ='';

    var LoginRoleID = "${SESSION_INFO.roleId}";

    var docGridID;
    var docDefaultChk = false;
    var GST_CHK = '';
    var GST_MANNUAL = 'N';
    var MAT_TAG = 'N';

    var voucherAppliedStatus = 0;
    var voucherAppliedCode = "";
    var voucherAppliedEmail = "";
    var voucherPromotionId = [];

    var codeList_10 = [];
    <c:forEach var="obj" items="${codeList_10}">
    codeList_10.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
    </c:forEach>

    var codeList_17 = [];
    <c:forEach var="obj" items="${codeList_17}">
    codeList_17.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
    </c:forEach>

    var codeList_19 = [];
    <c:forEach var="obj" items="${codeList_19}">
    codeList_19.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
    </c:forEach>

    var codeList_322 = [];
    <c:forEach var="obj" items="${codeList_322}">
    codeList_322.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
    </c:forEach>

    //voucher management
    var codeList_562 = [];
    codeList_562.push({codeId:"0", codeName:"No", code:"No"});
    <c:forEach var="obj" items="${codeList_562}">
    codeList_562.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
    </c:forEach>

    $(document).ready(function(){
        createAUIGrid();

        fn_selectDocSubmissionList();

        doDefCombo(codeList_10, '', 'appType', 'S', '');              // Common Code
        doDefCombo(codeList_19, '', 'rentPayMode', 'S', '');        // Common Code
        doDefCombo(codeList_17, '', 'billPreferInitial', 'S', '');       // Common Code
        doDefCombo(codeList_322, '', 'promoDiscPeriodTp1', 'S', '');      // Discount period
        doDefCombo(codeList_322, '', 'promoDiscPeriodTp2', 'S', '');      // Discount period
        doDefCombo(codeList_562, '0', 'voucherType', 'S', 'displayVoucherSection');    // Voucher Type Code
		doGetComboSepa ('/homecare/selectHomecareDscBranchList.do', '',  ' - ', '', 'dscBrnchId',  'S', ''); //Branch Code

         doGetComboData('/common/selectCodeList.do', {groupCode :'324'}, '',  'empChk',  'S'); //EMP_CHK
         doGetComboData('/common/selectCodeList.do', {groupCode :'325',orderValue : 'CODE_ID'}, '0', 'exTrade', 'S'); //EX-TRADE
         doGetComboData('/common/selectCodeList.do', {groupCode :'326'}, '0', 'gstChk',  'S'); //GST_CHK
//       doGetComboOrder('/common/selectCodeList.do', '322', 'CODE_ID', '', 'promoDiscPeriodTp1', 'S'); //Discount period
//       doGetComboOrder('/common/selectCodeList.do', '322', 'CODE_ID', '', 'promoDiscPeriodTp2', 'S'); //Discount period

        //Payment Channel, Billing Detail TAB Visible False처리
        fn_tabOnOffSet('PAY_CHA', 'HIDE');
       //fn_tabOnOffSet('BIL_DTL', 'HIDE'); //2018.01.01
        fn_tabOnOffSet('REL_CER', 'HIDE');

        //Attach File
        $(".auto_file").append("<label><span class='label_text'><a href='#'>File</a></span><input type='text' class='input_text' readonly='readonly' /></label>");

        //Pre-Order Info
        if(convToOrdYn == 'Y') {
            fn_loadPreOrderInfo();
        }
        //Copy Change Info
        if(copyChangeYn == 'Y') {
            fn_loadCopyChange();
        }
    });

    function createAUIGrid() {
        //AUIGrid 칼럼 설정
        var columnLayout = [
            {dataField : "chkfield",       width: 70,
            	renderer : {
	            	type : "CheckBoxEditRenderer",
	                showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
	                editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
	                checkValue : 1, // true, false 인 경우가 기본
	                unCheckValue : 0
                }
            },
            {dataField : "typeDesc",       headerText  : '<spring:message code="sal.title.text.document" />',       editable : false,       style : 'left_style'},
            {dataField : "codeId",          visible : false
            }];

        //그리드 속성 설정
        var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 40,           //한 화면에 출력되는 행 개수 20(기본값:20)
            editable            : true,
            fixedColumnCount    : 0,
            showStateColumn     : false,
            showRowCheckColumn  : false,
            displayTreeOpen     : false,
            rowIdField          : "codeId",
          //selectionMode       : "singleRow",  //"multipleCells",
            headerHeight        : 30,
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
            noDataMessage       : "No order found.",
            groupingMessage     : "Here groupping"
        };

        docGridID = GridCommon.createAUIGrid("grid_doc_wrap", columnLayout, "", gridPros);
    }

    // 리스트 조회.
    function fn_selectDocSubmissionList() {
        Common.ajaxSync("GET", "/sales/order/selectDocSubmissionList.do", {typeCodeId : '248'}, function(result) {
            AUIGrid.setGridData(docGridID, result);
        });
    }

    function fn_loadThirdParty(custId, sMethd) {
        fn_clearRentPayMode();
        fn_clearRentPay3thParty();
        fn_clearRentPaySetCRC();
        fn_clearRentPaySetDD();

        if(custId != $('#hiddenCustId').val()) {
            Common.ajax("GET", "/sales/customer/selectCustomerJsonList", {custId : custId}, function(result) {
	            if(result != null && result.length == 1) {
	                var custInfo = result[0];

	                $('#hiddenThrdPartyId').val(custInfo.custId)
	                $('#thrdPartyId').val(custInfo.custId)
	                $('#thrdPartyType').val(custInfo.codeName1)
	                $('#thrdPartyName').val(custInfo.name)
	                $('#thrdPartyNric').val(custInfo.nric)

	                $('#thrdPartyId').removeClass("readonly");
	                $('#thrdPartyType').removeClass("readonly");
	                $('#thrdPartyName').removeClass("readonly");
	                $('#thrdPartyNric').removeClass("readonly");

	            } else {
	                if(sMethd == 2) {
	                    Common.alert('<spring:message code="sal.alert.msg.input3rdPartyId" arguments="'+custId+'"/>');
	                }
	            }
	        });

        } else {
            Common.alert('<spring:message code="sal.alert.msg.samePerson3rdPartyId" arguments="'+custId+'"/>');
        }

        $('#sctThrdParty').removeClass("blind");
    }

    function fn_loadCustomer(custId) {
        $("#searchCustId").val(custId);

        Common.ajax("GET", "/sales/customer/selectCustomerJsonList", {custId : custId}, function(result) {
            if(result != null && result.length == 1) {
                var custInfo = result[0];

                $("#hiddenCustId").val(custInfo.custId); //Customer ID(Hidden)
                $("#custId").val(custInfo.custId); //Customer ID
                $("#custTypeNm").val(custInfo.codeName1); //Customer Name
                $("#typeId").val(custInfo.typeId); //Type
                $("#corpTypeId").val(custInfo.corpTypeId); //Corp Type
                $("#name").val(custInfo.name); //Name
                $("#nric").val(custInfo.nric); //NRIC/Company No
                $("#sstRegNo").val(custInfo.sstRgistNo); //SST Reg No
                $("#tin").val(custInfo.custTin); //TIN No
                $("#nationNm").val(custInfo.name2); //Nationality
                $("#nation").val(custInfo.nation); //Nationality
                $("#raceId").val(custInfo.raceId); //Nationality
                $("#race").val(custInfo.codeName2); //
                $("#dob").val(custInfo.dob == '01/01/1900' ? '' : custInfo.dob); //DOB
                $("#gender").val(custInfo.gender); //Gender
                $("#pasSportExpr").val(custInfo.pasSportExpr == '01/01/1900' ? '' : custInfo.pasSportExpr); //Passport Expiry
                $("#visaExpr").val(custInfo.visaExpr == '01/01/1900' ? '' : custInfo.visaExpr); //Visa Expiry
                $("#email").val(custInfo.email); //Email
                $("#custRem").val(custInfo.rem); //Remark
                $("#empChk").val('0'); //Employee
//              $("#gstChk").val('0').prop("disabled", true);
                $("#hiddenCustCrtDt").val(custInfo.crtDt); //cust create date
                $("#hiddenCustStatusId").val(custInfo.custStatusId); //Customer Status
                $("#custStatus").val(custInfo.custStatus); //Customer Status

                if(custInfo.receivingMarketingMsgStatus == 1){
                	$("#marketMessageYes").prop("checked", true);
                }
                else{
                	$("#marketMessageNo").prop("checked", true);
                }

                if(custInfo.corpTypeId > 0) {
                    $("#corpTypeNm").val(custInfo.codeName); //Industry Code
                } else {
                    $("#corpTypeNm").val(""); //Industry Code
                }

                if($('#typeId').val() == '965') { //Company
                    $('#sctBillPrefer').removeClass("blind");
                } else {
                    $('#sctBillPrefer').addClass("blind");
                }

                if(custInfo.custAddId > 0) {
                    //----------------------------------------------------------
                    // [Billing Detail] : Billing Address SETTING
                    //----------------------------------------------------------
                    $('#billAddrForm').clearForm();
                    fn_loadMailAddr(custInfo.custAddId);

                    //----------------------------------------------------------
                    // [Installation] : Installation Address SETTING
                    //----------------------------------------------------------
                    fn_clearInstallAddr();
                    fn_loadInstallAddr(custInfo.custAddId);
                }

                if(custInfo.custCntcId > 0) {
                    //----------------------------------------------------------
                    // [Master Contact] : Owner & Purchaser Contact
                    //                    Additional Service Contact
                    //----------------------------------------------------------
                    $('#custCntcForm').clearForm();
                    //$('#liMstCntcNewAddr').addClass("blind");
                    //$('#liMstCntcSelAddr').addClass("blind");
                    //$('#liMstCntcNewAddr2').addClass("blind");
                    //$('#liMstCntcSelAddr2').addClass("blind");

                    fn_loadCntcPerson(custInfo.custCntcId);
                    fn_loadSrvCntcPerson(custInfo.custCareCntId);

                    //----------------------------------------------------------
                    // [Installation] : Installation Contact Person
                    //----------------------------------------------------------
                    $('#instCntcForm').clearForm();
                    fn_loadInstallationCntcPerson(custInfo.custCntcId);
                }

                $('#liMstCntcNewAddr').removeClass("blind");
                $('#liMstCntcSelAddr').removeClass("blind");
                $('#liMstCntcNewAddr2').removeClass("blind");
                $('#liMstCntcSelAddr2').removeClass("blind");
                $('#liBillNewAddr').removeClass("blind");
                $('#liBillSelAddr').removeClass("blind");
                $('#liBillNewAddr2').removeClass("blind");
                $('#liBillSelAddr2').removeClass("blind");
                $('#liInstNewAddr').removeClass("blind");
                $('#liInstSelAddr').removeClass("blind");
                $('#liInstNewAddr2').removeClass("blind");
                $('#liInstSelAddr2').removeClass("blind");

                fn_checkDocList(false);

                if(custInfo.codeName == 'Government') {
                    Common.alert('<spring:message code="sal.alert.msg.gvmtCust" />');
                }
            } else {
                Common.alert('<spring:message code="sal.alert.msg.custNotFound" arguments="'+custId+'"/>');
            }
        });
    }

    function fn_loadMailAddr(custAddId) {
        Common.ajax("GET", "/sales/order/selectCustAddJsonInfo.do", {custAddId : custAddId}, function(billCustInfo) {
            if(billCustInfo != null) {
                $("#hiddenBillAddId").val(billCustInfo.custAddId); //Customer Address ID(Hidden)
                $("#billAddrDtl").val(billCustInfo.addrDtl); //Address
                $("#billStreet").val(billCustInfo.street); //Street
                $("#billArea").val(billCustInfo.area); //Area
                $("#billCity").val(billCustInfo.city); //City
                $("#billPostCode").val(billCustInfo.postcode); //Post Code
                $("#billState").val(billCustInfo.state); //State
                $("#billCountry").val(billCustInfo.country); //Country
                $("#hiddenBillStreetId").val(billCustInfo.custAddId); //Magic Address STREET_ID(Hidden)
            }
        });
    }

    //for initial load
    function fn_loadInstallAddr(custAddId) {
        Common.ajax("GET", "/sales/order/selectCustAddJsonInfo.do", {custAddId : custAddId, 'isHomecare' : 'Y'}, function(custInfo) {
            if(custInfo != null) {
                if(custInfo.areaId != undefined) {
                	if(convToOrdYn && copyChangeYn){ //check the string is positive value (means it is not empty or null)
                		if (convToOrdYn != "Y" && copyChangeYn != "Y") {
                              fn_clearSales();
                       }
                	}

                    if("DM" == custInfo.areaId.substring(0,2)) {
                        Common.alert('<spring:message code="sal.alert.msg.invalidAddr" />' + DEFAULT_DELIMITER + '<spring:message code="sal.alert.msg.oldAddrNewAddr" />');
                        $("#validAreaIdYN").val("N");

                    } else {
                        $("#validAreaIdYN").val("Y");
                    }

                } else {
                    Common.alert('<spring:message code="sal.alert.msg.invalidMagicAddress"/>',fn_orderRegPopClose());
                    return false;
                }

                $("#hiddenCustAddId").val(custInfo.custAddId); //Customer Address ID(Hidden)
                $("#instAddrDtl").val(custInfo.addrDtl); //Address
                $("#instStreet").val(custInfo.street); //Street
                $("#instArea").val(custInfo.area); //Area
                $("#instCity").val(custInfo.city); //City
                $("#instPostCode").val(custInfo.postcode); //Post Code
                $("#instState").val(custInfo.state); //State
                $("#instCountry").val(custInfo.country); //Country
                $("#dscBrnchId").val(custInfo.brnchId); //DSC Branch

                GST_CHK = custInfo.gstChk;

                if($("#appType").val() == '66') {
                    $("#gstChk").removeAttr("disabled");
                } else if($("#appType").val() != '' && $("#appType").val() != '66') {
                    /* var appTypeVal   = $("#appType").val();
                    var stkIdVal1       = $("#ordProduct1").val();
                    var stkIdVal2       = $("#ordProduct2").val();
                    var promoIdVal1  = $("#ordPromo1").val();
                    var promoIdVal2  = $("#ordPromo2").val();
                    var srvPacId        = 0;

                    fn_loadProductPrice(appTypeVal, stkIdVal1, srvPacId, '1');
                    fn_loadProductPrice(appTypeVal, stkIdVal2, srvPacId, '2');

                    if(FormUtil.isNotEmpty(promoIdVal1)) {
                        fn_loadPromotionPrice(promoIdVal1, stkIdVal1, srvPacId, '1');
                    }
                    if(FormUtil.isNotEmpty(promoIdVal2)) {
                        fn_loadPromotionPrice(promoIdVal2, stkIdVal2, srvPacId, '2');
                    } */

                    if(custInfo.gstChk == '1') {
                        $("#gstChk").val('1').prop("disabled", true);
                        $("#pBtnCal").removeClass("blind");
                        //fn_tabOnOffSet('REL_CER', 'SHOW');
                        fn_tabOnOffSet('REL_CER', 'HIDE');

                    } else {
                        $("#gstChk").val('0').prop("disabled", true);
                        $('#pBtnCal').addClass("blind");
                        fn_tabOnOffSet('REL_CER', 'HIDE');
                    }
                }
                // Checking DT branch for AC after load installation address
                console.log('stockIdVal2 ::: ' + stockIdVal)
                if(!FormUtil.isEmpty(stockIdVal)){
                    checkIfIsAcInstallationProductCategoryCode(stockIdVal);
                    //console.log(':::checkIfIsAcInstallationProductCategoryCode:::')
                }
            }
        });
    }

    //Customise Installation DSC/HDC Load for Aircon Checking Usage and not including fn_clearSales for after onchange use
    function fn_loadInstallAddrForDiffBranch(custAddId, isHomecare, isAC) {
    	Common.ajax("GET", "/sales/order/selectCustAddJsonInfo.do", {custAddId : custAddId, 'isHomecare' : isHomecare,'isAC' : isAC}, function(custInfo) {

            if(custInfo != null) {
                if(custInfo.areaId != undefined) {
                    if("DM" == custInfo.areaId.substring(0,2)) {
                        Common.alert('<spring:message code="sal.alert.msg.invalidAddr" />' + DEFAULT_DELIMITER + '<spring:message code="sal.alert.msg.oldAddrNewAddr" />');
                        $("#validAreaIdYN").val("N");

                    } else {
                        $("#validAreaIdYN").val("Y");
                    }
                } else {
                    Common.alert('<spring:message code="sal.alert.msg.invalidMagicAddress"/>',fn_orderRegPopClose());
                    return false;
                }

                $("#hiddenCustAddId").val(custInfo.custAddId); //Customer Address ID(Hidden)
                $("#instAddrDtl").val(custInfo.addrDtl); //Address
                $("#instStreet").val(custInfo.street); //Street
                $("#instArea").val(custInfo.area); //Area
                $("#instCity").val(custInfo.city); //City
                $("#instPostCode").val(custInfo.postcode); //Post Code
                $("#instState").val(custInfo.state); //State
                $("#instCountry").val(custInfo.country); //Country
                $("#dscBrnchId").val(custInfo.brnchId); //DSC Branch

                GST_CHK = custInfo.gstChk;

                if($("#appType").val() == '66') {
                    $("#gstChk").removeAttr("disabled");
                } else if($("#appType").val() != '' && $("#appType").val() != '66') {
                    if(custInfo.gstChk == '1') {
                        $("#gstChk").val('1').prop("disabled", true);
                        $("#pBtnCal").removeClass("blind");
                        fn_tabOnOffSet('REL_CER', 'HIDE');

                    } else {
                        $("#gstChk").val('0').prop("disabled", true);
                        $('#pBtnCal').addClass("blind");
                        fn_tabOnOffSet('REL_CER', 'HIDE');
                    }
                }
            }
        });
    }

    function fn_checkDocList(doCheck) {
        var vAppType  = $("#appType").val();
        var vCustType = $("#typeId").val();
        var vNational = $("#nationNm").val();

        for(var i = 0; i < AUIGrid.getRowCount(docGridID) ; i++) {
            AUIGrid.setCellValue(docGridID, i, "chkfield", 0);
            var vCodeId = AUIGrid.getCellValue(docGridID, i, "codeId");

            if(doCheck == true) {


                if(vAppType == '66' && vCustType == '964') {
                    if(vNational == 'MALAYSIA') {
                        if(vCodeId == '250' || vCodeId == '1244' /* || vCodeId == '271' */) {
                            AUIGrid.setCellValue(docGridID, i, "chkfield", 1);

                            if(docDefaultChk == false) docDefaultChk = true;
                        }

                    } else {
                        if(vCodeId == '939' || vCodeId == '940' || vCodeId == '1244') {
                            AUIGrid.setCellValue(docGridID, i, "chkfield", 1);

                            if(docDefaultChk == false) docDefaultChk = true;
                        }
                    }
                }

                //if(convToOrdYn != 'Y') {
                	if(vCodeId == '3198') { // SOF Form, check default when it is not eKey-in
                		AUIGrid.setCellValue(docGridID, i, "chkfield", 1);
                		if(docDefaultChk == false) docDefaultChk = true;
                	}
                //}
            } else {
            	if(vCodeId == '3198') { // SOF Form, check default when it is not eKey-in
                    AUIGrid.setCellValue(docGridID, i, "chkfield", 1);
                    //if(docDefaultChk == false) docDefaultChk = true;
                }
            }
        }

        $('.aui-checkbox').val("").prop("disabled", false);
    }

    function fn_loadSrvCntcPerson(custCareCntId) {
        $("#searchCustCareCntId").val(custCareCntId);

        Common.ajax("GET", "/sales/order/selectSrvCntcJsonInfo.do", {custCareCntId : custCareCntId}, function(srvCntcInfo) {
            if(srvCntcInfo != null) {
                $("#srvCntcId").val(srvCntcInfo.custCareCntId);
                $("#srvCntcName").val(srvCntcInfo.name);
                $("#srvInitial").val(srvCntcInfo.custInitial);
                $("#srvCntcEmail").val(srvCntcInfo.email);
                $("#srvCntcTelM").val(srvCntcInfo.telM);
                $("#srvCntcTelR").val(srvCntcInfo.telR);
                $("#srvCntcTelO").val(srvCntcInfo.telO);
                $("#srvCntcTelF").val(srvCntcInfo.telf);
                $("#srvCntcExt").val(srvCntcInfo.ext);
            }
        });
    }

    function fn_loadCntcPerson(custCntcId) {
        Common.ajax("GET", "/sales/order/selectCustCntcJsonInfo.do", {custCntcId : custCntcId}, function(custCntcInfo) {
            if(custCntcInfo != null) {
                $("#hiddenInstCntcId").val(custCntcInfo.custCntcId);
                $("#hiddenCustCntcId").val(custCntcInfo.custCntcId);
                $("#custCntcName").val(custCntcInfo.name1);
                $("#custInitial").val(custCntcInfo.code);
                $("#custCntcEmail").val(custCntcInfo.email);
                $("#custCntcTelM").val(custCntcInfo.telM1);
                $("#custCntcTelR").val(custCntcInfo.telR);
                $("#custCntcTelO").val(custCntcInfo.telO);
                $("#custCntcTelF").val(custCntcInfo.telf);
                $("#custCntcExt").val(custCntcInfo.ext);
            }
        });
    }

    function fn_loadInstallationCntcPerson(custCntcId){
        $("#searchCustCntcId").val(custCntcId);

        Common.ajax("GET", "/sales/order/selectCustCntcJsonInfo.do", {custCntcId : custCntcId}, function(instCntcInfo) {
            if(instCntcInfo != null) {
                $("#instCntcName").val(instCntcInfo.name1);
                $("#instInitial").val(instCntcInfo.code);
                $("#instCntcEmail").val(instCntcInfo.email);
                $("#instCntcTelM").val(instCntcInfo.telM1);
                $("#instCntcTelR").val(instCntcInfo.telR);
                $("#instCntcTelO").val(instCntcInfo.telO);
                $("#instCntcTelF").val(instCntcInfo.telf);
                $("#instCntcExt").val(instCntcInfo.ext);
                $("#instGender").val(instCntcInfo.gender);
                $("#instNric").val(instCntcInfo.nric);
                $("#instDob").val(instCntcInfo.dob);
                $("#instRaceId").val(instCntcInfo.raceId);
                $("#instDept").val(instCntcInfo.dept);
                $("#instPost").val(instCntcInfo.pos);
            }
        });
    }

    function fn_setBillGrp(grpOpt) {
        if(grpOpt == 'new') {
            fn_clearBillGroup();

            $('#grpOpt1').prop("checked", true);
            $('#sctBillMthd').removeClass("blind");
            $('#sctBillAddr').removeClass("blind");
            $('#liBillNewAddr').removeClass("blind");
            $('#liBillSelAddr').removeClass("blind");
            $('#liBillPreferNewAddr').removeClass("blind");
            $('#liBillPreferSelAddr').removeClass("blind");

            $('#billMthdEmailTxt1').val($('#custCntcEmail').val().trim());
            $('#billMthdEmailTxt2').val($('#srvCntcEmail').val().trim());

            if($('#typeId').val() == '965') { //Company
                $('#sctBillPrefer').removeClass("blind");
                fn_loadBillingPreference($('#srvCntcId').val());

                $('#billMthdEstm').prop("checked", true);
                $('#billMthdEmail1').prop("checked", true).removeAttr("disabled");
                $('#billMthdEmail2').removeAttr("disabled");
                $('#billMthdEmailTxt1').removeAttr("disabled");
                $('#billMthdEmailTxt2').removeAttr("disabled");

                if($("#corpTypeId").val() == 1151 || $("#corpTypeId").val() ==1154 || $("#corpTypeId").val() == 1333){
                	$('#billMthdPost').removeAttr("disabled");
                } else {
                	$('#billMthdPost').prop("disabled",true);
                }

            } else if($('#typeId').val() == '964') { //Individual
                if(FormUtil.isNotEmpty($('#custCntcEmail').val().trim())) {
                    $('#billMthdEstm').prop("checked", true);
                    $('#billMthdEmail1').prop("checked", true).removeAttr("disabled");
                    $('#billMthdEmail2').removeAttr("disabled");
                    $('#billMthdEmailTxt1').removeAttr("disabled");
                    $('#billMthdEmailTxt2').removeAttr("disabled");
                    $('#billMthdPost').removeAttr("disabled");
                }

                $('#billMthdSms').prop("checked", true);
                $('#billMthdSms1').prop("checked", true).removeAttr("disabled");
                $('#billMthdSms2').removeAttr("disabled");
            }

        } else if(grpOpt == 'exist') {
            fn_clearBillGroup();

            $('#grpOpt2').prop("checked", true);
            $('#sctBillSel').removeClass("blind");
            $('#liBillNewAddr').removeClass("blind");
            $('#liBillSelAddr').removeClass("blind");
            $('#liBillPreferNewAddr').removeClass("blind");
            $('#liBillPreferSelAddr').removeClass("blind");
            $('#billRem').prop("readonly", true).addClass("readonly");
        }
    }

    function fn_loadBillingPreference(custCareCntId) {
        Common.ajax("GET", "/sales/order/selectSrvCntcJsonInfo.do", {custCareCntId : custCareCntId}, function(srvCntcInfo) {
            if(srvCntcInfo != null) {
                $("#hiddenBPCareId").val(srvCntcInfo.custCareCntId);
                $("#billPreferInitial").val(srvCntcInfo.custInitial);
                $("#billPreferName").val(srvCntcInfo.name);
                $("#billPreferTelO").val(srvCntcInfo.telO);
                $("#billPreferExt").val(srvCntcInfo.ext);
            }
        });

    }

    $(function() {
        $('#btnRltdNo').click(function() {
            Common.popupDiv("/sales/order/prevOrderNoPop.do", {custId : $('#hiddenCustId').val(),isHomecare : 'A'}, null, true);
            fn_clearOrderSalesman();
        });

        $('#custBtn').click(function() {
            //Common.searchpopupWin("searchForm", "/common/customerPop.do","");
            Common.popupDiv("/common/customerPop.do", {callPrgm : "ORD_REGISTER_CUST_CUST"}, null, true);
        });

        $('#thrdPartyBtn').click(function() {
            //Common.searchpopupWin("searchForm", "/common/customerPop.do","");
            Common.popupDiv("/common/customerPop.do", {callPrgm : "ORD_REGISTER_PAY_3RD_PARTY"}, null, true);
        });

        $('#memBtn').click(function() {
            //Common.searchpopupWin("searchForm", "/common/memberPop.do","");
            Common.popupDiv("/common/memberPop.do", $("#searchForm").serializeJSON(), null, true);
        });

        $('#OrdNoTagBtn').click(function() {
            Common.popupDiv("/homecare/sales/order/hcOrderComboSearchPop.do", {promoNo:$("#ordPromo1").val(), prod:$("#ordProduct1").val(), custId : $('#hiddenCustId').val()}, null, true);
        });

        $('#addCustBtn').click(function() {
            //Common.popupWin("searchForm", "/sales/customer/customerRegistPop.do", {width : "1200px", height : "580x"});
            Common.popupDiv("/sales/customer/customerRegistPop.do", {"callPrgm" : "ORD_REGISTER"}, null, true);
        });

        $('#thrdPartyAddCustBtn').click(function() {
            //Common.popupWin("searchForm", "/sales/customer/customerRegistPop.do", {width : "1200px", height : "630x"});
            Common.popupDiv("/sales/customer/customerRegistPop.do", {"callPrgm" : "ORD_REGISTER_3PARTY"}, null, true);
        });

        $('#mstCntcNewAddBtn').click(function() {
            //Common.popupWin("searchForm", "/sales/customer/customerConctactSearchPop.do", {width : "1200px", height : "630x"});
            Common.popupDiv('/sales/customer/updateCustomerNewContactPop.do', {"custId":$('#hiddenCustId').val(), "callParam" : "ORD_REGISTER_CNTC_OWN"}, null , true ,'_editDiv3New');
        });

        $('#mstCntcSelAddBtn').click(function() {
            //Common.popupWin("searchForm", "/sales/customer/customerConctactSearchPop.do", {width : "1200px", height : "630x"});
            Common.popupDiv("/sales/customer/customerConctactSearchPop.do", {custId : $('#hiddenCustId').val(), callPrgm : "ORD_REGISTER_CNTC_OWN"}, null, true);
        });

        $('#mstCntcNewAddBtn2').click(function() {
            Common.popupDiv('/sales/customer/updateCustomerNewAddContactPop.do', {"custId":$('#hiddenCustId').val(), "callParam" : "ORD_REGISTER_CNTC_ADD"}, null , true ,'_editDiv3New');
        });

        $('#mstCntcSelAddBtn2').click(function() {
            //Common.popupWin("searchForm", "/sales/customer/customerConctactSearchPop.do", {width : "1200px", height : "630x"});
            Common.popupDiv("/sales/customer/customerConctactSearchPop.do", {custId : $('#hiddenCustId').val(), callPrgm : "ORD_REGISTER_CNTC_ADD"}, null, true);
        });

        $('#billPreferAddAddrBtn').click(function() {
            //Common.popupWin("searchForm", "/sales/customer/customerConctactSearchPop.do", {width : "1200px", height : "630x"});
            Common.popupDiv('/sales/customer/updateCustomerNewAddContactPop.do', {"custId":$('#hiddenCustId').val(), "callParam" : ""}, null , true ,'_editDiv3New');
        });

        $('#billPreferSelAddrBtn').click(function() {
            //Common.popupWin("searchForm", "/sales/customer/customerConctactSearchPop.do", {width : "1200px", height : "630x"});
            Common.popupDiv("/sales/customer/customerConctactSearchPop.do", {custId : $('#hiddenCustId').val(), callPrgm : "ORD_REGISTER_BILL_PRF"}, null, true);
        });

        $('#billNewAddrBtn').click(function() {
            Common.popupDiv("/sales/customer/updateCustomerNewAddressPop.do", {custId : $('#hiddenCustId').val(), callParam : "ORD_REGISTER_BILL_MTH"}, null , true);
        });

        $('#billSelAddrBtn').click(function() {
            //Common.popupWin("searchForm", "/sales/customer/customerAddressSearchPop.do", {width : "1200px", height : "630x"});
            Common.popupDiv("/sales/customer/customerAddressSearchPop.do", {custId : $('#hiddenCustId').val(), callPrgm : "ORD_REGISTER_BILL_MTH"}, null, true);
        });

        $('#instNewAddrBtn').click(function() {
            //Common.popupWin("searchForm", "/sales/customer/customerAddressSearchPop.do", {width : "1200px", height : "630x"});
            Common.popupDiv("/sales/customer/updateCustomerNewAddressPop.do", {custId : $('#hiddenCustId').val(), callParam : "ORD_REGISTER_INST_ADD"}, null , true);
        });

        $('#instSelAddrBtn').click(function() {
            //Common.popupWin("searchForm", "/sales/customer/customerAddressSearchPop.do", {width : "1200px", height : "630x"});
            Common.popupDiv("/sales/customer/customerAddressSearchPop.do", {custId : $('#hiddenCustId').val(), callPrgm : "ORD_REGISTER_INST_ADD"}, null, true);
        });

        $('#billGrpBtn').click(function() {
            //Common.popupWin("searchForm", "/customerBillGrpSearchPop.do", {width : "1200px", height : "630x"});
            Common.popupDiv("/sales/customer/customerBillGrpSearchPop.do", {custId : $('#hiddenCustId').val(), callPrgm : "ORD_REGISTER_BILL_GRP"}, null, true);
        });

        $('#addCreditCardBtn').click(function() {
            var vCustId = $('#thrdParty').is(":checked") ? $('#hiddenThrdPartyId').val() : $('#hiddenCustId').val();
            var vCustNric = $('#thrdParty').is(":checked") ? $('#thrdPartyNric').val() : $('#nric').val();
            //Common.popupDiv("/sales/customer/customerCreditCardAddPop.do", {custId : vCustId, callPrgm : "ORD_REGISTER_PAYM_CRC", nric : $('#nric').val()}, null, true);
            //Common.popupDiv("/sales/customer/customerCreditCardAddPop.do", {custId : vCustId, callPrgm : "ORD_REGISTER_PAYM_CRC"}, null, true);
            Common.popupDiv("/sales/customer/customerCreditCardAddPop.do", {custId : vCustId, callPrgm : "ORD_REGISTER_PAYM_CRC", nric : vCustNric}, null, true);
        });

        $('#selCreditCardBtn').click(function() {
            var vCustId = $('#thrdParty').is(":checked") ? $('#hiddenThrdPartyId').val() : $('#hiddenCustId').val();
            //Common.popupWin("searchForm", "/sales/customer/customerCreditCardSearchPop.do", {width : "1200px", height : "630x"});
            Common.popupDiv("/sales/customer/customerCreditCardSearchPop.do", {custId : vCustId, callPrgm : "ORD_REGISTER_PAYM_CRC"}, null, true);
        });
        //Payment Channel - Add New Bank Account
        $('#btnAddBankAccount').click(function() {
            var vCustId = $('#thrdParty').is(":checked") ? $('#hiddenThrdPartyId').val() : $('#hiddenCustId').val();
            Common.popupDiv("/sales/customer/customerBankAccountAddPop.do", {custId : vCustId, callPrgm : "ORD_REGISTER_BANK_ACC"}, null, true);
        });
        //Payment Channel - Select Another Bank Account
        $('#btnSelBankAccount').click(function() {
            var vCustId = $('#thrdParty').is(":checked") ? $('#hiddenThrdPartyId').val() : $('#hiddenCustId').val();
            Common.popupDiv("/sales/customer/customerBankAccountSearchPop.do", {custId : vCustId, callPrgm : "ORD_REGISTER_BANK_ACC"});
        });

        $('#trialNoBtn').click(function() {
            //Common.popupWin("searchForm", "/sales/order/orderSearchPop.do", {width : "1200px", height : "630x"});
            Common.popupDiv("/sales/order/orderSearchPop.do", {callPrgm : "ORD_REGISTER_SALE_ORD", indicator : "SearchTrialNo"});
        });

        $('#btnMatRltdNo').click(function() {
            Common.popupDiv("/sales/order/prevMatOrderNoPop.do", {custId : $('#hiddenCustId').val(),isHomecare : 'Y', appTypeId : $('#appType').val() }, null, true);
        });

        $('[name="grpOpt"]').click(function() {
            fn_setBillGrp($('input:radio[name="grpOpt"]:checked').val());
        });

        $('#trialNoChk').click(function() {
            if($('#trialNoChk').is(":checked")) {
                $('#trialNo').val('').removeClass("readonly");
                $('#trialNoBtn').removeClass("blind");

            } else {
                $('#trialNo').val('').addClass("readonly");
                $('#trialNoBtn').addClass("blind");
            }
        });

        $('#thrdParty').click(function(event) {
            fn_clearRentPayMode();
            fn_clearRentPay3thParty();
            fn_clearRentPaySetCRC();
            fn_clearRentPaySetDD();

            if($('#thrdParty').is(":checked")) {
                $('#sctThrdParty').removeClass("blind");

            } else {
                $('#sctThrdParty').addClass("blind");
            }
        });

        $('#billMthdPost').change(function() {
        	if($("#billMthdPost").is(":checked")) {
        		$('#billMthdEstm').change();
        		$('#billMthdSms').change();
        	}
        });

        $('#billMthdSms').change(function() {
            $('#billMthdSms1').prop("checked", false).prop("disabled", true);
            $('#billMthdSms2').prop("checked", false).prop("disabled", true);

            if($("#billMthdSms").is(":checked")) {
            	$('#billMthdEstm').change();
                $('#billMthdSms1').removeAttr("disabled").prop("checked", true);
                $('#billMthdSms2').removeAttr("disabled");
            }
        });

        $('#billMthdEstm').change(function() {
            $('#spEmail1').text("");
            $('#spEmail2').text("");
            $('#billMthdEmail1').prop("checked", false).prop("disabled", true);
            $('#billMthdEmail2').prop("checked", false).prop("disabled", true);
            $('#billMthdEmailTxt1').val("").prop("disabled", true);
            $('#billMthdEmailTxt2').val("").prop("disabled", true);

            if($("#billMthdEstm").is(":checked")) {
            	$('#billMthdSms').change();
                $('#spEmail1').text("*");
                $('#spEmail2').text("*");
                $('#billMthdEmail1').removeAttr("disabled").prop("checked", true);
                $('#billMthdEmail2').removeAttr("disabled");
                $('#billMthdEmailTxt1').removeAttr("disabled").val($('#custCntcEmail').val().trim());
                $('#billMthdEmailTxt2').removeAttr("disabled").val($('#srvCntcEmail').val().trim());
            }
        });

        $('#custId').change(function(event) {
            fn_selectCustInfo();
        });

        $('#custId').keydown(function (event) {
            if (event.which === 13) {    //enter
                fn_selectCustInfo();
                return false;
            }
        });

        $('#salesmanCd').change(function(event) {
            var memCd = $('#salesmanCd').val().trim();

            if(FormUtil.isNotEmpty(memCd)) {
                fn_loadOrderSalesman(0, memCd);
            }
        });

        $('#gstChk').change(function(event) {
            if($("#gstChk").val() == '1') {
                $('#pBtnCal').removeClass("blind");
                //fn_tabOnOffSet('REL_CER', 'SHOW');
                fn_tabOnOffSet('REL_CER', 'HIDE');
                GST_MANNUAL = 'Y';

            } else {
                $('#pBtnCal').addClass("blind");
                fn_tabOnOffSet('REL_CER', 'HIDE');

                var appTypeVal  = $("#appType").val();
                var stkIdVal1      = $("#ordProduct1").val();
                var stkIdVal2      = $("#ordProduct2").val();
                var promoIdVal1 = $("#ordPromo1").val();
                var promoIdVal2 = $("#ordPromo2").val();
                var srvPacId       = appTypeVal == '66' ? $('#srvPacId').val() : 0;

                fn_loadProductPrice(appTypeVal, stkIdVal1, srvPacId, '1');
                fn_loadProductPrice(appTypeVal, stkIdVal2, srvPacId, '2');

                if(FormUtil.isNotEmpty(promoIdVal1)) {
                    fn_loadPromotionPrice(promoIdVal1, stkIdVal1, srvPacId, '1');
                }
                if(FormUtil.isNotEmpty(promoIdVal2)) {
                    fn_loadPromotionPrice(promoIdVal2, stkIdVal2, srvPacId, '2');
                }
                GST_MANNUAL = 'N';
            }
        });

        $('#salesmanCd').keydown(function (event) {
            if (event.which === 13) {    //enter
                var memCd = $('#salesmanCd').val().trim();

                if(FormUtil.isNotEmpty(memCd)) {
                    fn_loadOrderSalesman(0, memCd);
                }
                return false;
            }
        });

        $('#thrdPartyId').change(function(event) {
            fn_loadThirdParty($('#thrdPartyId').val().trim(), 2);
        });

        $('#thrdPartyId').keydown(function(event) {
            if(event.which === 13) {    //enter
                fn_loadThirdParty($('#thrdPartyId').val().trim(), 2);
            }
        });
        // Application Type Change Event
        $('#appType').change(function() {
            fn_tabOnOffSet('PAY_CHA', 'HIDE');
            //Sales Order
            $('#salesOrderForm').clearForm();
            //CLEAR RENTAL PAY SETTING
            $('#thrdParty').prop("checked", false);

            fn_clearRentPayMode();
            fn_clearRentPay3thParty();
            fn_clearRentPaySetCRC();
            fn_clearRentPaySetDD();
            //CLEAR BILLING GROUP
            fn_clearBillGroup();
            //ClearControl_Sales();
            fn_clearSales();

            //fn_clearAddCpnt();

            $('[name="advPay"]').prop("disabled", true);

            var idx    = $("#appType option:selected").index();
            var selVal = $("#appType").val();
            var appSubType = '';
            console.log("idx:"+idx);
            if(idx > 0) {
                if(FormUtil.isEmpty($('#hiddenCustId').val())) {
                    $('#appType').val('');
                    Common.alert('<spring:message code="sal.alert.msg.plzSelCust" />');

                    $('#aTabCS').click();

                } else {

                    switch(selVal) {
                        case '66' : //RENTAL
                            fn_tabOnOffSet('PAY_CHA', 'SHOW');
                            //?FD문서에서 아래 항목 빠짐
                            $('[name="advPay"]').removeAttr("disabled");
                            $('#installDur').val('').prop("readonly", true).addClass("readonly");

                            $("#gstChk").val('0').removeAttr("disabled");
                            $('#pBtnCal').addClass("blind");
                            fn_tabOnOffSet('REL_CER', 'HIDE');

                            appSubType = '367';
                            var vCustType = $("#typeId").val();

                            if (vCustType == '965' ){
                            	$("#corpCustType").val('').removeAttr("disabled");
                            	$("#agreementType").val('').removeAttr("disabled");

                            } else {
                            	$("#corpCustType").val('').prop("disabled", true);
                                $("#agreementType").val('').prop("disabled", true);
                            }

                            break;

                        case '67' : //OUTRIGHT
                            if(GST_CHK == '1') {
                                $("#gstChk").val('1').removeAttr("disabled");
                                $("#pBtnCal").removeClass("blind");
                                //fn_tabOnOffSet('REL_CER', 'SHOW');
                                fn_tabOnOffSet('REL_CER', 'HIDE');

                            } else {
                                $("#gstChk").val('0').removeAttr("disabled");
                                $('#pBtnCal').addClass("blind");
                                fn_tabOnOffSet('REL_CER', 'HIDE');
                            }
                            $("#corpCustType").val('').prop("disabled", true);
                            $("#agreementType").val('').prop("disabled", true);
                            appSubType = '368';

                            break;

                        case '68' : //INSTALLMENT
                            $('#installDur').removeAttr("readonly").removeClass("readonly");

                            if(GST_CHK == '1') {
                                $("#gstChk").val('1').removeAttr("disabled");
                                $("#pBtnCal").removeClass("blind");
                                //fn_tabOnOffSet('REL_CER', 'SHOW');
                                fn_tabOnOffSet('REL_CER', 'HIDE');

                            } else {
                                $("#gstChk").val('0').removeAttr("disabled");
                                $('#pBtnCal').addClass("blind");
                                fn_tabOnOffSet('REL_CER', 'HIDE');
                            }
                            $("#corpCustType").val('').prop("disabled", true);
                            $("#agreementType").val('').prop("disabled", true);
                            appSubType = '369';

                            break;

                        case '1412' : //Outright Plus
                            $('#installDur').val("36").prop("readonly", true).removeClass("readonly");

                            $('[name="advPay"]').removeAttr("disabled");

                            if(GST_CHK == '1') {
                                $("#gstChk").val('1').removeAttr("disabled");
                                $("#pBtnCal").removeClass("blind");
                                //fn_tabOnOffSet('REL_CER', 'SHOW');
                                fn_tabOnOffSet('REL_CER', 'HIDE');

                            } else {
                                $("#gstChk").val('0').removeAttr("disabled");
                                $('#pBtnCal').addClass("blind");
                                fn_tabOnOffSet('REL_CER', 'HIDE');
                            }

                            fn_tabOnOffSet('PAY_CHA', 'SHOW');
                            $("#corpCustType").val('').prop("disabled", true);
                            $("#agreementType").val('').prop("disabled", true);
                            appSubType = '370';

                            break;

                        case '142' : //Sponsor
                            appSubType = '371';

                            $("#gstChk").val('').prop("disabled", true);
                            $('#pBtnCal').addClass("blind");
                            $("#corpCustType").val('').prop("disabled", true);
                            $("#agreementType").val('').prop("disabled", true);
                            fn_tabOnOffSet('REL_CER', 'HIDE');

                            break;

                        case '143' : //Service
                            appSubType = '372';

                            $("#gstChk").val('').prop("disabled", true);
                            $('#pBtnCal').addClass("blind");
                            $("#corpCustType").val('').prop("disabled", true);
                            $("#agreementType").val('').prop("disabled", true);
                            fn_tabOnOffSet('REL_CER', 'HIDE');

                            break;

                        case '144' : //Education
                            appSubType = '373';

                            $("#gstChk").val('').prop("disabled", true);
                            $('#pBtnCal').addClass("blind");
                            $("#corpCustType").val('').prop("disabled", true);
                            $("#agreementType").val('').prop("disabled", true);
                            fn_tabOnOffSet('REL_CER', 'HIDE');

                            break;

                        case '145' : //Free Trial
                            appSubType = '374';

                            $("#gstChk").val('').prop("disabled", true);
                            $('#pBtnCal').addClass("blind");
                            $("#corpCustType").val('').prop("disabled", true);
                            $("#agreementType").val('').prop("disabled", true);
                            fn_tabOnOffSet('REL_CER', 'HIDE');

                            break;

                        default :
                            $('#installDur').val('').prop("readonly", true).addClass("readonly");
                            $("#gstChk").val('0');
                            $('#pBtnCal').addClass("blind");
                            $("#corpCustType").val('').prop("disabled", true);
                            $("#agreementType").val('').prop("disabled", true);
                            fn_tabOnOffSet('REL_CER', 'HIDE');

                            break;
                    }

                    var pType = $("#appType").val() == '66' ? '1' : '2';
                    var custTypeId  = $('#typeId').val();
                    var nationalityId = $('#nation').val();

                    if (custTypeId != '964' || (custTypeId == '964' && nationalityId != '1') ) {
                        doGetComboData('/sales/order/selectServicePackageList2.do', {appSubType : appSubType, pType : pType}, '', 'srvPacId', 'S', 'fn_srvPacId'); //APPLICATION SUBTYPE
                    } else {
	                    //doGetComboData('/common/selectCodeList.do', {pType : pType}, '',  'srvPacId',  'S', 'fn_setDefaultSrvPacId'); //APPLICATION SUBTYPE
	                    doGetComboData('/sales/order/selectServicePackageList.do', {appSubType : appSubType, pType : pType}, '', 'srvPacId', 'S', 'fn_srvPacId'); //APPLICATION SUBTYPE
                    }
                    $('#ordProduct1 ').removeAttr("disabled");
                    $('#ordProduct2 ').removeAttr("disabled");
                }
            } else {
                $('#srvPacId option').remove();
                // ONGHC - ADD
                /* $('#ordProduct1').prop("disabled", true);
                $('#ordProduct2').prop("disabled", true); */

                $('#srvPacId').change();
            }
            //$('#srvPacId').chang();
            /* $('#ordProduct1 option').remove();
            $('#ordProduct1 optgroup').remove();
            $('#ordProduct2 option').remove();
            $('#ordProduct2 optgroup').remove();

            // ONGHC - ADD
            $('#ordPromo1 option').remove();
            $('#ordPromo1').prop("disabled", true);
            $('#ordPromo2 option').remove();
            $('#ordPromo2').prop("disabled", true); */

            //fn_clearAddCpnt();
        });

        $('#srvPacId').change(function() {
            // ONGHC - ADD
            $('#ordProduct1 option').remove();
            $('#ordProduct1 optgroup').remove();
            $('#ordProduct2 option').remove();
            $('#ordProduct2 optgroup').remove();

            $('#ordPromo1 option').remove();
            $('#ordPromo1').prop("disabled", true);
            $('#ordPromo2 option').remove();
            $('#ordPromo2').prop("disabled", true);

            $('#ordProduct1, #ordProduct2').change();

            fn_clearAddCpnt();

            var idx    = $("#srvPacId option:selected").index();
            var selVal = $("#srvPacId").val();

            if(idx > 0) {
                // ONGHC - ADD
                $('#ordProduct1').removeAttr("disabled");
                $('#ordProduct2').removeAttr("disabled");
                //doGetProductCombo('/sales/order/selectProductCodeList.do',  stkType, '', 'ordProduct', 'S', ''); //Product Code

                // product comboBox 생성
                fn_setProductCombo();
            } else {
                // ONGHC - ADD
                $('#ordProduct1').prop("disabled", true);
                $('#ordProduct2').prop("disabled", true);
            }

            //debugger;
            if($('#ordProduct1 option').length < 2 && $('#ordProduct2 option').length >= 2){
            	$('#btnMatRltdNo').removeClass("blind");
            	MAT_TAG = 'Y';
            }else{
            	$('#btnMatRltdNo').addClass("blind");
            	MAT_TAG = 'N';
            }
        });

        // Product Change Event
        $('#ordProduct1, #ordProduct2').change(function(event) {
            var _tagObj = $(event.target);
            var _tagId = _tagObj.attr('id');
            var _tagNum = _tagId.replace(/[^0-9]/g,"");
            if(FormUtil.checkReqValue($('#exTrade'))) {
                Common.alert('<spring:message code="sal.alert.msg.saveSalOrdSum" />' + DEFAULT_DELIMITER + '<spring:message code="sal.alert.msg.plzSelExTrade" />');
                _tagObj.val('');
                return;
            }

            $('#ordPromo'+_tagNum+' option').remove();
            // 필드 초기화.
            var dataList = $('[data-ref="'+_tagId+'"]');
            for(var i=0; i<dataList.length; ++i) {
            	$('#'+ $(dataList[i]).attr('id')).val('');
            }

            //check main aircon only ajax
            if(_tagNum == "1"){
                stockIdVal = $("#ordProduct"+_tagNum).val();
                //
                if(!FormUtil.isEmpty(stockIdVal)){
                	checkIfIsAcInstallationProductCategoryCode(stockIdVal);
                }
            }

            if(FormUtil.isEmpty(_tagObj.val())) {
            	totSumPrice();   // 합계
                return;
            }else{
                let stkId   = $("#ordProduct"+_tagNum).val();
                let pacId   = ( $('#srvPacId').val() || '${orderInfo.basicInfo.srvPacId}' );
                let appTypeId = $("#appType").val();

                Common.ajaxSync("GET", "/sales/productMgmt/selectProductDiscontinued.do", {stkId: stkId ,pacId: pacId, appTypeId: appTypeId}, function(result) {
                    if(result != null)
                        Common.confirm('<spring:message code="sal.alert.msg.cnfrmToSave" />' + DEFAULT_DELIMITER + '<spring:message code="sales.msg.discontinuedProduct" />', "");
                },  function(jqXHR, textStatus, errorThrown) {
                    try {
                        Common.alert('<spring:message code="sal.alert.title.saveFail" />' + DEFAULT_DELIMITER + '<b><spring:message code="sal.alert.msg.failSaveOrd" /></b>');
                    }
                    catch (e) {
                        console.log(e);
                    }

                    alert("Fail : " + jqXHR.responseJSON.message);
              });}

            $('#trialNoChk').prop("checked", false).prop("disabled", true);
            $('#trialNo').addClass("readonly");
            $('#ordPrice'+ _tagNum).addClass("readonly");
            $('#ordPv'+ _tagNum).addClass("readonly");
            $('#ordRentalFees'+ _tagNum).addClass("readonly");

            var appTypeIdx = $("#appType option:selected").index();
            var appTypeVal = $("#appType").val();
            var custTypeVal = $("#typeId").val();
            var stkIdx         = $("#ordProduct"+_tagNum+" option:selected").index();
            var stkIdVal      = $("#ordProduct"+_tagNum).val();
            var empChk     = $("#empChk").val();
            var exTrade      = $("#exTrade").val();
            var srvPacId      = appTypeVal == '66' ? $('#srvPacId').val() ||  '${orderInfo.basicInfo.srvPacId}'  : 0;
            if(stkIdx > 0) {
                fn_loadProductPrice(appTypeVal, stkIdVal, srvPacId, _tagNum);
                /* if(_tagNum == '2') {
                    fn_loadProductPromotion2(appTypeVal, stkIdVal, empChk, custTypeVal, exTrade, _tagNum);
                } else { */

                //}
                if(copyChangeYn == 'Y') {
                	if(_tagNum == '1') {
                        fn_loadProductPromotion_chg(appTypeVal, stkIdVal, empChk, custTypeVal, exTrade, '${orderInfo.basicInfo.ordPromoId}', _tagNum);
                    } else {
                        fn_loadProductPromotion_chg(appTypeVal, stkIdVal, empChk, custTypeVal, exTrade, '${orderInfo2.basicInfo.ordPromoId}', _tagNum);
                    }
                } else {
                	fn_loadProductPromotion(appTypeVal, stkIdVal, empChk, custTypeVal, exTrade, _tagNum);
                }
            }

            fn_loadProductComponent(appTypeVal, stkIdVal, _tagNum);
            setTimeout(function() { fn_check(0, _tagNum) }, 200);
        });

        $('#rentPayMode').change(function() {
            console.log('rentPayMode click event');

            fn_clearRentPaySetCRC();
            fn_clearRentPaySetDD();

            var rentPayModeIdx = $("#rentPayMode option:selected").index();
            var rentPayModeVal = $("#rentPayMode").val();

            if(rentPayModeIdx > 0) {
                if(rentPayModeVal == '133' || rentPayModeVal == '134') {
                    Common.alert('<spring:message code="sal.alert.msg.notProvideSvc" arguments="'+rentPayModeVal+'"/>');
                    fn_clearRentPayMode();
                }
                else {
                    if(rentPayModeVal == '131') {
                        if($('#thrdParty').is(":checked") && FormUtil.isEmpty($('#hiddenThrdPartyId').val())) {
                            Common.alert('<spring:message code="sal.alert.msg.plzSelThirdPartyFirst" />');
                        } else {
                            $('#sctCrCard').removeClass("blind");
                        }
                    }
                    else if(rentPayModeVal == '132') {
                        if($('#thrdParty').is(":checked") && FormUtil.isEmpty($('#hiddenThrdPartyId').val())) {
                            Common.alert('<spring:message code="sal.alert.msg.plzSelThirdPartyFirst" />');
                        } else {
                            $('#sctDirectDebit').removeClass("blind");
                        }
                    }
                }
            }
        });


        $('#exTrade').change(function() {

        	$('#ordPromo1 option').remove();
            $('#ordPromo2 option').remove();
            fn_clearAddCpnt();
            fn_clearOrderSalesman();

            $('#isReturnExtrade').prop("checked", false);
            $('#isReturnExtrade').attr("disabled",true);

            if($("#exTrade").val() == '1' || $("#exTrade").val() == '2') {
                //$('#relatedNo').removeAttr("readonly").removeClass("readonly");
                $('#btnRltdNo').removeClass("blind");

                if($('#exTrade').val()=='1'){
                	//$('#isReturnExtrade').prop("checked", true); --no product return
                    var todayDD = Number(TODAY_DD.substr(0, 2));
                    var todayYY = Number(TODAY_DD.substr(6, 4));

                    var strBlockDtFrom = blockDtFrom + BEFORE_DD.substr(2);
                    var strBlockDtTo = blockDtTo + TODAY_DD.substr(2);

                    console.log("todayDD: " + todayDD);
                    console.log("blockDtFrom : " + blockDtFrom);
                    console.log("blockDtTo : " + blockDtTo);

                     if(todayDD >= blockDtFrom && todayDD <= blockDtTo) { // Block if date > 22th of the month
                         $('#isReturnExtrade').attr("disabled",true);
                         $('#ordProduct1').val('');
                         $('#ordProduct2').val('');
                         $('#speclInstct').val('');

                    	 var msg = "Extrade sales key-in does not meet period date (Submission start on 1st of every month)";
                         Common.alert('<spring:message code="sal.alert.msg.actionRestriction" />' + DEFAULT_DELIMITER + "<b>" + msg + "</b>", '');
                         return;
                     }
               }


            } else {
                //$('#relatedNo').val('').prop("readonly", true).addClass("readonly");
                 $('#txtOldOrderID').val('');
                 $('#txtBusType').val('');
                $('#relatedNo').val('');
                $('#btnRltdNo').addClass("blind");
                $('#isReturnExtrade').prop("checked", false);
                $('#ordProduct1').val('');
                $('#ordProduct2').val('');
            }
            $('#isReturnExtrade').attr("disabled",true);
            $('#ordProduct1').val('');
            $('#ordProduct2').val('');
        });


        $('#btnCal').click(function() {
            if($("#ordProduct1 option:selected").index() <= 0) {
                Common.alert('<spring:message code="sal.alert.msg.plzSelProd" />');
                return false;
            }
            var appTypeName  = $('#appType option:selected').text();
            var productName  = $('#ordProduct1 option:selected').text();
            //Amount before GST
            var oldPrice     = $('#orgOrdPrice').val();
            var newPrice     = $('#ordPrice').val();
            var oldRental    = $('#orgOrdRentalFees').val();
            var newRental    = $('#ordRentalFees').val();
            var oldPv        = $('#ordPv').val();

            //Amount of GST applied
            var oldPriceGST  = fn_calcGst(oldPrice);
            var newPriceGST  = fn_calcGst(newPrice);
            var oldRentalGST = fn_calcGst(oldRental);
            var newRentalGST = fn_calcGst(newRental);
            var newPv        = $('#ordPvGST').val();

            if($('#appType').val() != '66') {
                oldPriceGST = Math.floor(oldPriceGST/10) * 10;
                newPriceGST = Math.floor(newPriceGST/10) * 10;
            }

            console.log('oldPriceGST:'+oldPriceGST);
            console.log('newPriceGST:'+newPriceGST);

            var msg = '<spring:message code="sal.alert.msg.gstInfo" arguments="'+appTypeName+';'+productName+';'+newPriceGST+';'+oldRentalGST+';'+newRentalGST+'" argumentSeparator=";"/>';
            fn_excludeGstAmt();

            Common.alert('<spring:message code="sal.alert.msg.gstAmount" />' + DEFAULT_DELIMITER + '<b>'+msg+'</b>');
        });


        $('#ordPromo1, #ordPromo2').change(function(event) {
        	var _tagObj = $(event.target);
            var _tagId = _tagObj.attr('id');
            var _tagNum = _tagId.replace(/[^0-9]/g,"");

            if(_tagNum == 1){
                  // == CHECK COMBO PROMOTION HERE ==  ordProudct
                  Common.ajax("POST", "/homecare/sales/order/chkPromoCboMst.do", { promoNo:$("#ordPromo"+_tagNum).val(), prod:$("#ordProduct"+_tagNum).val(), custId : $("#hiddenCustId").val()}, function(result) {

                    if(result != null) {
                        if (result.code == '3') {
                              // PROCEED TO SELECT COMBO PROMOTION
                              $('#trCboOrdNoTag').css("visibility","visible");
                        } else if (result.code == '4') {
                                // THERE HAVE NO ORDER TO TAG FOR COMBO PROMOTION
                                 $('#trCboOrdNoTag').css("visibility","collapse");
                                 $("#ordPromo"+_tagNum).prop("selectedIndex", 0);
                                 Common.alert('<spring:message code="sal.alert.msg.cboNoOrdTag" />');
                                 return false;
                        } else if (result.code == '99') {
                                Common.alert('<spring:message code="sal.alert.msg.promoCancalCode" />');
                                $('#trCboOrdNoTag').css("visibility","collapse");
                                $("#ordPromo"+_tagNum).prop("selectedIndex", 0);
                                return false;
                        } else {
                          // DO NTH
                              $('#trCboOrdNoTag').css("visibility","collapse");
                        }
                        $('#cboOrdNoTag').val("");
                        $('#hiddenCboOrdNoTag').val("");
                      }
                  });
            }
            fn_promoChg(_tagNum);

            fn_checkPromotionExtradeAvail();
        });


        $('[name="ordSaveBtn"]').click(function() {
            if(bulkOrderYn == 'Y' && FormUtil.checkReqValue($('#hiddenCopyQty'))) {
                Common.popupDiv("/sales/order/copyOrderBulkPop.do");

            } else {
                fn_preCheckSave();
            }
        });
    });

    function fn_srvPacId() {
    	$('#srvPacId').change();
    }

    function fn_promoChg1(){
    	fn_promoChg("1");
    }

    function fn_promoChg2(){
    	fn_promoChg("2");
    }

    function fn_promoChg(_tagNum) {
        $('#trialNoChk').prop("checked", false).prop("disabled", true);
        $('#trialNo').val('').addClass("readonly");

        var appTypeIdx  = $("#appType option:selected").index();
        var appTypeVal  = $("#appType").val();
        var stkIdIdx      = $("#ordProduct"+_tagNum+" option:selected").index();
        var stkIdVal      = $("#ordProduct"+_tagNum).val();
        var promoIdIdx = $("#ordPromo"+_tagNum+" option:selected").index();
        var promoIdVal = $("#ordPromo"+_tagNum).val();

       var srvPacId  = appTypeVal == '66' ? $('#srvPacId').val() || '${orderInfo.basicInfo.srvPacId}': 0;

       if(_tagNum == '1'){
    	   voucherPromotionCheck();
       }

        if(promoIdIdx > 0 && promoIdVal != '0') {
        	if(appTypeVal == '66' || appTypeVal == '67' || appTypeVal == '68') {
                $('#trialNoChk').removeAttr("disabled");
            }
            fn_loadPromotionPrice(promoIdVal, stkIdVal, srvPacId, _tagNum);
        } else {
             fn_loadProductPrice(appTypeVal, stkIdVal, srvPacId, _tagNum);
        }
    }

    function fn_preCheckSave() {
        if(!fn_validCustomer()) {
            $('#aTabCS').click();
            return false;
        }

        if(!fn_validMailAddress()) {
            $('#aTabBD').click();
            return false;
        }

        if(!fn_validContact()) {
            $('#aTabBD').click();
            return false;
        }

        if(!fn_validSales()) {
            $('#aTabSO').click();
            return false;
        }

        if(!fn_validRentPaySet()) {
            $('#aTabPC').click();
            return false;
        }

        if(!fn_validBillGroup()) {
            $('#aTabBD').click();
            return false;
        }

        if(!fn_validInstallation()) {
            $('#aTabIN').click();
            return false;
        }

        if(!fn_validDocument()) {
            $('#aTabDC').click();
            return false;
        }

        if(!fn_validCert()) {
            $('#aTabRC').click();
            return false;
        }

        if($("#ordProduct1 option:selected").index() > 0 && $("#ordProduct2 option:selected").index() > 0) {
            // product size check
            Common.ajax("GET", "/homecare/sales/order/checkProductSize.do", {product1 : $("#ordProduct1 option:selected").val(), product2 : $("#ordProduct2 option:selected").val()}, function(result) {
                if(result.code != '00') {
                    Common.alert('<spring:message code="sal.alert.msg.saveSalOrdSum" />' + DEFAULT_DELIMITER + "<b>"+result.message+"</b>");
                    $('#aTabSO').click();
                    return false;

                } else {
                	fn_preCheckSave2();
                }
            });
        } else {
        	fn_preCheckSave2();
        }
    }


    function fn_preCheckSave2() {
        var isValid = true;
        var msg = "";
        var docSelCnt = 0;

        //첨부파일이 존재하면
        if(!FormUtil.checkReqValue($('#certRefFile'))) {
            isValid = false;
            msg += '<spring:message code="sal.alert.msg.certRefFile1" />' + '<spring:message code="sal.alert.msg.certRefFile2" />' + '<spring:message code="sal.alert.msg.certRefFile3" />';
        }
        docSelCnt = fn_getDocChkCount();

        if(docSelCnt <= 0) {
            isValid = false;
            msg += '<spring:message code="sal.alert.msg.docuChk" />';
        }

        if(convToOrdYn == 'Y') {// if it is eKeyin order
        	Common.ajax("GET", "/sales/order/selRcdTms.do", {preOrdId : preOrdId, rcdTms : rcdTms}, function(result) {
                if(result.code == "99"){
                    Common.alert("Save Pre-Order Summary" + DEFAULT_DELIMITER + "<b>"+result.message+"</b>", fn_orderRegPopClose());
                    return;
                }else{
                	if($('#custCntcTelM').val() != null && $('#srvCntcTelM').val() != null ) {
                        var contactNumber = {
                              contactNumber       : $('#custCntcTelM').val()
                            , residenceNumber    : $('#custCntcTelR').val()
                            , officeNumber          : $('#custCntcTelO').val()
                            , faxNumber             : $('#custCntcTelF').val()
                            , asContactNumber    : $('#srvCntcTelM').val()
                            , asResidenceNumber : $('#srvCntcTelR').val()
                            , asOfficeNumber       : $('#srvCntcTelO').val()
                            , asFaxNumber          : $('#srvCntcTelF').val()
                        };

                        Common.ajax("GET", "/sales/customer/existingHPCodyMobile", contactNumber , function(result) {
                            if(result != null) {
                                Common.confirm("<spring:message code='sal.alert.msg.existingHPCodyMobileForSales' arguments = '" + result.fullName + " ; " + result.memCode+"' htmlEscape='false' argumentSeparator=';' />", function() {
                                    if(docSelCnt <= 0) {
                                        Common.confirm('<spring:message code="sal.alert.msg.cnfrmToSave" />' + DEFAULT_DELIMITER + msg, fn_hiddenSave);
                                    } else {
                                        fn_popOrderDetail();
                                    }
                                });
                             } else {
                                 fn_popOrderDetail();
                             }
                        });
                    }
                }
            });
        } else {
            if(!isValid) {
                Common.confirm('<spring:message code="sal.alert.msg.cnfrmToSave" />' + DEFAULT_DELIMITER + msg, fn_hiddenSave);

            } else {
                if($("#ordPromo1 option:selected").index() > 0) {
                    if($("#exTrade").val() == 1 || $("#exTrade").val() == 2) {
                        console.log('!@#### ordSaveBtn click START 11111');
                        $('#txtOldOrderID').val();
                        $('#relatedNo').val();
                        Common.popupDiv("/homecare/sales/order/oldOrderPop.do", {custId : $('#hiddenCustId').val(), salesOrdNo :$('#relatedNo').val(),busType:$('#txtBusType').val()}, null, true);

                    } else {
                    	fn_popOrderDetail();
                    }

                } else {
                	fn_popOrderDetail();
                }
            }
        }
    }

    function fn_popOrderDetail() {
        Common.popupDiv("/homecare/sales/order/hcCnfmOrderDetailPop.do");
    }

    function fn_excludeGstAmt() {
        //Amount before GST
        var oldPrice     = $('#orgOrdPrice').val();
        var newPrice     = $('#ordPrice').val();
        var oldRental    = $('#orgOrdRentalFees').val();
        var newRental    = $('#ordRentalFees').val();
        var oldPv        = $('#ordPv').val();

        //Amount of GST applied
        var oldPriceGST  = fn_calcGst(oldPrice);
        var newPriceGST  = fn_calcGst(newPrice);
        var oldRentalGST = fn_calcGst(oldRental);
        var newRentalGST = fn_calcGst(newRental);
        var newPv        = $('#ordPvGST').val();

        if($('#appType').val() != '66') {
            oldPriceGST = Math.floor(oldPriceGST/10) * 10;
            newPriceGST = Math.floor(newPriceGST/10) * 10;
        }

        $('#orgOrdPrice').val(oldPriceGST);
        $('#ordPrice').val(newPriceGST);
        $('#orgOrdRentalFees').val(oldRentalGST);
        $('#ordRentalFees').val(newRentalGST);
        $('#ordPv').val(newPv);

        $('#pBtnCal').addClass("blind");
    }

    function fn_includeGstAmt() {
        $("#gstChk").val('0');
        $('#pBtnCal').addClass("blind");
    }

    function fn_selectCustInfo() {
        var strCustId = $('#custId').val();
        //CLEAR CUSTOMER
        fn_clearCustomer();
        fn_clearMailAddress();
        fn_clearContactPerson();

        //CLEAR SALES
        fn_tabOnOffSet('PAY_CHA', 'HIDE');

        // ONGHC - ADD
        $('#srvPacId option').remove();
        $('#ordProduct1 option').remove();
        $('#ordProduct1 optgroup').remove();
        $('#ordPromo option').remove();
        fn_clearAddCpnt();

        $('#srvPacId option').addClass("blind");
        $('#ordProduct1').prop("disabled", true);
        $('#ordPromo').prop("disabled", true);

        $('#appType').val('');

        //ClearControl_Sales();
        fn_clearSales();

        //CLEAR RENTAL PAY SETTING
        $('#thrdParty').val('');

        fn_clearRentPayMode();
        fn_clearRentPay3thParty();
        fn_clearRentPaySetCRC();
        fn_clearRentPaySetDD();

        //CLEAR BILLING GROUP
        fn_clearBillGroup();

        //CLEAR INSTALLATION
        fn_clearInstallAddr();
        fn_clearCntcPerson();

        //CLEAR Search Form
        fn_clearSearchForm();

        if(FormUtil.isNotEmpty(strCustId) && strCustId > 0) {
            fn_loadCustomer(strCustId);
        }
        else {
            Common.alert('<b>Invalid customer ID.</b>');
        }
    }


/*******************************************************************************
    Save Logic [START]
*******************************************************************************/
    function fn_hiddenSave() {
        if($("#ordPromo option:selected").index() > 0) {
            if($("#exTrade").val() == 1 || $("#exTrade").val() == 2) {
                Common.popupDiv("/sales/order/oldOrderPop.do", {custId : $('#hiddenCustId').val()}, null, true);
            } else {
            	fn_popOrderDetail();
            }

        } else {
        	fn_popOrderDetail();
        }
    }

    function fn_doSaveOrder() {
        $("#promoDiscPeriodTp1").removeAttr("disabled");
        $("#promoDiscPeriodTp2").removeAttr("disabled");
        $("#dscBrnchId").removeAttr("disabled");

        //----------------------------------------------------------------------
        // salesOrderMVO
        //----------------------------------------------------------------------
        var vAppType    = $('#appType').val();
        var vCustBillId = $('input:radio[name="grpOpt"]:checked').val() == 'exist' ? $('#hiddenBillGrpId').val() : 0;
        var vBindingNo  = FormUtil.isNotEmpty($('#txtOldOrderID').val().trim()) ? $('#relatedNo').val().trim() : $('#hiddenOldOrderId').val().trim();
        var vBusType = $('#txtBusType').val();
        var vCnvrSchemeId;

        if($('#trialNoChk').is(":checked")) {
            vBindingNo = $('#trialNo').val().trim();
            vCnvrSchemeId = $('#trialId').val().trim();
        }
        var vIsReturnExtrade = "";
        if($('#exTrade').val() == 1){
            if($('#isReturnExtrade').is(":checked")) {
                vIsReturnExtrade = 1;
            }else{
                vIsReturnExtrade = 0;
            }
        }

        //----------------------------------------------------------------------
        // rentPaySetVO
        //----------------------------------------------------------------------
        var vCustCRCID = $('#rentPayMode').val() == '131' ? $('#hiddenRentPayCRCId').val() : 0;
        var vCustAccID = $('#rentPayMode').val() == '132' ? $('#hiddenRentPayBankAccID').val() : 0;
        var vBankID    = $('#rentPayMode').val() == '131' ? $('#hiddenRentPayCRCBankId').val() : $('#rentPayMode').val() == '132' ? $('#hiddenAccBankId').val() : 0;
        var vIs3rdParty = $('#thrdParty').is(":checked") ? 1 : 0;
        var vCustomerId = $('#thrdParty').is(":checked") ? $('#hiddenThrdPartyId').val() : $('#hiddenCustId').val();
        var vIssuNric = FormUtil.isNotEmpty($('#rentPayIC').val().trim()) ? $('#rentPayIC').val().trim() : $('#thrdParty').is(":checked") ? $('#thrdPartyNric').val().trim() : $('#nric').val().trim();

        //----------------------------------------------------------------------
        // accClaimAdtVO
        //----------------------------------------------------------------------
        var vAccNo = "";
        var vAccName = "";
        var vIssueBankID = 0;
        var vAdtPayMode = "REG";
        var vECash = 0;

        if($('#rentPayMode').val() == '130') {
            vAdtPayMode = "REG";
        } else if($('#rentPayMode').val() == '131') {
            vAccNo = $('#hiddenRentPayCRCId').val().trim();
            vAccName = $('#rentPayCRCName').val().trim();
            vAdtPayMode = "CRC";
            vECash = 1;

        } else if($('#rentPayMode').val() == '132') {
            vAccNo = $('#hiddenRentPayBankAccID').val().trim();
            vAccName = $('#accName').val().trim()
            vAdtPayMode = "DD";

        } else if($('#rentPayMode').val() == '133') {
            vAdtPayMode = "AEON";

        } else if($('#rentPayMode').val() == '134') {
            vAdtPayMode = "FPX";
        }
        var orderVO = {
            custTypeId           : $('#typeId').val().trim(),
            raceId                 : $('#raceId').val().trim(),
            billGrp                 : $('input:radio[name="grpOpt"]:checked').val(),
            preOrdId              : '',
            matPreOrdId         : '${matPreOrdId}',
            fraPreOrdId           : '${fraPreOrdId}',
            preOrderYN           : '${CONV_TO_ORD_YN}',
            copyOrderBulkYN   : '${BULK_ORDER_YN}',
            copyOrderChgYn    : "${COPY_CHANGE_YN}",
            copyQty               : $('#hiddenCopyQty').val(),
            ordSeqNo             : '${ordSeqNo}' > 0 ? '${ordSeqNo}' : $('#matBndlId').val(),

            salesOrderMVO1 : {
                advBill                   : $('input:radio[name="advPay"]:checked').val(),
                appTypeId              : $('#appType').val(),
                srvPacId                 : $('#srvPacId').val(),
                bindingNo               : vBindingNo,
                busType                  : vBusType,
                isExtradePR             : vIsReturnExtrade,
                cnvrSchemeId          : vCnvrSchemeId,
                custAddId               : $('#hiddenBillAddId').val().trim(),
                custBillId                : vCustBillId,
                custCareCntId          : $('#srvCntcId').val().trim(),
                custCntId                : $('#hiddenCustCntcId').val().trim(),
                custId                     : $('#hiddenCustId').val().trim(),
                custPoNo                 : $('#poNo').val().trim(),
                defRentAmt              : vAppType == '66' ? $('#ordRentalFees1').val().trim() : 0,
                deptCode                 : $('#departCd').val().trim(),
                grpCode                   : $('#grpCd').val().trim(),
                instPriod                  : $('#installDur').val().trim(),
                memId                     : $('#hiddenSalesmanId').val().trim(),
                mthRentAmt             : $('#ordRentalFees1').val().trim(), //2017.10.12 ordRentalFees 또는 orgOrdRentalFees 아직 미결정 2017.10.14 ordRentalFees로 결정
                orgCode                   : $('#orgCd').val().trim(),
                promoId                   : $('#ordPromo1').val(),
                refNo                       : $('#refereNo').val().trim(),
                rem                         : $('#ordRem').val().trim(),
                salesGmId                : $('#orgMemId').val().trim(),
                salesHmId                : $('#departMemId').val().trim(),
                salesOrdIdOld           : $('#txtOldOrderID').val(),
                salesSmId                : $('#grpMemId').val().trim(),
                totAmt                     : parseFloat(js.String.naNcheck($('#ordPrice1').val().trim())) + js.String.naNcheck(parseFloat($('#ordPrice2').val().trim())),
                totPv                       : parseFloat(js.String.naNcheck($('#ordPv1').val().trim())) + js.String.naNcheck(parseFloat($('#ordPv2').val().trim())),
                empChk                   : $('#empChk').val(),
                exTrade                   : $('#exTrade').val(),
                ecash                      : vECash,
                promoDiscPeriodTp    : $('#promoDiscPeriodTp1').val(),
                promoDiscPeriod        : $('#promoDiscPeriod1').val().trim(),
                norAmt                     : $('#orgOrdPrice1').val().trim(),
                norRntFee                 : $('#orgOrdRentalFees1').val().trim(),
                discRntFee                : $('#ordRentalFees1').val().trim(),
                gstChk                      : $('#gstChk').val(),
                corpCustType             : $('#corpCustType').val(),
                agreementType          : $('#agreementType').val(),
                comboOrdBind           : $('#hiddenCboOrdNoTag').val(),
                receivingMarketingMsgStatus   : $('input:radio[name="marketingMessageSelection"]:checked').val()
                ,voucherCode : voucherAppliedCode
            },
            salesOrderMVO2 : {
                advBill                    : $('input:radio[name="advPay"]:checked').val(),
                appTypeId              : $('#appType').val(),
                srvPacId                  : $('#srvPacId').val(),
                //bindingNo               : vBindingNo,
                cnvrSchemeId          : vCnvrSchemeId,
                custAddId                : $('#hiddenBillAddId').val().trim(),
                custBillId                 : vCustBillId,
                custCareCntId           : $('#srvCntcId').val().trim(),
                custCntId                 : $('#hiddenCustCntcId').val().trim(),
                custId                      : $('#hiddenCustId').val().trim(),
                custPoNo                 : $('#poNo').val().trim(),
                defRentAmt              : vAppType == '66' ? $('#ordRentalFees2').val().trim() : 0,
                deptCode                 : $('#departCd').val().trim(),
                grpCode                   : $('#grpCd').val().trim(),
                instPriod                   : $('#installDur').val().trim(),
                memId                     : $('#hiddenSalesmanId').val().trim(),
                mthRentAmt              : $('#ordRentalFees2').val().trim(), //2017.10.12 ordRentalFees 또는 orgOrdRentalFees 아직 미결정 2017.10.14 ordRentalFees로 결정
                orgCode                   : $('#orgCd').val().trim(),
                promoId                   : $('#ordPromo2').val(),
                refNo                       : $('#refereNo').val().trim(),
                rem                         : $('#ordRem').val().trim(),
                salesGmId                : $('#orgMemId').val().trim(),
                salesHmId                : $('#departMemId').val().trim(),
                //salesOrdIdOld           : $('#txtOldOrderID').val(),
                salesSmId                 : $('#grpMemId').val().trim(),
                totAmt                     : $('#ordPrice2').val().trim(),
                totPv                       : $('#ordPv2').val().trim(),
                empChk                   : $('#empChk').val(),
                //exTrade                   : $('#exTrade').val(),
                ecash                      : vECash,
                promoDiscPeriodTp   : $('#promoDiscPeriodTp2').val(),
                promoDiscPeriod      : $('#promoDiscPeriod2').val().trim(),
                norAmt                   : $('#orgOrdPrice2').val().trim(),
                norRntFee                : $('#orgOrdRentalFees2').val().trim(),
                discRntFee               : $('#ordRentalFees2').val().trim(),
                gstChk                    : $('#gstChk').val(),
                corpCustType           : $('#corpCustType').val(),
                agreementType        : $('#agreementType').val()
                ,voucherCode : voucherAppliedCode
            },
            salesOrderDVO1 : {
                itmPrc                       : $('#ordPrice1').val().trim(),
                itmPrcId                    : $('#ordPriceId1').val().trim(),
                itmPv                        : $('#ordPv1').val().trim(),
                itmStkId                    : $('#ordProduct1').val(),
                itmCompId                : $('#compType1').val(),
                isExstCust : $("#hiddenCustStatusId").val(),
            },
            salesOrderDVO2 : {
                itmPrc                       : $('#ordPrice2').val().trim(),
                itmPrcId                    : $('#ordPriceId2').val().trim(),
                itmPv                        : $('#ordPv2').val().trim(),
                itmStkId                    : $('#ordProduct2').val(),
                itmCompId                : $('#compType2').val(),
                isExstCust : $("#hiddenCustStatusId").val(),
            },
            installationVO : {
                addId                       : $('#hiddenCustAddId').val(),
                brnchId                    : $('#dscBrnchId').val(),
                cntId                       : $('#hiddenInstCntcId').val(),
                instct                       : $('#speclInstct').val(),
                preDt                      : $('#prefInstDt').val(),
                preTm                     : $('#prefInstTm').val()
            },
            rentPaySetVO : {
                bankId                  : vBankID,
                custAccId              : vCustAccID,
                custCrcId               : vCustCRCID,
                custId                   : vCustomerId,
                is3rdParty              : vIs3rdParty,
                issuNric                 : vIssuNric,
                modeId                 : $('#rentPayMode').val(),
                nricOld                  : $('#rentPayIC').val().trim(),
            },
            custBillMasterVO : {
                custBillAddId              : $("#hiddenBillAddId").val().trim(),
                custBillCntId               : $("#hiddenCustCntcId").val().trim(),
                custBillCustCareCntId   : $("#hiddenBPCareId").val().trim(),
                custBillCustId              : $('#hiddenCustId').val().trim(),
                custBillIsEstm             : $('#billMthdEstm').is(":checked") ? 1 : 0,
                custBillEmail               : $('#billMthdEmailTxt1').val().trim(),
                custBillEmailAdd         : $('#billMthdEmailTxt2').val().trim(),
                custBillIsPost              : $('#billMthdPost').is(":checked") ? 1 : 0,
                custBillIsSms              : $('#billMthdSms1').is(":checked") ? 1 : 0,
                custBillIsSms2            : $('#billMthdSms2').is(":checked") ? 1 : 0,
                custBillIsWebPortal     : $('#billGrpWeb').is(":checked")   ? 1 : 0,
                custBillRem               : $('#billRem').val().trim(),
                custBillWebPortalUrl   : $('#billGrpWebUrl').val().trim(),
                custBillIsEInv            : $('#billMthdEInv').is(":checked") ? 1 : 0,
            },
            rentalSchemeVO : {

            },
            accClaimAdtVO1 : {
                accClBillClmAmt           : $('#ordRentalFees1').val().trim(),
                accClClmAmt               : $('#ordRentalFees1').val().trim(),
                accClBankAccNo          : vAccNo,
                accClAccTName           : vAccName,
                accClAccNric               : vIssuNric,
                accClPayMode             : vAdtPayMode,
                accClPayModeId          : $('#rentPayMode').val()
            },
            accClaimAdtVO2 : {
                accClBillClmAmt           : $('#ordRentalFees2').val().trim(),
                accClClmAmt               : $('#ordRentalFees2').val().trim(),
                accClBankAccNo          : vAccNo,
                accClAccTName           : vAccName,
                accClAccNric               : vIssuNric,
                accClPayMode             : vAdtPayMode,
                accClPayModeId          : $('#rentPayMode').val()
            },
            eStatementReqVO : {
                email                      : $('#billMthdEmailTxt1').val().trim(),
                emailAdd                : $('#billMthdEmailTxt2').val().trim()
            },
            gSTEURCertificateVO : {
                eurcRefNo              : $('#certRefNo').val().trim(),
                eurcRefDt               : $('#certRefDt').val().trim(),
                eurcCustId              : $('#hiddenCustId').val(),
                eurcCustRgsNo        : $('#txtCertCustRgsNo').val().trim(),
                eurcRem                 : $('#txtCertRemark').val().trim(),
                atchFileGrpId           : $('#atchFileGrpId').val()
            },
            docSubmissionVOList    : GridCommon.getEditData(docGridID)
        };
         console.log(orderVO);
         $("#btnConfirm_RW").hide();
         Common.ajax("POST", "/homecare/sales/order/hcRegisterOrder.do", orderVO, function(result) {
            Common.alert('<spring:message code="sal.alert.msg.ordSaved" />' + DEFAULT_DELIMITER + "<b>"+result.message+"</b>",fn_orderRegPopClose());

        },  function(jqXHR, textStatus, errorThrown) {
        	$("#btnConfirm_RW").show();
            try {
                Common.alert('<spring:message code="sal.alert.title.saveFail" />' + DEFAULT_DELIMITER + '<b><spring:message code="sal.alert.msg.failSaveOrd" /></b><b>' + jqXHR.responseJSON.message + "</b>");
            } catch (e) {
                console.log(e);
            }
            alert("Fail : " + jqXHR.responseJSON.message);
        });
    }

    function fn_orderRegPopClose() {
        if(convToOrdYn == 'Y') {
            fn_getPreOrderList();
        }

        $('#btnCnfmOrderClose').click();
        $('#btnOrdRegClose').click();
    }

/*******************************************************************************
    Validation Check Logic [START]
*******************************************************************************/
    function fn_validCustomer() {
        var isValid = true, msg = "";

        if(FormUtil.checkReqValue($('#hiddenCustId'))) {
            isValid = false;
            msg += '<spring:message code="sal.alert.msg.plzSelCust2" />';
        }

        if($('#appType').val() == '1412' && $('#typeId').val() == '965') {
            isValid = false;
            msg = '<spring:message code="sal.alert.msg.plzSelIndvCustOutP" />';
        }

        if($("#empChk option:selected").index() <=0) {
            isValid = false;
            msg = '<spring:message code="sal.alert.msg.plzSelEmpl" />';
        }

        var newCustDt = new Date("01/02/2023").getTime();
        var custCrtDt = $('#hiddenCustCrtDt').val();

        if(custCrtDt > newCustDt && $("#typeId").val() == 964 && FormUtil.checkReqValue($('#email'))){
                isValid = false;
                msg += '<spring:message code="sal.alert.msg.plzKeyInEmailAddr" />';
        }

        if(!isValid) Common.alert('<spring:message code="sal.alert.msg.saveSalOrdSum" />' + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

        return isValid;
    }

    function fn_validMailAddress() {
        var isValid = true, msg = "";

        if(FormUtil.checkReqValue($('#hiddenBillAddId'))) {
            isValid = false;
            msg += '* <spring:message code="sal.alert.msg.plzSelAddr" />';
        }

        if(!isValid) Common.alert('<spring:message code="sal.alert.msg.saveSalOrdSum" />' + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

        return isValid;
    }

    function fn_validContact() {
        var isValid = true, msg = "";

        if(FormUtil.checkReqValue($('#hiddenCustCntcId'))) {
            isValid = false;
            msg += '* <spring:message code="sal.alert.msg.plzSelCntcPer" /><br>';
        }

        if(!isValid) Common.alert('<spring:message code="sal.alert.msg.saveSalOrdSum" />' + DEFAULT_DELIMITER + "<b>"+msg+ "</b>");

        return isValid;
    }

    function fn_validSales() {
        var isValid = true, msg = "";

        var appTypeIdx = $("#appType option:selected").index();
        var appTypeVal = $("#appType").val();
        var srvPacIdx  = $("#srvPacId option:selected").index();
        var srvPacVal  = $("#srvPacId").val();
        var custType = $("#typeId").val();

        if(appTypeIdx <= 0) {
            isValid = false;
            msg += '<spring:message code="sal.alert.msg.salAppType" /><br>';

        } else if(srvPacIdx <= 0 || srvPacVal == "") {
            isValid = false;
            msg += '* <spring:message code="sal.alert.msg.plzSelPckgType" /><br>';
        } else {
            if(appTypeVal == '68' || appTypeVal == '1412') {
                if(FormUtil.checkReqValue($('#installDur'))) {
                    isValid = false;
                    msg += '<spring:message code="sal.alert.msg.plzKeyinInstDuration" />';
                }
            }

            if(appTypeVal == '66' || appTypeVal == '67' || appTypeVal == '68' || appTypeVal == '1412') {
            	if($("#ordProduct1 option:selected").index() > 0) {
                    if($("#ordPromo1 option:selected").index() <= 0) {
                        isValid = false;
                        msg += "* Please select the matress promotion code.<br>";
                    }
                }
            	// If is MT Rental Starter 60 (SET) and promotion is null
                if($("#ordProduct2 option:selected").index() > 0 && srvPacVal == 10) {
                    if($("#ordPromo2 option:selected").index() <= 0) {
                        isValid = false;
                        msg += "* Please select the frame promotion code.<br>";
                    }
                }
            }

            if(appTypeVal == '66' || appTypeVal == '67' || appTypeVal == '68' || appTypeVal == '1412') {
                if(FormUtil.checkReqValue($('#refereNo'))) {
                    isValid = false;
                    msg += '* <spring:message code="sal.alert.msg.plzSelReferNo" /><br>';
                }
            }

            if(appTypeVal == '66') {
                if($(':radio[name="advPay"]:checked').val() != '1' && $(':radio[name="advPay"]:checked').val() != '0') {
                    isValid = false;
                    msg += '* <spring:message code="sal.alert.msg.plzSelAdvRentPay" /><br>';
                }
            }
        }

        const ordProd1 = $("#ordProduct1");
        const ordProd2 = $("#ordProduct2");

        if((ordProd1.find("option").length > 1 && ordProd1.find("option:selected").index() <= 0) || (ordProd2.find("option").length > 1 && ordProd2.find("option:selected").index() <= 0)){
            isValid = false;
            msg += '* <spring:message code="sal.alert.msg.plzSelPrd" /><br>';
        }
        // 프레임만 주문 불가.
        if($("#ordProduct1 option:selected").index() <= 0 && $("#ordProduct2 option:selected").index() > 0 && MAT_TAG == 'N') {
            isValid = false;
            msg += '* Only frames can not be ordered.<br>';
        }

        if(appTypeVal == '66' || appTypeVal == '67' || appTypeVal == '68' || appTypeVal == '1412') {
            if($("#ordProduct1 option:selected").index() > 0) {
                if($("#ordPromo1 option:selected").index() <= 0) {
                    isValid = false;
                    msg += "* Please select the mattres promotion code.<br>";
                }
            }
            if($("#ordProduct2 option:selected").index() > 0) {
                if($("#ordPromo2 option:selected").index() <= 0) {
                    isValid = false;
                    msg += "* Please select the frame promotion code.<br>";
                }
            }
        }

        if($('#voucherType').val() == ""){
       	 isValid = false;
            msg += "* Please select voucher type.<br>";
       }

       if($('#voucherType').val() != "" && $('#voucherType').val() > 0){
       	if(voucherAppliedStatus == 0){
       	 isValid = false;
            msg += "* You have selected a voucher type. Please apply a voucher is any.<br>";
       	}
       }

     // ADD COMBO PROMOTION CHECKING
        if ($('#trCboOrdNoTag').css("visibility") == "visible") {
          if ($('#cboOrdNoTag').val() == "" || $('#cboOrdNoTag').val() == null) {
                isValid = false;
                text = "<spring:message code='sal.title.text.cboBindOrdNo' />";
                msg += "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/><br>";
          } else  if ($('#hiddenCboOrdNoTag').val() == "" || $('#hiddenCboOrdNoTag').val() == null) {
                isValid = false;
                text = "<spring:message code='sal.title.text.cboBindOrdNo' />";
                msg += "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/><br>";
          }
        }

        // ADD ON COMPONENT CHECKING
        var isChkCompTy1 = true;
        var isChkCompTy2 = true;

        if ($("#compType1 option:selected").val() != undefined){
            if($("#compType1 option").length > 1) {
                if ($("#compType1 option:selected").index() <= 0) {
                	isChkCompTy1 = false;
                }
            }
        }
        if ($("#compType2 option:selected").val() != undefined){
            if($("#compType2 option").length > 1) {
                if ($("#compType2 option:selected").index() <= 0) {
                	isChkCompTy2 = false;
                }
            }
        }
        if(!(isChkCompTy1 && isChkCompTy2)) {
        	isValid = false;
        	msg += '* <spring:message code="sal.alert.msg.plzSelAddCmpt" /><br>';
        }
        // ADD ON COMPONENT CHECKING - END

        if(!FormUtil.checkReqValue($('#hiddenSalesmanId'))) {

            if($('#hiddenSalesmanId').val() == '1' || $('#hiddenSalesmanId').val() == '2') {

                if(appTypeVal == '66' || appTypeVal == '67' || appTypeVal == '68') {

                    if(FormUtil.checkReqValue($('#departCd')) || FormUtil.checkReqValue($('#grpCd')) || FormUtil.checkReqValue($('#orgCd'))) {
                        var memType = $('#hiddenSalesmanTypeId').val() == '1' ? "HP" : "Cody";

                        isValid = false;
                        msg += '* <spring:message code="sal.alert.msg.plzSelOrgCd" arguments="'+memType+'"/><br>';
                    }
                }
            }
        } else {
            if(appTypeIdx > 0 && appTypeVal != 143) {
                isValid = false;
                msg += '<spring:message code="sal.alert.msg.plzSelectSalesman" />';
            }
        }

        if(MAT_TAG == 'Y'){

        	if(FormUtil.checkReqValue($("#matRelatedNo"))){
        		isValid = false;
                msg += '<spring:message code="sal.alert.msg.plzSelMattressOrd" />';
        	}else{
        		 Common.ajaxSync("GET", "/homecare/sales/order/checkProductSize.do", {product1 : $("#matStkId").val(), product2 : $("#ordProduct2 option:selected").val()}, function(result) {
                     if(result.code != '00') {
                    	 isValid = false;
                    	 msg +=  '<spring:message code="sal.alert.msg.matSizeDiff" />';
                     }
                 });
        	}

        }

        // Added for aircond
        if(srvPacVal == 27) {// aircond service package
             Common.ajaxSync("GET", "/homecare/sales/order/checkProductSize.do", {product1 : $("#ordProduct1").val(), product2 : $("#ordProduct2 option:selected").val()}, function(result) {
                 if(result.code != '00') {
                     isValid = false;
                     msg +=  'Product size is different. Please check.';
                 }
             });
        }

        if(!isValid) Common.alert('<spring:message code="sal.alert.msg.saveSalOrdSum" />' + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

        return isValid;
    }

    function fn_isExistESalesNo() {
        var isExist = false, msg = "";

        Common.ajax("GET", "/sales/order/selectExistSofNo.do", {sofNo:$("#refereNo").val(), selType:'2'}, function(rsltInfo) {
            if(rsltInfo != null) {
                isExist = rsltInfo.isExist;
            }
            console.log('isExist:'+isExist);
        });

        return isExist;
    }

    function fn_validRentPaySet() {
        var isValid = true, msg = "";

        var appTypeIdx = $("#appType option:selected").index();
        var appTypeVal = $("#appType").val();
        var rentPayModeIdx = $("#rentPayMode option:selected").index();
        var rentPayModeVal = $("#rentPayMode").val();

        if(appTypeIdx > 0 && appTypeVal == '66') {

            if($('#thrdParty').is(":checked")) {

                if(FormUtil.checkReqValue($('#hiddenThrdPartyId'))) {
                    isValid = false;
                    msg += '<spring:message code="sal.alert.msg.plzSelThirdParty" />';
                }
            }

            if(rentPayModeIdx <= 0) {
                isValid = false;
                msg += '<spring:message code="sal.alert.msg.plzSelRentPayMode" />';
            }
            else {
                if(rentPayModeVal == '131') {
                    if(FormUtil.checkReqValue($('#hiddenRentPayCRCId'))) {
                        isValid = false;
                        msg += '<spring:message code="sal.alert.msg.plzSelCrdCard" />';
                    }
                    else if(FormUtil.checkReqValue($('#hiddenRentPayCRCBankId')) || $('#hiddenRentPayCRCBankId').val() == '0') {
                        isValid = false;
                        msg += '<spring:message code="sal.alert.msg.invalidCrdCardIssuebank" />';
                    }
                }
                else if(rentPayModeVal == '132') {
                    if(FormUtil.checkReqValue($('#hiddenRentPayBankAccID'))) {
                        isValid = false;
                        msg += '<spring:message code="sal.alert.msg.plzSelBankAccount" />';
                    }
                    else if(FormUtil.checkReqValue($('#hiddenAccBankId')) || $('#hiddenRentPayCRCBankId').val() == '0') {
                        isValid = false;
                        msg += '<spring:message code="sal.alert.msg.invalidBankAccIssueBank" />';
                    }
                }
            }
        }

      //20240710 [CELESTE]: Turn off due to unable to collect back all the TIN from Corporate customer. WIND requested to temporarily turn off the checking.
        /* if($('#typeId').val() == '965' && $("#corpTypeId").val() != "1333" && $("#corpTypeId").val() != "1151"){
            if(FormUtil.isEmpty($('#tin').val())){
                isValid = false;
                msg = "* E-Invoice is not allow. Please update customer's TIN number in Customer Management before choosing e-Invoice. <br />";
            }
        }
        else{
            if($("#billMthdEInv").is(":checked") == true){
                isValid = false;
                msg = "* E-Invoice is not allow. Please update customer's TIN number in Customer Management before choosing e-Invoice. <br />";
            }
        } */

        if(!isValid) Common.alert('<spring:message code="sal.alert.msg.saveSalOrdSum" />' + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

        return isValid;
    }

    function fn_validBillGroup() {
        var isValid = true, msg = "";

        var appTypeIdx  = $("#appType option:selected").index();
        var appTypeVal  = $("#appType").val();
        var grpOptSelYN = (!$('#grpOpt1').is(":checked") && !$('#grpOpt2').is(":checked")) ? false : true;
        var grpOptVal   = $(':radio[name="grpOpt"]:checked').val(); //new, exist

        if(!grpOptSelYN) {
            isValid = false;
            msg += '* <spring:message code="sal.alert.msg.plzSelGrpOpt" /><br>';

        } else {
            if(grpOptVal == 'exist') {
                if(FormUtil.checkReqValue($('#hiddenBillGrpId'))) {
                    isValid = false;
                    msg += '* <spring:message code="sal.alert.msg.plzSelBillGrp" /><br>';
                }

            } else {
                if(!$("#billMthdSms" ).is(":checked") && !$("#billMthdPost" ).is(":checked") && !$("#billMthdEstm" ).is(":checked")) {
                    isValid = false;
                    msg += '* <spring:message code="sal.alert.msg.pleaseSelectBillingMethod" /><br>';

                } else {
                    if($("#typeId").val() == '965' && $("#billMthdSms" ).is(":checked")) {
                        isValid = false;
                        msg += '* <spring:message code="sal.alert.msg.smsBillingMethod" /><br>';
                    }

                    if($("#billMthdEstm" ).is(":checked")) {
                        if(FormUtil.checkReqValue($('#billMthdEmailTxt1'))) {
                            isValid = false;
                            msg += '* <spring:message code="sal.alert.msg.plzKeyInEmailAddr" /><br>';

                        } else {
                            if(FormUtil.checkEmail($('#billMthdEmailTxt1').val())) {
                                isValid = false;
                                msg += '* <spring:message code="sal.msg.invalidEmail" /><br>';
                            }
                        }
                        if(!FormUtil.checkReqValue($('#billMthdEmailTxt2')) && FormUtil.checkEmail($('#billMthdEmailTxt2').val())) {
                            isValid = false;
                            msg += '* <spring:message code="sal.msg.invalidEmail" /><br>';
                        }

                    } else {
                        if(!FormUtil.checkReqValue($('#billMthdEmailTxt1')) && FormUtil.checkEmail($('#billMthdEmailTxt1').val())) {
                            isValid = false;
                            msg += '* <spring:message code="sal.msg.invalidEmail" /><br>';
                        }
                        if(!FormUtil.checkReqValue($('#billMthdEmailTxt2')) && FormUtil.checkEmail($('#billMthdEmailTxt2').val())) {
                            isValid = false;
                            msg += '* <spring:message code="sal.msg.invalidEmail" /><br>';
                        }
                    }
                }
            }
        }
        if(!isValid) Common.alert('<spring:message code="sal.alert.msg.saveSalOrdSum" />' + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

        return isValid;
    }

    function fn_validInstallation() {
        var isValid = true, msg = "";

        if($('#validAreaIdYN').val() == "N") {
            isValid = false;
            msg += '* <spring:message code="sal.alert.msg.customerAddrChange" /><br>';
        }

        if(FormUtil.checkReqValue($('#hiddenCustAddId'))) {
            isValid = false;
            msg += '<spring:message code="sal.alert.msg.plzSelInstallAddr" />';
        }

        if($("#dscBrnchId option:selected").index() <= 0) {
            isValid = false;
            msg += '<spring:message code="sal.alert.msg.plzSelDscBrnch" />';
        }

        if(FormUtil.isEmpty($('#prefInstDt').val().trim())) {
            isValid = false;
            msg += '<spring:message code="sal.alert.msg.plzSelPreferInstDate" />';
        }

        if(FormUtil.isEmpty($('#prefInstTm').val().trim())) {
            isValid = false;
            msg += '<spring:message code="sal.alert.msg.plzSelPreferInstTime" />';
        }

        if(!$('#pBtnCal').hasClass("blind")) {
            isValid = false;
            msg += '<spring:message code="sal.alert.msg.pressCalBtn" />';
        }

        if(!isValid) Common.alert('<spring:message code="sal.alert.msg.saveSalOrdSum" />' + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

        return isValid;
    }

    function fn_validDocument() {
        var isValid = true, msg = "";

        if(!isValid) Common.alert('<spring:message code="sal.alert.msg.saveSalOrdSum" />' + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

        return isValid;
    }

    function fn_validCert() {
        var isValid = true, msg = "";

        if(!$('#tabRC').hasClass("blind") && GST_MANNUAL == 'Y') {

            if(FormUtil.checkReqValue($('#certRefFile'))) {
                isValid = false;
                msg += '* <spring:message code="sal.alert.msg.plzUpldReliefCertFile" /><br>';
            }
            if(FormUtil.checkReqValue($('#certRefNo'))) {
                isValid = false;
                msg += '<spring:message code="sal.alert.msg.plzKeyinCertRefNo" />';
            }
            if(FormUtil.isEmpty($('#certRefDt').val().trim())) {
                isValid = false;
                msg += '<spring:message code="sal.alert.msg.plzSelCertRefDate" />';
            }
        }

        if(!isValid) Common.alert('<spring:message code="sal.alert.msg.saveSalOrdSum" />' + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

        return isValid;
    }

    function fn_checkProductQuota() {
        var exceedQuota = false, msg = "";

        Common.ajaxSync("GET", "/sales/productMgmt/selectQuotaCount.do", {stkId : $("#ordProduct1").val() , promoId : $('#ordPromo1').val() , convToOrdYn : convToOrdYn}, function(result) {
            if(result != null) {
                exceedQuota = true;
            }
        });

        Common.ajaxSync("GET", "/sales/productMgmt/selectQuotaCount.do", {stkId : $("#ordProduct2").val() , promoId : $('#ordPromo2').val() , convToOrdYn : convToOrdYn}, function(result) {
            if(result != null) {
                exceedQuota = true;
            }
        });

        if(exceedQuota == true) Common.alert("Pre-Order Summary" + DEFAULT_DELIMITER + "<b>* This product has reached the quota.</b>");

        return exceedQuota;
    }

/*******************************************************************************
    Validation Check Logic [END]
*******************************************************************************/

    function fn_clearOrderSalesman() {
        $('#salesmanId').val('');
        $('#salesmanCd').val('');
        $('#salesmanType').val('');
        $('#salesmanTypeId').val('');
        $('#salesmanNm').val('');
        $('#salesmanNric').val('');
        $('#departCd').val('');
        $('#departMemId').val('');
        $('#grpCd').val('');
        $('#grpMemId').val('');
        $('#orgCd').val('');
        $('#orgMemId').val('');
    }

    function fn_loadBillingGroup(billGrpId, custBillGrpNo, billType, billAddrFull, custBillRem, custBillAddId) {
        $('#hiddenBillGrpId').removeClass("readonly").val(billGrpId);
        $('#billGrp').removeClass("readonly").val(custBillGrpNo);
        $('#billType').removeClass("readonly").val(billType);
        $('#billAddr').removeClass("readonly").val(billAddrFull);
        $('#billRem').removeClass("readonly").val(custBillRem);

        fn_loadMailAddr(custBillAddId);
    }

    function fn_loadBankAccountPop(bankAccId) {
        fn_clearRentPaySetDD();
        fn_loadBankAccount(bankAccId);

        $('#sctDirectDebit').removeClass("blind");

        if(!FormUtil.IsValidBankAccount($('#hiddenRentPayBankAccID').val(), $('#rentPayBankAccNo').val())) {
            fn_clearRentPaySetDD();
            $('#sctDirectDebit').removeClass("blind");
            Common.alert('<spring:message code="sal.alert.title.invalidBankAcc" />' + DEFAULT_DELIMITER + '<spring:message code="sal.alert.msg.invalidAccForAutoDebit" />');
        }
    }

    function fn_loadBankAccount(bankAccId) {
        Common.ajax("GET", "/sales/order/selectCustomerBankDetailView.do", {getparam : bankAccId}, function(rsltInfo) {

            if(rsltInfo != null) {
                $("#hiddenRentPayBankAccID").val(rsltInfo.custAccId);
                $("#rentPayBankAccNo").val(rsltInfo.custAccNo);
                $("#rentPayBankAccNoEncrypt").val(rsltInfo.custEncryptAccNo);
                $("#rentPayBankAccType").val(rsltInfo.codeName);
                $("#accName").val(rsltInfo.custAccOwner);
                $("#accBranch").val(rsltInfo.custAccBankBrnch);
                $("#accBank").val(rsltInfo.bankCode + ' - ' + rsltInfo.bankName);
                $("#hiddenAccBankId").val(rsltInfo.custAccBankId);
                $("#ddcChl").val(rsltInfo.ddtChnl);
            }
        });
    }

    function fn_loadCreditCard(crcId, custOriCrcNo, custCrcNo, custCrcType, custCrcName, custCrcExpr, custCRCBank, custCrcBankId, crcCardType) {
        $('#hiddenRentPayCRCId').val(crcId);
        $('#rentPayCRCNo').val(custOriCrcNo);
        $('#hiddenRentPayEncryptCRCNoId').val(custCrcNo);
        $('#rentPayCRCType').val(custCrcType);
        $('#rentPayCRCName').val(custCrcName);
        $('#rentPayCRCExpiry').val(custCrcExpr);
        $('#rentPayCRCBank').val(custCRCBank);
        $('#hiddenRentPayCRCBankId').val(custCrcBankId);
        $('#rentPayCRCCardType').val(crcCardType);
    }

    function fn_loadCreditCard2(custCrcId) {
        Common.ajax("GET", "/sales/order/selectCustomerCreditCardDetailView.do", {getparam : custCrcId}, function(rsltInfo) {
            if(rsltInfo != null) {
                $("#hiddenRentPayCRCId").val(rsltInfo.custCrcId);
                $("#rentPayCRCNo").val(rsltInfo.decryptCRCNoShow);
                $("#hiddenRentPayEncryptCRCNoId").val(rsltInfo.custCrcNo);
                $("#rentPayCRCType").val(rsltInfo.code);
                $("#rentPayCRCName").val(rsltInfo.custCrcOwner);
                $("#rentPayCRCExpiry").val(rsltInfo.custCrcExpr);
                $("#rentPayCRCBank").val(rsltInfo.bankCode + ' - ' + rsltInfo.bankId);
                $("#hiddenRentPayCRCBankId").val(rsltInfo.custCrcBankId);
                $("#rentPayCRCCardType").val(rsltInfo.codeName);
            }
        });
    }

    function fn_loadOrderSalesman(memId, memCode) {
        fn_clearOrderSalesman();

        var custId = $("#custId").val();

        if(LoginRoleID != "105" && LoginRoleID != "97")//Modified by Keyi bypass HOR & Supervisor Key In restriction
        {

		        Common.ajax("GET", "/sales/order/checkRC.do", {memId : memId, memCode : memCode, custId : custId}, function(memRc) {
		            console.log("checkRc");
		            if(memRc != null) {
		                if(memRc.rookie == 1) {
		                    if(memRc.opCnt == 0 && memRc.rcPrct <= 50) {
		                        // Not own purchase and SHI below 50
		                        fn_clearOrderSalesman();
		                        Common.alert(memRc.name + " (" + memRc.memCode + ") is not allowed to key in due to RC below 50%.");
		                        return false;
		                    } else if(memRc.opCnt > 0) {
		                         // Own Purchase
		                         /* if(memRc.flg6Month == 0) {
		                             Common.alert(memRc.name + " (" + memRc.memCode + ") is not allowed for own purchase due member join less than 6 months.");
		                             return false;
		                         } */

		                         if(memRc.rcPrct <= 55) {
		                             Common.alert(memRc.name + " (" + memRc.memCode + ") is not allowed for own purchase key in due to RC below 55%.");
		                             return false;
		                         }
		                    }
		                } else {
		                    Common.alert(memRc.name + " (" + memRc.memCode + ") is still a rookie, no key in is allowed.");
		                    return false;
		                }
		            }
		     });
        }

            Common.ajax("GET", "/sales/order/selectMemberByMemberIDCode.do", {memId : memId, memCode : memCode, stus : 1, salesMen : 1}, function(memInfo) {

                if(memInfo == null) {
                    Common.alert('<spring:message code="sal.alert.msg.memNotFoundInput" arguments="'+memCode+'"/>');
                    Common.alert('<spring:message code="sal.alert.msg.memNotFoundInput" arguments="'+memCode+'"/>');

                } else {
                    $('#hiddenSalesmanId').val(memInfo.memId);
                    $('#salesmanCd').val(memInfo.memCode);
                    $('#salesmanType').val(memInfo.codeName);
                    $('#salesmanTypeId').val(memInfo.memType);
                    $('#salesmanNm').val(memInfo.name);
                    $('#salesmanNric').val(memInfo.nric);
                    $('#departCd').val(memInfo.deptCode);
                    $('#departMemId').val(memInfo.lvl3UpId);
                    $('#grpCd').val(memInfo.grpCode);
                    $('#grpMemId').val(memInfo.lvl2UpId);
                    $('#orgCd').val(memInfo.orgCode);
                    $('#orgMemId').val(memInfo.lvl1UpId);

                    $('#salesmanCd').removeClass("readonly");
                    $('#departCd').removeClass("readonly");
                    $('#grpCd').removeClass("readonly");
                    $('#orgCd').removeClass("readonly");

                    checkSalesPerson($('#salesmanCd').val(),$('#txtOldOrderID').val(),$('#relatedNo').val());
                }
            });

    }

    function fn_loadTrialNo(trialNo) {
        $('#trialNo').val('');
        $('#trialId').val('');

        if(FormUtil.isNotEmpty(trialNo)) {
            Common.ajax("GET", "/sales/order/selectTrialNo.do", {salesOrdNo : trialNo}, function(trialInfo) {
                if(trialInfo != null) {
                    $("#trialId").val(trialInfo.salesOrdId);
                    $("#trialNo").val(trialInfo.salesOrdNo);
                }
            });
        }
    }

    function fn_loadPromotionPrice(promoId, stkId, srvPacId, tagNum) {
        Common.ajax("GET", "/sales/order/selectProductPromotionPriceByPromoStockID.do", {promoId : promoId, stkId : stkId, srvPacId : srvPacId}, function(promoPriceInfo) {

            if(promoPriceInfo != null) {
                $("#ordPrice"+tagNum).val(promoPriceInfo.orderPricePromo);
                $("#ordPv"+tagNum).val(promoPriceInfo.orderPVPromo);
                $("#ordPvGST"+tagNum).val(promoPriceInfo.orderPVPromoGST);
                $("#ordRentalFees"+tagNum).val(promoPriceInfo.orderRentalFeesPromo);

                $("#promoDiscPeriodTp"+tagNum).val(promoPriceInfo.promoDiscPeriodTp);
                $("#promoDiscPeriod"+tagNum).val(promoPriceInfo.promoDiscPeriod);

                // 합계
                totSumPrice();
            }
        });
    }

    //LoadProductPromotion
    function fn_loadProductPromotion(appTypeVal, stkId, empChk, custTypeVal, exTrade, tagNum) {
        $('#ordPromo'+tagNum).removeAttr("disabled");

        //Voucher Management
        if(tagNum == '1'){ //Voucher Check only applies for Main Product Promotion
            if(appTypeVal !=66){
                doGetComboData('/sales/order/selectPromotionByAppTypeStock2.do', {appTypeId:appTypeVal,stkId:stkId, empChk:empChk, promoCustType:custTypeVal, exTrade:exTrade, srvPacId:$('#srvPacId').val(), voucherPromotion: voucherAppliedStatus,custStatus: $('#hiddenCustStatusId').val()}, '', 'ordPromo'+tagNum, 'S', 'voucherPromotionCheck'); //Common Code
            } else {
                doGetComboData('/sales/order/selectPromotionByAppTypeStock.do', {appTypeId:appTypeVal,stkId:stkId, empChk:empChk, promoCustType:custTypeVal, exTrade:exTrade, srvPacId:$('#srvPacId').val(), voucherPromotion: voucherAppliedStatus,custStatus: $('#hiddenCustStatusId').val()}, '', 'ordPromo'+tagNum, 'S', 'voucherPromotionCheck'); //Common Code
            }
        }
        else{
        	if(appTypeVal !=66){
                doGetComboData('/sales/order/selectPromotionByAppTypeStock2.do', {appTypeId:appTypeVal,stkId:stkId, empChk:empChk, promoCustType:custTypeVal, exTrade:exTrade, srvPacId:$('#srvPacId').val(), voucherPromotion: voucherAppliedStatus,custStatus: $('#hiddenCustStatusId').val()}, '', 'ordPromo'+tagNum, 'S', ''); //Common Code
            } else {
                doGetComboData('/sales/order/selectPromotionByAppTypeStock.do', {appTypeId:appTypeVal,stkId:stkId, empChk:empChk, promoCustType:custTypeVal, exTrade:exTrade, srvPacId:$('#srvPacId').val(), voucherPromotion: voucherAppliedStatus,custStatus: $('#hiddenCustStatusId').val()}, '', 'ordPromo'+tagNum, 'S', ''); //Common Code
            }
        }
    }

    //LoadProductPromotion - copy(chage)
    function fn_loadProductPromotion_chg(appTypeVal, stkId, empChk, custTypeVal, exTrade, promoVal, tagNum) {
        $('#ordPromo'+tagNum).removeAttr("disabled");
        //Voucher Management
        if(appTypeVal !=66){
            doGetComboData('/sales/order/selectPromotionByAppTypeStock2.do', {appTypeId:appTypeVal,stkId:stkId, empChk:empChk, promoCustType:custTypeVal, exTrade:exTrade, srvPacId:$('#srvPacId').val(), voucherPromotion: voucherAppliedStatus,custStatus: $('#hiddenCustStatusId').val()}, promoVal, 'ordPromo'+tagNum, 'S', 'fn_promoChg'+tagNum); //Common Code
        } else {
            doGetComboData('/sales/order/selectPromotionByAppTypeStock.do', {appTypeId:appTypeVal,stkId:stkId, empChk:empChk, promoCustType:custTypeVal, exTrade:exTrade, srvPacId:$('#srvPacId').val(), voucherPromotion: voucherAppliedStatus,custStatus: $('#hiddenCustStatusId').val()}, promoVal, 'ordPromo'+tagNum, 'S', 'fn_promoChg'+tagNum); //Common Code
        }
    }

    /* function fn_loadProductPromotion2(appTypeVal, stkId, empChk, custTypeVal, exTrade, tagNum) {
        $('#ordPromo'+tagNum).removeAttr("disabled");

        doGetComboData('/homecare/sales/order/selectPromotionByFrame.do', {appTypeId:appTypeVal,stkId:stkId, empChk:empChk, promoCustType:custTypeVal, exTrade:exTrade, srvPacId:$('#srvPacId').val()}, '', 'ordPromo'+tagNum, 'S', ''); //Common Code
    } */

    //LoadProductPrice
    function fn_loadProductPrice(appTypeVal, stkId, srvPacId, tagNum) {
        var appTypeId = 0;

        appTypeId = appTypeVal=='68' ? '67' : appTypeVal;

        $("#searchAppTypeId").val(appTypeId);
        $("#searchStkId").val(stkId);
        $("#searchSrvPacId").val(srvPacId);

        Common.ajax("GET", "/sales/order/selectStockPriceJsonInfo.do", {appTypeId : appTypeId, stkId : stkId, srvPacId : srvPacId}, function(stkPriceInfo) {
            if(stkPriceInfo != null) {
                var pvVal = stkPriceInfo.orderPV;
                var pvValGst = Math.floor(pvVal*(1/1.06))

                $("#ordPrice"+tagNum).val(stkPriceInfo.orderPrice);
                $("#ordPv"+tagNum).val(pvVal);
                $("#ordPvGST"+tagNum).val(pvValGst);
                $("#ordRentalFees"+tagNum).val(stkPriceInfo.orderRentalFees);
                $("#ordPriceId"+tagNum).val(stkPriceInfo.priceId);

                $("#orgOrdPrice"+tagNum).val(stkPriceInfo.orderPrice);
                $("#orgOrdPv"+tagNum).val(stkPriceInfo.orderPV);
                $("#orgOrdRentalFees"+tagNum).val(stkPriceInfo.orderRentalFees);
                $("#orgOrdPriceId"+tagNum).val(stkPriceInfo.priceId);

                $("#promoDiscPeriodTp"+tagNum).val('');
                $("#promoDiscPeriod"+tagNum).val('');
                // 합계
                totSumPrice();
            }
        });
    }

    // 합계
    function totSumPrice() {
    	// 합계
        var totOrdPrice = js.String.naNcheck($("#ordPrice1").val()) + js.String.naNcheck($("#ordPrice2").val());
        var totOrgOrdRentalFees = js.String.naNcheck($("#orgOrdRentalFees1").val()) + js.String.naNcheck($("#orgOrdRentalFees2").val());
        var totOrdRentalFees = js.String.naNcheck($("#ordRentalFees1").val()) + js.String.naNcheck($("#ordRentalFees2").val());
        var totOrdPv = js.String.naNcheck($("#ordPv1").val()) + js.String.naNcheck($("#ordPv2").val());

        $("#totOrdPrice").val(totOrdPrice.toFixed(2));
        $("#totOrgOrdRentalFees").val(totOrgOrdRentalFees.toFixed(2));
        $("#totOrdRentalFees").val(totOrdRentalFees.toFixed(2));
        $("#totOrdPv").val(totOrdPv.toFixed(2));
    }

    //tabNm : PAY_CHA, BIL_DTL, REL_CER
    //opt   : SHOW, HIDE
    function fn_tabOnOffSet(tabNm, opt) {
        switch(tabNm) {
            case 'PAY_CHA' :
                if(opt == 'SHOW') {
                    if($('#tabPC').hasClass("blind")) $('#tabPC').removeClass("blind");
                    if($('#atcPC').hasClass("blind")) $('#atcPC').removeClass("blind");
                } else if(opt == 'HIDE') {
                    if(!$('#tabPC').hasClass("blind")) $('#tabPC').addClass("blind");
                    if(!$('#atcPC').hasClass("blind")) $('#atcPC').addClass("blind");
                }
                break;
            case 'BIL_DTL' :
                if(opt == 'SHOW') {
                    if($('#tabBD').hasClass("blind")) $('#tabBD').removeClass("blind");
                    if($('#atcBD').hasClass("blind")) $('#atcBD').removeClass("blind");
                } else if(opt == 'HIDE') {
                    if(!$('#tabBD').hasClass("blind")) $('#tabBD').addClass("blind");
                    if(!$('#atcBD').hasClass("blind")) $('#atcBD').addClass("blind");
                }
                break;
            case 'REL_CER' :
                if(opt == 'SHOW') {
                    if($('#tabRC').hasClass("blind")) $('#tabRC').removeClass("blind");
                    if($('#atcRC').hasClass("blind")) $('#atcRC').removeClass("blind");
                } else if(opt == 'HIDE') {
                    if(!$('#tabRC').hasClass("blind")) $('#tabRC').addClass("blind");
                    if(!$('#atcRC').hasClass("blind")) $('#atcRC').addClass("blind");
                    $('#fileUploadForm').clearForm();
                }
                break;
            default :
                break;
        }
    }

    //ClearControl_Customer(Customer)
    function fn_clearCustomer() {
        $('#custForm').clearForm();
    }

    //ClearControl_MailAddress(Billing Detail -> Billing Address)
    function fn_clearMailAddress() {
        $('#liBillNewAddr').addClass("blind");
        $('#liBillSelAddr').addClass("blind");

        $('#billAddrForm').clearForm();
    }

    //ClearControl_ContactPerson(Billing Detail -> Billing Address)
    function fn_clearContactPerson() {
        $('#liMstCntcNewAddr').addClass("blind");
        $('#liMstCntcSelAddr').addClass("blind");
        $('#liMstCntcNewAddr2').addClass("blind");
        $('#liMstCntcSelAddr2').addClass("blind");

        $('#ownerPurchsForm').clearForm();
        $('#addSvcCntcForm').clearForm();
    }

    function fn_clearSales() {
        $('#installDur').val('');
        $('#ordProduct1').val('');
        $('#ordPromo').val('');
        $('#relatedNo').val('');
        $('#trialNoChk').prop("checked", false);
        $('#trialNo').val('');
        $('#ordPrice').val('');
        $('#ordPriceId').val('');
        $('#ordPv').val('');
        $('#ordRentalFees').val('');
        $('#orgOrdRentalFees').val('');
        $('#btnMatRltdNo').addClass('blind');
        $('#srvPacId').val('')
    }

    //ClearControl_RentPaySet_ThirdParty
    function fn_clearRentPayMode() {
        $('#rentPayModeForm').clearForm();
    }

    //ClearControl_RentPaySet_ThirdParty
    function fn_clearRentPay3thParty() {
        $('#thrdPartyForm').clearForm();
    }

    //ClearControl_RentPaySet_DD
    function fn_clearRentPaySetDD() {
        $('#sctDirectDebit').addClass("blind");
        $('#ddForm').clearForm();
    }

    //ClearControl_RentPaySet_CRC
    function fn_clearRentPaySetCRC() {
        $('#sctCrCard').addClass("blind");
        $('#crcForm').clearForm();
    }

    //ClearControl_BillGroup
    function fn_clearBillGroup() {

        $('#sctBillMthd').addClass("blind");
        $('#sctBillAddr').addClass("blind");
        $('#sctBillPrefer').addClass("blind");
        $('#sctBillSel').addClass("blind");

        $('#grpOpt1').removeAttr("checked");
        $('#grpOpt2').removeAttr("checked");

        $('#billMthdForm').clearForm();
//      $('#billAddrForm').clearForm();
        $('#billPreferForm').clearForm();
        $('#billSelForm').clearForm();
        $('#billRem').clearForm();
    }

    //ClearControl_Installation_Address
    function fn_clearInstallAddr() {
        $('#liInstNewAddr').addClass("blind");
        $('#liInstSelAddr').addClass("blind");

        $('#instAddrForm').clearForm();
    }

    //ClearControl_Installation_ContactPerson
    function fn_clearCntcPerson() {
        $('#liInstNewAddr2').addClass("blind");
        $('#liInstSelAddr2').addClass("blind");

        $('#instCntcForm').clearForm();
    }

    //ClearControl_Installation_ContactPerson
    function fn_clearSearchForm() {
        $('#searchForm').clearForm();
    }

    function chgTab(tabNm) {
        console.log('tabNm:'+tabNm);

        switch(tabNm) {
            case 'doc' :
                AUIGrid.resize(docGridID, 980, 380);
//              AUIGrid.resize(docGridID);
                if(docDefaultChk == false) fn_checkDocList(true);
                break;
            default :
                break;
        }
        /*
        if(tabNm != 'ins') {
            if(!$('#pBtnCal').hasClass("blind")) {
                //$('#aTabIN').click();
                Common.alert('<b>Please press the Calculation button</b>', fn_goInstallTab);
                instreturn false;
            }
        }
        */
    }

    function fn_goInstallTab() {
        $('#aTabIN').click();
    }

    function fn_getDocChkCount() {
        var chkCnt = 0, arrGridData = AUIGrid.getGridData(docGridID);

        for(var i = 0; i < AUIGrid.getRowCount(docGridID) ; i++) {
            var isChk = AUIGrid.getCellValue(docGridID, i, "chkfield");
            if(isChk == 1) chkCnt++;
        }

        return chkCnt;
    }

    function fn_setOptGrpClass() {
        $("optgroup").attr("class" , "optgroup_text")
    }

    function fn_setDefaultSrvPacId() {
        if($('#srvPacId option').size() >= 2) {
            $('#srvPacId option:eq(1)').attr('selected', 'selected');

            //$('#srvPacId').chang();
            // product comboBox 생성
            fn_setProductCombo();
        }
    }

    // product comboBox 생성
    function fn_setProductCombo(){
    	 var stkType = $("#appType").val() == '66' ? '1' : '2';
    	 const postcode = $("#instPostCode").val()
    	 //productType is use for indicating if is MAIN unit or AUX unit, 1-(MAIN),2-(AUX) as per _tagNum
         // StkCategoryID - Mattress(5706)
         doGetComboAndGroup2('/homecare/sales/order/selectHcProductCodeList.do', {stkType:stkType, srvPacId:$('#srvPacId').val(), postcode:postcode, productType: '1'}, '', 'ordProduct1', 'S', 'fn_setOptGrpClass');//product 생성
         // StkCategoryID - Frame(5707)
         doGetComboAndGroup2('/homecare/sales/order/selectHcProductCodeList.do', {stkType:stkType, srvPacId:$('#srvPacId').val(), postcode:postcode, productType: '2'}, '', 'ordProduct2', 'S', 'fn_setOptGrpClass');//product 생성
    }

    function fn_checkEkeyinSof(sofNo) {

        if(sofNo != null){
            Common.ajax("GET", "/sales/order/selectEKeyinSofCheck.do", {sofNo : sofNo}, function(result) {
                if(result != null){
                    Common.alert("<spring:message code='sal.alert.msg.sofUsed' arguments = '" + result.postingBrnch + " ; " + result.ekeyInStus + ";" + result.ordStus +"' htmlEscape='false' argumentSeparator=';' />");
                }
            });
       }
    }

    function fn_clearAddCpnt() {
		$('#trCpntId1').css("visibility","collapse");
	    $('#compType1 option').remove();
	    $('#trCpntId2').css("visibility","collapse");
	    $('#compType2 option').remove();
	}

	function fn_loadProductComponent(appTyp, stkId, tagNum) {
	   $('#compType'+tagNum+' option').remove();
	   $('#compType'+tagNum).removeClass("blind");
	   $('#compType'+tagNum).removeClass("disabled");

	   doGetComboData('/sales/order/selectProductComponent.do', { appTyp:appTyp, stkId:stkId }, '', 'compType'+tagNum, 'S', '');
	}

	function fn_check(a, tagNum) {
	    if ($('#compType'+tagNum+' option').length <= 0) {
	        if (a == 3) {
	            return;
	        } else {
	            setTimeout(function() { fn_check( parseInt(a) + 1, tagNum) }, 500);
	        }
	    } else if ($('#compType'+tagNum+' option').length <= 1) {
	        $('#trCpntId'+tagNum).css("visibility","collapse");
	        $('#compType'+tagNum+' option').remove();
	        $('#compType'+tagNum).addClass("blind");
	        $('#compType'+tagNum).prop("disabled", true);

	    } else if ($('#compType'+tagNum+' option').length > 1) {
	        $('#trCpntId'+tagNum).css("visibility","visible");
	        $('#compType'+tagNum).remove("blind");
	        $('#compType'+tagNum).removeAttr("disabled");

	        var key = 0;

	        Common.ajax("GET", "/sales/order/selectProductComponentDefaultKey.do", {stkId : $("#ordProduct"+tagNum).val()}, function(defaultKey) {
		        if(defaultKey != null) {
		            key = defaultKey.code;
		            $('#compType'+tagNum).val(key).change();
		            fn_reloadPromo(tagNum);
		        }
	        });
	    }
	}

  function fn_reloadPromo(tagNum) {
    $('#ordPromo'+tagNum+' option').remove();
    $('#ordPromo'+tagNum).removeClass("blind");
    $('#ordPromo'+tagNum).removeClass("disabled");

    var appTyp = $("#appType").val();
    var stkId = $("#ordProduct"+tagNum).val();
    var cpntId = $("#compType"+tagNum).val();
    var empInd = $("#empChk").val();
    var exTrade = $("#exTrade").val();

    doGetComboData('/sales/order/selectPromoBsdCpnt.do', { appTyp:appTyp, stkId:stkId, cpntId:cpntId, empInd:empInd, exTrade:exTrade }, '', 'ordPromo'+tagNum, 'S', '');
  }

  function checkIfIsAcInstallationProductCategoryCode(stockIdVal){
	  	Common.ajaxSync("GET", "/homecare/checkIfIsAcInstallationProductCategoryCode.do", {stkId: stockIdVal}, function(result) {

	        if(result != null)
	        {
	        	var custAddId = $('#hiddenCustAddId').val();
	    		fn_clearInstallAddr();
	            $('#liInstNewAddr').removeClass("blind");
	            $('#liInstSelAddr').removeClass("blind");
	        	if(result.data == 1){
	        		//change installation branch to AC //load AC combobox
	                fn_loadInstallAddrForDiffBranch(custAddId,'N','Y');
	        	}
	        	else{
	        		//change installation branch to HDC //load hdc combobox
					fn_loadInstallAddrForDiffBranch(custAddId,'Y');
	        	}
	        }
	    },  function(jqXHR, textStatus, errorThrown) {
	        alert("Fail to check Air Conditioner. Please contact IT");
	  });
  }

  function fn_setBindComboOrd(ordNo, ordId) {
	    $('#cboOrdNoTag').val(ordNo);
	    $('#hiddenCboOrdNoTag').val(ordId);
  }

  function displayVoucherSection(){
	  if(convToOrdYn == "Y"){
		  voucherAppliedDisplay();
	  }

	  if($('#voucherType option:selected').val() != null && $('#voucherType option:selected').val() != "" && $('#voucherType option:selected').val() != "0")
	  {
		  $('.voucherSection').show();
	  }
	  else{
		  $('.voucherSection').hide();
			clearVoucherData();
	  }
  }

  function applyVoucher() {
	  var voucherCode = $('#voucherCode').val();
	  var voucherEmail = $('#voucherEmail').val();
	  var voucherType = $('#voucherType option:selected').val();

	  if(voucherCode.length == 0 || voucherEmail.length ==0){
		clearVoucherData();
		  Common.alert('Both voucher code and voucher email must be key in');
		  return;
	  }
	  Common.ajax("GET", "/misc/voucher/voucherVerification.do", {platform: voucherType, voucherCode: voucherCode, custEmail: voucherEmail}, function(result) {
	        if(result.code == "00") {
	        	voucherAppliedStatus = 1;
	        	$('#voucherMsg').text('Voucher Applied for ' + voucherCode);
		      	voucherAppliedCode = voucherCode;
		      	voucherAppliedEmail = voucherEmail;
	        	$('#voucherMsg').show();

	        	Common.ajax("GET", "/misc/voucher/getVoucherUsagePromotionId.do", {voucherCode: voucherCode, custEmail: voucherEmail}, function(result) {
	        		if(result.length > 0){
	        			voucherPromotionId = result;
	        			//voucherPromotionCheck();

	                    var appTypeIdx = $("#appType option:selected").index();
	                    var appTypeVal = $("#appType").val();
	                    var custTypeVal = $("#typeId").val();
	                    var stkIdx         = $("#ordProduct1 option:selected").index();
	                    var stkIdVal      = $("#ordProduct1").val();
	                    var empChk     = $("#empChk").val();
	                    var exTrade      = $("#exTrade").val();
	                    var srvPacId      = appTypeVal == '66' ? $('#srvPacId').val() ||  '${orderInfo.basicInfo.srvPacId}'  : 0;

	                    if(stkIdx > 0) {
		                	fn_loadProductPromotion(appTypeVal, stkIdVal, empChk, custTypeVal, exTrade, "1");
	                    }
	        		}
	        		else{
	        			//reset everything
	    				clearVoucherData();
	        			Common.alert("No Promotion is being entitled for this voucher code");
	        			return;
	        		}
	        	});
	        }
	        else{
				clearVoucherData();
	        	Common.alert(result.message);
	        	return;
	        }
	  });
  }

  //Voucher Promotion Check only for Main Product
  function voucherPromotionCheck(){
	 if(voucherAppliedStatus == 1){
		var orderPromoId = [];
		var orderPromoIdToRemove = [];
		$("#ordPromo1 option").each(function()
		{
			  orderPromoId.push($(this).val());
	    });
		orderPromoIdToRemove = orderPromoId.filter(function(obj) {
		    return !voucherPromotionId.some(function(obj2) {
			        return obj == obj2;
		    });
		});

		if(orderPromoIdToRemove.length > 0){
		   	$('#ordPromo1').val('');
			for(var i = 0; i < orderPromoIdToRemove.length; i++){
				if(orderPromoIdToRemove[i] == ""){
				}
				else{
					$("#ordPromo1 option[value='" + orderPromoIdToRemove[i] +"']").remove();
				}
			}
		}
	}
  }

  function clearVoucherData(){
	  	$('#voucherCode').val('');
    	$('#voucherEmail').val('');
  		$('#voucherMsg').hide();
  		$('#voucherMsg').text('');
  	  	voucherAppliedStatus = 0;
    	voucherAppliedCode = "";
    	voucherAppliedEmail = "";
        voucherPromotionId =[];

        $('#ordProduct1').val('');
     	$('#ordPromo1').val('');
     	$('#ordPromo1 option').remove();
  }

  function fn_checkPreOrderSalesPerson(memId,memCode) {
  	Common.ajax("GET", "/homecare/sales/order/checkPreBookSalesPerson.do", {memId : memId, memCode : memCode}, function(memInfo) {
  		if(memInfo == null) {
              Common.alert('<b>Your input member code : '+ memCode +' is not allowed for extrade pre-order.</b>');
              fn_clearOrderSalesman();
          }
  	});
  }

  function fn_checkPreOrderConfigurationPerson(memId,memCode,salesOrdId,salesOrdNo) {
  	Common.ajax("GET", "/homecare/sales/order/hcCheckPreBookConfigurationPerson.do", {memId : memId, memCode : memCode, salesOrdId : salesOrdId , salesOrdNo : salesOrdNo}, function(memInfo) {
  		if(memInfo == null) {
              Common.alert('<b>Your input member code : '+ memCode +' is not allowed for extrade pre-order.</b>');
              fn_clearOrderSalesman();
          }
  	});
  }

  function checkSalesPerson(memCode,salesOrdId,salesOrdNo){
	  if(memCode == "100116" || memCode == "100224" || memCode == "ASPLKW"){
          return;
      }else{
        if($('#exTrade').val() == '1') {
        	fn_checkPreOrderSalesPerson(0,memCode);
        }
//         	 if($('#exTrade').val() == '1' && $("#typeId").val() == '964' && $('#relatedNo').val() == '' && $('#hiddenMonthExpired').val() != '1') {
//               	 fn_checkPreOrderSalesPerson(0,memCode);
//             }else if ($('#exTrade').val() == '1' && $("#typeId").val() == '964' && $('#relatedNo').val() != '' && $('#hiddenMonthExpired').val() != '1'){
//              	 fn_checkPreOrderSalesPerson(0,memCode);
//             }else if($('#exTrade').val() == '1' && $("#typeId").val() == '964' && $('#relatedNo').val() != '' && $('#hiddenMonthExpired').val() == '1'){
//               	 fn_checkPreOrderConfigurationPerson(0,memCode,salesOrdId,salesOrdNo);
//             }else{
//         		//do nothing
//             }
      }
  }

  function fn_checkPromotionExtradeAvail(){
	  var appTypeId = $('#appType option:selected').val();
      var oldOrderNo = $('#relatedNo').val();
      var promoId = $('#ordPromo1 option:selected').val();
      var extradeId = $('#exTrade option:selected').val();
	  console.log("OLDORDERNO"+oldOrderNo);
	  console.log("PROMOID"+promoId);

	  if(FormUtil.isNotEmpty(promoId) && FormUtil.isNotEmpty(oldOrderNo)) {
		  Common.ajax("GET", "/sales/order/checkExtradeWithPromoOrder.do",
				  {appTypeId : appTypeId, oldOrderNo : oldOrderNo, promoId : promoId, extradeId : extradeId, isHomeCare: 'Y'}, function(result) {
		        if(result == null) {
		         	  $('#ordPromo1').val('');
		         	  $('#ordPromo2').val('');
		         	  $('#relatedNo').val('');
		         	  Common.alert("No extrade with promo order found");
		        }
		        else{
		        	if(result.code == "99"){
			         	  $('#ordPromo1').val('');
			         	  $('#ordPromo2').val('');
			         	  //$('#relatedNo').val('');
			         	  Common.alert(result.message);
		        	}
		        }
		  });
	  }
  }
</script>

<div id="popup_wrap" class="popup_wrap">
<!--div id="popup_wrap" class="popup_wrap pop_win"--><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.newOrder" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="btnOrdRegClose"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1 num4">
    <li id="tabCS"><a id="aTabCS" href="#" onClick="javascript:chgTab('cst');" class="on">Customer</a></li>
    <li id="tabMC"><a id="aTabMS" href="#" onClick="javascript:chgTab('cnt');">Master Contact</a></li>
    <li id="tabSO"><a id="aTabSO" href="#" onClick="javascript:chgTab('sal');">Sales Order</a></li>
    <li id="tabPC"><a id="aTabPC" href="#" onClick="javascript:chgTab('pay');">Payment Channel</a></li>
    <li id="tabBD"><a id="aTabBD" href="#" onClick="javascript:chgTab('bil');">Billing Detail</a></li>
    <li id="tabIN"><a id="aTabIN" href="#" onClick="javascript:chgTab('ins');">Installation</a></li>
    <li id="tabDC"><a id="aTabDC" href="#" onClick="javascript:chgTab('doc');">Documents</a></li>
    <li id="tabRC"><a id="aTabRC" href="#" onClick="javascript:chgTab('rlf');">Relief Certificate</a></li>
</ul>

<!--****************************************************************************
    Customer - Form ID(searchForm/custForm)
*****************************************************************************-->
<article class="tap_area"><!-- tap_area start -->
<section class="search_table"><!-- search_table start -->

<form id="searchForm" name="searchForm" action="#" method="post">
    <input id="searchCustId" name="custId" type="hidden"/>
    <input id="hiddenCustId" name="custId"   type="hidden"/>
    <input id="hiddenOldOrderId" name="hiddenOldOrderId" type="hidden"/>
    <input id="hiddenCopyQty" name="hiddenCopyQty" type="hidden"/>
    <input id="hiddenCustCrtDt" name="hiddenCustCrtDt"   type="hidden"/>
</form>
<form id="custForm" name="custForm" action="#" method="post">

<ul class="right_btns mb10">
    <li><p class="btn_grid"><a id="addCustBtn" href="#"><spring:message code="sal.btn.addNewCust" /></a></p></li>
</ul>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.customerId" /><span class="must">*</span></th>
    <td><input id="custId" name="custId" type="text" placeholder="Customer ID" class="" /><a class="search_btn" id="custBtn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
    <th scope="row"><spring:message code="sal.text.type" /></th>
    <td><input id="custTypeNm" name="custTypeNm" type="text" placeholder="Customer Type" class="w100p" readonly/>
        <input id="typeId" name="typeId" type="hidden"/>
        <input id="corpTypeId" name="corpTypeId" type="hidden"/>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.name" /></th>
    <td><input id="name" name="name" type="text" placeholder="Customer Name" class="w100p" readonly/></td>
    <th scope="row"><spring:message code="sal.text.nricCompanyNo" /></th>
    <td><input id="nric" name="nric" type="text" placeholder="NRIC/Company No" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.tin" /></th>
    <td><input id="tin" name=tin type="text" placeholder="TIN No" class="w100p" readonly/></td>
    <th scope="row"><spring:message code="sal.title.text.sstRegistrationNo" /></th>
    <td><input id="sstRegNo" name="sstRegNo" type="text" placeholder="SST Registration No" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.nationality" /></th>
    <td><input id="nationNm" name="nationNm" type="text" placeholder="Nationality" class="w100p" readonly/>
        <input id="nation" name="nation" type="hidden"/>
    </td>
    <th scope="row"><spring:message code="sal.text.race" /></th>
    <td><input id="race" name="race" type="text" placeholder="Race" class="w100p" readonly/>
        <input id="raceId" name="raceId" type="hidden"/>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.dob" /></th>
    <td><input id="dob" name="dob" type="text" placeholder="DOB" class="w100p" readonly/></td>
    <th scope="row"><spring:message code="sal.text.gender" /></th>
    <td><input id="gender" name="gender" type="text" placeholder="Gender" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.passportExpire" /></th>
    <td><input id="pasSportExpr" name="pasSportExpr" type="text" placeholder="Passport Expiry" class="w100p" readonly/></td>
    <th scope="row"><spring:message code="sal.text.visaExpire" /></th>
    <td><input id="visaExpr" name="visaExpr" type="text" placeholder="Visa Expiry" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.email" /></th>
    <td><input id="email" name="email" type="text" placeholder="Email Address" class="w100p" readonly/></td>
    <th scope="row"><spring:message code="sal.text.indutryCd" /></th>
    <td><input id="corpTypeNm" name="corpTypeNm" type="text" placeholder="Industry Code" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.employee" /><span class="must">*</span></th>
    <td colspan="3"><select id="empChk" name="empChk" class="w100p"></select></select></td>
</tr>
 <tr>
	<th scope="row">Receiving Marketing Message</th>
	<td colspan="3">
		<div style="display:inline-block;width:100%;">
			<div style="display:inline-block;">
			<input id="marketMessageYes" type="radio" value="1" name="marketingMessageSelection"/><label for="marketMessageYes">Yes</label>
			</div>
			<div style="display:inline-block;">
			<input  id="marketMessageNo" type="radio" value="0" name="marketingMessageSelection"/><label for="marketMessageNo">No</label>
			</div>
		</div>
	</td>
</tr>
<tr>
    <th scope="row">Customer Status</th>
    <td colspan="3"><input id="custStatus" name="custStatus" type="text" title="" placeholder="" class="w100p" readonly/></td>
</tr>
<input id="hiddenCustStatusId" name="hiddenCustStatusId" type="hidden" />
<tr>
    <th scope="row"><spring:message code="sal.text.remark" /></th>
    <td colspan="3"><textarea  id="custRem" name="custRem" cols="20" rows="5" placeholder="Remark" readonly></textarea></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue"><a id="saveBtn" name="ordSaveBtn" href="#"><spring:message code="sal.btn.ok" /></a></p></li>
</ul>

</form>
</section><!-- search_table end -->

</article><!-- tap_area end -->

<!--****************************************************************************
    Master Contract
*****************************************************************************-->

<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h3><spring:message code="sal.title.text.ownPurchCntc" /></h3>
</aside><!-- title_line end -->

<ul class="right_btns mb10">
    <li id="liMstCntcNewAddr" class="blind"><p class="btn_grid"><a id="mstCntcNewAddBtn" href="#"><spring:message code="sal.btn.addNewContact" /></a></p></li>
    <li id="liMstCntcSelAddr" class="blind"><p class="btn_grid"><a id="mstCntcSelAddBtn" href="#"><spring:message code="sal.btn.selNewContact" /></a></p></li>
</ul>

<!------------------------------------------------------------------------------
    Owner & Purchaser Contact - Form ID(ownerPurchsForm)
------------------------------------------------------------------------------->
<section class="search_table"><!-- search_table start -->

<form id="ownerPurchsForm" name="ownerPurchsForm" action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.initial" /></th>
    <td><input id="custInitial" name="custInitial" type="text" placeholder="" class="w100p" disabled/></td>
    <th scope="row"><spring:message code="sal.text.name" /></th>
    <td><input id="custCntcName" name="custCntcName" type="text" placeholder="" class="w100p" disabled/>
        <input id="hiddenCustCntcId" name="custCntcId" type="hidden" /></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.telMOne" /></th>
    <td><input id="custCntcTelM" name="custCntcTelM" type="text" placeholder="" class="w100p" disabled/></td>
    <th scope="row"><spring:message code="sal.title.text.telROne" /></th>
    <td><input id="custCntcTelR" name="custCntcTelR" type="text" placeholder="" class="w100p" disabled/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.telOOne" /></th>
    <td><input id="custCntcTelO" name="custCntcTelO" type="text" placeholder="" class="w100p" disabled/></td>
    <th scope="row"><spring:message code="sal.title.text.extNo" />(1)</th>
    <td><input id="custCntcExt" name="custCntcExt" type="text" placeholder="" class="w100p" disabled/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.telFOne" /></th>
    <td><input id="custCntcTelF" name="custCntcTelF" type="text" placeholder="" class="w100p" disabled/></td>
    <th scope="row"><spring:message code="sal.title.text.eamilOne" /></th>
    <td><input id="custCntcEmail" name="custCntcEmail" type="text" placeholder="" class="w100p" disabled/></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<!------------------------------------------------------------------------------
    Additional Service Contact - Form ID(addSvcCntcForm)
------------------------------------------------------------------------------->

<aside class="title_line"><!-- title_line start -->
<h3>Additional Service Contact</h3>
</aside><!-- title_line end -->

<ul class="right_btns mb10">
    <li id="liMstCntcNewAddr2" class="blind"><p class="btn_grid"><a id="mstCntcNewAddBtn2" href="#">Add New Contact</a></p></li>
    <li id="liMstCntcSelAddr2" class="blind"><p class="btn_grid"><a id="mstCntcSelAddBtn2" href="#">Select Another Contact</a></p></li>
</ul>

<section class="search_table"><!-- search_table start -->

<form id="addSvcCntcForm" name="custCntcForm" action="#" method="post">
    <input id="srvCntcId" name="srvCntcId" type="hidden"/>
    <input id="srvInitial" name="srvInitial" type="hidden"/>
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Name</th>
    <td colspan="3"><input id="srvCntcName" name="srvCntcName" type="text" placeholder="" class="w100p" disabled/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.telMTwo" /></th>
    <td><input id="srvCntcTelM" name="srvCntcTelM" type="text" placeholder="" class="w100p" disabled/></td>
    <th scope="row"><spring:message code="sal.title.text.telRTwo" /></th>
    <td><input id="srvCntcTelR" name="srvCntcTelR" type="text" placeholder="" class="w100p" disabled/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.telOTwo" /></th>
    <td><input id="srvCntcTelO" name="srvCntcTelO" type="text" placeholder="" class="w100p" disabled/></td>
    <th scope="row"><spring:message code="sal.title.text.extNo" />(2)</th>
    <td><input id="srvCntcExt" name="srvCntcExt" type="text" placeholder="" class="w100p" disabled/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.telFTwo" /></th>
    <td><input id="srvCntcTelF" name="srvCntcTelF" type="text" placeholder="" class="w100p" disabled/></td>
    <th scope="row"><spring:message code="sal.title.text.emailTwo" /></th>
    <td><input id="srvCntcEmail" name="srvCntcEmail" type="text" placeholder="" class="w100p" disabled/></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue"><a name="ordSaveBtn" href="#"><spring:message code="sal.btn.ok" /></a></p></li>
</ul>

</form>
</section><!-- search_table end -->

</article><!-- tap_area end -->

<!--****************************************************************************
    Sales Order - Tab3
*****************************************************************************-->
<article class="tap_area"><!-- tap_area start -->

<section class="search_table"><!-- search_table start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:170px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.appType" /><span class="must">*</span></th>
    <td>
	    <span style="width:48.5%;"><select id="appType" name="appType" class="w100p"></select></span>
	    <span style="width:48.45%;"><select id="srvPacId"  name="srvPacId" class="w100p"></select></span>
    </td>
    <th scope="row"><spring:message code="sal.text.exTradeRelatedNo" /></th>
    <td>
        <span style="width:43%;"><select id="exTrade" name="exTrade" class="w100p"></select></span>
        <span style="width:45%;"><input id="relatedNo" name="relatedNo" type="text" placeholder="Related Number" class="w100p readonly" readonly /></span>
        <a id="btnRltdNo" href="#" class="search_btn blind"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
        <a><input id="isReturnExtrade" name="isReturnExtrade" type="checkbox" disabled/> Return ex-trade product</a>
        <input id="hiddenMonthExpired" name="hiddenMonthExpired" type="hidden" />
        <input id="hiddenPreBook" name="hiddenPreBook" type="hidden" />
    </td>
</tr>
<tr>
    <th scope="row">Voucher Type<span class="must">*</span></th>
    <td colspan="3">
	    <p> <select id="voucherType" name="voucherType" onchange="displayVoucherSection()" class="w100p"></select></p>
        <p class="voucherSection"><input id="voucherCode" name="voucherCode" type="text" title="Voucher Code" placeholder="Voucher Code" class="w100p"/></p>
        <p class="voucherSection"><input id="voucherEmail" name="voucherEmail" type="text" title="Voucher Email" placeholder="Voucher Email" class="w100p"/></p>
        <p style="width: 70px;" class="voucherSection btn_grid"><a id="btnVoucherApply" href="#" onclick="javascript:applyVoucher()">Apply</a></p>
        <br/><p style="display:none; color:red;font-size:10px;float: right;" id="voucherMsg"></p>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.instDuration" /><span class="must">*</span></th>
    <td><input id="installDur" name="installDur" type="text" placeholder="Installment Duration (1-36 Months)" class="w100p readonly" readonly/></td>
    <th scope="row">Mattress Order<span class="must">*</span></th>
    <td>
        <span style="width:70%;">
            <input id="matRelatedNo" name="matRelatedNo" type="text" placeholder="Mattress Order Number" class="w100p readonly" readonly />
            <input id="matOrdId" name="matOrdId" type="text" hidden/>
            <input id="matBndlId" name="matBndlId" type="text" hidden/>
            <input id="matStkId" name="matStkId" type="text" hidden/>
        </span>
        <a id="btnMatRltdNo" href="#" class="search_btn blind"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.refNo" /><span class="must">*</span></th>
    <td><input id="refereNo" name="refereNo" type="text" placeholder="" class="w100p" onblur="javascript:fn_checkEkeyinSof(this.value);"/></td>
    <th scope="row"><spring:message code="sal.text.ordDate" /><span class="must">*</span></th>
    <td>${toDay}</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.poNo" /><span class="must">*</span></th>
    <td><input id="poNo" name="poNo" type="text" placeholder="" class="w100p" /></td>
    <th scope="row"><spring:message code="sal.text.salManCode" /><span class="must">*</span></th>
    <td>
        <input id="salesmanCd" name="salesmanCd" type="text" placeholder="" class="" />
        <input id="hiddenSalesmanId" name="salesmanId" type="hidden"  />
        <a id="memBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
    </td>
</tr>
<tr>
    <th scope="row"></th>
    <td></td>
    <th scope="row"><spring:message code="sal.title.text.salesmanType" /></th>
    <td><input id="salesmanType" name="salesmanType" type="text" placeholder="Salesman Type" class="w100p readonly" readonly/>
        <input id="hiddenSalesmanTypeId" name="salesmanTypeId" type="hidden" /></td>
</tr>
<tr>
    <td>
	        <h3>Main Product</h3>
    </td>
    <td></td>
    <th scope="row"><spring:message code="sal.text.salManName" /></th>
    <td><input id="salesmanNm" name="salesmanNm" type="text" placeholder="Salesman Name" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.product" /><span class="must">*</span></th>
    <td>
        <select id="ordProduct1" name="ordProduct1" class="w100p" disabled></select>
    </td>
    <th scope="row"><spring:message code="sal.title.text.salesmanNric" /></th>
    <td><input id="salesmanNric" name="salesmanNric" type="text" placeholder="Salesman NRIC" class="w100p readonly" readonly/></td>
</tr>
<tr id='trCpntId1' style='visibility:collapse'>
    <th scope="row"><spring:message code="sal.title.text.cpntId" /><span class="must">*</span></th>
    <td>
        <select id="compType1" name="compType1" class="w100p" onchange="fn_reloadPromo('1')"></select>
    </td>
    <th scope="row"></th>
    <td></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.promo" /><span class="must">*</span></th>
    <td>
	    <select id="ordPromo1"     name="ordPromo1"    data-ref='ordProduct1' class="w100p" disabled></select>
	    <input id="txtOldOrderID"  name="txtOldOrderID" data-ref='ordProduct1' type="hidden" />
	    <input id="txtBusType"  name="txtBusType" type="hidden" />
    </td>
    <th scope="row"><spring:message code="sal.text.departmentCode" /></th>
    <td>
        <input id="departCd"       name="departCd"       type="text" placeholder="Department Code" class="w100p readonly" readonly />
        <input id="departMemId" name="departMemId" type="hidden" />
    </td>
</tr>
<tr id='trCboOrdNoTag' style='visibility:collapse'>
    <th scope="row"><spring:message code="sal.title.text.cboBindOrdNo" /><span class="must">*</span></th>
    <td>
     <input id="cboOrdNoTag" name="cboOrdNoTag" type="text" title="" placeholder="" class="" disabled="disabled"/>
     <input id="hiddenCboOrdNoTag" name="hiddenCboOrdNoTag" type="hidden"  />
     <a id="OrdNoTagBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
    </td>
    <th scope="row"></th>
    <td></td>
</tr>
<tr>
    <!-- Display None(20200117 - KR-SH) -->
    <th scope="row" style="display: none;"><spring:message code="sal.title.text.priceRpfRm" /></th>
    <td style="display: none;">
        <input id="ordPrice1"       name="ordPrice1"      data-ref='ordProduct1' type="text" placeholder="Price/Rental Processing Fees (RPF)" class="w100p readonly" readonly />
        <input id="ordPriceId1"    name="ordPriceId1"    data-ref='ordProduct1' type="hidden" />
        <input id="orgOrdPrice1"  name="orgOrdPrice1" data-ref='ordProduct1' type="hidden" />
        <input id="orgOrdPv1"     name="orgOrdPv1"     data-ref='ordProduct1' type="hidden" />
    </td>
    <!-- Display None(20200117 - KR-SH) End -->
    <th scope="row"><spring:message code="sales.promo.discPeriod" />/<br><spring:message code="sal.title.text.finalRentalFees" /></th>
    <td>
        <span style="width:40%;"><select id="promoDiscPeriodTp1" name="promoDiscPeriodTp1" data-ref='ordProduct1' class="w100p" disabled></select></span>
        <span style="width:23%;"><input id="promoDiscPeriod1"     name="promoDiscPeriod1"     data-ref='ordProduct1' type="text" placeholder=""  class="w100p readonly" readonly/></span>
        <span style="width:32%;"><input id="ordRentalFees1"         name="ordRentalFees1"          data-ref='ordProduct1' type="text" placeholder=""  class="w100p readonly" readonly/></span>
    </td>
    <th scope="row"><spring:message code="sal.text.GroupCode" /></th>
    <td>
        <input id="grpCd"       name="grpCd"       type="text" placeholder="Group Code" class="w100p readonly" readonly />
        <input id="grpMemId" name="grpMemId" type="hidden" />
    </td>
</tr>
<tr>
    <!-- Display None(20200117 - KR-SH) -->
    <th scope="row" style="display: none;"><spring:message code="sal.title.text.nomalRentFeeRm" /></th>
    <td style="display: none;"><input id="orgOrdRentalFees1" name="orgOrdRentalFees1" data-ref='ordProduct1' type="text" placeholder="Rental Fees (Monthly)" class="w100p readonly" readonly /></td>
    <!-- Display None(20200117 - KR-SH) End -->
    <th scope="row"><spring:message code="sal.title.text.pv" /></th>
    <td>
        <input id="ordPv1"       name="ordPv1"      data-ref='ordProduct1' type="text" placeholder="Point Value (PV)" class="w100p readonly" readonly />
        <input id="ordPvGST1" name="ordPvGST1" data-ref='ordProduct1' type="hidden" />
    </td>
    <th scope="row"><spring:message code="sal.text.organizationCode" /></th>
    <td>
        <input id="orgCd" name="orgCd" type="text" placeholder="Organization Code" class="w100p readonly" readonly />
        <input id="orgMemId" name="orgMemId" type="hidden" />
    </td>
</tr>
<tr>
    <th scope="row"></th>
    <td></td>
    <th scope="row"><spring:message code="sal.text.trialNo" /></th>
    <td><label><input id="trialNoChk" name="trialNoChk" type="checkbox" disabled/><span></span></label>
        <input id="trialNo" name="trialNo" type="text" placeholder="Trial No" style="width:210px;" class="readonly" readonly />
        <input id="trialId" name="trialId" type="hidden" />
        <a id="trialNoBtn" name="trialNoBtn" href="#" class="search_btn blind"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
    </td>
</tr>
<tr>
    <td><h3>AUX Product (Frame/OutdoorUnit)</h3></td>
    <td></td>
    <td><h3>Total</h3></td>
    <td></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.product" /><span class="must">*</span></th>
    <td>
        <select id="ordProduct2" name="ordProduct2" class="w100p" disabled></select>
    </td>
    <th scope="row" style="font-weight: bold;"><spring:message code="sal.title.text.priceRpfRm" /></th>
    <td>
        <input id="totOrdPrice" name="totOrdPrice" style="width:100%!important; font-weight: bold;" type="text" placeholder="Price/Rental Processing Fees (RPF)" class="readonly" readonly />
    </td>
</tr>
<tr id='trCpntId2' style='visibility:collapse'>
    <th scope="row"><spring:message code="sal.title.text.cpntId" /><span class="must">*</span></th>
    <td>
     <select id="compType2" name="compType2" class="w100p" onchange="fn_reloadPromo('2')"></select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.promo" /><span class="must">*</span></th>
    <td>
    <select id="ordPromo2"     name="ordPromo2"       data-ref='ordProduct2' class="w100p" disabled></select>
<!--     <input id="txtOldOrderID2" name="txtOldOrderID2" data-ref='ordProduct2' type="hidden" /> -->
    </td>
    <th scope="row" style="font-weight: bold;"><spring:message code="sal.title.text.nomalRentFeeRm" /></th>
    <td><input id="totOrgOrdRentalFees" name="totOrgOrdRentalFees" type="text" placeholder="Rental Fees (Monthly)" style="width:100%!important; font-weight: bold;"  class="readonly" readonly /></td>
</tr>
<!-- Display None(20200117 - KR-SH) -->
<tr style="display: none;">
    <th scope="row"><spring:message code="sal.title.text.priceRpfRm" /></th>
    <td>
        <input id="ordPrice2"        name="ordPrice2"      data-ref='ordProduct2' type="text" placeholder="Price/Rental Processing Fees (RPF)" class="w100p readonly" readonly />
        <input id="ordPriceId2"     name="ordPriceId2"    data-ref='ordProduct2' type="hidden" />
        <input id="orgOrdPrice2"   name="orgOrdPrice2" data-ref='ordProduct2' type="hidden" />
        <input id="orgOrdPv2"      name="orgOrdPv2"     data-ref='ordProduct2' type="hidden" />
    </td>
</tr>
<tr style="display: none;">
    <th scope="row"><spring:message code="sal.title.text.nomalRentFeeRm" /></th>
    <td><input id="orgOrdRentalFees2" name="orgOrdRentalFees2" data-ref='ordProduct2' type="text" placeholder="Rental Fees (Monthly)" class="w100p readonly" readonly /></td>
</tr>
<!-- Display None(20200117 - KR-SH) - End -->
<tr>
    <th scope="row"><spring:message code="sales.promo.discPeriod" />/<br><spring:message code="sal.title.text.finalRentalFees" /></th>
    <td>
        <span style="width:40%;"><select id="promoDiscPeriodTp2" name="promoDiscPeriodTp2" data-ref='ordProduct2' class="w100p" disabled></select></span>
        <span style="width:23%;"><input id="promoDiscPeriod2"     name="promoDiscPeriod2"     data-ref='ordProduct2' type="text" placeholder=""  class="w100p readonly" readonly/></span>
        <span style="width:32%;"><input id="ordRentalFees2"         name="ordRentalFees2"          data-ref='ordProduct2' type="text" placeholder=""  class="w100p readonly" readonly/></span>
    </td>
    <th scope="row" style="font-weight: bold;"><spring:message code="sal.title.text.finalRentalFees" /></th>
    <td>
        <p><input id="totOrdRentalFees" name="totOrdRentalFees" type="text" placeholder="" style="width:100%!important; font-weight: bold;" class="readonly" readonly/></p>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.pv" /></th>
    <td>
        <input id="ordPv2"      name="ordPv2"       data-ref='ordProduct2' type="text" placeholder="Point Value (PV)" class="w100p readonly" readonly />
        <input id="ordPvGST2" name="ordPvGST2" data-ref='ordProduct2' type="hidden" />
    </td>
    <th scope="row" style="font-weight: bold;"><spring:message code="sal.title.text.pv" /></th>
    <td>
        <input id="totOrdPv" name="totOrdPv" type="text" placeholder="Point Value (PV)" style="width:100%!important; font-weight: bold;" class="readonly" readonly />
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.remark" /></th>
    <td colspan="3"><textarea  id="ordRem" name="ordRem" cols="20" rows="5" placeholder="Remark"></textarea></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.rentPay" /><span class="must">*</span></th>
    <td colspan="3"><span><spring:message code="sal.msg.6month" /></span>
        <input id="advPayYes" name="advPay" type="radio" value="1" disabled/><span>Yes</span>
        <input id="advPayNo" name="advPay" type="radio" value="0" disabled/><span>No</span></td>
</tr>
<!--  <tr>
    <th scope="row">SST Type<span class="must">*</span></th>
    <td><select id="corpCustType" name="corpCustType" class="w100p" disabled></select>
    <th scope="row">Agreement Type<span class="must">*</span></th>
    <td><select id="agreementType" name="agreementType" class="w100p" disabled></select>
</tr> -->
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue"><a name="ordSaveBtn" href="#"><spring:message code="sal.btn.ok" /></a></p></li>
</ul>

</section><!-- search_table end -->

</article><!-- tap_area end -->

<!--****************************************************************************
    Payment Channel - Form ID(payChnnlForm)
*****************************************************************************-->
<article id="atcPC" class="tap_area"><!-- tap_area start -->

<section class="search_table"><!-- search_table start -->

<table class="type1 mb1m"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.payByThirdParty" /></th>
    <td colspan="3">
    <label><input id="thrdParty" name="thrdParty" type="checkbox" value="1"/><span></span></label>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<section id="sctThrdParty" class="blind">

<aside class="title_line"><!-- title_line start -->
<h3><spring:message code="sal.title.thirdParty" /></h3>
</aside><!-- title_line end -->

<ul class="right_btns mb10">
    <li><p class="btn_grid"><a id="thrdPartyAddCustBtn" href="#"><spring:message code="sal.btn.addNewThirdParty" /></a></p></li>
</ul>

<!------------------------------------------------------------------------------
    Third Party - Form ID(thrdPartyForm)
------------------------------------------------------------------------------->
<form id="thrdPartyForm" name="thrdPartyForm" action="#" method="post">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:170px" />
    <col style="width:*" />
    <col style="width:190px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.customerId" /><span class="must">*</span></th>
    <td><input id="thrdPartyId" name="thrdPartyId" type="text" placeholder="Third Party ID" class="" />
        <a href="#" class="search_btn" id="thrdPartyBtn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
        <input id="hiddenThrdPartyId" name="hiddenThrdPartyId" type="hidden" placeholder="Third Party ID" class="" /></td>
    <th scope="row"><spring:message code="sal.text.type" /></th>
    <td><input id="thrdPartyType" name="thrdPartyType" type="text" placeholder="Costomer Type" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.name" /></th>
    <td><input id="thrdPartyName" name="thrdPartyName" type="text" placeholder="Customer Name" class="w100p readonly" readonly/></td>
    <th scope="row"><spring:message code="sal.text.nricCompanyNo" /></th>
    <td><input id="thrdPartyNric" name="thrdPartyNric" type="text" placeholder="NRIC/Company Number" class="w100p readonly" readonly/></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</section>

<!------------------------------------------------------------------------------
    Rental Paymode - Form ID(rentPayModeForm)
------------------------------------------------------------------------------->
<section id="sctRentPayMode">

<form id="rentPayModeForm" name="rentPayModeForm">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:170px" />
    <col style="width:*" />
    <col style="width:190px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.rentalPaymode" /><span class="must">*</span></th>
    <td>
    <select id="rentPayMode" name="rentPayMode" class="w100p"></select>
    </td>
    <th scope="row"><spring:message code="sal.text.nricPassbook" /></th>
    <td><input id="rentPayIC" name="rentPayIC" type="text" placeholder="NRIC appear on DD/Passbook" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->
</form>

</section>

<section id="sctCrCard" class="blind">

<aside class="title_line"><!-- title_line start -->
<h3><spring:message code="sal.title.text.crdCard" /></h3>
</aside><!-- title_line end -->

<ul class="right_btns mb10">
    <li><p class="btn_grid"><a id="addCreditCardBtn" href="#"><spring:message code="sal.btn.addNewCreditCard" /></a></p></li>
    <li><p class="btn_grid"><a id="selCreditCardBtn" href="#"><spring:message code="sal.btn.selectAnotherCreditCard" /></a></p></li>
</ul>
<!------------------------------------------------------------------------------
    Credit Card - Form ID(crcForm)
------------------------------------------------------------------------------->
<form id="crcForm" name="crcForm" action="#" method="post">

<table class="type1 mb1m"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:170px" />
    <col style="width:*" />
    <col style="width:190px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.creditCardNumber" /><span class="must">*</span></th>
    <td><input id="rentPayCRCNo" name="rentPayCRCNo" type="text" placeholder="Credit Card Number" class="w100p readonly" readonly/>
        <input id="hiddenRentPayCRCId" name="rentPayCRCId" type="hidden" />
        <input id="hiddenRentPayEncryptCRCNoId" name="hiddenRentPayEncryptCRCNoId" type="hidden" /></td>
    <th scope="row"><spring:message code="sal.text.creditCardType" /></th>
    <td><input id="rentPayCRCType" name="rentPayCRCType" type="text" placeholder="Credit Card Type" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.nameOnCard" /></th>
    <td><input id="rentPayCRCName" name="rentPayCRCName" type="text" placeholder="Name On Card" class="w100p readonly" readonly/></td>
    <th scope="row"><spring:message code="sal.text.expiry" /></th>
    <td><input id="rentPayCRCExpiry" name="rentPayCRCExpiry" type="text" placeholder="Credit Card Expiry" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.issueBank" /></th>
    <td><input id="rentPayCRCBank" name="rentPayCRCBank" type="text" placeholder="Issue Bank" class="w100p readonly" readonly/>
        <input id="hiddenRentPayCRCBankId" name="rentPayCRCBankId" type="hidden" class="w100p" /></td>
    <th scope="row"><spring:message code="sal.text.cardType" /></th>
    <td><input id="rentPayCRCCardType" name="rentPayCRCCardType" type="text" placeholder="Card Type" class="w100p readonly" readonly/></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue"><a name="ordSaveBtn" href="#"><spring:message code="sal.btn.ok" /></a></p></li>
</ul>
</form>
</section>

<section id="sctDirectDebit" class="blind">

<aside class="title_line"><!-- title_line start -->
<h3><spring:message code="sal.title.text.directDebit" /></h3>
</aside><!-- title_line end -->

<ul class="right_btns mb10">
    <li><p class="btn_grid"><a id="btnAddBankAccount" href="#"><spring:message code="sal.btn.addNewBankAcc" /></a></p></li>
    <li><p class="btn_grid"><a id="btnSelBankAccount" href="#"><spring:message code="sal.btn.selectAnotherBankAccount" /></a></p></li>
</ul>
<!------------------------------------------------------------------------------
    Direct Debit - Form ID(ddForm)
------------------------------------------------------------------------------->
<form id="ddForm" name="ddForm" action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:170px" />
    <col style="width:*" />
    <col style="width:190px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.accountNumber" /><span class="must">*</span></th>
    <td><input id="rentPayBankAccNo" name="rentPayBankAccNo" type="text" placeholder="Account Number readonly" class="w100p readonly" readonly/>
        <input id="hiddenRentPayBankAccID" name="hiddenRentPayBankAccID" type="hidden" /></td>
    <th scope="row"><spring:message code="sal.text.accountType" /></th>
    <td><input id="rentPayBankAccType" name="rentPayBankAccType" type="text" placeholder="Account Type readonly" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.accountHolder" /></th>
    <td><input id="accName" name="accName" type="text" placeholder="Account Holder" class="w100p readonly" readonly/></td>
    <th scope="row"><spring:message code="sal.text.issueBankBranch" /></th>
    <td><input id="accBranch" name="accBranch" type="text" placeholder="Issue Bank Branch" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <spring:message code="sal.text.ddcChnl" var="ddcChnl"/> <!-- DEDUCTION CHANNEL -->
    <th scope="row">${ddcChnl}</th>
    <td><input id="ddcChl" name="ddcChl" type="text" placeholder="${ddcChnl}" class="w100p readonly" readonly />
    <input id="hiddenAccBankId" name="hiddenDdcChl" type="hidden" /></td>
    <th scope="row"><spring:message code="sal.text.issueBank" /></th>
    <td><input id="accBank" name="accBank" type="text" placeholder="Issue Bank" class="w100p readonly" readonly />
    <input id="hiddenAccBankId" name="hiddenAccBankId" type="hidden" /></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue"><a name="ordSaveBtn" href="#"><spring:message code="sal.btn.ok" /></a></p></li>
</ul>
</form>
</section>

</section><!-- search_table end -->

</article><!-- tap_area end -->

<!--****************************************************************************
    Billing Detail
*****************************************************************************-->
<article id="atcBD" class="tap_area"><!-- tap_area start -->

<section class="search_table"><!-- search_table start -->

<!-- New Billing Group Type start -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.groupOption" /><span class="must">*</span></th>
    <td>
    <label><input type="radio" id="grpOpt1" name="grpOpt" value="new"  /><span><spring:message code="sal.btn.newBillingGroup" /></span></label>
    <label><input type="radio" id="grpOpt2" name="grpOpt" value="exist"/><span><spring:message code="sal.btn.existBillGrp" /></span></label>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<!------------------------------------------------------------------------------
    Billing Method - Form ID(billMthdForm)
------------------------------------------------------------------------------->
<section id="sctBillMthd" class="blind">

<form id="billMthdForm" name="billMthdForm" action="#" method="post">

<table class="type1 mb1m"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row" rowspan="5"><spring:message code="sal.text.billingMethod" /><span class="must">*</span></th>
    <td colspan="3">
    <label><input id="billMthdPost" name="billMthd" type="radio" disabled/><span><spring:message code="sal.text.post" /></span></label>
    </td>
</tr>
<tr>
    <td colspan="3">
    <label><input id="billMthdSms" name="billMthd" type="radio" /><span><spring:message code="sal.text.sms" /></span></label>
    <label><input id="billMthdSms1" name="billMthdSms1" type="checkbox" disabled/><span><spring:message code="sal.text.mobile" /> 1</span></label>
    <label><input id="billMthdSms2" name="billMthdSms2" type="checkbox" disabled/><span><spring:message code="sal.text.mobile" /> 2</span></label>
    </td>
</tr>
<tr>
    <td>
    <label><input id="billMthdEstm" name="billMthd" type="radio" /><span><spring:message code="sal.text.eBilling" /></span></label>
    <label><input id="billMthdEmail1" name="billMthdEmail1" type="checkbox" disabled/><span><spring:message code="sal.text.email" /> 1</span></label>
    <label><input id="billMthdEmail2" name="billMthdEmail2" type="checkbox" disabled/><span><spring:message code="sal.text.email" /> 2</span></label>
    </td>
    <th scope="row"><spring:message code="sal.title.text.eamilOne" /><span id="spEmail1" class="must">*</span></th>
    <td><input id="billMthdEmailTxt1" name="billMthdEmailTxt1" type="text" placeholder="Email Address" class="w100p" disabled/></td>
</tr>
<tr>
    <td>
    <label><input id="billMthdEInv" name="billMthdEInv" type="checkbox"/><span><spring:message code="sal.title.text.eInvoicFlag" /></span></label>
    </td>
    <th scope="row"><spring:message code="sal.title.text.emailTwo" /></th>
    <td><input id="billMthdEmailTxt2" name="billMthdEmailTxt2" type="text" placeholder="Email Address" class="w100p" disabled/></td>
</tr>
<tr>
    <td>
    <label><input id="billGrpWeb" name="billGrpWeb" type="checkbox" /><span><spring:message code="sal.text.webPortal" /></span></label>
    </td>
    <th scope="row"><spring:message code="sal.text.webAddrUrl" /></th>
    <td><input id="billGrpWebUrl" name="billGrpWebUrl" type="text" placeholder="Web Address" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</section>

<!------------------------------------------------------------------------------
    Billing Address - Form ID(billAddrForm)
------------------------------------------------------------------------------->
<section id="sctBillAddr" class="blind">
<form id="billAddrForm" name="billAddrForm" action="#" method="post">
    <input id="hiddenBillAddId"     name="custAddId"           type="hidden"/>
    <input id="hiddenBillStreetId"  name="hiddenBillStreetId"  type="hidden"/>

<aside class="title_line"><!-- title_line start -->
<h3><spring:message code="sal.title.billingAddress" /></h3>
</aside><!-- title_line end -->

<ul class="right_btns mb10">
    <li id="liBillNewAddr" class="blind"><p class="btn_grid"><a id="billNewAddrBtn" href="#"><spring:message code="sal.btn.addNewAddr" /></a></p></li>
    <li id="liBillSelAddr" class="blind"><p class="btn_grid"><a id="billSelAddrBtn" href="#"><spring:message code="sal.title.text.selectAnotherAddress" /></a></p></li>
</ul>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.addressDetail" /><span class="must">*</span></th>
    <td colspan="3">
    <input id="billAddrDtl" name="billAddrDtl" type="text" placeholder="Address Detail" class="w100p readonly" readonly/>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.street" /></th>
    <td colspan="3">
    <input id="billStreet" name="billStreet" type="text" placeholder="Street" class="w100p readonly" readonly/>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.area" /><span class="must">*</span></th>
    <td colspan="3">
    <input id="billArea" name="billArea" type="text" placeholder="Area" class="w100p readonly" readonly/>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.city" /><span class="must">*</span></th>
    <td>
    <input id="billCity" name="billCity" type="text" placeholder="City" class="w100p readonly" readonly/>
    </td>
    <th scope="row"><spring:message code="sal.text.postCode" /><span class="must">*</span></th>
    <td>
    <input id="billPostCode" name="billPostCode" type="text" placeholder="Postcode" class="w100p readonly" readonly/>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.state" /><span class="must">*</span></th>
    <td>
    <input id="billState" name="billState" type="text" placeholder="State" class="w100p readonly" readonly/>
    </td>
    <th scope="row"><spring:message code="sal.text.country" /><span class="must">*</span></th>
    <td>
    <input id="billCountry" name="billCountry" type="text" placeholder="Country" class="w100p readonly" readonly/>
    </td>
</tr>

</tbody>
</table><!-- table end -->
<!-- Existing Type end -->
</form>
</section>
<br>

<section id="sctBillPrefer" class="blind">
<aside class="title_line"><!-- title_line start -->
<h3><spring:message code="sal.title.text.billPrefer" /></h3>
</aside><!-- title_line end -->

<ul class="right_btns mb10">
    <li id="liBillPreferNewAddr" class="blind"><p class="btn_grid"><a id="billPreferAddAddrBtn" href="#"><spring:message code="sal.btn.addNewContact" /></a></p></li>
    <li id="liBillPreferSelAddr" class="blind"><p class="btn_grid"><a id="billPreferSelAddrBtn" href="#"><spring:message code="sal.btn.selNewContact" /></a></p></li>
</ul>

<!------------------------------------------------------------------------------
    Billing Preference - Form ID(billPreferForm)
------------------------------------------------------------------------------->
<section class="search_table"><!-- search_table start -->
<form id="billPreferForm" name="billPreferForm" action="#" method="post">
    <input id="hiddenBPCareId" name="hiddenBPCareId" type="hidden" />
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.initial" /><span class="must">*</span></th>
    <td colspan="3"><select id="billPreferInitial" name="billPreferInitial" class="w100p"></select>
        </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.name" /><span class="must">*</span></th>
    <td colspan="3"><input id="billPreferName" name="billPreferName" type="text" placeholder="Name" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.telO" /><span class="must">*</span></th>
    <td><input id="billPreferTelO" name="billPreferTelO" type="text" placeholder="Tel(Office)" class="w100p" readonly/></td>
    <th scope="row"><spring:message code="sal.text.extNo" /><span class="must">*</span></th>
    <td><input id="billPreferExt" name="billPreferExt" type="text" placeholder="Ext No." class="w100p" readonly/></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</section><!-- search_table end -->
</section>

<!------------------------------------------------------------------------------
    Billing Group Selection - Form ID(billPreferForm)
------------------------------------------------------------------------------->
<section id="sctBillSel" class="blind">
<form id="billSelForm" name="billSelForm" action="#" method="post">

<aside class="title_line"><!-- title_line start -->
<h3><spring:message code="sal.page.subtitle.billingGroupSelection" /></h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.billingGroup" /><span class="must">*</span></th>
    <td><input id="billGrp" name="billGrp" type="text" placeholder="Billing Group" class="readonly" readonly/><a id="billGrpBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
        <input id="hiddenBillGrpId" name="billGrpId" type="hidden" /></td>
    <th scope="row"><spring:message code="sal.text.billingType" /><span class="must">*</span></th>
    <td><input id="billType" name="billType" type="text" placeholder="Billing Type" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.billingAddress" /></th>
    <td colspan="3"><textarea id="billAddr" name="billAddr" cols="20" rows="5" readonly></textarea></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</section>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.remark" /></th>
    <td><textarea id="billRem" name="billRem" cols="20" rows="5" readonly></textarea></td>
</tr>
</tbody>
</table><!-- table end -->
<!-- Existing Type end -->

<ul class="center_btns">
    <li><p class="btn_blue"><a name="ordSaveBtn" href="#"><spring:message code="sal.btn.ok" /></a></p></li>
</ul>

</section><!-- search_table end -->

</article><!-- tap_area end -->

<!--****************************************************************************
    Installation
*****************************************************************************-->
<article class="tap_area"><!-- tap_area start -->

<section class="search_table"><!-- search_table start -->

<aside class="title_line"><!-- title_line start -->
<h3><spring:message code="sal.text.instAddr" /></h3>
</aside><!-- title_line end -->

<ul class="right_btns mb10">
    <li id="liInstNewAddr" class="blind"><p class="btn_grid"><a id="instNewAddrBtn" href="#"><spring:message code="sal.btn.addNewAddr" /></a></p></li>
    <li id="liInstSelAddr" class="blind"><p class="btn_grid"><a id="instSelAddrBtn" href="#"><spring:message code="sal.title.text.selectAnotherAddress" /></a></p></li>
</ul>

<!------------------------------------------------------------------------------
    Installation Address - Form ID(instAddrForm)
------------------------------------------------------------------------------->
<form id="instAddrForm" name="instAddrForm" action="#" method="post">
    <input id="hiddenCustAddId" name="custAddId" type="hidden"/>
    <input id="validAreaIdYN" name="validAreaIdYN" type="hidden" value="Y" />

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:120px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.addressDetail" /><span class="must">*</span></th>
    <td colspan="3"><input id="instAddrDtl" name="instAddrDtl" type="text" placeholder="Address Detail" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.street" /><span class="must">*</span></th>
    <td colspan="3"><input id="instStreet" name="instStreet" type="text" placeholder="Street" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.area" /><span class="must">*</span></th>
    <td colspan="3"><input id="instArea" name="instArea" type="text" placeholder="Area" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.city" /><span class="must">*</span></th>
    <td>
    <input id="instCity" name="instCity" type="text" placeholder="City" class="w100p readonly" readonly/>
    </td>
    <th scope="row"><spring:message code="sal.text.postCode" /><span class="must">*</span></th>
    <td>
    <input id="instPostCode" name="instPostCode" type="text" placeholder="Post Code" class="w100p readonly" readonly/>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.state" /><span class="must">*</span></th>
    <td>
    <input id="instState" name="instState" type="text" placeholder="State" class="w100p readonly" readonly/>
    </td>
    <th scope="row"><spring:message code="sal.text.country" /><span class="must">*</span></th>
    <td>
    <input id="instCountry" name="instCountry" type="text" placeholder="Country" class="w100p readonly" readonly/>
    </td>
</tr>

</tbody>
</table><!-- table end -->
</form>

<section id="tbInstCntcPerson" class="blind">

<aside class="title_line"><!-- title_line start -->
<h3><spring:message code="sal.title.text.installCntcPerson" /></h3>
</aside><!-- title_line end -->

<ul class="right_btns mb10">
    <li id="liInstNewAddr2" class="blind"><p class="btn_grid"><a href="#"><spring:message code="sal.btn.addNewAddr" /></a></p></li>
    <li id="liInstSelAddr2" class="blind"><p class="btn_grid"><a href="#"><spring:message code="sal.title.text.selectAnotherAddress" /></a></p></li>
</ul>

<!------------------------------------------------------------------------------
    Installation Contact Person - Form ID(instCntcForm)
------------------------------------------------------------------------------->
<form id="instCntcForm" name="instCntcForm" action="#" method="post">
    <input id="hiddenInstCntcId" name="instCntcId"    type="hidden"/>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.name" /><span class="must">*</span></th>
    <td><input id="instCntcName" name="instCntcName" type="text" placeholder="" class="w100p" readonly/></td>
    <th scope="row"><spring:message code="sal.text.initial" /></th>
    <td><input id="instInitial" name="instInitial" type="text" placeholder="" class="w100p" readonly/></td>
    <th scope="row"><spring:message code="sal.text.gender" /></th>
    <td><input id="instGender" name="instGender" type="text" placeholder="" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.nric" /></th>
    <td><input id="instNric" name="instNric" type="text" placeholder="" class="w100p" readonly/></td>
    <th scope="row"><spring:message code="sal.text.dob" /></th>
    <td><input id="instDob" name="instDob" type="text" placeholder="" class="w100p" readonly/></td>
    <th scope="row"><spring:message code="sal.text.race" /></th>
    <td><input id="instRaceId" name="instRaceId" type="text" placeholder="" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.email" /></th>
    <td><input id="instCntcEmail" name="instCntcEmail" type="text" placeholder="" class="w100p" readonly/></td>
    <th scope="row"><spring:message code="sal.text.dept" /></th>
    <td><input id="instDept" name="instDept" type="text" placeholder="" class="w100p" readonly/></td>
    <th scope="row"><spring:message code="sal.text.post" /></th>
    <td><input id="instPost" name="instPost" type="text" placeholder="" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.telM" /></th>
    <td><input id="instCntcTelM" name="instCntcTelM" type="text" placeholder="" class="w100p" readonly/></td>
    <th scope="row"><spring:message code="sal.title.text.telR" /></th>
    <td><input id="instCntcTelR" name="instCntcTelR" type="text" placeholder="" class="w100p" readonly/></td>
    <th scope="row"><spring:message code="sal.title.text.telO" /></th>
    <td><input id="instCntcTelO" name="instCntcTelO" type="text" placeholder="" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.telF" /></th>
    <td><input id="instCntcTelF" name="instCntcTelF" type="text" placeholder="" class="w100p" readonly/></td>
    <th scope="row"></th>
    <td></td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</section>

<aside class="title_line"><!-- title_line start -->
<h3><spring:message code="sal.title.text.installInfomation" /></h3>
</aside><!-- title_line end -->

<!------------------------------------------------------------------------------
    Installation Contact Person - Form ID(installForm)
------------------------------------------------------------------------------->
<form id="installForm" name="installForm" action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.zeroGst" /><span class="must">*</span></th>
    <td>
    <p><select id="gstChk" name="gstChk" class="w100p"></select></p>
    <p id="pBtnCal" class="btn_sky blind"><a id="btnCal" href="#">Calculation</a></p>
    </td>
    <th scope="row">DT Branch<span class="must">*</span></th>
    <td>
    <select id="dscBrnchId" name="dscBrnchId" class="w100p" disabled></select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.perferInstDate" /><span class="must">*</span></th>
    <td><input id="prefInstDt" name="prefInstDt" type="text" title="Create start Date" placeholder="Prefer Install Date (dd/MM/yyyy)" class="j_date w100p" /></td>
    <th scope="row"><spring:message code="sal.title.text.perferInstTime" /><span class="must">*</span></th>
    <td>
    <div class="time_picker"><!-- time_picker start -->
    <input id="prefInstTm" name="prefInstTm" type="text" placeholder="Prefer Install Time (hh:mi tt)" class="time_date w100p" />
    <ul>
        <li>Time Picker</li>
        <li><a href="#">12:00 AM</a></li>
        <li><a href="#">01:00 AM</a></li>
        <li><a href="#">02:00 AM</a></li>
        <li><a href="#">03:00 AM</a></li>
        <li><a href="#">04:00 AM</a></li>
        <li><a href="#">05:00 AM</a></li>
        <li><a href="#">06:00 AM</a></li>
        <li><a href="#">07:00 AM</a></li>
        <li><a href="#">08:00 AM</a></li>
        <li><a href="#">09:00 AM</a></li>
        <li><a href="#">10:00 AM</a></li>
        <li><a href="#">11:00 AM</a></li>
        <li><a href="#">12:00 PM</a></li>
        <li><a href="#">01:00 PM</a></li>
        <li><a href="#">02:00 PM</a></li>
        <li><a href="#">03:00 PM</a></li>
        <li><a href="#">04:00 PM</a></li>
        <li><a href="#">05:00 PM</a></li>
        <li><a href="#">06:00 PM</a></li>
        <li><a href="#">07:00 PM</a></li>
        <li><a href="#">08:00 PM</a></li>
        <li><a href="#">09:00 PM</a></li>
        <li><a href="#">10:00 PM</a></li>
        <li><a href="#">11:00 PM</a></li>
    </ul>
    </div><!-- time_picker end -->
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.specialInstruction" /><span class="must">*</span></th>
    <td colspan="3"><textarea id="speclInstct" name="speclInstct" cols="20" rows="5"></textarea></td>
</tr>
</tbody>
</table><!-- table end -->

<!-- Existing Type end -->

<ul class="center_btns">
    <li><p class="btn_blue"><a name="ordSaveBtn" href="#"><spring:message code="sal.btn.ok" /></a></p></li>
</ul>

</form>
</section><!-- search_table end -->

</article><!-- tap_area end -->

<!--****************************************************************************
    Documents
*****************************************************************************-->
<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_doc_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->
<ul class="center_btns">
    <li><p class="btn_blue"><a name="ordSaveBtn" href="#"><spring:message code="sal.btn.ok" /></a></p></li>
</ul>
</article><!-- tap_area end -->

<!--****************************************************************************
    Relief Certificate - Form ID(rliefForm)
*****************************************************************************-->
<article id="atcRC" class="tap_area"><!-- tap_area start -->

<section class="search_table"><!-- search_table start -->
<form id="fileUploadForm" name="fileUploadForm" enctype="multipart/form-data" action="#" method="post">
    <input id="atchFileGrpId" name="atchFileGrpId" type="hidden" />

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:200px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.refNo" /><span class="must">*</span></th>
    <td><input id="certRefNo" name="certRefNo" type="text" placeholder="Cert Reference No" class="w100p" /></td>
    <th scope="row"><spring:message code="sal.title.text.certificateDate" /><span class="must">*</span></th>
    <td><input id="certRefDt" name="certRefDt" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" /></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.gstRegistrationNo" /></th>
    <td colspan="3"><input id="txtCertCustRgsNo" name="txtCertCustRgsNo" type="text" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.remark" /></th>
    <td colspan="3"><textarea id="txtCertRemark" name="txtCertRemark" cols="20" rows="5"></textarea></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.uploadReliefZipFile" /></th>
    <td colspan="3">
        <!-- auto_file start -->
        <div class="auto_file">
            <input id="certRefFile" name="certRefFile" type="file" title="file add" />
        </div>
        <!-- auto_file end -->
    </td>
</tr>
</tbody>
</table><!-- table end -->
<ul class="left_opt">
    <li><span class="red_text">**</span> <span class="brown_text"><spring:message code="sal.msg.zeroGstMsg" /></span></li>
</ul>

<ul class="center_btns">
    <li><p class="btn_blue"><a name="ordSaveBtn" href="#"><spring:message code="sal.btn.ok" /></a></p></li>
</ul>

</form>
</section><!-- search_table end -->

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->