<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript" language="javascript">
    var ORD_ID = "${salesOrderId}";
    var ORD_NO = "${salesOrderNo}";
    var ORD_STUS_ID = "${ordStusId}";
    var CUST_ID = "${custId}";
    var APP_TYPE_ID = "${appTypeId}";
    var APP_TYPE_DESC = "${appTypeDesc}";
    var TAB_NM = "${ordEditType}";
    var CUST_NRIC = "${custNric}";
    var PROMO_CODE = "${promoCode}";
    var PROMO_DESC = "${promoDesc}";
    var SRV_PAC_ID = "${srvPacId}";
    var GST_CHK = "${orderDetail.basicInfo.gstChk}";
    var ADDR_ID = "${orderDetail.basicInfo.ordAddrId}";
    var ROLE_ID = "${SESSION_INFO.roleId}";

    var keyValueList = [];

    var option = {
        winName : "popup",
        width : "1200px", //창 가로 크기
        height : "400px", //창 세로 크기
        resizable : "yes", //창 사이즈 변경. (yes/no)(default : yes)
        scrollbars : "no" //스크롤바. (yes/no)(default : yes)
    };

    var modDocGridID;
    var modRfrGridID;

    $(document)
            .ready(
                    function() {

                        if ("${memType}" == "2") {
                            TAB_NM = 'CNT';
                            $("#ordEditType").prop("disabled", true);
                        }

                        doGetComboData('/homecare/sales/selectEditTypeList.do', {
                            groupCode : '335'
                        }, TAB_NM, 'ordEditType', 'S'); //Order Edit Type
                        doGetComboSepa('/common/selectBranchCodeList.do', '1',
                                ' - ', '', 'modKeyInBranch', 'S'); //Branch Code
                        doGetComboSepa('/common/selectBranchCodeList.do', '5',
                                ' - ', '', 'dscBrnchId', 'S'); //Branch Code
                        doGetComboOrder('/common/selectCodeList.do', '19',
                                'CODE_NAME', '', 'rentPayMode', 'S', ''); //Common Code
                        doGetComboOrder('/common/selectCodeList.do', '10',
                                'CODE_ID', '', 'eurcRliefAppTypeId', 'S', ''); //Common Code
                        doGetComboOrder('/common/selectCodeList.do', '145',
                                'CODE_ID', '', 'eurcRliefTypeId', 'S', ''); //Common Code
                        doGetComboOrder('/common/selectCodeList.do', '322',
                                'CODE_ID', '', 'promoDiscPeriodTp', 'S'); //Discount period

                        fn_statusCodeSearch();

                        if (FormUtil.isNotEmpty(TAB_NM)) {
                            <c:if test="${callCenterYn != 'Y'}">
                                      if(!fn_checkAccessModify(TAB_NM)) return false;
                            </c:if>
                            fn_changeTab(TAB_NM);
                        }

                        createModAUIGrid1();
                        createModAUIGrid2();

                        AUIGrid.bind(modDocGridID, "cellClick",
                                function(event) {
                                    if (event.dataField == 'chkfield') {
                                        fn_setDocSubQty(event.rowIndex, AUIGrid
                                                .getCellValue(modDocGridID,
                                                        event.rowIndex,
                                                        "chkfield"));
                                    }
                                });

                        //Attach File
                        $(".auto_file2")
                                .append(
                                        "<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a id='btnDownGstCert' href='#' class='blind'>Download GST Cert</a></span>");
                    });

    function fn_statusCodeSearch() {
        Common.ajax("GET", "/homecare/sales/selectStateCodeList.do", $(
                "#searchForm").serialize(), function(result) {
            keyValueList = result;
        }, null, {
            async : false
        });
    }

    function fn_setDocSubQty(idx, chkYN) {//AUIGrid.getCellValue(modDocGridID , event.rowIndex, "chkfield"), event.rowIndex
        if (chkYN == '1') {
            AUIGrid.setCellValue(modDocGridID, idx, "docCopyQty", '1');
        } else {
            AUIGrid.setCellValue(modDocGridID, idx, "docCopyQty", '');
        }
    }

    function fn_addRowReferral() {
        var item = new Object(); //{ "salesOrdNo" : "새 이름", "country" : "새 나라", "price" : 0 };

        item.salesOrdNo = ORD_NO;
        item.refName = "";
        item.refStateId = "";
        item.refCntc = "";
        item.refRem = "";
        item.crtDt = "";
        item.userName = "";

        AUIGrid.addRow(modRfrGridID, item, "first");
    }

    function createModAUIGrid1() {
        console.log('createModAUIGrid1() START');

        //AUIGrid 칼럼 설정
        var docColumnLayout = [ {
            headerText : ' ',
            dataField : "chkfield",
            width : 70,
            renderer : {
                type : "CheckBoxEditRenderer",
                showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                checkValue : 1, // true, false 인 경우가 기본
                unCheckValue : 0
            }
        }, {
            headerText : '<spring:message code="sal.title.text.document" />',
            dataField : "typeDesc",
            editable : false
        }, {
            headerText : '<spring:message code="sal.title.qty" />',
            dataField : "docCopyQty",
            editable : true,
            width : 120
        }, {
            headerText : "docTypeId",
            dataField : "docTypeId",
            visible : false
        }, {
            headerText : "docSoId",
            dataField : "docSoId",
            visible : false
        } ];

        //그리드 속성 설정
        var docGridPros = {
            usePaging : true, //페이징 사용
            pageRowCount : 12, //한 화면에 출력되는 행 개수 20(기본값:20)
            editable : true,
            fixedColumnCount : 0,
            showStateColumn : false,
            showRowCheckColumn : false,
            displayTreeOpen : false,
            rowIdField : "codeId",
            //selectionMode       : "singleRow",  //"multipleCells",
            headerHeight : 30,
            useGroupingPanel : false, //그룹핑 패널 사용
            skipReadonlyColumns : true, //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove : true, //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn : true, //줄번호 칼럼 렌더러 출력
            noDataMessage : "No order found.",
            groupingMessage : "Here groupping"
        };

        modDocGridID = GridCommon.createAUIGrid("grid_mod_doc_wrap",
                docColumnLayout, "", docGridPros);
    }

    function createModAUIGrid2() {
        console.log('createModAUIGrid2() START');

        //AUIGrid 칼럼 설정
        var rfrColumnLayout = [
                {
                    headerText : '<spring:message code="sal.text.ordNo" />',
                    dataField : "salesOrdNo",
                    editable : false,
                    width : 100
                },
                {
                    headerText : '<spring:message code="sal.text.name" />',
                    dataField : "refName",
                    editable : true,
                    width : 200
                },
                {
                    headerText : '<spring:message code="sal.text.state" />',
                    dataField : "refStateId",
                    editable : true,
                    width : 100,
                    labelFunction : function(rowIndex, columnIndex, value,
                            headerText, item) {
                        var retStr = value;
                        for (var i = 0, len = keyValueList.length; i < len; i++) {
                            if (keyValueList[i]["stateId"] == value) {
                                retStr = keyValueList[i]["name"];
                                break;
                            }
                        }
                        return retStr;
                    },
                    editRenderer : {
                        type : "DropDownListRenderer",
                        list : keyValueList, //key-value Object 로 구성된 리스트
                        keyField : "stateId", //key 에 해당되는 필드명
                        valueField : "name" //value 에 해당되는 필드명
                    }
                },
                {
                    headerText : '<spring:message code="sal.text.contactNo" />',
                    dataField : "refCntc",
                    editable : true,
                    width : 110,
                    editRenderer : {
                        type : "InputEditRenderer",
                        onlyNumeric : true
                    }
                }, {
                    headerText : '<spring:message code="sal.text.remark" />',
                    dataField : "refRem",
                    editable : true
                }, {
                    headerText : '<spring:message code="sal.text.created" />',
                    dataField : "crtDt",
                    editable : false,
                    width : 120
                }, {
                    headerText : '<spring:message code="sal.text.creator" />',
                    dataField : "userName",
                    editable : false,
                    width : 100
                }, {
                    headerText : "ordRefId",
                    dataField : "ordRefId",
                    visible : false
                } ];

        //그리드 속성 설정
        var rfrGridPros = {
            usePaging : true, //페이징 사용
            pageRowCount : 10, //한 화면에 출력되는 행 개수 20(기본값:20)
            editable : true,
            fixedColumnCount : 0,
            showStateColumn : false,
            showRowCheckColumn : false,
            displayTreeOpen : false,
            rowIdField : "codeId",
            //selectionMode       : "singleRow",  //"multipleCells",
            headerHeight : 30,
            useGroupingPanel : false, //그룹핑 패널 사용
            skipReadonlyColumns : true, //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove : true, //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn : true, //줄번호 칼럼 렌더러 출력
            noDataMessage : "No order found.",
            groupingMessage : "Here groupping"
        };

        modRfrGridID = GridCommon.createAUIGrid("grid_mod_rfr_wrap",
                rfrColumnLayout, "", rfrGridPros);
    }

    // 리스트 조회.
    function fn_selectEditDocSubmList(ordId) {
        Common.ajax("GET", "/sales/order/selectEditDocSubmList.do", {
            salesOrderId : ordId,
            typeCodeId : '248'
        }, function(result) {
            AUIGrid.setGridData(modDocGridID, result);
        });
    }

    // 리스트 조회.
    function fn_selectReferralList(ordNo) {
        Common.ajax("GET", "/sales/order/selectReferralList.do", {
            salesOrdNo : ordNo
        }, function(result) {
            AUIGrid.setGridData(modRfrGridID, result);
        });
    }

    $(function() {
        $('#btnEditType').click(function() {
            var tabNm = $('#ordEditType').val();
            if("${SESSION_INFO.roleId}" == "256" && tabNm == 'PRM'){
                Common.alert('<spring:message code="sal.alert.msg.accRights" />' + DEFAULT_DELIMITER + '<b><spring:message code="sal.alert.msg.noAccRights" /></b>');
            }
            else{
                fn_changeTab(tabNm);
            }

        });
        $('#btnSaveBasicInfo').click(function() {
            if (!fn_validBasicInfo())
                return false;
            fn_doSaveBasicInfo();
        });
        $('#btnSaveMailingAddress').click(function() {
            if (!fn_validMailingAddress())
                return false;
            fn_doSaveMailingAddress();
        });
        $('#btnSaveMailingAddress2').click(function() {
            if (!fn_validMailingAddress2())
                return false;
            fn_doSaveMailingAddress2();
        });
        $('#btnSaveCntcPerson').click(function() {
            if (!fn_validCntcPerson())
                return false;
            fn_doSaveCntcPerson();
        });
        $('#btnSaveNric').click(function() {
            if (fn_validNric())
                fn_doSaveNric();
        });
        $('#btnSaveInstInfo').click(function() {
            if (!fn_validInstallInfo())
                return false;
            fn_doSaveInstallInfo();
        });
        $('#btnSavePayChan')
                .click(
                        function() {
                            if (!fn_validPaymentChannel())
                                return false;
                            Common
                                    .ajax(
                                            "GET",
                                            "/sales/order/getInstallDetail.do",
                                            {
                                                ordId : ORD_ID
                                            },
                                            function(result) {
                                                if (result.stusCodeId != "4"
                                                        && result.modeId == "131") {
                                                    if ($('#rentPayMode').val() != '131') {
                                                        Common
                                                                .alert('Change paymode is not allowed due to installation is not complete');
                                                    } else {
                                                        fn_doSavePaymentChannel();
                                                    }
                                                } else {
                                                    fn_doSavePaymentChannel();
                                                }

                                            });

                        });
        $('#btnSaveDocSub').click(function() {
            if (!fn_validDocSubmission())
                return false;
            fn_doSaveDocSub();
        });
        $('#btnSalesmanPop').click(function() {
            Common.popupDiv("/common/memberPop.do", {
                callPrgm : "ORD_MODIFY_BSC_INF"
            }, null, true);
        });
        $('#modSalesmanCd').change(function() {
            fn_loadOrderSalesman(null, $('#modSalesmanCd').val());
        });
        $('#modSalesmanCd').keydown(function(event) {
            if (event.which === 13) { //enter
                fn_loadOrderSalesman(null, $('#modSalesmanCd').val());
                return false;
            }
        });
        $('#btnBillNewAddr').click(function() {
            Common.popupDiv("/sales/customer/updateCustomerNewAddressPop.do", {
                custId : CUST_ID,
                callParam : "ORD_MODIFY_MAIL_ADR"
            }, null, true);
        });
        $('#btnBillSelAddr').click(function() {
            Common.popupDiv("/sales/customer/customerAddressSearchPop.do", {
                custId : CUST_ID,
                callPrgm : "ORD_MODIFY_MAIL_ADR"
            }, null, true);
        });
        $('#btnMailNewAddr').click(function() {
            Common.popupDiv("/sales/customer/updateCustomerNewAddressPop.do", {
                custId : CUST_ID,
                callParam : "ORD_MODIFY_MAIL_ADR2"
            }, null, true);
        });
        $('#btnMailSelAddr').click(function() {
            Common.popupDiv("/sales/customer/customerAddressSearchPop.do", {
                custId : CUST_ID,
                callPrgm : "ORD_MODIFY_MAIL_ADR2"
            }, null, true);
        });
        $('#btnInstNewAddr').click(function() {
            Common.popupDiv("/sales/customer/updateCustomerNewAddressPop.do", {
                custId : CUST_ID,
                callParam : "ORD_MODIFY_INST_ADR"
            }, null, true);
        });
        $('#btnInstSelAddr').click(function() {
            Common.popupDiv("/sales/customer/customerAddressSearchPop.do", {
                custId : CUST_ID,
                callPrgm : "ORD_MODIFY_INST_ADR"
            }, null, true);
        });
        //Payment Channel - Add New Third Party
        $('#btnAddCust').click(
                function() {
                    Common.popupWin("searchForm",
                            "/sales/customer/customerRegistPop.do", {
                                width : "1200px",
                                height : "630x"
                            });
                });
        $('#btnThrdParty').click(function() {
            //Common.searchpopupWin("searchForm", "/common/customerPop.do","");
            Common.popupDiv("/common/customerPop.do", {
                callPrgm : "ORD_MODIFY_PAY_3RD_PARTY"
            }, null, true);
        });
        //Payment Channel - Add New Bank Account
        $('#btnAddBankAccount').click(
                function() {
                    if ($('#thrdParty').is(":checked")) {
                        Common.popupDiv(
                                "/sales/customer/customerBankAccountAddPop.do",
                                {
                                    custId : $('#hiddenThrdPartyId').val()
                                }, null, true);

                    } else {
                        Common.popupDiv(
                                "/sales/customer/customerBankAccountAddPop.do",
                                {
                                    custId : CUST_ID
                                }, null, true);

                    }
                });
        //Payment Channel - Select Another Bank Account
        $('#btnSelBankAccount')
                .click(
                        function() {
                            if ($('#thrdParty').is(":checked")) {
                                Common
                                        .popupDiv(
                                                "/sales/customer/customerBankAccountSearchPop.do",
                                                {
                                                    custId : $(
                                                            '#hiddenThrdPartyId')
                                                            .val(),
                                                    callPrgm : "ORD_MODIFY_BANK_ACC"
                                                });

                            } else {
                                Common
                                        .popupDiv(
                                                "/sales/customer/customerBankAccountSearchPop.do",
                                                {
                                                    custId : CUST_ID,
                                                    callPrgm : "ORD_MODIFY_BANK_ACC"
                                                });

                            }
                        });
        //Payment Channel - Add New Credit Card
        $('#addCreditCardBtn').click(
                function() {
                    if ($('#thrdParty').is(":checked")) {
                        Common.popupDiv(
                                "/sales/customer/customerCreditCardAddPop.do",
                                {
                                    custId : $('#hiddenThrdPartyId').val()
                                }, null, true);

                    } else {
                        Common.popupDiv(
                                "/sales/customer/customerCreditCardAddPop.do",
                                {
                                    custId : CUST_ID
                                }, null, true);

                    }
                });
        //Payment Channel - Select Another Credit Card
        $('#selCreditCardBtn')
                .click(
                        function() {
                            if ($('#thrdParty').is(":checked")) {
                                Common
                                        .popupDiv(
                                                "/sales/customer/customerCreditCardSearchPop.do",
                                                {
                                                    custId : $(
                                                            '#hiddenThrdPartyId')
                                                            .val(),
                                                    callPrgm : "ORD_MODIFY_PAY_CHAN"
                                                }, null, true);

                            } else {
                                Common
                                        .popupDiv(
                                                "/sales/customer/customerCreditCardSearchPop.do",
                                                {
                                                    custId : CUST_ID,
                                                    callPrgm : "ORD_MODIFY_PAY_CHAN"
                                                }, null, true);

                            }
                        });
        $('#btnNewCntc').click(function() {
            Common.popupDiv("/sales/customer/updateCustomerNewContactPop.do", {
                custId : CUST_ID,
                callParam : "ORD_MODIFY_CNTC_OWN"
            }, null, true);
        });
        $('#btnSelCntc').click(function() {
            Common.popupDiv("/sales/customer/customerConctactSearchPop.do", {
                custId : CUST_ID,
                callPrgm : "ORD_MODIFY_CNTC_OWN"
            }, null, true);
        });
        $('#btnInstNewCntc').click(function() {
            Common.popupDiv("/sales/customer/updateCustomerNewContactPop.do", {
                custId : CUST_ID,
                callParam : "ORD_MODIFY_INST_CNTC"
            }, null, true);
        });
        $('#btnInstSelCntc').click(function() {
            Common.popupDiv("/sales/customer/customerConctactSearchPop.do", {
                custId : CUST_ID,
                callPrgm : "ORD_MODIFY_INST_CNTC"
            }, null, true);
        });
        $('#chkRejectDate')
                .click(
                        function() {

                            var isChk = $('#chkRejectDate').is(":checked");

                            fn_clearControlReject();

                            if (isChk)
                                $('#chkRejectDate').prop("checked", true);

                            if (isChk) {
                                if ($("#rentPayMode option:selected").index() <= 0) {
                                    $("#chkRejectDate").prop("checked", false);
                                    Common
                                            .alert("Rental Paymode Required"
                                                    + DEFAULT_DELIMITER
                                                    + "<b>Please select the rental payment mode first.</b>");
                                } else {
                                    $('#spRjctDate').text("*");
                                    $('#spRejectReason').text("*");
                                    $('#modStartDate').prop("disabled", true);
                                    $('#modRejectDate').removeAttr("disabled");
                                    $('#modRejectReason')
                                            .removeAttr("disabled");
                                }
                            }
                        });
        $('#thrdParty').click(function() {

            fn_clearRentPay3thParty();
            fn_clearRentPaySetCRC();
            fn_clearRentPaySetDD();
            fn_clearControlReject();

            $('#modApplyDate').val("${toDay}");
            $('#modSubmitDate').val('');
            $('#modStartDate').val('');
            $('#rentPayMode').val('');

            if ($('#thrdParty').is(":checked")) {
                $('#scPC_ThrdParty').removeClass("blind");
            }
        });
        $('#thrdPartyId')
                .change(
                        function(event) {

                            var InputCustID = 0;

                            if (FormUtil.isNotEmpty($('#thrdPartyId').val())) {
                                InputCustID = $('#thrdPartyId').val();
                            }

                            fn_clearRentPay3thParty();
                            fn_clearRentPaySetCRC();
                            fn_clearRentPaySetDD();
                            fn_clearControlReject();

                            $('#modApplyDate').val("${toDay}");
                            $('#modSubmitDate').val('');
                            $('#modStartDate').val('');
                            $('#rentPayMode').val('');

                            if (InputCustID != CUST_ID) {
                                fn_loadThirdParty(InputCustID, 2);
                            } else {
                                //              Common.alert("Third Party Restriction" + DEFAULT_DELIMITER + "<b>Third party and customer cannot be same person/company.<br />Your input third party ID : "+InputCustID+"</b>");
                                Common
                                        .alert('<spring:message code="sal.alert.msg.thirdPartyRestriction" />'
                                                + DEFAULT_DELIMITER
                                                + '<spring:message code="sal.alert.msg.plzInputPartyId" arguments="'+InputCustID+'"/>');
                            }
                        });
        $('#thrdPartyId')
                .keydown(
                        function(event) {
                            if (event.which === 13) { //enter
                                var InputCustID = 0;

                                if (FormUtil
                                        .isNotEmpty($('#thrdPartyId').val())) {
                                    InputCustID = $('#thrdPartyId').val();
                                }

                                fn_clearRentPay3thParty();
                                fn_clearRentPaySetCRC();
                                fn_clearRentPaySetDD();
                                fn_clearControlReject();

                                $('#modApplyDate').val("${toDay}");
                                $('#modSubmitDate').val('');
                                $('#modStartDate').val('');
                                $('#rentPayMode').val('');

                                if (InputCustID != CUST_ID) {
                                    fn_loadThirdParty(InputCustID, 2);
                                } else {
                                    Common
                                            .alert('<spring:message code="sal.alert.msg.thirdPartyRestriction" />'
                                                    + DEFAULT_DELIMITER
                                                    + '<spring:message code="sal.alert.msg.plzInputPartyId" arguments="'+InputCustID+'"/>');
                                }
                                return false;
                            }
                        });
        $('#rentPayMode')
                .change(
                        function(event) {

                            fn_clearRentPaySetCRC();
                            fn_clearRentPaySetDD();
                            fn_clearControlReject();

                            $('#modApplyDate').val("${toDay}");
                            $('#modSubmitDate').val('');
                            $('#modStartDate').val('');

                            if ($("#rentPayMode option:selected").index() > 0) {

                                if ($('#rentPayMode').val() == '133'
                                        || $('#rentPayMode').val() == '134') {

                                    var rentPayModeTxt = $(
                                            "#rentPayMode option:selected")
                                            .text();

                                    //                  Common.alert("Rental Paymode Restriction" + DEFAULT_DELIMITER + "<b>Currently we are not provide [" + $("#rentPayMode option:selected").text() + "] service.</b>");
                                    Common
                                            .alert('<spring:message code="sal.alert.msg.rentPayRestriction" />'
                                                    + DEFAULT_DELIMITER
                                                    + '<spring:message code="sal.alert.msg.notProvideSvc" arguments="'+rentPayModeTxt+'"/>');
                                    $('#rentPayMode').val('');
                                } else {
                                    if ($('#rentPayMode').val() == '131') {
                                        if ($('#thrdParty').is(":checked")) {
                                            if (FormUtil
                                                    .isEmpty($(
                                                            '#hiddenThrdPartyId')
                                                            .val())) {
                                                Common
                                                        .alert('<spring:message code="sal.alert.title.thirdPartyRequired" />'
                                                                + DEFAULT_DELIMITER
                                                                + '<spring:message code="sal.alert.msg.plzSelThirdPartyFirst" />');
                                                $('#rentPayMode').val('');
                                            } else {
                                                Common
                                                        .ajax(
                                                                "GET",
                                                                "/sales/order/getInstallDetail.do",
                                                                {
                                                                    ordId : ORD_ID
                                                                },
                                                                function(result) {
                                                                    if (result.stusCodeId != "4"
                                                                            && result.modeId != "131") {
                                                                        Common
                                                                                .alert('Change paymode to CRC is not allowed due to installation is not complete');

                                                                    } else {
                                                                        $(
                                                                                '#scPC_CrCard')
                                                                                .removeClass(
                                                                                        "blind");
                                                                    }
                                                                });

                                            }
                                        } else {
                                            Common
                                                    .ajax(
                                                            "GET",
                                                            "/sales/order/getInstallDetail.do",
                                                            {
                                                                ordId : ORD_ID
                                                            },
                                                            function(result) {
                                                                if (result.stusCodeId != "4"
                                                                        && result.modeId != "131") {
                                                                    Common
                                                                            .alert('Change paymode to CRC is not allowed due to installation is not complete');

                                                                } else {
                                                                    $(
                                                                            '#scPC_CrCard')
                                                                            .removeClass(
                                                                                    "blind");
                                                                }
                                                            });
                                        }
                                    } else if ($('#rentPayMode').val() == '132') {
                                        if ($('#thrdParty').is(":checked")) {
                                            if (FormUtil
                                                    .isEmpty($(
                                                            '#hiddenThrdPartyId')
                                                            .val())) {
                                                Common
                                                        .alert('<spring:message code="sal.alert.title.thirdPartyRequired" />'
                                                                + DEFAULT_DELIMITER
                                                                + '<spring:message code="sal.alert.msg.plzSelThirdPartyFirst" />');
                                                $('#rentPayMode').val('');
                                            } else {
                                                $('#scPC_DirectDebit')
                                                        .removeClass("blind");
                                            }
                                        } else {
                                            $('#scPC_DirectDebit').removeClass(
                                                    "blind");
                                        }
                                    }

                                    fn_loadRejectReasonList($('#rentPayMode')
                                            .val(), 0)
                                }
                            }
                        });
        $('#btnAddRowReferral').click(function() {
            fn_addRowReferral();
        });
        $('#btnCanclChg').click(function() {
            fn_selectReferralList(ORD_NO)
        });
        $('#btnSaveReferral').click(function() {
            fn_doSaveReferral();
        });
        $('#ordPromo').change(
                function() {

                    $('#relatedNo').val('').prop("readonly", true).addClass(
                            "readonly");

                    var stkIdVal = $("#stkId").val();
                    var promoIdIdx = $("#ordPromo option:selected").index();
                    var promoIdVal = $("#ordPromo").val();

                    if (promoIdIdx > 0 && promoIdVal != '0') {
                        $('#relatedNo').removeAttr("readonly").removeClass(
                                "readonly");

                        fn_loadPromotionPrice(promoIdVal, stkIdVal);
                    } else {

                        fn_loadProductPrice(stkIdVal);
                    }
                });
        $('#btnSavePromo').click(function() {
            if (!fn_validPromoPriceInfo())
                return false;
            fn_doSavePromoPriceInfo();
        });
        $('#btnSaveGstCert').click(
                function() {
                    if (!fn_validCert())
                        return false;

                    var formData = Common.getFormData("fileUploadForm");

                    Common.ajaxFile("/sales/order/gstEurCertUpload.do",
                            formData, function(result) {//  첨부파일 정보를 공통 첨부파일 테이블 이용 : 웹 호출 테스트

                                //console.log("총 갯수 : " + result.length);
                                console.log(result.atchFileGrpId);

                                $('#atchFileGrpId').val(result.atchFileGrpId);

                                fn_doSaveGstCertInfo();
                            });
                });
        $('#btnDownGstCert').click(
                function() {
                    var fileSubPath = $('#subPath').val();
                    var fileName = $('#fileName').val();
                    var orignlFileNm = $('#orignlFileNm').val();

                    window.open("<c:url value='/file/fileDown.do?subPath="
                            + fileSubPath + "&fileName=" + fileName
                            + "&orignlFileNm=" + orignlFileNm + "'/>");
                });
        $('#btnCal')
                .click(
                        function() {

                            var appTypeName = APP_TYPE_DESC;
                            var productName = $('#prdName').text();
                            //Amount before GST
                            var oldPrice = $('#orgOrdPrice').val();
                            var newPrice = $('#ordPrice').val();
                            var oldRental = $('#orgOrdRentalFees').val();
                            var newRental = $('#ordRentalFees').val();
                            var oldPv = $('#ordPv').val();
                            //Amount of GST applied
                            var oldPriceGST = fn_calcGst(oldPrice);
                            var newPriceGST = fn_calcGst(newPrice);
                            var oldRentalGST = fn_calcGst(oldRental);
                            var newRentalGST = fn_calcGst(newRental);
                            var newPv = $('#ordPvGST').val();

                            if (APP_TYPE_ID != '66') {
                                oldPriceGST = Math.floor(oldPriceGST / 10) * 10;
                                newPriceGST = Math.floor(newPriceGST / 10) * 10;
                            }

                            var msg = '';
                            /*
                             msg += 'Application Type : '+appTypeName +'<br>';
                             msg += 'Product          : '+productName +'<br>';
                             msg += 'Price(RPF)       : '+newPriceGST +'<br>';
                             msg += 'Normal Rental    : '+oldRentalGST+'<br>';
                             msg += 'Promotion        : '+newRentalGST+'<br>';
                             msg += '<br>The Price(Fee) was applied to the tab of [Sales Order]';
                             */
                            msg = '<spring:message code="sal.alert.msg.gstInfo" arguments="'+appTypeName+';'+productName+';'+newPriceGST+';'+oldRentalGST+';'+newRentalGST+'" argumentSeparator=";"/>';

                            fn_excludeGstAmt();

                            Common
                                    .alert('<spring:message code="sal.alert.msg.gstAmount" />'
                                            + DEFAULT_DELIMITER
                                            + '<b>'
                                            + msg
                                            + '</b>');
                        });
        $('#btnViewHistory').click(function() {
            fn_doViewHistory_Click();
        });
    });

    function fn_doViewHistory_Click() {
        var pram = "?srvCntrctId=0&ordId=${salesOrderId}";

        Common.popupDiv("/sales/membershipRental/paymentViewHistoryPop.do"
                + pram, null, null, true, '_ViewHistoryDiv1');
    }

    function fn_excludeGstAmt() {
        //Amount before GST
        var oldPrice = $('#orgOrdPrice').val();
        var newPrice = $('#ordPrice').val();
        var oldRental = $('#orgOrdRentalFees').val();
        var newRental = $('#ordRentalFees').val();
        var oldPv = $('#ordPv').val();
        //Amount of GST applied
        var oldPriceGST = fn_calcGst(oldPrice);
        var newPriceGST = fn_calcGst(newPrice);
        var oldRentalGST = fn_calcGst(oldRental);
        var newRentalGST = fn_calcGst(newRental);
        var newPv = $('#ordPvGST').val();

        if (APP_TYPE_ID != '66') {
            oldPriceGST = Math.floor(oldPriceGST / 10) * 10;
            newPriceGST = Math.floor(newPriceGST / 10) * 10;
        }

        $('#orgOrdPrice').val(oldPriceGST);
        $('#ordPrice').val(newPriceGST);
        $('#orgOrdRentalFees').val(oldRentalGST);
        $('#ordRentalFees').val(newRentalGST);
        $('#ordPv').val(newPv);

        $('#pBtnCal').addClass("blind");
    }

    function fn_clearOrderSalesman() {
        $('#modSalesmanId').val('');
        $('#modSalesmanCd').val('');
        $('#modSalesmanType').val('');
        $('#modSalesmanTypeId').val('');
        $('#modSalesmanName').val('');
        $('#modSalesmanIc').val('');
        $('#modOrderDeptCode').val('');
        $('#modDeptMemId').val('');
        $('#modOrderGrpCode').val('');
        $('#modGrpMemId').val('');
        $('#modOrderOrgCode').val('');
        $('#modOrgMemId').val('');
    }

    //ClearControl_RentPaySet_ThirdParty
    function fn_clearRentPay3thParty() {
        $('#scPC_ThrdParty').addClass("blind");
        $('#thrdPartyId').val('');
        $('#hiddenThrdPartyId').val('');
        $('#thrdPartyType').text('');
        $('#thrdPartyName').text('');
        $('#txtThrdPartyNric').text('');
        $('#thrdPartyNric').val('');
    }

    //ClearControl_RentPaySet_DD
    function fn_clearRentPaySetDD() {
        $('#scPC_DirectDebit').addClass("blind");

        $("#hiddenRentPayBankAccID").val('');
        $("#rentPayBankAccNo").text('');
        $("#rentPayBankAccNoEncrypt").val('');
        $("#rentPayBankAccType").text('');
        $("#accName").text('');
        $("#accBranch").text('');
        $("#accBank").text('');
        $("#accDdtChnl").text('');
        $("#hiddenAccBankId").val('');
    }

    //ClearControl_RentPaySet_CRC
    function fn_clearRentPaySetCRC() {
        $('#scPC_CrCard').addClass("blind");

        $("#hiddenRentPayCRCId").val('');
        $("#rentPayCRCNo").text('');
        $("#hiddenRentPayEncryptCRCNo").val('');
        $("#rentPayCRCType").text('');
        $("#rentPayCRCName").text('');
        $("#rentPayCRCExpiry").text('');
        $("#rentPayCRCBank").text('');
        $("#hiddenRentPayCRCBankId").val('');
        $("#rentPayCRCCardType").text('');
    }

    function fn_clearControlReject() {
        $("#chkRejectDate").prop("checked", false);
        $('#spRjctDate').text("");
        $('#spRejectReason').text("");
        $('#modStartDate').val('').removeAttr("disabled");
        $('#modRejectDate').val('').prop("disabled", true);
        $('#modRejectReason').val('').prop("disabled", true);
    }

    function fn_loadMailAddr(custAddId) {
        console.log("fn_loadMailAddr START");

        Common
                .ajax(
                        "GET",
                        "/sales/order/selectCustAddJsonInfo.do",
                        {
                            custAddId : custAddId
                        },
                        function(billCustInfo) {

                            if (billCustInfo != null) {

                                console.log("성공.");
                                console.log("hiddenBillAddId : "
                                        + billCustInfo.custAddId);

                                $("#modNewAddress").text(
                                        billCustInfo.fullAddress);
                                $("#modCustAddId").val(billCustInfo.custAddId);

                                Common
                                        .alert('<spring:message code="sal.alert.msg.addrSeleted" />'
                                                + DEFAULT_DELIMITER
                                                + '<spring:message code="sal.alert.msg.newAddrSelected" />');
                            }
                        });
    }

    function fn_loadOrderSalesman(memId, memCode) {

        console.log('fn_loadOrderSalesman memId:' + memId);
        console.log('fn_loadOrderSalesman memCd:' + memCode);

        fn_clearOrderSalesman();

        Common
                .ajax(
                        "GET",
                        "/sales/order/selectMemberByMemberIDCode.do",
                        {
                            memId : memId,
                            memCode : memCode
                        },
                        function(memInfo) {

                            if (memInfo == null || memInfo == 'undefined') {
                                //              Common.alert('<b>Member not found.</br>Your input member code : '+memCode+'</b>');
                                Common
                                        .alert('<spring:message code="sal.alert.msg.memNotFoundInput" arguments="'+memCode+'"/>');
                            } else {
                                $('#modSalesmanId').val(memInfo.memId);
                                $('#modSalesmanCd').val(memInfo.memCode);
                                $('#modSalesmanType').val(memInfo.codeName);
                                $('#modSalesmanTypeId').val(memInfo.memType);
                                $('#modSalesmanName').val(memInfo.name);
                                $('#modSalesmanIc').val(memInfo.nric);
                                $('#modOrderDeptCode').val(memInfo.deptCode);
                                $('#modDeptMemId').val(memInfo.lvl3UpId);
                                $('#modOrderGrpCode').val(memInfo.grpCode);
                                $('#modGrpMemId').val(memInfo.lvl2UpId);
                                $('#modOrderOrgCode').val(memInfo.orgCode);
                                $('#modOrgMemId').val(memInfo.lvl1UpId);
                            }
                        });
    }

    function isEditableNRIC() {
        var isEditable;

        Common
                .ajax(
                        "GET",
                        "/sales/order/checkNricEdit.do",
                        {
                            custId : CUST_ID
                        },
                        function(result) {

                            if (result != null) {
                                console.log('result.isEditable:'
                                        + result.isEditable);

                                isEditable = result.isEditable;

                                if (isEditable == false) {
                                    //                  Common.alert('<spring:message code="sal.alert.msg.actionRestriction" />' + DEFAULT_DELIMITER + "<b>Customer NRIC/Company No. for Customer ID : " + CUST_ID + " is disallowed to edit.</b>");
                                    Common
                                            .alert('<spring:message code="sal.alert.msg.actionRestriction" />'
                                                    + DEFAULT_DELIMITER
                                                    + '<spring:message code="sal.alert.msg.disallowCustidEdit" arguments="'+CUST_ID+'"/>');
                                }

                                return isEditable;
                            }
                        });
    }

    function fn_changeTab(tabNm) {

        if (tabNm == 'NRC' && isEditableNRIC() == false) {
            return false;
        }

        if (tabNm == 'PAY' && APP_TYPE_ID != '66' && APP_TYPE_ID != '1412') {
            /*
             var msg = "[" + ORD_NO + "] is [" + APP_TYPE_DESC + "] order.<br/>"
             + "Only rental order is allow to edit rental pay setting.";
             */
            var msg = '<spring:message code="sal.msg.rentOrdAllowEdit" arguments="'+ORD_NO+';'+APP_TYPE_DESC+'" argumentSeparator=";"/>';

            Common
                    .alert('<spring:message code="sal.alert.msg.actionRestriction" />'
                            + DEFAULT_DELIMITER + "<b>" + msg + "</b>");

            return false;
        }

        if (tabNm == 'DOC' && ORD_STUS_ID != '1' && ORD_STUS_ID != '4') {
            var msg = '<spring:message code="sal.alert.msg.notInActCompStusSubmm" />';

            Common
                    .alert('<spring:message code="sal.alert.msg.actionRestriction" />'
                            + DEFAULT_DELIMITER + "<b>" + msg + "</b>");

            $('#btnSaveDocSub').addClass("blind");
        }

        if (tabNm == 'PRM') {
            /*
            if(PROMO_CODE.indexOf('CMCPG160105') != -1 || PROMO_DESC.indexOf('EX-TRADE')    != -1 || PROMO_DESC.indexOf('EXTRADE')     != -1
            || PROMO_CODE.indexOf('CMCPG160401') != -1 || PROMO_DESC.indexOf('CMCPG160402') != -1 || PROMO_DESC.indexOf('CMCPG160403') != -1
            || PROMO_CODE.indexOf('CMCPG160404') != -1 || PROMO_DESC.indexOf('CMCPG160601') != -1 || PROMO_DESC.indexOf('CMCPG160602') != -1
            || PROMO_CODE.indexOf('CMCPG160605') != -1 || PROMO_DESC.indexOf('CMCPG160607') != -1) {
                var msg = "[" + ORD_NO + "] is under [" + PROMO_CODE + "] promotion.<br/>"
                        + "Edit promotion request is disallowed.";

                Common.alert('<spring:message code="sal.alert.msg.actionRestriction" />' + DEFAULT_DELIMITER + "<b>" + msg + "</b>");

                return false;
            }
             */
            if (ORD_STUS_ID != '1' && ORD_STUS_ID != '4') {
                var msg = '<spring:message code="This order is not in active/complete status.<br/>Edit promotion is disallowed." />';

                Common
                        .alert('<spring:message code="sal.alert.msg.actionRestriction" />'
                                + DEFAULT_DELIMITER + "<b>" + msg + "</b>");

                $('#btnSavePromo').addClass("blind");
            }
        }

        var vTit = 'Order Edit';

        if ($("#ordEditType option:selected").index() > 0) {
            vTit += ' - ' + $('#ordEditType option:selected').text();
        }

        $('#hTitle').text(vTit);

        if (tabNm == 'BSC') {
            $('#scBI').removeClass("blind");
            $('#aTabBI').click();
            fn_loadUpdateInfo(ORD_ID);

             if (ROLE_ID == 256 || ROLE_ID == 250 || ROLE_ID == 249
                    || ROLE_ID == 177
            ) {
                $('#modSalesmanCd').prop("disabled", true);
                $('#btnSalesmanPop').hide();
            }

        } else {
            $('#scBI').addClass("blind");
        }
        if (tabNm == 'MAL') {
            if (APP_TYPE_ID == '66') {
                $('#scMA').removeClass("blind");
                fn_loadBillGrpMailAddr(ORD_ID);
            } else {
                $('#scMA2').removeClass("blind");
                fn_loadMailAddress(ADDR_ID);
            }

            $('#aTabMA').click();
        } else {
            $('#scMA').addClass("blind");
            $('#scMA2').addClass("blind");
        }
        if (tabNm == 'CNT') {
            $('#scCP').removeClass("blind");
            $('#aTabMA').click();
            fn_loadBillGrpCntcPerson(ORD_ID);
        } else {
            $('#scCP').addClass("blind");
        }
        if (tabNm == 'NRC') {
            $('#scIC').removeClass("blind");
            $('#aTabCI').click();
            fn_loadNric(CUST_ID);
        } else {
            $('#scIC').addClass("blind");
        }
        if (tabNm == 'INS') {
            $('#scIN').removeClass("blind");
            $('#aTabIns').click();
            fn_loadInstallInfo(ORD_ID);
        } else {
            $('#scIN').addClass("blind");
        }

        if (tabNm == 'PAY') {

            $('#scPC').removeClass("blind");
            $('#aTabPay').click();
            fn_loadRentPaySetInfo(ORD_ID);

        } else {
            $('#scPC').addClass("blind");
        }
        if (tabNm == 'DOC') {
            $('#scDS').removeClass("blind");
            $('#aTabDS').click();
            AUIGrid.resize(modDocGridID, 960, 380);
            fn_selectEditDocSubmList(ORD_ID);
        } else {
            $('#scDS').addClass("blind");
        }
        if (tabNm == 'RFR') {
            $('#scRI').removeClass("blind");
            $('#aTabDS').click();
            fn_selectReferralList(ORD_NO);
        } else {
            $('#scRI').addClass("blind");
        }
        if (tabNm == 'PRM') {
            $('#scPR').removeClass("blind");
            $('#aTabMI').click();
            fn_loadPromotionInfo(ORD_ID);
        } else {
            $('#scPR').addClass("blind");
        }
        if (tabNm == 'GST') {
            $('#scGC').removeClass("blind");
            $('#aTabGC').click();
            fn_loadGstCert(ORD_ID);
        } else {
            $('#scGC').addClass("blind");
        }
    }

    function fn_loadGstCert(ordId) {
        Common.ajax("GET", "/sales/order/selectGSTCertInfo.do", {
            salesOrderId : ordId
        }, function(result) {

            if (result != null) {
                $('#existData').val("Y");

                $('#eurcId').val(result.eurcId);
                $('#eurcRliefAppTypeId').val(result.eurcRliefAppTypeId);
                $('#eurcRliefTypeId').val(result.eurcRliefTypeId);

                $('#certRefNo').val(result.eurcRefNo);
                $('#certRefDt').val(result.eurcRefDt);
                $('#txtCertCustRgsNo').val(result.eurcCustRgsNo);
                $('#txtCertRemark').val(result.eurcRem);

                if (FormUtil.isNotEmpty(result.atchFileGrpId)
                        && result.atchFileGrpId != '0') {
                    $('#btnDownGstCert').removeClass("blind");

                    fn_getGstCertFileDown(result.atchFileGrpId);
                }
            } else {
                if (APP_TYPE_ID == '66') {
                    $('#eurcRliefAppTypeId').val('1374');
                } else if (APP_TYPE_ID == '67' || APP_TYPE_ID == '68') {
                    $('#eurcRliefAppTypeId').val('1373');
                }
            }
        });
    }

    function fn_getGstCertFileDown(atchFileGrpId) {
        Common.ajax("GET", "/sales/order/gstCertFileDown.do", {
            atchFileGrpId : atchFileGrpId
        }, function(result) {

            if (result != null && result.files.length == 1) {

                var fileInfo = result.files[0];

                $('#subPath').val(fileInfo.fileSubPath);
                $('#fileName').val(fileInfo.physiclFileName);
                $('#orignlFileNm').val(fileInfo.atchFileName);
            }
        });
    }

    function fn_loadPromotionPrice(promoId, stkId) {

        if (GST_CHK == '1') {
            $('#pBtnCal').removeClass("blind");
        } else {
            $('#pBtnCal').addClass("blind");
        }

        if (APP_TYPE_ID != 66) {
            SRV_PAC_ID = 0;
        }
        Common.ajax("GET",
                "/sales/order/selectProductPromotionPriceByPromoStockID.do", {
                    promoId : promoId,
                    stkId : stkId,
                    srvPacId : SRV_PAC_ID
                }, function(promoPriceInfo) {

                    if (promoPriceInfo != null) {

                        $("#ordPrice").val(promoPriceInfo.orderPricePromo);
                        $("#ordPv").val(promoPriceInfo.orderPVPromo);
                        $("#ordPvGST").val(promoPriceInfo.orderPVPromoGST);
                        $("#ordRentalFees").val(
                                promoPriceInfo.orderRentalFeesPromo);
                        $("#orgOrdRentalFees").val(
                                promoPriceInfo.normalRentalFees);
                        /*
                         $("#orgOrdPrice").val(promoPriceInfo.orderPrice);
                         $("#orgOrdPv").val(promoPriceInfo.orderPV);
                         */
                        $("#promoDiscPeriodTp").val(
                                promoPriceInfo.promoDiscPeriodTp);
                        $("#promoDiscPeriod").val(
                                promoPriceInfo.promoDiscPeriod);
                    }
                });
    }

    function fn_loadPromotionInfo(ordId) {
        Common
                .ajax(
                        "GET",
                        "/sales/order/selectBasicInfoJson.do",
                        {
                            salesOrderId : ordId
                        },
                        function(basicInfo) {

                            if (basicInfo != null) {
                                var promoId = basicInfo.ordPromoId;
                                var stkId = basicInfo.stockId;

                                var custTypeVal = basicInfo.custTypeId;
                                var empChk = basicInfo.empChk;
                                var exTrade = basicInfo.exTrade;

                                $('#prdName').text(
                                        '(' + basicInfo.stockCode + ') '
                                                + basicInfo.stockDesc);
                                $('#ordPrice').val(basicInfo.ordAmt);
                                $('#ordRentalFees').val(basicInfo.ordMthRental);
                                $('#ordPv').val(basicInfo.ordPv);

                                $('#orgOrdRentalFees').val(basicInfo.norRntFee);

                                $("#promoDiscPeriodTp").val(
                                        basicInfo.promoDiscPeriodTp);
                                $("#promoDiscPeriod").val(
                                        basicInfo.promoDiscPeriod);

                                $('#relatedNo')
                                        .val(basicInfo.ordPromoRelatedNo);

                                $('#promoId').val(promoId);
                                $('#stkId').val(stkId);

                                if (APP_TYPE_ID == 67 || APP_TYPE_ID == 68
                                        || APP_TYPE_ID == 144) {
                                    doGetComboData(
                                            '/sales/order/selectPromotionByAppTypeStock2.do',
                                            {
                                                appTypeId : APP_TYPE_ID,
                                                stkId : stkId,
                                                empChk : empChk,
                                                promoCustType : custTypeVal,
                                                exTrade : exTrade,
                                                srvPacId : SRV_PAC_ID
                                            }, promoId, 'ordPromo', 'S', ''); //Common Code
                                } else
                                    doGetComboData(
                                            '/sales/order/selectPromotionByAppTypeStock.do',
                                            {
                                                appTypeId : APP_TYPE_ID,
                                                stkId : stkId,
                                                empChk : empChk,
                                                promoCustType : custTypeVal,
                                                exTrade : exTrade,
                                                srvPacId : SRV_PAC_ID
                                            }, promoId, 'ordPromo', 'S', ''); //Common Code
                            }
                        });
    }

    function fn_loadRentPaySetInfo(ordId) {
        console.log("fn_loadRentPaySetInfo START");

        Common.ajax("GET", "/sales/order/selectRentPaySetInfo.do", {
            salesOrderId : ordId
        },
                function(rsltInfo) {

                    if (rsltInfo != null) {
                        if (rsltInfo.is3party == '1') {
                            $("#thrdParty").attr("checked", true);
                            $('#scPC_ThrdParty').removeClass("blind");
                            fn_loadThirdParty(rsltInfo.payerCustId, 1);
                        }

                        $("#rentPayId").val(rsltInfo.rentPayId);
                        $("#rentPayMode").val(rsltInfo.payModeId);

                        if (rsltInfo.payModeId == '131') {
                            $('#scPC_CrCard').removeClass("blind");
                            fn_loadCreditCard(rsltInfo.crcId);
                        }

                        else if (rsltInfo.payModeId == '132') {
                            $('#scPC_DirectDebit').removeClass("blind");
                            fn_loadBankAccount(rsltInfo.bankAccId);
                        }

                        $('#rentPayIC').val(rsltInfo.oldIc);
                        if (rsltInfo.rentPayApplyDt != '01/01/1900')
                            $('#modApplyDate').val(rsltInfo.rentPayApplyDt);
                        if (rsltInfo.rentPaySubmitDt != '01/01/1900')
                            $('#modSubmitDate').val(rsltInfo.rentPaySubmitDt);
                        if (rsltInfo.rentPayStartDt != '01/01/1900')
                            $('#modStartDate').val(rsltInfo.rentPayStartDt);

                        if (rsltInfo.rentPayRejctDt != '01/01/1900') {
                            $('#spRjctDate').text("*");
                            $('#spRejectReason').text("*");
                            $('#modRejectDate').val(rsltInfo.rentPayRejctDt);
                            $('#modRejectDate').removeAttr("disabled");
                            $('#modStartDate').val("").prop("disabled", true);
                            $('#modRejectReason').removeAttr("disabled");
                            $("#chkRejectDate").prop("checked", true);

                        }

                        $('#modPayTerm').val(rsltInfo.payTrm);

                        fn_loadRejectReasonList(rsltInfo.payModeId,
                                rsltInfo.failResnId)
                    }
                });
    }

    function fn_loadRejectReasonList(paymodeId, failReasonId) {

        var typeId = 0, separator = ' - ';

        if (paymodeId == '131') {
            typeId = 168;
        } else if (paymodeId == '132') {
            typeId = 170;
        }


        doGetComboCodeId('/common/selectReasonCodeList.do', {
            typeId : typeId,
            inputId : failReasonId,
            separator : separator
        }, '', 'modRejectReason', 'S'); //Reason Code
    }

    function fn_loadThirdPartyPop(InputCustID) {

        fn_clearRentPay3thParty();
        fn_clearRentPaySetCRC();
        fn_clearRentPaySetDD();
        fn_clearControlReject();

        $('#modApplyDate').val("${toDay}");
        $('#modSubmitDate').val('');
        $('#modStartDate').val('');
        Common.ajax("GET", "/sales/order/getInstallDetail.do", {
            ordId : ORD_ID
        }, function(result) {
            if (result.stusCodeId != "4" && result.modeId == "131") {
                $('#rentPayMode').val(131);
                $('#scPC_CrCard').removeClass("blind");

            } else {
                $('#rentPayMode').val('');
            }
        });

        if (InputCustID != CUST_ID) {
            fn_loadThirdParty(InputCustID, 1);
        } else {
            Common
                    .alert('<spring:message code="sal.alert.msginvalidThirdPartyId" />'
                            + DEFAULT_DELIMITER
                            + '<spring:message code="sal.alert.msg.plzInputPartyId" arguments="'+InputCustID+'"/>');
        }
    }

    function fn_loadThirdParty(custId, sMethd) {

        Common
                .ajax(
                        "GET",
                        "/sales/customer/selectCustomerJsonList",
                        {
                            custId : custId
                        },
                        function(result) {

                            if (result != null && result.length == 1) {

                                var custInfo = result[0];

                                $('#hiddenThrdPartyId').val(custInfo.custId);
                                $('#thrdPartyId').val(custInfo.custId);
                                $('#thrdPartyType').text(custInfo.codeName1);
                                $('#thrdPartyName').text(custInfo.name);
                                $('#txtThrdPartyNric').text(custInfo.nric);
                                $('#thrdPartyNric').val(custInfo.nric);
                            } else {
                                if (sMethd == 2) {
                                    Common
                                            .alert('<spring:message code="sal.alert.msg.thirdPartyNotFoundmsg" />'
                                                    + DEFAULT_DELIMITER
                                                    + '<spring:message code="sal.alert.msg.thirdPartyNotFoundInput" arguments="'+custId+'"/>');
                                }
                            }
                        });

        $('#scPC_ThrdParty').removeClass("blind");
    }

    function fn_loadCreditCardPop(crcId) {
        console.log("fn_loadCreditCardPop START");
        //hiddenRentPayCRCId
        fn_clearRentPaySetCRC();
        fn_loadCreditCard(crcId);
        $('#scPC_CrCard').removeClass("blind");

        fn_clearControlReject();
        $('#modApplyDate').val("${toDay}");
        $('#modSubmitDate').val('');
        $('#modStartDate').val('');
    }

    function fn_loadCreditCard(custCrcId) {
        console.log("fn_loadCreditCard START");

        Common
                .ajax("GET",
                        "/sales/order/selectCustomerCreditCardDetailView.do", {
                            getparam : custCrcId
                        }, function(rsltInfo) {
                            if (rsltInfo != null) {
                                $("#hiddenRentPayCRCId")
                                        .val(rsltInfo.custCrcId);
                                $("#rentPayCRCNo").text(
                                        rsltInfo.decryptCRCNoShow);
                                $("#hiddenRentPayEncryptCRCNo").val(
                                        rsltInfo.custCrcNo);
                                $("#rentPayCRCType").text(rsltInfo.code);
                                $("#rentPayCRCName")
                                        .text(rsltInfo.custCrcOwner);
                                $("#rentPayCRCExpiry").text(
                                        rsltInfo.custCrcExpr);
                                $("#rentPayCRCBank").text(
                                        rsltInfo.bankCode + ' - '
                                                + rsltInfo.bankId);
                                $("#hiddenRentPayCRCBankId").val(
                                        rsltInfo.custCrcBankId);
                                $("#rentPayCRCCardType")
                                        .text(rsltInfo.codeName);
                            }
                        });
    }

    function fn_loadBankAccountPop(bankAccId) {
        fn_clearRentPaySetDD();
        fn_loadBankAccount(bankAccId);

        $('#scPC_DirectDebit').removeClass("blind");

        fn_clearControlReject();

        $('#modApplyDate').val('');
        $('#modSubmitDate').val('');
        $('#modStartDate').val('');
        //$('#rentPayMode').val('');

        if (!FormUtil.IsValidBankAccount($('#hiddenRentPayBankAccID').val(), $(
                '#rentPayBankAccNo').val())) {
            fn_clearRentPaySetDD();
            $('#scPC_DirectDebit').removeClass("blind");
            Common
                    .alert('<spring:message code="sal.alert.title.invalidBankAcc" />'
                            + DEFAULT_DELIMITER
                            + '<spring:message code="sal.alert.msg.invalidAccForAutoDebit" />');
        }
    }

    function fn_loadBankAccount(bankAccId) {
        console.log("fn_loadBankAccount START");

        Common.ajax("GET", "/sales/order/selectCustomerBankDetailView.do", {
            getparam : bankAccId
        }, function(rsltInfo) {

            if (rsltInfo != null) {
                $("#hiddenRentPayBankAccID").val(rsltInfo.custAccId);
                $("#rentPayBankAccNo").text(rsltInfo.custAccNo);
                $("#rentPayBankAccNoEncrypt").val(rsltInfo.custEncryptAccNo);
                $("#rentPayBankAccType").text(rsltInfo.codeName);
                $("#accName").text(rsltInfo.custAccOwner);
                $("#accBranch").text(rsltInfo.custAccBankBrnch);
                $("#accBank").text(
                        rsltInfo.bankCode + ' - ' + rsltInfo.bankName);
                $("#accDdtChnl").text(rsltInfo.ddtChnl);
                $("#hiddenAccBankId").val(rsltInfo.custAccBankId);
            }
        });
    }

    function fn_loadInstallInfo(ordId) {
        console.log("fn_loadInstallInfo START");

        Common.ajax("GET", "/homecare/sales/selectInstallInfo.do", {
            salesOrderId : ordId
        }, function(instInfo) {

            if (instInfo != null) {
                $("#modInstallId").val(instInfo.installId);
                $("#dscBrnchId").val(instInfo.dscId);
                $("#modPreferInstDt").val(instInfo.preferInstDt);
                $("#modPreferInstTm").val(instInfo.preferInstTm);
                $("#modInstct").val(instInfo.instct);

                fn_loadInstallAddrInfo(instInfo.installAddrId);
                fn_loadInstallCntcInfo(instInfo.installCntcId);
            }
        });
    }

    function fn_loadInstallAddrInfo(custAddId) {
        console.log("fn_loadInstallAddrInfo START");

        Common.ajax("GET", "/homecare/sales/selectInstallAddrInfo.do", {
            custAddId : custAddId
        }, function(addrInfo) {

            if (addrInfo != null) {

                $("#modInstAddrDtl").text(addrInfo.addrDtl);
                $("#modInstStreet").text(addrInfo.street);
                $("#modInstArea").text(addrInfo.area);
                $("#modInstCity").text(addrInfo.city);
                $("#modInstPostCd").text(addrInfo.postcode);
                $("#modInstState").text(addrInfo.city);
                $("#modInstCnty").text(addrInfo.country);

                $("#modInstAreaId").val(addrInfo.areaId);
                $("#modInstCustAddId").val(addrInfo.custAddId);
                $("#modInstCustAddIdOld").val(addrInfo.custAddId);
            }
        });
    }

    function fn_loadInstallAddrInfo2(custAddId) {
        console.log("fn_loadInstallAddrInfo START");

        Common.ajax("GET", "/sales/order/selectInstallAddrInfo.do", {
            custAddId : custAddId
        }, function(addrInfo) {

            if (addrInfo != null) {

                $("#modInstAddrDtl").text(addrInfo.addrDtl);
                $("#modInstStreet").text(addrInfo.street);
                $("#modInstArea").text(addrInfo.area);
                $("#modInstCity").text(addrInfo.city);
                $("#modInstPostCd").text(addrInfo.postcode);
                $("#modInstState").text(addrInfo.city);
                $("#modInstCnty").text(addrInfo.country);

                $("#modInstCustAddId").val(addrInfo.custAddId);
            }
        });
    }

    function fn_checkInstallResult(ordId) {
        Common.ajax("GET", "/sales/order/selectInstRsltCount.do", {
            salesOrdId : ordId
        }, function(rsltInfo) {
            if (rsltInfo != null) {
                console.log('fn_checkInstallResult:' + rsltInfo.cnt);
                return rsltInfo.cnt;
            }
        }, null, {
            async : false
        });
    }

    function fn_checkGSTZRLocation(areaId) {
        Common.ajax("GET", "/sales/order/selectGSTZRLocationCount.do", {
            areaId : areaId
        }, function(rsltInfo) {
            if (rsltInfo != null) {
                console.log('fn_checkGSTZRLocation:' + rsltInfo.cnt);
                return rsltInfo.cnt;
            }
        }, null, {
            async : false
        });
    }

    function fn_checkGSTZRLocationByAddrId(custAddId) {
        Common.ajax("GET", "/sales/order/selectGSTZRLocationByAddrIdCount.do",
                {
                    custAddId : ordId
                }, function(rsltInfo) {
                    if (rsltInfo != null) {
                        console.log('fn_checkGSTZRLocationByAddrId:'
                                + rsltInfo.cnt);
                        return rsltInfo.cnt;
                    }
                }, null, {
                    async : false
                });
    }

    function fn_loadInstallAddrInfoNew(custAddId) {
        console.log("fn_loadInstallAddrInfoNew START");

        $("#modInstCustAddId").val(custAddId);

        var addrIdOld = $("#modInstCustAddIdOld").val();
        var addrIdNew = $("#modInstCustAddId").val();

        if (APP_TYPE_ID == '67' || APP_TYPE_ID == '68') {

            if (fn_checkInstallResult(ORD_ID) == 0) {

                if (fn_checkGSTZRLocation($("#modInstAreaId").val()) > 0) {

                    if (fn_checkGSTZRLocationByAddrId(addrIdOld) > 0) {
                        $("#modInstCustAddIdOld").val(addrIdNew);
                        fn_loadInstallAddrInfo2(addrIdNew);
                    } else {
                        Common
                                .alert('<spring:message code="sal.alert.msg.changeFailed" />'
                                        + DEFAULT_DELIMITER
                                        + '<spring:message code="sal.alert.msg.zeroRateAreaCnntChng" />');
                    }
                } else {
                    if (fn_checkGSTZRLocationByAddrId(addrIdOld) > 0) {
                        Common
                                .alert('<spring:message code="sal.alert.msg.changeFailed" />'
                                        + DEFAULT_DELIMITER
                                        + '<spring:message code="sal.alert.msg.nonZeroRateAreaCnntChng" />');
                    } else {
                        $("#modInstCustAddIdOld").val(addrIdNew);
                        fn_loadInstallAddrInfo2(addrIdNew);
                    }
                }
            } else {
                $("#modInstCustAddIdOld").val(addrIdNew);
                fn_loadInstallAddrInfo2(addrIdNew);
            }
        } else {
            $("#modInstCustAddIdOld").val(addrIdNew);
            fn_loadInstallAddrInfo2(addrIdNew);
        }
    }

    function fn_loadInstallCntcInfo(custCntcId) {
        console.log("fn_loadInstallCntcInfo START");

        Common.ajax("GET", "/homecare/sales/selectInstallCntcInfo.do", {
            custCntcId : custCntcId
        }, function(cntcInfo) {

            if (cntcInfo != null) {
                $("#modInstCntcName").text(cntcInfo.name1);
                $("#modInstCntcInit").text(cntcInfo.code);
                $("#modInstCntcGender").text(cntcInfo.gender);
                $("#modInstCntcNric").text(cntcInfo.nric);
                $("#modInstCntcDob").text(cntcInfo.dob);
                $("#modInstCntcRace").text(cntcInfo.codeName);
                $("#modInstCntcEmail").text(cntcInfo.email);
                $("#modInstCntcDept").text(cntcInfo.dept);
                $("#modInstCntcPost").text(cntcInfo.pos);
                $("#modInstCntcTelM").text(cntcInfo.telM1);
                $("#modInstCntcTelR").text(cntcInfo.telR);
                $("#modInstCntcTelO").text(cntcInfo.telO);
                $("#modInstCntcTelF").text(cntcInfo.telf);

                $("#modInstCustCntcId").val(cntcInfo.custCntcId);
                //$("#modInstCustCntcIdOld").val(cntcInfo.custCntcId);
            }
        });
    }

    function fn_loadNric(custId) {
        console.log("fn_loadNric START");

        Common.ajax("GET", "/sales/order/selectCustomerInfo.do", {
            custId : custId
        }, function(resultInfo) {

            if (resultInfo != null) {

                $("#modCustNricOld").val(resultInfo.nric);
                $("#modCustNric").val(resultInfo.nric);
                $("#modCustGender").val(resultInfo.gender);
                $("#modNationality").val(resultInfo.nation);
                $("#modCustType").val(resultInfo.typeId);
            }
        });
    }

    function fn_loadCntcPerson(custCntcId) {
        console.log("fn_loadCntcPerson START");

        Common
                .ajax(
                        "GET",
                        "/sales/order/selectCustCntcJsonInfo.do",
                        {
                            custCntcId : custCntcId
                        },
                        function(custCntcInfo) {

                            if (custCntcInfo != null) {
                                console.log('custCntcInfo.custCntcId:'
                                        + custCntcInfo.custCntcId);

                                var vInit = FormUtil.isEmpty(custCntcInfo.code) ? ""
                                        : custCntcInfo.code;

                                $("#modCntcPersonNew").text(
                                        vInit + ' ' + custCntcInfo.name1);
                                $("#modCntcMobNoNew").text(custCntcInfo.telM1);
                                $("#modCntcResNoNew").text(custCntcInfo.telR);
                                $("#modCntcOffNoNew").text(custCntcInfo.telO);
                                $("#modCntcFaxNoNew").text(custCntcInfo.telf);

                                $("#modCustCntcId")
                                        .val(custCntcInfo.custCntcId);

                                Common
                                        .alert('<spring:message code="sal.alert.msg.contactPersonChnged" />'
                                                + DEFAULT_DELIMITER
                                                + '<spring:message code="sal.alert.msg.newCntcSeleted" />');
                            }
                        });
    }

    function fn_loadBillGrpCntcPerson(ordId) {
        Common.ajax("GET", "/homecare/sales/selectBillGrpCntcPersonJson.do", {
            salesOrdId : ordId
        }, function(cntcPerInfo) {

            if (cntcPerInfo != null) {

                $('#modCustId2').val(cntcPerInfo.custBillCustId);
                $('#modBillGroupId2').val(cntcPerInfo.custBillId);
                $('#modBillGroupNo2').text(cntcPerInfo.custBillGrpNo);
                $('#modTotalOrder2').text(cntcPerInfo.totOrder);

                $('#modCntcPerson').text(
                        cntcPerInfo.custAddInfo.code + ' '
                                + cntcPerInfo.custAddInfo.name1);
                $('#modCntcMobNo').text(cntcPerInfo.custAddInfo.telM1);
                $('#modCntcOffNo').text(cntcPerInfo.custAddInfo.telO);
                $('#modCntcResNo').text(cntcPerInfo.custAddInfo.telR);
                $('#modCntcFaxNo').text(cntcPerInfo.custAddInfo.telf);

                $('#modCustCntcIdOld').val(cntcPerInfo.custAddInfo.custCntcId);
            }
        });
    }

    function fn_loadBillGrpMailAddr(ordId) {
        Common.ajax("GET", "/sales/order/selectBillGrpMailingAddrJson.do", {
            salesOrdId : ordId
        }, function(mailAddrInfo) {

            if (mailAddrInfo != null) {

                $('#modCustId').val(mailAddrInfo.custBillCustId);
                $('#modBillGroupId').val(mailAddrInfo.custBillId);
                $('#modBillGroupNo').text(mailAddrInfo.custBillGrpNo);
                $('#modTotalOrder').text(mailAddrInfo.totOrder);
                $('#modAddress').text(mailAddrInfo.fullAddress);

                $('#modCustAddIdOld').val(mailAddrInfo.custBillAddId);
            }
        });
    }

    function fn_loadMailAddress(custAddId) {
        Common.ajax("GET", "/sales/order/selectCustAddJsonInfo.do", {
            custAddId : custAddId
        }, function(mailAddrInfo) {

            if (mailAddrInfo != null) {

                $('#txtMailAAddrDtl').text(mailAddrInfo.addrDtl);
                $('#txtMailStreet').text(mailAddrInfo.street);
                $('#txtMailArea').text(mailAddrInfo.area);
                $('#txtMailCity').text(mailAddrInfo.city);
                $('#txtMailPostcode').text(mailAddrInfo.postcode);
                $('#txtMailState').text(mailAddrInfo.state);
                $('#txtMailCountry').text(mailAddrInfo.country);

                $('#txtHiddenAddressID').val(mailAddrInfo.custAddId);
            }
        });
    }

    function fn_loadUpdateInfo(ordId) {
        Common.ajax("GET", "/homecare/sales/selectBasicInfoJson.do", {
            salesOrderId : ordId
        }, function(basicInfo) {

            if (basicInfo != null) {

                if (basicInfo.appTypeId == '68') {
                    $('#modInstallDur').removeAttr("disabled").val(
                            basicInfo.instlmtPriod);
                }

                if (basicInfo.appTypeId == '145') {
                	$('span', '#salManCodeLbl').empty().remove();
                }

                $('#modSalesOrdNo').val(basicInfo.ordNo);

                $('#modAppTypeId').val(basicInfo.appTypeId);
                $('#modOrdRefNo').val(basicInfo.ordRefNo);
                $('#modOrdPoNo').val(basicInfo.ordPoNo);
                $('#modOrdRem').val(basicInfo.ordRem);

                $('#modSalesmanId').val(basicInfo.ordMemId);
                $('#modSalesmanCd').val(basicInfo.ordMemCode);
                $('#modSalesmanType').val(basicInfo.ordMemTypeName);
                $('#modSalesmanTypeId').val(basicInfo.ordMemTypeId);
                $('#modSalesmanName').val(basicInfo.ordMemName);
                $('#modSalesmanIc').val(basicInfo.ordMemNric);
                $('#modOrderDeptCode').val(basicInfo.ordDeptCode);
                $('#modDeptMemId').val(basicInfo.ordHmId);
                $('#modOrderGrpCode').val(basicInfo.ordGrpCode);
                $('#modGrpMemId').val(basicInfo.ordSmId);
                $('#modOrderOrgCode').val(basicInfo.ordOrgCode);
                $('#modOrgMemId').val(basicInfo.ordGmId);

                $('#modKeyInBranch').val(basicInfo.keyinBrnchId);
            }
        });
    }

    function fn_validDocSubmission() {
        var isValid = true, msg = "";

        for (var i = 0; i < AUIGrid.getRowCount(modDocGridID); i++) {
            var isChk = AUIGrid.getCellValue(modDocGridID, i, "chkfield");
            var qty = AUIGrid.getCellValue(modDocGridID, i, "docCopyQty");

            if (isChk == 1 && (FormUtil.isEmpty(qty) || qty == 0)) {
                isValid = false;
                msg = '<spring:message code="sal.alert.msg.plzKeyinQtySelDoc" />';
                break;
            }
        }

        return isValid;
    }

    function fn_validNric() {
        var isValid = true, msg = "";

        if (FormUtil.isEmpty($('#modCustNric').val().trim())) {
            isValid = false;
            msg += '<spring:message code="sal.alert.msg.plzKeyInCustNricComNo" />';
        } else {

            var existNric = fn_validNricExist();

            console.log('existNric:' + existNric);

            if (existNric > 0) {
                isValid = false;
                msg += '<spring:message code="sal.alert.msg.existingCustId" />'
                        + existNric;

            } else {
                if ($('#modCustType').val().trim() == '964') {
                    var ic = $('#modCustNric').val().trim();
                    var lastDigit = parseInt(ic.charAt(ic.length - 1));

                    if (lastDigit != null) {
                        if ($('#modCustGender').val() == "F") {
                            if (lastDigit % 2 != 0) {
                                isValid = false;
                                msg += '<spring:message code="sal.alert.msg.invalidNric" />';
                            }
                        } else {
                            if (lastDigit % 2 == 0) {
                                isValid = false;
                                msg += '<spring:message code="sal.alert.msg.invalidNric" />';
                            }
                        }
                    }
                }
            }
        }

        if (!isValid)
            Common
                    .alert('<spring:message code="sal.alert.msg.saveValidation" />'
                            + DEFAULT_DELIMITER + "<b>" + msg + "</b>");

        console.log('msg:' + msg);
        console.log('isValid:' + isValid);

        return isValid;
    }

    function fn_validNricExist() {

        var exCustId = 0;

        Common.ajax("GET", "/sales/order/checkNricExist.do", $('#frmNric')
                .serializeJSON(), function(result) {

            console.log('result:' + result);

            if (result != null) {
                console.log('result.custId:' + result.custId);

                exCustId = result.custId;
            }

        }, null, {
            async : false
        });

        return exCustId;
    }

    function fn_validCert() {
        var isValid = true, msg = "";

        if (FormUtil.checkReqValue($('#certRefNo'))) {
            isValid = false;
            msg += '<spring:message code="sal.alert.msg.plzKeyinCertRefNo" />';
        }
        if (FormUtil.isEmpty($('#certRefDt').val().trim())) {
            isValid = false;
            msg += '<spring:message code="sal.alert.msg.plzSelCertRefDate" />';
        }
        if (FormUtil.checkReqValue($('#certRefFile'))) {
            isValid = false;
            msg += '<spring:message code="sal.alert.msg.noCertUploaded" />';
        }

        if (!isValid)
            Common
                    .alert('<spring:message code="sal.alert.msg.saveCertSummary" />'
                            + DEFAULT_DELIMITER + "<b>" + msg + "</b>");

        return isValid;
    }

    function fn_validInstallInfo() {
        var isValid = true, msg = "";

        if (FormUtil.isEmpty($('#modInstCustAddId').val())) {
            isValid = false;
            msg += '<spring:message code="sal.alert.msg.plzSelInstallAddr" />';
        }

        if (FormUtil.isEmpty($('#modInstCustCntcId').val())) {
            isValid = false;
            msg += '<spring:message code="sal.alert.msg.plzSelInstallContact" />';
        }

      /*   if ($("#dscBrnchId option:selected").index() <= 0) {
            isValid = false;
            msg += '<spring:message code="sal.alert.msg.plzSelDscBrnch" />';
        } */

        if (FormUtil.isEmpty($('#modPreferInstDt').val().trim())) {
            isValid = false;
            msg += '<spring:message code="sal.alert.msg.plzSelPreferInstDate" />';
        }

        if (FormUtil.isEmpty($('#modPreferInstTm').val().trim())) {
            isValid = false;
            msg += '<spring:message code="sal.alert.msg.plzSelPreferInstTime" />';
        }

        if (FormUtil.isEmpty($('#modInstct').val().trim())) {
            isValid = false;
            msg += '<spring:message code="sal.alert.msg.plzKeyinSpecialInstruction" />';
        }

        if (!isValid)
            Common
                    .alert('<spring:message code="sal.alert.msg.ordUpdSummary" />'
                            + DEFAULT_DELIMITER + "<b>" + msg + "</b>");

        Common.ajaxSync("GET", "/sales/customer/checkBlackArea", { custAddId : $('#modInstCustAddId').val(),salesOrdId : ORD_ID}, function(result) {

            if(result == true){
                isValid = false;
                Common.alert('* The area is not under coverage for the product categories. Reinstall and HS is not allow.');
                return isValid;
            }
        });

        return isValid;
    }

    function fn_validPaymentChannel() {
        var isValid = true, msg = "";

        if ($('#thrdParty').is(":checked")) {
            if (FormUtil.isEmpty($('#hiddenThrdPartyId').val())) {
                isValid = false;
                msg += '<spring:message code="sal.alert.msg.plzSelThirdParty" />';
            }
        }

        if ($("#rentPayMode option:selected").index() <= 0) {
            isValid = false;
            msg += '<spring:message code="sal.alert.msg.plzSelRentPayMode" />';
        } else {
            if ($("#rentPayMode").val() == '131') {
                //CRC
                if (FormUtil.isEmpty($('#hiddenRentPayCRCId').val())) {
                    isValid = false;
                    msg += '<spring:message code="sal.alert.msg.plzSelCrdCard" />';
                } else {
                    if (FormUtil.isEmpty($('#hiddenRentPayCRCBankId').val())
                            || $('#hiddenRentPayCRCBankId').val() == 0) {
                        isValid = false;
                        msg += '<spring:message code="sal.alert.msg.invalidCrdCardIssuebank" />';
                    }
                }
            } else if ($("#rentPayMode").val() == '132') {
                //DD
                if (FormUtil.isEmpty($('#hiddenRentPayBankAccID').val())) {
                    isValid = false;
                    msg += '<spring:message code="sal.alert.msg.plzSelBankAccount" />';
                } else {
                    if (FormUtil.isEmpty($('#hiddenAccBankId').val())
                            || $('#hiddenAccBankId').val() == 0) {
                        isValid = false;
                        msg += '<spring:message code="sal.alert.msg.invalidBankAccIssueBank" />';
                    }
                }
            }
        }

        var arrAppDate = $('#modApplyDate').val().split('/');
        var arrSubDate = $('#modSubmitDate').val().split('/');
        var arrStaDate = $('#modStartDate').val().split('/');
        var arrRjtDate = $('#modRejectDate').val().split('/');

        var sAppDate = arrAppDate[2] + arrAppDate[1] + arrAppDate[0];
        var sSubDate = arrSubDate[2] + arrSubDate[1] + arrSubDate[0];
        var sStaDate = arrStaDate[2] + arrStaDate[1] + arrStaDate[0];
        var sRjtDate = arrRjtDate[2] + arrRjtDate[1] + arrRjtDate[0];

        console.log('sAppDate : ' + sAppDate);
        console.log('sSubDate : ' + sSubDate);
        console.log('sStaDate : ' + sStaDate);
        console.log('sRjtDate : ' + sRjtDate);

        if (FormUtil.isEmpty($('#modApplyDate').val())) {
            isValid = false;
            msg += '<spring:message code="sal.alert.msg.applyDtRequired" />';
        } else {
            if (FormUtil.isNotEmpty($('#modSubmitDate').val())) {
                if (sSubDate < sAppDate) {
                    isValid = false;
                    msg += '<spring:message code="sal.alert.msg.submitDtmustLaster" />';
                }
            }
        }

        if (FormUtil.isNotEmpty($('#modStartDate').val())) {
            if (FormUtil.isEmpty($('#modSubmitDate').val())) {
                isValid = false;
                msg += '<spring:message code="sal.alert.msg.submitDtRequired" />';
            } else {
                if (sStaDate < sSubDate) {
                    isValid = false;
                    msg += '<spring:message code="sal.alert.msg.startDtMustLaster" />';
                }
            }
        }

        if ($('#chkRejectDate').is(":checked")) {
            if (FormUtil.isEmpty($('#modRejectDate').val())) {
                isValid = false;
                msg += '<spring:message code="sal.alert.msg.rjtDtIsReq" />';
            } else {
                if (FormUtil.isEmpty($('#modSubmitDate').val())) {
                    isValid = false;
                    msg += '<spring:message code="sal.alert.msg.submitDtRequired" />';
                } else {
                    if (sRjtDate < sSubDate) {
                        isValid = false;
                        msg += '<spring:message code="sal.alert.msg.rjtDtMustLater" />';
                    }
                }
            }

            if ($("#modRejectReason option:selected").index() <= 0) {
                isValid = false;
                msg += '<spring:message code="sal.alert.msg.rjtSelRjtReason" />';
            }
        }

        if (!isValid)
            Common
                    .alert('<spring:message code="sal.alert.msg.ordUpdSummary" />'
                            + DEFAULT_DELIMITER + "<b>" + msg + "</b>");

        return isValid;
    }



    function fn_validCntcPerson() {
        var isValid = true, msg = "";

        if (FormUtil.isEmpty($('#modCustCntcId').val().trim())) {
            isValid = false;
            msg += '<spring:message code="sal.alert.msg.plzSelCntcPerson" />';
        }

        if (FormUtil.isEmpty($('#modRem2').val().trim())) {
            isValid = false;
            msg += '<spring:message code="sal.alert.msg.plzKeyinReasonUpdate" />';
        } else {
            if (FormUtil.byteLength($('#modRem2').val().trim()) > 200) {
                isValid = false;
                msg += '<spring:message code="sal.alert.msg.rsnUpdValidTwoHundChar" />';
            }
        }

        if (!isValid)
            Common.alert('<spring:message code="sal.alert.msg.updSummary" />'
                    + DEFAULT_DELIMITER + "<b>" + msg + "</b>");

        return isValid;
    }

    function fn_validPromoPriceInfo() {
        var isValid = true, msg = "";

        if ($("#ordPromo option:selected").index() <= 0) {
            isValid = false;
            msg += '<spring:message code="sal.alert.msg.selPromoOption" />';
        }
        if ($('#promoId').val().trim() == $('#ordPromo').val().trim()) {
            isValid = false;
            msg += '<spring:message code="sal.alert.msg.selOrdPromoOption" />';
        }
        if (!$('#pBtnCal').hasClass("blind")) {
            isValid = false;
            msg += '<spring:message code="sal.alert.msg.pressCalBtn" />';
        }

        if (!isValid)
            Common
                    .alert('<spring:message code="sal.alert.msg.ordUpdSummary" />'
                            + DEFAULT_DELIMITER + "<b>" + msg + "</b>");

        return isValid;
    }

    function fn_validMailingAddress() {
        var isValid = true, msg = "";

        if (FormUtil.isEmpty($('#modCustAddId').val().trim())) {
            isValid = false;
            msg += '<spring:message code="sal.alert.msg.plzSeltheAddr" />';
        }

        if (FormUtil.isEmpty($('#modRem').val().trim())) {
            isValid = false;
            msg += '<spring:message code="sal.alert.msg.plzKeyinReasonUpdate" />';
        } else {
            if (FormUtil.byteLength($('#modRem').val().trim()) > 200) {
                isValid = false;
                msg += '<spring:message code="sal.alert.msg.rsnUpdValidTwoHundChar" />';
            }
        }

        if (!isValid)
            Common.alert('<spring:message code="sal.alert.msg.updSummary" />'
                    + DEFAULT_DELIMITER + "<b>" + msg + "</b>");

        return isValid;
    }

    function fn_validMailingAddress2() {
        var isValid = true, msg = "";

        if (FormUtil.isEmpty($('#txtHiddenAddressID').val().trim())) {
            isValid = false;
            msg += '<spring:message code="sal.msg.plzSelAddr" />';
        }

        if (!isValid)
            Common.alert('<spring:message code="sal.alert.msg.updSummary" />'
                    + DEFAULT_DELIMITER + "<b>" + msg + "</b>");

        return isValid;
    }

    function fn_validBasicInfo() {
        var isValid = true, msg = "";

        if ($('#modAppTypeId').val() == '68'
                && FormUtil.isEmpty($('#modInstallDur').val().trim())) {
            isValid = false;
            msg += '<spring:message code="sal.alert.msg.plzKeyinInstDuration" />';
        }

        if (FormUtil.isNotEmpty($('#modSalesmanTypeId').val().trim())) {
            if ($('#modSalesmanTypeId').val().trim() == 1
                    || $('#modSalesmanTypeId').val().trim() == 2) {
                if (FormUtil.isEmpty($('#modOrderDeptCode').val().trim())
                        || FormUtil.isEmpty($('#modOrderGrpCode').val().trim())
                        || FormUtil.isEmpty($('#modOrderOrgCode').val().trim())) {
                    isValid = false;
                    var memType = "";

                    if ($('#modSalesmanTypeId').val().trim() == 1) {
                        memType = "HP";
                    } else if ($('#modSalesmanTypeId').val().trim() == 2) {
                        memType = "Cody";
                    }

                    //                  msg += "* The " + memType + " department/group/organization code is missing.<br/>";
                    msg += '<spring:message code="sal.alert.grpCodeMissing" arguments="'+memType+'"/>';
                }
            }
        } else {
            if ($('#modAppTypeId').val() != '145') {
                isValid = false;
                msg += '<spring:message code="sal.alert.msg.plzSelectSalesman" />';
            }
        }

        if ($("#modKeyInBranch option:selected").index() <= 0) {
            isValid = false;
            msg += '<spring:message code="sal.alert.msg.plzSelTheKeyinbrnch" />';
        }

        if (!isValid)
            Common
                    .alert('<spring:message code="sal.alert.msg.ordUpdSummary" />'
                            + DEFAULT_DELIMITER + "<b>" + msg + "</b>");

        return isValid;
    }

    function fn_doSaveBasicInfo() {
        console.log('!@# fn_doSaveBasicInfo START');

        $('#hiddenOrdEditType').val($('#ordEditType').val());

        Common
                .ajax(
                        "POST",
                        "/homecare/sales/updateOrderBasinInfo.do",
                        $('#frmBasicInfo').serializeJSON(),
                        function(result) {

                            Common.alert(
                                    '<spring:message code="sal.alert.msg.updSummary" />'
                                            + DEFAULT_DELIMITER + "<b>"
                                            + result.message + "</b>",
                                    fn_reloadPage);

                        },
                        function(jqXHR, textStatus, errorThrown) {
                            try {
                                //                  Common.alert("Data Preparation Failed" + DEFAULT_DELIMITER + "<b>Saving data prepration failed.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
                                Common
                                        .alert('<spring:message code="sal.msg.dataPrepFail" />'
                                                + DEFAULT_DELIMITER
                                                + '<b><spring:message code="sal.alert.msg.savingDataPreprationFailed" /></b>');
                            } catch (e) {
                                console.log(e);
                            }
                        });
    }

    function fn_doSaveMailingAddress() {
        console.log('!@# fn_doSaveMailingAddress START');

        Common
                .ajax(
                        "POST",
                        "/sales/order/updateMailingAddress.do",
                        $('#frmMailAddr').serializeJSON(),
                        function(result) {

                            Common.alert(
                                    '<spring:message code="sal.alert.msg.mailingAddrUpdated" />'
                                            + DEFAULT_DELIMITER + "<b>"
                                            + result.message + "</b>",
                                    fn_reloadPage);

                        },
                        function(jqXHR, textStatus, errorThrown) {
                            try {
                                //                  Common.alert('<spring:message code="sal.msg.failToUpt" />' + DEFAULT_DELIMITER + "<b>Failed to update mailing address.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
                                Common
                                        .alert('<spring:message code="sal.msg.failToUpt" />'
                                                + DEFAULT_DELIMITER
                                                + '<b><spring:message code="sal.msg.failToUptMailAddr" /></b>');
                            } catch (e) {
                                console.log(e);
                            }
                        });
    }

    function fn_doSaveMailingAddress2() {
        console.log('!@# fn_doSaveMailingAddress2 START');

        Common
                .ajax(
                        "POST",
                        "/sales/order/updateMailingAddress2.do",
                        $('#frmMailAddr2').serializeJSON(),
                        function(result) {

                            Common.alert(
                                    '<spring:message code="sal.alert.msg.mailingAddrUpdated" />'
                                            + DEFAULT_DELIMITER + "<b>"
                                            + result.message + "</b>",
                                    fn_reloadPage);

                        },
                        function(jqXHR, textStatus, errorThrown) {
                            try {
                                //                  Common.alert('<spring:message code="sal.msg.failToUpt" />' + DEFAULT_DELIMITER + "<b>Failed to update mailing address.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
                                Common
                                        .alert('<spring:message code="sal.msg.failToUpt" />'
                                                + DEFAULT_DELIMITER
                                                + '<b><spring:message code="sal.msg.failToUptMailAddr" /></b>');
                            } catch (e) {
                                console.log(e);
                            }
                        });
    }

    function fn_doSaveCntcPerson() {
        console.log('!@# fn_doSaveCntcPerson START');

        Common
                .ajax(
                        "POST",
                        "/sales/order/updateCntcPerson.do",
                        $('#frmCntcPer').serializeJSON(),
                        function(result) {

                            Common.alert(
                                    '<spring:message code="sal.msg.cntcPerUpt" />'
                                            + DEFAULT_DELIMITER + "<b>"
                                            + result.message + "</b>",
                                    fn_reloadPage);

                        },
                        function(jqXHR, textStatus, errorThrown) {
                            try {
                                Common
                                        .alert('<spring:message code="sal.msg.failToUpt" />'
                                                + DEFAULT_DELIMITER
                                                + '<spring:message code="sal.msg.failToUptCntcPer" />');
                            } catch (e) {
                                console.log(e);
                            }
                        });
    }

    function fn_doSaveNric() {
        console.log('!@# fn_doSaveNric START');

        Common
                .ajax(
                        "POST",
                        "/sales/order/updateNric.do",
                        $('#frmNric').serializeJSON(),
                        function(result) {

                            Common.alert(
                                    '<spring:message code="sal.alert.msg.sucessUpdate" />'
                                            + DEFAULT_DELIMITER + "<b>"
                                            + result.message + "</b>",
                                    fn_reloadPage);

                        },
                        function(jqXHR, textStatus, errorThrown) {
                            try {
                                //                  Common.alert('<spring:message code="sal.msg.failToUpt" />' + DEFAULT_DELIMITER + "<b>Failed to save. Please try again later.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
                                Common
                                        .alert('<spring:message code="sal.msg.failToUpt" />'
                                                + DEFAULT_DELIMITER
                                                + '<b><spring:message code="sal.alert.msg.saveFail" /></b>');
                            } catch (e) {
                                console.log(e);
                            }
                        });
    }

    function fn_doSaveInstallInfo() {
        console.log('!@# fn_doSaveInstallInfo START');

        Common
                .ajax(
                        "POST",
                        "/homecare/sales/updateInstallInfo.do",
                        $('#frmInstInfo').serializeJSON(),
                        function(result) {

                            Common.alert(
                                    '<spring:message code="sal.alert.msg.updSummary" />'
                                            + DEFAULT_DELIMITER + "<b>"
                                            + result.message + "</b>",
                                    fn_reloadPage);

                        },
                        function(jqXHR, textStatus, errorThrown) {
                            try {
                                //                  Common.alert("Data Preparation Failed" + DEFAULT_DELIMITER + "<b>Saving data prepration failed.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
                                Common
                                        .alert('<spring:message code="sal.msg.dataPrepFail" />'
                                                + DEFAULT_DELIMITER
                                                + '<b><spring:message code="sal.alert.msg.savingDataPreprationFailed" /></b>');
                            } catch (e) {
                                console.log(e);
                            }
                        });
    }

    function fn_doSavePaymentChannel() {
        console.log('!@# fn_doSavePaymentChannel START');

        Common.ajax("POST", "/sales/order/updatePaymentChannel.do", $(
                '#payChanlForm').serializeJSON(), function(result) {

            Common.alert('<spring:message code="sal.alert.msg.updSummary" />'
                    + DEFAULT_DELIMITER + "<b>" + result.message + "</b>",
                    fn_reloadPage);

        }, function(jqXHR, textStatus, errorThrown) {
            try {
                //                  Common.alert("Data Preparation Failed" + DEFAULT_DELIMITER + "<b>Saving data prepration failed.<br/>"+"Error message : " + jqXHR.responseJSON.message + "</b>");
                Common.alert('<spring:message code="sal.msg.dataPrepFail" />'
                        + DEFAULT_DELIMITER
                        + "<b>Saving data prepration failed.</b>");
            } catch (e) {
                console.log(e);
            }
        });
    }

    function fn_doSaveDocSub() {
        console.log('!@# fn_doSaveDocSub START');

        var orderVO = {
            salesOrdId : ORD_ID,
            docSubmissionVOList : GridCommon.getEditData(modDocGridID)
        };

        Common
                .ajax(
                        "POST",
                        "/sales/order/saveDocSubmission.do",
                        orderVO,
                        function(result) {

                            Common
                                    .alert(
                                            '<spring:message code="sal.alert.msg.updSummary" />'
                                                    + DEFAULT_DELIMITER
                                                    + "<b>Order Number : "
                                                    + ORD_NO + "<br/>"
                                                    + result.message + "</b>",
                                            fn_reloadPage);

                        },
                        function(jqXHR, textStatus, errorThrown) {
                            try {
                                //                  Common.alert("Data Preparation Failed" + DEFAULT_DELIMITER + "<b>Saving data prepration failed.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
                                Common
                                        .alert('<spring:message code="sal.msg.dataPrepFail" />'
                                                + DEFAULT_DELIMITER
                                                + "<b>Saving data prepration failed.</b>");
                            } catch (e) {
                                console.log(e);
                            }
                        });
    }

    function fn_doSaveReferral() {
        console.log('!@# fn_doSaveReferral START');

        // 버튼 클릭시 cellEditCancel  이벤트 발생 제거. => 편집모드(editable=true)인 경우 해당 input 의 값을 강제적으로 편집 완료로 변경.
        AUIGrid.forceEditingComplete(modRfrGridID, null, false);

        var orderModifyVO = {
            salesOrdId : ORD_ID,
            gridReferralVOList : GridCommon.getEditData(modRfrGridID)
        };

        Common
                .ajax(
                        "POST",
                        "/sales/order/saveReferral.do",
                        orderModifyVO,
                        function(result) {

                            Common.alert(
                                    '<spring:message code="sal.alert.msg.newMemSaved" />'
                                            + DEFAULT_DELIMITER + "<b>"
                                            + result.message + "</b>",
                                    fn_reloadPage);

                        },
                        function(jqXHR, textStatus, errorThrown) {
                            try {
                                console.log("status : " + jqXHR.status);
                                console
                                        .log("code : "
                                                + jqXHR.responseJSON.code);
                                console.log("message : "
                                        + jqXHR.responseJSON.message);
                                console.log("detailMessage : "
                                        + jqXHR.responseJSON.detailMessage);

                                //              Common.alert("Failed To Save" + DEFAULT_DELIMITER + "<b>Failed to save new member. Please try again later.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
                                Common
                                        .alert('<spring:message code="sal.alert.title.saveFail" />'
                                                + DEFAULT_DELIMITER
                                                + '<spring:message code="sal.alert.msg.failToSaveNewMem" />');
                            } catch (e) {
                                console.log(e);
                            }
                        });
    }

    //LoadProductPrice
    function fn_loadProductPrice(stkId) {

        if (GST_CHK == '1') {
            $('#pBtnCal').removeClass("blind");
        } else {
            $('#pBtnCal').addClass("blind");
        }

        if (APP_TYPE_ID != 66) {
            SRV_PAC_ID = 0;
        }
        Common.ajax("GET", "/sales/order/selectStockPriceJsonInfo.do", {
            appTypeId : APP_TYPE_ID,
            stkId : stkId,
            srvPacId : SRV_PAC_ID
        }, function(stkPriceInfo) {

            if (stkPriceInfo != null) {

                console.log("성공.");

                var pvVal = stkPriceInfo.orderPV;
                var pvValGst = Math.floor(pvVal * (1 / 1.06))

                $("#ordPrice").val(stkPriceInfo.orderPrice);
                $("#ordPv").val(pvVal);
                $("#ordPvGST").val(pvValGst);
                $("#ordRentalFees").val(stkPriceInfo.orderRentalFees);
                $("#orgOrdRentalFees").val(stkPriceInfo.orderRentalFees);
                $("#ordPriceId").val(stkPriceInfo.priceId);

                $("#promoId").val('');
                $("#promoDiscPeriodTp").val('');
                $("#promoDiscPeriod").val('');
            }
        });
    }

    function fn_doSavePromoPriceInfo() {
        console.log('!@# fn_doSavePromoPriceInfo START');

        $('#promoDiscPeriodTp').removeAttr("disabled");
        if (APP_TYPE_ID == 66) {
            var salesOrderMVO = {
                salesOrdId : ORD_ID,
                promoId : $('#ordPromo').val().trim(),
                totAmt : $('#ordPrice').val().trim(),
                mthRentAmt : $('#ordRentalFees').val().trim(),
                totPv : $('#ordPv').val().trim(),
                discRntFee : $('#ordRentalFees').val().trim(),
                promoDiscPeriodTp : $('#promoDiscPeriodTp').val().trim(),
                promoDiscPeriod : $('#promoDiscPeriod').val().trim(),
                salesOrdNo : ORD_NO
            };
        } else {
            var salesOrderMVO = {
                salesOrdId : ORD_ID,
                promoId : $('#ordPromo').val().trim(),
                totAmt : $('#ordPrice').val().trim(),
                mthRentAmt : $('#ordRentalFees').val().trim(),
                totPv : $('#ordPv').val().trim(),
                discRntFee : $('#ordRentalFees').val().trim(),
                promoDiscPeriodTp : 0,
                promoDiscPeriod : 0,
                salesOrdNo : ORD_NO
            };
        }

        Common
                .ajax(
                        "POST",
                        "/sales/order/updatePromoPriceInfo.do",
                        salesOrderMVO,
                        function(result) {

                            Common.alert(
                                    '<spring:message code="sal.alert.msg.updSummary" />'
                                            + DEFAULT_DELIMITER + "<b>"
                                            + result.message + "</b>",
                                    fn_reloadPage);

                        },
                        function(jqXHR, textStatus, errorThrown) {
                            try {
                                console.log("status : " + jqXHR.status);
                                console
                                        .log("code : "
                                                + jqXHR.responseJSON.code);
                                console.log("message : "
                                        + jqXHR.responseJSON.message);
                                console.log("detailMessage : "
                                        + jqXHR.responseJSON.detailMessage);

                                //              Common.alert("Data Preparation Failed" + DEFAULT_DELIMITER + "<b>Saving data prepration failed.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
                                Common
                                        .alert('<spring:message code="sal.msg.dataPrepFail" />'
                                                + DEFAULT_DELIMITER
                                                + '<b><spring:message code="sal.alert.msg.savingDataPreprationFailed" /></b>');
                            } catch (e) {
                                console.log(e);
                            }
                        });
    }

    function fn_doSaveGstCertInfo() {
        console.log('!@# fn_doSaveGstCertInfo START');

        var gSTEURCertificateVO = {
            eurcId : $('#eurcId').val().trim(),
            eurcSalesOrdId : ORD_ID,
            eurcRefNo : $('#certRefNo').val().trim(),
            eurcRefDt : $('#certRefDt').val().trim(),
            eurcCustRgsNo : $('#txtCertCustRgsNo').val().trim(),
            eurcRem : $('#txtCertRemark').val().trim(),
            eurcRliefAppTypeId : APP_TYPE_ID,
            atchFileGrpId : $('#atchFileGrpId').val(),
            existData : $('#existData').val()
        };

        Common
                .ajax(
                        "POST",
                        "/sales/order/updateGstCertInfo.do",
                        gSTEURCertificateVO,
                        function(result) {

                            Common.alert("GST Certificate Saved"
                                    + DEFAULT_DELIMITER + "<b>"
                                    + result.message + "</b>", fn_reloadPage);

                        },
                        function(jqXHR, textStatus, errorThrown) {
                            try {
                                console.log("status : " + jqXHR.status);
                                console
                                        .log("code : "
                                                + jqXHR.responseJSON.code);
                                console.log("message : "
                                        + jqXHR.responseJSON.message);
                                console.log("detailMessage : "
                                        + jqXHR.responseJSON.detailMessage);

                                //              Common.alert("Failed To Save" + DEFAULT_DELIMITER + "<b>Failed to save. Please try again later.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
                                Common
                                        .alert('<spring:message code="sal.alert.title.saveFail" />'
                                                + DEFAULT_DELIMITER
                                                + '<b><spring:message code="sal.alert.msg.saveFail" /></b>');
                            } catch (e) {
                                console.log(e);
                            }
                        });
    }

    function fn_reloadPage() {
        //Common.popupDiv("/sales/order/orderModifyPop.do", { salesOrderId : ORD_ID, ordEditType : $('#ordEditType').val() }, null , true);
        $('#btnCloseModify').click();
    }
