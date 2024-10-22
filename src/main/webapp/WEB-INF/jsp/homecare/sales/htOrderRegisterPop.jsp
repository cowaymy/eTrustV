<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ include file="/WEB-INF/jsp/sales/order/convertToOrderInc.jsp" %>
<%@ include file="/WEB-INF/jsp/sales/order/copyChangeOrderInc.jsp" %>

<script type="text/javaScript" language="javascript">

    var convToOrdYn  = "${CONV_TO_ORD_YN}";
    var copyChangeYn = "${COPY_CHANGE_YN}";
    var bulkOrderYn  = "${BULK_ORDER_YN}";

    var docGridID;
    var docDefaultChk = false;
    var GST_CHK = '';
    var GST_MANNUAL = 'N';
    var ROLE_ID = "${SESSION_INFO.roleId}";
    var freeTrialAuth = "${PAGE_AUTH.funcUserDefine5}";

    $(document).ready(function(){

        createAUIGrid();

        fn_selectDocSubmissionList();

        //doGetComboOrder('/common/selectCodeList.do', '10', 'CODE_ID',   '', 'appType',     'S', ''); //Common Code

       /*  if(ROLE_ID == "341" || ROLE_ID == "342" || ROLE_ID == "343" || ROLE_ID == "344" || ROLE_ID == "130" ||
           ROLE_ID == "99" || ROLE_ID == "97" || ROLE_ID == "103" || ROLE_ID == "104" || ROLE_ID == "105" || // SO Admin
           ROLE_ID == "177" || ROLE_ID == "179" || ROLE_ID == "180" || ROLE_ID == "250" || ROLE_ID == "256" || // CDB Admin
           ROLE_ID == "253" || ROLE_ID == "256"// CODY Planning (current Service Innovative dept) -- by Hui Ding, 28/05/2021.
        ) {
        CommonCombo.make("appType", "/homecare/sales/selectCodeList.do", {groupCode : '10', codeIn : 'CS1T,CS1Y,FT1T,FT1Y'}, "", {
            id: "codeId",
            name: "codeName",
            type:"S"
        });
        }else{
        	  CommonCombo.make("appType", "/homecare/sales/selectCodeList.do", {groupCode : '10', codeIn : 'CS1T,CS1Y'}, "", {
                  id: "codeId",
                  name: "codeName",
                  type:"S"
        	  });
        } */ // NO LONGER USING

        var codeInList;


        if ('${FREE_TRIAL_AUTH}' == 'Y'){
        	console.log("allow to add Free Trial app type.");
        	codeInList = 'CS1T,CS1Y,FT1T,FT1Y';
        } else {
        	codeInList = 'CS1T,CS1Y';
        }

        CommonCombo.make("serviceType", "/common/selectServiceTypeList.do", {groupCode : '514'}, "", {
            id: "codeId",
            name: "codeName",
            type:"S"
        });

        CommonCombo.make("appType", "/homecare/sales/selectCodeList.do", {groupCode : '10', codeIn : codeInList}, "", {
            id: "codeId",
            name: "codeName",
            type:"S"
        });
        $('#ordProductLbl1').hide();
        $('#ordProductLbl2').hide();
        $('#ordUnitTypeboard').hide();
        $('#ordUnitTypeLbl').hide();
        $('#ordUnitType').hide();
        //doGetComboOrder('/common/selectCodeList.do', '19', 'CODE_NAME', '', 'rentPayMode', 'S', ''); //Common Code
        doGetComboOrder('/common/selectCodeList.do', '17', 'CODE_NAME', '', 'billPreferInitial', 'S', ''); //Common Code
        //doGetComboSepa ('/common/selectBranchCodeList.do', '5',  ' - ', '', 'dscBrnchId',  'S', ''); //Branch Code

        doGetComboData('/common/selectCodeList.do', {groupCode :'324'}, '',  'empChk',  'S'); //EMP_CHK
        //doGetComboData('/common/selectCodeList.do', {groupCode :'325',orderValue : 'CODE_ID'}, '0', 'exTrade', 'S'); //EX-TRADE
        //doGetComboData('/common/selectCodeList.do', {groupCode :'326'}, '0', 'gstChk',  'S'); //GST_CHK
        doGetComboOrder('/common/selectCodeList.do', '322', 'CODE_ID', '', 'promoDiscPeriodTp', 'S'); //Discount period

        //Payment Channel, Billing Detail TAB Visible False처리
       // fn_tabOnOffSet('PAY_CHA', 'HIDE');
      //fn_tabOnOffSet('BIL_DTL', 'HIDE'); //2018.01.01
        fn_tabOnOffSet('REL_CER', 'HIDE');

        //Attach File
        $(".auto_file").append("<label><span class='label_text'><a href='#'>File</a></span><input type='text' class='input_text' readonly='readonly' /></label>");


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
                dataField   : "typeDesc",   headerText  : '<spring:message code="sal.title.text.document" />',
                editable    : false,        style       : 'left_style'
            }, {
                dataField   : "codeId",     visible     : false
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
        Common.ajax("GET", "/homecare/sales/selectDocSubmissionList.do", {typeCodeId : '248'}, function(result) {
            AUIGrid.setGridData(docGridID, result);
        });
    }





    function fn_loadCustomer(custId){

        $("#searchCustId").val(custId);

        Common.ajax("GET", "/sales/customer/selectCustomerJsonList", {custId : custId}, function(result) {

            if(result != null && result.length == 1) {

              //fn_tabOnOffSet('BIL_DTL', 'SHOW'); //2018.01.01

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

                fn_checkPostCodeCoverage(custInfo.custId);

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
            }
            else {
//              Common.alert('<b>Customer not found.<br>Your input customer ID :'+$("#searchCustId").val()+'</b>');
                Common.alert('<spring:message code="sal.alert.msg.custNotFound" arguments="'+custId+'"/>');
            }
        });
    }

    function fn_checkPostCodeCoverage(custId){
        console.log("fn_checkPostCodeCoverage START");
       Common.ajax("GET", "/homecare/sales/selectHTCovergPostCode.do", {custId : custId}, function(postCodeInfo) {

           console.log("fn_checkPostCodeCoverage START : " + postCodeInfo);
              if(postCodeInfo != null){

              }else{
                  Common.alert('<b>* Post Code not in Care Service coverage area.<br />' , fn_clearAllForm() );
                  return false;
              }
       });
   }




    function fn_loadMailAddr(custAddId){
        console.log("fn_loadMailAddr START");

        Common.ajax("GET", "/homecare/sales/selectCustAddJsonInfo.do", {custAddId : custAddId}, function(billCustInfo) {

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

        Common.ajaxSync("GET", "/homecare/sales/selectCustAddJsonInfo.do", {custAddId : custAddId}, function(custInfo) {

            if(custInfo != null) {

                console.log("성공.");
                console.log("gstChk : " + custInfo.gstChk);


                if(custInfo.areaId != undefined){
                    console.log("custInfo.areaId.substring(0,2):"+custInfo.areaId.substring(0,2));
                    if("DM" == custInfo.areaId.substring(0,2)) {
                        Common.alert('<spring:message code="sal.alert.msg.invalidAddr" />' + DEFAULT_DELIMITER + '<spring:message code="sal.alert.msg.oldAddrNewAddr" />');

                        $("#validAreaIdYN").val("N");
                    }
                    else {
                        $("#validAreaIdYN").val("Y");
                    }
                }else{
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

                console.log('GST_CHK:'+GST_CHK);

                if($("#appType").val() == '66') {
                    $("#gstChk").removeAttr("disabled");
                }
                else if($("#appType").val() != '' && $("#appType").val() != '66'){

                    var appTypeVal = $("#appType").val();
                    var stkIdVal   = $("#ordProudct").val();
                    var promoIdVal = $("#ordPromo").val();

                    var srvPacId = 0;


                    fn_loadProductPrice(appTypeVal, stkIdVal);
                    if(FormUtil.isNotEmpty(promoIdVal)) {
                        fn_loadPromotionPrice(promoIdVal);
                    }

                }
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

        Common.ajax("GET", "/homecare/sales/selectSrvCntcJsonInfo.do", {custCareCntId : custCareCntId}, function(srvCntcInfo) {

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

        Common.ajax("GET", "/homecare/sales/selectCustCntcJsonInfo.do", {custCntcId : custCntcId}, function(custCntcInfo) {

            if(custCntcInfo != null) {
                console.log('custCntcInfo.custCntcId:'+custCntcInfo.custCntcId);
                //
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
        console.log("fn_loadInstallationCntcPerson START :custCntcId:"+custCntcId);

        $("#searchCustCntcId").val(custCntcId);

        Common.ajax("GET", "/homecare/sales/selectCustCntcJsonInfo.do", {custCntcId : custCntcId}, function(instCntcInfo) {

            if(instCntcInfo != null) {

                console.log("fn_loadInstallationCntcPerson hiddenInstCntcId:"+instCntcInfo.custCntcId);
                console.log("fn_loadInstallationCntcPerson instCntcName    :"+instCntcInfo.name);
                console.log("fn_loadInstallationCntcPerson instInitial     :"+instCntcInfo.custInitial);
                console.log("fn_loadInstallationCntcPerson instCntcEmail   :"+instCntcInfo.email);

                //$("#hiddenInstCntcId").val(instCntcInfo.custCntcId);
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



    function fn_loadBillingPreference(custCareCntId) {

        Common.ajax("GET", "/homecare/sales/selectSrvCntcJsonInfo.do", {custCareCntId : custCareCntId}, function(srvCntcInfo) {

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
/*         $('#btnRltdNo').click(function() {
            Common.popupDiv("/sales/order/prevOrderNoPop.do", {custId : $('#hiddenCustId').val()}, null, true);
        }); */
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
            //Common.popupDiv("/sales/customer/customerCreditCardAddPop.do", {custId : vCustId, callPrgm : "ORD_REGISTER_PAYM_CRC", nric : $('#nric').val()}, null, true);
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



        $('#salesmanCd').keydown(function (event) {
            if (event.which === 13) {    //enter
                var memCd = $('#salesmanCd').val().trim();

                if(FormUtil.isNotEmpty(memCd)) {
                    fn_loadOrderSalesman(0, memCd);
                }
                return false;
            }
        });


        $('#appType').change(function() {

           //Clear Care Service Order
            fn_clearSales();

            $('span', '#refereNoLbl').empty().remove();
            $('span', '#ordPromoLbl').empty().remove();
            $('span', '#ordProductLbl').empty().remove();
            $('span', '#salesmanCdLbl').empty().remove();


            var appTypeIdx = $("#appType option:selected").index();
            console.log('appTypeIdx : ' + appTypeIdx);

            if( appTypeIdx == 2 ){
            	$('#ordQuantity').val("1");
                  $('#ordQuantity').removeAttr("disabled");
                  $("#refereNoLbl").append("<span class='must'>*</span>");
                  $("#ordPromoLbl").append("<span class='must'>*</span>");
                  $("#ordProductLbl").append("<span class='must'>*</span>");
                  $("#salesmanCdLbl").append("<span class='must'>*</span>");
            }
            else if(appTypeIdx == 1 ){
            	$('#ordQuantity').val("1");
            	$('#ordQuantity').prop("disabled", true);
                $("#refereNoLbl").append("<span class='must'>*</span>");
                $("#ordPromoLbl").append("<span class='must'>*</span>");
                $("#ordProductLbl").append("<span class='must'>*</span>");
                $("#salesmanCdLbl").append("<span class='must'>*</span>");
            }
            else{
                 $('#ordQuantity').prop("disabled", true);
                 $("#refereNoLbl").find("span").remove();
                 $("#ordPromoLbl").find("span").remove();
                 $("#ordProductLbl").append("<span class='must'>*</span>");
                 //$("#ordProductLbl").find("span").remove();
                 $("#salesmanCdLbl").find("span").remove();
            }

        });

        $('#ordQuantity').change(function() {

            //Clear Care Service Order
            $('#installDur').val('');
            $('#ordProudct').val('0');
            $('#ordPromo').val('');
            $('#relatedNo').val('');
            $('#trialNoChk').prop("checked", false);
            $('#trialNo').val('');
            $('#ordPrice').val('');
            $('#ordPriceId').val('');
            $('#ordPv').val('');
            $('#ordRentalFees').val('');
            $('#orgOrdRentalFees').val('');
            $('#brandType').val('0');

         });


        $('#ordProudct').change(function() {
        	 //Common.alert("Product value : "+ $('#ordProudct').val());
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
            var srvPacId = 0;

            var promoAppTypeId = 0;

            if (appTypeVal == 3216){

            	 promoAppTypeId = 3220;

            }else if (appTypeVal == 3217){

            	promoAppTypeId = 3221;

            }else{

            	promoAppTypeId = 0;

            }


            console.log('app type change --> appTypeVal:'+appTypeVal);
            console.log('promo change --> promoAppTypeId:'+promoAppTypeId);

                fn_loadProductPrice(appTypeVal, stkIdVal);
                fn_loadProductPromotion(promoAppTypeId, stkIdVal, empChk, custTypeVal, exTrade, stkIdVal);

        });


        $('#brandType').change(function() {
        	var brandTypeVal = $("#brandType option:selected").val();

        	if(brandTypeVal.trim().toUpperCase() == 'OTHER'){
        		  $('#otherBrand').removeAttr("disabled");
        	}
        	else{
        		$('#otherBrand').val('');
        		 $('#otherBrand').prop("disabled", true);
        	}

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
            //var srvPacId    = $('#srvPacId').val();



                fn_loadProductPrice(appTypeVal, stkIdVal);
                fn_loadPromotionPrice(promoIdVal);


        });


        $('[name="ordSaveBtn"]').click(function() {
            if(bulkOrderYn == 'Y' && FormUtil.checkReqValue($('#hiddenCopyQty'))) {
                //Common.popupDiv("/sales/order/copyOrderBulkPop.do");
            }
            else {
                fn_preCheckSave();
            }
        });
    });


    function fn_preCheckSave() {




        if(!fn_validCustomer()) {
            $('#aTabCS').click();
            return false;
        }

   /*      if(!fn_validMailAddress()) {
            $('#aTabBD').click();
            return false;
        } */

        if(!fn_validContact()) {
            $('#aTabBD').click();
            return false;
        }

        if(!fn_validSales()) {
            $('#aTabSO').click();
            return false;
        }

     /*    if(!fn_validRentPaySet()) {
            $('#aTabPC').click();
            return false;
        } */

 /*        if(!fn_validBillGroup()) {
            $('#aTabBD').click();
            return false;
        } */

        if(!fn_validInstallation()) {
            $('#aTabIN').click();
            return false;
        }

/*         if(!fn_validDocument()) {
            $('#aTabDC').click();
            return false;
        } */

        if(!fn_validCert()) {
            $('#aTabRC').click();
            return false;
        }

        var isValid = true, msg = "", docSelCnt = 0;

        //첨부파일이 존재하면
        if(!FormUtil.checkReqValue($('#certRefFile'))) {
            isValid = false;
/*
            msg += "Under rare circumstances, Federal Government, State Government, Palace of Ruler and certain organizations ";
            msg += "are given GST relief for purchase of goods under Goods and Services Tax (Relief) Order 2014 at GST rate of 0%. ";
            msg += "\"Certificate under the Goods and Services Tax (Relief) Order 2014 \"" + "must be furnished by customers. <br /> ";
            msg += "<b>Are you sure you want to proceed?</b> <br /><br />";
*/
            msg += '<spring:message code="sal.alert.msg.certRefFile1" />' + '<spring:message code="sal.alert.msg.certRefFile2" />' + '<spring:message code="sal.alert.msg.certRefFile3" />';
        }

/*         docSelCnt = fn_getDocChkCount();

        console.log('!@#### docSelCnt:'+docSelCnt);

        if(docSelCnt <= 0) {
            isValid = false;

            //msg += "You are not select any document in this order.<br />";
            //msg += "<b>Are you sure want to save this order without any document submission ?</b><br /><br />";

            msg += '<spring:message code="sal.alert.msg.docuChk" />';
        } */

        console.log('!@#### isValid'+isValid);


        if(!isValid) {
            Common.confirm('<spring:message code="sal.alert.msg.cnfrmToSave" />' + DEFAULT_DELIMITER + msg, fn_hiddenSave);
        }
        else {

            if($("#ordPromo option:selected").index() > 0) {
                console.log('!@#### ordSaveBtn click START 00000');

                    console.log('!@#### ordSaveBtn click START 22222');
                    Common.popupDiv("/homecare/sales/cnfmHTOrderDetailPop.do");

            }
            else {
                console.log('!@#### ordSaveBtn click START 33333');
                Common.popupDiv("/homecare/sales/cnfmHTOrderDetailPop.do");
            }
        }
    }

    function fn_popOrderDetail() {
        Common.popupDiv("/homecare/sales/cnfmHTOrderDetailPop.do");
    }

    function fn_selectCustInfo() {
        var strCustId = $('#custId').val();

        //CLEAR CUSTOMER
        fn_clearCustomer();
        fn_clearMailAddress();
        fn_clearContactPerson();

        //CLEAR SALES
        fn_tabOnOffSet('PAY_CHA', 'HIDE');
        $('#appType').val('');

        //ClearControl_Sales();
        fn_clearSales();

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



            Common.popupDiv("/homecare/sales/cnfmHTOrderDetailPop.do");

    }

    function fn_doSaveOrder() {
        console.log('!@# fn_doSaveOrder START');

        var vBindingNo = "";
        var vCnvrSchemeId = 0 ;
        var vInstPriod = 0 ;
        var vSalesOrdIdOld = "";
        var vDefRentAmt = 0 ;
        var vAdvBill = 0 ;
        var vExTrade = 0 ;
        var vECash = 0;
        var vPromoDiscPeriodTp = 0 ;
        var vPromoDiscPeriod = 0;
        var vOrdPv = $('#ordPrice').val().trim();
        var vCustBillId = 0 ;
        var vMthRentAmt = 0;
        var vNorRntFee = 0 ;
        var vDiscRntFee = 0 ;
        var vGstChk = 0 ;
        var vProdBrand = "";
        var vOrderQuantity = $('#ordQuantity').val();
        var vServiceType = "";
        var vUnitType = "";

        var brandTypeVal = $("#brandType option:selected").val();
        if (brandTypeVal.trim().toUpperCase() == "OTHER"){
        	vProdBrand = $('#otherBrand').val();

        	if(vProdBrand.trim() == ""){
            	vProdBrand = $('#brandType').val();
        	}
        }
        else{
        	vProdBrand = $('#brandType').val();
        }

       orderVO = {

        custTypeId      : $('#typeId').val().trim(),
        raceId          : $('#raceId').val().trim(),
        orderQuantity : vOrderQuantity,
    	 // SERVICE CARE ORDER
        appTypeId               : $('#appType').val(),
        refNo                   : $('#refereNo').val().trim(),
        custId                  : $('#hiddenCustId').val().trim(),
        custCntId               : $('#hiddenCustCntcId').val().trim(),
        custAddId               : $('#hiddenCustAddId').val().trim(),
        memId                   : $('#hiddenSalesmanId').val().trim(),
        brnchId                 : $('#dscBrnchId').val(),
        totAmt                  : $('#ordPrice').val().trim(),
        promoId                 : $('#ordPromo').val(),
        bindingNo               : vBindingNo,
        totPv                   : vOrdPv,
        rem                     : $('#ordRem').val().trim(),
        custPoNo                : $('#poNo').val().trim(),
        instPriod               : vInstPriod,
        deptCode                : $('#departCd').val().trim(),
        grpCode                 : $('#grpCd').val().trim(),
        orgCode                 : $('#orgCd').val().trim(),
        salesOrdIdOld           : vSalesOrdIdOld,
        custBillId              : vCustBillId,
        mthRentAmt              : vMthRentAmt ,
        defRentAmt              : vDefRentAmt,
        salesGmId               : $('#orgMemId').val().trim(),
        salesHmId               : $('#departMemId').val().trim(),
        salesSmId               : $('#grpMemId').val().trim(),
        advBill                    : vAdvBill,
        cnvrSchemeId            : vCnvrSchemeId,
        custCareCntId           : $('#srvCntcId').val().trim(),
        empChk                  : $('#empChk').val(),
        exTrade                 : vExTrade,
        ecash                  : vECash,
        promoDiscPeriodTp       : vPromoDiscPeriodTp,
        promoDiscPeriod         : vPromoDiscPeriod,
        norAmt                  : $('#orgOrdPrice').val().trim(),
        norRntFee               : vNorRntFee,
        discRntFee              : vDiscRntFee,
        gstChk                  : vGstChk,
        srvPacId                : $('#srvPacId').val(),
        prodSize                 : $('#ordProudct').val(),
        prodBrand                :vProdBrand,
        serviceType             :  $('#serviceType').val(),
        unitType                 : $('#ordUnitType').val(),

        // SERVICE ADDRESS
        installationVO : {
                addId                   : $('#hiddenCustAddId').val(),
                brnchId                 : $('#dscBrnchId').val(),
                cntId                   : $('#hiddenInstCntcId').val(),
                instct                  : $('#speclInstct').val(),
                preDt                   : FormUtil.isEmpty($('#prefInstDt').val().trim()) ? '01/01/1900' : $('#prefInstDt').val(),
                preTm                   : FormUtil.isEmpty($('#prefInstTm').val().trim()) ? '00:00:00' : $('#prefInstTm').val()
            }
         //DOCUMENT SUBMISSION
        //,docSubmissionVOList         : GridCommon.getEditData(docGridID)

    };

        Common.ajax("POST", "/homecare/sales/registerOrder.do", orderVO, function(result) {

            Common.alert('<spring:message code="sal.alert.msg.ordSaved" />' + DEFAULT_DELIMITER + "<b>"+result.message+"</b>",fn_orderRegPopClose());

        },  function(jqXHR, textStatus, errorThrown) {
            try {
                console.log("status : " + jqXHR.status);
                console.log("code : " + jqXHR.responseJSON.code);
                console.log("message : " + jqXHR.responseJSON.message);
                console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);

//              Common.alert("Failed To Save" + DEFAULT_DELIMITER + "<b>Failed to save order.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
                Common.alert('<spring:message code="sal.alert.title.saveFail" />' + DEFAULT_DELIMITER + '<b><spring:message code="sal.alert.msg.failSaveOrd" /></b>');
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

        if(FormUtil.checkReqValue($('#hiddenCustId')) && FormUtil.checkReqValue($('#custId'))) {
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

        if(appTypeIdx <= 0) {
            isValid = false;
            msg += '<spring:message code="sal.alert.msg.salAppType" /><br>';
        }

        else {
            if(appTypeVal == '68' || appTypeVal == '1412') {
                if(FormUtil.checkReqValue($('#installDur'))) {
                    isValid = false;
                    msg += '<spring:message code="sal.alert.msg.plzKeyinInstDuration" />';
                }
            }

            if(appTypeVal == '66' || appTypeVal == '67' || appTypeVal == '68' || appTypeVal == '1412') {
                if($("#ordPromo option:selected").index() <= 0) {
                    isValid = false;
                    msg += "* Please select the promotion code.<br>";
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

        if($("#ordProudct option:selected").index() <= 0) {
            isValid = false;
            msg += '* <spring:message code="sal.alert.msg.plzSelPrd" /><br>';
        }



/*         if(!FormUtil.checkReqValue($('#hiddenSalesmanId'))) {

            if($('#hiddenSalesmanId').val() == '1' || $('#hiddenSalesmanId').val() == '2') {

                if(appTypeVal == '66' || appTypeVal == '67' || appTypeVal == '68') {

                    if(FormUtil.checkReqValue($('#departCd')) || FormUtil.checkReqValue($('#grpCd')) || FormUtil.checkReqValue($('#orgCd'))) {

                        var memType = $('#hiddenSalesmanTypeId').val() == '1' ? "HP" : "Cody";

                        isValid = false;
//                      msg += '* The ' + MemType + ' department/group/organization code is missing.<br>';
                        msg += '* <spring:message code="sal.alert.msg.plzSelOrgCd" arguments="'+memType+'"/><br>';
                    }
                }
            }
        }
        else {
            if(appTypeIdx > 0 && appTypeVal != 145) {
                isValid = false;
                msg += '<spring:message code="sal.alert.msg.plzSelectSalesman" />';
            }
        } */


        if($('#salesmanCd').val() == '' || $('#salesmanCd').val() == null ){
        	console.log("appTypeVal  : " + appTypeVal);
        	if(appTypeVal == 5701 || appTypeVal == 5702){
        	    // 5701 - FREE TRIAL 1 TIME
        	    // 5702 - FREE TRIAL 1 YEAR
        	}else {
        	       isValid = false;
        	         msg += '<spring:message code="sal.alert.msg.plzSelectSalesman" />';
        	}
        }

        if(appTypeVal == 5702 ){ // FREE TRIAL 1 YEAR ONLY CAN BE CREATED BY HOMECARE DEPARTMENT AND IT ADMINISTRATOR
        	console.log("ROLE ID  : " + ROLE_ID);
        	if(ROLE_ID == "130" ||   ROLE_ID == "344" || ROLE_ID == "343" || ROLE_ID == "342"){
        		  // 130 - ADMINISTRATOR
        		  // 344 - HOMECARE EXECUTIVE
        		  // 343 - HOMECARE TEAM LEADER
        		  // 342 - HOMECARE MANAGER
        	}else{
            isValid = false;
            msg += 'Application Type : Free Trial - 1 Year is not allowed. <br> Please select other application type.';
        }
        }

        if(!isValid) Common.alert('<spring:message code="sal.alert.msg.saveSalOrdSum" />' + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

        return isValid;
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

        /* if(FormUtil.isEmpty($('#prefInstDt').val().trim())) {
            isValid = false;
            msg += '<spring:message code="sal.alert.msg.plzSelPreferInstDate" />';
        }

        if(FormUtil.isEmpty($('#prefInstTm').val().trim())) {
            isValid = false;
            msg += '<spring:message code="sal.alert.msg.plzSelPreferInstTime" />';
        } */

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

        console.log('certRefFile'+ $('#certRefFile').val())

//      if(!$('#tabRC').hasClass("blind") && !FormUtil.checkReqValue($('#certRefFile'))) {
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
        console.log("fn_loadBankAccount START");

        Common.ajax("GET", "/homecare/sales/selectCustomerBankDetailView.do", {getparam : bankAccId}, function(rsltInfo) {

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
                $("#ddcChl").val(rsltInfo.ddtChnl);
            }
        });
    }



    function fn_loadOrderSalesman(memId, memCode) {

        console.log('fn_loadOrderSalesman memId:'+memId);
        console.log('fn_loadOrderSalesman memCd:'+memCode);

        fn_clearOrderSalesman();

        Common.ajax("GET", "/homecare/sales/selectMemberByMemberIDCode.do", {memId : memId, memCode : memCode, stus : 1, salesMen : 1}, function(memInfo) {

            if(memInfo == null) {
//              Common.alert('<b>Member not found.</br>Your input member code : '+memCode+'</b>');
                Common.alert('<spring:message code="sal.alert.msg.memNotFoundInput" arguments="'+memCode+'"/>');
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

            Common.ajax("GET", "/homecare/sales/selectTrialNo.do", {salesOrdNo : trialNo}, function(trialInfo) {

                if(trialInfo != null) {

                    console.log("성공.");

                    $("#trialId").val(trialInfo.salesOrdId);
                    $("#trialNo").val(trialInfo.salesOrdNo);
                }
            });
        }
    }

    function fn_loadPromotionPrice(promoId) {

        Common.ajax("GET", "/homecare/sales/selectProductPromotionPercentByPromoID.do", {promoId : promoId}, function(promoPriceInfo) {

            if(promoPriceInfo != null) {

                console.log("성공.");

                var discPrice = 0;
                var appQty = $('#ordQuantity').val();
                var discAddPrice = promoPriceInfo.promoAddDiscPrc;
                var promoDiscType = promoPriceInfo.promoDiscType;

                if(promoDiscType == 0){

                discPrice = ($('#orgOrdPrice').val() - ($('#orgOrdPrice').val() * promoPriceInfo.promoPrcPrcnt / 100) - discAddPrice);

                } else if (promoDiscType == 1){

                	discPrice = ($('#orgOrdPrice').val()  - promoPriceInfo.promoPrcPrcnt  - discAddPrice);

                }

                console.log('discount type : ' + promoDiscType);
                console.log('original Price -->  :'+ $('#orgOrdPrice').val());
                console.log('discount Price -->  :'+ Math.floor(discPrice));


                $("#ordPrice").val(Math.floor(discPrice));
                $("#orgOrdPrice").val(Math.floor(discPrice));

            }
        });
    }

    //LoadProductPromotion
    function fn_loadProductPromotion(promoAppTypeId, stkId, empChk, custTypeVal, exTrade, stkSize) {
        var exTrade = 0;
        $('#ordPromo').removeAttr("disabled");

        if(promoAppTypeId == 3220 || promoAppTypeId == 3221){
        	doGetComboData('/homecare/sales/selectPromotionByAppTypeStock.do',
        			{appTypeId:promoAppTypeId, empChk:empChk, promoCustType:custTypeVal, exTrade:exTrade, stkSize:stkSize}
		            , ''
		            , 'ordPromo'
		            , 'S'
		            , ''); //Common Code
        }
        else{
        	$('#ordPromo').prop("disabled", true);
        }

 }

    //LoadProductPrice
    function fn_loadProductPrice(appTypeVal, stkId) {

    	console.log('fn_loadProductPrice --> appTypeVal:'+appTypeVal);
        console.log('fn_loadProductPrice --> stkId:'+stkId);
        //console.log('fn_loadProductPrice --> srvPacId:'+srvPacId);

        var appTypeId = 0;

        appTypeId = appTypeVal=='68' ? '67' : appTypeVal;

        $("#searchAppTypeId").val(appTypeId);
        $("#searchStkId").val(stkId);
        //$("#searchSrvPacId").val(srvPacId);

         var orderQuantity = $('#ordQuantity').val();
        var orderPrice = 0;
        var totalPrice = 0;

      if(appTypeVal == 3216){
        switch(stkId){
        case "KING" :
            orderPrice = 240;
            break;
        case "QUEEN" :
            orderPrice = 220;
            break;
        case "SINGLE" :
            orderPrice = 175;
            break;
        }
      }else if (appTypeVal == 3217) {
        switch(stkId){
        case "KING" :
        	orderPrice = 648;
        	break;
        case "QUEEN" :
        	orderPrice = 594;
        	break;
        case "SINGLE" :
        	orderPrice = 473;
        	break;
        }
      }

      totalPrice = orderPrice * orderQuantity;

                $("#ordPrice").val(totalPrice);
                $("#orgOrdPrice").val(totalPrice);

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

    //ClearControl_AllForm
    function fn_clearAllForm(){
    	   fn_clearCustomer();
    	   fn_clearMailAddress();

    	   $('#ownerPurchsForm').clearForm();
           $('#addSvcCntcForm').clearForm();

    	   fn_clearSales();
    	   fn_clearInstallAddr();
    	   fn_clearCntcPerson();

    	  /*  $('#ownerPurchsForm').clearForm();
    	   $('#addSvcCntcForm').clearForm();
    	   $('#instAddrForm').clearForm(); */

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
        $('#ordProudct').val('0');
        $('#ordPromo').val('');
        $('#relatedNo').val('');
        $('#trialNoChk').prop("checked", false);
        $('#trialNo').val('');
        $('#ordPrice').val('');
        $('#ordPriceId').val('');
        $('#ordPv').val('');
        $('#ordRentalFees').val('');
        $('#orgOrdRentalFees').val('');
        $('#ordQuantity').val('0');
        $('#brandType').val('0');
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

    function fn_changeDetails(){

    	var productSizeMasterId;
    	var brandTypeMasterId;
    	var unitTypeMasterId;

    	if($("#serviceType").val() == "6862"){
    		//AIRCOND
    		productSizeMasterId = 521;
    		brandTypeMasterId = 518;
    		unitTypeMasterId = 520;
    	}else if($("#serviceType").val() == "6863"){
    		//MASSAGE
    		productSizeMasterId = 515;
    		brandTypeMasterId = 519;
    	}else if($("#serviceType").val() == "6861"){
    		//MATTRESS
    		productSizeMasterId = 447;
    		brandTypeMasterId = 517;
        }

        CommonCombo.make("ordProudct", "/common/selectProductSizeList.do", {groupCode : productSizeMasterId}, "", {
            id: "codeId",
            name: "codeName",
            type:"S"
        });

        CommonCombo.make("brandType", "/common/selectBrandTypeList.do", {groupCode : brandTypeMasterId}, "", {
            id: "codeId",
            name: "codeName",
            type:"S"
        });

        CommonCombo.make("ordUnitType", "/common/selectUnitTypeList.do", {groupCode : unitTypeMasterId}, "", {
            id: "codeId",
            name: "codeName",
            type:"S"
        });

    	if ($("#serviceType").val() == "6862" ||  $("#serviceType").val() == "6863"){

    		$('#ordProductLbl').hide();

    		if($("#serviceType").val() == "6862"){
    			$('#ordProductLbl2').hide();
    			$('#ordProductLbl1').show();
    			$('#ordUnitTypeboard').show();
    			$('#ordUnitTypeLbl').show();
    			$('#ordUnitType').show();
    			/* $("#ordProudct").prop("disabled", false); */
    		}else if($("#serviceType").val() == "6863"){
    			$('#ordProductLbl1').hide();
    			$('#ordProductLbl2').show();
    			$('#ordUnitTypeboard').hide();
                $('#ordUnitTypeLbl').hide();
                $('#ordUnitType').hide();
                /* $("#ordProudct").prop("disabled", true); */
    		}

    	}else{
    		$('#ordProductLbl1').hide();
    		$('#ordProductLbl2').hide();
    		$('#ordProductLbl').show();
    		$('#ordUnitTypeboard').hide();
            $('#ordUnitTypeLbl').hide();
            $('#ordUnitType').hide();
            /* $("#ordProudct").prop("disabled", false); */
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
    <li id="tabSO"><a id="aTabSO" href="#" onClick="javascript:chgTab('sal');">Care Service Order</a></li>
  <!--   <li id="tabPC"><a id="aTabPC" href="#" onClick="javascript:chgTab('pay');">Payment Channel</a></li> -->
    <li id="tabIN"><a id="aTabIN" href="#" onClick="javascript:chgTab('ins');">Care Service Address</a></li>
   <!--  <li id="tabDC"><a id="aTabDC" href="#" onClick="javascript:chgTab('doc');">Documents</a></li> -->
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
    <td><input id="custId" name="custId" type="text" title="" placeholder="Customer ID" class="" /><a class="search_btn" id="custBtn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
    <th scope="row"><spring:message code="sal.text.type" /></th>
    <td><input id="custTypeNm" name="custTypeNm" type="text" title="" placeholder="Customer Type" class="w100p" readonly/>
        <input id="typeId" name="typeId" type="hidden"/>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.name" /></th>
    <td><input id="name" name="name" type="text" title="" placeholder="Customer Name" class="w100p" readonly/></td>
    <th scope="row"><spring:message code="sal.text.nricCompanyNo" /></th>
    <td><input id="nric" name="nric" type="text" title="" placeholder="NRIC/Company No" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.nationality" /></th>
    <td><input id="nationNm" name="nationNm" type="text" title="" placeholder="Nationality" class="w100p" readonly/>
        <input id="nation" name="nation" type="hidden"/>
    </td>
    <th scope="row"><spring:message code="sal.text.race" /></th>
    <td><input id="race" name="race" type="text" title="" placeholder="Race" class="w100p" readonly/>
        <input id="raceId" name="raceId" type="hidden"/>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.dob" /></th>
    <td><input id="dob" name="dob" type="text" title="" placeholder="DOB" class="w100p" readonly/></td>
    <th scope="row"><spring:message code="sal.text.gender" /></th>
    <td><input id="gender" name="gender" type="text" title="" placeholder="Gender" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.passportExpire" /></th>
    <td><input id="pasSportExpr" name="pasSportExpr" type="text" title="" placeholder="Passport Expiry" class="w100p" readonly/></td>
    <th scope="row"><spring:message code="sal.text.visaExpire" /></th>
    <td><input id="visaExpr" name="visaExpr" type="text" title="" placeholder="Visa Expiry" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.email" /></th>
    <td><input id="email" name="email" type="text" title="" placeholder="Email Address" class="w100p" readonly/></td>
    <th scope="row"><spring:message code="sal.text.indutryCd" /></th>
    <td><input id="corpTypeNm" name="corpTypeNm" type="text" title="" placeholder="Industry Code" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.employee" /><span class="must">*</span></th>
    <td colspan="3"><select id="empChk" name="empChk" class="w100p"></select></select></td>
</tr>
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
    <td><input id="custInitial" name="custInitial" type="text" title="" placeholder="" class="w100p" disabled/></td>
    <th scope="row"><spring:message code="sal.text.name" /></th>
    <td><input id="custCntcName" name="custCntcName" type="text" title="" placeholder="" class="w100p" disabled/>
        <input id="hiddenCustCntcId" name="custCntcId" type="hidden" /></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.telMOne" /></th>
    <td><input id="custCntcTelM" name="custCntcTelM" type="text" title="" placeholder="" class="w100p" disabled/></td>
    <th scope="row"><spring:message code="sal.title.text.telROne" /></th>
    <td><input id="custCntcTelR" name="custCntcTelR" type="text" title="" placeholder="" class="w100p" disabled/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.telOOne" /></th>
    <td><input id="custCntcTelO" name="custCntcTelO" type="text" title="" placeholder="" class="w100p" disabled/></td>
    <th scope="row"><spring:message code="sal.title.text.extNo" />(1)</th>
    <td><input id="custCntcExt" name="custCntcExt" type="text" title="" placeholder="" class="w100p" disabled/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.telFOne" /></th>
    <td><input id="custCntcTelF" name="custCntcTelF" type="text" title="" placeholder="" class="w100p" disabled/></td>
    <th scope="row"><spring:message code="sal.title.text.eamilOne" /></th>
    <td><input id="custCntcEmail" name="custCntcEmail" type="text" title="" placeholder="" class="w100p" disabled/></td>
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
    <td colspan="3"><input id="srvCntcName" name="srvCntcName" type="text" title="" placeholder="" class="w100p" disabled/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.telMTwo" /></th>
    <td><input id="srvCntcTelM" name="srvCntcTelM" type="text" title="" placeholder="" class="w100p" disabled/></td>
    <th scope="row"><spring:message code="sal.title.text.telRTwo" /></th>
    <td><input id="srvCntcTelR" name="srvCntcTelR" type="text" title="" placeholder="" class="w100p" disabled/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.telOTwo" /></th>
    <td><input id="srvCntcTelO" name="srvCntcTelO" type="text" title="" placeholder="" class="w100p" disabled/></td>
    <th scope="row"><spring:message code="sal.title.text.extNo" />(2)</th>
    <td><input id="srvCntcExt" name="srvCntcExt" type="text" title="" placeholder="" class="w100p" disabled/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.telFTwo" /></th>
    <td><input id="srvCntcTelF" name="srvCntcTelF" type="text" title="" placeholder="" class="w100p" disabled/></td>
    <th scope="row"><spring:message code="sal.title.text.emailTwo" /></th>
    <td><input id="srvCntcEmail" name="srvCntcEmail" type="text" title="" placeholder="" class="w100p" disabled/></td>
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
<th scope="row">Service Type<span class="must">*</span></th>
    <td>
    <p><select id="serviceType" name="serviceType" class="w100p" onchange = "fn_changeDetails()"></select> </p>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.appType" /><span class="must">*</span></th>
    <td>
    <p><select id="appType" name="appType" class="w100p"></select> </p>
<!--     <p><select id="srvPacId" name="srvPacId" class="w100p"></select></p> -->
       <p><select id="ordQuantity" name="ordQuantity" class="w100p" disabled>
         <option value="0">Choose One</option>
        <option value="1">1</option>
        <option value="2">2</option>
            </select>
            </p>
    </td>
    <th scope="row"><spring:message code="sal.text.ordDate" /><span class="must">*</span></th>
    <td>${toDay}</td>
</tr>
<tr>
    <th scope="row" id="refereNoLbl"><spring:message code="sal.text.refNo" /><span class="must"></span></th>
    <td><input id="refereNo" name="refereNo" type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row" id ="salesmanCdLbl"><spring:message code="sal.text.salManCode" /><span class="must"></span></th>
    <td><input id="salesmanCd" name="salesmanCd" type="text" title="" placeholder="" class="" />
        <input id="hiddenSalesmanId" name="salesmanId" type="hidden"  />
        <a id="memBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.poNo" /><span class="must"></span></th>
    <td><input id="poNo" name="poNo" type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row"><spring:message code="sal.title.text.salesmanType" /></th>
    <td><input id="salesmanType" name="salesmanType" type="text" title="" placeholder="Salesman Type" class="w100p readonly" readonly/>
        <input id="hiddenSalesmanTypeId" name="salesmanTypeId" type="hidden" /></td>
</tr>
<tr id = "ordUnitTypeboard">
    <th scope="row" id = "ordUnitTypeLbl">Unit Type<span class="must">*</span></th>
    <td>
    <select id="ordUnitType" name="ordUnitType" class="w100p">
    </td>
</tr>
<tr>
    <th scope="row" id = "ordProductLbl">Mattress Size<span class="must">*</span></th>
    <th scope="row" id = "ordProductLbl1">Horsepower (HP)<span class="must">*</span></th>
    <th scope="row" id = "ordProductLbl2">Chair Size<span class="must">*</span></th>
    <td>
<!--             <select id="srvProduct" name="srvProduct" class="w100p">
            <option value="0">Choose One</option>
        <option value="1">Coway Mattress</option>
        <option value="2">Other Brands</option>
            </select> -->

             <select id="ordProudct" name="ordProudct" class="w100p">
          <!--   <select id="compType" name="compType" class="w100p" ></select> -->
        <!--     <option value="0">Choose One</option>
            <option value="KING">KING</option>
            <option value="QUEEN">QUEEN</option>
            <option value="SINGLE">SINGLE</option> -->
            </select>
            </td>
    <th scope="row"><spring:message code="sal.text.salManName" /></th>
    <td><input id="salesmanNm" name="salesmanNm" type="text" title="" placeholder="Salesman Name" class="w100p readonly" readonly/></td>
</tr>
<tr>
       <th scope="row">Brand<span class="must">*</span></th>
        <td>
         <select id="brandType" name="brandType">
<!--          <option value="0">Choose One</option>
        <option value="Dorma">Dorma</option>
        <option value="DreamLand">DreamLand</option>
        <option value="Getha">Getha</option>
        <option value="Goodnite">Goodnite</option>
        <option value="King Koil">King Koil</option>
        <option value="Mylatex">Mylatex</option>
        <option value="Sealy">Sealy</option>
        <option value="Slumberland">Slumberland</option>
        <option value="Sonno">Sonno</option>
        <option value="SweetDram">SweetDram</option>
        <option value="Other">Other</option> -->
       </select>
    </td>


    <th scope="row"><spring:message code="sal.title.text.salesmanNric" /></th>
    <td><input id="salesmanNric" name="salesmanNric" type="text" title="" placeholder="Salesman NRIC" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Other</th>
        <td>
   <input id="otherBrand" name="otherBrand" type="text" title="" placeholder="Other Brand" class="w100p" disabled />
    </td>

    <th scope="row"><spring:message code="sal.text.departmentCode" /></th>
    <td><input id="departCd"    name="departCd"    type="text" title="" placeholder="Department Code" class="w100p readonly" readonly />
        <input id="departMemId" name="departMemId" type="hidden" /></td>
</tr>
<tr>

   <th scope="row" id="ordPromoLbl"><spring:message code="sal.title.text.promo" /><span class="must"></span></th>
    <td>
    <select id="ordPromo" name="ordPromo" class="w100p" ></select>
    <input id="txtOldOrderID" name="txtOldOrderID" type="hidden" />
    </td>


<%--     <th scope="row">
    <spring:message code="sal.title.text.nomalRentFeeRm" />
    </th> --%>
    <!-- <td><input id="orgOrdRentalFees" name="orgOrdRentalFees" type="text" title="" placeholder="Rental Fees (Monthly)" class="w100p readonly" readonly /></td> -->
    <th scope="row"><spring:message code="sal.text.GroupCode" /></th>
    <td><input id="grpCd" name="grpCd" type="text" title="" placeholder="Group Code" class="w100p readonly" readonly />
        <input id="grpMemId" name="grpMemId" type="hidden" /></td>

</tr>
<tr>
          <th scope="row"><spring:message code="sal.title.text.priceRpfRm" /></th>
    <td>
    <input id="ordPrice"    name="ordPrice" type="text" title="" placeholder="Price/Rental Processing Fees (RPF)" class="w100p readonly" readonly />
        <input id="orgOrdPrice" name="orgOrdPrice" type="hidden" />

    <th scope="row"><spring:message code="sal.text.organizationCode" /></th>
    <td><input id="orgCd" name="orgCd" type="text" title="" placeholder="Organization Code" class="w100p readonly" readonly />
        <input id="orgMemId" name="orgMemId" type="hidden" /></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.remark" /></th>
    <td colspan="3"><textarea  id="ordRem" name="ordRem" cols="20" rows="5" placeholder="Remark"></textarea></td>
</tr>
</tbody>
</table><!-- table end -->

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
<h3>Service Address</h3>
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
    <td colspan="3"><input id="instAddrDtl" name="instAddrDtl" type="text" title="" placeholder="Address Detail" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.street" /><span class="must">*</span></th>
    <td colspan="3"><input id="instStreet" name="instStreet" type="text" title="" placeholder="Street" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.area" /><span class="must">*</span></th>
    <td colspan="3"><input id="instArea" name="instArea" type="text" title="" placeholder="Area" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.city" /><span class="must">*</span></th>
    <td>
    <input id="instCity" name="instCity" type="text" title="" placeholder="City" class="w100p readonly" readonly/>
    </td>
    <th scope="row"><spring:message code="sal.text.postCode" /><span class="must">*</span></th>
    <td>
    <input id="instPostCode" name="instPostCode" type="text" title="" placeholder="Post Code" class="w100p readonly" readonly/>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.state" /><span class="must">*</span></th>
    <td>
    <input id="instState" name="instState" type="text" title="" placeholder="State" class="w100p readonly" readonly/>
    </td>
    <th scope="row"><spring:message code="sal.text.country" /><span class="must">*</span></th>
    <td>
    <input id="instCountry" name="instCountry" type="text" title="" placeholder="Country" class="w100p readonly" readonly/>
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
    <td><input id="instCntcName" name="instCntcName" type="text" title="" placeholder="" class="w100p" readonly/></td>
    <th scope="row"><spring:message code="sal.text.initial" /></th>
    <td><input id="instInitial" name="instInitial" type="text" title="" placeholder="" class="w100p" readonly/></td>
    <th scope="row"><spring:message code="sal.text.gender" /></th>
    <td><input id="instGender" name="instGender" type="text" title="" placeholder="" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.nric" /></th>
    <td><input id="instNric" name="instNric" type="text" title="" placeholder="" class="w100p" readonly/></td>
    <th scope="row"><spring:message code="sal.text.dob" /></th>
    <td><input id="instDob" name="instDob" type="text" title="" placeholder="" class="w100p" readonly/></td>
    <th scope="row"><spring:message code="sal.text.race" /></th>
    <td><input id="instRaceId" name="instRaceId" type="text" title="" placeholder="" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.email" /></th>
    <td><input id="instCntcEmail" name="instCntcEmail" type="text" title="" placeholder="" class="w100p" readonly/></td>
    <th scope="row"><spring:message code="sal.text.dept" /></th>
    <td><input id="instDept" name="instDept" type="text" title="" placeholder="" class="w100p" readonly/></td>
    <th scope="row"><spring:message code="sal.text.post" /></th>
    <td><input id="instPost" name="instPost" type="text" title="" placeholder="" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.telM" /></th>
    <td><input id="instCntcTelM" name="instCntcTelM" type="text" title="" placeholder="" class="w100p" readonly/></td>
    <th scope="row"><spring:message code="sal.title.text.telR" /></th>
    <td><input id="instCntcTelR" name="instCntcTelR" type="text" title="" placeholder="" class="w100p" readonly/></td>
    <th scope="row"><spring:message code="sal.title.text.telO" /></th>
    <td><input id="instCntcTelO" name="instCntcTelO" type="text" title="" placeholder="" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.telF" /></th>
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
<h3>Service Information</h3>
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
<%--     <th scope="row"><spring:message code="sal.text.zeroGst" /><span class="must">*</span></th>
    <td>
    <p><select id="gstChk" name="gstChk" class="w100p"></select></p>
    <p id="pBtnCal" class="btn_sky blind"><a id="btnCal" href="#">Calculation</a></p>
    </td>
    <th scope="row"><spring:message code="sal.title.text.dscBrnch" /><span class="must">*</span></th>
    <td>
    <select id="dscBrnchId" name="dscBrnchId" class="w100p" disabled></select>
    </td> --%>
</tr>
<tr>
    <th scope="row">Prefer Service Date<!-- <span class="must">*</span> --></th>
    <td><input id="prefInstDt" name="prefInstDt" type="text" title="Create start Date" placeholder="Prefer Service Date (dd/MM/yyyy)" class="j_date w100p" /></td>
    <th scope="row">Prefer Service Time<!-- <span class="must">*</span> --></th>
    <td>
    <div class="time_picker"><!-- time_picker start -->
    <input id="prefInstTm" name="prefInstTm" type="text" title="" placeholder="Prefer Service Time (hh:mi tt)" class="time_date w100p" />
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
    <th scope="row"><spring:message code="sal.title.text.specialInstruction" /><span class="must"></span></th>
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
    <td><input id="certRefNo" name="certRefNo" type="text" title="" placeholder="Cert Reference No" class="w100p" /></td>
    <th scope="row"><spring:message code="sal.title.text.certificateDate" /><span class="must">*</span></th>
    <td><input id="certRefDt" name="certRefDt" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" /></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.gstRegistrationNo" /></th>
    <td colspan="3"><input id="txtCertCustRgsNo" name="txtCertCustRgsNo" type="text" title="" placeholder="" class="w100p" /></td>
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

