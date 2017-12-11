<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ include file="/WEB-INF/jsp/sales/order/convertToOrderInc.jsp" %>
<%@ include file="/WEB-INF/jsp/sales/order/copyChangeOrderInc.jsp" %>

<script type="text/javaScript" language="javascript">

    var convToOrdYn  = "${CONV_TO_ORD_YN}";
    var copyChangeYn = "${COPY_CHANGE_YN}";

    var docGridID;
    var docDefaultChk = false;
    
    $(document).ready(function(){

        createAUIGrid();

        fn_selectDocSubmissionList();

        doGetComboOrder('/common/selectCodeList.do', '10', 'CODE_ID',   '', 'appType',     'S', ''); //Common Code
        doGetComboOrder('/common/selectCodeList.do', '19', 'CODE_NAME', '', 'rentPayMode', 'S', ''); //Common Code
        doGetComboOrder('/common/selectCodeList.do', '17', 'CODE_NAME', '', 'billPreferInitial', 'S', ''); //Common Code
        doGetComboSepa ('/common/selectBranchCodeList.do', '5',  ' - ', '', 'dscBrnchId',  'S', ''); //Branch Code

        doGetComboData('/common/selectCodeList.do', {groupCode :'324'}, '',  'empChk',  'S'); //EMP_CHK
        doGetComboData('/common/selectCodeList.do', {groupCode :'325'}, '0', 'exTrade', 'S'); //EX-TRADE
        doGetComboData('/common/selectCodeList.do', {groupCode :'326'}, '0', 'gstChk',  'S'); //GST_CHK
        doGetComboOrder('/common/selectCodeList.do', '322', 'CODE_ID', '', 'promoDiscPeriodTp', 'S'); //Discount period

        //Payment Channel, Billing Detail TAB Visible False처리
        fn_tabOnOffSet('PAY_CHA', 'HIDE');
        fn_tabOnOffSet('BIL_DTL', 'HIDE');
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
        var columnLayout = [{
                dataField : "chkfield",
                headerText : ' ',
                width: 70,
                renderer : {
                    type : "CheckBoxEditRenderer",
                    showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                    editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                    checkValue : 1, // true, false 인 경우가 기본
                    unCheckValue : 0
                }
            }, {
                dataField   : "typeDesc",   headerText  : "Document",
                editable    : false,        style       : 'left_style'
            }, {
                dataField   : "codeId",     visible     : true
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
            selectionMode       : "singleRow",  //"multipleCells",
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
        Common.ajax("GET", "/sales/order/selectDocSubmissionList.do", {typeCodeId : '248'}, function(result) {
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
            }
            else {
                if(sMethd == 2) {
                    Common.alert('<b>Third party not found.<br />'
                               + 'Your input third party ID : ' + custId + '</b>');
                }
            }
        });
        }
        else {
            Common.alert('<b>Third party and customer cannot be same person/company.<br />'
                       + 'Your input third party ID : ' + custId + '</b>');
        }

        $('#sctThrdParty').removeClass("blind");
    }

    function fn_loadCustomer(custId){

        $("#searchCustId").val(custId);

        Common.ajax("GET", "/sales/customer/selectCustomerJsonList", {custId : custId}, function(result) {

            if(result != null && result.length == 1) {
                
                fn_tabOnOffSet('BIL_DTL', 'SHOW');

                var custInfo = result[0];

                console.log("성공.");
                console.log("custId : " + result[0].custId);
                console.log("userName1 : " + result[0].name);

                //
                $("#hiddenCustId").val(custInfo.custId); //Customer ID(Hidden)
                $("#custId").val(custInfo.custId); //Customer ID
                $("#custTypeNm").val(custInfo.codeName1); //Customer Name
                $("#typeId").val(custInfo.typeId); //Type
                $("#name").val(custInfo.name); //Name
                $("#nric").val(custInfo.nric); //NRIC/Company No
                $("#nationNm").val(custInfo.name2); //Nationality
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

                if(custInfo.corpTypeId > 0) {
                    $("#corpTypeNm").val(custInfo.codeName); //Industry Code
                }
                else {
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
                    Common.alert('<b>Goverment Customer</b>');
                }
            }
            else {
                Common.alert('<b>Customer not found.<br>Your input customer ID :'+$("#searchCustId").val()+'</b>');
            }
        });
    }

    function fn_loadMailAddr(custAddId){
        console.log("fn_loadMailAddr START");

        Common.ajax("GET", "/sales/order/selectCustAddJsonInfo.do", {custAddId : custAddId}, function(billCustInfo) {

            if(billCustInfo != null) {

                console.log("성공.");
                console.log("hiddenBillAddId : " + billCustInfo.custAddId);

                $("#hiddenBillAddId").val(billCustInfo.custAddId); //Customer Address ID(Hidden)
                $("#billAddrDtl").val(billCustInfo.addrDtl); //Address
                $("#billStreet").val(billCustInfo.street); //Street
                $("#billArea").val(billCustInfo.area); //Area
                $("#billCity").val(billCustInfo.city); //City
                $("#billPostCode").val(billCustInfo.postcode); //Post Code
                $("#billState").val(billCustInfo.state); //State
                $("#billCountry").val(billCustInfo.country); //Country
                
                $("#hiddenBillStreetId").val(billCustInfo.custAddId); //Magic Address STREET_ID(Hidden)

                console.log("hiddenBillAddId2 : " + $("#hiddenBillAddId").val());
            }
        });
    }

    function fn_loadInstallAddr(custAddId){
        console.log("fn_loadInstallAddr START");

        Common.ajaxSync("GET", "/sales/order/selectCustAddJsonInfo.do", {custAddId : custAddId}, function(custInfo) {

            if(custInfo != null) {

                console.log("성공.");
                console.log("gstChk : " + custInfo.gstChk);

                //
                $("#hiddenCustAddId").val(custInfo.custAddId); //Customer Address ID(Hidden)
                $("#instAddrDtl").val(custInfo.addrDtl); //Address
                $("#instStreet").val(custInfo.street); //Street
                $("#instArea").val(custInfo.area); //Area
                $("#instCity").val(custInfo.city); //City
                $("#instPostCode").val(custInfo.postcode); //Post Code
                $("#instState").val(custInfo.state); //State
                $("#instCountry").val(custInfo.country); //Country
                
                $("#dscBrnchId").val(custInfo.brnchId); //DSC Branch
                
//              if(!$("#gstChk").is('[disabled]')) {

                    if(custInfo.gstChk == '1') {
                        $("#gstChk").val('1').prop("disabled", true);
                        $("#pBtnCal").removeClass("blind");
                        fn_tabOnOffSet('REL_CER', 'SHOW');
                    }
                    else {
                        $("#gstChk").val('0').removeAttr("disabled");
                        $('#pBtnCal').addClass("blind");
                        fn_tabOnOffSet('REL_CER', 'HIDE');
                    }
//              }
            }
        });
    }
    
    function fn_checkDocList(doCheck) {
        
        var vAppType  = $("#appType").val();
        var vCustType = $("#typeId").val();
        var vNational = $("#nationNm").val();
        
        console.log('fn_checkDocList()');
        console.log('vAppType:'+vAppType);
        console.log('vCustType:'+vCustType);
        console.log('vNational:'+vNational);
        
        for(var i = 0; i < AUIGrid.getRowCount(docGridID) ; i++) {
            
            AUIGrid.setCellValue(docGridID, i, "chkfield", 0);

            if(doCheck == true) {
                var vCodeId = AUIGrid.getCellValue(docGridID, i, "codeId");
                
                if(vAppType == '66' && vCustType == '964') {
                    if(vNational == 'MALAYSIA') {
                        if(vCodeId == '250' || vCodeId == '1244' || vCodeId == '271') {
                            AUIGrid.setCellValue(docGridID, i, "chkfield", 1);
                            
                            if(docDefaultChk == false) docDefaultChk = true;
                        }                    
                    }
                    else {
                        if(vCodeId == '939' || vCodeId == '940' || vCodeId == '1244') {
                            AUIGrid.setCellValue(docGridID, i, "chkfield", 1);
                            
                            if(docDefaultChk == false) docDefaultChk = true;
                        }
                    }
                }
            }
            else {
                 docDefaultChk = false;
            }
        }
    }

    function fn_loadSrvCntcPerson(custCareCntId) {
        console.log("fn_loadSrvCntcPerson START");

        $("#searchCustCareCntId").val(custCareCntId);

        Common.ajax("GET", "/sales/order/selectSrvCntcJsonInfo.do", {custCareCntId : custCareCntId}, function(srvCntcInfo) {

            if(srvCntcInfo != null) {

                console.log("성공.");
                console.log("srvCntcInfo:"+srvCntcInfo.custCareCntId);
                console.log("srvCntcInfo:"+srvCntcInfo.name);
                console.log("srvCntcInfo:"+srvCntcInfo.custInitial);
                console.log("srvCntcInfo:"+srvCntcInfo.email);

                //
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

    function fn_loadCntcPerson(custCntcId){
        console.log("fn_loadCntcPerson START");

        Common.ajax("GET", "/sales/order/selectCustCntcJsonInfo.do", {custCntcId : custCntcId}, function(custCntcInfo) {

            if(custCntcInfo != null) {
                console.log('custCntcInfo.custCntcId:'+custCntcInfo.custCntcId);
                //
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
        console.log("fn_loadInstallationCntcPerson START :custCntcId:"+custCntcId);

        $("#searchCustCntcId").val(custCntcId);

        Common.ajax("GET", "/sales/order/selectCustCntcJsonInfo.do", {custCntcId : custCntcId}, function(instCntcInfo) {

            if(instCntcInfo != null) {

                console.log("fn_loadInstallationCntcPerson hiddenInstCntcId:"+instCntcInfo.custCntcId);
                console.log("fn_loadInstallationCntcPerson instCntcName    :"+instCntcInfo.name);
                console.log("fn_loadInstallationCntcPerson instInitial     :"+instCntcInfo.custInitial);
                console.log("fn_loadInstallationCntcPerson instCntcEmail   :"+instCntcInfo.email);

                $("#hiddenInstCntcId").val(instCntcInfo.custCntcId);
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
//          $('#sctBillPrefer').removeClass("blind");

            $('#liBillNewAddr').removeClass("blind");
            $('#liBillSelAddr').removeClass("blind");
            $('#liBillPreferNewAddr').removeClass("blind");
            $('#liBillPreferSelAddr').removeClass("blind");


            $('#billMthdEmailTxt1').val($('#custCntcEmail').val().trim());
            $('#billMthdEmailTxt2').val($('#srvCntcEmail').val().trim());

            if($('#typeId').val() == '965') { //Company

                console.log("fn_setBillGrp 1 typeId : "+$('#typeId').val());

                $('#sctBillPrefer').removeClass("blind");

                fn_loadBillingPreference($('#srvCntcId').val());

                /*
                btnBillGroupEStatement.Checked = true;
                btnBillGroupEmail_1.Checked = true;
                btnBillGroupEmail_1.Enabled = true;
                btnBillGroupEmail_2.Enabled = true;
                txtBillGroupEmail_1.Enabled = true;
                txtBillGroupEmail_2.Enabled = true;
                */

                $('#billMthdEstm').prop("checked", true);
                $('#billMthdEmail1').prop("checked", true).removeAttr("disabled");
                $('#billMthdEmail2').removeAttr("disabled");
                $('#billMthdEmailTxt1').removeAttr("disabled");
                $('#billMthdEmailTxt2').removeAttr("disabled");
            }
            else if($('#typeId').val() == '964') { //Individual

                console.log("fn_setBillGrp 2 typeId : "+$('#typeId').val());
                console.log("custCntcEmail : "+$('#custCntcEmail').val());
                console.log(FormUtil.isNotEmpty($('#custCntcEmail').val().trim()));

                if(FormUtil.isNotEmpty($('#custCntcEmail').val().trim())) {
                    /*
                    btnBillGroupEStatement.Checked = true;
                    btnBillGroupEmail_1.Checked = true;
                    btnBillGroupEmail_1.Enabled = true;
                    btnBillGroupEmail_2.Enabled = true;
                    txtBillGroupEmail_1.Enabled = true;
                    txtBillGroupEmail_2.Enabled = true;
                    */
                    $('#billMthdEstm').prop("checked", true);
                    $('#billMthdEmail1').prop("checked", true).removeAttr("disabled");
                    $('#billMthdEmail2').removeAttr("disabled");
                    $('#billMthdEmailTxt1').removeAttr("disabled");
                    $('#billMthdEmailTxt2').removeAttr("disabled");
                }

                $('#billMthdSms').prop("checked", true);
                $('#billMthdSms1').prop("checked", true).removeAttr("disabled");
                $('#billMthdSms2').removeAttr("disabled");
            }
        }
        else if(grpOpt == 'exist') {

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

    $(function(){
        $('#btnRltdNo').click(function() {
            Common.popupDiv("/sales/order/prevOrderNoPop.do", {custId : $('#hiddenCustId').val()}, null, true);
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
            Common.popupDiv("/sales/customer/customerCreditCardAddPop.do", {custId : vCustId, callPrgm : "ORD_REGISTER_PAYM_CRC"}, null, true);
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
        $('[name="grpOpt"]').click(function() {
            fn_setBillGrp($('input:radio[name="grpOpt"]:checked').val());
        });
        $('#trialNoChk').click(function() {
            if($('#trialNoChk').is(":checked")) {
                $('#trialNo').val('').removeClass("readonly");
                $('#trialNoBtn').removeClass("blind");
            }
            else {
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
            }
            else {
                $('#sctThrdParty').addClass("blind");
            }
        });
        $('#billMthdSms').click(function() {

            $('#billMthdSms1').prop("checked", false).prop("disabled", true);
            $('#billMthdSms2').prop("checked", false).prop("disabled", true);

            if($("#billMthdSms").is(":checked")) {
                $('#billMthdSms1').removeAttr("disabled").prop("checked", true);
                $('#billMthdSms2').removeAttr("disabled");
            }
        });
        $('#billMthdEstm').click(function() {

            $('#spEmail1').text("");
            $('#spEmail2').text("");
            $('#billMthdEmail1').prop("checked", false).prop("disabled", true);
            $('#billMthdEmail2').prop("checked", false).prop("disabled", true);
            $('#billMthdEmailTxt1').val("").prop("disabled", true);
            $('#billMthdEmailTxt2').val("").prop("disabled", true);

            if($("#billMthdEstm").is(":checked")) {
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
                fn_tabOnOffSet('REL_CER', 'SHOW');
            }
            else {
                $('#pBtnCal').addClass("blind");
                fn_tabOnOffSet('REL_CER', 'HIDE');
                
                var appTypeVal = $("#appType").val();
                var stkIdVal   = $("#ordProudct").val();
                var promoIdVal = $("#ordPromo").val();
                
                fn_loadProductPrice(appTypeVal, stkIdVal);
                if(FormUtil.isNotEmpty(promoIdVal)) {
                    fn_loadPromotionPrice(promoIdVal, stkIdVal);
                }
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

            $('[name="advPay"]').prop("disabled", true);

            var idx    = $("#appType option:selected").index();
            var selVal = $("#appType").val();
            var appSubType = '';
            
            if(idx > 0) {
                if(FormUtil.isEmpty($('#hiddenCustId').val())) {
                    $('#appType').val('');
                    Common.alert('<b>Please select customer first.</b>');

                    $('#aTabCS').click();
                }
                else {
                            
                    switch(selVal) {
                        case '66' : //RENTAL
                            fn_tabOnOffSet('PAY_CHA', 'SHOW');
                            //?FD문서에서 아래 항목 빠짐
                            $('[name="advPay"]').removeAttr("disabled");
                            $('#installDur').val('').prop("readonly", true).addClass("readonly");
                            $("#gstChk").val('0');
                            $('#pBtnCal').addClass("blind");
                            fn_tabOnOffSet('REL_CER', 'HIDE');
                            
                            appSubType = '367';
                            
                            break;

                        case '67' : //OUTRIGHT
//                          $("#gstChk").removeAttr("disabled");
                            
                            appSubType = '368';
                            
                            break;

                        case '68' : //INSTALLMENT
                            $('#installDur').removeAttr("readonly").removeClass("readonly");
//                          $("#gstChk").removeAttr("disabled");
                            
                            appSubType = '369';
                            
                            break;

                        case '1412' : //Outright Plus
                            $('#installDur').val("36").prop("readonly", true).removeClass("readonly");

                            $('[name="advPay"]').removeAttr("disabled");
//                          $("#gstChk").removeAttr("disabled");
                            
                            fn_tabOnOffSet('PAY_CHA', 'SHOW');
                          //fn_tabOnOffSet('REL_CER', 'HIDE');
                            
                            appSubType = '370';

                            break;
                        case '142' : //Sponsor                        
                            appSubType = '371';    
                            break;                            
                        case '143' : //Service
                            appSubType = '372';
                            break;
                        case '144' : //Education
                            appSubType = '373';
                            break;
                        case '145' : //Free Trial
                            appSubType = '374';
                            break;
                        default :
                            $('#installDur').val('').prop("readonly", true).addClass("readonly");
                            $("#gstChk").val('0');
                            $('#pBtnCal').addClass("blind");
                            fn_tabOnOffSet('REL_CER', 'HIDE');

                            break;
                    }
                    
                    var pType = $("#appType").val() == '66' ? '1' : '2';
                    //doGetComboData('/common/selectCodeList.do', {pType : pType}, '',  'srvPacId',  'S', 'fn_setDefaultSrvPacId'); //APPLICATION SUBTYPE
                    doGetComboData('/sales/order/selectServicePackageList.do', {appSubType : appSubType, pType : pType}, '', 'srvPacId', 'S', 'fn_setDefaultSrvPacId'); //APPLICATION SUBTYPE

                    $('#ordProudct ').removeAttr("disabled");
                }
            }
            else {
                $('#srvPacId option').remove(); 
            }
            
            $('#ordProudct option').remove();
            $('#ordProudct optgroup').remove();
        });
        $('#srvPacId').change(function() {

            $('#ordProudct option').remove();
            $('#ordProudct optgroup').remove();

            var idx    = $("#srvPacId option:selected").index();
            var selVal = $("#srvPacId").val();
            
            if(idx > 0) {
                var stkType = $("#appType").val() == '66' ? '1' : '2';
              //doGetProductCombo('/sales/order/selectProductCodeList.do',  stkType, '', 'ordProudct', 'S', ''); //Product Code
                
                doGetComboAndGroup2('/sales/order/selectProductCodeList.do', {stkType:stkType, srvPacId:$('#srvPacId').val()}, '', 'ordProudct', 'S', 'fn_setOptGrpClass');//product 생성
            }
        });
        $('#ordProudct').change(function() {

            if(FormUtil.checkReqValue($('#exTrade'))) {
                Common.alert("Save Sales Order Summary" + DEFAULT_DELIMITER + "<b>* Please select an Ex-Trade.</b>");
                $('#ordProudct').val('');
                return;
            }
            
            if(FormUtil.isEmpty($('#ordProudct').val())) {
                $('#ordPromo option').remove();
                
                $("#ordPrice").val('');
                $("#ordPv").val('');
                $("#ordPvGST").val('');
                $("#ordRentalFees").val('');
                $("#ordPriceId").val('');

                $("#orgOrdPrice").val('');
                $("#orgOrdPv").val('');
                $("#orgOrdRentalFees").val('');
                $("#orgOrdPriceId").val('');
                
                $("#promoDiscPeriodTp").val('');
                $("#promoDiscPeriod").val('');
                
                return;
            }
                
//          $('#ordCampgn option').remove();
//          $('#ordCampgn').prop("readonly", true);
//          $('#relatedNo').val('').prop("readonly", true).addClass("readonly");
            $('#trialNoChk').prop("checked", false).prop("disabled", true);
            $('#trialNo').val('').addClass("readonly");
            $('#ordPrice').val('').addClass("readonly");
            $('#ordPriceId').val('');
            $('#ordPv').val('').addClass("readonly");
            $('#ordRentalFees').val('').addClass("readonly");

            var appTypeIdx = $("#appType option:selected").index();
            var appTypeVal = $("#appType").val();
            var custTypeVal= $("#typeId").val();
            var stkIdx     = $("#ordProudct option:selected").index();
            var stkIdVal   = $("#ordProudct").val();
            var empChk     = $("#empChk").val();
            var exTrade    = $("#exTrade").val();

            if(stkIdx > 0) {
                fn_loadProductPrice(appTypeVal, stkIdVal);
                fn_loadProductPromotion(appTypeVal, stkIdVal, empChk, custTypeVal, exTrade);
            }
        });
        $('#rentPayMode').change(function() {

            console.log('rentPayMode click event');

            fn_clearRentPaySetCRC();
            fn_clearRentPaySetDD();

            var rentPayModeIdx = $("#rentPayMode option:selected").index();
            var rentPayModeVal = $("#rentPayMode").val();

            if(rentPayModeIdx > 0) {
                if(rentPayModeVal == '133' || rentPayModeVal == '134') {

                    Common.alert('<b>Currently we are not provide ['+rentPayModeVal+'] service.</b>');
                    fn_clearRentPayMode();
                }
                else {
                    if(rentPayModeVal == '131') {
                        if($('#thrdParty').is(":checked") && FormUtil.isEmpty($('#hiddenThrdPartyId').val())) {
                            Common.alert('<b>Please select the third party first.</b>');
                        }
                        else {
                            $('#sctCrCard').removeClass("blind");
                        }
                    }
                    else if(rentPayModeVal == '132') {
                        if($('#thrdParty').is(":checked") && FormUtil.isEmpty($('#hiddenThrdPartyId').val())) {
                            Common.alert('<b>Please select the third party first.</b>');
                        }
                        else {
                            $('#sctDirectDebit').removeClass("blind");
                        }
                    }
                }
            }
        });
        $('#exTrade').change(function() {
            
            $('#ordPromo option').remove();
            
            if($("#exTrade").val() == '1') {
                //$('#relatedNo').removeAttr("readonly").removeClass("readonly");
                $('#btnRltdNo').removeClass("blind");
            }
            else {
                //$('#relatedNo').val('').prop("readonly", true).addClass("readonly");
                $('#relatedNo').val('');
                $('#btnRltdNo').addClass("blind");
            }
            $('#ordProudct').val('');

        });
        $('#btnCal').click(function() {            
            if($("#ordProudct option:selected").index() <= 0) {
                Common.alert('<b>* Please select a product.</b>');
                return false;
            }
            var appTypeName  = $('#appType option:selected').text();
            var productName  = $('#ordProudct option:selected').text();
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
            
            var msg = '';
            
            msg += 'Application Type : '+appTypeName +'<br>';
            msg += 'Product          : '+productName +'<br>';
            msg += 'Price(RPF)       : '+newPriceGST +'<br>';
            msg += 'Normal Rental    : '+oldRentalGST+'<br>';
            msg += 'Promotion        : '+newRentalGST+'<br>';
            msg += '<br>The Price(Fee) was applied to the tab of [Sales Order]';
            
            fn_excludeGstAmt();
            
            Common.alert('GST Amount' + DEFAULT_DELIMITER + '<b>'+msg+'</b>');
        });
        $('#ordPromo').change(function() {

//          $('#relatedNo').val('').prop("readonly", true).addClass("readonly");
            $('#trialNoChk').prop("checked", false).prop("disabled", true);
            $('#trialNo').val('').addClass("readonly");

            var appTypeIdx = $("#appType option:selected").index();
            var appTypeVal = $("#appType").val();
            var stkIdIdx   = $("#ordProudct option:selected").index();
            var stkIdVal   = $("#ordProudct").val();
            var promoIdIdx = $("#ordPromo option:selected").index();
            var promoIdVal = $("#ordPromo").val();

            if(promoIdIdx > 0 && promoIdVal != '0') {
/*
                if($("#exTrade").val() == '1') {
                    $('#relatedNo').removeAttr("readonly").removeClass("readonly");
                }
*/
                if(appTypeVal == '66' || appTypeVal == '67' || appTypeVal == '68') {
                    $('#trialNoChk').removeAttr("disabled");
                }

                fn_loadPromotionPrice(promoIdVal, stkIdVal);
            }
            else {
                fn_loadProductPrice(appTypeVal, stkIdVal);
            }
        });
        $('[name="ordSaveBtn"]').click(function() {

//            fn_doSaveOrder();

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

            var isValid = true, msg = "", docSelCnt = 0;

            //첨부파일이 존재하면
            if(!FormUtil.checkReqValue($('#certRefFile'))) {
                isValid = false;

                msg += "Under rare circumstances, Federal Government, State Government, Palace of Ruler and certain organizations ";
                msg += "are given GST relief for purchase of goods under Goods and Services Tax (Relief) Order 2014 at GST rate of 0%. ";
                msg += "\"Certificate under the Goods and Services Tax (Relief) Order 2014 \"" + "must be furnished by customers. <br /> ";
                msg += "<b>Are you sure you want to proceed?</b> <br /><br />";
            }

            docSelCnt = fn_getDocChkCount();
            
            console.log('!@#### docSelCnt:'+docSelCnt);
            
            if(docSelCnt <= 0) {
                isValid = false;

                msg += "You are not select any document in this order.<br />";
                msg += "<b>Are you sure want to save this order without any document submission ?</b><br /><br />";
            }

            console.log('!@#### isValid'+isValid);
            
            if(!isValid) {
                Common.confirm("Confirm To Save" + DEFAULT_DELIMITER + msg, fn_hiddenSave);
            }
            else {

                if($("#ordPromo option:selected").index() > 0) {
                    console.log('!@#### ordSaveBtn click START 00000');
                    if($("#exTrade").val() == 1) {
                        console.log('!@#### ordSaveBtn click START 11111');
                        $('#txtOldOrderID').val('');
                        Common.popupDiv("/sales/order/oldOrderPop.do", {custId : $('#hiddenCustId').val()}, null, true);
                    }
                    else {
                        console.log('!@#### ordSaveBtn click START 22222');
                        Common.popupDiv("/sales/order/cnfmOrderDetailPop.do");
                    }
                }
                else {
                    console.log('!@#### ordSaveBtn click START 33333');                    
                    Common.popupDiv("/sales/order/cnfmOrderDetailPop.do");
                }
            }

        });
    });

	function fn_popOrderDetail() {	    
	    Common.popupDiv("/sales/order/cnfmOrderDetailPop.do");
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
        fn_tabOnOffSet('BIL_DTL', 'HIDE');

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

        console.log('!@#### fn_hiddenSave START');
        
        if($("#ordPromo option:selected").index() > 0) {

            if($("#exTrade").val() == 1) {
                Common.popupDiv("/sales/order/oldOrderPop.do", {custId : $('#hiddenCustId').val()}, null, true);
            }
            else {
                Common.popupDiv("/sales/order/cnfmOrderDetailPop.do");
            }
        }
        else {
            Common.popupDiv("/sales/order/cnfmOrderDetailPop.do");
        }
    }

    function fn_doSaveOrder() {
        console.log('!@# fn_doSaveOrder START');
        
//      $("#gstChk").removeAttr("disabled");
        $("#promoDiscPeriodTp").removeAttr("disabled");
        $("#dscBrnchId").removeAttr("disabled");
        
        //----------------------------------------------------------------------
        // salesOrderMVO
        //----------------------------------------------------------------------
        var vAppType    = $('#appType').val();
        var vDefRentAmt = vAppType == '66' ? $('#ordRentalFees').val().trim() : 0;
        var vCustBillId = vAppType == '66' ? $('input:radio[name="grpOpt"]:checked').val() == 'exist' ? $('#hiddenBillGrpId').val() : 0 : 0;
        var vBindingNo  = FormUtil.isNotEmpty($('#txtOldOrderID').val().trim()) ? $('#relatedNo').val().trim() : $('#hiddenOldOrderId').val().trim();
        var vCnvrSchemeId;

        if($('#trialNoChk').is(":checked")) {
            vBindingNo = $('#trialNo').val().trim();
            vCnvrSchemeId = $('#trialId').val().trim();
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
        var vAccNo = "", vAccName = "", vIssueBankID = 0, vAdtPayMode = "REG";
        
        if($('#rentPayMode').val() == '130') {
            vAdtPayMode = "REG";
        }
        else if($('#rentPayMode').val() == '131') {
            vAccNo = $('#hiddenRentPayCRCId').val().trim();
            vAccName = $('#rentPayCRCName').val().trim();
            vAdtPayMode = "CRC";
        }
        else if($('#rentPayMode').val() == '132') {
            vAccNo = $('#hiddenRentPayBankAccID').val().trim();
            vAccName = $('#accName').val().trim()
            vAdtPayMode = "DD";
        }
        else if($('#rentPayMode').val() == '133') {
            vAdtPayMode = "AEON";
        }
        else if($('#rentPayMode').val() == '134') {
            vAdtPayMode = "FPX";
        }
        
        var orderVO = {
            
            custTypeId  : $('#typeId').val().trim(),
            raceId      : $('#raceId').val().trim(),
            billGrp     : $('input:radio[name="grpOpt"]:checked').val(),
            preOrdId    : '${preOrdId}',
            preOrderYN  : '${CONV_TO_ORD_YN}',
            
            salesOrderMVO : {
                advBill                 : $('input:radio[name="advPay"]:checked').val(),
                appTypeId               : $('#appType').val(),
                srvPacId                : $('#srvPacId').val(),
                bindingNo               : vBindingNo,
                cnvrSchemeId            : vCnvrSchemeId,
                custAddId               : $('#hiddenBillAddId').val().trim(),
                custBillId              : vCustBillId,
                custCareCntId           : $('#srvCntcId').val().trim(),
                custCntId               : $('#hiddenCustCntcId').val().trim(),
                custId                  : $('#hiddenCustId').val().trim(),
                custPoNo                : $('#poNo').val().trim(),
                defRentAmt              : vDefRentAmt,
                deptCode                : $('#departCd').val().trim(),
                grpCode                 : $('#grpCd').val().trim(),
                instPriod               : $('#installDur').val().trim(),
                memId                   : $('#hiddenSalesmanId').val().trim(),
                mthRentAmt              : $('#ordRentalFees').val().trim(), //2017.10.12 ordRentalFees 또는 orgOrdRentalFees 아직 미결정 2017.10.14 ordRentalFees로 결정
                orgCode                 : $('#orgCd').val().trim(),
                promoId                 : $('#ordPromo').val(),
                refNo                   : $('#refereNo').val().trim(),
                rem                     : $('#ordRem').val().trim(),
                salesGmId               : $('#orgMemId').val().trim(),
                salesHmId               : $('#departMemId').val().trim(),
                salesOrdIdOld           : $('#txtOldOrderID').val(),
                salesSmId               : $('#grpMemId').val().trim(),
                totAmt                  : $('#ordPrice').val().trim(),
                totPv                   : $('#ordPv').val().trim(),
                empChk                  : $('#empChk').val(),
                exTrade                 : $('#exTrade').val(),
//              ecash                   : $('#ordPv').val(),
                promoDiscPeriodTp       : $('#promoDiscPeriodTp').val(),
                promoDiscPeriod         : $('#promoDiscPeriod').val().trim(),
                norAmt                  : $('#orgOrdPrice').val().trim(),
                norRntFee               : $('#orgOrdRentalFees').val().trim(),
                discRntFee              : $('#ordRentalFees').val().trim(),
                gstChk                  : $('#gstChk').val()
            },
            salesOrderDVO : {
                itmPrc                  : $('#ordPrice').val().trim(),
                itmPrcId                : $('#ordPriceId').val().trim(),
                itmPv                   : $('#ordPv').val().trim(),
                itmStkId                : $('#ordProudct').val()
            },
            installationVO : {
                addId                   : $('#hiddenCustAddId').val(),
                brnchId                 : $('#dscBrnchId').val(),
                cntId                   : $('#hiddenInstCntcId').val(),
                instct                  : $('#speclInstct').val(),
                preDt                   : $('#prefInstDt').val(),
                preTm                   : $('#prefInstTm').val()
            },
            rentPaySetVO : {
                bankId                  : vBankID,
                custAccId               : vCustAccID,
                custCrcId               : vCustCRCID,
                custId                  : vCustomerId,
                is3rdParty              : vIs3rdParty,
                issuNric                : vIssuNric,
                modeId                  : $('#rentPayMode').val(),
                nricOld                 : $('#rentPayIC').val().trim(),
            },
            custBillMasterVO : {
                custBillAddId           : $("#hiddenBillAddId").val().trim(),
                custBillCntId           : $("#hiddenCustCntcId").val().trim(),
                custBillCustCareCntId   : $("#hiddenBPCareId").val().trim(),
                custBillCustId          : $('#hiddenCustId').val().trim(),
                custBillEmail           : $('#billMthdEmailTxt1').val().trim(),
                custBillEmailAdd        : $('#billMthdEmailTxt2').val().trim(),
                custBillIsPost          : $('#billMthdPost').is(":checked") ? 1 : 0,
                custBillIsSms           : $('#billMthdSms1').is(":checked") ? 1 : 0,
                custBillIsSms2          : $('#billMthdSms2').is(":checked") ? 1 : 0,
                custBillIsWebPortal     : $('#billGrpWeb').is(":checked")   ? 1 : 0,
                custBillRem             : $('#billRem').val().trim(),
                custBillWebPortalUrl    : $('#billGrpWebUrl').val().trim()
            },
            rentalSchemeVO : {
//              renSchId                : ,
//              isSync                  : ,
//              renSchDt                : ,
//              renSchTerms             : ,
//              salesOrdId              : ,
//              stusCodeId              :
            },
            accClaimAdtVO : {
//              accClSvcCntrctId        :,
                accClBillClmAmt         : $('#ordRentalFees').val().trim(),
                accClClmAmt             : $('#ordRentalFees').val().trim(),
                accClBankAccNo          : vAccNo,
                accClAccTName           : vAccName,
                accClAccNric            : vIssuNric,
                accClPayMode            : vAdtPayMode,
                accClPayModeId          : $('#rentPayMode').val()
            },
            eStatementReqVO : {
                email                   : $('#billMthdEmailTxt1').val().trim(),
                emailAdd                : $('#billMthdEmailTxt2').val().trim()
            },
            /*
            salesOrderLogVO : {
                logId                   : ,
                isLok                   : ,
                logCrtDt                : ,
                logCrtUserId            : ,
                logDt                   : ,
                prgrsId                 : ,
                refId                   : ,
                salesOrdId              :
            },*/
            gSTEURCertificateVO : {
                eurcRefNo               : $('#certRefNo').val().trim(),
                eurcRefDt               : $('#certRefDt').val().trim(),
                eurcCustId              : $('#hiddenCustId').val(),
                eurcCustRgsNo           : $('#txtCertCustRgsNo').val().trim(),
                eurcRem                 : $('#txtCertRemark').val().trim(),
                atchFileGrpId           : $('#atchFileGrpId').val()
            },
            docSubmissionVOList         : GridCommon.getEditData(docGridID)
        };

        Common.ajax("POST", "/sales/order/registerOrder.do", orderVO, function(result) {

            Common.alert("Order Saved" + DEFAULT_DELIMITER + "<b>"+result.message+"</b>",fn_orderRegPopClose());
            
        },  function(jqXHR, textStatus, errorThrown) {
            try {
                console.log("status : " + jqXHR.status);
                console.log("code : " + jqXHR.responseJSON.code);
                console.log("message : " + jqXHR.responseJSON.message);
                console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);

//              Common.alert("Failed To Save" + DEFAULT_DELIMITER + "<b>Failed to save order.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
                Common.alert("Failed To Save" + DEFAULT_DELIMITER + "<b>Failed to save order.</b>");
            }
            catch (e) {
                console.log(e);
//              alert("Saving data prepration failed.");
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
            msg += "* Please select a customer.<br>";
        }

        if($('#appType').val() == '1412' && $('#typeId').val() == '965') {
            isValid = false;
            msg = "* Please select an individual customer<br>(Outright Plus).<br>";
        }

        if($("#empChk option:selected").index() <=0) {
            isValid = false;
            msg = "* Please select an employee.<br>";
        }

        if(!isValid) Common.alert("Save Sales Order Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

        return isValid;
    }

    function fn_validMailAddress() {
        var isValid = true, msg = "";

        if(FormUtil.checkReqValue($('#hiddenBillAddId'))) {
            isValid = false;
            msg += "* Please select an address.";
        }

        if(!isValid) Common.alert("Save Sales Order Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

        return isValid;
    }

    function fn_validContact() {
        var isValid = true, msg = "";

        if(FormUtil.checkReqValue($('#hiddenCustCntcId'))) {
            isValid = false;
            msg += "* Please select a contact person.<br>";
        }

        if(!isValid) Common.alert("Save Sales Order Summary" + DEFAULT_DELIMITER + "<b>"+msg+ "</b>");

        return isValid;
    }

    function fn_validSales() {
        var isValid = true, msg = "";

        var appTypeIdx = $("#appType option:selected").index();
        var appTypeVal = $("#appType").val();

        if(appTypeIdx <= 0) {
            isValid = false;
            msg += "* Please select an application type.<br>";
        }
        else {
            if(appTypeVal == '68' || appTypeVal == '1412') {
                if(FormUtil.checkReqValue($('#installDur'))) {
                    isValid = false;
                    msg += "* Please key in the installment duration.<br>";
                }
            }
/*
            if(appTypeVal == '66' || appTypeVal == '67' || appTypeVal == '68' || appTypeVal == '144' || appTypeVal == '1412') {
                if($("#ordPromo option:selected").index() <= 0) {
                    isValid = false;
                    msg += "* Please select the promotion code.<br>";
                }
            }
*/
            if(appTypeVal == '66' || appTypeVal == '67' || appTypeVal == '68' || appTypeVal == '1412') {
                if(FormUtil.checkReqValue($('#refereNo'))) {
                    isValid = false;
                    msg += "* Please key in the reference no.<br>";
                }
            }
            
            if(fn_isExistESalesNo() == 'true') {
                isValid = false;
                msg += "* this Sales has posted, no amendment allow<br>";
            }
            
            if(appTypeVal == '66') {
                if($(':radio[name="advPay"]:checked').val() != '1' && $(':radio[name="advPay"]:checked').val() != '0') {
                    isValid = false;
                    msg += "* Please select advance rental payment.<br>";
                }
            }
        }

        if($("#ordProudct option:selected").index() <= 0) {
            isValid = false;
            msg += "* Please select a product.<br>";
        }

        if(!FormUtil.checkReqValue($('#hiddenSalesmanId'))) {

            if($('#hiddenSalesmanId').val() == '1' || $('#hiddenSalesmanId').val() == '2') {

                if(appTypeVal == '66' || appTypeVal == '67' || appTypeVal == '68') {

                    if(FormUtil.checkReqValue($('#departCd')) || FormUtil.checkReqValue($('#grpCd')) || FormUtil.checkReqValue($('#orgCd'))) {

                        var memType = $('#hiddenSalesmanTypeId').val() == '1' ? "HP" : "Cody";

                        isValid = false;
                        msg += "* The " + MemType + " department/group/organization code is missing.<br>";
                    }
                }
            }
        }
        else {
            if(appTypeIdx > 0 && appTypeVal != 143) {
                isValid = false;
                msg += "* Please select a salesman.<br>";
            }
        }

        if(!isValid) Common.alert("Save Sales Order Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

        return isValid;
    }

    function fn_isExistESalesNo() {
        var isExist = false, msg = "";

        Common.ajaxSync("GET", "/sales/order/selectExistSofNo.do", {sofNo:$("#refereNo").val(), selType:'2'}, function(rsltInfo) {
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
                    msg += "* Please select the third party.<br>";
                }
            }

            if(rentPayModeIdx <= 0) {
                isValid = false;
                msg += "* Please select the rental paymode.<br>";
            }
            else {
                if(rentPayModeVal == '131') {
                    if(FormUtil.checkReqValue($('#hiddenRentPayCRCId'))) {
                        isValid = false;
                        msg += "* Please select a credit card.<br>";
                    }
                    else if(FormUtil.checkReqValue($('#hiddenRentPayCRCBankId')) || $('#hiddenRentPayCRCBankId').val() == '0') {
                        isValid = false;
                        msg += "* Invalid credit card issue bank.<br>";
                    }
                }
                else if(rentPayModeVal == '132') {
                    if(FormUtil.checkReqValue($('#hiddenRentPayBankAccID'))) {
                        isValid = false;
                        msg += "* Please select a bank account.<br>";
                    }
                    else if(FormUtil.checkReqValue($('#hiddenAccBankId')) || $('#hiddenRentPayCRCBankId').val() == '0') {
                        isValid = false;
                        msg += "* Invalid bank account issue bank.<br>";
                    }
                }
            }
        }

        if(!isValid) Common.alert("Save Sales Order Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

        return isValid;
    }

    function fn_validBillGroup() {
        var isValid = true, msg = "";

        var appTypeIdx  = $("#appType option:selected").index();
        var appTypeVal  = $("#appType").val();
        var grpOptSelYN = (!$('#grpOpt1').is(":checked") && !$('#grpOpt2').is(":checked")) ? false : true;
        var grpOptVal   = $(':radio[name="grpOpt"]:checked').val(); //new, exist

        if(appTypeIdx > 0 && appTypeVal == '66') {

            if(!grpOptSelYN) {
                isValid = false;
                msg += "* Please select the group option.<br>";
            }
            else {

                if(grpOptVal == 'exist') {

                    if(FormUtil.checkReqValue($('#hiddenBillGrpId'))) {
                        isValid = false;
                        msg += "* Please select a billing group.<br>";
                    }
                }
                else {

                    console.log('billMthdSms  checked:' + $("#billMthdSms" ).is(":checked"));
                    console.log('billMthdPost checked:' + $("#billMthdPost" ).is(":checked"));
                    console.log('billMthdEstm checked:' + $("#billMthdEstm" ).is(":checked"));

                    if(!$("#billMthdSms" ).is(":checked") && !$("#billMthdPost" ).is(":checked") && !$("#billMthdEstm" ).is(":checked")) {
                        isValid = false;
                        msg += "* Please select at least one billing method.<br>";
                    }
                    else {
                        if($("#typeId").val() == '965' && $("#billMthdSms" ).is(":checked")) {
                            isValid = false;
                            msg += "* SMS billing method is not allow for company type customer.<br>";
                        }

                        if($("#billMthdEstm" ).is(":checked")) {
                            if(FormUtil.checkReqValue($('#billMthdEmailTxt1'))) {
                                isValid = false;
                                msg += "* Please key in the email address.<br>";
                            }
                            else {
                                if(FormUtil.checkEmail($('#billMthdEmailTxt1').val())) {
                                    isValid = false;
                                    msg += "* Invalid email address.<br>";
                                }
                            }
                            if(!FormUtil.checkReqValue($('#billMthdEmailTxt2')) && FormUtil.checkEmail($('#billMthdEmailTxt2').val())) {
                                isValid = false;
                                msg += "* Invalid email address.<br>";
                            }
                        }
                    }
                }
            }
        }

        if(!isValid) Common.alert("Save Sales Order Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

        return isValid;
    }

    function fn_validInstallation() {
        var isValid = true, msg = "";

        if(FormUtil.checkReqValue($('#hiddenCustAddId'))) {
            isValid = false;
            msg += "* Please select an installation address.<br>";
        }

        if(FormUtil.checkReqValue($('#hiddenInstCntcId'))) {
            isValid = false;
            msg += "* Please select an installation contact person.<br>";
        }

        if($("#dscBrnchId option:selected").index() <= 0) {
            isValid = false;
            msg += "* Please select the DSC branch.<br>";
        }

        if(FormUtil.isEmpty($('#prefInstDt').val().trim())) {
            isValid = false;
            msg += "* Please select prefer install date.<br>";
        }

        if(FormUtil.isEmpty($('#prefInstTm').val().trim())) {
            isValid = false;
            msg += "* Please select prefer install time.<br>";
        }

        if(!$('#pBtnCal').hasClass("blind")) {
            isValid = false;
            msg += "* Please press the Calculation button<br>";
        }
            
        if(!isValid) Common.alert("Save Sales Order Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

        return isValid;
    }

    function fn_validDocument() {
        var isValid = true, msg = "";

        if(!isValid) Common.alert("Save Sales Order Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

        return isValid;
    }

    function fn_validCert() {
        var isValid = true, msg = "";

        console.log('certRefFile'+ $('#certRefFile').val())

        if(!$('#tabRC').hasClass("blind") && !FormUtil.checkReqValue($('#certRefFile'))) {

            if(FormUtil.checkReqValue($('#certRefNo'))) {
                isValid = false;
                msg += "* Please key in the cert reference no.<br>";
            }
            if(FormUtil.isEmpty($('#certRefDt').val().trim())) {
                isValid = false;
                msg += "* Please select the cert reference date.<br>";
            }
        }

        if(!isValid) Common.alert("Save Sales Order Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

        return isValid;
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
            Common.alert("Invalid Bank Account" + DEFAULT_DELIMITER + "<b>Invalid account for auto debit.</b>");
        }
    }
    
    function fn_loadBankAccount(bankAccId) {
        console.log("fn_loadBankAccount START");
        
        Common.ajax("GET", "/sales/order/selectCustomerBankDetailView.do", {getparam : bankAccId}, function(rsltInfo) {

            if(rsltInfo != null) {
                console.log("fn_loadBankAccount Setting");
                
                $("#hiddenRentPayBankAccID").val(rsltInfo.custAccId);
                $("#rentPayBankAccNo").val(rsltInfo.custAccNo);
                $("#rentPayBankAccNoEncrypt").val(rsltInfo.custEncryptAccNo);
                $("#rentPayBankAccType").val(rsltInfo.codeName);
                $("#accName").val(rsltInfo.custAccOwner);
                $("#accBranch").val(rsltInfo.custAccBankBrnch);
                $("#accBank").val(rsltInfo.bankCode + ' - ' + rsltInfo.bankName);
                $("#hiddenAccBankId").val(rsltInfo.custAccBankId);
            }
        });
    }
    
    function fn_loadCreditCard(crcId, custOriCrcNo, custCrcNo, custCrcType, custCrcName, custCrcExpr, custCRCBank, custCrcBankId, crcCardType) {
/*
        console.log(crcId);
        console.log(custOriCrcNo);
        console.log(custCrcNo);
        console.log(custCrcType);
        console.log(custCrcName);
        console.log(custCrcExpr);
        console.log(custCRCBank);
        console.log(custCrcBankId);
        console.log(crcCardType);

        $('#hiddenRentPayCRCId').val(crcId);
        $('#rentPayCRCNo').removeClass("readonly").val(custOriCrcNo);
        $('#hiddenRentPayEncryptCRCNoId').val(custCrcNo);
        $('#rentPayCRCType').removeClass("readonly").val(custCrcType);
        $('#rentPayCRCName').removeClass("readonly").val(custCrcName);
        $('#rentPayCRCExpiry').removeClass("readonly").val(custCrcExpr);
        $('#rentPayCRCBank').removeClass("readonly").val(custCRCBank);
        $('#hiddenRentPayCRCBankId').val(custCrcBankId);
        $('#rentPayCRCCardType').removeClass("readonly").val(crcCardType);
*/
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
        console.log("fn_loadCreditCard START");

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

        console.log('fn_loadOrderSalesman memId:'+memId);
        console.log('fn_loadOrderSalesman memCd:'+memCode);

        fn_clearOrderSalesman();

        Common.ajax("GET", "/sales/order/selectMemberByMemberIDCode.do", {memId : memId, memCode : memCode}, function(memInfo) {

            if(memInfo == null) {
                Common.alert('<b>Member not found.</br>Your input member code : '+memCode+'</b>');
            }
            else {
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
              //$('#salesmanType').removeClass("readonly");
              //$('#salesmanNm').removeClass("readonly");
              //$('#salesmanNric').removeClass("readonly");
                $('#departCd').removeClass("readonly");
                $('#grpCd').removeClass("readonly");
                $('#orgCd').removeClass("readonly");
            }
        });
    }

    function fn_loadTrialNo(trialNo) {

        $('#trialNo').val('');
        $('#trialId').val('');

        if(FormUtil.isNotEmpty(trialNo)) {

            Common.ajax("GET", "/sales/order/selectTrialNo.do", {salesOrdNo : trialNo}, function(trialInfo) {

                if(trialInfo != null) {

                    console.log("성공.");

                    $("#trialId").val(trialInfo.salesOrdId);
                    $("#trialNo").val(trialInfo.salesOrdNo);
                }
            });
        }
    }
    
    function fn_loadPromotionPrice(promoId, stkId) {

        Common.ajax("GET", "/sales/order/selectProductPromotionPriceByPromoStockID.do", {promoId : promoId, stkId : stkId}, function(promoPriceInfo) {

            if(promoPriceInfo != null) {

                console.log("성공.");

//              $("#ordPrice").removeClass("readonly");
//              $("#ordPv").removeClass("readonly");
//              $("#ordRentalFees").removeClass("readonly");

                $("#ordPrice").val(promoPriceInfo.orderPricePromo);
                $("#ordPv").val(promoPriceInfo.orderPVPromo);
                $("#ordPvGST").val(promoPriceInfo.orderPVPromoGST);
                $("#ordRentalFees").val(promoPriceInfo.orderRentalFeesPromo);

                $("#promoDiscPeriodTp").val(promoPriceInfo.promoDiscPeriodTp);
                $("#promoDiscPeriod").val(promoPriceInfo.promoDiscPeriod);
            }
        });
    }

    //LoadProductPromotion
    function fn_loadProductPromotion(appTypeVal, stkId, empChk, custTypeVal, exTrade) {
        console.log('fn_loadProductPromotion --> appTypeVal:'+appTypeVal);
        console.log('fn_loadProductPromotion --> stkId:'+stkId);
        console.log('fn_loadProductPromotion --> empChk:'+empChk);
        console.log('fn_loadProductPromotion --> custTypeVal:'+custTypeVal);

        $('#ordPromo').removeAttr("disabled");

        doGetComboData('/sales/order/selectPromotionByAppTypeStock.do', {appTypeId:appTypeVal,stkId:stkId, empChk:empChk, promoCustType:custTypeVal, exTrade:exTrade, srvPacId:$('#srvPacId').val()}, '', 'ordPromo', 'S', ''); //Common Code
    }

    //LoadProductPrice
    function fn_loadProductPrice(appTypeVal, stkId) {
        console.log('fn_loadProductPrice --> appTypeVal:'+appTypeVal);
        console.log('fn_loadProductPrice --> stkId:'+stkId);

        var appTypeId = 0;

        appTypeId = appTypeVal=='68' ? '67' : appTypeVal;

        $("#searchAppTypeId").val(appTypeId);
        $("#searchStkId").val(stkId);

        Common.ajax("GET", "/sales/order/selectStockPriceJsonInfo.do", {appTypeId : appTypeId, stkId : stkId}, function(stkPriceInfo) {

            if(stkPriceInfo != null) {

                console.log("성공.");

//              $("#ordPrice").removeClass("readonly");
//              $("#ordPv").removeClass("readonly");
//              $("#ordRentalFees").removeClass("readonly");

                $("#ordPrice").val(stkPriceInfo.orderPrice);
                $("#ordPv").val(stkPriceInfo.orderPV);
                $("#ordPvGST").val(stkPriceInfo.orderPV);
                $("#ordRentalFees").val(stkPriceInfo.orderRentalFees);
                $("#ordPriceId").val(stkPriceInfo.priceId);

                $("#orgOrdPrice").val(stkPriceInfo.orderPrice);
                $("#orgOrdPv").val(stkPriceInfo.orderPV);
                $("#orgOrdRentalFees").val(stkPriceInfo.orderRentalFees);
                $("#orgOrdPriceId").val(stkPriceInfo.priceId);
                
                $("#promoDiscPeriodTp").val('');
                $("#promoDiscPeriod").val('');
            }
        });
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
        $('#ordProudct').val('');
        $('#ordPromo').val('');
        $('#relatedNo').val('');
        $('#trialNoChk').prop("checked", false);
        $('#trialNo').val('');
        $('#ordPrice').val('');
        $('#ordPriceId').val('');
        $('#ordPv').val('');
        $('#ordRentalFees').val('');
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
                return false;
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
        if($('#srvPacId option').size() == 2) {
            $('#srvPacId option:eq(1)').attr('selected', 'selected');
            
            var stkType = $("#appType").val() == '66' ? '1' : '2';
            
            doGetComboAndGroup2('/sales/order/selectProductCodeList.do', {stkType:stkType, srvPacId:$('#srvPacId').val()}, '', 'ordProudct', 'S', 'fn_setOptGrpClass');//product 생성
        }
    }
</script>

<div id="popup_wrap" class="popup_wrap">
<!--div id="popup_wrap" class="popup_wrap pop_win"--><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>New Order</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="btnOrdRegClose">CLOSE</a></p></li>
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

</form>
<form id="custForm" name="custForm" action="#" method="post">

<ul class="right_btns mb10">
    <li><p class="btn_grid"><a id="addCustBtn" href="#">Add New Customer</a></p></li>
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
    <th scope="row">Customer ID<span class="must">*</span></th>
    <td><input id="custId" name="custId" type="text" title="" placeholder="Customer ID" class="" /><a class="search_btn" id="custBtn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
    <th scope="row">Type</th>
    <td><input id="custTypeNm" name="custTypeNm" type="text" title="" placeholder="Customer Type" class="w100p" readonly/>
        <input id="typeId" name="typeId" type="hidden"/>
    </td>
</tr>
<tr>
    <th scope="row">Name</th>
    <td><input id="name" name="name" type="text" title="" placeholder="Customer Name" class="w100p" readonly/></td>
    <th scope="row">NRIC/Company No</th>
    <td><input id="nric" name="nric" type="text" title="" placeholder="NRIC/Company No" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row">Nationality</th>
    <td><input id="nationNm" name="nationNm" type="text" title="" placeholder="Nationality" class="w100p" readonly/></td>
    <th scope="row">Race</th>
    <td><input id="race" name="race" type="text" title="" placeholder="Race" class="w100p" readonly/>
        <input id="raceId" name="raceId" type="hidden"/>
    </td>
</tr>
<tr>
    <th scope="row">DOB</th>
    <td><input id="dob" name="dob" type="text" title="" placeholder="DOB" class="w100p" readonly/></td>
    <th scope="row">Gender</th>
    <td><input id="gender" name="gender" type="text" title="" placeholder="Gender" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row">Passport Expiry</th>
    <td><input id="pasSportExpr" name="pasSportExpr" type="text" title="" placeholder="Passport Expiry" class="w100p" readonly/></td>
    <th scope="row">Visa Expiry</th>
    <td><input id="visaExpr" name="visaExpr" type="text" title="" placeholder="Visa Expiry" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row">Email</th>
    <td><input id="email" name="email" type="text" title="" placeholder="Email Address" class="w100p" readonly/></td>
    <th scope="row">Industry Code</th>
    <td><input id="corpTypeNm" name="corpTypeNm" type="text" title="" placeholder="Industry Code" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row">Employee<span class="must">*</span></th>
    <td colspan="3"><select id="empChk" name="empChk" class="w100p"></select></select></td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="3"><textarea  id="custRem" name="custRem" cols="20" rows="5" placeholder="Remark" readonly></textarea></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue"><a id="saveBtn" name="ordSaveBtn" href="#">OK</a></p></li>
</ul>

</form>
</section><!-- search_table end -->

</article><!-- tap_area end -->

<!--****************************************************************************
    Master Contract
*****************************************************************************-->

<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h3>Owner &amp; Purchaser Contact</h3>
</aside><!-- title_line end -->

<ul class="right_btns mb10">
    <li id="liMstCntcNewAddr" class="blind"><p class="btn_grid"><a id="mstCntcNewAddBtn" href="#">Add New Contact</a></p></li>
    <li id="liMstCntcSelAddr" class="blind"><p class="btn_grid"><a id="mstCntcSelAddBtn" href="#">Select Another Contact</a></p></li>
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
    <th scope="row">Initial</th>
    <td><input id="custInitial" name="custInitial" type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Name</th>
    <td><input id="custCntcName" name="custCntcName" type="text" title="" placeholder="" class="w100p" />
        <input id="hiddenCustCntcId" name="custCntcId" type="hidden" /></td>
</tr>
<tr>
    <th scope="row">Tel(Mobile)(1)</th>
    <td><input id="custCntcTelM" name="custCntcTelM" type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Tel(Residence)(1)</th>
    <td><input id="custCntcTelR" name="custCntcTelR" type="text" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Tel(Office)(1)</th>
    <td><input id="custCntcTelO" name="custCntcTelO" type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Ext No.(1)</th>
    <td><input id="custCntcExt" name="custCntcExt" type="text" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Tel(Fax)(1)</th>
    <td><input id="custCntcTelF" name="custCntcTelF" type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Email(1)</th>
    <td><input id="custCntcEmail" name="custCntcEmail" type="text" title="" placeholder="" class="w100p" /></td>
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
    <td colspan="3"><input id="srvCntcName" name="srvCntcName" type="text" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Tel(Mobile)(2)</th>
    <td><input id="srvCntcTelM" name="srvCntcTelM" type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Tel(Residence)(2)</th>
    <td><input id="srvCntcTelR" name="srvCntcTelR" type="text" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Tel(Office)(2)</th>
    <td><input id="srvCntcTelO" name="srvCntcTelO" type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Ext No.(2)</th>
    <td><input id="srvCntcExt" name="srvCntcExt" type="text" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Tel(Fax)(2)</th>
    <td><input id="srvCntcTelF" name="srvCntcTelF" type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Email(2)</th>
    <td><input id="srvCntcEmail" name="srvCntcEmail" type="text" title="" placeholder="" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue"><a name="ordSaveBtn" href="#">OK</a></p></li>
</ul>

</form>
</section><!-- search_table end -->

</article><!-- tap_area end -->

<!--****************************************************************************
    Sales Order
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
    <th scope="row">Application Type<span class="must">*</span></th>
    <td>
    <p><select id="appType" name="appType" class="w100p"></select></p>
    <p><select id="srvPacId" name="srvPacId" class="w100p"></select></p>
    </td>
    <th scope="row">Ex-Trade/Related No</th>
    <td><p><select id="exTrade" name="exTrade" class="w100p"></select></p><p><input id="relatedNo" name="relatedNo" type="text" title="" placeholder="Related Number" class="w100p readonly" readonly /></p>
        <a id="btnRltdNo" href="#" class="search_btn blind"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
</tr>
<tr>
    <th scope="row">Installment Duration<span class="must">*</span></th>
    <td><input id="installDur" name="installDur" type="text" title="" placeholder="Installment Duration (1-36 Months)" class="w100p readonly" readonly/></td>
    <th scope="row">Order Date<span class="must">*</span></th>
    <td>${toDay}</td>
</tr>
<tr>
    <th scope="row">Reference No<span class="must">*</span></th>
    <td><input id="refereNo" name="refereNo" type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Salesman Code<span class="must">*</span></th>
    <td><input id="salesmanCd" name="salesmanCd" type="text" title="" placeholder="" class="" />
        <input id="hiddenSalesmanId" name="salesmanId" type="hidden"  />
        <a id="memBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
</tr>
<tr>
    <th scope="row">PO No<span class="must">*</span></th>
    <td><input id="poNo" name="poNo" type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Salesman Type</th>
    <td><input id="salesmanType" name="salesmanType" type="text" title="" placeholder="Salesman Type" class="w100p readonly" readonly/>
        <input id="hiddenSalesmanTypeId" name="salesmanTypeId" type="hidden" /></td>
</tr>
<tr>
    <th scope="row">Product<span class="must">*</span></th>
    <td><select id="ordProudct" name="ordProudct" class="w100p" disabled></select></td>
    <th scope="row">Salesman Name</th>
    <td><input id="salesmanNm" name="salesmanNm" type="text" title="" placeholder="Salesman Name" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Promotion</th>
    <td>
    <select id="ordPromo" name="ordPromo" class="w100p" disabled></select>
    <input id="txtOldOrderID" name="txtOldOrderID" type="hidden" />
    </td>
    <th scope="row">Salesman NRIC</th>
    <td><input id="salesmanNric" name="salesmanNric" type="text" title="" placeholder="Salesman NRIC" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Price/RPF (RM)</th>
    <td><input id="ordPrice"    name="ordPrice"    type="text" title="" placeholder="Price/Rental Processing Fees (RPF)" class="w100p readonly" readonly />
        <input id="ordPriceId"  name="ordPriceId"  type="hidden" />
        <input id="orgOrdPrice" name="orgOrdPrice" type="hidden" />
        <input id="orgOrdPv"    name="orgOrdPv"    type="hidden" /></td>
    <th scope="row">Department Code</th>
    <td><input id="departCd"    name="departCd"    type="text" title="" placeholder="Department Code" class="w100p readonly" readonly />
        <input id="departMemId" name="departMemId" type="hidden" /></td>
</tr>
<tr>
    <th scope="row">Normal Rental Fees (RM)</th>
    <td><input id="orgOrdRentalFees" name="orgOrdRentalFees" type="text" title="" placeholder="Rental Fees (Monthly)" class="w100p readonly" readonly /></td>
    <th scope="row">Group Code</th>
    <td><input id="grpCd" name="grpCd" type="text" title="" placeholder="Group Code" class="w100p readonly" readonly />
        <input id="grpMemId" name="grpMemId" type="hidden" /></td>
</tr>
<tr>
    <th scope="row">Discount Period/<br>Final Rental Fee</th>
    <td><p><select id="promoDiscPeriodTp" name="promoDiscPeriodTp" class="w100p" disabled></select></p>
        <p><input id="promoDiscPeriod" name="promoDiscPeriod" type="text" title="" placeholder="" style="width:42px;" class="readonly" readonly/></p>
        <p><input id="ordRentalFees" name="ordRentalFees" type="text" title="" placeholder="" style="width:90px;"  class="readonly" readonly/></p></td>
    <th scope="row">Organization Code</th>
    <td><input id="orgCd" name="orgCd" type="text" title="" placeholder="Organization Code" class="w100p readonly" readonly />
        <input id="orgMemId" name="orgMemId" type="hidden" /></td>
</tr>
<tr>
    <th scope="row">PV</th>
    <td><input id="ordPv"    name="ordPv"    type="text" title="" placeholder="Point Value (PV)" class="w100p readonly" readonly />
        <input id="ordPvGST" name="ordPvGST" type="hidden" /></td>
    <th scope="row">Trial No</th>
    <td><label><input id="trialNoChk" name="trialNoChk" type="checkbox" disabled/><span></span></label>
               <input id="trialNo" name="trialNo" type="text" title="" placeholder="Trial No" style="width:210px;" class="readonly" readonly />
               <input id="trialId" name="trialId" type="hidden" />
               <a id="trialNoBtn" name="trialNoBtn" href="#" class="search_btn blind"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="3"><textarea  id="ordRem" name="ordRem" cols="20" rows="5" placeholder="Remark"></textarea></td>
</tr>
<tr>
    <th scope="row">Advance Rental Payment<span class="must">*</span></th>
    <td colspan="3"><span>Does customer make advance rental payment for 6 months and above?</span>
        <input id="advPayYes" name="advPay" type="radio" value="1" disabled/><span>Yes</span>
        <input id="advPayNo" name="advPay" type="radio" value="0" disabled/><span>No</span></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue"><a name="ordSaveBtn" href="#">OK</a></p></li>
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
    <th scope="row">Pay By Third Party</th>
    <td colspan="3">
    <label><input id="thrdParty" name="thrdParty" type="checkbox" value="1"/><span></span></label>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<section id="sctThrdParty" class="blind">

<aside class="title_line"><!-- title_line start -->
<h3>Third Party</h3>
</aside><!-- title_line end -->

<ul class="right_btns mb10">
    <li><p class="btn_grid"><a id="thrdPartyAddCustBtn" href="#">Add New Third Party</a></p></li>
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
    <th scope="row">Customer ID<span class="must">*</span></th>
    <td><input id="thrdPartyId" name="thrdPartyId" type="text" title="" placeholder="Third Party ID" class="" />
        <a href="#" class="search_btn" id="thrdPartyBtn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
        <input id="hiddenThrdPartyId" name="hiddenThrdPartyId" type="hidden" title="" placeholder="Third Party ID" class="" /></td>
    <th scope="row">Type</th>
    <td><input id="thrdPartyType" name="thrdPartyType" type="text" title="" placeholder="Costomer Type" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Name</th>
    <td><input id="thrdPartyName" name="thrdPartyName" type="text" title="" placeholder="Customer Name" class="w100p readonly" readonly/></td>
    <th scope="row">NRIC/Company No</th>
    <td><input id="thrdPartyNric" name="thrdPartyNric" type="text" title="" placeholder="NRIC/Company Number" class="w100p readonly" readonly/></td>
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
    <th scope="row">Rental Paymode<span class="must">*</span></th>
    <td>
    <select id="rentPayMode" name="rentPayMode" class="w100p"></select>
    </td>
    <th scope="row">NRIC on DD/Passbook</th>
    <td><input id="rentPayIC" name="rentPayIC" type="text" title="" placeholder="NRIC appear on DD/Passbook" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->
</form>

</section>

<section id="sctCrCard" class="blind">

<aside class="title_line"><!-- title_line start -->
<h3>Credit Card</h3>
</aside><!-- title_line end -->

<ul class="right_btns mb10">
    <li><p class="btn_grid"><a id="addCreditCardBtn" href="#">Add New Credit Card</a></p></li>
    <li><p class="btn_grid"><a id="selCreditCardBtn" href="#">Select Another Credit Card</a></p></li>
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
    <th scope="row">Credit Card Number<span class="must">*</span></th>
    <td><input id="rentPayCRCNo" name="rentPayCRCNo" type="text" title="" placeholder="Credit Card Number" class="w100p readonly" readonly/>
        <input id="hiddenRentPayCRCId" name="rentPayCRCId" type="hidden" />
        <input id="hiddenRentPayEncryptCRCNoId" name="hiddenRentPayEncryptCRCNoId" type="hidden" /></td>
    <th scope="row">Credit Card Type</th>
    <td><input id="rentPayCRCType" name="rentPayCRCType" type="text" title="" placeholder="Credit Card Type" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Name On Card</th>
    <td><input id="rentPayCRCName" name="rentPayCRCName" type="text" title="" placeholder="Name On Card" class="w100p readonly" readonly/></td>
    <th scope="row">Expiry</th>
    <td><input id="rentPayCRCExpiry" name="rentPayCRCExpiry" type="text" title="" placeholder="Credit Card Expiry" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Issue Bank</th>
    <td><input id="rentPayCRCBank" name="rentPayCRCBank" type="text" title="" placeholder="Issue Bank" class="w100p readonly" readonly/>
        <input id="hiddenRentPayCRCBankId" name="rentPayCRCBankId" type="hidden" title="" class="w100p" /></td>
    <th scope="row">Card Type</th>
    <td><input id="rentPayCRCCardType" name="rentPayCRCCardType" type="text" title="" placeholder="Card Type" class="w100p readonly" readonly/></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue"><a name="ordSaveBtn" href="#">OK</a></p></li>
</ul>
</form>
</section>

<section id="sctDirectDebit" class="blind">

<aside class="title_line"><!-- title_line start -->
<h3>Direct Debit</h3>
</aside><!-- title_line end -->

<ul class="right_btns mb10">
    <li><p class="btn_grid"><a id="btnAddBankAccount" href="#">Add New Bank Account</a></p></li>
    <li><p class="btn_grid"><a id="btnSelBankAccount" href="#">Select Another Bank Account</a></p></li>
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
    <th scope="row">Account Number<span class="must">*</span></th>
    <td><input id="rentPayBankAccNo" name="rentPayBankAccNo" type="text" title="" placeholder="Account Number readonly" class="w100p readonly" readonly/>
        <input id="hiddenRentPayBankAccID" name="hiddenRentPayBankAccID" type="hidden" /></td>
    <th scope="row">Account Type</th>
    <td><input id="rentPayBankAccType" name="rentPayBankAccType" type="text" title="" placeholder="Account Type readonly" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Account Holder</th>
    <td><input id="accName" name="accName" type="text" title="" placeholder="Account Holder" class="w100p readonly" readonly/></td>
    <th scope="row">Issue Bank Branch</th>
    <td><input id="accBranch" name="accBranch" type="text" title="" placeholder="Issue Bank Branch" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Issue Bank</th>
    <td colspan=3><input id="accBank" name="accBank" type="text" title="" placeholder="Issue Bank" class="w100p readonly" readonly/>
        <input id="hiddenAccBankId" name="hiddenAccBankId" type="hidden" /></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue"><a name="ordSaveBtn" href="#">OK</a></p></li>
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
    <th scope="row">Group Option<span class="must">*</span></th>
    <td>
    <label><input type="radio" id="grpOpt1" name="grpOpt" value="new"  /><span>New Billing Group</span></label>
    <label><input type="radio" id="grpOpt2" name="grpOpt" value="exist"/><span>Existion Billing Group</span></label>
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
    <th scope="row" rowspan="5">Billing Method<span class="must">*</span></th>
    <td colspan="3">
    <label><input id="billMthdPost" name="billMthdPost" type="checkbox" /><span>Post</span></label>
    </td>
</tr>
<tr>
    <td colspan="3">
    <label><input id="billMthdSms" name="billMthdSms" type="checkbox" /><span>SMS</span></label>
    <label><input id="billMthdSms1" name="billMthdSms1" type="checkbox" disabled/><span>Mobile 1</span></label>
    <label><input id="billMthdSms2" name="billMthdSms2" type="checkbox" disabled/><span>Mobile 2</span></label>
    </td>
</tr>
<tr>
    <td>
    <label><input id="billMthdEstm" name="billMthdEstm" type="checkbox" /><span>E-Billing</span></label>
    <label><input id="billMthdEmail1" name="billMthdEmail1" type="checkbox" disabled/><span>Email 1</span></label>
    <label><input id="billMthdEmail2" name="billMthdEmail2" type="checkbox" disabled/><span>Email 2</span></label>
    </td>
    <th scope="row">Email(1)<span id="spEmail1" class="must">*</span></th>
    <td><input id="billMthdEmailTxt1" name="billMthdEmailTxt1" type="text" title="" placeholder="Email Address" class="w100p" disabled/></td>
</tr>
<tr>
    <td></td>
    <th scope="row">Email(2)</th>
    <td><input id="billMthdEmailTxt2" name="billMthdEmailTxt2" type="text" title="" placeholder="Email Address" class="w100p" disabled/></td>
</tr>
<tr>
    <td>
    <label><input id="billGrpWeb" name="billGrpWeb" type="checkbox" /><span>Web Portal</span></label>
    </td>
    <th scope="row">Web address(URL)</th>
    <td><input id="billGrpWebUrl" name="billGrpWebUrl" type="text" title="" placeholder="Web Address" class="w100p" /></td>
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
<h3>Billing Address</h3>
</aside><!-- title_line end -->

<ul class="right_btns mb10">
    <li id="liBillNewAddr" class="blind"><p class="btn_grid"><a id="billNewAddrBtn" href="#">Add New Address</a></p></li>
    <li id="liBillSelAddr" class="blind"><p class="btn_grid"><a id="billSelAddrBtn" href="#">Select Another Address</a></p></li>
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
    <th scope="row">Address Detail<span class="must">*</span></th>
    <td colspan="3">
    <input id="billAddrDtl" name="billAddrDtl" type="text" title="" placeholder="Address Detail" class="w100p readonly" readonly/>
    </td>
</tr>
<tr>
    <th scope="row">Street</th>
    <td colspan="3">
    <input id="billStreet" name="billStreet" type="text" title="" placeholder="Street" class="w100p readonly" readonly/>
    </td>
</tr>
<tr>
    <th scope="row">Area<span class="must">*</span></th>
    <td colspan="3">
    <input id="billArea" name="billArea" type="text" title="" placeholder="Area" class="w100p readonly" readonly/>
    </td>
</tr>
<tr>
    <th scope="row">City<span class="must">*</span></th>
    <td>
    <input id="billCity" name="billCity" type="text" title="" placeholder="City" class="w100p readonly" readonly/>
    </td>
    <th scope="row">PostCode<span class="must">*</span></th>
    <td>
    <input id="billPostCode" name="billPostCode" type="text" title="" placeholder="Postcode" class="w100p readonly" readonly/>
    </td>
</tr>
<tr>
    <th scope="row">State<span class="must">*</span></th>
    <td>
    <input id="billState" name="billState" type="text" title="" placeholder="State" class="w100p readonly" readonly/>
    </td>
    <th scope="row">Country<span class="must">*</span></th>
    <td>
    <input id="billCountry" name="billCountry" type="text" title="" placeholder="Country" class="w100p readonly" readonly/>
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
<h3>Billing Preference</h3>
</aside><!-- title_line end -->

<ul class="right_btns mb10">
    <li id="liBillPreferNewAddr" class="blind"><p class="btn_grid"><a id="billPreferAddAddrBtn" href="#">Add New Contact</a></p></li>
    <li id="liBillPreferSelAddr" class="blind"><p class="btn_grid"><a id="billPreferSelAddrBtn" href="#">Select Another Contact</a></p></li>
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
    <th scope="row">Initials<span class="must">*</span></th>
    <td colspan="3"><select id="billPreferInitial" name="billPreferInitial" class="w100p"></select>
        </td>
</tr>
<tr>
    <th scope="row">Name<span class="must">*</span></th>
    <td colspan="3"><input id="billPreferName" name="billPreferName" type="text" title="" placeholder="Name" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row">Tel(Office)<span class="must">*</span></th>
    <td><input id="billPreferTelO" name="billPreferTelO" type="text" title="" placeholder="Tel(Office)" class="w100p" readonly/></td>
    <th scope="row">Ext No.<span class="must">*</span></th>
    <td><input id="billPreferExt" name="billPreferExt" type="text" title="" placeholder="Ext No." class="w100p" readonly/></td>
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
<h3>Billing Group Selection</h3>
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
    <th scope="row">Billing Group<span class="must">*</span></th>
    <td><input id="billGrp" name="billGrp" type="text" title="" placeholder="Billing Group" class="readonly" readonly/><a id="billGrpBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
        <input id="hiddenBillGrpId" name="billGrpId" type="hidden" /></td>
    <th scope="row">Billing Type<span class="must">*</span></th>
    <td><input id="billType" name="billType" type="text" title="" placeholder="Billing Type" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Billing Address</th>
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
    <th scope="row">Remark</th>
    <td><textarea id="billRem" name="billRem" cols="20" rows="5" readonly></textarea></td>
</tr>
</tbody>
</table><!-- table end -->
<!-- Existing Type end -->

<ul class="center_btns">
    <li><p class="btn_blue"><a name="ordSaveBtn" href="#">OK</a></p></li>
</ul>

</section><!-- search_table end -->

</article><!-- tap_area end -->

<!--****************************************************************************
    Installation
*****************************************************************************-->
<article class="tap_area"><!-- tap_area start -->

<section class="search_table"><!-- search_table start -->

<aside class="title_line"><!-- title_line start -->
<h3>Installation Address</h3>
</aside><!-- title_line end -->

<ul class="right_btns mb10">
    <li id="liInstNewAddr" class="blind"><p class="btn_grid"><a id="instNewAddrBtn" href="#">Add New Address</a></p></li>
    <li id="liInstSelAddr" class="blind"><p class="btn_grid"><a id="instSelAddrBtn" href="#">Select Another Address</a></p></li>
</ul>

<!------------------------------------------------------------------------------
    Installation Address - Form ID(instAddrForm)
------------------------------------------------------------------------------->
<form id="instAddrForm" name="instAddrForm" action="#" method="post">
    <input id="hiddenCustAddId" name="custAddId" type="hidden"/>

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
    <th scope="row">Address Detail<span class="must">*</span></th>
    <td colspan="3"><input id="instAddrDtl" name="instAddrDtl" type="text" title="" placeholder="Address Detail" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Street<span class="must">*</span></th>
    <td colspan="3"><input id="instStreet" name="instStreet" type="text" title="" placeholder="Street" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Area<span class="must">*</span></th>
    <td colspan="3"><input id="instArea" name="instArea" type="text" title="" placeholder="Area" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">City<span class="must">*</span></th>
    <td>
    <input id="instCity" name="instCity" type="text" title="" placeholder="City" class="w100p readonly" readonly/>
    </td>
    <th scope="row">PostCode<span class="must">*</span></th>
    <td>
    <input id="instPostCode" name="instPostCode" type="text" title="" placeholder="Post Code" class="w100p readonly" readonly/>
    </td>
</tr>
<tr>
    <th scope="row">State<span class="must">*</span></th>
    <td>
    <input id="instState" name="instState" type="text" title="" placeholder="State" class="w100p readonly" readonly/>
    </td>
    <th scope="row">Country<span class="must">*</span></th>
    <td>
    <input id="instCountry" name="instCountry" type="text" title="" placeholder="Country" class="w100p readonly" readonly/>
    </td>
</tr>

</tbody>
</table><!-- table end -->
</form>

<section id="tbInstCntcPerson" class="blind">

<aside class="title_line"><!-- title_line start -->
<h3>Installation Contact Person</h3>
</aside><!-- title_line end -->

<ul class="right_btns mb10">
    <li id="liInstNewAddr2" class="blind"><p class="btn_grid"><a href="#">Add New Address</a></p></li>
    <li id="liInstSelAddr2" class="blind"><p class="btn_grid"><a href="#">Select Another Address</a></p></li>
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
    <th scope="row">Name<span class="must">*</span></th>
    <td><input id="instCntcName" name="instCntcName" type="text" title="" placeholder="" class="w100p" readonly/></td>
    <th scope="row">Initial</th>
    <td><input id="instInitial" name="instInitial" type="text" title="" placeholder="" class="w100p" readonly/></td>
    <th scope="row">Gender</th>
    <td><input id="instGender" name="instGender" type="text" title="" placeholder="" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row">NRIC</th>
    <td><input id="instNric" name="instNric" type="text" title="" placeholder="" class="w100p" readonly/></td>
    <th scope="row">DOB</th>
    <td><input id="instDob" name="instDob" type="text" title="" placeholder="" class="w100p" readonly/></td>
    <th scope="row">Race</th>
    <td><input id="instRaceId" name="instRaceId" type="text" title="" placeholder="" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row">Email</th>
    <td><input id="instCntcEmail" name="instCntcEmail" type="text" title="" placeholder="" class="w100p" readonly/></td>
    <th scope="row">Department</th>
    <td><input id="instDept" name="instDept" type="text" title="" placeholder="" class="w100p" readonly/></td>
    <th scope="row">Post</th>
    <td><input id="instPost" name="instPost" type="text" title="" placeholder="" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row">Tel(Mobile)</th>
    <td><input id="instCntcTelM" name="instCntcTelM" type="text" title="" placeholder="" class="w100p" readonly/></td>
    <th scope="row">Tel(Residence)</th>
    <td><input id="instCntcTelR" name="instCntcTelR" type="text" title="" placeholder="" class="w100p" readonly/></td>
    <th scope="row">Tel(Office)</th>
    <td><input id="instCntcTelO" name="instCntcTelO" type="text" title="" placeholder="" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row">Tel(Fax)</th>
    <td><input id="instCntcTelF" name="instCntcTelF" type="text" title="" placeholder="" class="w100p" readonly/></td>
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
<h3>Installation Information</h3>
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
    <th scope="row">Zero GST<span class="must">*</span></th>
    <td>
    <p><select id="gstChk" name="gstChk" class="w100p"></select></p>
    <p id="pBtnCal" class="btn_sky blind"><a id="btnCal" href="#">Calculation</a></p>
    </td>
    <th scope="row">DSC Branch<span class="must">*</span></th>
    <td>
    <select id="dscBrnchId" name="dscBrnchId" class="w100p" disabled></select>
    </td>
</tr>
<tr>
    <th scope="row">Prefer Install Date<span class="must">*</span></th>
    <td><input id="prefInstDt" name="prefInstDt" type="text" title="Create start Date" placeholder="Prefer Install Date (dd/MM/yyyy)" class="j_date w100p" /></td>
    <th scope="row">Prefer Install Time<span class="must">*</span></th>
    <td>
    <div class="time_picker"><!-- time_picker start -->
    <input id="prefInstTm" name="prefInstTm" type="text" title="" placeholder="Prefer Install Time (hh:mi tt)" class="time_date w100p" />
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
    <th scope="row">Special Instruction<span class="must">*</span></th>
    <td colspan="3"><textarea id="speclInstct" name="speclInstct" cols="20" rows="5"></textarea></td>
</tr>
</tbody>
</table><!-- table end -->

<!-- Existing Type end -->

<ul class="center_btns">
    <li><p class="btn_blue"><a name="ordSaveBtn" href="#">OK</a></p></li>
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
    <li><p class="btn_blue"><a name="ordSaveBtn" href="#">OK</a></p></li>
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
    <th scope="row">Reference No<span class="must">*</span></th>
    <td><input id="certRefNo" name="certRefNo" type="text" title="" placeholder="Cert Reference No" class="w100p" /></td>
    <th scope="row">Certificate Date<span class="must">*</span></th>
    <td><input id="certRefDt" name="certRefDt" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" /></td>
</tr>
<tr>
    <th scope="row">GST Registration No</th>
    <td colspan="3"><input id="txtCertCustRgsNo" name="txtCertCustRgsNo" type="text" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="3"><textarea id="txtCertRemark" name="txtCertRemark" cols="20" rows="5"></textarea></td>
</tr>
<tr>
    <th scope="row">Upload Relief Cert(.zip)</th>
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
    <li><span class="red_text">**</span> <span class="brown_text">This section is ONLY applicable to Federal Government, State Government, Palace of Ruler and other organisations which were given GST relief for purchase of goods at GST rate of 0%.</span></li>
</ul>

<ul class="center_btns">
    <li><p class="btn_blue"><a name="ordSaveBtn" href="#">OK</a></p></li>
</ul>

</form>
</section><!-- search_table end -->

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->