</script>
<div id="popup_wrap" class="popup_wrap">
 <!-- popup_wrap start -->
 <header class="pop_header">
  <!-- pop_header start -->
  <h1 id="hTitle">
   Care Service Order Edit
  </h1>
  <ul class="right_opt">
   <li><p class="btn_blue2">
     <a id="btnCloseModify" href="#"><spring:message
       code="sal.btn.close" /></a>
    </p></li>
  </ul>
 </header>
 <!-- pop_header end -->
 <section class="pop_body">
  <!-- pop_body start -->
  <section class="search_table">
   <!-- search_table start -->
   <form id="searchForm" method="post" />
   <form action="#" method="post">
    <table class="type1">
     <!-- table start -->
     <caption>table</caption>
     <colgroup>
      <col style="width: 110px" />
      <col style="width: *" />
     </colgroup>
     <tbody>
      <tr>
       <th scope="row"><spring:message code="sal.text.editType" /></th>
       <td><select id="ordEditType" class="mr5"></select>
        <p class="btn_sky">
         <a id="btnEditType" href="#"><spring:message
           code="sal.btn.confirm" /></a>
        </p></td>
      </tr>
     </tbody>
    </table>
    <!-- table end -->
   </form>
  </section>
  <!-- search_table end -->
  <!------------------------------------------------------------------------------
    Order Detail Page Include START
