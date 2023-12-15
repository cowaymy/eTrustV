<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
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
    var MEM_TYPE     = '${SESSION_INFO.userTypeId}';

    var codeList_325 = [];
    <c:forEach var="obj" items="${codeList_325}">
    codeList_325.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
    </c:forEach>

    var branchCdList_1 = [];
    <c:forEach var="obj" items="${branchCdList_1}">
    branchCdList_1.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
    </c:forEach>

    var branchCdList_5 = [];
    <c:forEach var="obj" items="${branchCdList_5}">
    branchCdList_5.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
    </c:forEach>


    $(document).ready(function(){
    	doDefComboCode(codeList_325, '0', 'exTrade', 'S', '');    // EX-TRADE
    	doDefCombo(branchCdList_1, '', 'keyinBrnchId', 'S', '');    // Branch Code
    	doDefCombo(branchCdList_5, '', 'dscBrnchId', 'S', '');      // Branch Code

        $('#exTrade option[value="1"]').attr('selected', 'selected');
        $('#btnRltdNoEKeyIn').removeClass("blind");

        doGetComboAndGroup2('/common/selectProductCodeList.do', {selProdGubun: 'EXHC'}, '', 'ordProd', 'S', 'fn_setOptGrpClass');

        $("#nric").keyup(function(){$(this).val($.trim($(this).val().toUpperCase()));});

        $('#nric').keypress(function (e) {
            var regex = new RegExp("^[a-zA-Z0-9\s]+$");
            var str = String.fromCharCode(!e.charCode ? e.which : e.charCode);
            if (regex.test(str)) {
                return true;
            }
            e.preventDefault();
            return false;
        });
    });

    $(function(){
    	$('#btnRltdNoEKeyIn').click(function() {
            $("#hiddenIsPreBooking").val('1');
    		Common.popupDiv("/sales/order/preBooking/preBookPrevOrderNoPop.do", {custId : $('#hiddenCustId').val(), isPreBooking:  $('#hiddenIsPreBooking').val()}, null, true);
    	});

       $('#btnConfirm').click(function() {
            if(!fn_validConfirm())  return false;
            $('#nric').prop("readonly", true).addClass("readonly");
            $('#btnConfirm').addClass("blind");
            $('#btnClear').addClass("blind");
            $("#btnPreBookingSave").show();

            fn_loadCustomer(null, $('#nric').val());
        });

        $('#nric').keydown(function (event) {
            if (event.which === 13) {
                if(!fn_validConfirm())  return false;

                if(fn_isExistESalesNo() == 'true') return false;

                $('#nric').prop("readonly", true).addClass("readonly");
                $('#sofNo').prop("readonly", true).addClass("readonly");
                $('#btnConfirm').addClass("blind");
                $('#btnClear').addClass("blind");

                fn_loadCustomer(null, $('#nric').val());
            }
        });

        $('#chkSameCntc').click(function() {
            if($('#chkSameCntc').is(":checked")) {
                $('#scAnothCntc').addClass("blind");
            }
            else {
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

        $('#billNewAddrBtn').click(function() {
            Common.popupDiv("/sales/customer/updateCustomerNewAddressPop.do", {custId : $('#hiddenCustId').val(), callParam : "PRE_ORD_BILL_ADD"}, null , true);
        });

        $('#billSelAddrBtn').click(function() {
            Common.popupDiv("/sales/customer/customerAddressSearchPop.do", {custId : $('#hiddenCustId').val(), callPrgm : "PRE_ORD_BILL_ADD"}, null, true);
        });

        $('#exTrade').change(function() {

            $('#ordPromo option').remove();
            fn_clearAddCpnt();
           // $('#relatedOrdNo').val("");
            $('#isReturnExtrade').prop("checked", false);

            if($("#exTrade").val() == '1' || $("#exTrade").val() == '2') {
                $('#btnRltdNoEKeyIn').removeClass("blind");

                if($('#exTrade').val()=='1'){
                	$('#isReturnExtrade').prop("checked", true);

                    var todayDD = Number(TODAY_DD.substr(0, 2));
                    var todayYY = Number(TODAY_DD.substr(6, 4));

                    var strBlockDtFrom = blockDtFrom + BEFORE_DD.substr(2);
                    var strBlockDtTo = blockDtTo + TODAY_DD.substr(2);

                     if(todayDD >= blockDtFrom || todayDD <= blockDtTo) { // Block if date > 22th of the month
                         var msg = "Extrade sales key-in does not meet period date (Submission start on 3rd of every month)";
                         Common.alert('<spring:message code="sal.alert.msg.actionRestriction" />' + DEFAULT_DELIMITER + "<b>" + msg + "</b>", '');
                         return;
                     }
               }
            }
            else {
                $('#relatedOrdNo').val('');
                $('#btnRltdNoEKeyIn').addClass("blind");
            }

            $('#isReturnExtrade').attr("disabled",true);
            $('#ordProd').val('');
            $('#speclInstct').val('');
        });

        $('#ordProd').change(function() {
            if(FormUtil.checkReqValue($('#exTrade'))) {
                Common.alert("Save Sales Order Summary" + DEFAULT_DELIMITER + "<b>* Please select an Ex-Trade.</b>");
                $('#ordProd').val('');
                return;
            }

            var exTrade    = $("#exTrade").val();
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
    });


    function fn_validOrderInfo() {
        var isValid = true, msg = "";

        var custType = $("#hiddenTypeId").val();
        var exTrade = $("#exTrade").val();

        if(FormUtil.checkReqValue($('#salesmanCd')) && FormUtil.checkReqValue($('#salesmanNm'))) {
                isValid = false;
                msg += "* Please select a salesman.<br>";
        }

        if($('#txtOldOrderID').val().trim() == null || $('#txtOldOrderID').val().trim() == ''){
            isValid = false;
            msg += "* Please select a Ex-trade order.<br>";
       }

       if($("#ordProd option:selected").index() <= 0) {
           isValid = false;
           msg += "* Please select the Product.<br>";
       }

        if(!isValid)
        	Common.alert("Save Pre-Booking Order Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");
        return isValid;
    }

    function fn_validConfirm() {
        var isValid = true, msg = "";

        var nric = $('#nric').val();

        if(FormUtil.checkReqValue($('#nric'))) {
            isValid = false;
            msg += "* Please key in NRIC/Company No.<br>";
        }else{
        	//check if NRIC is Numeric, else company number (includes alphabet)
        	var nric_trim = $("#nric").val().replace(/ |-|_/g,'');

            if($.isNumeric($("#nric_trim").val())){
                var dob = Number($('#nric').val().substr(0,2));
                var nowDt = new Date();
                var nowDtY = Number(nowDt.getFullYear().toString().substr(-2));
                var age = nowDtY- dob < 0 ? nowDtY- dob + 100 : nowDtY- dob ;

                if(age < 18) {
                    Common.alert("Pre-Booking Order Summary" + DEFAULT_DELIMITER + "<b>* Member must 18 years old and above.</b>");
                    $('#scPreBookingOrdArea').addClass("blind");
                    return false;
                }
            }
        }

        if(!isValid) Common.alert("Pre-Booking Order Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");
        return isValid;
    }

    function fn_validCustomer() {
        var isValid = true, msg = "";

        if(FormUtil.checkReqValue($('#hiddenCustId'))) {
            isValid = false;
            msg += "* Please select a customer.<br>";
        }

        if($('#hiddenTypeId').val() != '964') {
            isValid = false;
            msg = "* Please select an individual customer<br>";
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

        if(!isValid) Common.alert("Save Pre-Booking Order Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");
        return isValid;
    }

    function fn_doSavePreBookingOrder() {
        if(!fn_validCustomer()) {
            $('#aTabCS').click();
            return false;
        }

        if(!fn_validOrderInfo()) {
            $('#aTabOI').click();
            return false;
        }

        var orderVO = {
                custId                  : $('#hiddenCustId').val(),
                custContactNumber: $("#custCntcTelM").val(),
                memCode             : $('#salesmanCd').val(),
                salesOrdIdOld       : $('#txtOldOrderID').val(),
                salesOrdNoOld      : $('#relatedOrdNo').val(),
                relatedNo              : $('#relatedOrdNo').val(),
                rem                      : $('#preBookRemark').val(),
                stkId                    : $('#ordProd').val(),
                postCode              : $('#instPostCode').val(),
                receivingMarketingMsgStatus   : $('input:radio[name="marketingMessageSelection"]:checked').val()
        };

        Common.ajax("GET",
        		            "/sales/order/preBooking/selectPreBookOrderVerifyStus.do",
        		           {custId : $('#hiddenCustId').val(), salesOrdIdOld : $('#txtOldOrderID').val()},
        		           function(result){
                               if(result != null){
                            	   if(result.custVerifyStus == 'ACT'){
                            		   Common.alert("Pre-Booking Alert" + DEFAULT_DELIMITER + "<b>This Order currently in progress being pre-book with Order No. " + result.preBookNo + ". You are not allowed to proceed pre-book for this order.</b>", fn_closePreBookingOrdRegPop);
                            	   }else if(result.custVerifyStus == 'Y'){
                            		   Common.alert("Pre-Booking Alert" + DEFAULT_DELIMITER + "<b>This Order had been pre-book with Order No." + result.preBookNo +". You are not allowed to proceed pre-book for this order.</b>", fn_closePreBookingOrdRegPop);
                            	   }
                               }else{
                            	   Common.ajax("POST", "/sales/order/preBooking/registerPreBooking.do", orderVO, function(result) {
                                       Common.alert("Order Saved" + DEFAULT_DELIMITER + "<b>"+result.message+"</b>", fn_closePreBookingOrdRegPop);
                                   },
                                   function(jqXHR, textStatus, errorThrown) {
                                       try {
                                           Common.alert("Failed To Save" + DEFAULT_DELIMITER + "<b>Failed to save order. " + jqXHR.responseJSON.message + "</b>");
                                           Common.removeLoader();
                                       }
                                       catch (e) {
                                           console.log(e);
                                       }
                                   });
                               }
                           }
        );
    }

    function fn_closePreBookingOrdRegPop() {
        $('#btnCnfmPreBookingOrderClose').click();
        fn_getPreBookingOrderList();
        $('#_divPreBookingOrdRegPop').remove();

    }

    function fn_closePreBookingOrdRegPop2() {
            $('#_divPreBookingOrdRegPop').remove();
    }

    function fn_loadOrderSalesman(memId, memCode) {
        console.log('fn_loadOrderSalesman memId:'+memId);
        console.log('fn_loadOrderSalesman memCd:'+memCode);

        $('#salesmanCd').val('');
        $('#salesmanNm').val('');

        Common.ajax("GET", "/sales/order/selectMemberByMemberIDCode.do", {memId : memId, memCode : memCode}, function(memInfo) {
            if(memInfo == null) {
                Common.alert('<b>Member not found.</br>Your input member code : '+memCode+'</b>');
            }
            else {
                $('#salesmanCd').val(memInfo.memCode);
                $('#salesmanNm').val(memInfo.name);

                if(memInfo.memCode == "100116" || memInfo.memCode == "100224"){
                    return;
                }else{
                     fn_checkPreBookSalesPerson(memId,memCode);
                }
            }
        });
    }

    function fn_checkPreBookSalesPerson(memId,memCode) {
        Common.ajax("GET", "/sales/order/preBooking/checkPreBookSalesPerson.do", {memId : memId, memCode : memCode}, function(memInfo) {
            if(memInfo == null) {
                Common.alert('<b>Your input member code : '+ memCode +' is not allowed for pre-book.</b>');
                $('#salesmanCd').val('');
                $('#salesmanNm').val('');
            }
        });
    }

    function fn_setOptGrpClass() {
        $("optgroup").attr("class" , "optgroup_text")
    }

    function fn_loadCustomer(custId, nric){
        Common.ajax("GET", "/sales/customer/selectCustomerJsonList", {custId : custId, nric : nric}, function(result) {
            Common.removeLoader();

            if(result.length > 0 ) {
                $('#scPreBookingOrdArea').removeClass("blind");

                var custInfo = result[0];
                var dob = custInfo.dob;
                var dobY = dob.split("/")[2];
                var nowDt = new Date();
                var nowDtY = nowDt.getFullYear();

                if(!nric.startsWith("TST")){
	                if(dobY != 1900) {
	                    if((nowDtY - dobY) < 18) {
	                        Common.alert("Pre-Booking Order Summary" + DEFAULT_DELIMITER + "<b>* b Member must 18 years old and above.</b>");
	                        $('#scPreBookingOrdArea').addClass("blind");
	                        return false;
	                    }
	                }

                }

                $("#hiddenCustId").val(custInfo.custId); //Customer ID(Hidden)
                $("#custTypeNm").val(custInfo.codeName1); //Customer Name
                $("#hiddenTypeId").val(custInfo.typeId); //Type
                $("#name").val(custInfo.name); //Name
                $("#nric").val(custInfo.nric); //NRIC/Company No
                $("#nationNm").val(custInfo.name2); //Nationality
                $("#race").val(custInfo.codeName2); //
                $("#dob").val(custInfo.dob == '01/01/1900' ? '' : custInfo.dob); //DOB
                $("#gender").val(custInfo.gender); //Gender
                $("#pasSportExpr").val(custInfo.pasSportExpr == '01/01/1900' ? '' : custInfo.pasSportExpr); //Passport Expiry
                $("#visaExpr").val(custInfo.visaExpr == '01/01/1900' ? '' : custInfo.visaExpr); //Visa Expiry
                $("#custEmail").val(custInfo.email); //Email
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
                }
                else {
                    $("#corpTypeNm").val(""); //Industry Code
                }

                if(custInfo.custAddId > 0) {

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

            }

        });
    }


    function fn_loadInstallAddr(custAddId){
        Common.ajax("GET", "/sales/order/selectCustAddJsonInfo.do", {custAddId : custAddId}, function(custInfo) {
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
    	if(Common.checkPlatformType() == "mobile") {
            var strDocumentWidth = $(document).outerWidth();
            var strDocumentHeight = $(document).outerHeight();
            Common.popupWin("frmCustSearch", "/sales/customer/customerRegistPopESales.do", {width : strDocumentWidth+"px", height : strDocumentHeight + "px", resizable: "no", scrollbars: "yes"});
        } else{
        	Common.popupWin("frmCustSearch", "/sales/customer/customerRegistPopESales.do", {width : "1220px", height : "690", resizable: "no", scrollbars: "no"});
        }
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
        case 'ord' :
            	if(MEM_TYPE == "1" || MEM_TYPE == "2" || MEM_TYPE == "7" ){
                    $('#memBtn').addClass("blind");
                    $('#salesmanCd').prop("readonly",true).addClass("readonly");;
                    $('#salesmanCd').val("${SESSION_INFO.userName}");
                    $('#salesmanCd').change();
                }

                if($('#ordProd').val() == null){
                       $('#appType').change();
                }

                $('[name="advPay"]').prop("disabled", true);
                $('#advPayNo').prop("checked", true);
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
<h1>Pre-Booking</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="btnPreBookingOrdClose" onClick="javascript:fn_closePreBookingOrdRegPop2();" href="#">CLOSE</a></p></li>
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
			<tr>
			    <th scope="row">NRIC/Company No</th>
			    <td colspan="3" ><input id="nric" name="nric" type="text" title="" placeholder="" class="w100p" style="min-width:150px"  value=""'/></td>
			</tr>
			<tr>
			    <th scope="row" colspan="4" ><span class="must"><spring:message code='sales.msg.ordlist.icvalid'/></span></th>
			</tr>
		</tbody>
	</table><!-- table end -->
</form>
<!------------------------------------------------------------------------------
    Pre-Booking Order Register Content START
------------------------------------------------------------------------------->
<section id="scPreBookingOrdArea" class="blind">

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1 num4">
    <li><a id="aTabCS" class="on">Customer</a></li>
    <li><a id="aTabOI" onClick="javascript:chgTab('ord');">Order Info</a></li>
  <!-- <li><a id="aTabBD" onClick="javascript:chgTab('pay');">Payment Info</a></li>
    <li><a id="aTabFL" >Attachment</a></li> -->
</ul>

<article class="tap_area"><!-- tap_area start -->

<section class="search_table"><!-- search_table start -->
<form id="frmPreBookingOrdReg" name="frmPreBookingOrdReg" action="#" method="post">
    <input id="hiddenCustId" name="custId"   type="hidden"/>
    <input id="hiddenTypeId" name="typeId"   type="hidden"/>
    <input id="hiddenCustCntcId" name="custCntcId" type="hidden" />
    <input id="hiddenCustAddId" name="custAddId" type="hidden" />
    <input id="hiddenCallPrgm" name="callPrgm" type="hidden" />
    <input id="hiddenCustStatusId" name="hiddenCustStatusId" type="hidden" />
    <input id="hiddenIsPreBooking" name="isPreBooking"   type="hidden"/>
    <input id="hiddenSalesOldOrdId" name="hdnSalesOldOrdId"   type="hidden"/>

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
                <td><input id="custStatus" name="custStatus" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
            </tr>
		</tbody>
	</table><!-- table end -->

	<aside class="title_line"><!-- title_line start -->
	<h3>Contact Person information</h3>
	</aside><!-- title_line end -->

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
    <col style="width:40%" />
    <col style="width:*" />
    <col style="width:40%" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Address Line 1<span class="must">*</span></th>
    <td colspan="3"><input id="instAddrDtl" name="instAddrDtl" type="text" title="" placeholder="eg. NO 10/UNIT 13-02-05/LOT 33945" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Address Line 2<span class="must">*</span></th>
    <td colspan="3"><input id="instStreet" name="instStreet" type="text" title="" placeholder="eg. TAMAN/JALAN/KAMPUNG" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Area | Daerah<span class="must">*</span></th>
    <td colspan="3"><input id="instArea" name="instArea" type="text" title="" placeholder="eg. TAMAN RIMBA" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">City | Bandar<span class="must">*</span></th>
    <td colspan="3"><input id="instCity" name="instCity" type="text" title="" placeholder="eg. KOTA KINABALU" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">PostCode | Poskod<span class="must">*</span></th>
    <td colspan="3"><input id="instPostCode" name="instPostCode" type="text" title="" placeholder="eg. 88450" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">State | Negeri<span class="must">*</span></th>
    <td colspan="3"><input id="instState" name="instState" type="text" title="" placeholder="eg. SABAH" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Country | Negara<span class="must">*</span></th>
    <td colspan="3"><input id="instCountry" name="instCountry" type="text" title="" placeholder="eg. MALAYSIA" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">DSC Branch<span class="must">*</span></th>
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
    <th scope="row">Ex-Trade/Related No</th>
    <td><p><select id="exTrade" name="exTrade" class="w100p"></select></p>
    <a id="btnRltdNoEKeyIn" href="#" class="search_btn blind"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
        <p><input id="relatedOrdNo" name="relatedOrdNo" type="text" title="" placeholder="Related Order Number" class="w100p readonly" readonly/></p>
       <!-- <a><input id="isReturnExtrade" name="isReturnExtrade" type="checkbox" disabled/> Return ex-trade product</a> -->
      <input id="txtOldOrderID"  name="txtOldOrderID" data-ref='' type="hidden" />
      <input id="txtBusType"  name="txtBusType" type="hidden" />
      <input id = "hiddenMonthExpired" name="hiddenMonthExpired" type="hidden"/>
    </td>
</tr>
<tr>
    <th scope="row">Product | Produk<span class="must">*</span></th>
    <td><select id="ordProd" name="ordProd" class="w100p"></select>
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
    <td><textarea id="preBookRemark" name="preBookRemark" cols="20" rows="5"></textarea></td>
</tr>
</tbody>
</table><!-- table end -->

<br><br><br><br><br>
</section><!-- search_table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->
<section id="scPayInfo" class="search_table blind"><!-- search_table start -->
<table class="type1 mb1m"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:40%" />
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
    <td><input id="thrdPartyType" name="thrdPartyType" type="text" title="" placeholder="Customer Type" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Name</th>
    <td><input id="thrdPartyName" name="thrdPartyName" type="text" title="" placeholder="Customer Name" class="w100p readonly" readonly/></td>
    <th scope="row">NRIC/Company No</th>
    <td><input id="thrdPartyNric" name="thrdPartyNric" type="text" title="" placeholder="NRIC/Company Number" class="w100p readonly" readonly/></td>
</tr>
</tbody>
</table><!-- table end -->
</section>

<!------------------------------------------------------------------------------
    Rental Paymode - Form ID(rentPayModeForm)
------------------------------------------------------------------------------->
<section id="sctRentPayMode">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:40%" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th><spring:message code="sal.text.rentalPaymode2" /><span class="must">*</span></th>
    <td  scope="row" >
    <select id="rentPayMode" name="rentPayMode" class="w100p"></select>
    </td>
    <!-- <th scope="row">NRIC on DD/Passbook</th>
    <td><input id="rentPayIC" name="rentPayIC" type="text" title="" placeholder="NRIC appear on DD/Passbook" class="w100p" /></td> -->
</tr>
</tbody>
</table><!-- table end -->

</section>

<section id="sctCrCard" class="blind">

<aside class="title_line"><!-- title_line start -->
<h3>Bank Card</h3>
</aside><!-- title_line end -->

<ul class="right_btns mb10">
    <li><p class="btn_grid"><a id="selCreditCardBtn" href="#">Select Another Credit Card</a></p></li>
    <li><p class="btn_grid"><a id="addCreditCardBtn" href="#">Add New Credit Card</a></p></li>
</ul>
<!------------------------------------------------------------------------------
    Credit Card - Form ID(crcForm)
------------------------------------------------------------------------------->

<table class="type1 mb1m"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:40%" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.creditCardNo2" /></th>
    <td><input id="rentPayCRCNo" name="rentPayCRCNo" type="text" title="" placeholder="Credit Card Number" class="w100p readonly" readonly/>
        <input id="hiddenRentPayCRCId" name="rentPayCRCId" type="hidden" />
        <input id="hiddenRentPayEncryptCRCNoId" name="hiddenRentPayEncryptCRCNoId" type="hidden" /></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.type2" /></th>
    <td><input id="rentPayCRCType" name="rentPayCRCType" type="text" title="" placeholder="Credit Card Type" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.nameOnCard2" /></th>
    <td><input id="rentPayCRCName" name="rentPayCRCName" type="text" title="" placeholder="Name On Card" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.expiryDate2" /></th>
    <td><input id="rentPayCRCExpiry" name="rentPayCRCExpiry" type="text" title="" placeholder="Credit Card Expiry" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.issueBank2" /></th>
    <td><input id="rentPayCRCBank" name="rentPayCRCBank" type="text" title="" placeholder="Issue Bank" class="w100p readonly" readonly/>
        <input id="hiddenRentPayCRCBankId" name="rentPayCRCBankId" type="hidden" title="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.cardType2" /></th>
    <td><input id="rentPayCRCCardType" name="rentPayCRCCardType" type="text" title="" placeholder="Card Type" class="w100p readonly" readonly/></td>
</tr>
</tbody>
</table><!-- table end -->

<!-- <ul class="center_btns">
    <li><p class="btn_blue"><a name="ordSaveBtn" href="#">OK</a></p></li>
</ul> -->
</section>

<section id="sctDirectDebit" class="blind">

<aside class="title_line"><!-- title_line start -->
<h3>Direct Debit</h3>
</aside><!-- title_line end -->

<ul class="right_btns mb10">
    <li><p class="btn_grid"><a id="btnSelBankAccount" href="#">Select Another Bank Account</a></p></li>
    <li><p class="btn_grid"><a id="btnAddBankAccount" href="#">Add New Bank Account</a></p></li>
</ul>
<!------------------------------------------------------------------------------
    Direct Debit - Form ID(ddForm)
------------------------------------------------------------------------------->

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

</section>

</section><!-- search_table end -->

<!--****************************************************************************
    Billing Detail
*****************************************************************************-->
<section class="search_table"><!-- search_table start -->

<!-- New Billing Group Type start -->
<table class="type1" style="display:none"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:40%" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Group Option<span class="must">*</span></th>
    <td>
    <label><input type="radio" id="grpOpt1" name="grpOpt" value="new" /><span>New Billing Group</span></label>
    <label><input type="radio" id="grpOpt2" name="grpOpt" value="exist"/><span>Existion Billing Group</span></label>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<!------------------------------------------------------------------------------
    Billing Method - Form ID(billMthdForm)
------------------------------------------------------------------------------->
<section id="sctBillMthd" class="blind">

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

</section>

<!------------------------------------------------------------------------------
    Billing Address - Form ID(billAddrForm)
------------------------------------------------------------------------------->
<section id="sctBillAddr" class="blind">
    <input id="hiddenBillAddId"     name="custAddId"           type="hidden"/>
    <input id="hiddenBillStreetId"  name="hiddenBillStreetId"  type="hidden"/>

<aside class="title_line"><!-- title_line start -->
<h3>Billing Address</h3>
</aside><!-- title_line end -->

 <ul class="right_btns mb10">
    <li><p class="btn_grid"><a id="billNewAddrBtn" href="#">Add New Address</a></p></li>
    <li><p class="btn_grid"><a id="billSelAddrBtn" href="#">Select Another Address</a></p></li>
</ul>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:40%" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Address Detail<span class="must">*</span></th>
    <td >
    <input id="billAddrDtl" name="billAddrDtl" type="text" title="" placeholder="eg. NO 10/UNIT 13-02-05/LOT 33945" class="w100p readonly" readonly/>
    </td>
</tr>
<tr>
    <th scope="row">Street</th>
    <td >
    <input id="billStreet" name="billStreet" type="text" title="" placeholder="eg. TAMAN/JALAN/KAMPUNG" class="w100p readonly" readonly/>
    </td>
</tr>
<tr>
    <th scope="row">Area<span class="must">*</span></th>
    <td >
    <input id="billArea" name="billArea" type="text" title="" placeholder="eg. TAMAN RIMBA" class="w100p readonly" readonly/>
    </td>
</tr>
<tr>
    <th scope="row">City<span class="must">*</span></th>
    <td >
    <input id="billCity" name="billCity" type="text" title="" placeholder="eg. KOTA KINABALU" class="w100p readonly" readonly/>
    </td>
</tr>
<tr>
    <th scope="row">PostCode<span class="must">*</span></th>
    <td >
    <input id="billPostCode" name="billPostCode" type="text" title="" placeholder="eg. 88450" class="w100p readonly" readonly/>
    </td>
</tr>
<tr>
    <th scope="row">State<span class="must">*</span></th>
    <td >
    <input id="billState" name="billState" type="text" title="" placeholder="eg. SABAH" class="w100p readonly" readonly/>
    </td>
</tr>
<tr>
    <th scope="row">Country<span class="must">*</span></th>
    <td >
    <input id="billCountry" name="billCountry" type="text" title="" placeholder="eg. MALAYSIA" class="w100p readonly" readonly/>
    </td>
</tr>

</tbody>
</table><!-- table end -->
<!-- Existing Type end -->
</section>
<br>

<section id="sctBillPrefer" class="blind">
<aside class="title_line"><!-- title_line start -->
<h3>Billing Preference</h3>
</aside><!-- title_line end -->

<ul class="right_btns mb10">
    <li class="blind"><p class="btn_grid"><a id="billPreferAddAddrBtn" href="#">Add New Contact</a></p></li>
    <li class="blind"><p class="btn_grid"><a id="billPreferSelAddrBtn" href="#">Select Another Contact</a></p></li>
</ul>

<!------------------------------------------------------------------------------
    Billing Preference - Form ID(billPreferForm)
------------------------------------------------------------------------------->
<section class="search_table"><!-- search_table start -->
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
</section><!-- search_table end -->
</section>

<!------------------------------------------------------------------------------
    Billing Group Selection - Form ID(billPreferForm)
------------------------------------------------------------------------------->
<section id="sctBillSel" class="blind">

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
</section>
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<!-- <tr>
    <th scope="row">Remark</th>
    <td><textarea id="billRem" name="billRem" cols="20" rows="5" readonly></textarea></td>
</tr> -->
</tbody>
</table><!-- table end -->
<!-- Existing Type end -->

</section><!-- search_table end -->

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

<ul class="center_btns mt20">
    <li><p class="btn_blue2"><a id="btnPreBookingSave" onClick="javascript:fn_doSavePreBookingOrder();" href="#">Save</a></p></li>
</ul>

</section>
<!------------------------------------------------------------------------------
    Pre-Order Regist Content END
------------------------------------------------------------------------------->
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
