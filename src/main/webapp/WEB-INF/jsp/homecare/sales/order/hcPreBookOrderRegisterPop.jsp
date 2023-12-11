<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/homecare-js-1.0.js"></script>

<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style type="text/css">

    /* 커스텀 스타일 정의 */
    .auto_file2 {
        width:100%!important;
    }
    .auto_file2 > label {
        width:100%!important;
    }
   .auto_file2 label input[type=text]{width:40%!important; float:left}

</style>
<script type="text/javaScript">

    var TODAY_DD      = "${toDay}";
    var BEFORE_DD = "${bfDay}";
    var blockDtFrom = "${hsBlockDtFrom}";
    var blockDtTo = "${hsBlockDtTo}";
    var stockIdVal ='';

    //파일 저장 캐시
    var myFileCaches = {};

    //AUIGrid 생성 후 반환 ID
    var listGiftGridID;
    var appTypeData = [{"codeId": "66","codeName": "Rental"},{"codeId": "67","codeName": "Outright"},{"codeId": "68","codeName": "Instalment"}];
    var MEM_TYPE     = '${SESSION_INFO.userTypeId}';


    /* var codeList_19 = [];
    <c:forEach var="obj" items="${codeList_19}">
    codeList_19.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
    </c:forEach>

    var codeList_325 = [];
    <c:forEach var="obj" items="${codeList_325}">
    codeList_325.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
    </c:forEach>

    var codeList_415 = [];
    <c:forEach var="obj" items="${codeList_415}">
    codeList_415.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
    </c:forEach>

    var codeList_416 = [];
    <c:forEach var="obj" items="${codeList_416}">
    codeList_416.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
    </c:forEach> */

    var branchCdList_1 = [];
    <c:forEach var="obj" items="${branchCdList_1}">
    branchCdList_1.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
    </c:forEach>

    /* var branchCdList_5 = [];
    <c:forEach var="obj" items="${branchCdList_5}">
    branchCdList_5.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
    </c:forEach>

    var codeList_562 = [];
    codeList_562.push({codeId:"0", codeName:"No", code:"No"});
    <c:forEach var="obj" items="${codeList_562}">
    codeList_562.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
    </c:forEach>*/

    function disableSaveButton() {
    	$('#btnSave').unbind();
    }

    function setupSaveButton() {
    	disableSaveButton();
    	$('#btnSave').click(function() {
            if(!fn_validCustomer()) {
                $('#aTabCS').click();
                return false;
            }

            if(!fn_validOrderInfo()) {
                $('#aTabOI').click();
                return false;
            }

          fn_doSavePreOrder();

        });
    }

    $(document).ready(function(){
        createAUIGridStk();

        //doDefCombo(appTypeData, '' ,'appType', 'S', '');           //Status 생성
        //doDefCombo(codeList_19, '', 'rentPayMode', 'S', '');       // Common Code
        //doDefCombo(codeList_415, '', 'corpCustType', 'S', '');     // Common Code
        //doDefCombo(codeList_416, '', 'agreementType', 'S', '');  // Common Code
        ///doDefCombo(branchCdList_5, '', 'dscBrnchId', 'S', '');      // Branch Code
        doDefCombo(branchCdList_1, '', 'keyinBrnchId', 'S', '');    // Branch Code
        //doDefComboCode(codeList_325, '0', 'exTrade', 'S', '');    // EX-TRADE
		doGetComboSepa ('/homecare/selectHomecareDscBranchList.do', '',  ' - ', '', 'dscBrnchId',  'S', ''); //Branch Code
		//doDefCombo(codeList_562, '0', 'voucherType', 'S', 'displayVoucherSection');    // Voucher Type Code
		doGetComboAndGroup2('/common/selectProductCodeList.do', {selProdGubun: 'HC'}, '', 'preOrdProduct', 'S', 'fn_setOptGrpClass');//product 생성

		//UpperCase Field
        $("#nric").keyup(function(){$(this).val($.trim($(this).val().toUpperCase()));});
        //$("#sofNo").keyup(function(){$(this).val($.trim($(this).val().toUpperCase()));});
        $('#nric').keypress(function (e) {
            var regex = new RegExp("^[a-zA-Z0-9\s]+$");
            var str = String.fromCharCode(!e.charCode ? e.which : e.charCode);
            if (regex.test(str)) {
                return true;
            }
            e.preventDefault();
            return false;
        });

        // 20190925 KR-OHK Moblie Popup Setting
        //Common.setMobilePopup(true, false,'');
    });

    function createAUIGridStk() {
        //AUIGrid 칼럼 설정
        var columnLayoutGft = [
              {headerText : "Product CD",     dataField : "itmcd", width : 180}
            , {headerText : "Product Name", dataField : "itmname"}
            , {headerText : "Product QTY",   dataField : "promoFreeGiftQty", width : 180}
            , {headerText : "itmid",              dataField : "promoFreeGiftStkId", visible : false}
            , {headerText : "promoItmId",    dataField : "promoItmId", visible : false}
        ];

        //그리드 속성 설정
        var listGridPros = {
            usePaging                   : true,         //페이징 사용
            pageRowCount            : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)
            editable                      : false,
            fixedColumnCount        : 1,
            showStateColumn         : false,
            displayTreeOpen          : false,
            softRemoveRowMode   : false,
            headerHeight               : 30,
            useGroupingPanel         : false,        //그룹핑 패널 사용
            skipReadonlyColumns    : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove       : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
            noDataMessage            : "No order found.",
            groupingMessage         : "Here groupping"
        };
        /* listGiftGridID = GridCommon.createAUIGrid("pop_list_gift_grid_wrap", columnLayoutGft, "", listGridPros); */
    }

    $(function(){

    	$('#btnRltdNoEKeyIn').click(function() {
            Common.popupDiv("/homecare/sales/order/hcPreBookOrderNoPrevPop.do", {custId : $('#hiddenCustId').val() ,isHomecare : 'B'
            	}, null, true);
      });

        $('#btnConfirm').click(function() {
            if(!fn_validConfirm())  return false;
            //if(fn_isExistESalesNo() == 'true') return false;

           ///// $('#cmbTypeId').prop("disabled", true);
            $('#nric').prop("readonly", true).addClass("readonly");
            //$('#sofNo').prop("readonly", true).addClass("readonly");
            $('#btnConfirm').addClass("blind");
            $('#btnClear').addClass("blind");

            fn_checkRc($('#nric').val());
            //fn_loadCustomer(null, $('#nric').val());
        });
        $('#nric').keydown(function (event) {
            if (event.which === 13) {
                if(!fn_validConfirm())  return false;
                //if(fn_isExistESalesNo() == 'true') return false;

                $('#nric').prop("readonly", true).addClass("readonly");
                //$('#sofNo').prop("readonly", true).addClass("readonly");
                $('#btnConfirm').addClass("blind");
                $('#btnClear').addClass("blind");

                fn_checkRc($('#nric').val());
                //fn_loadCustomer(null, $('#nric').val());
            }
        });

        $('#chkSameCntc').click(function() {
            if($('#chkSameCntc').is(":checked")) {
                $('#scAnothCntc').addClass("blind");
            } else {
                $('#scAnothCntc').removeClass("blind");
            }
        });
        $('#btnNewCntc').click(function() {
            Common.popupDiv('/sales/customer/updateCustomerNewContactPop.do', {custId : $('#hiddenCustId').val(), callParam : "PRE_ORD_CNTC"}, null , true);
        });
        $('#btnSelCntc').click(function() {
            Common.popupDiv("/sales/customer/customerConctactSearchPop.do", {custId : $('#hiddenCustId').val(), callPrgm : "PRE_ORD_CNTC"}, null, true);
        });
        $('#btnNewInstAddr').click(function() {
            Common.popupDiv("/sales/customer/updateCustomerNewAddressPop.do", {custId : $('#hiddenCustId').val(), callParam : "PRE_ORD_INST_ADD"}, null, true);
        });
        $('#btnSelInstAddr').click(function() {
            Common.popupDiv("/sales/customer/customerAddressSearchPop.do", {custId : $('#hiddenCustId').val(), callPrgm : "PRE_ORD_INST_ADD"}, null, true);
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

        $('#memBtn').click(function() {
            Common.popupDiv("/common/memberPop.do", $("#searchForm").serializeJSON(), null, true);
        });


        setupSaveButton();


    });

    function fn_isExistMember() {
        var isExist = false, msg = "";

        Common.ajaxSync("GET", "/sales/order/selectExistingMember.do", $("#frmCustSearch").serialize(), function(rsltInfo) {
            if(rsltInfo != null) {
                isExist = rsltInfo.isExist;
            }
        });

        if(isExist == 'true') Common.alert("Pre-Order Summary" + DEFAULT_DELIMITER + "<b>* The member is our existing HP/Cody/Staff/CT.</b>");
        return isExist;
    }


    function fn_validOrderInfo() {
        var isValid = true;
        var msg = "";

        if(FormUtil.checkReqValue($('#salesmanCd')) && FormUtil.checkReqValue($('#salesmanNm'))) {
            if(appTypeIdx > 0 && appTypeVal != 143) {
                isValid = false;
                msg += "* Please select a Salesman.<br>";
            }
        }

        if($('#txtOldOrderID').val().trim() == null || $('#txtOldOrderID').val().trim() == ''){
        	 isValid = false;
             msg += "* Please select a Ex-trade order.<br>";
    	}

        if($("#preOrdProduct option:selected").index() <= 0) {
            isValid = false;
            msg += "* Please select the Product.<br>";
        }


        if(!isValid) Common.alert("Save Pre-Booking Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");
        return isValid;
    }

    function fn_validConfirm() {
    	var isValid = true;
        var msg = "";


        if(FormUtil.checkReqValue($('#nric'))) {
            isValid = false;
            msg += "* Please key in NRIC/Company No.<br>";

        } else {
            var nric_trim = $("#nric").val().replace(/ |-|_/g,'');
            console.log ("nric_trim :: "+ nric_trim);
            if($.isNumeric($("#nric_trim").val())){

            var dob = Number($('#nric').val().substr(0,2));
            var nowDt = new Date();
            var nowDtY = Number(nowDt.getFullYear().toString().substr(-2));
            var age = nowDtY- dob < 0 ? nowDtY- dob + 100 : nowDtY- dob ;

            if(age < 18) {
                Common.alert("Pre-Booking Summary" + DEFAULT_DELIMITER + "<b>* Member must 18 years old and above.</b>");
                $('#scPreOrdArea').addClass("blind");

                return false;
            }
        }
        }

        if(!isValid) Common.alert("Pre-Booking Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");
        return isValid;
    }

    function fn_validCustomer() {
    	var isValid = true;
        var msg = "";

        if(FormUtil.checkReqValue($('#hiddenCustId'))) {
            isValid = false;
            msg += "* Please select a customer.<br>";
        }

        if($('#hiddenTypeId').val() != '964') {
            isValid = false;
            msg += "* Please select an individual customer.<br>";
        }

        if($('#hiddenCustStatusId').val() == '7466' || $('#hiddenCustStatusId').val() == '7476') {

        }else{
        	isValid = false;
            msg = "* Please select an Engaged customer.<br>";
        }

        if(FormUtil.checkReqValue($('#hiddenCustCntcId'))) {
            isValid = false;
            msg += "* Please select a contact person.<br>";
        }

        if(FormUtil.checkReqValue($('#hiddenCustAddId'))) {
            isValid = false;
            msg += "* Please select an installation address.<br>";
        }

        if($("#keyinBrnchId option:selected").index() <= 0) {
            isValid = false;
            msg += "* Please select the Posting branch.<br>";
        }

        if(!isValid) Common.alert("Save Pre-Booking Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");
        return isValid;
    }


    // Confirm창에서 저장버튼을 눌렀을 경우.
    function fn_doSavePreOrder() {

    	var orderVO = {
    			  custId                      	: $('#hiddenCustId').val(),
    			  custContactNumber				: $('#custCntcTelM').val(),
    			  memCode                 		: $('#salesmanCd').val(),
    			  salesOrdIdOld          		: $('#txtOldOrderID').val(),
    			  salesOrdNoOld          		: $('#relatedNo').val(),
    			  rem                    		: $('#preRemark').val(),
    			  stkId                  		: $('#preOrdProduct').val(),
    			  area							: $('#instArea').val(),
    			  postCode						: $('#instPostCode').val(),
    			  receivingMarketingMsgStatus   : $('input:radio[name="marketingMessageSelection"]:checked').val()

    	};
    	 Common.ajax("GET", "/homecare/sales/order/selectPreBookOrderVerifyStus.do", {custId : $('#hiddenCustId').val() , salesOrdIdOld : $('#txtOldOrderID').val()}, function(result) {
    		 if(result != null && result.custVerifyStus == 'ACT'){
    			 Common.alert("Pre-Booking Alert" + DEFAULT_DELIMITER + "<b>This Order currently in progress being pre book. You are not allowed to proceed pre-book for this order.</b>", fn_closePreOrdRegPop);
    		 }else if(result != null && result.custVerifyStus == 'Y'){
    			 Common.alert("Pre-Booking Alert" + DEFAULT_DELIMITER + "<b>This Order had been pre book with Order No." + result.preBookNo +". You are not allowed to proceed pre-book for this order.</b>", fn_closePreOrdRegPop);
    		 }else{
    			 Common.ajax("POST", "/homecare/sales/order/registerHcPreBookingOrder.do", orderVO, function(result) {
    	             Common.alert("Pre Booking Order Saved" + DEFAULT_DELIMITER + "<b>"+result.message+"</b>", fn_closePreOrdRegPop);
    	         },
    	         function(jqXHR, textStatus, errorThrown) {
    	             try {
    	                 Common.alert("Failed To Save" + DEFAULT_DELIMITER + "<b>" + jqXHR.responseJSON.message + "</b>");
    	                 Common.removeLoader();

    	             } catch (e) {
    	                 console.log(e);
    	             }
    	         });
    		 }
    	 });

    }

    function fn_closePreOrdRegPop() {

        //$('#btnCnfmOrderClose').click();
        // 20190925 KR-OHK Moblie Popup Setting
        if(Common.checkPlatformType() == "mobile") {
            opener.fn_PopClose();
            opener.fn_getPreBookOrderList();

        } else {
        	fn_getPreBookOrderList();
            $('#_divPreOrdRegPop').remove();
        }
    }

    function fn_closePreOrdRegPop2() {

        // 20190925 KR-OHK Moblie Popup Setting
        if(Common.checkPlatformType() == "mobile") {
            self.close();
        } else {
            $('#_divPreOrdRegPop').remove();
        }
    }

    function fn_loadOrderSalesman(memId, memCode) {
        $('#salesmanCd').val('');
        $('#salesmanNm').val('');

        Common.ajax("GET", "/sales/order/selectMemberByMemberIDCode.do", {memId : memId, memCode : memCode}, function(memInfo) {

            if(memInfo == null) {
                Common.alert('<b>Member not found.</br>Your input member code : '+memCode+'</b>');

            } else {
                $('#salesmanCd').val(memInfo.memCode);
                $('#salesmanNm').val(memInfo.name);
                fn_checkPreBookSalesPerson(memId,memCode);
            }
        });
    }


    function fn_setOptGrpClass() {
        $("optgroup").attr("class" , "optgroup_text")
    }

    function fn_checkPreBookSalesPerson(memId,memCode) {
    	Common.ajax("GET", "/homecare/sales/order/checkPreBookSalesPerson.do", {memId : memId, memCode : memCode}, function(memInfo) {
    		if(memInfo == null) {
                Common.alert('<b>Your input member code : '+ memCode +' is not allowed for pre-book.</b>');
                $('#salesmanCd').val('');
                $('#salesmanNm').val('');
            }
    	});
    }

    function fn_checkRc(nric) {
        Common.ajax("GET", "/sales/order/checkRC.do", {nric : nric}, function(result) {
            if(result != null) {
                if(result.rookie == 1) {
                    if(result.rcPrct != null) {
                        if(result.opCnt == 0 && result.rcPrct <= 50) {
                            Common.alert(result.memCode + " (" + result.memCode + ") is not allowed to key in due to Individual SHI below 55%");
                            return false;
                        } else if(result.opCnt > 0) {
                            // Own Purchase
                            /* if(result.flg12Month == 0) {
                                Common.alert(result.name + " (" + result.memCode + ") is not allowed for own purchase due member join less than 12 months.");
                                return false;
                            } */
                            if(result.rcPrct <= 55) {
                                Common.alert(result.name + " (" + result.memCode + ") is not allowed for own purchase key in due to RC below 55%.");
                                return false;
                            }
                        }
                    }  else {
                        Common.alert("Currently" + result.name + " (" + result.memCode + ") Has empty data for RC. Kindly refer IT and raise Ticket");
                        return false;
                    }
                } else {
                    Common.alert(result.memCode + " (" + result.memCode + ") is still a rookie, no key in is allowed.");
                    return false;
                }
            }

            fn_loadCustomer(null, nric);
        });
    }

    function fn_loadCustomer(custId, nric){
        Common.ajax("GET", "/sales/customer/selectCustomerJsonList", {custId : custId, nric : nric}, function(result) {
            Common.removeLoader();
            if(result != null && result.length >= 1) {

                $('#scPreOrdArea').removeClass("blind");

                var custInfo = result[0];
                var dob = custInfo.dob;
                var dobY = dob.split("/")[2];
                var nowDt = new Date();
                var nowDtY = nowDt.getFullYear();

                if(dobY != 1900) {
                    if((nowDtY - dobY) < 18) {
                        Common.alert("Pre-Booking Summary" + DEFAULT_DELIMITER + "<b>* Member must 18 years old and above.</b>");
                        $('#scPreOrdArea').addClass("blind");
                        return false;
                    }
                }

                $("#hiddenCustId").val(custInfo.custId); //Customer ID(Hidden)
                $("#custTypeNm").val(custInfo.codeName1); //Customer Name
                $("#hiddenTypeId").val(custInfo.typeId); //Type
                $("#name").val(custInfo.name); //Name
                $("#nric").val(custInfo.nric); //NRIC/Company No

                $("#hiddenCustStatusId").val(custInfo.custStatusId); //Customer Status
                $("#custStatus").val(custInfo.custStatus); //Customer Status

                $("#nationNm").val(custInfo.name2); //Nationality
                $("#race").val(custInfo.codeName2); //
                $("#dob").val(custInfo.dob == '01/01/1900' ? '' : custInfo.dob); //DOB
                $("#gender").val(custInfo.gender); //Gender
                $("#pasSportExpr").val(custInfo.pasSportExpr == '01/01/1900' ? '' : custInfo.pasSportExpr); //Passport Expiry
                $("#visaExpr").val(custInfo.visaExpr == '01/01/1900' ? '' : custInfo.visaExpr); //Visa Expiry
                $("#custEmail").val(custInfo.email); //Email

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

                if(custInfo.custAddId > 0) {
                    //----------------------------------------------------------
                    // [Billing Detail] : Billing Address SETTING
                    //----------------------------------------------------------
                    //fn_loadBillAddr(custInfo.custAddId);

                    //----------------------------------------------------------
                    // [Installation] : Installation Address SETTING
                    //----------------------------------------------------------
                    fn_loadInstallAddr(custInfo.custAddId);
                }

                if(custInfo.custCntcId > 0) {
                    //----------------------------------------------------------
                    // [Master Contact] : Owner & Purchaser Contact
                    //                    Additional Service Contact
                    //----------------------------------------------------------
                    fn_loadMainCntcPerson(custInfo.custCntcId);
                    fn_loadCntcPerson(custInfo.custCntcId);
                }

                if(custInfo.codeName == 'Government') {
                    Common.alert('<b>Goverment Customer</b>');
                }

            } else {
                Common.confirm('<b>* This customer is NEW customer.<br>Do you want to create a customer?</b>', fn_createCustomerPop, fn_closePreOrdRegPop2);
            }
        });
    }

    function fn_resetSales() {

    }

    function fn_loadInstallAddr(custAddId){
        Common.ajax("GET", "/sales/order/selectCustAddJsonInfo.do", {custAddId : custAddId, 'isHomecare' : 'Y'}, function(custInfo) {

            if(custInfo != null) {
                $("#hiddenCustAddId").val(custInfo.custAddId); //Customer Address ID(Hidden)
                $("#instAddrDtl").val(custInfo.addrDtl); //Address
                $("#instStreet").val(custInfo.street); //Street
                $("#instArea").val(custInfo.area); //Area
                $("#instCity").val(custInfo.city); //City
                $("#instPostCode").val(custInfo.postcode); //Post Code
                $("#instState").val(custInfo.state); //State
                $("#instCountry").val(custInfo.country); //Country

                $("#dscBrnchId").val(custInfo.brnchId); //DSC Branch
                if(MEM_TYPE == 2)
                    $("#keyinBrnchId").val(custInfo.cdBrnchId); //Posting Branch
                else if (MEM_TYPE == 7)
                	$("#keyinBrnchId").val(284); //Posting Branch
                else
                    $("#keyinBrnchId").val(custInfo.soBrnchId); //Posting Branch


            }
        });
    }

    function fn_loadInstallAddrForDiffBranch(custAddId, isHomecare,isAC) {
        Common.ajax("GET", "/sales/order/selectCustAddJsonInfo.do", {custAddId : custAddId, 'isHomecare' : isHomecare,'isAC' : isAC}, function(custInfo) {

            if(custInfo != null) {
                $("#hiddenCustAddId").val(custInfo.custAddId); //Customer Address ID(Hidden)
                $("#instAddrDtl").val(custInfo.addrDtl); //Address
                $("#instStreet").val(custInfo.street); //Street
                $("#instArea").val(custInfo.area); //Area
                $("#instCity").val(custInfo.city); //City
                $("#instPostCode").val(custInfo.postcode); //Post Code
                $("#instState").val(custInfo.state); //State
                $("#instCountry").val(custInfo.country); //Country

                $("#dscBrnchId").val(custInfo.brnchId); //DSC Branch
                if(MEM_TYPE == 2)
                    $("#keyinBrnchId").val(custInfo.cdBrnchId); //Posting Branch
                else if (MEM_TYPE == 7)
                	$("#keyinBrnchId").val(284); //Posting Branch
                else
                    $("#keyinBrnchId").val(custInfo.soBrnchId); //Posting Branch

            }
        });
    }

    function fn_createCustomerPop() {
        Common.popupWin("frmCustSearch", "/sales/customer/customerRegistPopESales.do", {width : "1220px", height : "690", resizable: "no", scrollbars: "no"});
    }

    function fn_loadMainCntcPerson(custCntcId){
        Common.ajax("GET", "/sales/order/selectCustCntcJsonInfo.do", {custCntcId : custCntcId}, function(custCntcInfo) {

            if(custCntcInfo != null) {
                $("#hiddenCustCntcId").val(custCntcInfo.custCntcId);
                $("#custInitial").val(custCntcInfo.code);
                $("#custEmail").val(custCntcInfo.email);
            }
        });
    }

    function fn_loadSrvCntcPerson(custCareCntId) {
        Common.ajax("GET", "/sales/order/selectSrvCntcJsonInfo.do", {custCareCntId : custCareCntId}, function(srvCntcInfo) {

            if(srvCntcInfo != null) {
                //hiddenBPCareId
                $("#hiddenBPCareId").val(srvCntcInfo.custCareCntId);
                $("#custCntcName").val(srvCntcInfo.name);
                $("#custCntcInitial").val(srvCntcInfo.custInitial);
                $("#custCntcEmail").val(srvCntcInfo.email);
                $("#custCntcTelM").val(srvCntcInfo.telM);
                $("#custCntcTelR").val(srvCntcInfo.telR);
                $("#custCntcTelO").val(srvCntcInfo.telO);
                $("#custCntcTelF").val(srvCntcInfo.telf);
                $("#custCntcExt").val(srvCntcInfo.ext);
            }
        });
    }

    function fn_loadCntcPerson(custCntcId){
        Common.ajax("GET", "/sales/order/selectCustCntcJsonInfo.do", {custCntcId : custCntcId}, function(custCntcInfo) {

            if(custCntcInfo != null) {
                $("#hiddenCustCntcId").val(custCntcInfo.custCntcId);
                $("#custCntcInitial").val(custCntcInfo.code);
                $("#custCntcName").val(custCntcInfo.name1);
                $("#custCntcEmail").val(custCntcInfo.email);
                $("#custCntcTelM").val(custCntcInfo.telM1);
                $("#custCntcTelR").val(custCntcInfo.telR);
                $("#custCntcTelO").val(custCntcInfo.telO);
                $("#custCntcTelF").val(custCntcInfo.telf);
                $("#custCntcExt").val(custCntcInfo.ext);
            }
        });
    }

    function chgTab(tabNm) {
        switch(tabNm) {
            case 'ord' :    // Order Info
            	if(MEM_TYPE == "1" || MEM_TYPE == "2" || MEM_TYPE == "7" ){
                    $('#memBtn').addClass("blind");
                    $('#salesmanCd').prop("readonly",true).addClass("readonly");;
                    $('#salesmanCd').val("${SESSION_INFO.userName}");
                    $('#salesmanCd').change();
                }


                break;


                case 'sal' :

                    var todayDD = Number(TODAY_DD.substr(0, 2));
                    var todayYY = Number(TODAY_DD.substr(6, 4));

                    var strBlockDtFrom = blockDtFrom + BEFORE_DD.substr(2);

                    var strBlockDtTo = blockDtTo + TODAY_DD.substr(2);
                    if ($("#exTrade").val() == 1) {

                        if (todayDD >= blockDtFrom || todayDD <= blockDtTo) { // Block if date > 22th of the month
                               var msg = "Extrade sales key-in does not meet period date (Submission start on 3rd of every month)";
                               Common.alert('<spring:message code="sal.alert.msg.actionRestriction" />'+ DEFAULT_DELIMITER + "<b>" + msg + "</b>",'');
                        return;
                    }
                }

                break;

            default :
                break;
        }
    }

    function encryptIc(nric){
        $('#nric').attr("placeholder", nric.substr(0).replace(/[\S]/g,"*"));
    }


</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Pre-Booking (HC)</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="btnPreOrdClose" onClick="javascript:fn_closePreOrdRegPop2();" href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<ul class="right_btns">
    <li><p class="btn_blue"><a id="btnConfirm" href="#">Confirm</a></p></li>
    <li><p class="btn_blue"><a id="btnClear" href="#">Clear</a></p></li>
</ul>
</aside><!-- title_line end -->
<form id="frmCustSearch" name="frmCustSearch" action="#" method="post">
    <input id="selType" name="selType" type="hidden" value="1" />
    <input id="callPrgm" name="callPrgm" type="hidden" value="PRE_ORD" />
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>

           <%--  <tr>
                    <th scope="row"><spring:message code="sal.text.custType" /><span class="must">*</span></th>
                     <td>
                      <select name="cmbTypeId" id="cmbTypeId" >
                        <option value="">Please Choose a Customer Type</option>
                        <option value="965">Company</option>
                        <option value="964">Individual</option>
                        </select>
                     </td>
              </tr> --%>

<tr>
    <th scope="row">NRIC/Company No</th>
    <td colspan="3" ><input id="nric" name="nric" type="text" title="" placeholder="" class="w100p" style="min-width:150px"  value=""'/></td>
</tr>
<!-- <tr>
    <th scope="row">SOF No</th>
    <td colspan="3" ><input id="sofNo" name="sofNo" type="text" title="" placeholder="" class="w100p" style="min-width:150px" maxlength="20" value=""'/></td>
</tr> -->
<tr>
    <th scope="row" colspan="4" ><span class="must"><spring:message code='sales.msg.ordlist.icvalid'/></span></th>
</tr>
</tbody>
</table><!-- table end -->
</form>
<!------------------------------------------------------------------------------
    Pre-Order Regist Content START
------------------------------------------------------------------------------->
<section id="scPreOrdArea" class="blind">

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1 num4">
    <li><a id="aTabCS" class="on">Customer</a></li>
    <li><a id="aTabOI" onClick="javascript:chgTab('ord');">Order Info</a></li>
<!--     <li><a id="aTabBD" onClick="javascript:chgTab('pay');">Payment Info</a></li>
    <li><a id="aTabFL" >Attachment</a></li> -->
</ul>

<article class="tap_area"><!-- tap_area start -->

<section class="search_table"><!-- search_table start -->
<form id="frmPreOrdReg" name="frmPreOrdReg" action="#" method="post">
    <input id="hiddenCustId" name="custId"   type="hidden"/>
    <input id="hiddenTypeId" name="typeId"   type="hidden"/>
    <input id="hiddenCustCntcId" name="custCntcId" type="hidden" />
    <input id="hiddenCustAddId" name="custAddId" type="hidden" />
    <input id="hiddenCallPrgm" name="callPrgm" type="hidden" />

<aside class="title_line"><!-- title_line start -->
<h3>Customer information</h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:40%" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.custType2" /><span class="must">*</span></th>
    <td><input id="custTypeNm" name="custTypeNm" type="text" title="" placeholder="" class="w100p readonly" /></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.initial2" /><span class="must">*</span></th>
    <td><input id="custInitial" name="custInitial" type="text" title="Initial" placeholder="Initial" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.companyType2" /></th>
    <td><input id="corpTypeNm" name="corpTypeNm" type="text" title="" placeholder="" class="w100p readonly" /></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.custName2" /><span class="must">*</span></th>
    <td><input id="name" name="name" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
</tr>

</tbody>
</table><!-- table end -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:40%" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.nationality2" /><span class="must">*</span></th>
    <td><input id="nationNm" name="nationNm" type="text" title="" placeholder="Nationality" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Passport Visa expiry date | Visa passport tarikh tamat(foreigner)</th>
    <td><input id="visaExpr" name="visaExpr" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Passport expiry date | Pasport tarikh luput(foreigner)</th>
    <td><input id="pasSportExpr" name="pasSportExpr" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.dob2" /></th>
    <td><input id="dob" name="dob" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.race2" /><span class="must">*</span></th>
    <td><input id="race" name="race" type="text" title="Create start Date" placeholder="Race" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.gender2" /></th>
    <td><input id="gender" name="gender" type="text" title="" placeholder="Gender" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.email2" /></th>
    <td><input id="custEmail" name="custCntcEmail" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
</tr>
 <tr>
	<th scope="row">Receiving Marketing Message</th>
	<td>
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
				    <td><input id="custStatus" name="custStatus" type="text" title="" placeholder="" class="w100p readonly" readonly/>
				    <input id="hiddenCustStatusId" name="hiddenCustStatusId" type="hidden" /></td>
				</tr>
<!-- <tr>
    <th scope="row">Tel (Mobile)</th>
    <td><input id="custTelM" name="custTelM" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Tel (Residence)</th>
    <td><input id="custTelR" name="custTelR" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
    <th scope="row">Tel (Fax)<span class="must">*</span></th>
    <td><input id="custTelF" name="custTelF" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Tel (Office)</th>
    <td><input id="custTelO" name="custTelO" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Ext No.</th>
    <td><input id="custExt" name="custExt" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
</tr> -->
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h3>Contact Person information</h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:250px" />
    <col style="width:*" />
    <col style="width:250px" />
    <col style="width:*" />
</colgroup>
<tbody>
<!-- <tr>
    <th scope="row">If contact same as above click here</th>
    <td colspan="3"><input id="chkSameCntc" type="checkbox" checked/></td>
</tr> -->
</tbody>
</table><!-- table end -->

<section id="scAnothCntc">

<ul class="right_btns mb10">
    <li><p class="btn_grid"><a id="btnSelCntc" href="#">Select Another Contact</a></p></li>
    <li><p class="btn_grid"><a id="btnNewCntc" href="#">Add New Contact</a></p></li>
</ul>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:40%" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <!-- <th scope="row">Initial<span class="must">*</span></th>
    <td><input id="custCntcInitial" name="custCntcInitial" type="text" title="Create start Date" placeholder="Race" class="w100p readonly" readonly/></td> -->
    <th scope="row">Second/Service contact person name</th>
    <td><input id="custCntcName" name="custCntcName" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Tel (Mobile)<span class="must">*</span></th>
    <td><input id="custCntcTelM" name="custCntcTelM" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
    </tr>
<tr>
    <th scope="row">Tel (Residence)<span class="must">*</span></th>
    <td><input id="custCntcTelR" name="custCntcTelR" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Tel (Office)<span class="must">*</span></th>
    <td><input id="custCntcTelO" name="custCntcTelO" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Tel (Fax)<span class="must">*</span></th>
    <td><input id="custCntcTelF" name="custCntcTelF" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Ext No.(1)</th>
    <td><input id="custCntcExt" name="custCntcExt" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Email(1)</th>
    <td><input id="custCntcEmail" name="custCntcEmail" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
</tr>
</tbody>
</table><!-- table end -->
</section>

<aside class="title_line"><!-- title_line start -->
<h3>Installation Address &amp; Information</h3>
</aside><!-- title_line end -->

<ul class="right_btns mb10">
    <li><p class="btn_grid"><a id="btnSelInstAddr" href="#">Select Existing Address</a></p></li>
    <li><p class="btn_grid"><a id="btnNewInstAddr" href="#">Add New Address</a></p></li>
</ul>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Address Line 1<span class="must">*</span></th>
    <td colspan="3"><input id="instAddrDtl" name="instAddrDtl" type="text" title="" placeholder="Address Detail" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Address Line 2<span class="must">*</span></th>
    <td colspan="3"><input id="instStreet" name="instStreet" type="text" title="" placeholder="Street" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Area | Daerah<span class="must">*</span></th>
    <td colspan="3"><input id="instArea" name="instArea" type="text" title="" placeholder="Area" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">City | Bandar<span class="must">*</span></th>
    <td colspan="3"><input id="instCity" name="instCity" type="text" title="" placeholder="City" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">PostCode | Poskod<span class="must">*</span></th>
    <td colspan="3"><input id="instPostCode" name="instPostCode" type="text" title="" placeholder="Post Code" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">State | Negeri<span class="must">*</span></th>
    <td colspan="3"><input id="instState" name="instState" type="text" title="" placeholder="State" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Country | Negara<span class="must">*</span></th>
    <td colspan="3"><input id="instCountry" name="instCountry" type="text" title="" placeholder="Country" class="w100p readonly" readonly/></td>
</tr>

</tbody>
</table><!-- table end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">DT Branch<span class="must">*</span></th>
    <td colspan="3"><select id="dscBrnchId" name="dscBrnchId" class="w100p" disabled></select></td>
</tr>
<tr>
    <th scope="row">Posting Branch<span class="must">*</span></th>
    <td colspan="3"><select id="keyinBrnchId" name="keyinBrnchId" class="w100p" disabled></select></td>
</tr>
<tr>
    <th scope="row">Prefer Install Date<span class="must">*</span></th>
    <td colspan="3"><input id="prefInstDt" name="prefInstDt" type="text" title="Create start Date" placeholder="Prefer Install Date (dd/MM/yyyy)" class="j_date w100p" value="${nextDay}"  disabled/></td>
</tr>
<tr>
    <th scope="row">Prefer Install Time<span class="must">*</span></th>
    <td colspan="3">
    <div class="time_picker"><!-- time_picker start -->
    <input id="prefInstTm" name="prefInstTm" type="text" title="" placeholder="Prefer Install Time (hh:mi tt)" class="time_date w100p" value="11:00 AM" disabled/>
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
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<section class="search_table"><!-- search_table start -->

<aside class="title_line"><!-- title_line start -->
<h3>Order information</h3>
</aside><!-- title_line end -->
<table class="type1"><!-- table start -->
	<caption>table</caption>
	<colgroup>
	    <col style="width:40%" />
	    <col style="width:*" />
	</colgroup>
	<tbody>
		<tr>
		    <th scope="row">Ex-Trade/Related No<span class="must">*</span></th>
		    <td><p><select id="exTrade" name="exTrade" class="w100p">
		    <option value="2301" selected>Ex-trade</option></select></p>
		        <a id="btnRltdNoEKeyIn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
                <p><input id="relatedNo" name="relatedNo" type="text" title="" placeholder="Related Number" class="w100p readonly" readonly /></p>
                <!-- <a><input id="isReturnExtrade" name="isReturnExtrade" type="checkbox" disabled/> Return ex-trade product</a></td> -->
                <input id="txtOldOrderID"  name="txtOldOrderID" data-ref='' type="hidden" />
                <input id="txtBusType"  name="txtBusType" type="hidden" />
		</tr>

		<tr>
		    <th scope="row">Product | Produk<span class="must">*</span></th>
		    <td><select id="preOrdProduct" name="preOrdProduct" class="w100p"></select>
		    </td>
		</tr>

		<tr>
		    <th scope="row">Salesman Code / Name<span class="must">*</span></th>
		    <td><input id="salesmanCd" name="salesmanCd" type="text" style="width:115px;" title="" placeholder="" class=""/>
		        <a id="memBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
		        <p><input id="salesmanNm" name="salesmanNm" type="text" class="w100p readyonly" title="" placeholder="Salesman Name" disabled/></p>
		    </td>
		</tr>
		<tr>
		    <th scope="row">Remark</th>
		    <td><textarea id="preRemark" name="preRemark" cols="20" rows="5"></textarea></td>
		</tr>

	</tbody>
</table><!-- table end -->


<br><br><br><br><br>
</section><!-- search_table end -->

</article><!-- tap_area end -->


</section><!-- tap_wrap end -->

<ul class="center_btns mt20">
    <li><p class="btn_blue2 big"><a id="btnSave" href="#">Save</a></p></li>
</ul>

</section>
<!------------------------------------------------------------------------------
    Pre-Order Regist Content END
------------------------------------------------------------------------------->
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