------------------------------------------------------------------------------->
  <%@ include file="/WEB-INF/jsp/homecare/sales/htOrderDetailContent.jsp"%>
  <!------------------------------------------------------------------------------
    Order Detail Page Include END
------------------------------------------------------------------------------->
  <!------------------------------------------------------------------------------
    Basic Info Edit START
------------------------------------------------------------------------------->
  <section id="scBI" class="blind">
   <aside class="title_line">
    <!-- title_line start -->
    <h3>
     <spring:message code="sal.title.text.basicInfomation" />
    </h3>
   </aside>
   <!-- title_line end -->
   <section class="search_table">
    <!-- search_table start -->
    <form id="frmBasicInfo" method="post">
     <input id="modSalesOrdId" name="salesOrdId" type="hidden"
      value="${salesOrderId}" /> <input id="modSalesOrdNo"
      name="salesOrdNo" type="hidden" /> <input id="modAppTypeId"
      name="appTypeId" type="hidden" /> <input id="modSalesmanId"
      name="salesmanId" type="hidden" /> <input id="modSalesmanTypeId"
      name="salesmanTypeId" type="hidden" /> <input id="modDeptMemId"
      name="deptMemId" type="hidden" /> <input id="modGrpMemId"
      name="grpMemId" type="hidden" /> <input id="modOrgMemId"
      name="orgMemId" type="hidden" />
     <table class="type1">
      <!-- table start -->
      <caption>table</caption>
      <colgroup>
       <col style="width: 200px" />
       <col style="width: *" />
       <col style="width: 170px" />
       <col style="width: *" />
      </colgroup>
      <tbody>
       <tr>
        <th scope="row"><spring:message
          code="sal.title.text.instDuration" /><span class="must">*</span></th>
        <td><input id="modInstallDur" name="installDur" type="text"
         title="" placeholder="Installment Duration (1-36 Months)"
         class="w100p" disabled /></td>
        <th scope="row" id="salManCodeLbl"><spring:message code="sal.text.salManCode" /><span
         class="must">*</span></th>
        <td><input id="modSalesmanCd" name="salesmanCd" type="text"
         title="" placeholder="Salesman Code" class="" /> <a
         id="btnSalesmanPop" href="#" class="search_btn"><img
          src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif"
          alt="search" /></a></td>
       </tr>
       <tr>
        <th scope="row"><spring:message code="sal.text.refNo" /></th>
        <td><input id="modOrdRefNo" name="ordRefNo" type="text"
         title="" placeholder="Reference Number" class="w100p" /></td>
        <th scope="row"><spring:message
          code="sal.title.text.salesmanType" /></th>
        <td><input id="modSalesmanType" name="salesmanType"
         type="text" title="" placeholder="Salesman Type"
         class="readonly" readonly /></td>
       </tr>
       <tr>
        <th scope="row"><spring:message code="sal.text.poNo" /></th>
        <td><input id="modOrdPoNo" name="ordPoNo" type="text"
         title="" placeholder="PO Number" class="w100p" /></td>
        <th scope="row"><spring:message code="sal.text.salManName" /></th>
        <td><input id="modSalesmanName" name="salesmanName"
         type="text" title="" placeholder="Salesman Name"
         class="readonly" readonly /></td>
       </tr>
       <tr>
        <th scope="row"><spring:message code="sal.text.keyInBranch" /><span
         class="must">*</span></th>
        <td><select id="modKeyInBranch" name="keyInBranch"
         class="w100p"></select></td>
        <th scope="row"><spring:message
          code="sal.title.text.salesmanNric" /></th>
        <td><input id="modSalesmanIc" name="salesmanIc" type="text"
         title="" placeholder="Salesman NRIC" class="readonly" readonly /></td>
       </tr>
       <tr>
        <th scope="row" rowspan="3"><spring:message
          code="sal.text.remark" /></th>
        <td rowspan="3"><textarea id="modOrdRem" name="ordRem"
          cols="20" rows="5"></textarea></td>
        <th scope="row"><spring:message
          code="sal.text.departmentCode" /></th>
        <td><input id="modOrderDeptCode" name="orderDeptCode"
         type="text" title="" placeholder="Department Code"
         class="readonly" readonly /></td>
       </tr>
       <tr>
        <th scope="row"><spring:message code="sal.text.GroupCode" /></th>
        <td><input id="modOrderGrpCode" name="orderGrpCode"
         type="text" title="" placeholder="Group Code" class="readonly"
         readonly /></td>
       </tr>
       <tr>
        <th scope="row"><spring:message
          code="sal.text.organizationCode" /></th>
        <td><input id="modOrderOrgCode" name="orderOrgCode"
         type="text" title="" placeholder="Organization Code"
         class="readonly" readonly /></td>
       </tr>
      </tbody>
     </table>
     <!-- table end -->
    </form>
   </section>
   <!-- search_table end -->
   <ul class="center_btns">
    <li><p class="btn_blue2">
      <a id="btnSaveBasicInfo" name="btnSaveBasicInfo" href="#"><spring:message
        code="sal.btn.save" /></a>
     </p></li>
   </ul>
  </section>
  <!------------------------------------------------------------------------------
    Basic Info Edit END
------------------------------------------------------------------------------->
  <!------------------------------------------------------------------------------
    Mailing Address Edit START
------------------------------------------------------------------------------->
  <section id="scMA" class="blind">
   <aside class="title_line">
    <!-- title_line start -->
    <h3>
     <spring:message code="sal.title.text.billingGrpMtncMailAddr" />
    </h3>
   </aside>
   <!-- title_line end -->
   <ul class="right_btns mb10">
    <li><p class="btn_grid">
      <a id="btnBillNewAddr" href="#"><spring:message
        code="sal.btn.addNewAddr" /></a>
     </p></li>
    <li><p class="btn_grid">
      <a id="btnBillSelAddr" href="#"><spring:message
        code="sal.title.text.seMailAddr" /></a>
     </p></li>
   </ul>
   <section class="search_table">
    <!-- search_table start -->
    <form id="frmMailAddr" method="post">
     <input name="salesOrdId" type="hidden" value="${salesOrderId}" /> <input
      id="modCustId" name="custId" type="hidden" /> <input
      id="modBillGroupId" name="billGroupId" type="hidden" /> <input
      id="modCustAddId" name="custAddId" type="hidden" /> <input
      id="modCustAddIdOld" name="custAddIdOld" type="hidden" />
     <table class="type1">
      <!-- table start -->
      <caption>table</caption>
      <colgroup>
       <col style="width: 190px" />
       <col style="width: *" />
       <col style="width: 190px" />
       <col style="width: *" />
      </colgroup>
      <tbody>
       <tr>
        <th scope="row"><spring:message
          code="sal.text.billingGroup" /></th>
        <td><span id="modBillGroupNo"></span></td>
        <th scope="row"><spring:message
          code="sal.title.text.totOrdGroup" /></th>
        <td><span id="modTotalOrder"></span></td>
       </tr>
       <tr>
        <th scope="row"><spring:message
          code="sal.title.text.currAddr" /></th>
        <td colspan="3"><span id="modAddress"></span></td>
       </tr>
       <tr>
        <th scope="row"><spring:message
          code="sal.title.text.newAddr" /></th>
        <td colspan="3"><span id="modNewAddress"></span></td>
       </tr>
       <tr>
        <th scope="row"><spring:message
          code="sal.title.text.reasonUpdate" /></th>
        <td colspan="3"><textarea id="modRem" name="sysHistRem"
          cols="20" rows="5"></textarea></td>
       </tr>
      </tbody>
     </table>
     <!-- table end -->
    </form>
   </section>
   <!-- search_table end -->
   <ul class="center_btns">
    <li><p class="btn_blue2">
      <a id="btnSaveMailingAddress" href="#"><spring:message
        code="sal.btn.save" /></a>
     </p></li>
   </ul>
  </section>
  <!------------------------------------------------------------------------------
    Mailing Address Edit END
------------------------------------------------------------------------------->
  <!------------------------------------------------------------------------------
    Mailing Address Edit START(Not Rental)
------------------------------------------------------------------------------->
  <section id="scMA2" class="blind">
   <aside class="title_line">
    <!-- title_line start -->
    <h3>
     <spring:message code="sal.title.text.mailingAddr" />
    </h3>
   </aside>
   <!-- title_line end -->
   <ul class="right_btns mb10">
    <li><p class="btn_grid">
      <a id="btnMailNewAddr" href="#"><spring:message
        code="sal.btn.addNewAddr" /></a>
     </p></li>
    <li><p class="btn_grid">
      <a id="btnMailSelAddr" href="#"><spring:message
        code="sal.title.text.seMailAddr" /></a>
     </p></li>
   </ul>
   <section class="search_table">
    <!-- search_table start -->
    <form id="frmMailAddr2" method="post">
     <input name="salesOrdId" type="hidden" value="${salesOrderId}" /> <input
      id="txtHiddenAddressID" name="custAddId" type="hidden" />
     <table class="type1">
      <!-- table start -->
      <caption>table</caption>
      <colgroup>
       <col style="width: 150px" />
       <col style="width: *" />
       <col style="width: 150px" />
       <col style="width: *" />
      </colgroup>
      <tbody>
       <tr>
        <th scope="row"><spring:message
          code="sal.text.addressDetail" /><span class="must">*</span></th>
        <td colspan="3"><span id="txtMailAAddrDtl"></span></td>
       </tr>
       <tr>
        <th scope="row"><spring:message code="sal.text.street" /><span
         class="must">*</span></th>
        <td colspan="3"><span id="txtMailStreet"></span></td>
       </tr>
       <tr>
        <th scope="row"><spring:message code="sal.text.area" /><span
         class="must">*</span></th>
        <td colspan="3" id="txtMailArea"><span></span></td>
       </tr>
       <tr>
        <th scope="row"><spring:message code="sal.text.city" /></th>
        <td><span id="txtMailCity"></span></td>
        <th scope="row"><spring:message code="sal.text.postCode" /></th>
        <td><span id="txtMailPostcode"></span></td>
       </tr>
       <tr>
        <th scope="row"><spring:message code="sal.text.state" /></th>
        <td><span id="txtMailState"></span></td>
        <th scope="row"><spring:message code="sal.text.country" /></th>
        <td><span id="txtMailCountry"></span></td>
       </tr>
      </tbody>
     </table>
     <!-- table end -->
    </form>
   </section>
   <!-- search_table end -->
   <ul class="center_btns">
    <li><p class="btn_blue2">
      <a id="btnSaveMailingAddress2" href="#"><spring:message
        code="sal.btn.save" /></a>
     </p></li>
   </ul>
  </section>
  <!------------------------------------------------------------------------------
    Mailing Address Edit END(Not Rental)
------------------------------------------------------------------------------->
  <!------------------------------------------------------------------------------
    Contact Person Edit START
------------------------------------------------------------------------------->
  <section id="scCP" class="blind">
   <aside class="title_line">
    <!-- title_line start -->
    <h3>
     <spring:message code="sal.title.text.billingGrpMtcContactPerson" />
    </h3>
   </aside>
   <!-- title_line end -->
   <ul class="right_btns mb10">
    <li><p class="btn_grid">
      <a id="btnNewCntc" href="#"><spring:message
        code="sal.btn.addNewContact" /></a>
     </p></li>
    <li><p class="btn_grid">
      <a id="btnSelCntc" href="#"><spring:message
        code="sal.title.text.selContactPerson" /></a>
     </p></li>
   </ul>
   <section class="search_table">
    <!-- search_table start -->
    <form id="frmCntcPer" method="post">
     <input name="salesOrdId" type="hidden" value="${salesOrderId}" /> <input
      id="modCustId2" name="custId" type="hidden" /> <input
      id="modBillGroupId2" name="billGroupId" type="hidden" /> <input
      id="modCustCntcId" name="custCntcId" type="hidden" /> <input
      id="modCustCntcIdOld" name="custCntcIdOld" type="hidden" />
     <table class="type1">
      <!-- table start -->
      <caption>table</caption>
      <colgroup>
       <col style="width: 150px" />
       <col style="width: *" />
       <col style="width: 180px" />
       <col style="width: *" />
      </colgroup>
      <tbody>
       <tr>
        <th scope="row"><spring:message
          code="sal.text.billingGroup" /></th>
        <td><span id="modBillGroupNo2"></span></td>
        <th scope="row"><spring:message
          code="sal.title.text.totOrdGroup" /></th>
        <td><span id="modTotalOrder2"></span></td>
       </tr>
      </tbody>
     </table>
     <!-- table end -->
     <aside class="title_line">
      <!-- title_line start -->
      <h2>
       <spring:message code="sal.title.text.currCntcPerson" />
      </h2>
     </aside>
     <!-- title_line end -->
     <table class="type1">
      <!-- table start -->
      <caption>table</caption>
      <colgroup>
       <col style="width: 150px" />
       <col style="width: *" />
       <col style="width: 180px" />
       <col style="width: *" />
      </colgroup>
      <tbody>
       <tr>
        <th scope="row"><spring:message
          code="sal.text.contactPerson" /></th>
        <td colspan="3"><span id="modCntcPerson"></span></td>
       </tr>
       <tr>
        <th scope="row"><spring:message
          code="sal.title.text.mobNumber" /></th>
        <td><span id="modCntcMobNo"></span></td>
        <th scope="row"><spring:message
          code="sal.title.text.officeNumber" /></th>
        <td><span id="modCntcOffNo"></span></td>
       </tr>
       <tr>
        <th scope="row"><spring:message
          code="sal.title.text.residenceNumber" /></th>
        <td><span id="modCntcResNo"></span></td>
        <th scope="row"><spring:message
          code="sal.title.text.faxNumber" /></th>
        <td><span id="modCntcFaxNo"></span></td>
       </tr>
      </tbody>
     </table>
     <!-- table end -->
     <aside class="title_line">
      <!-- title_line start -->
      <h2>
       <spring:message code="sal.btn.newContactPerson" />
      </h2>
     </aside>
     <!-- title_line end -->
     <table class="type1">
      <!-- table start -->
      <caption>table</caption>
      <colgroup>
       <col style="width: 150px" />
       <col style="width: *" />
       <col style="width: 180px" />
       <col style="width: *" />
      </colgroup>
      <tbody>
       <tr>
        <th scope="row"><spring:message
          code="sal.text.contactPerson" /></th>
        <td colspan="3"><span id="modCntcPersonNew"></td>
       </tr>
       <tr>
        <th scope="row"><spring:message
          code="sal.title.text.mobNumber" /></th>
        <td><span id="modCntcMobNoNew"></span></td>
        <th scope="row"><spring:message
          code="sal.title.text.officeNumber" /></th>
        <td><span id="modCntcOffNoNew"></span></td>
       </tr>
       <tr>
        <th scope="row"><spring:message
          code="sal.title.text.residenceNumber" /></th>
        <td><span id="modCntcResNoNew"></span></td>
        <th scope="row"><spring:message
          code="sal.title.text.faxNumber" /></th>
        <td><span id="modCntcFaxNoNew"></span></td>
       </tr>
       <tr>
        <th scope="row"><spring:message
          code="sal.title.text.reasonUpdate" /></th>
        <td colspan="3"><textarea id="modRem2" name="sysHistRem"
          cols="20" rows="5"></textarea></td>
       </tr>
      </tbody>
     </table>
     <!-- table end -->
    </form>
   </section>
   <!-- search_table end -->
   <ul class="center_btns">
    <li><p class="btn_blue2 big">
      <a id="btnSaveCntcPerson" href="#"><spring:message
        code="sal.btn.save" /></a>
     </p></li>
   </ul>
  </section>
  <!------------------------------------------------------------------------------
    Contact Person Edit END
------------------------------------------------------------------------------->
  <!------------------------------------------------------------------------------
    NRIC/Company No. Edit START
------------------------------------------------------------------------------->
  <section id="scIC" class="blind">
   <aside class="title_line">
    <!-- title_line start -->
    <h3>
     <spring:message code="sal.title.text.nricCompNo" />
    </h3>
   </aside>
   <!-- title_line end -->
   <section class="search_table">
    <!-- search_table start -->
    <form id="frmNric" method="post">
     <input name="custId" value="${custId}" type="hidden" /> <input
      id="modCustNricOld" name="custNricOld" type="hidden" /> <input
      id="modCustGender" name="custGender" type="hidden" /> <input
      id="modNationality" name="nationality" type="hidden" /> <input
      id="modCustType" name="custType" type="hidden" />
     <table class="type1">
      <!-- table start -->
      <caption>table</caption>
      <colgroup>
       <col style="width: 190px" />
       <col style="width: *" />
      </colgroup>
      <tbody>
       <tr>
        <th scope="row"><spring:message
          code="sal.title.text.nricCompNo" /></th>
        <td><input id="modCustNric" name="custNric" type="text"
         title="" placeholder="NRIC/Company No." class="" /></td>
       </tr>
      </tbody>
     </table>
     <!-- table end -->
    </form>
   </section>
   <!-- search_table end -->
   <ul class="center_btns">
    <li><p class="btn_blue2">
      <a id="btnSaveNric" href="#"><spring:message
        code="sal.btn.save" /></a>
     </p></li>
   </ul>
  </section>
  <!------------------------------------------------------------------------------
    NRIC/Company No. Edit END
------------------------------------------------------------------------------->
  <!------------------------------------------------------------------------------
    Installation Edit START
------------------------------------------------------------------------------->
  <section id="scIN" class="blind">
   <aside class="title_line">
    <!-- title_line start -->
    <h3>
   Service Address
    </h3>
   </aside>
   <!-- title_line end -->
   <ul class="right_btns mb10">
    <li><p class="btn_grid">
      <a id="btnInstNewAddr" href="#"><spring:message
        code="sal.btn.addNewAddr" /></a>
     </p></li>
    <li><p class="btn_grid">
      <a id="btnInstSelAddr" href="#"><spring:message
        code="sal.title.text.seMailAddr" /></a>
     </p></li>
   </ul>
   <section class="search_table">
    <!-- search_table start -->
    <form id="frmInstInfo" method="post">
     <input name="salesOrdId" type="hidden" value="${salesOrderId}" /> <input
      name="salesOrdNo" type="hidden" value="${salesOrderNo}" />
     <!-- Install Address Info                                                    -->
     <input id="modInstallId" name="installId" type="hidden" /> <input
      id="modInstCustAddIdOld" name="custAddIdOld" type="hidden" /> <input
      id="modInstCustAddId" name="custAddId" type="hidden" /> <input
      id="modInstAreaId" name="areaId" type="hidden" />
     <!-- Install Contact Info                                                    -->
     <input id="modInstCustCntcId" name="custCntcId" type="hidden" />
     <!--input id="modInstCustCntcIdOld" name="custGender" type="hidden" /-->
     <table class="type1">
      <!-- table start -->
      <caption>table</caption>
      <colgroup>
       <col style="width: 150px" />
       <col style="width: *" />
       <col style="width: 150px" />
       <col style="width: *" />
      </colgroup>
      <tbody>
       <tr>
        <th scope="row"><spring:message
          code="sal.text.addressDetail" /><span class="must">*</span></th>
        <td colspan="3"><span id="modInstAddrDtl"></span></td>
       </tr>
       <tr>
        <th scope="row"><spring:message code="sal.text.street" /><span
         class="must">*</span></th>
        <td colspan="3"><span id="modInstStreet"></span></td>
       </tr>
       <tr>
        <th scope="row"><spring:message code="sal.text.area" /><span
         class="must">*</span></th>
        <td colspan="3" id="modInstArea"><span></span></td>
       </tr>
       <tr>
        <th scope="row"><spring:message code="sal.text.city" /></th>
        <td><span id="modInstCity"></span></td>
        <th scope="row"><spring:message code="sal.text.postCode" /></th>
        <td><span id="modInstPostCd"></span></td>
       </tr>
       <tr>
        <th scope="row"><spring:message code="sal.text.state" /></th>
        <td><span id="modInstState"></span></td>
        <th scope="row"><spring:message code="sal.text.country" /></th>
        <td><span id="modInstCnty"></span></td>
       </tr>
      </tbody>
     </table>
     <!-- table end -->
     <aside class="title_line">
      <!-- title_line start -->
      <h3>
       Service Contact Person
      </h3>
     </aside>
     <!-- title_line end -->
     <ul class="right_btns mb10">
      <li><p class="btn_grid">
        <a id="btnInstNewCntc" href="#"><spring:message
          code="sal.btn.addNewContact" /></a>
       </p></li>
      <li><p class="btn_grid">
        <a id="btnInstSelCntc" href="#"><spring:message
          code="sal.title.text.selContactPerson" /></a>
       </p></li>
     </ul>
     <table class="type1">
      <!-- table start -->
      <caption>table</caption>
      <colgroup>
       <col style="width: 150px" />
       <col style="width: *" />
       <col style="width: 150px" />
       <col style="width: *" />
       <col style="width: 150px" />
       <col style="width: *" />
      </colgroup>
      <tbody>
       <tr>
        <th scope="row"><spring:message code="sal.text.name" /><span
         class="must">*</span></th>
        <td><span id="modInstCntcName"></span></td>
        <th scope="row"><spring:message code="sal.text.initial" /></th>
        <td><span id="modInstCntcInit"></span></td>
        <th scope="row"><spring:message code="sal.text.gender" /></th>
        <td><span id="modInstCntcGender"></span></td>
       </tr>
       <tr>
        <th scope="row"><spring:message code="sal.text.nric" /></th>
        <td><span id="modInstCntcNric"></span></td>
        <th scope="row"><spring:message code="sal.text.dob" /></th>
        <td><span id="modInstCntcDob"></span></td>
        <th scope="row"><spring:message code="sal.text.race" /></th>
        <td><span id="modInstCntcRace"></span></td>
       </tr>
       <tr>
        <th scope="row"><spring:message code="sal.text.email" /></th>
        <td><span id="modInstCntcEmail"></span></td>
        <th scope="row"><spring:message code="sal.text.dept" /></th>
        <td><span id="modInstCntcDept"></span></td>
        <th scope="row"><spring:message code="sal.text.post" /></th>
        <td><span id="modInstCntcPost"></span></td>
       </tr>
       <tr>
        <th scope="row"><spring:message code="sal.text.telM" /></th>
        <td><span id="modInstCntcTelM"></span></td>
        <th scope="row"><spring:message code="sal.text.telR" /></th>
        <td><span id="modInstCntcTelR"></span></td>
        <th scope="row"><spring:message code="sal.text.telO" /></th>
        <td><span id="modInstCntcTelO"></span></td>
       </tr>
       <tr>
        <th scope="row"><spring:message code="sal.text.telF" /></th>
        <td><span id="modInstCntcTelF"></span></td>
        <th scope="row"></th>
        <td><span></span></td>
        <th scope="row"></th>
        <td><span></span></td>
       </tr>
      </tbody>
     </table>
     <!-- table end -->
     <aside class="title_line">
      <!-- title_line start -->
      <h3>
       Service Information
      </h3>
     </aside>
     <!-- title_line end -->
     <table class="type1">
      <!-- table start -->
      <caption>table</caption>
      <colgroup>
       <col style="width: 190px" />
       <col style="width: *" />
       <col style="width: 190px" />
       <col style="width: *" />
      </colgroup>
      <tbody>
    <%--    <tr>
        <th scope="row"><spring:message
          code="sal.title.text.dscBrnch" /><span class="must">*</span></th>
        <td colspan="3"><select id="dscBrnchId" name="dscBrnchId"
         class="w100p"></select></td>
       </tr> --%>
       <tr>
        <th scope="row">Prefer Service Date<span class="must">*</span></th>
        <td><input id="modPreferInstDt" name="preDt" type="text"
         title="Create start Date" placeholder="DD/MM/YYYY"
         class="j_date w100p" readonly /></td>
        <th scope="row">Prefer Service Time<span class="must">*</span></th>
        <td>
         <div class="time_picker w100p">
          <!-- time_picker start -->
          <input id="modPreferInstTm" name="preTm" type="text" title=""
           placeholder="" class="time_date w100p" readonly />
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
         </div>
         <!-- time_picker end -->
        </td>
       </tr>
       <tr>
        <th scope="row"><spring:message
          code="sal.title.text.specialInstruction" /><span class="must">*</span></th>
        <td colspan="3"><textarea id="modInstct" name="instct"
          cols="20" rows="5"></textarea></td>
       </tr>
      </tbody>
     </table>
     <!-- table end -->
    </form>
   </section>
   <!-- search_table end -->
   <ul class="center_btns">
    <li><p class="btn_blue2">
      <a id="btnSaveInstInfo" href="#"><spring:message
        code="sal.btn.save" /></a>
     </p></li>
   </ul>
  </section>
  <!------------------------------------------------------------------------------
    Installation Edit END
------------------------------------------------------------------------------->
  <!------------------------------------------------------------------------------
    Payment Channel Edit START
------------------------------------------------------------------------------->
  <section id="scPC" class="blind">
   <aside class="title_line">
    <!-- title_line start -->
    <h3>
     <spring:message code="sal.title.text.paymentChnnl" />
    </h3>
   </aside>
   <!-- title_line end -->
   <ul class="right_btns mb10">
    <li><p class="btn_grid">
      <a id="btnViewHistory" href="#"><spring:message
        code="sal.title.text.viewHistory" /></a>
     </p></li>
   </ul>
   <form id="payChanlForm" name="payChanlForm" action="#" method="post">
    <input name="salesOrdId" type="hidden" value="${salesOrderId}" /> <input
     name="salesOrdNo" type="hidden" value="${salesOrderNo}" /> <input
     name="custId" type="hidden" value="${custId}" /> <input
     name="custNric" type="hidden" value="${custNric}" /> <input
     id="rentPayId" name="rentPayId" type="hidden" />
    <table class="type1">
     <!-- table start -->
     <caption>table</caption>
     <colgroup>
      <col style="width: 150px" />
      <col style="width: *" />
      <col style="width: 150px" />
      <col style="width: *" />
     </colgroup>
     <tbody>
      <tr>
       <th scope="row"><spring:message
         code="sal.text.payByThirdParty" /></th>
       <td colspan="3"><label><input id="thrdParty"
         name="thrdParty" id="thrdParty" type="checkbox" value="1" /><span></span></label>
       </td>
      </tr>
     </tbody>
    </table>
    <!-- table end -->
    <!------------------------------------------------------------------------------
    Third Party
------------------------------------------------------------------------------->
    <section id="scPC_ThrdParty" class="blind">
     <aside class="title_line">
      <!-- title_line start -->
      <h2>
       <spring:message code="sal.title.thirdParty" />
      </h2>
     </aside>
     <!-- title_line end -->
     <ul class="right_btns mb10">
      <li><p class="btn_grid">
        <a id="btnAddCust" href="#"><spring:message
          code="sal.btn.addNewThirdParty" /></a>
       </p></li>
     </ul>
     <table class="type1">
      <!-- table start -->
      <caption>table</caption>
      <colgroup>
       <col style="width: 170px" />
       <col style="width: *" />
       <col style="width: 190px" />
       <col style="width: *" />
      </colgroup>
      <tbody>
       <tr>
        <th scope="row"><spring:message code="sal.text.customerId" /><span
         class="must">*</span></th>
        <td><input id="thrdPartyId" name="thrdPartyId" type="text"
         title="" placeholder="Third Party ID" class="" /> <a href="#"
         class="search_btn" id="btnThrdParty"><img
          src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif"
          alt="search" /></a> <input id="hiddenThrdPartyId"
         name="hiddenThrdPartyId" type="hidden" title=""
         placeholder="Third Party ID" class="" /></td>
        <th scope="row"><spring:message code="sal.text.type" /></th>
        <td><span id="thrdPartyType"></span></td>
       </tr>
       <tr>
        <th scope="row"><spring:message code="sal.text.name" /></th>
        <td><span id="thrdPartyName"></span></td>
        <th scope="row"><spring:message
          code="sal.text.nricCompanyNo" /></th>
        <td><span id="txtThrdPartyNric"></span> <input
         id="thrdPartyNric" name="thrdPartyNric" type="hidden" /></td>
       </tr>
      </tbody>
     </table>
     <!-- table end -->
    </section>
    <!------------------------------------------------------------------------------
    Rental Paymode
------------------------------------------------------------------------------->
    <section id="scPC_RentPayMode">
     <table class="type1">
      <!-- table start -->
      <caption>table</caption>
      <colgroup>
       <col style="width: 150px" />
       <col style="width: *" />
       <col style="width: 150px" />
       <col style="width: *" />
      </colgroup>
      <tbody>
       <tr>
        <th scope="row"><spring:message
          code="sal.text.rentalPaymode" /><span class="must">*</span></th>
        <td><select id="rentPayMode" name="rentPayMode"
         class="w100p"></select></td>
        <th scope="row"><spring:message
          code="sal.text.nricPassbook" /></th>
        <td><input id="rentPayIC" name="rentPayIC" type="text"
         title="" placeholder="" class="w100p" /></td>
       </tr>
      </tbody>
     </table>
     <!-- table end -->
    </section>
    <!------------------------------------------------------------------------------
    Credit Card
------------------------------------------------------------------------------->
    <section id="scPC_CrCard" class="blind">
     <aside class="title_line">
      <!-- title_line start -->
      <h2>
       <spring:message code="sal.page.subtitle.creditCard" />
      </h2>
     </aside>
     <!-- title_line end -->
     <ul class="right_btns mb1m">
      <li><p class="btn_grid">
        <a id="addCreditCardBtn" href="#"><spring:message
          code="sal.btn.addNewCreditCard" /></a>
       </p></li>
      <li><p class="btn_grid">
        <a id="selCreditCardBtn" href="#"><spring:message
          code="sal.btn.selectAnotherCreditCard" /></a>
       </p></li>
     </ul>
     <table class="type1">
      <!-- table start -->
      <caption>table</caption>
      <colgroup>
       <col style="width: 150px" />
       <col style="width: *" />
       <col style="width: 150px" />
       <col style="width: *" />
      </colgroup>
      <tbody>
       <tr>
        <th scope="row"><spring:message
          code="sal.text.creditCardNumber" /><span class="must">*</span></th>
        <td><span id="rentPayCRCNo"></span> <input
         id="hiddenRentPayCRCId" name="rentPayCRCId" type="hidden" /> <input
         id="hiddenRentPayEncryptCRCNo" name="hiddenRentPayEncryptCRCNo"
         type="hidden" /></td>
        <th scope="row"><spring:message
          code="sal.text.creditCardType" /></th>
        <td><span id="rentPayCRCType"></span></td>
       </tr>
       <tr>
        <th scope="row"><spring:message code="sal.text.nameOnCard" /></th>
        <td><span id="rentPayCRCName"></span></td>
        <th scope="row"><spring:message code="sal.text.expiry" /></th>
        <td><span id="rentPayCRCExpiry"></span></td>
       </tr>
       <tr>
        <th scope="row"><spring:message code="sal.text.issueBank" /></th>
        <td><span id="rentPayCRCBank"></span> <input
         id="hiddenRentPayCRCBankId" name="rentPayCRCBankId"
         type="hidden" title="" class="w100p" /></td>
        <th scope="row"><spring:message code="sal.text.cardType" /></th>
        <td><span id="rentPayCRCCardType"></span></td>
       </tr>
      </tbody>
     </table>
     <!-- table end -->
    </section>
    <!------------------------------------------------------------------------------
    Direct Debit
------------------------------------------------------------------------------->
    <section id="scPC_DirectDebit" class="blind">
     <aside class="title_line">
      <!-- title_line start -->
      <h3>
       <spring:message code="sal.page.subtitle.directDebit" />
      </h3>
     </aside>
     <!-- title_line end -->
     <ul class="right_btns mb10">
      <li><p class="btn_grid">
        <a id="btnAddBankAccount" href="#"><spring:message
          code="sal.btn.addNewBankAccount" /></a>
       </p></li>
      <li><p class="btn_grid">
        <a id="btnSelBankAccount" href="#"><spring:message
          code="sal.btn.selectAnotherBankAccount" /></a>
       </p></li>
     </ul>
     <table class="type1">
      <!-- table start -->
      <caption>table</caption>
      <colgroup>
       <col style="width: 150px" />
       <col style="width: *" />
       <col style="width: 150px" />
       <col style="width: *" />
      </colgroup>
      <tbody>
       <tr>
        <th scope="row"><spring:message
          code="sal.text.accountNumber" /><span class="must">*</span></th>
        <td><span id="rentPayBankAccNo"></span> <input
         id="rentPayBankAccNoEncrypt" name="rentPayBankAccNoEncrypt"
         type="hidden" /> <input id="hiddenRentPayBankAccID"
         name="hiddenRentPayBankAccID" type="hidden" />
        <th scope="row"><spring:message code="sal.text.accountType" /></th>
        <td><span id="rentPayBankAccType"></span></td>
       </tr>
       <tr>
        <th scope="row"><spring:message
          code="sal.text.accountHolder" /></th>
        <td><span id="accName"></span></td>
        <th scope="row"><spring:message
          code="sal.text.issueBankBranch" /></th>
        <td><span id="accBranch"></span></td>
       </tr>
       <tr>
        <th scope="row"><spring:message code="sal.text.ddcChnl" /></th>
        <td><span id="accDdtChnl"></span></td>
        <th scope="row"><spring:message code="sal.text.issueBank" /></th>
        <td><span id="accBank"></span> <input id="hiddenAccBankId"
         name="hiddenAccBankId" type="hidden" /></td>
       </tr>
      </tbody>
     </table>
     <!-- table end -->
    </section>
    <table class="type1">
     <!-- table start -->
     <caption>table</caption>
     <colgroup>
      <col style="width: 150px" />
      <col style="width: *" />
      <col style="width: 150px" />
      <col style="width: *" />
     </colgroup>
     <tbody>
      <tr>
       <th scope="row"><spring:message code="sal.text.applyDate" /><span
        class="must">*</span></th>
       <td><input id="modApplyDate" name="applyDate" type="text"
        title="Create start Date" placeholder="DD/MM/YYYY"
        class="j_date w100p" /></td>
       <th scope="row"><spring:message code="sal.text.submitDate" /></th>
       <td><input id="modSubmitDate" name="submitDate" type="text"
        title="Create start Date" placeholder="DD/MM/YYYY"
        class="j_date w100p" /></td>
      </tr>
      <tr>
       <th scope="row"><spring:message code="sal.text.startDate" /></th>
       <td><input id="modStartDate" name="startDate" type="text"
        title="Create start Date" placeholder="DD/MM/YYYY"
        class="j_date w100p" /></td>
       <th scope="row"><label> <input id="chkRejectDate" name="chkRejectDate"
         type="checkbox" value="1" /><span>Reject Date</span><span
         id="spRjctDate" class="must"></span></label></th>
       <td><input id="modRejectDate" name="rejectDate" type="text"
        title="Create start Date" placeholder="DD/MM/YYYY"
        class="j_date w100p" disabled /></td>
      </tr>
      <tr>
       <th scope="row"><spring:message
         code="sal.title.text.payTerm" /></th>
       <td><select id="modPayTerm" name="payTerm" class="w100p">
         <option value="0">No Term</option>
         <option value="1">1 Month</option>
         <option value="2">2 Months</option>
         <option value="3">3 Months</option>
         <option value="4">4 Months</option>
         <option value="5">5 Months</option>
         <option value="6">6 Months</option>
       </select></td>
       <th scope="row"><spring:message
         code="sal.title.text.rejReason" /><span id="spRejectReason"
        class="must"></span></th>
       <td><select id="modRejectReason" name="rejectReason"
        class="w100p" disabled></select></td>
      </tr>
     </tbody>
    </table>
    <!-- table end -->
   </form>
   <ul class="center_btns">
    <li><p class="btn_blue2">
      <a id="btnSavePayChan" href="#"><spring:message
        code="sal.btn.save" /></a>
     </p></li>
   </ul>
  </section>
  <!------------------------------------------------------------------------------
    Payment Channel Edit END
------------------------------------------------------------------------------->
  <!------------------------------------------------------------------------------
    Document Submissioon Edit START
------------------------------------------------------------------------------->
  <section id="scDS" class="blind">
   <aside class="title_line">
    <!-- title_line start -->
    <h3>
     <spring:message code="sal.title.text.docuSubmission" />
    </h3>
   </aside>
   <!-- title_line end -->
   <article class="grid_wrap">
    <!-- grid_wrap start -->
    <div id="grid_mod_doc_wrap"
     style="width: 100%; height: 380px; margin: 0 auto;"></div>
   </article>
   <!-- grid_wrap end -->
   <ul class="center_btns">
    <li><p class="btn_blue2">
      <a id="btnSaveDocSub" href="#"><spring:message
        code="sal.btn.save" /></a>
     </p></li>
   </ul>
  </section>
  <!------------------------------------------------------------------------------
    Document Submissioon Edit END
------------------------------------------------------------------------------->
  <!------------------------------------------------------------------------------
    Referrals Info Edit START
------------------------------------------------------------------------------->
  <section id="scRI" class="blind">
   <aside class="title_line">
    <!-- title_line start -->
    <h3>
     <spring:message code="sal.title.text.referralInfo" />
    </h3>
   </aside>
   <!-- title_line end -->
   <section class="search_table">
    <!-- search_table start -->
    <form id="frmRefrl" method="post">
     <input name="custId" value="${custId}" type="hidden" /> <input
      id="modCustNricOld" name="custNricOld" type="hidden" /> <input
      id="modCustGender" name="custGender" type="hidden" /> <input
      id="modNationality" name="nationality" type="hidden" /> <input
      id="modCustType" name="custType" type="hidden" />
     <table class="type1">
      <!-- table start -->
      <caption>table</caption>
      <colgroup>
       <col style="width: 190px" />
       <col style="width: *" />
      </colgroup>
      <tbody>
       <tr>
        <th scope="row"><spring:message
          code="sal.title.text.ordNop" /></th>
        <td><input type="text" value="${salesOrderNo}" title=""
         placeholder="" class="" disabled /></td>
       </tr>
      </tbody>
     </table>
     <!-- table end -->
     <ul class="right_btns">
      <li><p class="btn_grid">
        <a id="btnCanclChg" href="#"><spring:message
          code="sal.title.text.cancelChngs" /></a>
       </p></li>
      <li><p class="btn_grid">
        <a id="btnAddRowReferral" href="#"><spring:message
          code="sal.btn.add" /></a>
       </p></li>
     </ul>
     <article class="grid_wrap">
      <!-- grid_wrap start -->
      <div id="grid_mod_rfr_wrap"
       style="width: 100%; height: 240px; margin: 0 auto;"></div>
     </article>
     <!-- grid_wrap end -->
    </form>
   </section>
   <!-- search_table end -->
   <ul class="center_btns">
    <li><p class="btn_blue2">
      <a id="btnSaveReferral" href="#"><spring:message
        code="sal.btn.save" /></a>
     </p></li>
   </ul>
  </section>
  <!------------------------------------------------------------------------------
    Referrals Info Edit END
------------------------------------------------------------------------------->
  <!------------------------------------------------------------------------------
    Promotion Info Edit START
------------------------------------------------------------------------------->
  <section id="scPR" class="blind">
   <aside class="title_line">
    <!-- title_line start -->
    <h3>
     <spring:message code="sal.title.text.promoInfomation" />
    </h3>
   </aside>
   <!-- title_line end -->
   <ul class="left_btns">
    <li><p class="btn_blue">
     <p>
      <spring:message code="sal.title.text.expiredPromoQuestion" />
     </p></li>
   </ul>
   <section class="search_table">
    <!-- search_table start -->
    <table class="type1">
     <!-- table start -->
     <caption>table</caption>
     <colgroup>
      <col style="width: 150px" />
      <col style="width: *" />
      <col style="width: 150px" />
      <col style="width: *" />
     </colgroup>
     <tbody>
      <tr>
       <th scope="row"><spring:message code="sal.text.product" /></th>
       <td><span id="prdName"></span></td>
       <th scope="row"><spring:message
         code="sal.title.text.priceRpfRm" /></th>
       <td><input id="ordPrice" name="ordPrice" type="text"
        title="" placeholder="Price/Rental Processing Fees (RPF)"
        class="w100p readonly" readonly /> <input id="promoId"
        name="promoId" type="hidden" /></td>
       <input id="stkId" name="stkId" type="hidden" />
       </td>
      </tr>
      <tr>
       <th scope="row"><spring:message code="sal.title.text.promo" /><span
        class="must">*</span></th>
       <td><select id="ordPromo" name="ordPromo" class="w100p"></select>
       </td>
       <th scope="row"><spring:message
         code="sal.title.text.nomalRentFeeRm" /></th>
       <td><input id="orgOrdRentalFees" name="orgOrdRentalFees"
        type="text" title="" placeholder="Normal Rental Fees (Monthly)"
        class="w100p readonly" readonly /></td>
      </tr>
      <tr>
       <th scope="row"><spring:message code="sal.title.text.pv" /></th>
       <td><input id="ordPv" name="ordPv" type="text" title=""
        placeholder="Point Value (PV)" class="w100p readonly" readonly />
        <input id="ordPvGST" name="ordPvGST" type="hidden" /></td>
       <th scope="row"><spring:message
         code="sal.title.text.rentFeeRm" /></th>
       <td><p>
         <select id="promoDiscPeriodTp" name="promoDiscPeriodTp"
          class="w100p" disabled></select>
        </p>
        <p>
         <input id="promoDiscPeriod" name="promoDiscPeriod" type="text"
          title="" placeholder="" style="width: 42px;" class="readonly"
          readonly />
        </p>
        <p>
         <input id="ordRentalFees" name="ordRentalFees" type="text"
          title="" placeholder="" style="width: 90px;" class="readonly"
          readonly />
        </p></td>
      </tr>
      <tr>
       <th scope="row"><spring:message
         code="sal.title.text.relatedNo" /></th>
       <td><input id="relatedNo" name="relatedNo" type="text"
        title="" placeholder="Related Number" class="w100p readonly"
        readonly /></td>
       <td colspan="2"><p id="pBtnCal" class="btn_sky blind">
         <a id="btnCal" href="#">Exclude GST Calculation</a>
        </p></td>
      </tr>
     </tbody>
    </table>
    <!-- table end -->
   </section>
   <ul class="center_btns">
    <li><p class="btn_blue2">
      <a id="btnSavePromo" href="#"><spring:message
        code="sal.btn.save" /></a>
     </p></li>
   </ul>
  </section>
  <!------------------------------------------------------------------------------
    Promotion Info Edit END
------------------------------------------------------------------------------->
  <!------------------------------------------------------------------------------
    GST Certification Edit START
------------------------------------------------------------------------------->
  <section id="scGC" class="blind">
   <aside class="title_line">
    <!-- title_line start -->
    <h3>
     <spring:message code="sal.title.text.gstCertification" />
    </h3>
   </aside>
   <!-- title_line end -->
   <section class="search_table">
    <!-- search_table start -->
    <form id="fileUploadForm" name="fileUploadForm"
     enctype="multipart/form-data" action="#" method="post">
     <input id="atchFileGrpId" name="atchFileGrpId" type="hidden" /> <input
      id="subPath" name="subPath" type="hidden" /> <input id="fileName"
      name="fileName" type="hidden" /> <input id="orignlFileNm"
      name="orignlFileNm" type="hidden" /> <input id="existData"
      name="existData" type="hidden" value="N" /> <input id="eurcId"
      name="eurcId" type="hidden" />
     <table class="type1">
      <!-- table start -->
      <caption>table</caption>
      <colgroup>
       <col style="width: 180px" />
       <col style="width: *" />
       <col style="width: 160px" />
       <col style="width: *" />
      </colgroup>
      <tbody>
       <tr>
        <th scope="row"><spring:message code="sal.text.refNo" /><span
         class="must">*</span></th>
        <td><input id="certRefNo" name="certRefNo" type="text"
         title="" placeholder="Cert Reference No" class="w100p" disabled /></td>
        <th scope="row"><spring:message
          code="sal.title.text.certificateDate" /><span class="must">*</span></th>
        <td><input id="certRefDt" name="certRefDt" type="text"
         title="Create start Date" placeholder="DD/MM/YYYY"
         class="j_date w100p" disabled /></td>
       </tr>
       <tr>
        <th scope="row"><spring:message
          code="sal.text.gstRegistrationNo" /></th>
        <td colspan="3"><input id="txtCertCustRgsNo"
         name="txtCertCustRgsNo" type="text" title="" placeholder=""
         class="w100p" disabled /></td>
       </tr>
       <tr>
        <th scope="row"><spring:message
          code="sal.title.text.appType" /></th>
        <td><select id="eurcRliefAppTypeId" class="w100p" disabled></select>
        </td>
        <th scope="row"><spring:message
          code="sal.title.text.certificateType" /></th>
        <td><select id="eurcRliefTypeId" class="w100p" disabled></select>
        </td>
       </tr>
       <tr>
        <th scope="row"><spring:message code="sal.text.remark" /></th>
        <td colspan="3"><textarea id="txtCertRemark"
          name="txtCertRemark" cols="20" rows="5" disabled></textarea></td>
       </tr>
       <tr>
        <th scope="row"><spring:message
          code="sal.title.text.uploadReliefZipFile" /></th>
        <td colspan="3">
         <!-- auto_file start -->
         <div class="auto_file2">
          <input id="certRefFile" name="certRefFile" type="file"
           title="file add" disabled />
         </div> <!-- auto_file end -->
        </td>
       </tr>
      </tbody>
     </table>
     <!-- table end -->
    </form>
   </section>
   <!-- search_table end -->
   <!--<ul class="center_btns">-->
   <!-- <li><p class="btn_blue2"><a id="btnSaveGstCert" name="btnSaveGstCert" href="#"><spring:message code="sal.btn.save" /></a></p></li>-->
   <!--</ul>-->
  </section>
  <!------------------------------------------------------------------------------
    GST Certification Edit END
------------------------------------------------------------------------------->
 </section>
 <!-- pop_body end -->
</div>
<!-- popup_wrap end -->